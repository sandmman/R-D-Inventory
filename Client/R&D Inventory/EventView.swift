//
//  EventView.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/7/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class EventView: UIView {

    var label: UILabel = UILabel()
    var myNames = ["dipen","laxu","anis","aakash","santosh","raaa","ggdds","house"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        label.frame = CGRect(x: 50, y: 10, width: 200, height: 100)
        label.backgroundColor=UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "test label"
        label.isHidden=true
        self.addSubview(label)
        
        let btn: UIButton = UIButton()
        btn.frame = CGRect(x: 50, y: 120, width: 200, height: 100)
        btn.backgroundColor=UIColor.red
        btn.setTitle("Test button", for: UIControlState.normal)
        self.addSubview(btn)
        
        let txtField : UITextField = UITextField()
        txtField.frame = CGRect(x: 50, y: 10, width: 200, height: 100)
        txtField.backgroundColor = UIColor.gray
        self.addSubview(txtField)
    }
}
