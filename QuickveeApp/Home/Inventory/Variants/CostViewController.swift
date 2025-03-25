//
//  CostViewController.swift
//
//
//  Created by Jamaluddin Syed on 10/12/23.
//

import UIKit

class CostViewController: UIViewController {
    
    
    @IBOutlet weak var one: UIStackView!
    @IBOutlet weak var four: UIStackView!
    
    @IBOutlet weak var three: UIStackView!
    @IBOutlet weak var seven: UIStackView!
    @IBOutlet weak var save: UIStackView!
    
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var costText: UITextField!
    
    var cleanedAmount = ""
    var descPO = ""
    var quantity = ""
    var cosp_id = ""
    var cosv_id = ""
    var cosISV = ""
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costText.text = "0.00"
        
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
        
        previousBtn.layer.borderWidth = 1.0
        previousBtn.layer.borderColor = UIColor.black.cgColor
        previousBtn.layer.cornerRadius = 8.0
        
        saveBtn.layer.cornerRadius = 8.0
        
        hoverView.layer.cornerRadius = 10
        hoverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveBtn.isEnabled = true
        previousBtn.isEnabled = true
        closeBtn.isEnabled = true
        setUI()
    }
    
    func setupPOApi(v_id : String , p_id : String, desc : String , quantity: String , price : String , m_id : String ,e_id : String ) {
        
        print(v_id)
        print(p_id)
        print(desc)
        print(quantity)
        print(price)
        print(cosp_id)
        print(cosv_id)
        print(m_id)
        
        
        ApiCalls.sharedCall.variantSavePO(merchant_id: m_id, product_id: p_id, variant_id: v_id,
                                          description: desc, qty: quantity, price: price, emp_id: e_id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.loadIndicator.isAnimating = false
                
                ToastClass.sharedToast.showToast(message: "Updated Successfully", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.saveBtn.isEnabled = true
                
                let viewcontrollerArray = self.navigationController?.viewControllers
                var destiny = 0
                
                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                    destiny = destinationIndex
                    self.previousBtn.isEnabled = true
                    self.closeBtn.isEnabled = true
                    
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                }
                else {
                    self.previousBtn.isEnabled = true
                    self.closeBtn.isEnabled = true
                }
            }else{
                print("Api Error")
                self.saveBtn.isEnabled = true
            }
        }
    }
    
  
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        cleanedAmount = String(cleanedAmount.dropLast())
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        
        if amountAsString.last == "0" {
            amountAsString.append("0")
        }
        costText.text = "\(amountAsString)"
    }
    
    
    @IBAction func prevBtnClick(_ sender: UIButton) {
        
        //  varInfoVC2?.mode = "costPO"
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        
        let viewcontrollerArray = navigationController?.viewControllers
        let destiny = 4
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        let price = costText.text ?? ""
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let e_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
        
        loadIndicator.isAnimating = true
        previousBtn.isEnabled = false
        closeBtn.isEnabled = false
        saveBtn.isEnabled = false
        
        if UserDefaults.standard.string(forKey: "toInstantPO") == "prod" {
            setupPOApi(v_id: cosv_id, p_id: cosp_id, desc: descPO, quantity: quantity, price: price, m_id: m_id, e_id: e_id)
        }
        
        else {
            if cosISV == "0" {
                setupPOApi(v_id: cosv_id, p_id: cosp_id, desc: descPO, quantity: quantity, price: price, m_id: m_id, e_id: e_id)
            }
            else {
                setupPOApi(v_id: "", p_id: cosv_id, desc: descPO, quantity: quantity, price: price, m_id: m_id, e_id: e_id)
            }
        }
    }
    
    @IBAction func numberBtnClick(_ sender: UIButton) {
        
        let titleText = sender.currentTitle
        
        doubleText(currentTitle: titleText ?? "")
    }
    
    
    @IBAction func eraseBtnClick(_ sender: UIButton) {
        
        costText.text = ""
        cleanedAmount = ""
    }
    
    func doubleText(currentTitle : String ) {
        
        
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
        
        costText.text = "\(amountAsString)"
        
        if costText.text == "0000" {
            costText.text = "00000"
        }
    }
    
    private func setUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        saveBtn.addSubview(loadIndicator)
        let center = 40
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}
