//
//  BuildsCalendarViewController.swift
//  
//
//  Created by Aaron Liberatore on 1/7/17.
//
//

import UIKit
import FSCalendar

class BuildsCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource, TabBarViewController {
    
    var project: Project!
    
    private var selectedDate: String? = nil

    private var builds = [String: [Build]]()
    
    private var listener: ListenerHandler!

    private let gregorian = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

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
        listener.listenForBuilds(for: project, onComplete: didReceiveBuild)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }
    
    // MARK: Calendar

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return builds[date.display]?.count ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let day = date.day else {
            return UIColor.darkGray
        }

        return day == 1 || day == 7 ? UIColor.lightGray : UIColor.darkGray
    }
    
    // MARK: Tableview
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let builds = builds[calendar.selectedDate.display] else {
            return 0
        }
        return builds.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.Builds, for: indexPath)
        
        if let buildArr = builds[calendar.selectedDate.display] {
            
            cell.textLabel?.text = buildArr[indexPath.row].title
            cell.detailTextLabel?.text = buildArr[indexPath.row].type.rawValue

        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
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
            
            reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateBuildViewController {
            destination.project = project
            destination.generic = true
        }
    }
    
    // MARK: Private Functions
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        builds = [:]
        
        reloadData()
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
        
        reloadData()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            if self.tableView != nil && self.calendar != nil {
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
        }
    }
}
