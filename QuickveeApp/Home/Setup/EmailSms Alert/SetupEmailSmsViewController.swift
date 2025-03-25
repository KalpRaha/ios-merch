//
//  SetupEmailSmsViewController.swift
//  
//
//  Created by Jamaluddin Syed on 23/02/23.
//

import UIKit
import MaterialComponents
import Alamofire
import MessageUI

class SetupEmailSmsViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var emailNotiUnder: UILabel!
    @IBOutlet weak var emailAdress: MDCOutlinedTextField!
    @IBOutlet weak var mobileNumber: MDCOutlinedTextField!
    @IBOutlet weak var smsNotiUnder: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var emailNotiSwitch: UISwitch!
    @IBOutlet weak var smsNotiSwitch: UISwitch!
    
    @IBOutlet weak var onlineOrderInfo: UITextView!
    @IBOutlet weak var acceptedView: UIView!
    @IBOutlet weak var packingView: UIView!
    @IBOutlet weak var outDelView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var aceptSmsView: UIView!
    @IBOutlet weak var packingSmsView: UIView!
    @IBOutlet weak var readySmsView: UIView!
    @IBOutlet weak var completedSmsView: UIView!
    @IBOutlet weak var cancelSmsView: UIView!
    
    @IBOutlet weak var acceptedEmailCheck: UIImageView!
    @IBOutlet weak var packEmailCheck: UIImageView!
    @IBOutlet weak var outDelCheck: UIImageView!
    @IBOutlet weak var delCheck: UIImageView!
    @IBOutlet weak var cancelCheck: UIImageView!
    
    @IBOutlet weak var acceptSmsCheck: UIImageView!
    @IBOutlet weak var packingSmsCheck: UIImageView!
    @IBOutlet weak var readySmsCheck: UIImageView!
    @IBOutlet weak var completeSmsCheck: UIImageView!
    @IBOutlet weak var cancelSmsCheck: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var activeTextField = UITextField()
    let email = "vishal@imerchantech.com"

    var setup: SetupEmailSms?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupSwitch()
        emailNotify()
        smsNotify()
        setupTap()
        
        print(setup!)

        let attributeString = NSMutableAttributedString(string: "This service is only available for paid users. Please contact \(email) for more details.")
        attributeString.addAttribute(.foregroundColor, value: UIColor(red: 159.0/255.0, green: 159.0/255.0, blue: 159.0/255.0, alpha: 1.0), range: NSRange(location: 0, length: 61))
        attributeString.addAttribute(.foregroundColor, value: UIColor(red: 159.0/255.0, green: 159.0/255.0, blue: 159.0/255.0, alpha: 1.0), range: NSRange(location: 81, length: 22))
        attributeString.addAttribute(.font, value: UIFont(name: "Manrope-Medium", size: 12.0)!, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(.link, value: "mailto:\(email)", range: NSRange(location: 62, length: email.count))
        attributeString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 62, length: email.count))
        onlineOrderInfo.attributedText = attributeString
    
        
        emailAdress.delegate = self
        mobileNumber.delegate = self
        
        updateBtn.layer.cornerRadius = 10
        emailNotiSwitch.addTarget(self, action: #selector(emailNotiAction), for: .valueChanged)
        smsNotiSwitch.addTarget(self, action: #selector(smsNotiAction), for: .valueChanged)
        topView.addBottomShadow()
        
        mobileNumber.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        emailAdress.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            emailLabel.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            emailLabel.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupFields() {
        
        createCustomTextField(textField: emailAdress)
        createCustomTextField(textField: mobileNumber)
        
        emailAdress.label.text = "Email Address"

        emailNotiUnder.text = "If would like to receive a copy of your customers online order via email please enter the email address."
        
        mobileNumber.label.text = "Mobile Number"
        
        mobileNumber.keyboardType = .numberPad
        smsNotiUnder.text = "If you would like to receive a text notification with the order details every time an order is placed please enter a number that is able to receive SMS message."
        
        emailAdress.text = setup?.bcc_email
        mobileNumber.text = setup?.msg_no
        
        if setup?.enable_email == "1" {
            emailAdress.isUserInteractionEnabled = true
            emailAdress.setTextColor(.black, for: .normal)
        }
        else {
            emailAdress.isUserInteractionEnabled = false
            emailAdress.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        }
        
        if setup?.enable_message == "1" {
            mobileNumber.isUserInteractionEnabled = true
            mobileNumber.setTextColor(.black, for: .normal)
        }
        else {
            mobileNumber.isUserInteractionEnabled = false
            mobileNumber.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        }
    }
    
    func setupSwitch() {
        
        emailNotiSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        smsNotiSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
       
        emailNotiSwitch.isOn = checkEmailEnable()
        smsNotiSwitch.isOn = checkSmsEnable()
    }
    
    func checkEmailEnable() -> Bool {
        
        if setup?.enable_email == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func checkSmsEnable() -> Bool {
        
        if setup?.enable_message == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func emailNotify() {
        
        if (setup?.enable_order_status_email.contains("1"))! {
            acceptedEmailCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: acceptedView, opaque: 1)
        }
        else {
            acceptedEmailCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: acceptedView, opaque: 0)
        }
        
        if (setup?.enable_order_status_email.contains("2"))! {
            packEmailCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: packingView, opaque: 1)
        }
        else {
            packEmailCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: packingView, opaque: 0)
        }
        
        if (setup?.enable_order_status_email.contains("3"))! {
            outDelCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: outDelView, opaque: 1)
        }
        else {
            outDelCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: outDelView, opaque: 0)
        }
        
        if (setup?.enable_order_status_email.contains("4"))! {
            delCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: deliveryView, opaque: 1)
        }
        else {
            delCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: deliveryView, opaque: 0)
        }
        
        if (setup?.enable_order_status_email.contains("5"))! {
            cancelCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: cancelView, opaque: 1)
        }
        else {
            cancelCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: cancelView, opaque: 0)
        }
        
        acceptedView.layer.cornerRadius = 5.0
        packingView.layer.cornerRadius = 5.0
        outDelView.layer.cornerRadius = 5.0
        deliveryView.layer.cornerRadius = 5.0
        cancelView.layer.cornerRadius = 5.0
        
    }

    
    func smsNotify() {
        
        if (setup?.enable_order_status_msg.contains("1"))! {
            acceptSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: aceptSmsView, opaque: 1)

        }
        else {
            acceptSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: aceptSmsView, opaque: 0)
        }
        
        if (setup?.enable_order_status_msg.contains("2"))! {
            packingSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: packingSmsView, opaque: 1)

        }
        else {
            packingSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: packingSmsView, opaque: 0)

        }
        
        if (setup?.enable_order_status_msg.contains("3"))! {
            readySmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: readySmsView, opaque: 1)

        }
        else {
            readySmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: readySmsView, opaque: 0)

        }
        
        if (setup?.enable_order_status_msg.contains("4"))! {
            completeSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: completedSmsView, opaque: 1)

        }
        else {
            completeSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: completedSmsView, opaque: 0)

        }
        
        if (setup?.enable_order_status_msg.contains("5"))! {
            cancelSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: cancelSmsView, opaque: 1)
        }
        else {
            cancelSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: cancelSmsView, opaque: 0)
        }
        
        aceptSmsView.layer.cornerRadius = 5.0
        packingSmsView.layer.cornerRadius = 5.0
        readySmsView.layer.cornerRadius = 5.0
        completedSmsView.layer.cornerRadius = 5.0
        cancelSmsView.layer.cornerRadius = 5.0
    }
    
    func setupTap() {
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(acceptedClick))
        acceptedView.isUserInteractionEnabled = true
        acceptedView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(packedClick))
        packingView.isUserInteractionEnabled = true
        packingView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(outDelClick))
        outDelView.isUserInteractionEnabled = true
        outDelView.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(delClick))
        deliveryView.isUserInteractionEnabled = true
        deliveryView.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(cancelClick))
        cancelView.isUserInteractionEnabled = true
        cancelView.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(acceptedSmsClick))
        aceptSmsView.isUserInteractionEnabled = true
        aceptSmsView.addGestureRecognizer(tap6)
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(packedSmsClick))
        packingSmsView.isUserInteractionEnabled = true
        packingSmsView.addGestureRecognizer(tap7)
        
        let tap8 = UITapGestureRecognizer(target: self, action: #selector(readySmsClick))
        readySmsView.isUserInteractionEnabled = true
        readySmsView.addGestureRecognizer(tap8)
        
        let tap9 = UITapGestureRecognizer(target: self, action: #selector(completeSmsClick))
        completedSmsView.isUserInteractionEnabled = true
        completedSmsView.addGestureRecognizer(tap9)
        
        let tap10 = UITapGestureRecognizer(target: self, action: #selector(cancelSmsClick))
        cancelSmsView.isUserInteractionEnabled = true
        cancelSmsView.addGestureRecognizer(tap10)
    }
    
    @objc func emailNotiAction(emailSwitch: UISwitch) {
        
        if emailSwitch.isOn {
            emailSwitch.isOn = true
            emailAdress.isUserInteractionEnabled = true
            emailAdress.setTextColor(.black, for: .normal)
        }
        else {
            emailSwitch.isOn = false
            emailAdress.isUserInteractionEnabled = false
            emailAdress.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
            emailAdress.trailingView?.isHidden = true
            createCustomTextField(textField: emailAdress)
        }
    }
    
    @objc func emailSend(gesture: UITapGestureRecognizer) {
        
        let url = URL(string: email)!
        
            UIApplication.shared.open(url)
        
    }
    

    
    @objc func smsNotiAction(smsSwitch: UISwitch) {
        
        if smsSwitch.isOn {
            smsSwitch.isOn = true
            mobileNumber.isUserInteractionEnabled = true
            mobileNumber.setTextColor(.black, for: .normal)

        }
        else {
            smsSwitch.isOn = false
            mobileNumber.isUserInteractionEnabled = false
            mobileNumber.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
            mobileNumber.trailingView?.isHidden = true
            createCustomTextField(textField: mobileNumber)
        }
    }
    
    @objc func emailEdit() {
        
        if emailAdress.text?.count == 0 {
            showAlert(title: "Alert", message: "Email address cannot be blank")
        }
        
        else {
            showAlert(title: "Alert", message: "Please enter valid email address.")
        }

    }
    
    @objc func numberEdit() {
       
        if emailAdress.text?.count == 0 {
            showAlert(title: "Alert", message: "Phone Number cannot be blank")
        }
        
        else {
            showAlert(title: "Alert", message: "Please enter valid phone number.")
        }

    }
    
    func validateParameters() {
        
        var email_enable = ""
        var msg_enable = ""
        var email = ""
        var phone = ""
       
        let email_id = setup?.merchant_id
        
        if checkEmailParams() == "1" {
            email_enable = "1"
            guard let email_check = emailAdress.text, email_check != "", validateEmailAddress(email: email_check) else {
                emailAdress.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                emailAdress.trailingView = button
                emailAdress.trailingViewMode = .always
                button.addTarget(self, action: #selector(emailEdit), for: .touchUpInside)
                return
            }
            email = email_check
        }

        else {
            email_enable = "0"
            email = ""
        }

        if checkSmsParams() == "1" {
            msg_enable = "1"
            guard let msg_check = mobileNumber.text, msg_check != "", mobileValidate(number: msg_check) else {
                mobileNumber.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                mobileNumber.trailingView = button
                mobileNumber.trailingViewMode = .always
                button.addTarget(self, action: #selector(numberEdit), for: .touchUpInside)
                return
            }
            phone = msg_check
        }

        else {
            msg_enable = "0"
            phone = ""
        }
        
        let email_cust = checkEmailCust()
        let phone_cust = checkMsgCust()
        
        loadingIndicator.isAnimating = true
        
        setupApi(merchant_id: email_id!, email_enable: email_enable, msg_enable: msg_enable, email: email,
                 phone: phone, email_cust: email_cust, phone_cust: phone_cust)
    }
    
    func setupApi(merchant_id: String, email_enable: String, msg_enable: String, email: String, phone: String,
                  email_cust: String, phone_cust: String) {
        
        let url = AppURLs.UPDATE_STORE_ALERTS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "enable_email": email_enable,//0
            "enable_msg": msg_enable,//0
            "enable_email_customer": email_cust,//1,2,3,4,5
            "enable_message_customer": phone_cust,//1,2,3,4,5
            "email_id": email,
            "phone_no": phone//789456123
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {

            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.loadingIndicator.isAnimating = false
//                    self.showAlert(title: "Success", message: "Updated Successfully!")
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                catch {
                    
                }
                
                break

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func mobileValidate(number: String) -> Bool {
        
        if number.count < 10 {
            return false
        }
        else {
            return true
        }
    }
    
    func checkEmailParams() -> String {
        
        if emailNotiSwitch.isOn {
            return "1"
        }
        
        else {
            return "0"
        }
    }
    
    func checkSmsParams() -> String {
        
        if smsNotiSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkEmailCust() -> String {
        
        var email_cust = ""
        
        if acceptedEmailCheck.image == UIImage(named: "circle_check") {
            email_cust = "1,"
        }
        
        if packEmailCheck.image == UIImage(named: "circle_check") {
            email_cust += "2,"
        }
        
        if outDelCheck.image == UIImage(named: "circle_check") {
            email_cust += "3,"
        }
        
        if delCheck.image == UIImage(named: "circle_check") {
            email_cust += "4,"
        }
        
        if cancelCheck.image == UIImage(named: "circle_check") {
            email_cust += "5"
        }
        
        return email_cust
    }
    
    func checkMsgCust() -> String {
        
        var msg_cust = ""
        
        if acceptSmsCheck.image == UIImage(named: "circle_check") {
            msg_cust = "1,"
        }
        
        if packingSmsCheck.image == UIImage(named: "circle_check") {
            msg_cust += "2,"
        }
        
        if readySmsCheck.image == UIImage(named: "circle_check") {
            msg_cust += "3,"
        }
        
        if completeSmsCheck.image == UIImage(named: "circle_check") {
            msg_cust += "4,"
        }
        
        if cancelSmsCheck.image == UIImage(named: "circle_check") {
            msg_cust += "5"
        }
        
        return msg_cust
    }
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        view.endEditing(true)
        validateParameters()
    }
    
    @objc func acceptedClick() {
        
        if acceptedEmailCheck.image == UIImage(named: "circle_check") {
            acceptedEmailCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: acceptedView, opaque: 0)
        }
        
        else {
            acceptedEmailCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: acceptedView, opaque: 1)
        }
        
    }
    
    @objc func packedClick() {
        if packEmailCheck.image == UIImage(named: "circle_check") {
            packEmailCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: packingView, opaque: 0)
        }
        
        else {
            packEmailCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: packingView, opaque: 1)
            
        }
    }
    
    @objc func outDelClick() {
        if outDelCheck.image == UIImage(named: "circle_check") {
            outDelCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: outDelView, opaque: 0)
            
        }
        
        else {
            outDelCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: outDelView, opaque: 1)
            
        }
    }
    
    @objc func delClick() {
        if delCheck.image == UIImage(named: "circle_check") {
            delCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: deliveryView, opaque: 0)
            
        }
        
        else {
            delCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: deliveryView, opaque: 1)
            
        }
    }
    
    @objc func cancelClick() {
        if cancelCheck.image == UIImage(named: "circle_check") {
            cancelCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: cancelView, opaque: 0)
            
        }
        
        else {
            cancelCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: cancelView, opaque: 1)
        }
    }
    
    @objc func acceptedSmsClick() {
        
        if acceptSmsCheck.image == UIImage(named: "circle_check") {
            acceptSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: aceptSmsView, opaque: 0)
            
        }
        
        else {
            acceptSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: aceptSmsView, opaque: 1)
            
        }
    }
    
    @objc func packedSmsClick() {
        
        if packingSmsCheck.image == UIImage(named: "circle_check") {
            packingSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: packingSmsView, opaque: 0)
        }
        
        else {
            packingSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: packingSmsView, opaque: 1)
            
        }
    }
    
    @objc func readySmsClick() {
        if readySmsCheck.image == UIImage(named: "circle_check") {
            readySmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: readySmsView, opaque: 0)
        }
        
        else {
            readySmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: readySmsView, opaque: 1)
        }
    }
    
    @objc func completeSmsClick() {
        if completeSmsCheck.image == UIImage(named: "circle_check") {
            completeSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: completedSmsView, opaque: 0)
            
        }
        
        else {
            completeSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: completedSmsView, opaque: 1)
        }
    }
    
    @objc func cancelSmsClick() {
        if cancelSmsCheck.image == UIImage(named: "circle_check") {
            cancelSmsCheck.image = UIImage(named: "circle_uncheck")
            addShadow(viewShadow: cancelSmsView, opaque: 0)
            
        }
        
        else {
            cancelSmsCheck.image = UIImage(named: "circle_check")
            addShadow(viewShadow: cancelSmsView, opaque: 1)
        }
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
    
    func addShadow(viewShadow: UIView, opaque: Float) {
        viewShadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        viewShadow.layer.shadowOpacity = opaque
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 3
        
        if opaque == 0 {
            viewShadow.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
            viewShadow.layer.borderWidth = 1.0
        }
        
        else {
            viewShadow.layer.borderWidth = 0
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }

    
    func validateEmailAddress(email: String) -> Bool {
        
        if email != "" && validateEmail(email: email) {
            return true
        }
        
        else {
            return false
        }
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
   
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {

        var updatetext = textField.text ?? ""
        
        if textField == mobileNumber  {
            
            if updatetext.count == 11 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext.count > 0 {
                createCustomTextField(textField: mobileNumber)
                mobileNumber.trailingView?.isHidden = true
            }
        }
        
        if textField == emailAdress  {
            
             if updatetext.count > 0 {
                createCustomTextField(textField: emailAdress)
                emailAdress.trailingView?.isHidden = true
            }
        }
        
        activeTextField.text = updatetext
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
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
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Medium", size: 14.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
    }
    
//    func createAttributedText(text: String) -> NSMutableAttributedString {
//        print(text.count)
//        let textRange = NSRange(location: 0, length: text.count)
//        let attributedText = NSMutableAttributedString(string: text)
//        attributedText.addAttribute(.underlineStyle,
//                                    value: NSUnderlineStyle.single.rawValue,
//                                    range: textRange)
//        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: textRange)
//
//        return attributedText
//    }
    
//    func createAttributedTextBefore(text: String) -> NSMutableAttributedString {
//        print(text.count)
//        let textRange = NSRange(location: 0, length: text.count)
//        let attributedText = NSMutableAttributedString(string: text)
//        attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
//                                    value: UIColor(red: 159.0/255.0, green: 159.0/255.0, blue: 159.0/255.0, alpha: 1.0), range: textRange)
//
//        return attributedText
//    }
}

struct SetupEmailSms {
    
    let merchant_id: String
    let enable_email: String
    let enable_message: String
    let bcc_email: String
    let msg_no: String
    let enable_order_status_email: String
    let enable_order_status_msg: String
}
