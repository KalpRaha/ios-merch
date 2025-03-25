//
//  RefundCell.swift
//  
//
//  Created by Pallavi on 27/03/24.
//

import UIKit

class RefundCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titlelblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = "Store credit"
        titleLbl.text = "0.00"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        
    }

}
