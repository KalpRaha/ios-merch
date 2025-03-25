//
//  AddGiftCardViewController.swift
//  
//
//  Created by Pallavi on 31/07/24.
//

import UIKit

protocol AddGiftcardprotocol: AnyObject {
    func setGIftCard()
}

class AddGiftCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var numbertextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var sixbtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var ApplyBtn: UIButton!
 
    
    weak var delegate: AddGiftcardprotocol?
    
    var cleanedAmount = ""
    var mode = ""
    var number = ""
    var emp_id = ""
    var amount = ""
    var created = ""
    var numTextfield = ""
    var user_Id = ""
    var price = ""
    var select = false
    
    var activeTextField = UITextField()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupUI()
        numbertextField.delegate = self
        numbertextField.keyboardType = .decimalPad
      
        UserDefaults.standard.set(0, forKey: "modal_screen")
      
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setMode()
        
    }
 
    func setUI() {
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
        
        ApplyBtn.layer.cornerRadius = 10
        bgView.layer.cornerRadius  = 10
 
        oneBtn.layer.cornerRadius = 8.0
        twoBtn.layer.cornerRadius = 8.0
        threeBtn.layer.cornerRadius = 8.0
        fourBtn.layer.cornerRadius = 8.0
        fifthBtn.layer.cornerRadius = 8.0
        sixbtn.layer.cornerRadius = 8.0
        sevenBtn.layer.cornerRadius = 8.0
        eightBtn.layer.cornerRadius = 8.0
        nineBtn.layer.cornerRadius = 8.0
        zeroBtn.layer.cornerRadius = 8.0
    }
  
    func setMode(){
       
        if mode == "Add" {
            titleLbl.text = "Add"
            numbertextField.placeholder = "$0.00"
            
            let color = UIColor.black
            let placeholder = numbertextField.placeholder ?? ""
            numbertextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            
        }
        else {
            titleLbl.text = "Remove"
            let color = UIColor.red
            let placeholder = numbertextField.placeholder ?? ""
            numbertextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            numbertextField.placeholder = "$0.00"
            numbertextField.textColor = UIColor.red
            
           
        }
    }
    
    func roundOf(item : String) -> Double {
            
            var itemDollar = ""
            
            if item.starts(with: "$") {
                itemDollar = String(item.dropFirst())
                let doub = Double(itemDollar) ?? 0.00
                let div = (100 * doub) / 100
                return div
            }
            else {
                let doub = Double(item) ?? 0.00
                let div = (100 * doub) / 100
                print(div)
                return div
            }
        }
    
    func calculate_AddGift(textFieldText :String) -> String {
        let textFld =   textFieldText//roundOf(item: textFieldText)
        let d_amt = textFld.dropFirst()
        let credit_amt =  d_amt
        return String(credit_amt)
    }
    
    func checkPrice(varamt: String, textAmt: String) -> Bool {
        
        let v_amt = Double(varamt) ?? 0.00
        let textAmt = Double(textAmt) ?? 0.00
        
        if v_amt > textAmt {
            return false
        }
        return true
    }
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        let titleText = sender.currentTitle
        if mode == "Add" {
            doubleText(currentTitle: titleText ?? "")
        }
        else {
           doubleText(currentTitle: titleText ?? "")
        }
    
    }
    
    @IBAction func NumberCancelBtnClick(_ sender: UIButton) {
        numbertextField.text = ""
        cleanedAmount = ""
    }
    
    @IBAction func numberBackBtn(_ sender: UIButton) {
        
        cleanedAmount = String(cleanedAmount.dropLast())
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        
        if amountAsString.last == "0" {
            amountAsString.append("0")
        }
        numbertextField.text = "$\(amountAsString)"
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        UserDefaults.standard.set(0, forKey: "modal_screen")
        dismiss(animated: true)
    }
    
    @IBAction func ApplyBtnClick(_ sender: UIButton) {
        if numbertextField.text != "" {
            addRemoveApiCall()
        }
        else {
            ToastClass.sharedToast.showToast(message: "The Value should be greater than Zero ", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
        }
       
    }

    func addRemoveApiCall() {
       
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        numTextfield = numbertextField.text ?? ""
       
        let amt = String(numTextfield.dropFirst())
        
        var type = ""
        
        if mode == "Add" {
            type = "credit"
        }
        else {
            type = "debit"
            
        }
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.giftCardAddRemoveAPiCall(merchant_id: id, number: number,
                                                     user_id: user_Id, amount: amt, emp_id: emp_id,
                                                     created_at: created, location: "GiftCardHistory",
                                                     type: type, desc: "", order_id: "null"){ isSuccess,responseData in
            
            if isSuccess {
               
                
                DispatchQueue.main.asyncAfter(deadline: .now() +  1.0) {
                    self.loadingIndicator.isAnimating = false
                    self.dismiss(animated: true)
                }
                self.delegate?.setGIftCard()
               
            }
            else {
                print("Api Error")
            }
        }
    }
  
    func doubleText(currentTitle : String ) {
        
        let amt = Double(amount) ?? 0.00
        
        for character in currentTitle {
            print(cleanedAmount)
            
            cleanedAmount.append(character)
        }
        print(amt)
        print(cleanedAmount)
        
        if mode == "Add" {
            
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            let result = (Double(cleanedAmount) ?? 00000) / 100.0

            if result > amt {
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
        
        numbertextField.text = "$\(amountAsString)"
        
        if numbertextField.text == "0000" {
            numbertextField.text = "00000"
        }
    }
  
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
       
        ApplyBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: ApplyBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: ApplyBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    
    }
}


struct SomeStruct {
    var name: String
    var description: String {
        return "Item: \(name)"
    }
}
