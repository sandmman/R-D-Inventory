//
//  BuildFormViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/13/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class BuildFormViewModel: FormViewModel<Build> {
    
    public var assembly: Assembly? = nil {
        didSet {
            guard let assem = assembly else {
                return
            }
            FirebaseDataManager.getParts(for: assem, onComplete: receivedPart)
        }
    }
    
    public var assemblies = [Assembly]()
    
    public var parts = [Part]()

    public var didReceivePart: (((Part, Int)) -> ())? = nil

    public var didReceiveAssembly: (() -> ())? = nil
    
    public var didChangeAssembly: ((PushRow<Assembly>) -> ())!

    // MARK: - Initializers

    public init(project: Project, assembly: Assembly?, assemblies: [Assembly], parts: [Part], build: Build? = nil, callback: (()->())?) {
        
        self.assembly = assembly
        
        self.assemblies = assemblies

        self.parts = parts
        
        super.init(project: project, obj: build)

        getParts(for: build)
        
        getAssemblies()
    }
    
    public convenience init(project: Project, build: Build, callback: @escaping ()->()) {
        
        self.init(project: project, assembly: nil, assemblies: [], parts: [], build: build, callback: callback)
    }
    
    public convenience init(project: Project, callback: @escaping ()->()) {
        
        self.init(project: project, assembly: nil, assemblies: [], parts: [], build: nil, callback: callback)
    }
    
    public convenience init(project: Project, assembly: Assembly?) {
        
        self.init(project: project, assembly: assembly, assemblies: [], parts: [], build: nil, callback: nil)
    }
    
    public convenience init(project: Project, build: Build) {
        
        self.init(project: project, assembly: nil, assemblies: [], parts: [], build: build, callback: nil)
    }
    
    public convenience init(project: Project, assembly: Assembly, build: Build) {
        
        self.init(project: project, assembly: assembly, assemblies: [], parts: [], build: build, callback: nil)
    }
    
    // MARK: - Form Overrides
    
    override func setDefaultValue(for label: String) -> Any {
        
        switch label {
        case Constants.BuildFields.Title            : return isEditing ? obj!.title             : ""
        case Constants.BuildFields.Quantity         : return isEditing ? String(obj!.quantity)  : "0"
        case Constants.BuildFields.Location         : return isEditing ? ""                     : ""
        case Constants.BuildFields.Date             : return isEditing ? obj!.scheduledDate     : Date()
        case Constants.BuildFields.BType            : return isEditing ? obj!.type == .Standard ? false : true : false
        case Constants.BuildFields.Notifications    : return false
        case Constants.BuildFields.AssemblyID       :
            if isEditing {
                return ""
            } else {
                return assemblies.count > 0 ? assemblies[0] : ""
            }
        default                                     : return ""
        }
    }
    
    override func setDefaultTitle(for label: String) -> String {
        
        switch label {
        case Constants.BuildFields.Title        : return "Title"
        case Constants.BuildFields.Quantity     : return "Quantity"
        case Constants.BuildFields.Location     : return "Location"
        case Constants.BuildFields.Date         : return "Scheduled Date"
        case Constants.BuildFields.BType        : return "Custom Build?"
        case Constants.BuildFields.Notifications: return "Receive Notification?"
        case Constants.BuildFields.AssemblyID   : return "Assembly"
        default                                 : return ""
        }
    }
    
    public override func instantiateForm() -> Form {
        
        let form = Form()
        
        let partsNeededTag = "Parts Needed"

        form +++ Section("Please Choose Assembly for Build") {
                    $0.hidden = Condition.function([""], { form in return self.isEditing })
                }
                <<< PushRow<Assembly>(Constants.BuildFields.AssemblyID) {
                    $0.title = setDefaultTitle(for: Constants.BuildFields.AssemblyID)
                    $0.options = assemblies
                    $0.value = setDefaultValue(for: Constants.BuildFields.AssemblyID) as? Assembly ?? nil
                    $0.selectorTitle = "Choose an Assembly!"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                    $0.displayValueFor = { return $0?.name }
                }.onChange(didChangeAssembly)
            +++ Section("General")
                <<< textRow(for: Constants.BuildFields.Title)
                <<< intRow(for: Constants.BuildFields.Quantity)
                <<< textRow(for: Constants.BuildFields.Location)
                <<< dateInLineRow(for: Constants.BuildFields.Date)
                <<< switchRow(for: Constants.BuildFields.Notifications)
                <<< switchRow(for: Constants.BuildFields.BType)
        
        let partsSection = Section(partsNeededTag) { $0.hidden = "$type == false" }
        
        partsSection.append(contentsOf: parts.map { stepperRow(part: $0) })
        
        form +++ partsSection
        
        return form
    }

    public override func completed(form: Form) -> Build? {

        return isEditing ? updateBuild(from: form) : saveBuild(from: form)
    }
    
    // MARK: - Save

    private func saveBuild(from form: Form) -> Build? {
        
        guard let build = ObjectMapper.createBuild(from: form, parts: parts) else {
            return nil
        }
        
        guard let assembly = assembly, let project = project else {
            return nil
        }

        FirebaseDataManager.save(build: build, to: assembly, within: project)

        return build
    }
    
    private func updateBuild(from form: Form) -> Build? {
        
        guard let oldBuild = obj else {
            return nil
        }
        
        guard let newBuild = ObjectMapper.update(build: oldBuild, from: form, parts: parts) else {
            return nil
        }

        FirebaseDataManager.update(build: newBuild)

        return newBuild
    }

    // MARK: - Callbacks

    private func receivedPart(part: Part) {
        
        self.parts.append(part)

        guard let b = obj, let value = b.partsNeeded[part.key] else {
            didReceivePart?((part, 0))
            return
        }

        didReceivePart?((part, value))
    }
    
    private func receivedAssembly(assembly: Assembly) {
        
        self.assemblies.append(assembly)
        
        didReceiveAssembly?()
    }

    private func getParts(for build: Build?) {
        guard let b = build else {
            return
        }

        for (key, _) in b.partsNeeded {
            FirebaseDataManager.get(part: key, onComplete: receivedPart)
        }
    }
    
    private func getAssemblies() {
        guard assembly == nil, let proj = project else {
            return
        }
        
        FirebaseDataManager.getAssemblies(for: proj, onComplete: receivedAssembly)
    }
}
