//
//  CustomerTableViewCell.swift
//
//
//  Created by Jamaluddin Syed on 01/08/24.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var customName: UILabel!
    @IBOutlet weak var customNumber: UILabel!
    
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    
    @IBOutlet weak var disabledBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.disabledBtn.layer.borderWidth = 1
        self.disabledBtn.layer.borderColor = UIColor(hexString: "#F55353").cgColor
        self.disabledBtn.layer.cornerRadius = 5
    }
    
    
}
