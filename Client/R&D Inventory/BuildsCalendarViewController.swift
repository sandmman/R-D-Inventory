//
//  BuildsCalendarViewController.swift
//  
//
//  Created by Aaron Liberatore on 1/7/17.
//
//

import UIKit
import FSCalendar

public protocol CalendarDataSourceDelegate {
    func reloadCalendar()
    func reloadTableView()
}

class BuildsCalendarViewController: UIViewController {
    
    var project: Project!
    
    var viewModel: BuildsViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCalendar()
        
        viewModel = BuildsViewModel(project: project)
        
        viewModel.delegate = self
        
        viewModel.calendarDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startSync()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToBuildCalendar(sender: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let _ = segue.identifier, let destination = segue.destination as? CreateBuildViewController else {
            return
        }

        destination.viewModel = viewModel.getNextViewModel(nil)

    }
}

extension BuildsCalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    internal func initializeCalendar() {
        
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        
        calendar.select(Date())
        
        calendar.scrollDirection = .vertical
        
        calendar.appearance.headerTitleFont = UIFont(name: "Arial", size: 10)
        
        calendar.appearance.titleFont = UIFont(name: "Arial", size: 8)
    }
    
    public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.buildsDataSource.count(date: date.display)
    }
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        viewModel.selected(date: date)
    }
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        guard let day = date.day, date.month == Date().month else {
            return UIColor.lightGray
        }
        
        return day == 1 || day == 7 ? UIColor.lightGray : UIColor.darkGray
    }
}

extension BuildsCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(date: calendar.selectedDate)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            viewModel.delete(from: tableView, at: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let buildArr = viewModel.buildsDataSource.dict[calendar.selectedDate.display] else {
            return UITableViewCell()
        }
        
        return buildArr[indexPath.row].cellForTableView(tableView: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell(at: indexPath)
        performSegue(withIdentifier: Constants.Segues.BuildDetail, sender: nil)
    }
}

extension BuildsCalendarViewController: TabBarViewController {
    
    public func didChangeProject(project: Project) {
        self.project = project

        guard let vm = viewModel else {
            return
        }
        vm.project = project
    }

}

extension BuildsCalendarViewController: FirebaseTableViewDelegate, CalendarDataSourceDelegate {
    
    public func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func reloadCalendar() {
        DispatchQueue.main.async {
            self.calendar.reloadData()
        }
    }
}
