//
//  LoyaltyTableViewCell.swift
//  
//
//  Created by Pallavi on 11/06/24.
//

import UIKit

class LoyaltyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var promotionName: UILabel!
    
    @IBOutlet weak var promotionValue: UILabel!
    
    @IBOutlet weak var validDates: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var switchDisable: UISwitch!
    
    @IBOutlet weak var promoView: UIView!
    
}
