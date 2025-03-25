//
//  RefundedItemCell.swift
//  
//
//  Created by Pallavi on 26/03/24.
//

import UIKit

class RefundedItemCell: UITableViewCell {

  
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
