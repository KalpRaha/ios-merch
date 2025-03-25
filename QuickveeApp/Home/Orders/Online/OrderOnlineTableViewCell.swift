//
//  OrderOnlineTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 06/06/23.
//

import UIKit

class OrderOnlineTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderDateTime: UILabel!
    
    @IBOutlet weak var refundPriceLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var newOrderLbl: UILabel!
    @IBOutlet weak var existCustLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var mobNumber: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderIdValue: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusPrice: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewTop: NSLayoutConstraint!
  
    @IBOutlet weak var ststusViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var statusTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newOrderLeadingConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var orderNumberValue: UILabel!
    
    @IBOutlet weak var statusViewBtn: UIButton!
   
    @IBOutlet weak var FirstDotView: UIView!
    
    @IBOutlet weak var secondDotView: UIView!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
        
    
    func setUpRing(button: UIButton, color: UIColor) {
        
        let circleLayer = CAShapeLayer()
        circleLayer.path =
        UIBezierPath(ovalIn: CGRect(x: button.bounds.minX - 2,
                                    y: button.bounds.minY - 2,
                                    width: 50, height: 50)).cgPath
        button.layer.addSublayer(circleLayer)

        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
    }

    }

extension UIView {
    
    func animate() {
        let layer = CAGradientLayer()
        let startLocations = [0, 0]
        let endLocations = [1, 6]
        
        layer.colors = [UIColor.red.cgColor, UIColor.white.cgColor]
        layer.frame = self.frame
        layer.locations = startLocations as [NSNumber]
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(layer)
        
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = 2.0
        layer.add(anim, forKey: "loc")
        layer.locations = endLocations as [NSNumber]
    }
}
