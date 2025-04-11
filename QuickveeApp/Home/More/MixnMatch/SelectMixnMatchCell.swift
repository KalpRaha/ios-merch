//
//  SelectMixnMatchCell.swift
//  
//
//  Created by Pallavi on 14/06/24.
//

import UIKit

class SelectMixnMatchCell: UITableViewCell {

    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var upcLabel: UILabel!
    @IBOutlet weak var varientLbl: UILabel!
    
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    
    @IBOutlet weak var upcWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.5
        priceLbl.adjustsFontSizeToFitWidth = true
        priceLbl.minimumScaleFactor = 0.5
        upcLabel.adjustsFontSizeToFitWidth = true
        upcLabel.minimumScaleFactor = 0.5
        varientLbl.adjustsFontSizeToFitWidth = true
        varientLbl.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if self.checkMarkImage.image == UIImage(named: "uncheck inventory") {
//            self.checkMarkImage.image = UIImage(named: "check inventory")
//        }
//        else{
//            self.checkMarkImage.image = UIImage(named: "uncheck inventory")
//        }
    }

}
