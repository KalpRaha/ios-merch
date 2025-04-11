//
//  RefundProductCell.swift
//  
//
//  Created by Pallavi on 18/09/24.
//

import UIKit

class RefundProductCell: UITableViewCell {

    @IBOutlet weak var RefundProductLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var qtylbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    @IBOutlet weak var bogoDiscountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
