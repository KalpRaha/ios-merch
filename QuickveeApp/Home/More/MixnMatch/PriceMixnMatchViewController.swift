//
//  PriceMixnMatchViewController.swift
//
//
//  Created by Pallavi on 13/06/24.
//

import UIKit

class PriceMixnMatchViewController: UIViewController {
    
    
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
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var percentView: UIView!
    
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var persentLbl: UILabel!
    
    var cleanedAmount = ""
    var pricevarientArr = [ProductById]()
    
    var varPrice = ""
    var priceP_id = ""
    var percentage = ""
    var price_prodTitle = ""
    var price_unselect = [String]()
    
    weak var delegate: PriceQtyDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        priceTextField.placeholder = "$0.00"
    }
    
    
    func setUI() {
        
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
        
        let priceGest = UITapGestureRecognizer(target: self, action: #selector(priceBtnClick))
        priceLbl.addGestureRecognizer(priceGest)
        priceLbl.isUserInteractionEnabled = true
        priceGest.numberOfTapsRequired = 1
        
        let percentGest = UITapGestureRecognizer(target: self, action: #selector(percentBtnClick))
        persentLbl.addGestureRecognizer(percentGest)
        persentLbl.isUserInteractionEnabled = true
        percentGest.numberOfTapsRequired = 1
        
    }
    
    
    @objc func priceBtnClick() {
        
        percentView.backgroundColor = .clear
        priceView.backgroundColor = .black
        priceTextField.placeholder = "$0.00"
        priceTextField.text = ""
        cleanedAmount = ""
        
    }
    
    @objc func percentBtnClick() {
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
            
            cleanedAmount.append(character)
        }
        
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
        
        var ispercent = ""
        
        if priceView.backgroundColor == .black {
            
            
            guard let title = priceTextField.text, title != "" else {
                ToastClass.sharedToast.showToast(message: "Enter Price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            guard priceTextField.text != "$0.00" else {
                ToastClass.sharedToast.showToast(message: "Price must be greater than Zero", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            ispercent = "0"
        }
        
        else {
            
            guard let title = priceTextField.text, title != "" else {
                ToastClass.sharedToast.showToast(message: "Enter Percent", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            guard priceTextField.text != "0.00%" else {
                ToastClass.sharedToast.showToast(message: "Price must be greater than Zero", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            ispercent = "1"
        }
        
        let price = priceTextField.text ?? ""
        UserDefaults.standard.set(1, forKey: "modal_screen")
        dismiss(animated: true) {
            self.delegate?.getPriceQty(price: price, is_percent: ispercent, quantity: "")
        }
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        UserDefaults.standard.set(0, forKey: "modal_screen")
        dismiss(animated: true)
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
