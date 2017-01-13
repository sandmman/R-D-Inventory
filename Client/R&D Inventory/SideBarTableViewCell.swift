//
//  SideBarTableViewCell.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/8/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class SideBarTableViewCell: UITableViewCell {
    
    @IBOutlet var backgrounImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*let shadowPath = UIBezierPath(rect: bounds)

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.25
        layer.shadowPath = shadowPath.cgPath*/
    }

}
