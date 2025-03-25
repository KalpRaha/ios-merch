//
//  LoyaltyTableCell.swift
//  
//
//  Created by Pallavi on 23/09/24.
//

import UIKit

class LoyaltyTableCell: UITableViewCell {

   
    @IBOutlet weak var awardedValue: UILabel!
    @IBOutlet weak var awardedLbl: UILabel!
    @IBOutlet weak var dateLoyaltyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
