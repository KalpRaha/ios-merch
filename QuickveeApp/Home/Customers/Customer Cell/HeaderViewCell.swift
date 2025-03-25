//
//  HeaderViewCell.swift
//  democustInfo
//
//  Created by Pallavi on 06/11/24.
//

import Foundation
import UIKit

class HeaderViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var paidOrderBtn: UIButton!
    @IBOutlet weak var refundOrderBtn: UIButton!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderDetailLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var bonusPointLbl: UILabel!
    
   
    @IBOutlet weak var orderDetailViewHeight: NSLayoutConstraint!
    
    override init(reuseIdentifier: String?) {
           super.init(reuseIdentifier: reuseIdentifier)
           setupView()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupView()
       }

       private func setupView() {
           self.contentView.backgroundColor = .systemBlue

          
       }
    
    
    
    
}
