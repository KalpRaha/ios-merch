//
//  RegisterTableViewController.swift
//  
//
//  Created by Jamaluddin Syed on 23/01/23.
//

import UIKit
import MaterialComponents
import DropDown
import Alamofire
import RecaptchaEnterprise

class RegisterTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerLabel: UILabel!
    
    @IBOutlet weak var nameField: MDCOutlinedTextField!
    @IBOutlet weak var lastNameField: MDCOutlinedTextField!
    @IBOutlet weak var businessField: MDCOutlinedTextField!
    @IBOutlet weak var phoneField: MDCOutlinedTextField!
    @IBOutlet weak var emailField: MDCOutlinedTextField!
    @IBOutlet weak var addressField: MDCOutlinedTextField!
    @IBOutlet weak var cityField: MDCOutlinedTextField!
    @IBOutlet weak var zipCodeField: MDCOutlinedTextField!
    @IBOutlet weak var stateField: MDCOutlinedTextField!
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var loginNowBtn: UIButton!
    
    let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    var activeTextField = UITextField()
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    let menu = DropDown()
    var recaptchaClient: RecaptchaClient?
    var verify = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.blue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupMenu()
        setupField()
        setupButtons()
        stateButton.layer.cornerRadius = 5
        registerView.layer.cornerRadius = 20.0
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundView = UIImageView.init(image: UIImage(named: "White"))
        
        verify = false
        recaptcha()
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupMenu() {
        
        menu.dataSource = states
        menu.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = stateButton
        menu.anchorView = stateButton
        
        menu.selectionAction = { index, title in
            self.stateField.text = title
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.image = UIImage(named: "down")
            self.stateField.trailingView = imageView
            self.stateField.trailingViewMode = .always
            self.createCustomTextField(textField: self.stateField)
        }
    }
    
    func setupButtons() {
        
        verifyButton.setTitle("Verify Recaptcha", for: .normal)
        verifyButton.layer.borderColor = UIColor(red: CGFloat(10.0/225.0), green: CGFloat(100.0/255.0), blue: CGFloat(249.0/255.0), alpha: CGFloat(1.0)).cgColor
        verifyButton.layer.borderWidth = 1.0
        verifyButton.setTitleColor(UIColor(red: CGFloat(10.0/225.0), green: CGFloat(100.0/255.0), blue: CGFloat(249.0/255.0), alpha: CGFloat(1.0)), for: .normal)
        verifyButton.layer.cornerRadius = 10.0
        registerButton.setTitle("Sign Up", for: .normal)
        registerButton.layer.cornerRadius = 10.0
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.borderWidth = 1.0
        registerButton.backgroundColor = .black
        memberLabel.text = "Already a member?"
        createAttributedText(text: "Login Now")
    }
    
    func setupField() {
        
        createCustomTextField(textField: nameField)
        createCustomTextField(textField: lastNameField)
        createCustomTextField(textField: businessField)
        createCustomTextField(textField: phoneField)
        createCustomTextField(textField: emailField)
        createCustomTextField(textField: stateField)
        createCustomTextField(textField: addressField)
        createCustomTextField(textField: cityField)
        createCustomTextField(textField: zipCodeField)
        
        nameField.delegate = self
        lastNameField.delegate = self
        businessField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        stateField.delegate = self
        addressField.delegate = self
        cityField.delegate = self
        zipCodeField.delegate = self

        nameField.label.text = "First Name"
        lastNameField.label.text = "Last Name"
        businessField.label.text = "Business"
        phoneField.label.text = "Phone"
        phoneField.keyboardType = .asciiCapableNumberPad
        emailField.label.text = "Email"
        stateField.label.text = "State"
        addressField.label.text = "Address"
        cityField.label.text = "City"
        zipCodeField.label.text = "Zip code"
        zipCodeField.keyboardType = .asciiCapableNumberPad
        
        nameField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        businessField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        emailField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        stateField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        addressField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cityField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        zipCodeField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        stateField.trailingView = imageView
        stateField.trailingViewMode = .always
        
    }
    
    @objc func nameEdit() {
        
        if nameField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "First Name cannot be empty")
        }
    }
    
    @objc func lastNameEdit() {
        
        if lastNameField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Last Name cannot be empty")
        }
    }
    
    @objc func businessEdit() {
        if businessField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Business Name cannot be empty")
        }
    }
    
    @objc func phoneEdit() {
        if phoneField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Phone Number cannot be empty")
        }
        else {
            showErrorAlert(title: "Alert", message: "Please enter valid phone number")
        }
    }
    
    @objc func emailEdit() {
        if emailField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Email Address cannot be empty")
        }
        else {
            showErrorAlert(title: "Alert", message: "Please enter valid email address")
        }
    }
    
    @objc func addressEdit() {
        if addressField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Address field cannot be empty")
        }
    }
    
    @objc func cityEdit() {
        if cityField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "City Name cannot be empty")
        }
    }
    
    @objc func stateEdit() {
        if stateField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "State field cannot be empty")
        }
    }
    
    @objc func zipEdit() {
        if zipCodeField.text?.count == 0 {
            showErrorAlert(title: "Alert", message: "Zip Code cannot be empty")
        }
        else {
            showErrorAlert(title: "Alert", message: "Please enter valid zip code")
        }
    }
    
    
    
    @IBAction func verifyButtonClick(_ sender: UIButton) {
        
        
        guard let firstName = nameField.text, firstName != "" else {
            nameField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            nameField.trailingView = button
            nameField.trailingViewMode = .always
            button.addTarget(self, action: #selector(nameEdit), for: .touchUpInside)
            return
        }
        guard let lastName = lastNameField.text, lastName != "" else {
            lastNameField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            lastNameField.trailingView = button
            lastNameField.trailingViewMode = .always
            button.addTarget(self, action: #selector(lastNameEdit), for: .touchUpInside)
            return
        }
        guard let business = businessField.text, business != "" else {
            businessField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            businessField.trailingView = button
            businessField.trailingViewMode = .always
            button.addTarget(self, action: #selector(businessEdit), for: .touchUpInside)
            return
        }
        
        guard let phone = phoneField.text, phone.count == 10, phone != "" else {
            phoneField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            phoneField.trailingView = button
            phoneField.trailingViewMode = .always
            button.addTarget(self, action: #selector(phoneEdit), for: .touchUpInside)
            return
        }
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
        guard let address = addressField.text, address != "" else {
            addressField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            addressField.trailingView = button
            addressField.trailingViewMode = .always
            button.addTarget(self, action: #selector(addressEdit), for: .touchUpInside)
            return
        }
        guard let city = cityField.text, city != "" else {
            cityField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            cityField.trailingView = button
            cityField.trailingViewMode = .always
            button.addTarget(self, action: #selector(cityEdit), for: .touchUpInside)
            return
        }
        guard let state = stateField.text, state != "" else {
            stateField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            stateField.trailingView = button
            stateField.trailingViewMode = .always
            button.addTarget(self, action: #selector(stateEdit), for: .touchUpInside)
            return
        }
        guard let zipcode = zipCodeField.text, zipcode.count == 5, zipcode != "" else {
            zipCodeField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            zipCodeField.trailingView = button
            zipCodeField.trailingViewMode = .always
            button.addTarget(self, action: #selector(zipEdit), for: .touchUpInside)
            return
        }
        
        loadIndicator.isAnimating = true
        verifyButton.setTitle("Please Wait!", for: .normal)
        verifyRecaptcha()
    }
    
    @IBAction func loginClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerBtnClick(_ sender: UIButton) {
        
        if verify {
            setUpPostMethod()
            
        }
        else {
            showAlert(title: "Alert", message: "Please verify recaptcha", tag: 0)
        }
    }
    
    
    @IBAction func stateButtonClick(_ sender: UIButton) {
        view.endEditing(true)
        menu.show()
    }
    
    
    func setUpPostMethod() {
        
        guard let firstName = nameField.text, firstName != "" else {
            nameField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            nameField.trailingView = button
            nameField.trailingViewMode = .always
            button.addTarget(self, action: #selector(nameEdit), for: .touchUpInside)
            return
        }
        guard let lastName = lastNameField.text, lastName != "" else {
            lastNameField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            lastNameField.trailingView = button
            lastNameField.trailingViewMode = .always
            button.addTarget(self, action: #selector(lastNameEdit), for: .touchUpInside)
            return
        }
        guard let business = businessField.text, business != "" else {
            businessField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            businessField.trailingView = button
            businessField.trailingViewMode = .always
            button.addTarget(self, action: #selector(businessEdit), for: .touchUpInside)
            return
        }
        
        guard let phone = phoneField.text, phone.count == 10, phone != "" else {
            phoneField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            phoneField.trailingView = button
            phoneField.trailingViewMode = .always
            button.addTarget(self, action: #selector(phoneEdit), for: .touchUpInside)
            return
        }
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
        guard let address = addressField.text, address != "" else {
            addressField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            addressField.trailingView = button
            addressField.trailingViewMode = .always
            button.addTarget(self, action: #selector(addressEdit), for: .touchUpInside)
            return
        }
        guard let city = cityField.text, city != "" else {
            cityField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            cityField.trailingView = button
            cityField.trailingViewMode = .always
            button.addTarget(self, action: #selector(cityEdit), for: .touchUpInside)
            return
        }
        guard let state = stateField.text, state != "" else {
            stateField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            stateField.trailingView = button
            stateField.trailingViewMode = .always
            button.addTarget(self, action: #selector(stateEdit), for: .touchUpInside)
            return
        }
        guard let zipcode = zipCodeField.text, zipcode.count == 5, zipcode != "" else {
            zipCodeField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            zipCodeField.trailingView = button
            zipCodeField.trailingViewMode = .always
            button.addTarget(self, action: #selector(zipEdit), for: .touchUpInside)
            return
        }
        
        let parameters: [String: Any] = [
            "f_name": firstName,
            "l_name": lastName,
            "business_name": business,
            "phone": phone,
            "email": email,
            "address_line_1": address,
            "city": city,
            "state": state,
            "zip": zipcode,
            "ip_address": "10.0.2.16"
        ]
        
        print(parameters)
        
        loadingIndicator.isAnimating = true
        registerButton.setTitle("Please Wait!", for: .normal)
        
        let url = AppURLs.REGISTER

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            
            switch (response.result) {
            case .success:
                print(response)
                self.loadingIndicator.isAnimating = false
                self.registerButton.setTitle("Sign Up", for: .normal)
                self.showAlert(title: "Congratulations!", message: "Registered successfully! Please check your mail for login password", tag: 1)
                break
            case .failure:
                print(Error.self)
            }
        }
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    // MARK: Recaptcha
    
    func recaptcha() {
        //    6LfGXowkAAAAAD34dp9lXuvt8zwVDcV0I_kqv9YS real id
        Recaptcha.fetchClient(withSiteKey: "6LeJFX0kAAAAAKcitnufe-dgG_XglWpxRHkCWqCl") { recaptchaClient, error in
            if let recaptchaClient = recaptchaClient {
                self.recaptchaClient = recaptchaClient
            }
            if let error = error {
                print("RecaptchaClient creation error")
            }
        }
    }
    
    func verifyRecaptcha() {
        
        guard let recaptchaClient = recaptchaClient else {
            print("RecaptchaClient creation failed.")
            verifyButton.setTitle("Verify Recaptcha", for: .normal)
            loadIndicator.isAnimating = false
            showAlert(title: "Oops!", message: "Creation failed", tag: 0)
            return
        }
        
        Task {
            do {
                let action = RecaptchaAction(customAction: "login")
                let token = try await recaptchaClient.execute(withAction: action)
                print("Token received: \(token)")
            } catch {
                print("Error executing reCAPTCHA: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: MISC
    
    func showErrorAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func showAlert(title: String, message: String, tag: Int) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            if tag == 1 {
                self.navigationController?.popViewController(animated: true)
            }
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {

        var updatetext = textField.text ?? ""
        
        if textField == nameField || textField == lastNameField {
            
            if updatetext.count == 31 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count == 1{
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == businessField {
            
            if updatetext.count == 71 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count == 1{
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
        
        else if textField == phoneField {
            
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
        
        else if textField == addressField {
            
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
        
        else if textField == zipCodeField {
            
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
    
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
        
    func validateEmailAddress(email: String) -> Bool {
        
        if email != "" && validateEmail(email: email) && countDots(email: email) {
            return true
        }
        
        else {
            return false
        }
    }
    
    func countDots(email: String) -> Bool {
        
        switch email.filter({ $0 == "." }).count {
        case 1:
            return true
        default:
            return false
        }
    }
    
    
    func createAttributedText(text: String) {
        print(text.count)
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        
        attributedText.addAttribute(.foregroundColor, value: UIColor(red: CGFloat(10.0/225.0),
                                                                     green: CGFloat(100.0/255.0), blue: CGFloat(249.0/255.0),
                                                                     alpha: CGFloat(1.0)), range: textRange)
        loginNowBtn.setAttributedTitle(attributedText, for: .normal)
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
    
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        verifyButton.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: verifyButton.centerXAnchor, constant: 65),
            loadIndicator.centerYAnchor
                .constraint(equalTo: verifyButton.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
        
        
        registerButton.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: registerButton.centerXAnchor, constant: 65),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: registerButton.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}
struct RegisterResponse {
    
    let firstName: String
    let lastName: String
    let business: String
    let phone: Int
    let email: String
    let address: String
    let city: String
    let state: String
    let zipcode: Int
}
