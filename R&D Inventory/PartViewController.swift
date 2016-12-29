//
//  PartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class PartViewController: UIViewController {

    @IBOutlet weak var partNameLabel: UILabel!
    @IBOutlet weak var partIDLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var numOnOrderLabel: UILabel!
    @IBOutlet weak var numInStockLabel: UILabel!
    @IBOutlet weak var orderLeadTimeLabel: UILabel!
    @IBOutlet weak var numPartsNeededLabel: UILabel!
    
    var part: Part? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let p = part else {
            return
        }
        
        partNameLabel.text = p.name
        partIDLabel.text = String(p.uid)
        manufacturerLabel.text = p.manufacturer
        numOnOrderLabel.text = String(p.countOnOrder)
        numInStockLabel.text = String(p.countInStock)
        orderLeadTimeLabel.text = p.leadTime.description
        numPartsNeededLabel.text = String(p.countSubParts)
    }

}
