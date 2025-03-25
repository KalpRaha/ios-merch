//
//  QuickAddSetupViewController.swift
//  
//
//  Created by Jamaluddin Syed on 08/10/24.
//

import UIKit

class QuickAddSetupViewController: UIViewController {
    
    let actionList = ["Display Item Not Found", "Quick Enter, Forced", "Quick Enter, Prompt", "Full Enter, Forced", "Full Enter, Prompt"]
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    
    @IBOutlet weak var entireView: UIView!
    
    var msg = "0"
    var register: Register_Settings?
    
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 10
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectClick1))
        view1.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        view1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(selectClick2))
        view2.addGestureRecognizer(tap2)
        tap2.numberOfTapsRequired = 1
        view2.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectClick3))
        view3.addGestureRecognizer(tap3)
        tap3.numberOfTapsRequired = 1
        view3.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(selectClick4))
        view4.addGestureRecognizer(tap4)
        tap4.numberOfTapsRequired = 1
        view4.isUserInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(selectClick5))
        view5.addGestureRecognizer(tap5)
        tap5.numberOfTapsRequired = 1
        view5.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        loadIndicator.isAnimating = true
        entireView.isHidden = true
        
        setupApi()
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.setRegisterSettings(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
                
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let reg = response as! [String:Any]
        
        register = Register_Settings(id: "\(reg["id"] ?? "")",
                                     device_name: "\(reg["device_name"] ?? "")",
                                     merchant_id: "\(reg["merchant_id"] ?? "")",
                                     cost_method: "\(reg["cost_method"] ?? "")",
                                     age_verify: "\(reg["age_verify"] ?? "")",
                                     by_scanning: "\(reg["by_scanning"] ?? "")",
                                     inv_setting: "\(reg["inv_setting"] ?? "")",
                                     cost_per: "\(reg["cost_per"] ?? "")",
                                     regi_setting: "\(reg["regi_setting"] ?? "")",
                                     idel_logout: "\(reg["idel_logout"] ?? "")",
                                     return_window: "\(reg["return_window"] ?? "")",
                                     discount_prompt: "\(reg["discount_prompt"] ?? "")",
                                     round_invoice: "\(reg["round_invoice"] ?? "")",
                                     customer_loyalty: "\(reg["customer_loyalty"] ?? "")",
                                     barcode_msg: "\(reg["barcode_msg"] ?? "")",
                                     default_cash_drawer: "\(reg["default_cash_drawer"] ?? "")",
                                     clock_in: "\(reg["clock_in"] ?? "")",
                                     hide_inactive: "\(reg["hide_inactive"] ?? "")",
                                     end_day_Allow: "\(reg["end_day_Allow"] ?? "")",
                                     shift_assign: "\(reg["shift_assign"] ?? "")",
                                     start_date: "\(reg["start_date"] ?? "")",
                                     end_date: "\(reg["end_date"] ?? "")",
                                     start_time: "\(reg["start_time"] ?? "")",
                                     end_time: "\(reg["end_time"] ?? "")",
                                     report_history: "\(reg["report_history"] ?? "")",
                                     emp_permission: "\(reg["iemp_permissiond"] ?? "")",
                                     no_of_station: "\(reg["no_of_station"] ?? "")",
                                     denomination: "\(reg["denomination"] ?? "")",
                                     ebt: "\(reg["ebt"] ?? "")",
                                     enable_cashback_limit: "\(reg["enable_cashback_limit"] ?? "")",
                                     cashback_limit_amount: "\(reg["cashback_limit_amount"] ?? "")",
                                     cashback_charge_amount: "\(reg["cashback_charge_amount"] ?? "")",
                                     enable_autolock_transaction: "\(reg["enable_autolock_transaction"] ?? "")")
        
        msg = register?.barcode_msg ?? ""
        
        if msg == "1" {
            img1.image = UIImage(named: "select_radio")
            img2.image = UIImage(named: "unselect_radio")
            img3.image = UIImage(named: "unselect_radio")
            img4.image = UIImage(named: "unselect_radio")
            img5.image = UIImage(named: "unselect_radio")
        }
        else if msg == "2" {
            img1.image = UIImage(named: "unselect_radio")
            img2.image = UIImage(named: "select_radio")
            img3.image = UIImage(named: "unselect_radio")
            img4.image = UIImage(named: "unselect_radio")
            img5.image = UIImage(named: "unselect_radio")
        }
        if msg == "3" {
            img1.image = UIImage(named: "unselect_radio")
            img2.image = UIImage(named: "unselect_radio")
            img3.image = UIImage(named: "select_radio")
            img4.image = UIImage(named: "unselect_radio")
            img5.image = UIImage(named: "unselect_radio")
        }
        else if msg == "4" {
            img1.image = UIImage(named: "unselect_radio")
            img2.image = UIImage(named: "unselect_radio")
            img3.image = UIImage(named: "unselect_radio")
            img4.image = UIImage(named: "select_radio")
            img5.image = UIImage(named: "unselect_radio")
        }
        else if msg == "5" {
            img1.image = UIImage(named: "unselect_radio")
            img2.image = UIImage(named: "unselect_radio")
            img3.image = UIImage(named: "unselect_radio")
            img4.image = UIImage(named: "unselect_radio")
            img5.image = UIImage(named: "select_radio")
        }
        else {
            
        }
        
        loadIndicator.isAnimating = false
        entireView.isHidden = false
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let reg = register?.regi_setting ?? ""
        let idel_logout = register?.idel_logout ?? ""
        let ebt = register?.ebt ?? ""
        let enable_cashback_limit = register?.enable_cashback_limit ?? ""
        let cashback_limit_amount = register?.cashback_limit_amount ?? ""
        let cashback_charge_amount = register?.cashback_charge_amount ?? ""
        let barcode_msg = msg
        
        entireView.isHidden = true
        loadIndicator.isAnimating = true
        
        
        ApiCalls.sharedCall.updateRegisterSettings(merchant_id: id,
                                                   regi_setting: reg, idel_logout: idel_logout,
                                                   ebt: ebt, cbenable: enable_cashback_limit,
                                                   cblimit: cashback_limit_amount,
                                                   cbcharge: cashback_charge_amount,
                                                   barcode_msg: barcode_msg) { isSuccess, responseData in
            
            if isSuccess {
                
                self.entireView.isHidden = false
                self.loadIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Updated successfully",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            }
            
            else {
                self.loadIndicator.isAnimating = false
            }
        }
    }
    
    
    @objc func selectClick1() {
        
        img1.image = UIImage(named: "select_radio")
        img2.image = UIImage(named: "unselect_radio")
        img3.image = UIImage(named: "unselect_radio")
        img4.image = UIImage(named: "unselect_radio")
        img5.image = UIImage(named: "unselect_radio")
        msg = "1"
    }
    
    @objc func selectClick2() {
        
        img1.image = UIImage(named: "unselect_radio")
        img2.image = UIImage(named: "select_radio")
        img3.image = UIImage(named: "unselect_radio")
        img4.image = UIImage(named: "unselect_radio")
        img5.image = UIImage(named: "unselect_radio")
        msg = "2"
    }
    
    @objc func selectClick3() {
        img1.image = UIImage(named: "unselect_radio")
        img2.image = UIImage(named: "unselect_radio")
        img3.image = UIImage(named: "select_radio")
        img4.image = UIImage(named: "unselect_radio")
        img5.image = UIImage(named: "unselect_radio")
        msg = "3"
    }
    
    @objc func selectClick4() {
        img1.image = UIImage(named: "unselect_radio")
        img2.image = UIImage(named: "unselect_radio")
        img3.image = UIImage(named: "unselect_radio")
        img4.image = UIImage(named: "select_radio")
        img5.image = UIImage(named: "unselect_radio")
        msg = "4"
    }
    
    @objc func selectClick5() {
        img1.image = UIImage(named: "unselect_radio")
        img2.image = UIImage(named: "unselect_radio")
        img3.image = UIImage(named: "unselect_radio")
        img4.image = UIImage(named: "unselect_radio")
        img5.image = UIImage(named: "select_radio")
        msg = "5"
    }
}

extension QuickAddSetupViewController {
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}
