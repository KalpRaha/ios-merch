//
//  ChangePasswordViewController.swift
//  
//
//  Created by Jamaluddin Syed on 10/03/23.
//

import UIKit
import MaterialComponents
import Alamofire

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var password: MDCOutlinedTextField!
    @IBOutlet weak var newPass: MDCOutlinedTextField!
    @IBOutlet weak var confirmNew: MDCOutlinedTextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordLbl: UILabel!
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    var passwordred = false
    var newpasswordred = false
    var confirmred = false
    
    var merchant_id: String?
    var merch_pass: String?
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.label.text = "Current Password"
        newPass.label.text = "New Password"
        confirmNew.label.text = "Confirm Password"
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button1.setImage(UIImage(named: "visibility_off"), for: .normal)
        password.trailingView = button1
        password.trailingViewMode = .always
        button1.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
       
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button2.setImage(UIImage(named: "visibility_off"), for: .normal)
        newPass.trailingView = button2
        newPass.trailingViewMode = .always
        button2.addTarget(self, action: #selector(showNewPassword), for: .touchUpInside)

        let button3 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button3.setImage(UIImage(named: "visibility_off"), for: .normal)
        confirmNew.trailingView = button3
        confirmNew.trailingViewMode = .always
        button3.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)

        password.isSecureTextEntry = true
        newPass.isSecureTextEntry = true
        confirmNew.isSecureTextEntry = true
        
        password.delegate = self
        newPass.delegate = self
        confirmNew.delegate = self
        
        
        createCustomTextField(textField: password)
        createCustomTextField(textField: newPass)
        createCustomTextField(textField: confirmNew)
        
        password.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        newPass.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        confirmNew.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        topView.addBottomShadow()
        updateBtn.layer.cornerRadius = 10
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            passwordLbl.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            passwordLbl.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @objc func passwordError() {
        showAlert(title: "Alert", message: "Password cannot be empty", mode: 0)
    }
    
    @objc func newPasswordError() {
        showAlert(title: "Alert", message: "New Password cannot be empty", mode: 0)
    }
    
    @objc func confirmPasswordError() {
        showAlert(title: "Alert", message: "Confirm password cannot be empty", mode: 0)
    }

    
    @IBAction func updateButtonClick(_ sender: UIButton) {
        
        view.endEditing(true)
        
        guard let passwordold = password.text, passwordold != "" else {
            self.password.isError(numberOfShakes: 3, revert: true)
            passwordred = true
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            password.trailingView = button
            password.trailingViewMode = .always
            button.addTarget(self, action: #selector(passwordError), for: .touchUpInside)
            return
        }
        
        guard let newPassword = newPass.text, newPassword != "" else {
            newPass.isError(numberOfShakes: 3, revert: true)
            newpasswordred = true
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            newPass.trailingView = button
            newPass.trailingViewMode = .always
            button.addTarget(self, action: #selector(newPasswordError), for: .touchUpInside)
            return
        }
        
        guard let confirmPass = confirmNew.text, confirmPass != "" else {
            confirmNew.isError(numberOfShakes: 3, revert: true)
            confirmred = true
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            confirmNew.trailingView = button
            confirmNew.trailingViewMode = .always
            button.addTarget(self, action: #selector(confirmPasswordError), for: .touchUpInside)
            return
        }
        
        loadingIndicator.isAnimating = true
        
        comparePassword(password: passwordold, newPass: newPassword, confirmPass: confirmPass)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == password {
            if updatetext.last == " " {
                updatetext = String(updatetext.dropLast())
            }
            
            else if textField.text!.count > 0 && passwordred {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "visibility_off"), for: .normal)
                password.trailingView = button
                password.trailingViewMode = .always
                button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
                createCustomTextField(textField: password)
                passwordred = false
                password.isSecureTextEntry = true
            }

        }
        
        else if textField == newPass && newpasswordred {
            
            if updatetext.last == " " {
                updatetext = String(updatetext.dropLast())
            }
            
            else if textField.text!.count > 0 && newpasswordred {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "visibility_off"), for: .normal)
                newPass.trailingView = button
                newPass.trailingViewMode = .always
                button.addTarget(self, action: #selector(showNewPassword), for: .touchUpInside)
                createCustomTextField(textField: newPass)
                newpasswordred = false
                newPass.isSecureTextEntry = true
            }
        }
        
        else {
            
            if updatetext.last == " " {
                updatetext = String(updatetext.dropLast())
            }
            
            else if textField.text!.count > 0 && confirmred {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "visibility_off"), for: .normal)
                confirmNew.trailingView = button
                confirmNew.trailingViewMode = .always
                button.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)
                createCustomTextField(textField: confirmNew)
                confirmred = false
                confirmNew.isSecureTextEntry = true
            }
        }
        
        activeTextField.text = updatetext
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func setupApi(changePass: String, confirmPass: String) {
        
        let url = AppURLs.CHANGE_PASSWORD

        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
            "new_password": changePass,
            "confirm_password": confirmPass
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    
                    UserDefaults.standard.set(false, forKey: "LoggedIn")
                    UserDefaults.standard.set(false, forKey: "passcheck")
                    UserDefaults.standard.set(false, forKey: "fcm_token_set")

                    self.loadingIndicator.isAnimating = false
                    self.showAlert(title: "Success", message: json["message"] as! String, mode: 1)
                    
                    let nav = self.navigationController
                    nav!.popToViewController((nav?.viewControllers.first)!, animated: true)
                    
                }
                catch {
                    
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func comparePassword(password: String, newPass: String, confirmPass: String) {
        
        let merch_pass = merch_pass
        
        if password.md5 == merch_pass {
            
            if newPass == confirmPass {
                setupApi(changePass: newPass, confirmPass: confirmPass)
            }
            else {
                loadingIndicator.isAnimating = false
                showAlert(title: "Alert", message: "New password does not match to confirm password", mode: 0)
            }
        }
        
        else {
            loadingIndicator.isAnimating = false
            showAlert(title: "Alert", message: "Old password does not match", mode: 0)
        }
        
        
    }
    
    func showAlert(title: String, message: String, mode: Int) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
            if mode == 1 {
                let nav = self.navigationController
                nav!.popToViewController((nav?.viewControllers.first)!, animated: true)
            }
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    
    @objc func showPassword(sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "visibility_off") {
            sender.setImage(UIImage(named: "visibility"), for: .normal)
            password.isSecureTextEntry = false
        }
        else {
            sender.setImage(UIImage(named: "visibility_off"), for: .normal)
            password.isSecureTextEntry = true
        }
    }
    
    @objc func showNewPassword(sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "visibility_off") {
            sender.setImage(UIImage(named: "visibility"), for: .normal)
            newPass.isSecureTextEntry = false
        }
        else {
            sender.setImage(UIImage(named: "visibility_off"), for: .normal)
            newPass.isSecureTextEntry = true
        }
    }
    
    @objc func showConfirmPassword(sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "visibility_off") {
            sender.setImage(UIImage(named: "visibility"), for: .normal)
            confirmNew.isSecureTextEntry = false
        }
        else {
            sender.setImage(UIImage(named: "visibility_off"), for: .normal)
            confirmNew.isSecureTextEntry = true
        }
    }
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            var destiny = 0
            let viewcontrollerArray = navigationController?.viewControllers

            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
        else {
           dismiss(animated: true)
        }
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Medium", size: 14.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.setTextColor(.black, for: .normal)
        textField.setTextColor(.black, for: .editing)
        textField.trailingViewMode = .always
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        updateBtn.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: updateBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: updateBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
   

}
