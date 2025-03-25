//
//  GiftCardTableViewCell.swift
//  
//
//  Created by Pallavi on 31/07/24.
//

import UIKit

class GiftCardTableViewCell: UITableViewCell {

    @IBOutlet weak var giftImage: UIImageView!
   
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var amt: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
