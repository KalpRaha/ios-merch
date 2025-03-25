//
//  CartTableCell.swift
//  
//
//  Created by Pallavi on 21/03/24.
//

import UIKit

class CartTableCell: UITableViewCell {

    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var refQty: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
