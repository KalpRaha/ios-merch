//
//  LoginViewController.swift
//  QuickveeApp
//
//  Created by Jamaluddin Syed on 17/01/23.
//

import UIKit
import MaterialComponents

class LoginViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var signinText: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswordText: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    @IBOutlet weak var emailField: MDCOutlinedTextArea!
    
    @IBOutlet weak var passwordField: MDCOutlinedTextArea!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImage.image = UIImage(named: "White")
        imageLogo.image = UIImage(named: "Quickveelogo")
        loginBtn.setTitle("Login", for: .normal)
        registerBtn.setTitle("Sign Up", for: .normal)
        signinText.text = "SIGN IN"
        orLabel.text = "–––– OR ––––"
        loginBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        registerBtn.layer.borderColor = UIColor.black.cgColor
        registerBtn.layer.borderWidth = 1.5
        createAttributedText(text: "Forget Password?")
        emailField.label.text = "Email"
        emailField.textView.delegate = self
//        emailField.textView.becomeFirstResponder()
        passwordField.label.text = "Password"
        passwordField.textView.delegate = self
        emailField.label.textColor = UIColor.lightGray
        emailField.setFloatingLabel(.lightGray, for: .disabled)
        createCustomTextField(textField: emailField)
        createCustomTextField(textField: passwordField)
        passwordField.textView.isSecureTextEntry = true
        loginView.layer.cornerRadius = 20
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func createCustomTextField(textField: MDCOutlinedTextArea) {
        textField.minimumNumberOfVisibleRows = 1.0
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setOutlineColor(.lightGray, for: .disabled)
        textField.setNormalLabel(.lightGray, for: .normal)
        textField.setNormalLabel(.lightGray, for: .editing)
        textField.setNormalLabel(.lightGray, for: .disabled)
        textField.setFloatingLabel(.lightGray, for: .normal)
        textField.setFloatingLabel(.lightGray, for: .disabled)
        textField.setFloatingLabel(.lightGray, for: .editing)
        textField.setTextColor(.black, for: .normal)
        textField.setTextColor(.black, for: .editing)
        textField.setTextColor(.black, for: .disabled)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func validatePassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    
    func createAttributedText(text: String) {
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.underlineStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
        forgetPasswordText.attributedText = attributedText
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
//        guard let email = emailField.textView.text, email != "",
//        validateEmail(email: email) else {
//            emailField.isError(numberOfShakes: 3, revert: true)
//            return
//        }
//
//        createCustomTextField(textField: emailField)
//
//        guard let password = passwordField.textView.text, password != "",
//        password.count > 7, validatePassword(password: password) else {
//            passwordField.isError(numberOfShakes: 3, revert: true)
//            return
//        }
//
//        createCustomTextField(textField: passwordField)

        performSegue(withIdentifier: "toStore", sender: nil)
    }
    
@IBAction func registerButtonClicked(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toreg", sender: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= 10
    }
}
extension MDCOutlinedTextArea {
    
//    func isError(numberOfShakes shakes: Float, revert: Bool) {
//        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
//        shake.duration = 0.07
//        shake.repeatCount = shakes
//        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
//        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
//        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
//        self.layer.add(shake, forKey: "position")
//
//        setOutlineColor(.red, for: .normal)
//        setOutlineColor(.red, for: .editing)
//        setOutlineColor(.red, for: .disabled)
//        setFloatingLabel(.red, for: .normal)
//        setFloatingLabel(.red, for: .editing)
//        setFloatingLabel(.red, for: .disabled)
//    }
}
