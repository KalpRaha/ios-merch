//
//  AddVendorViewController.swift
//  
//
//  Created by Jamaluddin Syed on 27/03/23.
//

import UIKit
import MaterialComponents
import Alamofire

class AddVendorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var vendorName: MDCOutlinedTextField!
    @IBOutlet weak var vendorNumber: MDCOutlinedTextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var disableBtn: UIButton!
    @IBOutlet weak var addPanel: UIView!
    
    @IBOutlet weak var addPanelLabel: UILabel!
    @IBOutlet weak var addPanelBottom: NSLayoutConstraint!
    
    var viewcontrol: SetupVendorViewController?
    var showviewcontrol: ShowVendorViewController?
    
    var mode: String?
    var updateVendorName: String?
    var updateVendorNumber: String?
    
    var id: String?
    var enable: String?
    var merchant_id: String?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz2134567890 "
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupField()
        setupMode()
        
        addBtn.layer.cornerRadius = 10
        addPanel.layer.cornerRadius = 10
        addPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        vendorName.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        vendorNumber.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        vendorName.autocorrectionType = .no

                
        vendorName.delegate = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
    }
    
    func setupField() {
        
        vendorName.label.text = "Name"
        vendorNumber.label.text = "Mobile Number"
    
        createCustomTextField(textField: vendorName)
        createCustomTextField(textField: vendorNumber)
        
        vendorNumber.keyboardType = .numberPad
    }
    
    
    func setupMode() {
    
        if mode == "add" {
            addPanelLabel.text = "Add Vendor"
            addBtn.setTitle("Add", for: .normal)
            disableBtn.setTitle("Cancel", for: .normal)
            disableBtn.setTitleColor(.black, for: .normal)
            disableBtn.layer.cornerRadius = 10
            disableBtn.layer.borderWidth = 1.0
            disableBtn.layer.borderColor = UIColor.black.cgColor
            vendorName.text = ""
            vendorNumber.text = ""
        }
        
        else {
            addPanelLabel.text = "Edit Vendor"
            addBtn.setTitle("Update", for: .normal)
            vendorName.text = updateVendorName
            vendorNumber.text = updateVendorNumber
            id = showviewcontrol?.vendorId
            enable = showviewcontrol?.vendor_enable
            
            if enable == "1" {
                disableBtn.setTitle("Disable", for: .normal)
                disableBtn.setTitleColor(.red, for: .normal)
                disableBtn.layer.cornerRadius = 10
                disableBtn.layer.borderWidth = 1.0
                disableBtn.layer.borderColor = UIColor.red.cgColor
                
            }
            else {
                disableBtn.setTitle("Enable", for: .normal)
                disableBtn.setTitleColor(UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0), for: .normal)
                disableBtn.layer.cornerRadius = 10
                disableBtn.layer.borderWidth = 1.0
                disableBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
            }
        }
    }
    
    @objc func nameEdit() {
        
        showAlert(title: "Alert", message: "Vendor Name cannot be empty")
    }
    
    @objc func numberEdit() {
        if vendorNumber.text?.count == 0 {
            showAlert(title: "Alert", message: "Vendor Number cannot be empty")

        }
        
        else {
            showAlert(title: "Alert", message: "Vendor Number must be of 10 digits")
        }
    }
    
    
    func validateParameters(task: Int) {
        
        var created = ""
        var updated = ""
        var vendor_id = ""
        var enabled = ""
        
        guard let name = vendorName.text, name != "", checkSpaces(name: name) else {
            vendorName.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            vendorName.trailingView = button
            vendorName.trailingViewMode = .always
            button.addTarget(self, action: #selector(nameEdit), for: .touchUpInside)

            return
        }
        
        guard let number = vendorNumber.text, number != "", number.count == 10 else {
            vendorNumber.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            vendorNumber.trailingView = button
            vendorNumber.trailingViewMode = .always
            button.addTarget(self, action: #selector(numberEdit), for: .touchUpInside)
            return
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dates = formatter.string(from: date)
        let date_time = "\(dates) \(hour):\(minutes):\(seconds)"
        
        if mode == "add" {
            created = date_time
            updated = ""
            vendor_id = ""
            enabled = "1"
        }
        else {
            created = ""
            updated = date_time
            vendor_id = id!
            enabled = enable!
        }
        
        if task == 0 {
            loadIndicator.isAnimating = true
        }
        else {
            loadingIndicator.isAnimating = true
        }
        
        setupApi(name: name, phone: number, created: created,
                 updated: updated, enabled: enabled, vendor_id: vendor_id, task: task)
    }
    
    func checkSpaces(name: String) -> Bool {
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        else {
            return true
        }
    }
    
    func setupApi(name: String, phone: String, created: String,
                  updated: String, enabled: String, vendor_id: String, task: Int) {
        
        let url = AppURLs.ADD_EDIT_VENDOR

        let parameters: [String:Any] = [
            "merchant_id": merchant_id!,
            "name": name,
            "phone": phone,
            "created_at": created,
            "updated_at": updated,
            "enabled": enabled,
            "vendor_id": vendor_id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    if task == 0 {
                        self.loadIndicator.isAnimating = true
                    }
                    else {
                        self.loadingIndicator.isAnimating = true
                    }
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.refreshRows()
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func refreshRows() {
        
        self.dismiss(animated: true)
        
        if mode == "add" {
            viewcontrol?.blackView.isHidden = true
            viewcontrol?.setupApi()
        }
        else {
            showviewcontrol?.blackView.isHidden = true
            showviewcontrol?.popView()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
   

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }
    

    @objc func updateTextField(textField: MDCOutlinedTextField) {

        var updatetext = textField.text ?? ""
        
        if textField == vendorName  {
            
            if updatetext.count > 30 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count > 0 {
                vendorName.trailingView?.isHidden = true
                createCustomTextField(textField: vendorName)
            }
            
            
            activeTextField.text = updatetext
        }
        
        else if textField == vendorNumber {
            
            if updatetext.count > 10 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count > 0 {
                vendorNumber.trailingView?.isHidden = true
                createCustomTextField(textField: vendorNumber)
            }
            
            vendorNumber.text = updatetext
        }
        
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
        if mode == "add" {
            viewcontrol?.blackView.isHidden = true
        }
        else {
            showviewcontrol?.blackView.isHidden = true
        }
        
    }
    
    
    @IBAction func disableBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            self.dismiss(animated: true)
            viewcontrol?.blackView.isHidden = true
        }
        
        else {
            
            if disableBtn.titleLabel?.text == "Disable" {
                enable = "0"
                disableBtn.setTitle("Enable", for: .normal)
                disableBtn.setTitleColor(UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0), for: .normal)
                disableBtn.layer.cornerRadius = 10
                disableBtn.layer.borderWidth = 1.0
                disableBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
            }
            
            else {
                enable = "1"
                disableBtn.setTitle("Disable", for: .normal)
                disableBtn.setTitleColor(.red, for: .normal)
                disableBtn.layer.cornerRadius = 10
                disableBtn.layer.borderWidth = 1.0
                disableBtn.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        validateParameters(task: 0)
    }
    
    
    
    @IBAction func addButtonClick(_ sender: UIButton) {
        
        validateParameters(task: 1)
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        self.addPanelBottom.constant = keyboardFrame.size.height
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        
        
        self.addPanelBottom.constant = 0
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 16.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        var center = 36
        if mode == "add" {
            center = 26
        }
        
        addBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(center)),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        disableBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: disableBtn.centerXAnchor, constant: 36),
            loadIndicator.centerYAnchor
                .constraint(equalTo: disableBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
   
}
