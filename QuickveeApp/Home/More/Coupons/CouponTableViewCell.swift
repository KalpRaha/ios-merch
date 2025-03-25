//
//  CouponTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 10/03/23.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var codeName: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var discountValue: UILabel!
    
    @IBOutlet weak var validity: UILabel!
    
    @IBOutlet weak var minOrder: UILabel!
    
    @IBOutlet weak var maxOrder: UILabel!
    
    @IBOutlet weak var validityDate: UILabel!
    
    @IBOutlet weak var minOrderAmt: UILabel!
    
    @IBOutlet weak var maxOrderAmt: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var online: UILabel!
    
    @IBOutlet weak var onlineSwitch: UISwitch!
    
    
    @IBOutlet weak var maxDiscountBottom: NSLayoutConstraint!
}
