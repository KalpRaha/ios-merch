//
//  QtyMixnMatchViewController.swift
//
//
//  Created by Pallavi on 13/06/24.
//

import UIKit

class QtyMixnMatchViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextbtn: UIButton!
    
    weak var delegate: PriceQtyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
  
    func setUI() {
        
        qtyTextField.placeholder = "0"
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 10
        nextbtn.layer.cornerRadius = 10
        
        backgroundView.layer.cornerRadius = 10
        firstBtn.layer.cornerRadius = 8
        secondBtn.layer.cornerRadius = 8
        thirdBtn.layer.cornerRadius = 8
        fourthBtn.layer.cornerRadius = 8
        fifthBtn.layer.cornerRadius = 8
        sixBtn.layer.cornerRadius = 8
        sevenBtn.layer.cornerRadius = 8
        eightBtn.layer.cornerRadius = 8
        nineBtn.layer.cornerRadius = 8
    }
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        
        if qtyTextField.text?.count ?? 0 >= 6 {
            
        }
        else {
            if sender.currentTitle == "0" &&  qtyTextField.text?.count == 0 {
                
            }
            else {
                qtyTextField.text?.append(sender.currentTitle!)
            }
        }
    }
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        qtyTextField.text = ""
        
    }
    
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        var inputString = qtyTextField.text ?? ""
        
        inputString = String(inputString.dropLast())
        
        qtyTextField.text = inputString
    }
    
    @IBAction func cancleBtnClick(_ sender: UIButton) {

        UserDefaults.standard.set(0, forKey: "modal_screen")
        dismiss(animated: true)
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        guard let title = qtyTextField.text , title != "" else   {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let numTitle = Int(title) ?? 1
        
        if numTitle < 1 {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
           // UserDefaults.standard.set(true, forKey: "select_key")
            UserDefaults.standard.set(2, forKey: "modal_screen")
            delegate?.getPriceQty(price: "", is_percent: "", quantity: title)
            dismiss(animated: true)
        }
    }
}
