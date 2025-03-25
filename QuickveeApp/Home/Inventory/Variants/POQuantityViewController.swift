//
//  POQuantityViewController.swift
//  
//
//  Created by Jamaluddin Syed on 10/4/23.
//

import UIKit

class POQuantityViewController: UIViewController {
    
    
    @IBOutlet weak var quantityText: UITextField!
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    
//    @IBOutlet weak var minusBtn: UIButton!
//    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hoverView: UIView!
    
    var desc = ""
    var descVari_id = ""
    var descprod_id = ""
    var descIsV = ""

    var ipoVari_id = ""
    var ipoProd_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = "Enter Quantity"
        quantityText.placeholder = "0"
        
        let color = UIColor.black
        let placeholder = quantityText.placeholder ?? ""
        quantityText.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        oneBtn.layer.cornerRadius = 8.0
        twoBtn.layer.cornerRadius = 8.0
        threeBtn.layer.cornerRadius = 8.0
        fourBtn.layer.cornerRadius = 8.0
        fiveBtn.layer.cornerRadius = 8.0
        sixBtn.layer.cornerRadius = 8.0
        sevenBtn.layer.cornerRadius = 8.0
        eightBtn.layer.cornerRadius = 8.0
        nineBtn.layer.cornerRadius = 8.0
        
        eraseBtn.layer.cornerRadius = 8.0
        zeroBtn.layer.cornerRadius = 8.0
        backBtn.layer.cornerRadius = 8.0
        
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 8.0
        
        saveBtn.layer.cornerRadius = 8.0
        
        hoverView.layer.cornerRadius = 10
        hoverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cancelBtn.setTitle("Cancel", for: .normal)
        saveBtn.setTitle("Next", for: .normal)
        
    }
    
    
    @IBAction func numberBtnsClick(_ sender: UIButton) {
        
        if quantityText.text?.count ?? 0 >= 6 {
            
        }
        else {
            
            quantityText.text?.append(sender.currentTitle!)
        }
    }
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        
        quantityText.text = ""
        
    }
  
    @IBAction func minusBtnClick(_ sender: UIButton) {
        
        var quantity = quantityText.text ?? ""
        
        if !quantity.hasPrefix("-") {
            quantity.insert("-", at: quantity.startIndex)
            
            quantityText.text = quantity
        }
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        var quantity = quantityText.text ?? ""
        
        if quantity.hasPrefix("-") {
            quantity.remove(at: quantity.startIndex)
            
            quantityText.text = quantity
        }
      
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        var inputString = quantityText.text ?? ""
        
        inputString = String(inputString.dropLast())
        
        quantityText.text = inputString
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
      //  varInfoVC1?.mode = "quantPO"
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if UserDefaults.standard.string(forKey: "toInstantPO") == "prod" {
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                destiny = destinationIndex
            }
        }
        else {
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is VariantInfoViewController }) {
                destiny = destinationIndex
            }
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
   
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        guard let title = quantityText.text, title != "" else {
            ToastClass.sharedToast.showToast(message: "Enter valid product quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        performSegue(withIdentifier: "costPO", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! CostViewController
        vc.descPO = desc
        vc.quantity = quantityText.text ?? ""
        
        if UserDefaults.standard.bool(forKey: "Po Descrip") {
            vc.cosv_id = descVari_id
            vc.cosp_id = descprod_id
        }
        else {
            vc.cosv_id = ipoVari_id
            vc.cosp_id = ipoProd_id
        }
        vc.cosISV = descIsV
    }
}
