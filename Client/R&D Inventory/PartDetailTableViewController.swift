//
//  PartDetailTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/11/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class PartDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var partNameLabel: UILabel!
    @IBOutlet weak var partIDLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var numOnOrderLabel: UILabel!
    @IBOutlet weak var numInStockLabel: UILabel!
    @IBOutlet weak var orderLeadTimeLabel: UILabel!
    @IBOutlet weak var numPartsNeededLabel: UILabel!
    
    public var part: Part? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let p = part else {
            return
        }
        
        partNameLabel.text = p.name
        partIDLabel.text = String(p.key)
        manufacturerLabel.text = p.manufacturer
        numOnOrderLabel.text = String(p.countOnOrder)
        numInStockLabel.text = String(p.countInStock)
        orderLeadTimeLabel.text = p.leadTime.description
        numPartsNeededLabel.text = String(p.countInAssembly)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
