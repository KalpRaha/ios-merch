//
//  StockSaveTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 12/11/24.
//

import UIKit
import MaterialComponents

class StockSaveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var upperView: UIView!
    
    @IBOutlet weak var stockName: UILabel!
    
    @IBOutlet weak var upcLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var qtyValue: UILabel!
    
    @IBOutlet weak var newQtyView: UIView!
    
    @IBOutlet weak var disValue: UILabel!
    
    @IBOutlet weak var newQtyText: UITextField!
    
    @IBOutlet weak var noteField: MDCOutlinedTextField!
}
