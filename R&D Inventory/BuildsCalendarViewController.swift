//
//  BuildsCalendarViewController.swift
//  
//
//  Created by Aaron Liberatore on 1/7/17.
//
//

import UIKit
import FSCalendar

class BuildsCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, TabBarViewController {
    
    var project: Project!
    
    private var builds = [String: [Build]]()
    
    private var listener: ListenerHandler!

    private let gregorian = Calendar(identifier: .gregorian)
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "gmt")
        dateFormatter.dateFormat = "ccc"

        return dateFormatter
    }()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    private weak var eventView: EventView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]

        self.calendar.select(Date())

        self.calendar.scrollDirection = .vertical
        
        self.calendar.appearance.headerTitleFont = UIFont(name: "Arial", size: 10)
        
        self.calendar.appearance.titleFont = UIFont(name: "Arial", size: 8)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        listener = ListenerHandler()
        //listener.listenForBuilds(for: project, onComplete: didReceiveBuild)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }

    public func didChangeProject(project: Project) {
        self.project = project
        builds = [:]
    }
    
    private func didReceiveBuild(build: Build) {
        if var arr = builds[build.displayDate] {
            if let index = arr.index(of: build) {
                arr[index] = build
            } else {
                arr.append(build)
            }
            builds[build.displayDate] = arr

        } else {
            builds[build.displayDate] = [build]
        }
        
        print(builds)
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return builds[formatter.string(from: date)]?.count ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        calendar.scope = .week
        
        let eventView = EventView()
        view.addSubview(eventView)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let day = formatter.string(from: date)
        return day == "Sun" || day == "Sat" ? UIColor.lightGray : UIColor.darkGray
    }
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {

    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToBuildCalendar(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateBuildViewController {
            
            guard let build = sourceViewController.newBuild else {
                return
            }
            
            if builds[build.displayDate] == nil {
                builds[build.displayDate] = [build]
            } else {
                 builds[build.displayDate]?.append(build)
            }
            
            calendar.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateBuildViewController {
            destination.project = project
            destination.generic = true
        }
    }

}
