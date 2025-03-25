//
//  LoginTableViewController.swift
//
//
//  Created by Jamaluddin Syed on 23/01/23.
//

import UIKit
import MaterialComponents
import Alamofire
import CommonCrypto
import AdSupport
import AppTrackingTransparency
import WebKit

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var sigininText: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    @IBOutlet weak var storeNameField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    @IBOutlet weak var passwordField: MDCOutlinedTextField!
    
    var storeArray = [Store]()
    var responseDict = [String:Any]()
    
    let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    var adv_id: String?
    
    private var lastSelectedText = ""
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupField()
        setupBtns()
       
        loginView.layer.cornerRadius = 20
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundView = UIImageView.init(image: UIImage(named: "White"))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "visibility"), for: .normal)
        passwordField.trailingView = button
        passwordField.trailingViewMode = .always
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        emailField.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.emailField.addGestureRecognizer(swipeDown)
        
        emailField.keyboardType = .emailAddress
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingIndicator.isAnimating = false
        loginBtn.setTitle("Login", for: .normal)
        passwordField.text = ""
        emailField.text = ""
        emailField.autocorrectionType = .no
        storeNameField.text = ""
        
        let websiteDataTypes: Set<String> = [
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeSessionStorage]

        let dateFrom = Date(timeIntervalSince1970: 0) // To remove all data
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            print("Website data cleared.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAdvId()
    }
    
    func getAdvId() -> String {
        let adv_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print(adv_id)
        return adv_id
    }
   
    func setupField() {
        
        passwordField.isSecureTextEntry = true
        //createAttributedText(text: "Forget Password?")
        emailField.label.text = "Email"
        emailField.delegate = self
        passwordField.label.text = "Password"
        passwordField.delegate = self
        storeNameField.label.text = "Store Name"
        storeNameField.delegate = self
        storeNameField.autocorrectionType = .no
        emailField.label.textColor = UIColor.lightGray
        emailField.setFloatingLabelColor(.lightGray, for: .disabled)
        
        createCustomTextField(textField: storeNameField)
        createCustomTextField(textField: emailField)
        createCustomTextField(textField: passwordField)
        
        emailField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    func setupBtns() {

        loginBtn.setTitle("Login", for: .normal)
        sigininText.text = "LOGIN TO YOUR STORE"
        loginBtn.layer.cornerRadius = 10
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStore" {
            
            let vc = segue.destination as! StoreViewController
            vc.current_Password = passwordField.text
            vc.current_email = emailField.text
            vc.storeArray = storeArray
            vc.adv_id = adv_id
            vc.mode = "login"
        }
        
        if segue.identifier == "logintoPassCode" {
            
            let vc = segue.destination as! PassCodeViewController
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                if gesture.state == UIGestureRecognizer.State.ended {
                    let endTap = gesture.location(in: view)
                    let arbitraryValue = emailField.closestPosition(to: endTap)
                    emailField.selectedTextRange = emailField.textRange(from: arbitraryValue!, to: arbitraryValue!)
                }
            case .left:
                print("Swiped left")
                if gesture.state == UIGestureRecognizer.State.ended {
                    let endTap = gesture.location(in: view)
                    let arbitraryValue = emailField.closestPosition(to: endTap)
                    emailField.selectedTextRange = emailField.textRange(from: arbitraryValue!, to: arbitraryValue!)
                }
            default:
                let endTap = gesture.location(in: view)
                let arbitraryValue = emailField.closestPosition(to: endTap)
                emailField.selectedTextRange = emailField.textRange(from: arbitraryValue!, to: arbitraryValue!)
                break
            }
        }
    }

    @objc func emailEdit() {
        if emailField.text?.count == 0 {
            showAlert(title: "Alert", message: "Email Address cannot be empty")
        }
        else {
            showAlert(title: "Alert", message: "Please enter valid email address")
        }
    }
    
    @objc func passwordEdit() {
        
        showAlert(title: "Alert", message: "Password cannot be empty")
        
    }
    
    @objc func nameEdit() {
        
        showAlert(title: "Alert", message: "Store Name cannot be empty")
        
    }

    @IBAction func loginButtonClick(_ sender: UIButton) {
        
        guard let storename = storeNameField.text, storename != ""
        else {
            storeNameField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            storeNameField.trailingView = button
            storeNameField.trailingViewMode = .always
            button.addTarget(self, action: #selector(nameEdit), for: .touchUpInside)
            return
        }
        
        createCustomTextField(textField: storeNameField)
        
        
        guard let email = emailField.text, email != "",
              validateEmailAddress(email: email) else {
            emailField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            emailField.trailingView = button
            emailField.trailingViewMode = .always
            button.addTarget(self, action: #selector(emailEdit), for: .touchUpInside)
            return
        }
        
        createCustomTextField(textField: emailField)
        
        guard let password = passwordField.text, password != ""
        else {
            passwordField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            passwordField.trailingView = button
            passwordField.trailingViewMode = .always
            button.addTarget(self, action: #selector(passwordEdit), for: .touchUpInside)
            return
        }
        
        createCustomTextField(textField: passwordField)
    
        loginBtn.setTitle("Please Wait!", for: .normal)
        self.loadingIndicator.isAnimating = true
        
//        setUpPostMethod()
        getLoginDetails()
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
  
    func setUpPostMethod() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        let parameters: [String: Any] = [
            "email_id": email,
            "password": password
        ]
        
        
        let url = AppURLs.ALL_STORES

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    if json["result"] == nil {
                        self.getLoginDetails()
                    }
                    else {
                        self.loadingIndicator.isAnimating = false
                        self.loginBtn.setTitle("Login", for: .normal)
                        self.getResponseValues(response: json["result"]!)
                    }
                }
                catch {
                    
                }
                break

            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }

    func getResponseValues(response: Any) {
        
        let responseArray = response as! [[String:Any]]
        var storeList = [Store]()
        
        for response in responseArray {
            let store = Store(a_city: "\(response["a_city"] ?? "")",
                              a_country: "\(response["a_country"] ?? "")",
                              a_phone: "\(response["a_phone"] ?? "")",
                              a_state: "\(response["a_state"] ?? "")",
                              a_zip: "\(response["a_zip"] ?? "")",
                              email: "\(response["email"] ?? "")",
                              logo: "\(response["logo"] ?? "")",
                              merchant_id: "\(response["merchant_id"] ?? "")",
                              merchant_name: "\(response["merchant_name"] ?? "")",
                              password: "\(response["password"] ?? "")",
                              store_name: "\(response["store_name"] ?? "")",
                              login_store_name: "\(response["login_store_name"] ?? "")",
                              a_address_line_1: "\(response["a_address_line_1"] ?? "")",
                              a_address_line_2: "\(response["a_address_line_2"] ?? "")")
            storeList.append(store)
        }
        
        storeArray = storeList
        self.loadingIndicator.isAnimating = false
        loginBtn.setTitle("Login", for: .normal)
        
        performSegue(withIdentifier: "toStore", sender: nil)
        
    }
 
    func getLoginDetails() {
        
        guard let email = emailField.text else { return }
        guard let password = passwordField.text, password != "" else { return }
        guard let storeName = storeNameField.text else { return }
        let adv_id = getAdvId()
        let env = "\(UIDevice.current.systemVersion)\(UIDevice.current.model)"
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "adv_id": adv_id,
            "env": env,
            "login_store_name": storeName
        ]
        
        print(parameters)
        
        let url = AppURLs.LOGIN
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    if json["status"] as! Int == 0 {
                        let msg = json["message"] as? String ?? ""
                        //self.showAlert(title: "Alert", message: msg)
                        ToastClass.sharedToast.showToast(message: msg, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.loadingIndicator.isAnimating = false
                        self.loginBtn.setTitle("Login", for: .normal)
                    }
                    else {
                        let jsonDict = json["result"]
                        self.getLoginResponse(response: jsonDict!)
                        
                    }
                    break
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
  
    func getLoginResponse(response: Any) {
        
        responseDict = response as! [String:Any]
        print(responseDict)
        let merchant_id = responseDict["merchant_id"]
        let merchant_name = responseDict["merchant_name"]
        UserDefaults.standard.set(merchant_id, forKey: "merchant_id")
        UserDefaults.standard.set(merchant_name, forKey: "merchant_name")
        let email = emailField.text ?? ""
        let pass = passwordField.text ?? ""
        let store = storeNameField.text ?? ""
        
        UserDefaults.standard.set(email, forKey: "merchant_email")
        UserDefaults.standard.set(pass, forKey: "merchant_password")
        UserDefaults.standard.set(store, forKey: "store_name_webview")
        
        print(responseDict)
        

        performSegue(withIdentifier: "logintoPassCode", sender: nil)
    }
    
    
//    @IBAction func signUpBtnClick(_ sender: UIButton) {
//        performSegue(withIdentifier: "toreg", sender: nil)
//    }
    
    
//    @IBAction func forgetPassClick(_ sender: UIButton) {
//
//        setUpForResetPassword()
//    }
    
    
    func setUpForResetPassword() {
        
        let url = AppURLs.FORGOT_PASSWORD

        guard let email = emailField.text, email != "" else {
            showAlert(title: "Alert", message: "Please enter valid email address")
            return
        }
        
        let parameters : [String:Any] =
        ["email" : email]
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            
            switch (response.result) {
            case .success:
                print(response)
                self.showAlert(title: "Alert", message: "check your email or password")
                
                break
            case .failure:
                print(Error.self)
            }
        }
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
  
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
 
    func validateEmail(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func validateEmailAddress(email: String) -> Bool {
        
        if email != "" && validateEmail(email: email) {
            return true
        }
        
        else {
            return false
        }
    }

    func validatePassword(password: String) -> Bool {
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        if textField == emailField {
            
            if textField.text!.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
            
        }
        
        else if textField == passwordField {
            
            if textField.text!.count == 1 {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "visibility"), for: .normal)
                passwordField.trailingView = button
                passwordField.trailingViewMode = .always
                button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
                passwordField.isSecureTextEntry = true
                createCustomTextField(textField: textField)
            }
        }
    }
    
//    func createAttributedText(text: String) {
//        let textRange = NSRange(location: 0, length: text.count)
//        let attributedText = NSMutableAttributedString(string: text)
//        attributedText.addAttribute(.underlineStyle,
//                                    value: NSUnderlineStyle.single.rawValue,
//                                    range: textRange)
//        attributedText.addAttribute(.font, value: UIFont(name: "Manrope-SemiBold", size: 15.0)!, range: textRange)
//        forgetPassword.setAttributedTitle(attributedText, for: .normal)
//    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension LoginTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == storeNameField {
            if (string == " ") {
                return false
            }
            return true
        }
        else {
            return true
        }
    }
}


extension MDCOutlinedTextField {
    
    func isError(numberOfShakes shakes: Float, revert: Bool) {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
        
        setOutlineColor(.red, for: .normal)
        setOutlineColor(.red, for: .editing)
        setOutlineColor(.red, for: .disabled)
        setFloatingLabelColor(.red, for: .normal)
        setFloatingLabelColor(.red, for: .editing)
        setFloatingLabelColor(.red, for: .disabled)
    }
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

extension LoginTableViewController {
   
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        loginBtn.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: loginBtn.centerXAnchor, constant: 65),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: loginBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

//struct Login {
//    let address_line_1 : String
//    let a_address_line_2 : String
//    let a_city : String
//    let a_country : String
//    let a_phone : String
//    let a_state : String
//    let a_zip : String
//    let email : String
//    let phone : String;
//    let merchant_id : String
//    let merchant_name : String
//    var password : String
//    let address_line_3 : String
//}
