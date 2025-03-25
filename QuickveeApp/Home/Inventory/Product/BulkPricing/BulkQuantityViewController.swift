//
//  BulkQuantityViewController.swift
//  
//
//  Created by Jamaluddin Syed on 2/9/24.
//

import UIKit

class BulkQuantityViewController: UIViewController {
    
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextnt: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var quantityTetxField: UITextField!
    
    var b_price = ""
    var b_percent = ""
    var qtyvarientArr = [ProductById]()
    var qtyP_id = ""
    var prodTitel_Qty = ""
    var qty_Unselect = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        
        quantityTetxField.placeholder = "0"
        let colors = UIColor.black
        let placeholder = quantityTetxField.placeholder ?? ""
        quantityTetxField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : colors])
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 10
        nextnt.layer.cornerRadius = 10
        
        bgView.layer.cornerRadius = 10
        oneBtn.layer.cornerRadius = 8
        twoBtn.layer.cornerRadius = 8
        threeBtn.layer.cornerRadius = 8
        fourBtn.layer.cornerRadius = 8
        fiveBtn.layer.cornerRadius = 8
        sixBtn.layer.cornerRadius = 8
        sevenBtn.layer.cornerRadius = 8
        eightBtn.layer.cornerRadius = 8
        nineBtn.layer.cornerRadius = 8
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBulkVC" {
            let vc = segue.destination as! BulkPricingViewController
            if qtyvarientArr.count == 0 {
                vc.prod = prodTitel_Qty
            }else {
                vc.arrofvarients = qtyvarientArr
            }
            vc.bp_price = b_price
            vc.b_qty = quantityTetxField.text ?? ""
            vc.bprod_id = qtyP_id
            vc.bulk_percetage = b_percent
            vc.bulk_unselect = qty_Unselect
            
        }
    }
    
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        
        if quantityTetxField.text?.count ?? 0 >= 6 {
            
        }
        else {
            
            quantityTetxField.text?.append((sender as AnyObject).currentTitle!)
        }
        
    }
    
    
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        
        quantityTetxField.text = ""
    }
    
    
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        
        var inputString = quantityTetxField.text ?? ""
        
        inputString = String(inputString.dropLast())
        
        quantityTetxField.text = inputString
    }
    
    

    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        guard let title = quantityTetxField.text else  {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        
        let numTitle = Int(title) ?? 0
        
        if numTitle < 1 {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)

        }
        else {
            performSegue(withIdentifier: "toBulkVC", sender: nil)

        }
        
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
       
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
}
