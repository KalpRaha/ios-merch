//
//  OnlineOrderCell.swift
//  
//
//  Created by Pallavi on 18/09/24.
//

import UIKit

class OnlineOrderCell: UITableViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var qtyLblb: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
   
    @IBOutlet weak var bogoDiscoutLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
