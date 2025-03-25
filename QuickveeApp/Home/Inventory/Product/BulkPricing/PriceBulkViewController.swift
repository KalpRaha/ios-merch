//
//  PriceBulkViewController.swift
//  
//
//  Created by Jamaluddin Syed on 2/9/24.
//

import UIKit

class PriceBulkViewController: UIViewController {
    
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var percentView: UIView!
    
    var cleanedAmount = ""
    var pricevarientArr = [ProductById]()
  
    var varPrice = ""
    var priceP_id = ""
    var percentage = ""
    var price_prodTitle = ""
    var price_unselect = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        priceTextField.placeholder = "$0.00"
    }
    
    
    func setUI(){
        
        let color = UIColor.black
        let placeholder = priceTextField.placeholder ?? ""
        
        priceTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
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
        zeroBtn.layer.cornerRadius = 8
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 10
        clearBtn.layer.cornerRadius = 5
        nineBtn.layer.cornerRadius = 10
        eraseBtn.layer.cornerRadius = 5
        nextBtn.layer.cornerRadius = 10

    }
    
    
    @IBAction func priceBtnClick(_ sender: UIButton) {
      
        percentView.backgroundColor = .clear
        priceView.backgroundColor = .black
        priceTextField.placeholder = "$0.00"
        priceTextField.text = ""
        cleanedAmount = ""
    }
    
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
        
        
        priceView.backgroundColor = .clear
        percentView.backgroundColor = .black
        priceTextField.placeholder = "0.00%"
        priceTextField.text = ""
        cleanedAmount = ""
    }
    
    
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        
        priceTextField.text = ""
        cleanedAmount = ""
    }
    
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        
        let titleText = sender.currentTitle
        
        doubleText(currentTitle: titleText ?? "")
        
    }
    
    
    func doubleText(currentTitle : String ) {
        
        
        for character in currentTitle {
            print(cleanedAmount)
            
            cleanedAmount.append(character)
        }
        
        print(cleanedAmount)
        
        if priceView.backgroundColor == .black {
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            if Double(cleanedAmount) ?? 00000 > 9999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        print(cleanedAmount)
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        print(amountAsDouble)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        
        if priceView.backgroundColor == .black {
            priceTextField.text = "$\(amountAsString)"
        }
        
        else {
            priceTextField.text = "\(amountAsString)%"
        }
        
        
        if priceTextField.text == "0000" {
            priceTextField.text = "00000"
       }
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        if priceView.backgroundColor == .clear {
            
           
            guard let title = priceTextField.text, title != "", title != "0.00%" else {
                ToastClass.sharedToast.showToast(message: "Enter Percent", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
          
                percentage = "1"
           
            
        }else {
            
          
                guard let title = priceTextField.text, title != "", title != "$0.00" else {
                    ToastClass.sharedToast.showToast(message: "Enter price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
        
            
                percentage = "0"
            
        }
        performSegue(withIdentifier: "toQuantity", sender: nil)
        
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
       
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toQuantity" {
            let vc = segue.destination as! BulkQuantityViewController
            vc.b_percent = percentage
            
            if priceView.backgroundColor == .black {
                let cost = "\(priceTextField.text ?? "" )"
                let deal = String(cost.dropFirst())
                print(deal)
                vc.b_price  = deal
            }
            else {
                let cost = "\(priceTextField.text ?? "" )"
                let deal = String(cost.dropLast())
                print(deal)
                vc.b_price  = deal
            }
            
            if pricevarientArr.count == 0{
                vc.prodTitel_Qty = price_prodTitle
            }
            else {
                vc.qtyvarientArr = pricevarientArr
            }
            
            vc.qtyP_id = priceP_id
            vc.qty_Unselect = price_unselect
        }
    }
    
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        
        cleanedAmount = String(cleanedAmount.dropLast())
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        
        if amountAsString.last == "0" {
            amountAsString.append("0")
        }
        
        if priceView.backgroundColor == .black {
            priceTextField.text = "$\(amountAsString)"
        }
        else {
            priceTextField.text = "\(amountAsString)%"
        }
    }
}

extension UIView {
    func addBottomShadowtwo() {
        
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06).cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
