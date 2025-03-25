//
//  GrandTableCell.swift
//  
//
//  Created by Pallavi on 04/03/24.
//

import UIKit

class GrandTableCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var contentValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
