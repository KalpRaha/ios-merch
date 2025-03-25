//
//  StoreOptionsViewController.swift
//  
//
//  Created by Jamaluddin Syed on 21/02/23.
//

import UIKit
import MaterialComponents
import Alamofire

class StoreOptionsViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var enableOrderSwitch: UISwitch!
    @IBOutlet weak var resetTime: MDCOutlinedTextField!
    @IBOutlet weak var autoPrintOrder: UILabel!
    @IBOutlet weak var autoOrderSwitch: UISwitch!
    @IBOutlet weak var autoPrintPay: UILabel!
    @IBOutlet weak var enableFutureSwitch: UISwitch!
    @IBOutlet weak var autoPaySwitch: UISwitch!
    @IBOutlet weak var advanceDayCount: UILabel!
    @IBOutlet weak var futureDayCount: MDCOutlinedTextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    
    @IBOutlet weak var enableVoidSwitch: UISwitch!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var storeOptionsLbl: UILabel!
    var activeTextField = UITextField()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var setup: StoreOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
        updateBtn.layer.cornerRadius = 10
        
        setupFields()
        setupSwitch()
    
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "alarm")
        resetTime.trailingView = imageView
        resetTime.trailingViewMode = .always

        resetTime.delegate = self
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()

        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            storeOptionsLbl.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            storeOptionsLbl.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupFields() {
        

        createCustomTextField(textField: futureDayCount)
        createCustomTextField(textField: resetTime)
        
        futureDayCount.addTarget(self, action: #selector(updateTextField), for: .editingChanged)

        
        resetTime.label.text = "Reset Time"
        resetTime.text = setup?.reset_order_time
        
        futureDayCount.label.text = "Future Day Count"
        futureDayCount.text = setup?.advance_count
        
        futureDayCount.keyboardType = .numberPad
        autoPrintOrder.text = "Auto Print Orders to packing receipt\nprinter?"
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        if textField == futureDayCount {
            if textField.text == "1" || textField.text == "2" || textField.text == "3"
                || textField.text == "4" || textField.text == "5" || textField.text == "6"
                || textField.text == "7" || textField.text == "8" || textField.text == "9"
                {
                futureDayCount.trailingView?.isHidden = true
                createCustomTextField(textField: futureDayCount)
            }
        }
    }
    
    func setupSwitch() {
        
        enableOrderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        autoOrderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        autoPaySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableFutureSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableVoidSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        enableOrderSwitch.isOn = checkEnableOrder()
        autoOrderSwitch.isOn = checkEnableKitchen()
        autoPaySwitch.isOn = checkEnablePay()
        enableFutureSwitch.isOn = checkEnableFuture()
        enableVoidSwitch.isOn = checkEnableVoid()
        
        enableOrderSwitch.addTarget(self, action: #selector(enableSwitchAction), for: .valueChanged)
        autoOrderSwitch.addTarget(self, action: #selector(autoOrderSwitchAction), for: .valueChanged)
        autoPaySwitch.addTarget(self, action: #selector(autoPayAction), for: .valueChanged)
        enableFutureSwitch.addTarget(self, action: #selector(enableFutureAction), for: .valueChanged)
        enableVoidSwitch.addTarget(self, action: #selector(enableVoidAction), for: .valueChanged)
    }
    
    func checkEnableOrder() -> Bool {
        
        if setup?.enable_order_number == "1" {
            resetTime.isUserInteractionEnabled = true
            resetTime.setTextColor(UIColor.black, for: .normal)
            UserDefaults.standard.set(true, forKey: "order_number_enable")
            return true
        }
        else {
            resetTime.isUserInteractionEnabled = false
            resetTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
            UserDefaults.standard.set(false, forKey: "order_number_enable")
            return false
        }
    }
    
    func enableOrderParams() -> String {
        
        if enableOrderSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func enableVoidOrder() -> String {
        
        if enableVoidSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkEnableKitchen() -> Bool {
        if setup?.auto_print_kitchen == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func kitchenParams() -> String {
        
        if autoOrderSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkEnablePay() -> Bool {
        
        if setup?.auto_print_payment == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func payParams() -> String {
        
        if autoPaySwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkEnableFuture() -> Bool{
        
        if setup?.future_ordering == "1" {
            futureDayCount.isUserInteractionEnabled = true
            futureDayCount.setTextColor(.black, for: .normal)
            return true
        }
        else {
            futureDayCount.isUserInteractionEnabled = false
            futureDayCount.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
            return false
        }
    }
    
    func checkEnableVoid() -> Bool {
        
        if setup?.enable_void_order == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func futureParams() -> String {
        
        if enableFutureSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    
    @objc func enableSwitchAction(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            enableVoidSwitch.isOn = false
            resetTime.isUserInteractionEnabled = true
            resetTime.setTextColor(.black, for: .normal)
        }
        else {
            enableSwitch.isOn = false
        }
    }
   
    @objc func autoOrderSwitchAction(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
        }
        else {
            enableSwitch.isOn = false
        }
    }
    
    @objc func autoPayAction(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
        }
        else {
            enableSwitch.isOn = false
        }
    }
    
    @objc func enableFutureAction(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            futureDayCount.isUserInteractionEnabled = true
            futureDayCount.setTextColor(.black, for: .normal)
        }
        else {
            enableSwitch.isOn = false
            futureDayCount.isUserInteractionEnabled = false
            futureDayCount.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
            futureDayCount.text = ""
        }
    }
    
    @objc func enableVoidAction(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            enableOrderSwitch.isOn = false
            resetTime.isUserInteractionEnabled = false
            resetTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            enableSwitch.isOn = false
        }
    }
    
    @IBAction func homeButtonClick(_ sender: UIButton) {
        
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
    
    
    @IBAction func enableOrderInfo(_ sender: UIButton) {
        
        let message = "Please select a time to reset the order numbers. Orders numbers will reset to 1 (one) at the selected time on a daily basis."
        showAlert(title: "Info", message: message)
    }
    
    
    @IBAction func futureOrderInfo(_ sender: UIButton) {
        
        let message = "Up to how many days in advance will you accept future orders? 1 = Today"
        showAlert(title: "Info", message: message)
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
    
    @objc func daysError() {
        
        if futureDayCount.text!.count == 0 {
            showAlert(title: "Alert", message: "Future order days, if enabled, cannot be empty")
        }
        else if  futureDayCount.text == "0" {
            showAlert(title: "Alert", message: "Future order days, if enabled, must be greater than equal to 1")
        }
        else {
            showAlert(title: "Alert", message: "Please enter a valid day count that is less than or equal to 12")
        }
    }
    
    func validateParameters() {
        
        var enable_online = ""
        var reset_time = ""
        var enable_future = ""
        var day_count = ""
        var void_order = ""
        
        let email = setup?.merchant_id
        
        let user_id = setup?.id
        
        if enableOrderParams() == "1" {
            enable_online = "1"
            reset_time = resetTime.text!
        }
        else {
            enable_online = "0"
            reset_time = ""
        }
        
        if enableVoidOrder() == "1" {
            void_order = "1"
        }
        else {
            void_order = "0"
        }
        
        if futureParams() == "1" {
            enable_future = "1"
            guard let day = futureDayCount.text, day != "", validateDays(days: day) else {
                futureDayCount.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                futureDayCount.trailingView = button
                futureDayCount.trailingViewMode = .always
                button.addTarget(self, action: #selector(daysError), for: .touchUpInside)
                loadingIndicator.isAnimating = false
                return
            }
            day_count = day
        }
        else {
            enable_future = "0"
            day_count = ""
        }
        
        loadingIndicator.isAnimating = true
        
        if enable_online == "1" {
            UserDefaults.standard.set(true, forKey: "order_number_enable")
        }
        else {
            UserDefaults.standard.set(false, forKey: "order_number_enable")
        }
        
        setupApi(merchant_id: email!, id: user_id!, enable_online: enable_online, reset_time: reset_time, 
                 enable_future: enable_future, day_count: day_count, enable_void_order: void_order)
    }
    
    func setupApi(merchant_id: String, id: String, 
                  enable_online: String, reset_time: String,
                  enable_future: String, day_count: String, enable_void_order: String) {
        
        let url = AppURLs.UPDATE_STORE_OPTIONS

        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "user_id": id,
            "enable_order_number": enable_online,//0
            "order_reset_time": reset_time,
            "enable_kitchen_receipt": kitchenParams(),//0
            "enable_payment_receipt": payParams(),//0
            "enable_future_order": enable_future,//0
            "adv_day_count": day_count,
            "enable_void_order": enable_void_order
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                self.loadingIndicator.isAnimating = false
//                self.showAlert(title: "Success", message: "Updated Successfully.")
                ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func validateDays(days: String) -> Bool {
        
        let dayCount = Int(days)
        
        if dayCount! > 0 && dayCount! <= 12 {
            return true
        }
        
        else {
            return false
        }
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        view.endEditing(true)
        validateParameters()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == resetTime {
            activeTextField = textField
            openDatePicker(textField: resetTime)
        }
    }
    
    func openDatePicker(textField: UITextField) {
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        datePicker.datePickerMode = .time
        doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    
        resetTime.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        resetTime.inputAccessoryView = toolbar
        
    }
    
    @objc func timeDoneBtn() {
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let timeFormat = DateFormatter()
            timeFormat.timeStyle = .short
            activeTextField.text = timeFormat.string(from: datePicker.date)
        }
        activeTextField.resignFirstResponder()
    }
    
    @objc func cancelBtnClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        
        print(datePicker.date)
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
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Medium", size: 13.0)
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

struct StoreOptions {
    
    let merchant_id: String
    let id: String
    let enable_order_number: String
    let reset_order_time: String
    let auto_print_kitchen: String
    let auto_print_payment: String
    let future_ordering: String
    let advance_count: String
    let enable_void_order: String
}

