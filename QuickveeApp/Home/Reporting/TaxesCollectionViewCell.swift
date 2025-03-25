//
//  TaxesCollectionViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 20/01/23.
//

import UIKit

class TaxesCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var tax_name_title: UILabel!
    @IBOutlet weak var tax_rate_title: UILabel!
    @IBOutlet weak var tax_coll_title: UILabel!
    @IBOutlet weak var tax_ref_title: UILabel!
    
    @IBOutlet weak var tax_name: UILabel!
    @IBOutlet weak var tax_rate: UILabel!
    @IBOutlet weak var collected_tax: UILabel!
    @IBOutlet weak var refunded_tax: UILabel!
    
    

    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondvIEW: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var fourView: UIView!
}
