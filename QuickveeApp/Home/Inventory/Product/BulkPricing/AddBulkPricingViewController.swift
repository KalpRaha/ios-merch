//
//  AddBulkPricingViewController.swift

//
//  Created by Jamaluddin Syed on 2/9/24.
//

import UIKit

class AddBulkPricingViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bulkPriceLbl: UILabel!
    @IBOutlet weak var clickOnLbl: UILabel!
    
    @IBOutlet weak var addBulkBtn: UIButton!
    @IBOutlet weak var bulkPricingBtn: UIButton!
    
    @IBOutlet weak var bulkPriceAddHeight: NSLayoutConstraint!
    
    var arrofBulk = [BulkPricingModel]()
    var varientArr = [ProductById]()
    var addUnselect = [String]()
   
    var prod_id = ""
    var prod_title = ""

    var b_id = ""
    var bulk_name = ""
    var bulk_price = ""
    var bulk_percent = ""
    var qty = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        topView.addBottomShadow()
        bulkPricingBtn.layer.cornerRadius = 10
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if addUnselect.count == 0 {
            bulkPricingBtn.isHidden = true
            bulkPriceAddHeight.constant = 0
        }
        else {
            
            bulkPricingBtn.isHidden = false
            bulkPriceAddHeight.constant = 45
        }
        
        if arrofBulk.isEmpty {
            bulkPriceLbl.isHidden = false
            clickOnLbl.isHidden = false
            addBulkBtn.isHidden = false
            bulkPricingBtn.isHidden = true
            
        }
        else {
            
            bulkPriceLbl.isHidden = true
            clickOnLbl.isHidden = true
            addBulkBtn.isHidden = true
            tableview.isHidden = false
            bulkPricingBtn.isHidden = false
        }
        
    }

    @IBAction func addBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PriceBulkViewController") as! PriceBulkViewController
        if varientArr.count == 0 {
            vc.price_prodTitle = prod_title
        
        }else {
            vc.pricevarientArr = varientArr
        }
        vc.priceP_id = prod_id
        vc.price_unselect  = addUnselect
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! BulkEditViewController
        if varientArr.count == 0 {
            vc.edit_p_Title = prod_title
        }else {
            vc.editvarient = varientArr
        }
        vc.bulk_id = b_id
        vc.product_id = prod_id
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {            
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
}

extension AddBulkPricingViewController : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrofBulk.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "BulkDetailCell", for: indexPath) as! BulkDetailCell
        cell.selectionStyle = .none
        cell.offerLbl.text = arrofBulk[indexPath.row].bulk_price_title
        
      
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = tableview.cellForRow(at: indexPath) as! BulkDetailCell
        b_id = arrofBulk[indexPath.row].id
        bulk_name = arrofBulk[indexPath.row].bulk_price_title
        bulk_price = arrofBulk[indexPath.row].bulk_price
        bulk_percent = arrofBulk[indexPath.row].is_percentage
        qty = arrofBulk[indexPath.row].bulk_qty
        performSegue(withIdentifier: "toEditBulk", sender: nil)
        
    }
   
}


struct BulkPricingModel {
    var id: String
    var merchant_id: String
    var product_id: String
    var bulk_price: String
    var bulk_qty: String
    var bulk_price_title: String
    var is_percentage: String
}
