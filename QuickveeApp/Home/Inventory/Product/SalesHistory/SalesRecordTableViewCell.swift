//
//  SalesRecordTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 1/5/24.
//

import UIKit

class SalesRecordTableViewCell: UITableViewCell {

   
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var salesId: UILabel!
    @IBOutlet weak var salesQty: UILabel!
    @IBOutlet weak var salesPrice: UILabel!
    @IBOutlet weak var salesQtyValue: UILabel!
    @IBOutlet weak var salesPriceValue: UILabel!
    @IBOutlet weak var totalCostLbl: UILabel!
    @IBOutlet weak var costValue: UILabel!
    
    
    @IBOutlet weak var recordBorderView: UIView!
    
    @IBOutlet weak var costView: UIView!
    
    

}
