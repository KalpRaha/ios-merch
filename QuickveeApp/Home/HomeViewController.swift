//
//  HomeViewController.swift
//
//
//  Created by Jamaluddin Syed on 11/01/23.
//

import UIKit
import Alamofire
import Nuke
import LocalAuthentication
import AdSupport
import WebKit

protocol SwitchStoreDelegate: AnyObject {
    
    func setPresent(id: String)
}

protocol UpdateEmpNameDelegate: AnyObject {
    
    func updateName(name: String)
}

protocol UpdatePermissionDelegate: AnyObject {
    
    func updatePermission()
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var merchant_Name: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var changeView: UIView!
    
    @IBOutlet weak var topmidview: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var lockView: UIView!
    
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var lockScreenLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!
    
    @IBOutlet weak var collection: UICollectionView!
    
    let tabs = ["Orders", "Dashboard", "Inventory", "Customers", "More"]
    
    let tabsColor = ["#6879E3", "#F55353", "#10C0EE", "#10C0EE", "#10C0EE", "#4DE060"]
    
    var merchant_id: String?
    var new_count = "0"
    var isSetup = false
    
    var isLottery = false
    
    var page: URL?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "passcheck")
        view.clipsToBounds = true
        topView.layer.cornerRadius = 10
        
        UserDefaults.standard.set(false, forKey: "run_appdelegate")
        
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        logoImage.layer.cornerRadius = logoImage.bounds.size.width / 2
        
        let lockGest = UITapGestureRecognizer(target: self, action: #selector(lockClick))
        lockScreenLbl.addGestureRecognizer(lockGest)
        lockScreenLbl.isUserInteractionEnabled = true
        lockGest.numberOfTapsRequired = 1
        
        let logGest = UITapGestureRecognizer(target: self, action: #selector(logClick))
        logoutLbl.addGestureRecognizer(logGest)
        logoutLbl.isUserInteractionEnabled = true
        logGest.numberOfTapsRequired = 1
        
        let logoImageGest = UITapGestureRecognizer(target: self, action: #selector(logoClick))
        changeView.addGestureRecognizer(logoImageGest)
        changeView.isUserInteractionEnabled = true
        logoImageGest.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        loadingIndicator.isAnimating = true
        collection.isHidden = true
        
        if !UserDefaults.standard.bool(forKey: "fcm_token_set") {
            setToken()
            UserDefaults.standard.set(true, forKey: "fcm_token_set")
        }
        else {
            setupApi()
            resetDefaults()
        }
        dropView.isHidden = true
        dropView.layer.cornerRadius = 10.0
        
        changeView.layer.cornerRadius = 10.0
        logoutView.layer.cornerRadius = 10.0
        
        changeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        logoutView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    func setToken() {
        
        let merch = merchant_id ?? ""
        let token = UserDefaults.standard.string(forKey: "fcm_token") ?? ""
        let adv_id = getAdvId()
        
        ApiCalls.sharedCall.setFcmToken(merchant_id: merch, adv_id: adv_id, fcm_token: token) { isSuccess, responseData in
            
            if isSuccess {
                self.setupApi()
                self.resetDefaults()
            }
            
            else {
                print("failed")
            }
        }
    }
    
    func getAdvId() -> String {
        
        let adv_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return adv_id
    }
    
    
    @objc func lockClick() {
        
        dropView.isHidden = true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "lockPass") as! LockPassCodeViewController
        vc.updateDelegate = self
        
        UserDefaults.standard.set("home", forKey: "lockSource")
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func logClick() {
        
        dropView.isHidden = true
        showAlertLogout(title: "Alert", message: "Are you sure you want to Logout?")
    }
    
    @objc func logoClick() {
        
        ApiCalls.sharedCall.cancelRequest()
        dropView.isHidden = true
        setUpPostMethod()
    }
    
    func setUpPostMethod() {
        
        collection.isHidden = true
        loadingIndicator.isAnimating = true
        
        let email = UserDefaults.standard.string(forKey: "merchant_email") ?? ""
        let password = UserDefaults.standard.string(forKey: "merchant_password") ?? ""
        
        let parameters: [String: Any] = [
            "email_id": email,
            "password": password
        ]
        
        print(parameters)
        print(parameters)
        
        let url = AppURLs.ALL_STORES
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    if json["result"] == nil {
                        self.collection.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: "You have access to only one store",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        self.getResponseValues(response: json["result"])
                    }
                }
                catch {
                    self.collection.isHidden = false
                    self.loadingIndicator.isAnimating = false
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                self.collection.isHidden = false
                self.loadingIndicator.isAnimating = false
                
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
        
        let stores = UserDefaults.standard.string(forKey: "assigned_store") ?? ""
        
        var storeArray = [Store]()
        
        for store in storeList {
            
            if stores.contains(store.merchant_id) {
                storeArray.append(store)
            }
        }
        
        if storeArray.count < 2 {
            
            ToastClass.sharedToast.showToast(message: "You have access to only one store",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            self.collection.isHidden = false
            self.loadingIndicator.isAnimating = false
        }
        
        else {
            
            self.collection.isHidden = false
            self.loadingIndicator.isAnimating = false
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "storelist") as! StoreViewController
            vc.storeArray = storeArray
            vc.mode = "switch"
            vc.delegate = self
            
            let email = UserDefaults.standard.string(forKey: "merchant_email") ?? ""
            let password = UserDefaults.standard.string(forKey: "merchant_password") ?? ""
            vc.current_email = email
            vc.current_Password = password
            present(vc, animated: true)
        }
    }
 
    func setupLogoutApi() {
        
        let url = AppURLs.LOGOUT
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
            "adv_id": getAdvId()
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let _ = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    UserDefaults.standard.set(false, forKey: "LoggedIn")
                    UserDefaults.standard.set(false, forKey: "passcheck")
                    UserDefaults.standard.set(false, forKey: "fcm_token_set")
                    
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
    
    func showAlertLogout(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("yes button tapped")
            ApiCalls.sharedCall.cancelRequest()
            self.setupLogoutApi()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    func setupApi() {
        
        let url = AppURLs.HOME_ALL_DATA
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    self.getResponseValues(store_name: "\(json["store_name"] ?? "")",
                                           logo: "\(json["store_logo"] ?? "")",
                                           dispatch_status: "\(json["dispatch_status"] ?? "")")
                }
                catch {
                    
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getResponseValues(store_name: String, logo: String, dispatch_status: String) {
        
        storeName.text = store_name
        
        UserDefaults.standard.set(store_name, forKey: "store_name")
        
        let img_url = "\(AppURLs.STORE_LOGO)\(logo)"
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "merchant"), transition: .fadeIn(duration: 0.5))
        
        Nuke.loadImage(with: img_url, options: options, into: logoImage)
        
        let name = UserDefaults.standard.string(forKey: "merchant_name") ?? ""
        
        print(name)
        merchant_Name.text = name
        
        UserDefaults.standard.set(dispatch_status, forKey: "dispatch_status_delivery")
        
        getApiCallData()
    }
    
    func getApiCallData() {
        
        let url = AppURLs.STORE_DETAILS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id!
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    guard let jsonDict = json["result"] else {
                        return
                    }
                    
                    self.getResponseValues(responseValues: jsonDict)
                    break
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getResponseValues(responseValues: Any) {
        
        
        let response = responseValues as! [String:Any]
        
        let enable = response["enable_order_number"] as! String
        
        if enable == "1" {
            UserDefaults.standard.set(true, forKey: "order_number_enable")
            
        }
        else {
            UserDefaults.standard.set(false, forKey: "order_number_enable")
            
        }
        
        setupScreensApi()
    }
    
    func setupScreensApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.setRegisterSettings(merchant_id: id) { isSuccess, response in
            
            
            if isSuccess {
                
                self.getResponseLotteryValues(response: response["result"])
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseLotteryValues(response: Any) {
        
        let reg = response as! [String:Any]
        
        let register = Register_Settings(id: "\(reg["id"] ?? "")",
                                         device_name: "\(reg["device_name"] ?? "")",
                                         merchant_id: "\(reg["merchant_id"] ?? "")",
                                         cost_method: "\(reg["cost_method"] ?? "")",
                                         age_verify: "\(reg["age_verify"] ?? "")",
                                         by_scanning: "\(reg["by_scanning"] ?? "")",
                                         inv_setting: "\(reg["inv_setting"] ?? "")",
                                         cost_per: "\(reg["cost_per"] ?? "")",
                                         regi_setting: "\(reg["regi_setting"] ?? "")",
                                         idel_logout: "\(reg["idel_logout"] ?? "")",
                                         return_window: "\(reg["return_window"] ?? "")",
                                         discount_prompt: "\(reg["discount_prompt"] ?? "")",
                                         round_invoice: "\(reg["round_invoice"] ?? "")",
                                         customer_loyalty: "\(reg["customer_loyalty"] ?? "")",
                                         barcode_msg: "\(reg["barcode_msg"] ?? "")",
                                         default_cash_drawer: "\(reg["default_cash_drawer"] ?? "")",
                                         clock_in: "\(reg["clock_in"] ?? "")",
                                         hide_inactive: "\(reg["hide_inactive"] ?? "")",
                                         end_day_Allow: "\(reg["end_day_Allow"] ?? "")",
                                         shift_assign: "\(reg["shift_assign"] ?? "")",
                                         start_date: "\(reg["start_date"] ?? "")",
                                         end_date: "\(reg["end_date"] ?? "")",
                                         start_time: "\(reg["start_time"] ?? "")",
                                         end_time: "\(reg["end_time"] ?? "")",
                                         report_history: "\(reg["report_history"] ?? "")",
                                         emp_permission: "\(reg["iemp_permissiond"] ?? "")",
                                         no_of_station: "\(reg["no_of_station"] ?? "")",
                                         denomination: "\(reg["denomination"] ?? "")",
                                         ebt: "\(reg["ebt"] ?? "")",
                                         enable_cashback_limit: "\(reg["enable_cashback_limit"] ?? "")",
                                         cashback_limit_amount: "\(reg["cashback_limit_amount"] ?? "")",
                                         cashback_charge_amount: "\(reg["cashback_charge_amount"] ?? "")",
                                         enable_autolock_transaction: "\(reg["enable_autolock_transaction"] ?? "")")
        
        setEBT(ebt: register.ebt)
    }
    
    func setEBT(ebt: String) {
        
        if ebt.contains("4") {
            isLottery = true
            UserDefaults.standard.set(true, forKey: "lottery_inventory")
        }
        else {
            isLottery = false
            UserDefaults.standard.set(false, forKey: "lottery_inventory")
        }
        
        collection.isHidden = false
        loadingIndicator.isAnimating = false
        
        setupCount()
    }
    
    func setupCount() {
        
        let merch = merchant_id ?? ""
        
        ApiCalls.sharedCall.newOrderCount(merchant_id: merch) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let res = responseData["result"] else {
                    return
                }
                
                self.new_count = res as? String ?? "0"
                self.collection.reloadData()
                print(res)
                print(self.new_count)
            }
            else{
                print("Api Error")
            }
        }
    }
  
    @IBAction func threeDotsClick(_ sender: UIButton) {
        
        if dropView.isHidden {
            dropView.isHidden = false
            dropView.layer.shadowOpacity = 1
        }
        
        else {
            dropView.isHidden = true
            dropView.layer.shadowOpacity = 0
        }
        dropView.layer.shadowColor =  UIColor.lightGray.cgColor
        dropView.layer.shadowOffset = CGSize.zero
        dropView.layer.shadowRadius = 3
        
    }
    
    func resetDefaults() {
        
        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_sales")
        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_item")
        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_order")
        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_taxes")
        
        UserDefaults.standard.set(0, forKey: "tempOrderSource_sales")
        UserDefaults.standard.set(0, forKey: "tempOrderSource_item")
        UserDefaults.standard.set(0, forKey: "tempOrderSource_order")
        UserDefaults.standard.set(0, forKey: "tempOrderSource_taxes")
        
        UserDefaults.standard.set(0, forKey: "tempOrderType_sales")
        UserDefaults.standard.set(0, forKey: "tempOrderType_item")
        UserDefaults.standard.set(0, forKey: "tempOrderType_taxes")
        
        UserDefaults.standard.set(0, forKey: "tempCategory_item")
        
        
        UserDefaults.standard.set(101, forKey: "dateTimeFilter_sales")
        UserDefaults.standard.set(101, forKey: "dateTimeFilter_item")
        UserDefaults.standard.set(101, forKey: "dateTimeFilter_order")
        UserDefaults.standard.set(101, forKey: "dateTimeFilter_taxes")
        
        UserDefaults.standard.set(0, forKey: "validOrderSource_sales")
        UserDefaults.standard.set(0, forKey: "validOrderSource_item")
        UserDefaults.standard.set(0, forKey: "validOrderSource_order")
        UserDefaults.standard.set(0, forKey: "validOrderSource_taxes")
        
        UserDefaults.standard.set(0, forKey: "validOrderType_sales")
        UserDefaults.standard.set(0, forKey: "validOrderType_item")
        UserDefaults.standard.set(0, forKey: "validOrderType_taxes")
        
        UserDefaults.standard.set(0, forKey: "validCategory_item")
        
        UserDefaults.standard.set(0, forKey: "changeOrderSource_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_item")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_order")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeOrderType_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderType_item")
        UserDefaults.standard.set(0, forKey: "changeOrderType_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeCategory_item")
        
        UserDefaults.standard.set("9", forKey: "orderSource_sales")
        UserDefaults.standard.set("9", forKey: "orderSource_item")
        UserDefaults.standard.set("9", forKey: "orderSource_order")
        UserDefaults.standard.set("9", forKey: "orderSource_taxes")
        
        UserDefaults.standard.set("both", forKey: "orderType_sales")
        UserDefaults.standard.set("both", forKey: "orderType_item")
        UserDefaults.standard.set("both", forKey: "orderType_taxes")
        
        UserDefaults.standard.set("all", forKey: "category_item")
        
        //Setup
        
        UserDefaults.standard.set(10, forKey: "vendorDateMode")
        UserDefaults.standard.set(1, forKey: "vendorDate")
        
        //Order store
        UserDefaults.standard.set("", forKey: "temp_order_paid_start_date")
        UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
        
        UserDefaults.standard.set("", forKey: "temp_order_paid_min_amt")
        UserDefaults.standard.set("", forKey: "temp_order_paid_max_amt")
        
        UserDefaults.standard.set("", forKey: "valid_order_paid_start_date")
        UserDefaults.standard.set("", forKey: "valid_order_paid_end_date")
        
        UserDefaults.standard.set("", forKey: "valid_order_paid_min_amt")
        UserDefaults.standard.set("", forKey: "valid_order_paid_max_amt")
        
        UserDefaults.standard.set("", forKey: "temp_order_refund_start_date")
        UserDefaults.standard.set("", forKey: "temp_order_refund_end_date")
        
        UserDefaults.standard.set("", forKey: "temp_order_refund_min_amt")
        UserDefaults.standard.set("", forKey: "temp_order_refund_max_amt")
        
        UserDefaults.standard.set("", forKey: "valid_order_refund_start_date")
        UserDefaults.standard.set("", forKey: "valid_order_refund_end_date")
        
        UserDefaults.standard.set("", forKey: "valid_order_refund_min_amt")
        UserDefaults.standard.set("", forKey: "valid_order_refund_max_amt")
        
        //online order
        
        UserDefaults.standard.set("", forKey: "temp_order_new_start_date")
        UserDefaults.standard.set("", forKey: "temp_order_new_end_date")
        
        UserDefaults.standard.set("", forKey: "temp_order_new_min_amt")
        UserDefaults.standard.set("", forKey: "temp_order_new_max_amt")
        
        UserDefaults.standard.set("", forKey: "valid_order_new_start_date")
        UserDefaults.standard.set("", forKey: "valid_order_new_end_date")
        
        UserDefaults.standard.set("", forKey: "valid_order_new_min_amt")
        UserDefaults.standard.set("", forKey: "valid_order_new_max_amt")
        
        UserDefaults.standard.set("", forKey: "temp_order_closed_start_date")
        UserDefaults.standard.set("", forKey: "temp_order_closed_end_date")
        
        UserDefaults.standard.set("", forKey: "temp_order_closed_min_amt")
        UserDefaults.standard.set("", forKey: "temp_order_closed_max_amt")
        
        UserDefaults.standard.set("", forKey: "valid_order_closed_start_date")
        UserDefaults.standard.set("", forKey: "valid_order_closed_end_date")
        
        UserDefaults.standard.set("", forKey: "valid_order_closed_min_amt")
        UserDefaults.standard.set("", forKey: "valid_order_closed_max_amt")
        
        UserDefaults.standard.set("", forKey: "temp_order_failed_start_date")
        UserDefaults.standard.set("", forKey: "temp_order_failed_end_date")
        
        UserDefaults.standard.set("", forKey: "temp_order_failed_min_amt")
        UserDefaults.standard.set("", forKey: "temp_order_failed_max_amt")
        
        UserDefaults.standard.set("", forKey: "valid_order_failed_start_date")
        UserDefaults.standard.set("", forKey: "valid_order_failed_end_date")
        
        UserDefaults.standard.set("", forKey: "valid_order_failed_min_amt")
        UserDefaults.standard.set("", forKey: "valid_order_failed_max_amt")
        
        UserDefaults.standard.set("", forKey: "temp_order_new_order_type")
        UserDefaults.standard.set("", forKey: "temp_order_closed_order_type")
        UserDefaults.standard.set("", forKey: "temp_order_failed_order_type")
        
        UserDefaults.standard.set("", forKey: "valid_order_new_order_type")
        UserDefaults.standard.set("", forKey: "valid_order_closed_order_type")
        UserDefaults.standard.set("", forKey: "valid_order_failed_order_type")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toOrders" {
            let vc = segue.destination as! OrdersViewController
            vc.merchant_id = merchant_id
        }
        
        else if segue.identifier == "toReporting" {
            let vc  = segue.destination as! SalesNewViewController
            vc.page = page
            vc.delegate = self
        }
        
        else if segue.identifier == "hometoInventory" {
            _  = segue.destination as! InventoryViewController
        }
        
        else if segue.identifier == "toSetup"  {
            let vc  = segue.destination as! SetupViewController
            vc.merchant_id = merchant_id
            vc.more = isSetup
        }
        
        //        else if segue.identifier == "toGiftCard" {
        //            _  = segue.destination as! GiftCardViewController
        //        }
        
        else if segue.identifier == "toCustomer" {
            _  = segue.destination as! CustomerViewController
        }
        
        //        else  {
        //            _  = segue.destination as! EmployeesViewController
        //        }
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
      
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: collection.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: collection.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}


extension HomeViewController: SwitchStoreDelegate {
    
    func setPresent(id: String) {
        let demo_merchant_id = id
        UserDefaults.standard.set(demo_merchant_id, forKey: "merchant_id")
        navigationController?.popViewController(animated: true)
    }
}

extension HomeViewController: UpdateEmpNameDelegate {
    
    func updateName(name: String) {
        merchant_Name.text = name
    }
}

extension HomeViewController: UpdatePermissionDelegate {
    
    func updatePermission() {
        
        loadingIndicator.isAnimating = true
        collection.isHidden = true
////
////        let merchant = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
////        let pin = UserDefaults.standard.string(forKey: "emp_passcode") ?? ""
////
////        ApiCalls.sharedCall.passCodeCall(merchant_id: merchant, pin: pin, admin_id: merchant) { isSuccess, responseData in
////
////            if isSuccess {
////
////                if let variant = responseData["status"], variant as! Int != 0  {
////                    self.getEmpId(variant: responseData["result"])
////                    self.loadingIndicator.isAnimating = false
////                    self.collection.isHidden = false
////                }
////
////                else {
////                    print("failed")
////                    self.loadingIndicator.isAnimating = false
////                    self.collection.isHidden = false
////                }
////            }
////        }
//        
//        getEmpId()
//    }
//    
//    func getEmpId() {
//        
////        let variant_emp = variant as! [[String: Any]]
////        var per_array = [String]()
////
////        for vari in variant_emp {
////
////            let permission = "\(vari["permissions"] ?? "")"
////            per_array = permission.components(separatedBy: ",")
////        }
////
////        //homescreen
////        if per_array.contains("O") {
////            UserDefaults.standard.set(false, forKey: "lock_orders")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_orders")
////        }
////
////        if per_array.contains("GC") {
////            UserDefaults.standard.set(false, forKey: "lock_gift")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_gift")
////        }
////
////        if per_array.contains("SS") {
////            UserDefaults.standard.set(false, forKey: "lock_setup")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_setup")
////        }
////
////        if per_array.contains("D") {
////            UserDefaults.standard.set(false, forKey: "lock_dashboard")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_dashboard")
////        }
////
////        if per_array.contains("CU") {
////            UserDefaults.standard.set(false, forKey: "lock_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_customer")
////        }
////
////        if per_array.contains("MR") {
////            UserDefaults.standard.set(false, forKey: "lock_more")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_more")
////        }
////
////        //inventory category
////        if per_array.contains("CC") {
////            UserDefaults.standard.set(false, forKey: "lock_add_category")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_category")
////        }
////
////        if per_array.contains("PC") {
////            UserDefaults.standard.set(false, forKey: "lock_disable_category")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_disable_category")
////        }
////
////        if per_array.contains("RC") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_category")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_category")
////        }
////
////        if per_array.contains("UC") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_category")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_category")
////        }
////
////        //inventory items
////
////        if per_array.contains("ED") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_product")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_product")
////        }
////
////        if per_array.contains("AD") {
////            UserDefaults.standard.set(false, forKey: "lock_add_product")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_product")
////        }
////
////        if per_array.contains("DS") {
////            UserDefaults.standard.set(false, forKey: "lock_disable_product")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_disable_product")
////        }
////
////        if per_array.contains("RI") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_product")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_product")
////        }
////
////        //inventory access and manage
////
////        if per_array.contains("AI") {
////            UserDefaults.standard.set(false, forKey: "lock_access_inventory")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_inventory")
////        }
////
////        if per_array.contains("MC") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_categories")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_categories")
////        }
////
////        if per_array.contains("MP") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_products")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_products")
////        }
////
////        if per_array.contains("MA") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_attributes")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_attributes")
////        }
////
////        if per_array.contains("MB") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_brands")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_brands")
////        }
////
////        if per_array.contains("MT") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_tags")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_tags")
////        }
////
////        //stocktake
////
////        if per_array.contains("AK") {
////            UserDefaults.standard.set(false, forKey: "lock_access_stocktake")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_stocktake")
////        }
////
////        if per_array.contains("CK") {
////            UserDefaults.standard.set(false, forKey: "lock_add_stocktake")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_stocktake")
////        }
////
////        if per_array.contains("VK") {
////            UserDefaults.standard.set(false, forKey: "lock_view_stocktake")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_view_stocktake")
////        }
////
////        if per_array.contains("EK") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_stocktake")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_stocktake")
////        }
////
////        if per_array.contains("OK") {
////            UserDefaults.standard.set(false, forKey: "lock_void_stocktake")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_void_stocktake")
////        }
////
////
////        // gift card
////        if per_array.contains("GB") {
////            UserDefaults.standard.set(false, forKey: "lock_add_gift")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_gift")
////        }
////
////        if per_array.contains("RB") {
////            UserDefaults.standard.set(false, forKey: "lock_remove_gift")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_remove_gift")
////        }
////
////        //more
////        if per_array.contains("PS") {
////            UserDefaults.standard.set(false, forKey: "lock_reg_set")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_reg_set")
////        }
////
////        if per_array.contains("QA") {
////            UserDefaults.standard.set(false, forKey: "lock_quick_add")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_quick_add")
////        }
////
////        if per_array.contains("AMM") {
////            UserDefaults.standard.set(false, forKey: "lock_mix_match")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_mix_match")
////        }
////
////        if per_array.contains("AM") {
////            UserDefaults.standard.set(false, forKey: "add_mix_match")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "add_mix_match")
////        }
////
////        if per_array.contains("EM") {
////            UserDefaults.standard.set(false, forKey: "edit_mix_match")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "edit_mix_match")
////        }
////
////        if per_array.contains("DM") {
////            UserDefaults.standard.set(false, forKey: "delete_mix_match")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "delete_mix_match")
////        }
////
////        // store settings
////
////        if per_array.contains("AS") {
////            UserDefaults.standard.set(false, forKey: "lock_store_access")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_store_access")
////        }
////
////        if per_array.contains("ST") {
////            UserDefaults.standard.set(false, forKey: "lock_store_info")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_store_info")
////        }
////
////        if per_array.contains("SE") {
////            UserDefaults.standard.set(false, forKey: "lock_report_time")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_report_time")
////        }
////
////        if per_array.contains("SY") {
////            UserDefaults.standard.set(false, forKey: "lock_system_access")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_system_access")
////        }
////
////        if per_array.contains("AL") {
////            UserDefaults.standard.set(false, forKey: "lock_alert")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_alert")
////        }
////
////        if per_array.contains("OP") {
////            UserDefaults.standard.set(false, forKey: "lock_store_options")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_store_options")
////        }
////
////        if per_array.contains("ALP") {
////            UserDefaults.standard.set(false, forKey: "lock_loyalty_program")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_loyalty_program")
////        }
////
////        if per_array.contains("EL") {
////            UserDefaults.standard.set(false, forKey: "edit_loyalty_program")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "edit_loyalty_program")
////        }
////
////        if per_array.contains("AB") {
////            UserDefaults.standard.set(false, forKey: "add_bonus_points")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "add_bonus_points")
////        }
////
////        if per_array.contains("EB") {
////            UserDefaults.standard.set(false, forKey: "edit_bonus_points")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "edit_bonus_points")
////        }
////
////        if per_array.contains("DB") {
////            UserDefaults.standard.set(false, forKey: "delete_bonus_points")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "delete_bonus_points")
////        }
////
////        if per_array.contains("SC") {
////            UserDefaults.standard.set(false, forKey: "lock_store_setup")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_store_setup")
////        }
////
////        if per_array.contains("IS") {
////            UserDefaults.standard.set(false, forKey: "lock_inventory_settings")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_inventory_settings")
////        }
////
////        //coupon
////        if per_array.contains("AO") {
////            UserDefaults.standard.set(false, forKey: "lock_add_coupon")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_coupon")
////        }
////
////        if per_array.contains("UO") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_coupon")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_coupon")
////        }
////
////        if per_array.contains("RO") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_coupon")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_coupon")
////        }
////
////        if per_array.contains("C") {
////            UserDefaults.standard.set(false, forKey: "lock_access_coupon")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_coupon")
////        }
////
////        //reporting
////        if per_array.contains("DG") {
////            UserDefaults.standard.set(false, forKey: "lock_dashboard_graph")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_dashboard_graph")
////        }
////
////        if per_array.contains("AR") {
////            UserDefaults.standard.set(false, forKey: "lock_access_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_reports")
////        }
////
////        if per_array.contains("SA") {
////            UserDefaults.standard.set(false, forKey: "lock_sales_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_sales_reports")
////        }
////
////        if per_array.contains("IN") {
////            UserDefaults.standard.set(false, forKey: "lock_inventory_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_inventory_reports")
////        }
////
////        if per_array.contains("PA") {
////            UserDefaults.standard.set(false, forKey: "lock_payment_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_payment_reports")
////        }
////
////        if per_array.contains("RA") {
////            UserDefaults.standard.set(false, forKey: "lock_register_activity")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_register_activity")
////        }
////
////        if per_array.contains("RR") {
////            UserDefaults.standard.set(false, forKey: "lock_refund_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_refund_reports")
////        }
////
////        if per_array.contains("LR") {
////            UserDefaults.standard.set(false, forKey: "lock_loyalty_report")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_loyalty_report")
////        }
////
////        if per_array.contains("SR") {
////            UserDefaults.standard.set(false, forKey: "lock_sc_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_sc_reports")
////        }
////
////        if per_array.contains("GR") {
////            UserDefaults.standard.set(false, forKey: "lock_gc_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_gc_reports")
////        }
////
////        if per_array.contains("CM") {
////            UserDefaults.standard.set(false, forKey: "lock_customer_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_customer_reports")
////        }
////
////        if per_array.contains("ER") {
////            UserDefaults.standard.set(false, forKey: "lock_employee_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_employee_reports")
////        }
////
////        if per_array.contains("TR") {
////            UserDefaults.standard.set(false, forKey: "lock_tax_reports")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_tax_reports")
////        }
////
////        if per_array.contains("EH") {
////            UserDefaults.standard.set(false, forKey: "lock_employee_hours")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_employee_hours")
////        }
////
////        //customers
////
////        if per_array.contains("AU") {
////            UserDefaults.standard.set(false, forKey: "lock_add_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_customer")
////        }
////
////        if per_array.contains("UU") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_customer")
////        }
////
////        if per_array.contains("PU") {
////            UserDefaults.standard.set(false, forKey: "lock_disable_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_disable_customer")
////        }
////
////        if per_array.contains("RU") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_customer")
////        }
////
////        if per_array.contains("IP") {
////            UserDefaults.standard.set(false, forKey: "lock_add_points_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_points_customer")
////        }
////
////        if per_array.contains("DP") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_points_customer")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_points_customer")
////        }
////
////        //vendors
////
////        if per_array.contains("CV") {
////            UserDefaults.standard.set(false, forKey: "lock_add_vendors")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_add_vendors")
////        }
////
////        if per_array.contains("UV") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_vendors")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_vendors")
////        }
////
////        if per_array.contains("PV") {
////            UserDefaults.standard.set(false, forKey: "lock_disable_vendors")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_disable_vendors")
////        }
////
////        if per_array.contains("AV") {
////            UserDefaults.standard.set(false, forKey: "lock_access_vendors")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_vendors")
////        }
////
////        //PO
////
////        if per_array.contains("EO") {
////            UserDefaults.standard.set(false, forKey: "lock_create_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_create_po")
////        }
////
////        if per_array.contains("VI") {
////            UserDefaults.standard.set(false, forKey: "lock_view_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_view_po")
////        }
////
////        if per_array.contains("EP") {
////            UserDefaults.standard.set(false, forKey: "lock_edit_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_edit_po")
////        }
////
////        if per_array.contains("RP") {
////            UserDefaults.standard.set(false, forKey: "lock_receive_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_receive_po")
////        }
////
////        if per_array.contains("VP") {
////            UserDefaults.standard.set(false, forKey: "lock_void_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_void_po")
////        }
////
////        if per_array.contains("AP") {
////            UserDefaults.standard.set(false, forKey: "lock_access_po")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_po")
////        }
////
////        //taxes
////
////        if per_array.contains("T") {
////            UserDefaults.standard.set(false, forKey: "lock_access_taxes")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_taxes")
////        }
////
////        // orders
////
////        if per_array.contains("UP") {
////            UserDefaults.standard.set(false, forKey: "lock_update_order_status")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_update_order_status")
////        }
////
////        //employees
////
////        if per_array.contains("AE") {
////            UserDefaults.standard.set(false, forKey: "lock_access_employees")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_employees")
////        }
////
////        if per_array.contains("ME") {
////            UserDefaults.standard.set(false, forKey: "lock_manage_employees")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_manage_employees")
////        }
////
////        if per_array.contains("TI") {
////            UserDefaults.standard.set(false, forKey: "lock_access_timesheet")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_access_timesheet")
////        }
////
////        if per_array.contains("DE") {
////            UserDefaults.standard.set(false, forKey: "lock_delete_employees")
////        }
////        else {
////            UserDefaults.standard.set(true, forKey: "lock_delete_employees")
////        }
//        
//        
        let websiteDataTypes: Set<String> = [
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeSessionStorage]
        
        let dateFrom = Date(timeIntervalSince1970: 0) // To remove all data
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            print("Website data cleared.")
            UserDefaults.standard.set(true, forKey: "home_return")
            
            self.loadingIndicator.isAnimating = false
            self.collection.isHidden = false
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.homeImage.image = UIImage(named: tabs[indexPath.row])
        
        cell.homeLbl.text = tabs[indexPath.row]
        
        cell.notifyvIEW.layer.cornerRadius = 12.5
        
        cell.colorview.backgroundColor = UIColor(hexString: tabsColor[indexPath.row])
        
        cell.notifyvIEW.backgroundColor = .red
        cell.notifyLbl.font = UIFont(name: "Manrope-Medium", size: 12.0)!
        cell.notifyvIEW.isHidden = true
        cell.notifyLbl.text = "\(new_count)"
        
        if indexPath.row == 0 {
            
            if new_count == "0" {
                cell.notifyLbl.isHidden = true
                cell.notifyvIEW.isHidden = true
            }
            
            else {
                cell.notifyLbl.isHidden = false
                cell.notifyvIEW.isHidden = false
            }
            
        }
        else {
            cell.notifyLbl.isHidden = true
            cell.notifyvIEW.isHidden = true
        }
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        
        cell.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 3
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        if indexPath.row == 0 {
            if UserDefaults.standard.bool(forKey: "lock_orders") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                UserDefaults.standard.set("new", forKey: "modeOnlineSelected")
                performSegue(withIdentifier: "toOrders", sender: nil)
            }
        }
        
        else if indexPath.row == 1 {
            
            // self.performSegue(withIdentifier: "toReporting", sender: nil)
            let email = UserDefaults.standard.string(forKey: "email_webview") ?? ""
            let pass = UserDefaults.standard.string(forKey: "read_pass_webview") ?? ""
            let backend_access = UserDefaults.standard.string(forKey: "backend_access_webview") ?? ""
            
            if email == "" || email == "<null>" || pass == "" || pass == "<null>" || backend_access == "0"
            || UserDefaults.standard.bool(forKey: "lock_dashboard") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                UserDefaults.standard.set(true, forKey: "goToHome")
                self.performSegue(withIdentifier: "toReporting", sender: nil)
            }
            
            
//            if UserDefaults.standard.bool(forKey: "lock_dashboard") {
//                ToastClass.sharedToast.showToast(message: "Access Denied",
//                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            }
//            else {
//                UserDefaults.standard.set(true, forKey: "goToHome")
//                self.performSegue(withIdentifier: "toReporting", sender: nil)
//            }
        }
        
        else if indexPath.row == 2 {
            
            if UserDefaults.standard.bool(forKey: "lock_access_inventory") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                performSegue(withIdentifier: "hometoInventory", sender: nil)
            }
        }
        //            else {
        //                mode = "inventory"
        //                performSegue(withIdentifier: "toReporting", sender: nil)
        //            }
        
        else if indexPath.row == 3 {
            
            if UserDefaults.standard.bool(forKey: "lock_customer") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                performSegue(withIdentifier: "toCustomer", sender: nil)
            }
        }
        
        //        else if indexPath.row == 4 {
        //
        //            if UserDefaults.standard.bool(forKey: "lock_gift_screen") {
        //                ToastClass.sharedToast.showToast(message: "Access Denied",
        //                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        //            }
        //            else {
        //                performSegue(withIdentifier: "toGiftCard", sender: nil)
        //            }
        //        }
        
        //        else if indexPath.row == 4 {
        //
        //            if UserDefaults.standard.bool(forKey: "lock_customer") {
        //                ToastClass.sharedToast.showToast(message: "Access Denied",
        //                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        //            }
        //            else {
        //                performSegue(withIdentifier: "toCustomer", sender: nil)
        //            }
        //        }
        
        
//        else if indexPath.row == 4 {
//            
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                
//                if UserDefaults.standard.bool(forKey: "lock_setup") {
//                    ToastClass.sharedToast.showToast(message: "Access Denied",
//                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                }
//                else {
//                    isSetup = false
//                    performSegue(withIdentifier: "toSetup", sender: nil)
//                }
//            }
            
//            else {
//                
//                if UserDefaults.standard.bool(forKey: "lock_setup") {
//                    ToastClass.sharedToast.showToast(message: "Access Denied",
//                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                }
//                else {
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let root = storyBoard.instantiateViewController(withIdentifier: "setup") as! SetupViewController
//                    root.merchant_id = merchant_id
//                    
//                    let vc = UISplitViewController()
//                    vc.modalPresentationStyle = .fullScreen
//                    vc.view.backgroundColor = .systemBackground
//                    vc.viewControllers = [UINavigationController(rootViewController: root)]
//                    present(vc, animated: true)
//                }
//            }
//        }
        
        else {
            if UserDefaults.standard.bool(forKey: "lock_more") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                isSetup = true
                performSegue(withIdentifier: "toSetup", sender: nil)
            }
        }
        ApiCalls.sharedCall.cancelRequest()
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collection.bounds.size.width
        return CGSize(width: (width/2) - 5, height: (width/2) + 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
