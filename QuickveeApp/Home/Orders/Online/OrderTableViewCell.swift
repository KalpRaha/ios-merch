//
//  OrderTableViewCell.swift
//  
//
//  Created by Pallavi on 27/02/24.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
