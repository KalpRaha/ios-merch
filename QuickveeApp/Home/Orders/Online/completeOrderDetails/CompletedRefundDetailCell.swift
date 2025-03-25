//
//  CompletedRefundDetailCell.swift
//  
//
//  Created by Pallavi on 25/11/24.
//

import UIKit

class CompletedRefundDetailCell: UITableViewCell {

    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var taxRefundedValueLbl: UILabel!
    @IBOutlet weak var taxRefunded: UILabel!
    @IBOutlet weak var tipNcaRefundLbl: UILabel!

    @IBOutlet weak var AuthCodeLbl: UILabel!
   
    @IBOutlet weak var authcodeTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var authCodebottomConstraint: NSLayoutConstraint!
}
