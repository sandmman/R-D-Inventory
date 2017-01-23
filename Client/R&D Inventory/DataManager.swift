//
//  DataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

public protocol DataManager {
    
    static func save(project: Project)
    
    static func save(assembly: Assembly, to project: Project)
    
    static func save(build: Build, to project: Project)
    
    static func save(part: Part, to project: Project)

    static func save(build: Build, to assembly: Assembly, within project: Project)
    
    static func save(part: Part, to assembly: Assembly, within project: Project)
    
    static func add(build: Build, to assembly: Assembly)
    
    static func add(part: Part, to assembly: Assembly)
    
    


    static func get(assembly: String, onComplete: @escaping (Assembly) -> ())
    
    static func get(build: String, onComplete: @escaping (Build) -> ())
    
    static func get(part: String, onComplete: @escaping (Part) -> ())
    
    static func get(project: String, onComplete: @escaping (Project) -> ())
    
    static func update(assembly: Assembly)
    
    static func update(build: Build)
    
    static func update(part: Part)
    
    static func update(project: Project)
    
    static func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ())
    
    static func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ())
    
    static func getProjects(onComplete: @escaping ([Project]) -> ())
}
