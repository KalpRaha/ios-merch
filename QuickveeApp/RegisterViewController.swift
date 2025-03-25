//
//  RegisterViewController.swift
//  QuickveeApp
//
//  Created by Jamaluddin Syed on 10/01/23.
//

import UIKit
import MaterialComponents
import DropDown

class RegisterViewController: UIViewController  {
    
    @IBOutlet weak var nameField: MDCOutlinedTextArea!
    @IBOutlet weak var lastNameField: MDCOutlinedTextArea!
    @IBOutlet weak var businessField: MDCOutlinedTextArea!
    @IBOutlet weak var phoneField: MDCOutlinedTextArea!
    @IBOutlet weak var emailField: MDCOutlinedTextArea!
    @IBOutlet weak var addressField: MDCOutlinedTextArea!
    @IBOutlet weak var cityField: MDCOutlinedTextArea!
    
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var zipCodeField: MDCOutlinedTextArea!
    @IBOutlet weak var quickVeeLogo: UIImageView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var registerView: UIView!
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    let menu = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.dataSource = states
        navigationController?.navigationBar.topItem?.titleView = stateButton
        menu.anchorView = stateButton
        
        menu.selectionAction = { index, title in
            self.stateButton.setTitle("  "+title, for: .normal)
            self.stateButton.setTitleColor(.black, for: .normal)
        }
        
        registerView.layer.cornerRadius = 20.0
        quickVeeLogo.image = UIImage(named: "Quickveelogo")
        registerLabel.text = "SIGN UP"
        createCustomTextField(textField: nameField)
        createCustomTextField(textField: lastNameField)
        createCustomTextField(textField: businessField)
        createCustomTextField(textField: phoneField)
        createCustomTextField(textField: emailField)
        createCustomTextField(textField: addressField)
        createCustomTextField(textField: cityField)
        createCustomTextField(textField: zipCodeField)
        stateButton.layer.borderColor = UIColor.lightGray.cgColor
        stateButton.layer.borderWidth = 1.0
        nameField.label.text = "First Name"
//        nameField.textView.becomeFirstResponder()
        lastNameField.label.text = "Last Name"
        businessField.label.text = "Business"
        phoneField.label.text = "Phone"
        phoneField.textView.keyboardType = .asciiCapableNumberPad
        emailField.label.text = "Email"
        addressField.label.text = "Address"
        cityField.label.text = "City"
        stateButton.setTitle("  State", for: .normal)
        stateButton.setTitleColor(.lightGray, for: .normal)
        zipCodeField.label.text = "Zip code"
        zipCodeField.textView.keyboardType = .asciiCapableNumberPad
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
        createAttributedText(text: "Already a member? Login Now")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize.height = contentView.bounds.size.height
    }
    
    
    @IBAction func verifyButtonClick(_ sender: UIButton) {
        
        guard let firstName = nameField.textView.text, firstName != "",
              firstName.count < 31 else {
            return
        }
        
        guard let lastName = lastNameField.textView.text, lastName != "",
              lastName.count < 31 else {
            return
        }
        
        guard let email = emailField.textView.text, email != "",
              validateEmail(email: email) else {
            return
        }
        
        guard let phone = phoneField.textView.text, phone != "",
                phone.count < 11 else {
            return
        }
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    
    @IBAction func registerBtnClick(_ sender: UIButton) {
  
        
//        setUpPostMethod()
        
        
        
//        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    
    @IBAction func stateButtonClick(_ sender: UIButton) {
        
        menu.show()
    }
    
    
    func setUpPostMethod() {
        guard let firstName = nameField.textView.text else { return }
        guard let lastName = lastNameField.textView.text else { return }
        guard let business = businessField.textView.text else { return }
        guard let phone = phoneField.textView.text else { return }
        guard let email = emailField.textView.text else { return }
        guard let address = addressField.textView.text else { return }
        guard let city = cityField.textView.text else { return }
//        guard let state = stateField.textView.text else { return }
        guard let zipcode = zipCodeField.textView.text else { return }
        
        let url = "https://sandbox.quickvee.com/app/register_merchant"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "f_name": firstName,
            "l_name": lastName,
            "business": business,
            "phone": phone,
            "email": email,
            "address_line_1": address,
            "city": city,
//            "state": state,
            "zip": zipcode
        ]
        
        print(parameters)
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
       
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if error == nil{
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            if let response = response as? HTTPURLResponse{
                guard (200 ... 299) ~= response.statusCode else {
                    print("Status code :- \(response.statusCode)")
                    print(response)
                    return
                }
            }
            
            do{
                let json = try JSONDecoder().decode(Response.self, from: data)
                print(json)
            }catch let error{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func createAttributedText(text: String) {
        print(text.count)
        let textRange = NSRange(location: 18, length: 9)
        let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.underlineStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
        
        attributedText.addAttribute(.foregroundColor, value: UIColor(red: CGFloat(10.0/225.0), green: CGFloat(100.0/255.0), blue: CGFloat(249.0/255.0), alpha: CGFloat(1.0)), range: textRange)
        memberLabel.attributedText = attributedText
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextArea) {
        textField.minimumNumberOfVisibleRows = 1.0
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabel(.lightGray, for: .normal)
        textField.setFloatingLabel(.lightGray, for: .editing)
    }
}

