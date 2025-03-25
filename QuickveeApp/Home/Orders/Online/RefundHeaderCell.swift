//
//  RefundHeaderCell.swift
//  
//
//  Created by Pallavi on 27/03/24.
//

import UIKit

class RefundHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var refunfLbl: UILabel!
    
    @IBOutlet weak var refDateAndTime: UILabel!
   
    override func awakeFromNib(){
        super.awakeFromNib()
      //  refunfLbl.text = "Refund"
    }
    
}
