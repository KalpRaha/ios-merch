//
//  RegisterSettingsViewController.swift
//
//
//  Created by Pallavi on 11/06/24.
//

import UIKit
import MaterialComponents

class RegisterSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var toopview: UIView!
    
    @IBOutlet weak var payCollection: UICollectionView!
    @IBOutlet weak var regCollection: UICollectionView!
    
    @IBOutlet weak var updateBt: UIButton!
    @IBOutlet weak var lockScreenText: MDCOutlinedTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scroll: UIView!
    
    @IBOutlet weak var cashBackSwitch: UISwitch!
    @IBOutlet weak var cashbackLimitText: MDCOutlinedTextField!
    @IBOutlet weak var cashbackCharge: MDCOutlinedTextField!
    
    var register: Register_Settings?
    
    var food = false
    var cash = false
    var gift = false
    var lottery = false
    
    var stock = false
    var pin = false
    
    var isUpdate = false
    private var isSymbolOnRight = false
    
    var chargeCheck = false
    
    let payArray = ["Food EBT", "Cash EBT", "Gift Card", "Lottery Payout"]
    let regArray = ["Stock Prompt", "21+ Manager Pin"]
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toopview.addBottomShadow()
        
        lockScreenText.label.text = "Idle Lock Screen Minutes"
        
        updateBt.layer.cornerRadius = 10
        
        createCustomTextField(textField: lockScreenText)
        lockScreenText.keyboardType = .numberPad
        
        cashBackSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cashBackSwitch.addTarget(self, action: #selector(enableCashback), for: .valueChanged)
        
        cashbackLimitText.label.text = "Cashback Limit($)"
        cashbackCharge.label.text = "Cashback Charge($)"
        
        createCustomTextField(textField: cashbackLimitText)
        createCustomTextField(textField: cashbackCharge)
        
        cashbackLimitText.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cashbackCharge.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        cashbackLimitText.keyboardType = .numberPad
        cashbackCharge.keyboardType = .numberPad
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        setupApi()
    }
    
    func setupApi() {
        
        scroll.isHidden = true
        loadingIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.setRegisterSettings(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
                
                DispatchQueue.main.async {
                    self.payCollection.reloadData()
                    self.regCollection.reloadData()
                }
            }
            else{
                print("Api Error")
                self.scroll.isHidden = false
                self.loadingIndicator.isAnimating = false
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
        
        setEBT(ebt: register?.ebt ?? "")
        setReg(reg: register?.regi_setting ?? "")
        
        let lockTime = register?.idel_logout ?? ""
        lockScreenText.text = lockTime
        
        let enable_cash = register?.enable_cashback_limit ?? ""
        
        if enable_cash == "1" {
            cashBackSwitch.isOn = true
            cashBackSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            cashBackSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        else {
            cashBackSwitch.isOn = false
            cashBackSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            cashBackSwitch.thumbTintColor = .white
        }
        
        cashbackLimitText.text = register?.cashback_limit_amount ?? ""
        cashbackCharge.text = register?.cashback_charge_amount ?? ""
    }
    
    func setEBT(ebt: String) {
        
        if ebt.contains("1") {
            food = true
        }
        else {
            food = false
        }
        
        if ebt.contains("2") {
            cash = true
        }
        else {
            cash = false
        }
        
        if ebt.contains("3") {
            gift = true
        }
        else {
            gift = false
        }
        
        if ebt.contains("4") {
            lottery = true
        }
        else {
            lottery = false
        }
        
        print(ebt)
    }
    
    func setReg(reg: String) {
        
        if reg.contains("1") {
            stock = true
        }
        else {
            stock = false
        }
        
        if reg.contains("5") {
            pin = true
        }
        else {
            pin = false
        }
        
        scroll.isHidden = false
        loadingIndicator.isAnimating = false
        
        if isUpdate {
            ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            isUpdate = false
        }
    }
    
    @objc func enableCashback(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            enableSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            enableSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        else {
            enableSwitch.isOn = false
            enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            enableSwitch.thumbTintColor = UIColor.white
        }
    }
    
    func checkCashBack() -> String {
        
        if cashBackSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let time = lockScreenText.text, time != "" else {
            lockScreenText.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        var ebt = ""
        
        if food {
            ebt = "1"
        }
        else {
            ebt = ""
        }
        
        if cash {
            
            if ebt == "1" {
                ebt = "1,2"
            }
            else {
                ebt = "2"
            }
        }
        
        if gift {
            
            if ebt == "1,2" {
                ebt = "1,2,3"
            }
            
            else if ebt == "1" {
                ebt = "1,3"
            }
            
            else if ebt == "2" {
                ebt = "2,3"
            }
            
            else {
                ebt = "3"
            }
        }
        
        if lottery {
            
            if ebt == "1,2" {
                ebt = "1,2,4"
            }
            
            else if ebt == "2,3" {
                ebt = "2,3,4"
            }
            
            else if ebt == "1,3" {
                ebt = "1,3,4"
            }
            
            else if ebt == "1,2,3" {
                ebt = "1,2,3,4"
            }
            
            else if ebt == "1" {
                ebt = "1,4"
            }
            
            else if ebt == "2" {
                ebt = "2,4"
            }
            
            else if ebt == "3" {
                ebt = "3,4"
            }
            
            else {
                ebt = "4"
            }
        }
        
        if ebt.contains("4") {
            UserDefaults.standard.set(true, forKey: "lottery_inventory")
        }
        else {
            UserDefaults.standard.set(false, forKey: "lottery_inventory")
        }
        
        var reg = ""
        
        if stock  {
            reg = "1"
        }
        
        if pin {
            
            if reg == "1" {
                reg = "1,5"
            }
            else {
                reg = "5"
            }
        }
        
        let cbenable = checkCashBack()
        
        let limit = cashbackLimitText.text ?? ""
        let charge = cashbackCharge.text ?? ""
        
        guard checkChangeGreaterThanLimit(limit: limit, charge: charge) else {
            chargeCheck = true
            cashbackCharge.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter cashback charge less than cashback limit",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            return
        }
        
        if chargeCheck {
            createCustomTextField(textField: cashbackCharge)
        }
        loadIndicator.isAnimating = true
        
        let barcode_msg = register?.barcode_msg ?? ""
        
        ApiCalls.sharedCall.updateRegisterSettings(merchant_id: id, regi_setting: reg,
                                                   idel_logout: time, ebt: ebt, cbenable: cbenable,
                                                   cblimit: limit, cbcharge: charge, barcode_msg: barcode_msg) { isSuccess, responseData in
            
            if isSuccess {
                
                let lock = self.lockScreenText.text ?? ""
                UserDefaults.standard.set(lock, forKey: "lock_screen")
                self.loadIndicator.isAnimating = false
                self.isUpdate = true
                self.setupApi()
            }
            
            else {
                self.loadIndicator.isAnimating = false
                self.isUpdate = false
            }
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension RegisterSettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == payCollection {
            payArray.count
        }
        else {
            regArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == payCollection {
            
            let cell = payCollection.dequeueReusableCell(withReuseIdentifier: "payregcell", for: indexPath) as! RegisterCollectionCell
            
            if indexPath.row == 0 {
                if food {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            if indexPath.row == 1 {
                if cash {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 {
                if gift {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 3 {
                if lottery {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.regLbl.text = payArray[indexPath.row]
            
            return cell
        }
        
        else {
            
            let cell = regCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RegisterCollectionCell
            
            if indexPath.row == 0 {
                if stock {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            
            if indexPath.row == 1 {
                if pin {
                    cell.regImage.image = UIImage(named: "check inventory")
                }
                else {
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
            }
            cell.regLbl.text = regArray[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! RegisterCollectionCell
                
        if collectionView == payCollection {

            if indexPath.row == 0 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    food = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    food = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
            
            else if indexPath.row == 1 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    cash = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    cash = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
            
            else if indexPath.row == 2 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    gift = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    gift = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
            
            else if indexPath.row == 3 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    lottery = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    lottery = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
        }
        
        else {
            
            if indexPath.row == 0 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    stock = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    stock = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
            
            else if indexPath.row == 1 {
                
                if cell.regImage.image == UIImage(named: "check inventory") {
                    pin = false
                    cell.regImage.image = UIImage(named: "uncheck inventory")
                }
                else {
                    pin = true
                    cell.regImage.image = UIImage(named: "check inventory")
                }
            }
        }
    }
}

extension RegisterSettingsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        return CGSize(width: width/2 - 10, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension RegisterSettingsViewController {
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        scrollView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: scrollView.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: scrollView.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        updateBt.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: updateBt.centerXAnchor, constant: 40),
            loadIndicator.centerYAnchor
                .constraint(equalTo: updateBt.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            print(cleanedAmount)
            if character.isNumber {
                cleanedAmount.append(character)
            }
            print(cleanedAmount)
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        if Double(cleanedAmount) ?? 00000 > 9999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        if textField.text == "000" {
            textField.text = ""
        }
    }
    
    func checkChangeGreaterThanLimit(limit: String, charge: String) -> Bool {
        
        let limit_doub = Double(limit) ?? 0.00
        let charge_doub = Double(charge) ?? 0.00
        
        if charge_doub <= limit_doub {
            return true
        }
        else {
            return false
        }
    }
    
    func setupShadow(view: UIView) {
        
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15).cgColor
        view.layer.shadowOffset = CGSize(width: 0 , height: 2)
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
}


struct Register_Settings {
    
    let id: String
    let device_name: String
    let merchant_id: String
    let cost_method: String
    let age_verify: String
    let by_scanning: String
    let inv_setting: String
    let cost_per: String
    let regi_setting: String
    let idel_logout: String
    let return_window: String
    let discount_prompt: String
    let round_invoice: String
    let customer_loyalty: String
    let barcode_msg: String
    let default_cash_drawer: String?
    let clock_in: String
    let hide_inactive: String
    let end_day_Allow: String
    let shift_assign: String
    let start_date: String
    let end_date: String
    let start_time: String
    let end_time: String
    let report_history: String
    let emp_permission: String
    let no_of_station: String
    let denomination: String
    let ebt: String
    let enable_cashback_limit: String
    let cashback_limit_amount: String
    let cashback_charge_amount: String
    let enable_autolock_transaction: String
}

struct Update_Register_Settings {
    
    
    let merchant_id: String
    let regi_setting: String
    let idel_logout: String
    let return_window: String
    let discount_prompt: String
    let round_invoice: String
    let customer_loyalty: String
    let ebt: String
}
