//
//  AddMixnMatchCell.swift
//  
//
//  Created by Pallavi on 18/06/24.
//

import UIKit

class AddMixnMatchCell: UITableViewCell {

   
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var varientlbl: UILabel!
    @IBOutlet weak var upclbl: UILabel!
   
    @IBOutlet weak var closeBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.5
        priceLbl.adjustsFontSizeToFitWidth = true
        priceLbl.minimumScaleFactor = 0.5
        upclbl.adjustsFontSizeToFitWidth = true
        upclbl.minimumScaleFactor = 0.5
        varientlbl.adjustsFontSizeToFitWidth = true
        varientlbl.minimumScaleFactor = 0.5
    }

}
