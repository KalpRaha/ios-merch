//
//  TaxTableCell.swift
//  
//
//  Created by Pallavi on 19/09/24.
//

import UIKit

class TaxTableCell: UITableViewCell {

    @IBOutlet weak var taxName: UILabel!
    
    @IBOutlet weak var taxPercent: UILabel!
    
    @IBOutlet weak var productTotalPrice: UILabel!
    
    @IBOutlet weak var taxvalue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
