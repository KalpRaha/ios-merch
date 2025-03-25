//
//  SetupProfileViewController.swift
//  
//
//  Created by Jamaluddin Syed on 09/03/23.
//

import UIKit
import MaterialComponents
import Alamofire
import DropDown
import Nuke
import AdSupport

class SetupProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var streetAddress: MDCOutlinedTextField!
    @IBOutlet weak var aptAddress: MDCOutlinedTextField!
    @IBOutlet weak var cityAddress: MDCOutlinedTextField!

    @IBOutlet weak var stateAddress: MDCOutlinedTextField!
    @IBOutlet weak var stateAddressBtn: UIButton!
    @IBOutlet weak var phoneNumber: MDCOutlinedTextField!
    @IBOutlet weak var zipCode: MDCOutlinedTextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var store_logo: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileBtn: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    let menu = DropDown()

    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    var setup: SetupProfile?
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        setupMenu()
        bannerImage.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        
        print(setup!)
        
        versionLabel.text =  "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"

        
       
        topView.addBottomShadow()
        logoutBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        stateAddressBtn.backgroundColor = .clear
        
       

        streetAddress.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        cityAddress.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        phoneNumber.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        zipCode.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        stateAddress.trailingView = imageView
        stateAddress.trailingViewMode = .always
        
        scrollView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        setupWhiteUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            profileBtn.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            profileBtn.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        
    }
    
    func setupTextFields() {
        
        streetAddress.label.text = "Street Address"
        aptAddress.label.text = "Suit/Apt#"
        cityAddress.label.text = "City"
        stateAddress.label.text = "State"
        phoneNumber.label.text = "Phone Number"
        zipCode.label.text = "Zip"
                
        createCustomTextField(textArea: streetAddress)
        createCustomTextField(textArea: aptAddress)
        createCustomTextField(textArea: cityAddress)
        createCustomTextField(textArea: stateAddress)
        createCustomTextField(textArea: zipCode)
        createCustomTextField(textArea: phoneNumber)
        
        zipCode.keyboardType = .numberPad
        phoneNumber.keyboardType = .numberPad
        
        streetAddress.text = ""
        aptAddress.text = ""
        cityAddress.text = ""
        stateAddress.text = ""
        zipCode.text = ""
        phoneNumber.text = ""
        
        streetAddress.text = setup?.a_address_line_1
        emailLabel.text = setup?.email
        aptAddress.text = ""
        cityAddress.text = setup?.a_city
        stateAddress.text = setup?.a_state
        zipCode.text = setup?.a_zip
        phoneNumber.text = setup?.a_phone
        storeNameLabel.text = setup?.name
                
        setLogo(image: setup!.img)

        setBanner(image: setup!.banner_img)
        
    }
    
    func setLogo(image: String) {
        
        let img_url = AppURLs.STORE_LOGO

        let logo_img = "\(img_url)\(image)"
        
        print(image)
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "merchant"), transition: .fadeIn(duration: 0.5))

        Nuke.loadImage(with: logo_img, options: options, into: store_logo)
    }
    
    func setBanner(image: String) {
        
        let banner_url = AppURLs.STORE_BANNER
        
        let img_banner = "\(banner_url)\(image)"
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "merchantechlogo"), transition: .fadeIn(duration: 0.5))
        
        Nuke.loadImage(with: img_banner, options: options, into: bannerImage)

    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        if textField == streetAddress {
            if textField.text!.count == 1 {
                streetAddress.trailingView?.isHidden = true
                createCustomTextField(textArea: streetAddress)
            }
            
            
        }
        
        else if textField == cityAddress {
            if textField.text!.count > 0 {
                cityAddress.trailingView?.isHidden = true
                createCustomTextField(textArea: cityAddress)
            }
        }
        
        else if textField == zipCode {
            if textField.text!.count == 5 {
                zipCode.trailingView?.isHidden = true
                createCustomTextField(textArea: zipCode)
            }
            
            else if (textField.text?.count)! > 5 {
                zipCode.text = String(zipCode.text!.dropLast())
            }
        }
        
        else if textField == phoneNumber {
            if textField.text!.count == 10 {
                phoneNumber.trailingView?.isHidden = true
                createCustomTextField(textArea: phoneNumber)
            }
            else if (textField.text?.count)! > 10 {
                phoneNumber.text = String(phoneNumber.text!.dropLast())
            }
        }
    }
    
    @objc func pullToRefresh() {
                
        setupApi()
    }
    
    
    func setupMenu() {
        
        menu.dataSource = states
        menu.backgroundColor = .white
        menu.anchorView = stateAddressBtn
        menu.separatorColor = .black
        menu.layer.cornerRadius = 10.0
        menu.selectionAction = { index, title in
            self.stateAddress.text = title
            self.menu.deselectRow(at: index)
        }
        
    }
    
    func setupApi() {
        
        let url = AppURLs.PROFILE

        let parameters: [String:Any] = [
            "merchant_id": setup?.merchant_id ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    guard let jsonDict = json["result"] else {
                        return
                    }
                    print(jsonDict)
                    self.getResponseValues(responseValues: jsonDict)
                    self.contentView.isHidden = false
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getResponseValues(responseValues: Any) {
        
        let response = responseValues as! [String:Any]
        
        let store_name = "\(response["store_name"] ?? "")"
        let email_id = "\(response["email"] ?? "")"
        let address = "\(response["a_address_line_1"] ?? "")"
        let apt = "\(response["a_address_line_2"] ?? "")"
        let city = "\(response["a_city"] ?? "")"
        let state = "\(response["a_state"] ?? "")"
        let zip = "\(response["a_zip"] ?? "")"
        let phone = "\(response["a_phone"] ?? "")"
        let logo = "\(response["img"] ?? "")"
        
        storeNameLabel.text = store_name
        emailLabel.text = email_id
        streetAddress.text = address
        aptAddress.text = apt
        cityAddress.text = city
        stateAddress.text = state
        zipCode.text = zip
        phoneNumber.text = phone
                
        setLogo(image: setup!.img)
        setBanner(image: setup!.banner_img)


        if self.refresh.isRefreshing {
            self.refresh.endRefreshing()
        }
    }
    
    func checkSpaces(name: String) -> Bool {
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        else {
            return true
        }
    }
    
    
    func validateUpdateParameters() {
  
        
        guard let street = streetAddress.text, street != "",
        checkSpaces(name: street) else {
            streetAddress.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            streetAddress.trailingView = button
            streetAddress.trailingViewMode = .always
            button.addTarget(self, action: #selector(streetError), for: .touchUpInside)
            return
        }
        
        guard let city = cityAddress.text, city != "",
        checkSpaces(name: city) else {
            cityAddress.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            cityAddress.trailingView = button
            cityAddress.trailingViewMode = .always
            button.addTarget(self, action: #selector(cityError), for: .touchUpInside)
            return
        }
        
        guard let state = stateAddress.text, state != "",
        checkSpaces(name: state) else {
            stateAddress.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            stateAddress.trailingView = button
            stateAddress.trailingViewMode = .always
            button.addTarget(self, action: #selector(stateError), for: .touchUpInside)
            return
        }
        
        guard let zip = zipCode.text, zip != "", zip.count == 5,
        checkSpaces(name: zip) else {
            zipCode.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            zipCode.trailingView = button
            zipCode.trailingViewMode = .always
            button.addTarget(self, action: #selector(zipError), for: .touchUpInside)
            return
        }
        
        guard let phone = phoneNumber.text, phone.count == 10, phone != "",
        checkSpaces(name: phone) else {
            phoneNumber.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            phoneNumber.trailingView = button
            phoneNumber.trailingViewMode = .always
            button.addTarget(self, action: #selector(phoneError), for: .touchUpInside)
            return
        }
        
        loadIndicator.isAnimating = true
        
        setupUpdateApi()
    }
    
    @objc func streetError() {
        
            showAlert(title: "Alert", message: "Street Address cannot be empty")
       
    }
    
    @objc func cityError() {
        
            showAlert(title: "Alert", message: "The City field cannot be left blank.")
        
    }
    
    @objc func stateError() {
        
            showAlert(title: "Alert", message: "The State field cannot be left blank.")
       
    }
    
    @objc func zipError() {
        if zipCode.text?.count == 0 {
            showAlert(title: "Alert", message: "Zip Code cannot be empty")
        }
        else {
            showAlert(title: "Alert", message: "Please enter valid zip code")
        }
    }
    
    @objc func phoneError() {
        if phoneNumber.text?.count == 0 {
            showAlert(title: "Alert", message: "Phone Number cannot be empty")
        }
        else {
            showAlert(title: "Alert", message: "Please enter valid phone number")
        }
    }
    
    
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func setupUpdateApi() {
        
        
        let url = AppURLs.UPDATE_PROFILE

        let parameters: [String:Any] = [
            "merchant_id": setup?.merchant_id ?? "",
            "address1": streetAddress.text!,
            "address2": "",
            "address3": "",
            "state": stateAddress.text!,
            "city": cityAddress.text!,
            "zip": zipCode.text!,
            "phoneNumber": phoneNumber.text!
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.loadIndicator.isAnimating = false
//                    self.showAlert(title: "Success", message: "Updated Successfully")
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func setupLogoutApi() {
        
        let url = AppURLs.LOGOUT

        let parameters: [String:Any] = [
            "merchant_id": setup?.merchant_id ?? "",
            "adv_id": getAdvId()

        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let _ = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    self.showAlertLogout(title: "Alert", message: "Are you sure you want to Logout?")
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getAdvId() -> String {
        let adv_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print(adv_id)
        return adv_id
    }
    
   
    
    func createAttributedText(text: String) ->  NSMutableAttributedString {
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.font, value: UIFont(name: "Manrope-SemiBold", size: 10.0)!, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: textRange)
        return attributedText
    }
    
    func showAlertLogout(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("yes button tapped")
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            UserDefaults.standard.set(false, forKey: "passcheck")
            UserDefaults.standard.set(false, forKey: "fcm_token_set")
            let nav = self.navigationController
            nav!.popToViewController((nav?.viewControllers.first)!, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func stateBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        menu.show()
    }
    
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        
        setupLogoutApi()
    }
    
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        validateUpdateParameters()
        view.endEditing(true)
    }
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
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
                                                                                                                

    func createCustomTextField(textArea: MDCOutlinedTextField) {
        textArea.font = UIFont(name: "Manrope-SemiBold", size: 14.0)
        textArea.setOutlineColor(UIColor(red: 198.0/255.0, green: 207.0/255.0, blue: 219.0/255.0, alpha: 1.0), for: .normal)
        textArea.setOutlineColor(UIColor(red: 198.0/255.0, green: 207.0/255.0, blue: 219.0/255.0, alpha: 1.0), for: .editing)
        textArea.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textArea.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
        textArea.setNormalLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }

    private func setupWhiteUI() {
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

    
}



//struct Profile {
//
//    let a_address_line_1: String
//    let a_address_line_2: String
//    let a_address_line_3: String
//    let a_city: String
//    let a_country: String
//    let a_phone: String
//    let a_state: String
//    let a_zip: String
//    let email: String
//    let f_name: String
//    let l_name: String
//    let logo: String
//    let merchant_id: String
//    let merchant_name: String
//    let phone: String
//    let store_name: String
//}


struct SetupProfile {
    
    let merchant_id: String
    let name: String
    let a_address_line_1: String
    let a_address_line_2: String
    let a_address_line_3: String
    let email: String
    let a_phone: String
    let a_city: String
    let banner_img : String
    let img: String
    let a_state: String
    let a_zip: String
}
