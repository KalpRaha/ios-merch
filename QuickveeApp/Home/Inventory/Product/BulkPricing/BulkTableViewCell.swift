//
//  BulkTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 2/12/24.
//

import UIKit

class BulkTableViewCell: UITableViewCell {


    @IBOutlet weak var variLable: UILabel!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(named: "borderBulk")?.cgColor
        bgView.layer.cornerRadius = 5
    }
}
