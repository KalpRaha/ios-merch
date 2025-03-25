//
//  PurchaseQuantityViewController.swift
//  
//
//  Created by Pallavi on 21/05/24.
//

import UIKit
import MaterialComponents

class PurchaseQuantityViewController: UIViewController {

   
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var sixbtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
   
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
   
    
    var purchaseVarientArr = [ProductById]()
    var q_singleProd = ""
    var arrofVarientPurchaseQty = [Purchase]()
    var product_id = ""
    var prod_purchaseQty = ""
    var isVarient = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    func setUI(){
        
        qtyTextField.placeholder = "0"
        let colors = UIColor.black
        let placeholder = qtyTextField.placeholder ?? ""
        qtyTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : colors])
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        bgView.layer.cornerRadius = 10
        oneBtn.layer.cornerRadius = 8
        twoBtn.layer.cornerRadius = 8
        threeBtn.layer.cornerRadius = 8
        fourBtn.layer.cornerRadius = 8
        fifthBtn.layer.cornerRadius = 8
        sixbtn.layer.cornerRadius = 8
        sevenBtn.layer.cornerRadius = 8
        eightBtn.layer.cornerRadius = 8
        nineBtn.layer.cornerRadius = 8
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! MaxPurchaseQuantityViewController
    
        if  purchaseVarientArr.count == 0{
            vc.single_product = q_singleProd
            vc.product_purchaseQty = prod_purchaseQty
        }
        else{
            vc.maxpurVarientArr = purchaseVarientArr
            vc.varient_Select_PurQty = arrofVarientPurchaseQty
        }
        vc.p_qty = qtyTextField.text ?? ""
        vc.prod_id = product_id
        vc.is_Varient = isVarient
       
    }
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        if qtyTextField.text?.count ?? 0 >= 6 {
           
        }
        else {
            
            qtyTextField.text?.append((sender as AnyObject).currentTitle!)
        }
    }
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        var inputString = qtyTextField.text ?? ""
        
        inputString = String(inputString.dropLast())
        
        qtyTextField.text = inputString
    }
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        qtyTextField.text = ""
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {

    
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
       
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        guard let title = qtyTextField.text else  {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        
        let numTitle = Int(title) ?? 0
        
        if numTitle < 1 {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)

        }
        else {
            performSegue(withIdentifier: "toMaxPurchase", sender: nil)
        }
       
        
    }
    
    
}
