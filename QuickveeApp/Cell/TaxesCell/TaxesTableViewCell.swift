//
//  TaxesTableViewCell.swift
//  
//
//  Created by Jamaluddin Syed on 20/01/23.
//

import UIKit

class TaxesTableViewCell: UITableViewCell {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var borderView: UIView!
    
    var taxStats = ["Tax or Fee", "Tax Rate or Fee", "Tax or Fee Refunded", "Tax or Fee Collected"]
    
    var tax = [String:Any]()
    
    
    public func configure(with tax: [String:Any]) {
        self.tax = tax
        collectionView.reloadData()
    }
    
}

extension TaxesTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaxesCollectionViewCell
        
        let taxes = Taxes(collected_tax: "\(tax["collected_tax"] ?? "0.0")",
                          refunded_tax: "\(tax["refunded_tax"] ?? "0.0")",
                          tax_name: "\(tax["tax_name"] ?? "")",
                          tax_rate: "\(tax["tax_rate"] ?? "0.0")")
        
        print(taxes)
        
        
        
        cell.tax_name_title.text = "Tax or Fee"
        cell.tax_rate_title.text = "Tax Rate or Fee"
        cell.tax_ref_title.text = "Tax or Fee Refunded"
        cell.tax_coll_title.text = "Tax or Fee Collected"
        
        cell.tax_name.text = taxes.tax_name
        if taxes.tax_rate == "N/A" {
            cell.tax_rate.text = "Deleted"
            cell.tax_rate.textColor = UIColor.red
        }
        else {
            cell.tax_rate.text = "\(taxes.tax_rate)\u{0025}"
            cell.tax_rate.textColor = .black
        }
        cell.refunded_tax.text = "\u{0024}\(taxes.refunded_tax)"
        cell.collected_tax.text = "\u{0024}\(taxes.collected_tax)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
