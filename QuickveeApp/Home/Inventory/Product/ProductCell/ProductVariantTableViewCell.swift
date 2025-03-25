//
//  ProductVariantTableViewCell.swift
//
//
//  Created by Jamaluddin Syed on 10/18/23.
//

import UIKit
import MaterialComponents

class ProductVariantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var price: MDCOutlinedTextField!
    @IBOutlet weak var comparePrice: MDCOutlinedTextField!
    @IBOutlet weak var costPerItem: MDCOutlinedTextField!
    @IBOutlet weak var margin: MDCOutlinedTextField!
    @IBOutlet weak var profit: MDCOutlinedTextField!
    @IBOutlet weak var qty: MDCOutlinedTextField!
    @IBOutlet weak var customCode: MDCOutlinedTextField!
    @IBOutlet weak var upcCode: MDCOutlinedTextField!
    @IBOutlet weak var reorderQty: MDCOutlinedTextField!
    @IBOutlet weak var reorderLevel: MDCOutlinedTextField!
    
    @IBOutlet weak var trackQty: UIButton!
    @IBOutlet weak var checkID: UIButton!
    @IBOutlet weak var selling: UIButton!
    @IBOutlet weak var disable: UIButton!
    
    @IBOutlet weak var instantBtn: UIButton!
        
    @IBOutlet weak var salesHistoryBtn: UIButton!
    @IBOutlet weak var costItemInner: UIView!
    
    @IBOutlet weak var salesHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyInner: UIView!
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var foodstampable: UIButton!
    @IBOutlet weak var plusMain: UIView!

    @IBOutlet weak var lineView: UIView!
    
}
