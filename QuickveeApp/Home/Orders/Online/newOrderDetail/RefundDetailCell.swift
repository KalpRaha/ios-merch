//
//  RefundDetailCell.swift
//  
//
//  Created by Pallavi on 20/09/24.
//

import UIKit

class RefundDetailCell: UITableViewCell {

    
    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var taxRefundedValueLbl: UILabel!
    @IBOutlet weak var TotalRefundedValue: UILabel!
    @IBOutlet weak var tipNcaRefLbl: UILabel!
    @IBOutlet weak var AuthCodeLbl: UILabel!
   
    @IBOutlet weak var authcodeTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var authCodebottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
