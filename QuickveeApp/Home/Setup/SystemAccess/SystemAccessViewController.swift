//
//  SystemAccessViewController.swift
//  
//
//  Created by Pallavi on 11/06/24.
//

import UIKit
import MaterialComponents
import DropDown

class SystemAccessViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cashDrawerStart: MDCOutlinedTextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var stationName: MDCOutlinedTextField!
    @IBOutlet weak var endOfDayAllow: MDCOutlinedTextField!
    @IBOutlet weak var shiftAssign: MDCOutlinedTextField!
    
    @IBOutlet weak var eodBtn: UIButton!
    @IBOutlet weak var shiftBtn: UIButton!
    
    @IBOutlet weak var startTime: MDCOutlinedTextField!
    @IBOutlet weak var endTime: MDCOutlinedTextField!
    
    @IBOutlet weak var stationBottom: NSLayoutConstraint!
    
    @IBOutlet weak var denoBtn: UIButton!
    @IBOutlet weak var denoLbl: UILabel!
    
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var stationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var yestStartBtn: UIButton!
    @IBOutlet weak var yestStartLbl: UILabel!
    
    @IBOutlet weak var todayStartBtn: UIButton!
    @IBOutlet weak var todayStartLbl: UILabel!
    
    @IBOutlet weak var todayEndBtn: UIButton!
    @IBOutlet weak var todayEndLbl: UILabel!
    
    @IBOutlet weak var tomEndBtn: UIButton!
    @IBOutlet weak var tomEndLbl: UILabel!
    
    
    let eodmenu = DropDown()
    let shiftmenu = DropDown()
    private var isSymbolOnRight = false
    var no_station = ""
    
    var activeTextField = UITextField()
    
    var eod = ["Deny if staff clocked in", "Mass clock out staff clocked in", "Ignore Time Clock"]
    var shift = ["Don't Track Shifts", "Track Shifts By Cashier", "Track Shifts By Station"]

    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        cashDrawerStart.label.text = "Default Cash Drawer Start"
        endOfDayAllow.label.text = "End of Day Allowance"
        shiftAssign.label.text = "Shift Assignment"
        stationName.label.text = "Station Name"
        
        startTime.label.text = "Start Time"
        endTime.label.text = "End Time"
        
        updateBtn.layer.cornerRadius = 10
        
        createCustomTextField(textField: cashDrawerStart)
        createCustomTextField(textField: endOfDayAllow)
        createCustomTextField(textField: shiftAssign)
        createCustomTextField(textField: stationName)
        createCustomTextField(textField: startTime)
        createCustomTextField(textField: endTime)
        
        startTime.delegate = self
        endTime.delegate = self
        
        cashDrawerStart.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cashDrawerStart.keyboardType = .numberPad
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(denoLblClick))
        denoLbl.addGestureRecognizer(tap1)
        denoLbl.isUserInteractionEnabled = true
        tap1.numberOfTapsRequired = 1
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(yestStartLblClick))
        yestStartLbl.addGestureRecognizer(tap2)
        yestStartLbl.isUserInteractionEnabled = true
        tap2.numberOfTapsRequired = 1
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(todayStartLblClick))
        todayStartLbl.addGestureRecognizer(tap3)
        todayStartLbl.isUserInteractionEnabled = true
        tap3.numberOfTapsRequired = 1
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(todayEndLblClick))
        todayEndLbl.addGestureRecognizer(tap4)
        todayEndLbl.isUserInteractionEnabled = true
        tap4.numberOfTapsRequired = 1
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tomEndLblClick))
        tomEndLbl.addGestureRecognizer(tap5)
        tomEndLbl.isUserInteractionEnabled = true
        tap5.numberOfTapsRequired = 1
        
        setupMenu()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        checkEndShift()
        getRegisterSettings()
    }
    
    func setupMenu() {
        
        eodmenu.dataSource = eod
        eodmenu.textFont = UIFont(name: "Manrope-SemiBold", size: 13.0)!
        eodmenu.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = eodBtn
        eodmenu.anchorView = eodBtn
        
        eodmenu.selectionAction = { index, title in
            self.endOfDayAllow.text = title
            self.eodmenu.deselectRow(index)
        }
        
        shiftmenu.dataSource = shift
        shiftmenu.textFont = UIFont(name: "Manrope-SemiBold", size: 13.0)!
        shiftmenu.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = shiftBtn
        shiftmenu.anchorView = shiftBtn
        
        shiftmenu.selectionAction = { index, title in
            self.shiftAssign.text = title
            self.shiftmenu.deselectRow(index)
            
            if index == 0 {
                
                self.stationHeight.constant = 53
                self.stationName.isHidden = false
                self.stationBottom.constant = 20
                self.stationName.label.text = ""
                self.stationName.text = self.no_station
            }
            else if index == 1 {
                
                self.stationHeight.constant = 0
                self.stationName.isHidden = true
                self.stationBottom.constant = 0
                self.stationName.label.text = ""
                self.stationName.text = ""
            }
            else {
                
                self.stationHeight.constant = 53
                self.stationName.isHidden = false
                self.stationBottom.constant = 20
                self.stationName.label.text = "Station Name"
                self.stationName.text = self.no_station
            }
        }
    }
    
    func checkEndShift() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.checkEndShift(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                let res = responseData["status"] as! Bool
                let resmsg = responseData["msg"] as! String
                
                if res {
                    self.shiftBtn.isHidden = true
                }
                
                else {
                    self.shiftAssign.backgroundColor = UIColor(named: "Disabled Text")
                    self.shiftBtn.isHidden = false
                }
                
            }
            
            else {
            }
        }
    }
    
    func getRegisterSettings() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.setRegisterSettings(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
            }
            
            else {
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let reg = response as! [String:Any]
        
        let register = Register_Settings(id: "\(reg["id"] ?? "")", 
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
                                         emp_permission: "\(reg["emp_permission"] ?? "")",
                                         no_of_station: "\(reg["no_of_station"] ?? "")", 
                                         denomination: "\(reg["denomination"] ?? "")",
                                         ebt: "\(reg["ebt"] ?? "")",
                                         enable_cashback_limit: "\(reg["enable_cashback_limit"] ?? "")",
                                         cashback_limit_amount: "\(reg["cashback_limit_amount"] ?? "")",
                                         cashback_charge_amount: "\(reg["cashback_charge_amount"] ?? "")",
                                         enable_autolock_transaction: "\(reg["enable_autolock_transaction"] ?? "")")
        
        setSystemAccess(reg: register)
    }
    
    func setSystemAccess(reg: Register_Settings) {
        
        if reg.default_cash_drawer != "" && reg.default_cash_drawer != "<null>" {
            
            cashDrawerStart.text = reg.default_cash_drawer
        }
        else {
            cashDrawerStart.text = "0.00"
        }
        
        
        if reg.denomination == "0" {
            denoBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else {
            denoBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        if reg.end_day_Allow == "1" {
            
            endOfDayAllow.text = eod[0]
        }
        
        else if reg.end_day_Allow == "2" {
            endOfDayAllow.text = eod[1]
        }
        
        else {
            endOfDayAllow.text = eod[2]
        }
        
        no_station = reg.no_of_station
        
        if reg.shift_assign == "1" {
            shiftAssign.text = shift[0]
            stationHeight.constant = 53
            stationName.isHidden = false
            stationBottom.constant = 20
            stationName.label.text = ""
            stationName.text = no_station
        }
        else if reg.shift_assign == "2" {
            shiftAssign.text = shift[1]
            stationHeight.constant = 0
            stationName.isHidden = true
            stationBottom.constant = 0
            stationName.label.text = ""
            stationName.text = ""
        }
        
        else {
            shiftAssign.text = shift[2]
            stationHeight.constant = 53
            stationName.isHidden = false
            stationBottom.constant = 20
            stationName.label.text = "Station Name"
            stationName.text = no_station
        }
        
        
        if reg.start_date == "1" {
            yestStartBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            todayStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
        
        else {
            yestStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
            todayStartBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }
        
        let start = reg.start_time
        let final_start = String(start.dropLast(3))
        startTime.text = final_start
        
        if reg.end_date == "1" {
            todayEndBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            tomEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
        
        else {
            todayEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
            tomEndBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        }
        
        let end = reg.end_time
        let final_end = String(end.dropLast(3))
        endTime.text = final_end
    }
    
    
    @IBAction func denoBtnClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "check inventory") {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        else {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
        }
    }
    
    @objc func denoLblClick() {
        
        if denoBtn.currentImage == UIImage(named: "check inventory") {
            denoBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        else {
            denoBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        }
    }
    
    
    @IBAction func yestStartClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "unselect_radio") {
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            todayStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    @objc func yestStartLblClick() {
        
        if yestStartBtn.currentImage == UIImage(named: "unselect_radio") {
            yestStartBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            todayStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    
    @IBAction func todayStartClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "unselect_radio") {
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            yestStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    @objc func todayStartLblClick() {
        
        if todayStartBtn.currentImage == UIImage(named: "unselect_radio") {
            todayStartBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            yestStartBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    
    @IBAction func todayEndClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "unselect_radio") {
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            tomEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    @objc func todayEndLblClick() {
        
        if todayEndBtn.currentImage == UIImage(named: "unselect_radio") {
            todayEndBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            tomEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    
    @IBAction func tomEndClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "unselect_radio") {
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            todayEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    @objc func tomEndLblClick() {
        
        if tomEndBtn.currentImage == UIImage(named: "unselect_radio") {
            tomEndBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            todayEndBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        }
    }
    
    func checkEOD() -> String {
        
        if endOfDayAllow.text == eod[0] {
            return "1"
        }
        
        else if endOfDayAllow.text == eod[1] {
            return "2"
        }
        
        else {
            return "3"
        }
    }
    
    func checkShift() -> String {
        
        if shiftAssign.text == shift[0] {
            return "1"
        }
        
        else if shiftAssign.text == shift[1] {
            return "2"
        }
        
        else {
            return "3"
        }
        
    }
    
    func checkDeno() -> Int {
        
        if denoBtn.currentImage == UIImage(named: "check inventory") {
            return 1
        }
        else {
            return 0
        }
    }
    
    func checkSDate() -> String {
        
        if yestStartBtn.currentImage == UIImage(named: "select_radio") {
            return "1"
        }
        else {
            return "2"
        }
        
    }
    
    func checkEDate() -> String {
        
        if todayEndBtn.currentImage == UIImage(named: "select_radio") {
            return "1"
        }
        else {
            return "2"
        }
    }
    
    
    
    @IBAction func eodBtnClick(_ sender: UIButton) {
        
        view.endEditing(true)
        eodmenu.deselectRows(at: [0,1,2])
        eodmenu.show()
    }
    
    
    @IBAction func shiftBtnClick(_ sender: UIButton) {
        
        view.endEditing(true)
        shiftmenu.deselectRows(at: [0,1,2])
        shiftmenu.show()
    }
    
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        loadIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let drawer = cashDrawerStart.text ?? ""
        
        let endDay = checkEOD()
        
        let shift = checkShift()
        
        let station = stationName.text ?? ""
        
        let deno = checkDeno()
        
        let start_date = checkSDate()
        
        let end_date = checkEDate()
        
        let start_time = startTime.text ?? ""
        
        let end_time = endTime.text ?? ""
        
        
        
        ApiCalls.sharedCall.updateSystemAccess(merchant_id: id, default_cash_drawer: drawer,
                                               clock_in: "", hide_inactive: "", end_day_Allow: endDay,
                                               shift_assign: shift, start_date: start_date, end_date: end_date,
                                               start_time: start_time, end_time: end_time, adv_id: "",
                                               station_name: "", no_of_station: station,
                                               denomination: deno) { isSuccess, responseData in
            
            if isSuccess {
                
                self.loadIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                self.loadIndicator.isAnimating = false
            }
        }
    }
}

extension SystemAccessViewController {
    
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        updateBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: updateBtn.centerXAnchor, constant: 40),
            loadIndicator.centerYAnchor
                .constraint(equalTo: updateBtn.centerYAnchor),
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
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if activeTextField == startTime || activeTextField == endTime {
            openDatePicker(textField: activeTextField)
        }
    }
    
    func openDatePicker(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        datePicker.datePickerMode = .time
        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
        
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
    
    @objc func timeDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField == startTime {
                checkStartTime(time: datePicker.date)
            }
            else {
                checkEndTime(time: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    @objc func cancel(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    func checkStartTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm aa"
        let starttime = dateFormat.string(from: time)
        
        let start = starttime.suffix(2)
        
        if start == "AM" {
            
            dateFormat.dateFormat = "hh:mm"
            activeTextField.text = "\(dateFormat.string(from: time))"
            
            if todayStartBtn.currentImage == UIImage(named: "select_radio") && todayEndBtn.currentImage == UIImage(named: "select_radio") {
                endTime.text = ""
            }
        }
        
        else if start == "PM" {
            
            let hours = starttime.prefix(2)
            let hoursInt = Int(hours)!
            
            dateFormat.dateFormat = ":mm"
            let hour = hoursInt + 12
            activeTextField.text = "\(hour)\(dateFormat.string(from: time))"
            
            if todayStartBtn.currentImage == UIImage(named: "select_radio") && todayEndBtn.currentImage == UIImage(named: "select_radio") {
                endTime.text = ""
            }
        }
        
        else {
            
            dateFormat.dateFormat = "hh:mm"
            activeTextField.text = "\(dateFormat.string(from: time))"
            
            if todayStartBtn.currentImage == UIImage(named: "select_radio") && todayEndBtn.currentImage == UIImage(named: "select_radio") {
                endTime.text = ""
            }
        }
    }
    
    func checkEndTime(time: Date) {
        
        if startTime.text == "" {
            showAlert(title: "Alert", message: "Start Time not set, Please set a start time first.")
        }
        else {
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm aa"
            let starttime = dateFormat.string(from: time)
            let start = starttime.suffix(2)
            
            if start == "AM" {
                
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = "\(dateFormat.string(from: time))"
            }
            
            else if start == "PM" {
                
                let hours = starttime.prefix(2)
                let hoursInt = Int(hours)!
                
                dateFormat.dateFormat = ":mm"
                let hour = hoursInt + 12
                activeTextField.text = "\(hour)\(dateFormat.string(from: time))"
            }
            
            else {
                
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = "\(dateFormat.string(from: time))"
            }
        }
    }
}

