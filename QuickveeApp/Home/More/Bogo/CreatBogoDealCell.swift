//
//  CreatBogoDealCell.swift
//  QuickveeApp
//
//  Created by Pallavi on 04/02/25.
//

import UIKit

class CreatBogoDealCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var varientlbl: UILabel!
    @IBOutlet weak var upclbl: UILabel!
   
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        titleLbl.minimumScaleFactor = 0.5
        
        priceLbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        priceLbl.minimumScaleFactor = 0.5
        
        upclbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        upclbl.minimumScaleFactor = 0.5
        
        varientlbl.adjustsFontSizeToFitWidth = true  // Enable text scaling
        varientlbl.minimumScaleFactor = 0.5
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
