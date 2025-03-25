//
//  ItemSalesTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 17/01/23.
//

import UIKit



class ItemSalesTableViewCell: UITableViewCell {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var salesArray = ["Category", "Refunded", "Price Override", "Gross Sales", "Discounts",
                      "Default Tax", "Other Tax", "Net Sales"]
    
    var items = [String:Any]()
    
    func configure(with items: [String:Any]) {
        self.items = items
        collectionView.reloadData()
    }
    
    
    func calculateGrossSales(item: Items) -> Double {
        
        let gross = Double(item.total_price) ?? 0.00
        return gross
        
    }
    
    
    func calculateNetSales(item: Items) -> Double {
        
        print("item.price \(item.price)")
        print("item.adjust \(item.adjust_price)")
        print("item.saletx \(item.saletx)")
        print("item.othertx \(item.othertx)")
        print("item.discount \(item.discount_amt)")
        
        
        let price = Double(item.price) ?? 0.00
        let discount = Double(item.discount_amt) ?? 0.00
        
        let price_tax = price
        let net = price_tax - discount
        return net
        
    }
    
    func roundOf(item : String) -> Double {
        
        let doub = Double(item) ?? 0.00
        let div = Double(round(100 * doub) / 100)
        print(div)
        return div
    }
}
    

extension ItemSalesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemSalesInfoCollectionViewCell
        
        let items = Items(refund_amount: "\(items["refund_amount"] ?? "0")",
            total_price: "\(items["total_price"]  ?? "0")",
            adjust_price: "\(items["adjust_price"] ?? "0")",
            price: "\(items["price"] ?? "0")",
            refund_amount_without_tax: "\(items["refund_amount_without_tax"] ?? "0")",
            othertx: "\(items["othertx"] ?? "0")",
            categories: "\(items["categories"] ?? "category_name")",
            discount_amt: "\(items["discount_amt"] ?? "0")",
            refund_qty: "\(items["refund_qty"] ?? "0")",
            total_qty: "\(items["total_qty"] ?? "0")" ,
            saletx: "\(items["saletx"] ?? "0")",
            name: "\(items["name"] ?? "")")
        
        cell.category.text = (items.categories)
        
        if items.categories == "category_name" {
            cell.category.text = "N/A"
        }
        
        else {
            cell.category.text = (items.categories)
            
        }
        
        let refunded = roundOf(item: items.refund_amount)
        let final_refunded = String(format:"%.02f", refunded)
        cell.refunded.text = "\u{0024}\(final_refunded)"
        
        let price_overide = roundOf(item: items.adjust_price)
        let final_override = String(format:"%.02f", price_overide)
        cell.price_overide.text = "\u{0024}\(final_override)"
        
        let gross_sales = roundOf(item:String(calculateGrossSales(item: items)))
        let final_gross = String(format:"%.02f", gross_sales)
        cell.productpricevalue.text = "\u{0024}\(final_gross)"
        
        let discounts = roundOf(item:items.discount_amt)
        let final_discounts = String(format:"%.02f", discounts)
        cell.discounts.text = "\u{0024}\(final_discounts)"
        
        let default_tax = roundOf(item:items.saletx)
        let final_def_tax = String(format:"%.02f", default_tax)
        cell.default_tax.text = "\u{0024}\(final_def_tax)"
        
        let other_tax = roundOf(item:items.othertx)
        let final_other_tax = String(format:"%.02f", other_tax)
        cell.other_tax.text = "\u{0024}\(final_other_tax)"
            
        let net_sales = roundOf(item: String(calculateNetSales(item: items)))
        let final_net = String(format:"%.02f", net_sales)
        cell.net_sales.text = "\u{0024}\(final_net)"
        cell.net_sales.textColor = UIColor.systemGreen
        
        cell.name_label.text = items.name + " - "
        cell.grayLabel.text = "No of items sold:"
        cell.numberofItemsLbl.text = items.total_qty
        
        cell.category_ttle.text = "Category"
        cell.refunded_title.text = "Refunded"
        cell.overide_title.text = "Price Override"
        cell.productPrice.text = "Product Price"
        cell.discount_title.text = "Item Discount"
        cell.def_tax_title.text = "Default Tax"
        cell.other_tax_title.text = "Other Tax"
        cell.net_sales_title.text = "Net Sales"
        cell.net_sales.textColor = UIColor.systemGreen


        return cell
    }
    
}
