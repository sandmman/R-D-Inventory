//
//  PartTableViewCell.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

protocol PartTableViewCellDelegate {
    func didChangeQuantityInStock(at indexPath: IndexPath)
}

class PartTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var nameTextLabel: UILabel!

    @IBOutlet var manufacturerTextLabel: UILabel!

    @IBOutlet var textField: UITextField!

    public var indexPath: IndexPath?
    
    public var delegate: PartTableViewCellDelegate?

    public var count: Int! {
        didSet {
            textField?.text = nil
            textField?.placeholder = String(count)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField?.delegate = self

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = indexPath, let delegate = delegate {
            guard let str = textField.text, !str.isEmpty else {
                return
            }
            
            count = Int(str)!
            
            delegate.didChangeQuantityInStock(at: indexPath)
        }
    }
}
