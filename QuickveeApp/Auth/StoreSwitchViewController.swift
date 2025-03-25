//
//  StoreSwitchViewController.swift
//  
//
//  Created by Jamaluddin Syed on 07/08/24.
//

import UIKit
import MaterialComponents

class StoreSwitchViewController: UIViewController {
    
    
    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var passwordArray = [String]()
    weak var delegate: SwitchStoreDelegate?
    var passindex = 0
    let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBtn.layer.cornerRadius = 10
        doneBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
        
        createCustomTextField(textField: passwordField)
        
        passwordField.isSecureTextEntry = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "visibility"), for: .normal)
        passwordField.trailingView = button
        passwordField.trailingViewMode = .always
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    }
    
    @objc func showPassword(sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "visibility_off") {
            sender.setImage(UIImage(named: "visibility"), for: .normal)
            passwordField.isSecureTextEntry = true
        }
        else {
            sender.setImage(UIImage(named: "visibility_off"), for: .normal)
            passwordField.isSecureTextEntry = false
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
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        
        let pass = passwordField.text ?? ""
        
        if pass.md5 == passwordArray[passindex] {
            dismiss(animated: true) {
                UserDefaults.standard.set(pass, forKey: "merchant_password")
                //self.delegate?.setPresent(mode: 1, id: "", password: [], index: 0)
            }
        }
        else {
            ToastClass.sharedToast.showToast(message: "Passwords dont match", 
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
    }
}
