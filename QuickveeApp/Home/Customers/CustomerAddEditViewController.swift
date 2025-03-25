//
//  CustomerAddEditViewController.swift
//
//
//  Created by Jamaluddin Syed on 30/08/24.
//

import UIKit
import MaterialComponents
import DropDown

class CustomerAddEditViewController: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var scroll: UIView!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var fname: MDCOutlinedTextField!
    @IBOutlet weak var lname: MDCOutlinedTextField!
    
    @IBOutlet weak var mobileField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    
    @IBOutlet weak var dobField: MDCOutlinedTextField!
    @IBOutlet weak var address: MDCOutlinedTextField!
    
    @IBOutlet weak var suiteField: MDCOutlinedTextField!
    @IBOutlet weak var cityField: MDCOutlinedTextField!
    
    @IBOutlet weak var stateField: MDCOutlinedTextField!
    @IBOutlet weak var zipField: MDCOutlinedTextField!
    
    @IBOutlet weak var notesField: MDCOutlinedTextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var StateDropDownBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    
    let menu = DropDown()
    
    var mode = ""
    var custObj: FindCustModel?
    var custId = ""
    
    
    var focusType: FocusType?
    
    var activeTextField = UITextField()
    
    let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(custObj)
        setupMenu()
        topview.addBottomShadow()
        
        createCustomTextField(textField: fname)
        createCustomTextField(textField: lname)
        createCustomTextField(textField: mobileField)
        createCustomTextField(textField: emailField)
        createCustomTextField(textField: dobField)
        createCustomTextField(textField: address)
        createCustomTextField(textField: suiteField)
        createCustomTextField(textField: cityField)
        createCustomTextField(textField: stateField)
        createCustomTextField(textField: zipField)
        createCustomTextField(textField: notesField)
        
        fname.label.text = "First Name*"
        lname.label.text = "Last Name"
        mobileField.label.text = "Mobile No*"
        emailField.label.text = "Email Address*"
        dobField.label.text = "Date of Birth"
        address.label.text = "Address Line 1"
        suiteField.label.text = "Suite/Apt#"
        cityField.label.text = "City"
        stateField.label.text = "Select State"
        zipField.label.text = "Zip Code"
        notesField.label.text = "Notes"
        
        fname.autocapitalizationType = .words
        
        dobField.delegate = self
        fname.delegate = self
        lname.delegate = self
        suiteField.delegate = self
        mobileField.delegate = self
        emailField.delegate = self
        stateField.delegate = self
        address.delegate = self
        cityField.delegate = self
        zipField.delegate = self
        
        fname.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        lname.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        suiteField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        mobileField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        emailField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        stateField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        address.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cityField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        zipField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        emailField.keyboardType = .emailAddress
        mobileField.keyboardType = .numberPad
        zipField.keyboardType = .numberPad
        
        saveBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        stateField.trailingView = imageView
        stateField.trailingViewMode = .always
        
        let startDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startDateImage.image = UIImage(named: "date_picker")
        self.dobField.trailingView = startDateImage
        self.dobField.trailingViewMode = .always
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollHeight.constant = 700
        setupUI()
        setMode()
        
    }
    
    
    func setMode() {
        print(custObj?.name)
        
        if mode == "add" {
            saveBtn.setTitle("Add", for: .normal)
            titleLbl.text = "Add Customer"
            
        }
        else {
            saveBtn.setTitle("Save", for: .normal)
            titleLbl.text = "Edit Customer"
            setFocusField()
            // dobFormatter()
            let fName = custObj?.f_name ?? ""
            let lastName = custObj?.l_name ?? ""
            
            fname.text = fName
            lname.text = lastName
            
            
//            let nameComponents = fullName?.split(separator: " ")
//            print(nameComponents)
            
            
//            if let nameComponents = nameComponents, nameComponents.count >= 2 {
//                print(nameComponents)
//                let firstName = String(nameComponents[0])
//                let lastName = String(nameComponents[1])
//                print(firstName)
//                
//                fname.text = firstName
//                lname.text = lastName
//            } else {
//                fname.text = custObj?.name
//                lname.text = ""
//            }
           
            mobileField.text = custObj?.phone
            emailField.text = custObj?.email
            emailField.isEnabled = false
            emailField.alpha = 0.5
            
            let suite = custObj?.address_line_2 ?? ""
            print(suite)
            if suite != "null" && suite != "" && suite != "<null>" {
                suiteField.text = suite
            }
            else {
                suiteField.text = ""
            }
            
            let city = custObj?.city ?? ""
            if city != "<null>"  && city != ""{
                cityField.text = city
            }
            else {
                cityField.text = ""
            }
            
            let zip = custObj?.pincode ?? ""
            if zip != "<null>" && zip != "" {
                zipField.text = zip
            } else {
                zipField.text = ""
            }
            
            let addressLine1 = custObj?.address_line_1 ?? ""
            if addressLine1 != ""  && addressLine1 != "<null>" {
                address.text = addressLine1
            } else {
                address.text = ""
            }
            
            let note = custObj?.note ?? ""
            if note != ""  && note != "<null>" {
                notesField.text = note
            } else {
                notesField.text = ""
            }
            
            let dob = custObj?.dob
            
            if dob != "<null>" && dob != "0000-00-00 00:00:00" {
                
                let ddd = ToastClass.sharedToast.setStockDateFormat(dateStr: dob ?? "")
                print(ddd)
                
                let date = dob?.split(separator: " ")
                var b_Date = String(date?.first ?? "")
                dobField.text = ddd
            }
            else {
                dobField.text = ""
            }
            
            
//            if let dob = custObj?.dob, dob != "<null>" && dob != "0000-00-00 00:00:00" {
//                let inputFormatter = DateFormatter()
//                inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Input format of `dob`
//                
//                let outputFormatter = DateFormatter()
//                outputFormatter.dateFormat = "MM/dd/yyyy" // Desired output format
//
//                if let date = inputFormatter.date(from: dob) {
//                    let formattedDOB = outputFormatter.string(from: date)
//                    bdate = formattedDOB
//                    isbirth = true
//                } else {
//                    print("Invalid")
//                }
//            } else {
//                print("nil")
//            }
            
            let state = custObj?.state ?? ""
            if state != ""  && state != "<null>" {
                stateField.text = state
            } else {
                stateField.text = ""
            }
        }
        
    }
   
    private func setFocusField() {
        switch focusType {
        case .address:
            address.becomeFirstResponder()
        case .dob:
            dobField.becomeFirstResponder()
        case .note:
            notesField.becomeFirstResponder()
        case .none:
            break
        }
    }
  
    func setupMenu() {
        
        menu.dataSource = states
        menu.backgroundColor = .white
        menu.anchorView = StateDropDownBtn
        menu.separatorColor = .black
        menu.layer.cornerRadius = 10.0
        menu.selectionAction = { index, title in
            self.stateField.text = title
            self.menu.deselectRow(at: index)
        }
        
    }
    
    
    @IBAction func SelectStateBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        menu.show()
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if mode == "Add" {
            custId = ""
            addCustomerAPiCall()
        }
        else {
            custId = custObj?.customer_id ?? ""
            addCustomerAPiCall()
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
 
    
    func addCustomerAPiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
       // let nameRegex = "^[a-zA-Z ]+$"
        
        guard let name = fname.text, name != "" else {
            fname.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter title", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let lnameText = lname.text  else {
            lname.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter a valid last name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let email = emailField.text, email != "" else {
            emailField.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter email Address", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let mobile = mobileField.text, mobile != "", mobile.count == 10 else {
            mobileField.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter mobile number", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        
        let dob = dobField.text ?? ""
        print(dob)
        let db = ToastClass.sharedToast.setCouponlistDate(dateStr: dob)
        print(db)
        
        let addressLine1 = address.text ?? ""
        let city = cityField.text ?? ""
        let state = stateField.text ?? ""
        let notes = notesField.text ?? ""
        let suits = suiteField.text ?? ""
        let zip = zipField.text ?? ""
        
        print(notes)
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addCustomersAPICall(merchant_id: id, fname: name, lname: lnameText,
                                                email: email, phone_no: mobile, address_line_1: addressLine1,
                                                address_line_2: suits, state: state, city: city,
                                                pincode: zip, dob: db, notes: notes,
                                                customer_id: custId, order_id: "",
                                                note: notes) { isSuccess, responseData in
            
            
            
            if isSuccess {
                let list = responseData["message"] as! String
                print(list)
                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.loadingIndicator.isAnimating = false
                if list == "Customer Email ID is already exist." {
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                print("API error")
            }
        }
        
    }
   
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 15.0)
        textField.setOutlineColor(border, for: .normal)
        textField.setOutlineColor(border, for: .editing)
        textField.setNormalLabelColor(border, for: .normal)
        textField.setNormalLabelColor(border, for: .editing)
        textField.setFloatingLabelColor(border, for: .normal)
        textField.setFloatingLabelColor(border, for: .editing)
        textField.setTextColor(.black, for: .normal)
        textField.setTextColor(.black, for: .editing)
    }
    
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == fname || textField == lname {
            
            if updatetext.count == 31 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count == 1{
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == suiteField {
            
            if updatetext.count == 30 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count == 1{
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == mobileField {
            
            if updatetext.count == 11 {
                updatetext = String(updatetext.dropLast())
            }
            else if updatetext.count == 10 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == emailField {
            
            if updatetext.count > 0 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
            
        }
        
        else if textField == address {
            
            if updatetext.count == 151 {
                updatetext = String(updatetext.dropLast())
            }
            else if updatetext.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
            
        }
        
        else if textField == cityField {
            
            if updatetext.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
            
        }
        
        else if textField == stateField {
            print(textField.text!)
            if textField.text != "" {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == zipField {
            
            if updatetext.count == 6 {
                updatetext = String(updatetext.dropLast())
            }
            else if updatetext.count == 5 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        activeTextField.text = updatetext
    }
    
    
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        saveBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
    }
}


extension CustomerAddEditViewController {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if textField == dobField {
            openDatePicker(textField: dobField)
        }
   
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        
        if textField == fname {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
           
            
            return (string == filtered)
        }
        else if textField == lname {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        else {
            return true
        }
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fname {
            fname.text = textField.text?.trimmingCharacters(in: .whitespaces)
        }
    }
    
    
    func openDatePicker(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        dobField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        toolbar.barStyle = .default
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateBtnClick))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDateBtnClick))
        
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        dobField.inputAccessoryView = toolbar
        
    }
    
    
//    @objc func doneDateBtnClick() {
//        if let datePicker = dobField.inputView as? UIDatePicker {
//            let dateFormatter = DateFormatter() 
//            dateFormatter.dateFormat = "MM/dd/yyyy"
//            print(dateFormatter)
//            dobField.text = dateFormatter.string(from: datePicker.date)
//        }
//        dobField.resignFirstResponder()
//    }
    
    @objc func doneDateBtnClick() {
        if let datePicker = dobField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy" // Format: 01/13/2025
            dobField.text = dateFormatter.string(from: datePicker.date) // Sets formatted date
        }
        dobField.resignFirstResponder() // Hides the keyboard
    }
    
    @objc func cancelDateBtnClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
}
