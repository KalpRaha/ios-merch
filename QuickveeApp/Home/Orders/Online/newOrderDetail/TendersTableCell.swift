//
//  TendersTableCell.swift
//  
//
//  Created by Pallavi on 20/09/24.
//

import UIKit

class TendersTableCell: UITableViewCell {

    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var cardValueLbl: UILabel!
    @IBOutlet weak var authCodeLb: UILabel!
    @IBOutlet weak var AIdLbl: UILabel!
    
    @IBOutlet weak var authCodeTopContrain: NSLayoutConstraint!
    
    @IBOutlet weak var authCodeBottomConstrain: NSLayoutConstraint!
   
    
    @IBOutlet weak var AidBottomeConstain: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
