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
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
