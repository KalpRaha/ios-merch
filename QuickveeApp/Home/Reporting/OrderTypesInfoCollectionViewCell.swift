//
//  OrderTypesInfoCollectionViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 17/01/23.
//

import UIKit

class OrderTypesInfoCollectionViewCell: UICollectionViewCell {
  
    
    @IBOutlet weak var order_Type_Label: UILabel!
    @IBOutlet weak var count_label: UILabel!
    
    @IBOutlet weak var amt_with_tip: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var amt_without_tip: UILabel!
    
    @IBOutlet weak var grayLabel: UILabel!
    
    @IBOutlet weak var am_with_tip_title: UILabel!
    @IBOutlet weak var tip_title: UILabel!
    @IBOutlet weak var amt_without_title: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var separate: UIView!
    
}
