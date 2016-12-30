//
//  AssemblyDetailViewController
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var partsTableView: UITableView!

    var assembly: Assembly? = nil
    
    var parts: [Part] = []

    var selectedPart: Part? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        partsTableView.delegate = self
        partsTableView.dataSource = self
        
        guard let a = assembly else {
            return
        }
        
        self.title = a.name
        
        DataService.sharedInstance.getParts(for: a) {
            part in

            self.parts.append(part)
            self.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = partsTableView.indexPathForSelectedRow {
            self.partsTableView.deselectRow(at: row, animated: false)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == Constants.Segues.PartDetail) {
            
            let viewController = segue.destination as! PartViewController
            
            viewController.part = selectedPart
            
        }
    }

    // Table view
    func reloadData() {
        DispatchQueue.main.async {
            self.partsTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.partsTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.part)! as UITableViewCell
        
        cell.textLabel?.text = parts[indexPath.row].name
        cell.detailTextLabel?.text = parts[indexPath.row].manufacturer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {

        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedPart = parts[indexPath.row]
        
        performSegue(withIdentifier: Constants.Segues.PartDetail, sender: self)
    }

}
