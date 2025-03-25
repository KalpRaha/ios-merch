//
//  CreateBonusViewController.swift
//
//
//  Created by Pallavi on 11/06/24.
//

import UIKit
import MaterialComponents

class CreateBonusViewController: UIViewController {
    
    
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var bonusPointInfo: MDCOutlinedTextField!
    @IBOutlet weak var bonusSpend: MDCOutlinedTextField!
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var mode = ""
    var promotion_id = ""
    var current = ""
    var addClick = true
    
    var isSymbolOnRight = false
    var activeTextField = UITextField()
    var switchEnabled = ""
    
    var namePromo = [String]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        createCustomTextField(textField: bonusPointInfo)
        createCustomTextField(textField: bonusSpend)
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        
        bonusPointInfo.autocapitalizationType = .words
        
        bonusSpend.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        bonusSpend.keyboardType = .numberPad
        
        bonusPointInfo.label.text = "Bonus Point Promotion Name"
        bonusPointInfo.addTarget(self, action: #selector(updateText), for: .editingChanged)
        bonusSpend.label.text = "$1 = "
        startDate.label.text = "Start Date"
        endDate.label.text = "End Date"
        
        enableSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        enableSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        
        startDate.delegate = self
        endDate.delegate = self
        bonusPointInfo.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        applyBtn.isEnabled = true
        enableSwitch.isOn = false
        enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
        enableSwitch.thumbTintColor = .white
        
        if mode == "edit" {
            
            titleLbl.text = "Edit Loyalty"
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            ApiCalls.sharedCall.getBonusById(merchant_id: id, promotion_id: promotion_id) { isSuccess, responseData in
                
                if isSuccess {
                    
                    self.getResponseValues(response: responseData["promotion_array"])
                }
                else{
                    print("Api Error")
                }
            }
            
            applyBtn.setTitle("Update", for: .normal)
            deleteBtn.setTitle("Delete", for: .normal)
            
            deleteBtn.layer.borderColor = UIColor(hexString: "#F55353").cgColor
            deleteBtn.setTitleColor(UIColor(hexString: "#F55353"), for: .normal)
            deleteBtn.layer.borderWidth = 1.0
            
            bonusPointInfo.backgroundColor = UIColor(named: "Disabled Text")
            
            innerView.isHidden = false
        }
        
        else {
            
            titleLbl.text = "Add Loyalty"
            applyBtn.setTitle("Add", for: .normal)
            deleteBtn.setTitle("Cancel", for: .normal)
            
            deleteBtn.layer.borderColor = UIColor.black.cgColor
            deleteBtn.setTitleColor(.black, for: .normal)
            deleteBtn.layer.borderWidth = 1.0
            
            innerView.isHidden = true
        }
        applyBtn.layer.cornerRadius = 10
        deleteBtn.layer.cornerRadius = 10
    }
    
    
    func getResponseValues(response: Any) {
        
        print(response)
        
        let bonus_points = response as! [String:Any]
        
        let bonus = Bonus_Points(promotion_id: "\(bonus_points["promotion_id"] ?? "")",
                                 enable_promotion: "\(bonus_points["enable_promotion"] ?? "")",
                                 promotion_name: "\(bonus_points["promotion_name"] ?? "")",
                                 current_points: "\(bonus_points["current_points"] ?? "")",
                                 bonus_points: "\(bonus_points["bonus_points"] ?? "")",
                                 start_date: "\(bonus_points["start_date"] ?? "")",
                                 end_date: "\(bonus_points["end_date"] ?? "")")
        
        bonusPointInfo.text = bonus.promotion_name
        bonusSpend.text = bonus.bonus_points
        
        let start_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: bonus.start_date)
        print(start_date)
        startDate.text = start_date
      
        let end_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: bonus.end_date)
        endDate.text = end_date
       
        startDate.text = start_date
       // bonus.start_date
        endDate.text = end_date
       // bonus.end_date
       
        current = bonus.current_points
        
        let enable = bonus.enable_promotion
        setEnable(enable: enable)
        
    }
    
    func setEnable(enable: String) {
        
        if enable == "1" {
            enableSwitch.isOn = true
            switchEnabled = "1"
            enableSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            enableSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        
        else {
            enableSwitch.isOn = false
            switchEnabled = "0"
            enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            enableSwitch.thumbTintColor = .white
        }
    }
  
    @objc func switchChange(enableSwitch: UISwitch) {
        
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            switchEnabled = "1"
            enableSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            enableSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        else {
            enableSwitch.isOn = false
            switchEnabled = "0"
            enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            enableSwitch.thumbTintColor = .white
        }
    }
    
    func checkSwitch() -> String {
        
        if switchEnabled == "1" {
            return "1"
        }
        else {
            return  "0"
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
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if sender.currentTitle == "Delete" {
            
            if UserDefaults.standard.bool(forKey: "delete_bonus_points") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                
                getResponseDeleteValues()
            }
        }
        
        else {
            navigationController?.popViewController(animated: true)
        }
    }
  
    @IBAction func applyBtnClick(_ sender: UIButton) {
        
        if sender.currentTitle == "Add" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            }
            
            if sender.currentTitle == "Add" {
                guard addClick else {
                    return
                }
            }
            addClick = false
            loadingIndicator.isAnimating = true
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            var promo_id = ""
            
            if sender.currentTitle == "Add" {
                
                promo_id = ""
            }
            
            else {
                promo_id = promotion_id
            }
            
            guard let name = bonusPointInfo.text, name != "" else {
                bonusPointInfo.isError(numberOfShakes: 3, revert: true)
                loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Enter Promotion Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                addClick = true
                return
            }
            
            if sender.currentTitle == "Add" {
                guard !namePromo.contains(name) else {
                    bonusPointInfo.isError(numberOfShakes: 3, revert: true)
                    loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Duplicate Promotion Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    addClick = true
                    return
                }
            }
            
            guard let bonus = bonusSpend.text, bonus != "" else {
                bonusSpend.isError(numberOfShakes: 3, revert: true)
                loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Enter Bonus Point Awarded", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                addClick = true
                return
            }
            
            guard let start = startDate.text, start != "" else {
                startDate.isError(numberOfShakes: 3, revert: true)
                loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Enter Start Date", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                addClick = true
                return
            }
            
            guard let end = endDate.text, end != "" else {
                endDate.isError(numberOfShakes: 3, revert: true)
                loadingIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Enter End Date", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                addClick = true
                return
            }
            
            print(start)
            print(end)
            
            
           // setCouponlistDate
            let sdate = ToastClass.sharedToast.setCouponlistDate(dateStr: start)
            print(sdate)
            
            let edate = ToastClass.sharedToast.setCouponlistDate(dateStr: end)
            print(edate)
            
            ApiCalls.sharedCall.updateBonus(merchant_id: id, promotion_id: promo_id, admin_id: "",
                                            enable_promotion: checkSwitch(), current_points: current,
                                            promotion_name: name, bonus_points: bonus,
                                            start_date: sdate, end_date: edate) { isSuccess, responseData in
                
                if isSuccess {
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Bonus Point Promotion Created Successfully",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.navigationController?.popViewController(animated: true)
                }
                
                else {
                    self.loadingIndicator.isAnimating = false
                }
            }
        }
        
        else {
            
            if UserDefaults.standard.bool(forKey: "edit_bonus_points") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
                
                if sender.currentTitle == "Add" {
                    guard addClick else {
                        return
                    }
                }
                addClick = false
                loadingIndicator.isAnimating = true
                
                let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                var promo_id = ""
                
                if sender.currentTitle == "Add" {
                    
                    promo_id = ""
                }
                
                else {
                    promo_id = promotion_id
                }
                
                guard let name = bonusPointInfo.text, name != "" else {
                    bonusPointInfo.isError(numberOfShakes: 3, revert: true)
                    loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Enter Promotion Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    addClick = true
                    return
                }
                
                if sender.currentTitle == "Add" {
                    guard !namePromo.contains(name) else {
                        bonusPointInfo.isError(numberOfShakes: 3, revert: true)
                        loadingIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: "Duplicate Promotion Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        addClick = true
                        return
                    }
                }
                
                guard let bonus = bonusSpend.text, bonus != "" else {
                    bonusSpend.isError(numberOfShakes: 3, revert: true)
                    loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Enter Bonus Point Awarded", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    addClick = true
                    return
                }
                
                guard let start = startDate.text, start != "" else {
                    startDate.isError(numberOfShakes: 3, revert: true)
                    loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Enter Start Date", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    addClick = true
                    return
                }
                
                guard let end = endDate.text, end != "" else {
                    endDate.isError(numberOfShakes: 3, revert: true)
                    loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Enter End Date", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    addClick = true
                    return
                }
                
                let sdate = ToastClass.sharedToast.setCouponlistDate(dateStr: start)
                print(sdate)
                
                let edate = ToastClass.sharedToast.setCouponlistDate(dateStr: end)
                print(edate)
                
                
                
                
                ApiCalls.sharedCall.updateBonus(merchant_id: id, promotion_id: promo_id, admin_id: "",
                                                enable_promotion: checkSwitch(), current_points: current,
                                                promotion_name: name, bonus_points: bonus,
                                                start_date: sdate, end_date: edate) { isSuccess, responseData in
                    
                    if isSuccess {
                        self.loadingIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: "Bonus Point Promotion Created Successfully",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    else {
                        self.loadingIndicator.isAnimating = false
                    }
                }
            }
        }
    }
    
    func getResponseDeleteValues() {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this promotion?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            self.loadIndicator.isAnimating = true
            
            ApiCalls.sharedCall.deleteBonusPoint(merchant_id: id,
                                                 promotion_id: self.promotion_id) { isSuccess, responseData in
                
                if isSuccess {
                    
                    self.loadIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "Bonus Point Promotion deleted successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    print("Api Error")
                    self.loadIndicator.isAnimating = false
                }
            }
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        
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
        
        if Double(cleanedAmount) ?? 00000 > 99999999 {
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

extension CreateBonusViewController: UITextFieldDelegate {
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        applyBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: applyBtn.centerXAnchor, constant: 35),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: applyBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        
        deleteBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: deleteBtn.centerXAnchor, constant: 40),
            loadIndicator.centerYAnchor
                .constraint(equalTo: deleteBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == startDate || textField == endDate {
            activeTextField = textField
            openDatePicker(textField: activeTextField, tag: activeTextField.tag)
        }
        
        else if textField == bonusPointInfo {
            activeTextField = textField
        }
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == bonusPointInfo {
            
            if updatetext.count > 15 {
                updatetext = String(updatetext.dropLast())
            }
            
            activeTextField.text = updatetext
        }
    }
    
    
    func openDatePicker(textField: UITextField, tag: Int) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        datePicker.datePickerMode = .date
        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
    
    @objc func cancel(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func dateDoneBtn() {
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField.tag == 1 {
                checkStartDate(date: datePicker.date)
            }
            else {
                checkEndDate(date: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    func checkStartDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        let calendar = Calendar.current
        let dateToday = Date()
        let currentDay = calendar.component(.day, from: dateToday)
        let currentMonth = calendar.component(.month, from: dateToday)
        let currentYear = calendar.component(.year, from: dateToday)
        
        let startDay = calendar.component(.day, from: date)
        let startMonth = calendar.component(.month, from: date)
        let startYear = calendar.component(.year, from: date)
        
        if startYear < currentYear {
            
            showAlert(title: "Alert", message: "Start date should be greater than current date")
        }
        
        else if startYear == currentYear {
            
            if startMonth < currentMonth {
                
                showAlert(title: "Alert", message: "Start date should be greater than current date")
            }
            
            else if startMonth >= currentMonth {
                
                if startDay < currentDay {
                    
                    showAlert(title: "Alert", message: "Start date should be greater than current date")
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    endDate.text = ""
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        if startDate.text == "" {
            showAlert(title: "Alert", message: "Please enter start date first")
        }
        else {
            let startDateCheck = dateFormat.date(from: startDate.text!)
            
            let calendar = Calendar.current
            
            let startDay = calendar.component(.day, from: startDateCheck!)
            let startMonth = calendar.component(.month, from: startDateCheck!)
            let startYear = calendar.component(.year, from: startDateCheck!)
            
            let endDay = calendar.component(.day, from: date)
            let endMonth = calendar.component(.month, from: date)
            let endYear = calendar.component(.year, from: date)
            
            if endYear < startYear {
                
                showAlert(title: "Alert", message: "End date should be greater than Start date")
            }
            
            else if endYear == startYear {
                
                if endMonth < startMonth {
                    
                    showAlert(title: "Alert", message: "End date should be greater than Start date")
                }
                
                else if endMonth == startMonth {
                    
                    if endDay < startDay {
                        
                        showAlert(title: "Alert", message: "End date should be greater than Start date")
                    }
                    
                    else {
                        activeTextField.text = dateFormat.string(from: date)
                    }
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}



struct Bonus_Points {
    
    let promotion_id: String
    let enable_promotion: String
    let promotion_name: String
    let current_points: String
    let bonus_points: String
    let start_date: String
    let end_date: String
}
