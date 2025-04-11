//
//  CompletedCartOnlineCell.swift

//
//  Created by Pallavi on 25/11/24.
//

import UIKit

class CompletedCartOnlineCell: UITableViewCell {

   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var bogoDiscountLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
