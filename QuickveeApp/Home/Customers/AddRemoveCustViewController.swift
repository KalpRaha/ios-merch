//
//  AddRemoveCustViewController.swift
//  
//
//  Created by Pallavi on 04/10/24.
//

import UIKit

protocol AddRemoveCustDelegate: AnyObject {
    func setPointValue(totalPoint: String)
}

class AddRemoveCustViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var numbertextField: UITextField!
    
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
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var erazeBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var ApplyBtn: UIButton!
    
    weak var custdelegate: AddRemoveCustDelegate?
    
    var cleanedAmount = ""
    var mode = ""
    var customerId = ""
    var addRemovePoints  = ""

    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupUI()
        numbertextField.keyboardType = .decimalPad
        
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
    
    
    func setMode() {
        
        if mode == "Add" {
            titleLbl.text = "Add"
            
            numbertextField.placeholder = "0.00"
            
            let color = UIColor.black
            let placeholder = numbertextField.placeholder ?? ""
            numbertextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        else {
            titleLbl.text = "Remove"
            
            let color = UIColor.red
            let placeholder = numbertextField.placeholder ?? ""
            numbertextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
            numbertextField.placeholder = "0.00"
            numbertextField.textColor = UIColor.red
        }
    }
    
    func checkPrice(varamt: String, textAmt: String) -> Bool {
        let numtext = textAmt.filter { $0 != "," }
        print(numtext)
        
        let v_amt = Double(varamt) ?? 0.00
        let text_Amt = Double(numtext) ?? 0.00
        
        print(v_amt)
        print(text_Amt)
        if v_amt > text_Amt {
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
    
    @IBAction func NumberClearBtnClick(_ sender: UIButton) {
        numbertextField.text = ""
        cleanedAmount = ""
    }
    
    
    @IBAction func numberEraseBtn(_ sender: UIButton) {
        
        cleanedAmount = String(cleanedAmount.dropLast())
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        
        if amountAsString.last == "0" {
            amountAsString.append("0")
        }
        numbertextField.text = "\(amountAsString)"
    }
    
    
    @IBAction func cancleBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func applyBtnClick(_ sender: UIButton) {
        
        if mode == "Add" {
            
            if numbertextField.text != "" {
                addRemovePointsAPI()
            }
            else {
                ToastClass.sharedToast.showToast(message: "Enter Valid Points", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
            }
        }
        else {
            let num = numbertextField.text ?? ""
            
            
            if !num.isEmpty {
             
                let checkless = checkPrice(varamt: num, textAmt: addRemovePoints)
                
                if checkless {
                    
                    addRemovePointsAPI()
                }
                else {
                    
                    ToastClass.sharedToast.showToast(message: "Enter Valid Points", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
                }
            }
            else {
                ToastClass.sharedToast.showToast(message: "Enter Valid Points", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
            }
        }
    }
    
    func addRemovePointsAPI() {
        let num = numbertextField.text ?? ""
        print(num)

        print(num)
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        
        
        var debit = ""
        var credit = ""
        
        if mode == "Add" {
            
            credit = num
            debit = ""
        }
        else {
            debit = num
            credit = ""
        }

        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.custAddRemoveLoyaltyPoint(merchant_id: id, admin_id: id,
                                                      customer_id: customerId, credit_points: credit,
                                                      credit_amount: credit, debit_points: debit,
                                                      debit_amount: debit, reason: "", date_time: "0",
                                                      emp_id: emp_id) { isSuccess, responseData in
            if isSuccess {
                
                if  responseData["total_pts"] != nil {
                    
                    let point = responseData["total_pts"] as! String
                    print(point)
                    self.loadingIndicator.isAnimating = false
                    self.dismiss(animated: true) {
                        self.custdelegate?.setPointValue(totalPoint: point)
                    }
                }
            }
            else {
                print("Api Error")
            }
        }
    }
    
    
    func doubleText(currentTitle: String ) {
        
        for character in currentTitle {
            cleanedAmount.append(character)
        }
        
        if Double(cleanedAmount) ?? 00000 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        print(cleanedAmount)
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        
        numbertextField.text = "\(amountAsString)"
        
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
