//
//  AddPurchaseQtyViewController.swift
//  
//
//  Created by Pallavi on 21/05/24.
//

import UIKit

class AddPurchaseQtyViewController: UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var purchaseQtyLbl: UILabel!
    @IBOutlet weak var clickOnLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addNewPurchasrQtyBtn: UIButton!
    @IBOutlet weak var newPurchaseBtnHeightConstraint: NSLayoutConstraint!
    
    
    
    var varientArr = [ProductById]()
    var singleProd = ""
    var product_PurchaseQty = ""
    var varient_Selected_purchaseQty = [String]()
    var varient_selected_id = [String]()
    var prod_id  = ""
    var is_Varient = ""
    var deal_Name = ""
    var selecte_pur_qty =  ""
    var purchaseArr =  [Purchase]()
    var purchaseQtyArr = [Purchase]()
    var null_found_big = 0
    var duplicate = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewPurchasrQtyBtn.layer.cornerRadius = 10
        topView.addBottomShadow()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if is_Varient == "0" {
            
            addNewPurchasrQtyBtn.isHidden = true
            newPurchaseBtnHeightConstraint.constant = 0
            
            if product_PurchaseQty == "0" || product_PurchaseQty == "<null>" {
                tableView.isHidden = true
                addBtn.isHidden = false
                purchaseQtyLbl.isHidden = false
                clickOnLbl.isHidden = false
                addNewPurchasrQtyBtn.isHidden = false
                newPurchaseBtnHeightConstraint.constant = 0
            }
            else {
                addBtn.isHidden = true
                purchaseQtyLbl.isHidden = true
                clickOnLbl.isHidden = true
                tableView.isHidden = false
                addNewPurchasrQtyBtn.isHidden = true
                newPurchaseBtnHeightConstraint.constant = 0
            }
        }
        else {
            
            getpurchaseQty()
            print(purchaseQtyArr.count)
            print(duplicate)

            if null_found_big == 0 {
                
                tableView.isHidden = false
                addBtn.isHidden = true
                purchaseQtyLbl.isHidden = true
                clickOnLbl.isHidden = true
                addNewPurchasrQtyBtn.isHidden = true
            }
            
            else if purchaseQtyArr.count > null_found_big {
                
                tableView.isHidden = false
                addBtn.isHidden = true
                purchaseQtyLbl.isHidden = true
                clickOnLbl.isHidden = true
                addNewPurchasrQtyBtn.isHidden = false
                  
            }
            else if purchaseQtyArr.count > duplicate || purchaseQtyArr.count > 0  {
                tableView.isHidden = false
                addBtn.isHidden = true
                purchaseQtyLbl.isHidden = true
                clickOnLbl.isHidden = true
                addNewPurchasrQtyBtn.isHidden = false
            }
            else if purchaseQtyArr.count == 0{
                addBtn.isHidden = false
                purchaseQtyLbl.isHidden = false
                clickOnLbl.isHidden = false
                tableView.isHidden = true
                addNewPurchasrQtyBtn.isHidden = true
            }
            else {
                addBtn.isHidden = false
                purchaseQtyLbl.isHidden = false
                clickOnLbl.isHidden = false
                tableView.isHidden = true
                addNewPurchasrQtyBtn.isHidden = true
            }
        }
    }
    
    func getpurchaseQty(){
        

        var smallPurchase: [Purchase] = []
        var seenIDs: Set<String> = Set()
        var null_found = 0
        var duplicate_found = 0

        for qty in varientArr {
            let id = qty.id
            if !seenIDs.contains(id) {
                let pur = Purchase(id: id, name: qty.variant, qty: qty.purchase_qty)
                print(pur.qty)
                
                if qty.purchase_qty == "<null>" {
                    null_found += 1
                } else if smallPurchase.contains(where: { $0.qty == pur.qty }) {
                    duplicate_found += 1
                } else {
                    smallPurchase.append(pur)
                    seenIDs.insert(id)
                }
                print("$$\(null_found)")
                print("##\(duplicate_found)")
                
            }
        }
        print(smallPurchase)
        null_found_big = null_found
        purchaseQtyArr = smallPurchase
        duplicate = duplicate_found
    }
    
   
    
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: Any) {
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! MaxPurchaseUpdateViewController
        
        if varientArr.count == 0 {
            vc.single_prod_title = singleProd
        }
        else {
            vc.arrofVarient = varientArr
            vc.arrPurchaseQty = purchaseQtyArr
        }
        vc.dealText = deal_Name
        vc.selected_qty = selecte_pur_qty
        vc.product_id = prod_id
        vc.is_Varient = is_Varient
       
        
    }
    
    @IBAction func AddBtnClick(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PurchaseQuantityViewController") as! PurchaseQuantityViewController
        
        if varientArr.count == 0 {
            vc.q_singleProd = singleProd
            vc.prod_purchaseQty = product_PurchaseQty
        }
        else {
            vc.purchaseVarientArr = varientArr
            vc.arrofVarientPurchaseQty = purchaseQtyArr
        }
        vc.product_id = prod_id
        vc.isVarient = is_Varient
      
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
}

extension AddPurchaseQtyViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if varientArr.count == 0{
            return 1
        }else {
            return purchaseQtyArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPurchaseCell", for: indexPath) as! AddPurchaseCell
        cell.selectionStyle = .none
      
        if varientArr.count == 0 {
            cell.offerLbl.text = "Max Quantity per transaction \(product_PurchaseQty)"
        }
        else {
                cell.offerLbl.text = "Max Quantity per transaction \(purchaseQtyArr[indexPath.row].qty)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddPurchaseCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        if varientArr.count == 0 {
            cell.offerLbl.text = "Max Quantity per transaction \(product_PurchaseQty)"
            deal_Name = cell.offerLbl.text ?? ""
            selecte_pur_qty = product_PurchaseQty
        }
        else {
            cell.offerLbl.text = "Max Quantity per transaction \(purchaseQtyArr[indexPath.row].qty)"
            selecte_pur_qty = purchaseQtyArr[indexPath.row].qty
            deal_Name = cell.offerLbl.text ?? ""
            print(deal_Name)
        }
        var smallpur = [String]()
        
        performSegue(withIdentifier: "toPurchaseUpdate", sender: nil)
    }
}


struct Purchase {
    
    var id: String
    var name: String
    var qty: String
    
}
