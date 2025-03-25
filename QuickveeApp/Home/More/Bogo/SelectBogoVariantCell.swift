//
//  SelectBogoVariantCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 31/01/25.
//

import UIKit

class SelectBogoVariantCell: UITableViewCell {

    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var upcLabel: UILabel!
    @IBOutlet weak var varientLbl: UILabel!
    
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    
    @IBOutlet weak var upcWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        titleLbl.minimumScaleFactor = 0.5
        
        priceLbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        priceLbl.minimumScaleFactor = 0.5
        
        upcLabel.adjustsFontSizeToFitWidth = true  // Enable text scaling
        upcLabel.minimumScaleFactor = 0.5
        
        varientLbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        varientLbl.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
