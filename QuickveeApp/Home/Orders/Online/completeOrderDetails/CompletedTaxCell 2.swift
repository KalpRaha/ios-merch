//
//  CompletedTaxCell.swift
//  
//
//  Created by Pallavi on 25/11/24.
//

import UIKit

class CompletedTaxCell: UITableViewCell {
    
    @IBOutlet weak var taxName: UILabel!
    @IBOutlet weak var taxPercent: UILabel!
    @IBOutlet weak var productTotalPrice: UILabel!
    @IBOutlet weak var taxvalue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
