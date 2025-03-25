//
//  OrderTypesTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 17/01/23.
//

import UIKit

class OrderTypesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var orderArray = [String:Any]()
    
    func configure(with order: [String:Any]) {
        
        orderArray = order
        collectionView.reloadData()
    }
    
    func roundOf(item: String) -> Double {
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = Double(round(100 * doub) / 100)
        print(div)
        return div
    }
    
    func getOrderType(order: String) -> String {
        
        if order == "delivery" {
            return "Delivery"
        }
        else{
            return "Pickup"
        }
        
    }
    
    func textColor(text : String) -> UIColor {
        
        return UIColor(red: 245.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        
    }
    
}


extension OrderTypesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OrderTypesInfoCollectionViewCell
        
        let order = Order(order_method: "\(orderArray["order_method"] ?? "0")",
                          total_count: "\(orderArray["total_count"] ?? "0")",
                          amount_with_tip: "\(orderArray["amount_with_tip"] ?? "0")",
                          amt_without_tip: "\(orderArray["amt_without_tip"] ?? "0")",
                          tip: "\(orderArray["tip"] ?? "0")")
        
    
        cell.amt_without_title.text = "Total without Tips"
        cell.tip_title.text = "Tip"
        cell.am_with_tip_title.text = "Total with Tips"
        
        cell.order_Type_Label.text = "\(getOrderType(order: order.order_method)) - "
        let color =  UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        cell.order_Type_Label.textColor = color
        cell.grayLabel.text = "No. of Transactions:"
        cell.count_label.text = order.total_count
        cell.count_label.textColor = color
        
        let amt_without_tip = roundOf(item: order.amt_without_tip)
        let final_without_tip = String(format:"%.02f", amt_without_tip)
        cell.amt_without_tip.text = "\u{0024}\(String(final_without_tip))"
        
        let tip = roundOf(item: order.tip)
        let final_tip = String(format:"%.02f", tip)
        cell.tip.text = "\u{0024}\(String(final_tip))"
        
        let amt_with_tip = roundOf(item: order.amount_with_tip)
        let final_amt_tip = String(format:"%.02f", amt_with_tip)
        cell.amt_with_tip.text = "\u{0024}\(String(final_amt_tip))"
        
        print(cell.contentView.bounds.size.height)
                
        return cell


    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
