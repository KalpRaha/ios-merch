//
//  SetupInventoryViewController.swift
//
//
//  Created by Jamaluddin Syed on 7/3/24.
//

import UIKit
import MaterialComponents

class SetupInventoryViewController: UIViewController {
    
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var checkBirthday: UIImageView!
    @IBOutlet weak var checkExpire: UIImageView!
    
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var expireView: UIView!
    
    @IBOutlet weak var birthdaylbl: UILabel!
    @IBOutlet weak var expirelbl: UILabel!
    
    @IBOutlet weak var scanSwitch: UISwitch!
    
    
    var birthday = false
    var expire = false
    var costPer = ""
    var costMethod = ""
    var invSetting = ""
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        topview.addBottomShadow()
        saveBtn.layer.cornerRadius = 10
        
        let birth_tap = UITapGestureRecognizer(target: self, action: #selector(birthEnable))
        birthdayView.addGestureRecognizer(birth_tap)
        birth_tap.numberOfTapsRequired = 1
        birthdayView.isUserInteractionEnabled = true
        
        let expire_tap = UITapGestureRecognizer(target: self, action: #selector(expireEnable))
        expireView.addGestureRecognizer(expire_tap)
        expire_tap.numberOfTapsRequired = 1
        expireView.isUserInteractionEnabled = true
        
        scanSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        scanSwitch.addTarget(self, action: #selector(enableScan), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callApi()
    }
    
    func callApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.setInventorySetup(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
            }
            
            else {
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let res = response as! [String:Any]
        
        let invent = SetupInventory(merchant_id: "\(res["merchant_id"] ?? "")", age_verify: "\(res["age_verify"] ?? "")",
                                    by_scanning: "\(res["by_scanning"] ?? "")", cost_method: "\(res["cost_method"] ?? "")",
                                    inv_setting: "\(res["inv_setting"] ?? "")", cost_per: "\(res["cost_per"] ?? "")")
        
        if invent.by_scanning == "1" {
            scanSwitch.isOn = true
            scanSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            scanSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
            
            birthdaylbl.textColor = .lightGray
            expirelbl.textColor = .lightGray
            checkBirthday.image = UIImage(named: "uncheck inventory")
            checkExpire.image = UIImage(named: "uncheck inventory")
            birthdayView.isUserInteractionEnabled = false
            expireView.isUserInteractionEnabled = false
            
            birthday = false
            expire = false
        }
        else {
            
            scanSwitch.isOn = false
            scanSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            scanSwitch.thumbTintColor = .white
            
            birthdayView.isUserInteractionEnabled = true
            expireView.isUserInteractionEnabled = true
            
            birthdaylbl.textColor = .black
            expirelbl.textColor = .black
            
            if invent.age_verify == "1,2" {
                checkBirthday.image = UIImage(named: "check inventory")
                checkExpire.image = UIImage(named: "check inventory")
                birthday = true
                expire = true
            }
            
            else if invent.age_verify == "1" {
                checkBirthday.image = UIImage(named: "check inventory")
                checkExpire.image = UIImage(named: "uncheck inventory")
                birthday = true
                expire = false
            }
            
            else if invent.age_verify == "2" {
                checkBirthday.image = UIImage(named: "uncheck inventory")
                checkExpire.image = UIImage(named: "check inventory")
                birthday = false
                expire = true
            }
            
            else {
                checkBirthday.image = UIImage(named: "uncheck inventory")
                checkExpire.image = UIImage(named: "uncheck inventory")
                birthday = false
                expire = false
            }
        }
        
        costPer = invent.cost_per
        costMethod = invent.cost_method
        invSetting = invent.inv_setting
    }
    
    @objc func birthEnable() {
        
        if checkBirthday.image == UIImage(named: "check inventory") {
            checkBirthday.image = UIImage(named: "uncheck inventory")
            birthday = false
        }
        
        else {
            checkBirthday.image = UIImage(named: "check inventory")
            birthday = true
        }
    }
    
    @objc func expireEnable() {
        
        if checkExpire.image == UIImage(named: "check inventory") {
            checkExpire.image = UIImage(named: "uncheck inventory")
            expire = false
        }
        
        else {
            checkExpire.image = UIImage(named: "check inventory")
            expire = true
        }
    }
    
    @objc func enableScan(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            
            enableSwitch.isOn = true
            
            scanSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            scanSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
            birthdaylbl.textColor = .lightGray
            expirelbl.textColor = .lightGray
            checkBirthday.image = UIImage(named: "uncheck inventory")
            checkExpire.image = UIImage(named: "uncheck inventory")
            birthdayView.isUserInteractionEnabled = false
            expireView.isUserInteractionEnabled = false
            
            birthday = false
            expire = false
        }
        
        else {
            
            enableSwitch.isOn = false
            
            scanSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            scanSwitch.thumbTintColor = .white
            birthdaylbl.textColor = .black
            expirelbl.textColor = .black
            checkBirthday.image = UIImage(named: "check inventory")
            checkExpire.image = UIImage(named: "check inventory")
            birthdayView.isUserInteractionEnabled = true
            expireView.isUserInteractionEnabled = true
            
            birthday = true
            expire = true
        }
    }
    
    func checkScan() -> String {
        
        if scanSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkAge(scan: String) -> String {
        
        if scan == "0" {
            
            if birthday && expire  {
                return "1,2"
            }
            else if birthday  {
                return "1"
            }
            else if expire  {
                return "2"
            }
            else {
                return ""
            }
        }
        
        else {
            return ""
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let scan = checkScan()
        let age = checkAge(scan: scan)
        
        if scan == "0" {
            guard age != "" else {
                ToastClass.sharedToast.showToast(message: "Select Age Verification",
                                    font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        }
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.updateInventorySetup(merchant_id: id, cost_method: costMethod,
                                                 by_scanning: scan, age_verify: age,
                                                 inv_setting: invSetting, cost_per: costPer) { isSuccess, responseData in
            
            if isSuccess {
                
                self.loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Updated Successfully",
                                    font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        saveBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: 35),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

struct SetupInventory {
    
    let merchant_id: String
    let age_verify: String
    let by_scanning: String
    let cost_method: String
    let inv_setting: String
    let cost_per: String
}
