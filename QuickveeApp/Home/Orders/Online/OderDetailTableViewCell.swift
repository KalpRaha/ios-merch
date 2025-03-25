//
//  OderDetailTableViewCell.swift
//  
//
//  Created by Pallavi on 27/02/24.
//

import UIKit

class OderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    
    @IBOutlet weak var qtyLbl: UILabel!
   
    @IBOutlet weak var totalpriceLbl: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

