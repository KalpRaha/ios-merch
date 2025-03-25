//
//  SetupAddTaxViewController.swift
//  
//
//  Created by Jamaluddin Syed on 16/03/23.
//

import UIKit
import MaterialComponents
import Alamofire

class SetupAddTaxViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var taxTitle: MDCOutlinedTextField!
    @IBOutlet weak var displayName: MDCOutlinedTextField!
    @IBOutlet weak var percentage: MDCOutlinedTextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var action: String?
    var updateTitle: String?
    var updateDisplay: String?
    var updatePercent: String?
    var updateId: String?
    var merchant_id: String?
    var deleteHide: Int?
    var viewControl: SetupTaxViewController?
    
    private var isSymbolOnRight = false
    
    let formatter = NumberFormatter()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        addButton.layer.cornerRadius = 10.0
        
        topView.addBottomShadow()
        
        if action == "add" {
            topLabel.text = "Add Tax"
            addButton.setTitle("Add", for: .normal)
            deleteBtn.isHidden = true
        }
        
        else {
            topLabel.text = "Edit Tax"
            taxTitle.text = updateTitle
            displayName.text = updateDisplay
            percentage.text = updatePercent
            
            if deleteHide == 0 {
                deleteBtn.isHidden = true
                taxTitle.isEnabled = false
            }
            else {
                deleteBtn.isHidden = false
                taxTitle.isEnabled = true
            }
        
            addButton.setTitle("Save", for: .normal)
        }
        setupField()
        formatter.maximumFractionDigits = 2
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    
    }
    
    func setupField() {
        
        taxTitle.label.text = "Title"
        displayName.label.text = "Display Name"
        percentage.label.text = "Percentage"
        
        createCustomTextField(textField: taxTitle)
        createCustomTextField(textField: displayName)
        createCustomTextField(textField: percentage)
        
        percentage.keyboardType = .decimalPad
        
        taxTitle.addTarget(self, action: #selector(updateLimit), for: .editingChanged)
        displayName.addTarget(self, action: #selector(updateLimit), for: .editingChanged)
        percentage.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        showAlert(title: "Alert", message: "Are you sure you want to delete this tax?", delete: 1)
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addButtonClick(_ sender: UIButton) {
                
        
        validateParameters()
        
    }
    
    func showErrorAlert(title: String, message: String, delete: Int) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            if delete == 1 {
                self.setupApiDelete()
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        
        
    }
    
    func showAlert(title: String, message: String, delete: Int) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if delete == 1 {
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    self.setupApiDelete()
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        
        else {
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
            }
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    @objc func titleError() {
        if taxTitle.text == "" {
            showErrorAlert(title: "Alert", message: "Tax Title cannot be empty", delete: 0)
        }
        else {
            showErrorAlert(title: "Alert", message: "Tax with name \(taxTitle.text!) already exists", delete: 0)
        }
    }
    
    @objc func titleSpaces() {
        
        showErrorAlert(title: "Alert", message: "Tax Title cannot be empty", delete: 0)
    }
    
    @objc func percentError() {
        showErrorAlert(title: "Alert", message: "Tax percentage cannot be empty", delete: 0)
    }
    
    @objc func displayError() {
        showErrorAlert(title: "Alert", message: "Display name cannot be empty", delete: 0)
    }
    
    func checkSpaces(name: String) -> Bool {
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        else {
            return true
        }
    }
    
    func validateParameters() {
        
        guard let title = taxTitle.text, title != "", checkNameDuplicate(name: title) else {
            taxTitle.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            taxTitle.trailingView = button
            taxTitle.trailingViewMode = .always
            button.addTarget(self, action: #selector(titleError), for: .touchUpInside)
            return
        }
        
        guard checkSpaces(name: title) else {
            taxTitle.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            taxTitle.trailingView = button
            taxTitle.trailingViewMode = .always
            button.addTarget(self, action: #selector(titleSpaces), for: .touchUpInside)
            return
        }
        
        guard let percent = percentage.text, percent != "" else {
            percentage.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            percentage.trailingView = button
            percentage.trailingViewMode = .always
            button.addTarget(self, action: #selector(percentError), for: .touchUpInside)
            return
        }
        
        guard let display = displayName.text else {
            displayName.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            displayName.trailingView = button
            displayName.trailingViewMode = .always
            button.addTarget(self, action: #selector(displayError), for: .touchUpInside)
            return
        }
        
        var mode = ""
        if addButton.currentTitle == "Add" {
            mode = "Add"
        }
        
        else {
            mode = "Save"
        }
        
        loadingIndicator.isAnimating = true
        setupApi(title: title, percent: percent, display: display, id: updateId!, mode: mode)
        
    }
    
    
    func setupApi(title: String, percent: String, display: String, id: String, mode: String) {
        
        let url = AppURLs.ADD_TAX

        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
            "taxID": updateId!,
            "title": title,
            "percent": percent,
            "displayname": display
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.loadingIndicator.isAnimating = false
                    self.navigationController?.popViewController(animated: true)
                    self.viewControl?.showUpdatedToast(mode: mode)
                    break
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    func setupApiDelete() {
        
        let url = AppURLs.DELETE_TAX

        print(updateId!)
        let parameters: [String:Any] = [
            "id": updateId!
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.navigationController?.popViewController(animated: true)
                    break
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func checkNameDuplicate(name: String) -> Bool {
        
        if action == "add" {
            for i in 0...viewControl!.taxName.count - 1 {
                if viewControl!.taxName[i].lowercased() == name.lowercased() {
                    return false
                }
            }
            return true
        }
        else {
            for i in 0...viewControl!.taxName.count - 1 {
                
                if viewControl!.taxName[i].lowercased() == name.lowercased() {
                    
                    if i == deleteHide {
                        return true
                    }
                    return false
                }
            }
            return true
        }
    }
}

extension SetupAddTaxViewController {
    
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
        if Double(cleanedAmount) ?? 0.00 > 99999 {
          cleanedAmount = String(cleanedAmount.dropLast())
        }
        let amount = Double(cleanedAmount) ?? 0.0
        print(cleanedAmount)
        let amountAsDouble = (amount / 1000.0)
        print(amountAsDouble)
        var amountAsString = String(amountAsDouble)
        print(cleanedAmount)
        print(amountAsString)
        if cleanedAmount.last == "0" {
          if cleanedAmount.count > amountAsString.count {
            let diff = ((cleanedAmount.count + 1) - amountAsString.count)
            for _ in 0..<diff {
              amountAsString.append("0")
            }
            if amountAsString.count > 6 {
              amountAsString.removeLast()
            }
          }
        }
        textField.text = amountAsString
        if textField.text == "0.000" {
          textField.text = "0.000"
        }
      }










    
    @objc func updateLimit(textField: MDCOutlinedTextField) {
        
        if textField == taxTitle {
            
            if textField.text?.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
            
            else if textField.text?.count == 51 {
                textField.text = String(textField.text!.dropLast())
            }
        }
        
        
        
       else  if textField == displayName {
            
            if textField.text?.count == 51 {
                textField.text = String(textField.text!.dropLast())
            }
        }
    }
    
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        addButton.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: addButton.centerXAnchor, constant: 30),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: addButton.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}
