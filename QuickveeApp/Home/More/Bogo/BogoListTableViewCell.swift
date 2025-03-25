//
//  BogoListTableViewCell.swift
//  bogoUi
//
//  Created by Pallavi Patil on 27/01/25.
//

import UIKit

class BogoListTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dealLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var validDate: UILabel!
    @IBOutlet weak var smallbgView: UIView!
    
    
   
    @IBOutlet weak var swichBtn: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
