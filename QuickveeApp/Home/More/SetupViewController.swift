//
//  SetupViewController.swift
//
//
//  Created by Jamaluddin Syed on 21/02/23.
//

import UIKit
import Alamofire
import AdSupport

class SetupViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var setupLbl: UILabel!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    var responseArray = [String:Any]()
    
    let stationList = //["Online Store Options","Store Options","Email & SMS Alert","Change Password", "Coupons","Taxes","Loyalty Program",
    ["Register Settings", "QuickAdd"]
    //"Mix n' Match Pricing","Inventory","Company Info",]
    
    let moreList = ["Mix n' Match Pricing", "Coupons", "Loyalty Program", "Gift Card", "BOGO"]
  
    
    var more = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var merchant_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
        
        logoutBtn.layer.cornerRadius = 10
        
        if more {
            logoutBtn.isHidden = true
        }
        else {
            logoutBtn.isHidden = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
//        tableview.isHidden = true
//        loadingIndicator.isAnimating = true
//        getApiCallData()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            //            setupLbl.text = "Setup"
            
            if more {
                setupLbl.text = "More"
            }
            else {
                setupLbl.text = "Station Settings"
            }
            setupLbl.textAlignment = .left
        }
        else {
            
            if more {
                setupLbl.text = "More"
            }
            else {
                setupLbl.text = "Station Settings"
            }
            setupLbl.textAlignment = .center
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
//    func getApiCallData() {
//        
//        let url = AppURLs.STORE_DETAILS
//        
//        let parameters: [String:Any] = [
//            "merchant_id": merchant_id!
//        ]
//        
//        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
//            switch response.result {
//                
//            case .success(_):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    guard let jsonDict = json["result"] else {
//                        self.loadingIndicator.isAnimating = false
//                        self.tableview.isHidden = false
//                        return
//                    }
//                    
//                    self.getResponseValues(responseValues: jsonDict)
//                    self.loadingIndicator.isAnimating = false
//                    self.tableview.isHidden = false
//                    break
//                }
//                catch {
//                    
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                
//            }
//        }
//    }
    
//    func getResponseValues(responseValues: Any) {
//        
//        let response = responseValues as! [String:Any]
//        responseArray = response
//        
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let subRoot = storyBoard.instantiateViewController(withIdentifier: "storeSetup") as! StoreSetupViewController
//            subRoot.setup = StoreSetup(merchant_id: merchant_id ?? "",
//                                       offline: "\(responseArray["offline"] ?? "")",
//                                       max_delivery_radius: "\(responseArray["max_delivery_radius"] ?? "")",
//                                       min_delivery_amt: "\(responseArray["min_delivery_amt"] ?? "")",
//                                       float_delivery: "\(responseArray["float_delivery"] ?? "")",
//                                       delivery_fee: "\(responseArray["delivery_fee"] ?? "")",
//                                       rate_per_miles: "\(responseArray["rate_per_miles"] ?? "")",
//                                       is_pickup: "\(responseArray["is_pickup"] ?? "")",
//                                       pickup_min_time: "\(responseArray["pickup_min_time"] ?? "")",
//                                       pickup_max_time: "\(responseArray["pickup_max_time"] ?? "")",
//                                       is_deliver: "\(responseArray["is_deliver"] ?? "")",
//                                       deliver_min_time: "\(responseArray["deliver_min_time"] ?? "")",
//                                       deliver_max_time: "\(responseArray["deliver_max_time"] ?? "")",
//                                       cfee_pik: "\(responseArray["cfee_pik"] ?? "")",
//                                       cfee_pik_price: "\(responseArray["cfee_pik_price"] ?? "")",
//                                       cfee_del: "\(responseArray["cfee_del"] ?? "")",
//                                       cfee_del_price: "\(responseArray["cfee_del_price"] ?? "")",
//                                       enable_tip: "\(responseArray["enable_tip"] ?? "")",
//                                       default_tip_p: "\(responseArray["default_tip_p"] ?? "")",
//                                       default_tip_d: "\(responseArray["default_tip_d"] ?? "")")
//            showDetailViewController(UINavigationController(rootViewController: subRoot), sender: nil)
//        }
//    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.popViewController(animated: true)
        }
        
        else {
            dismiss(animated: true)
        }
    }
    
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        
        showAlertLogout(title: "Alert", message: "Are you sure you want to Logout?")
        
    }
    
    func showAlertLogout(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("yes button tapped")
            
            self.tableview.isHidden = true
            self.loadingIndicator.isAnimating = true
            self.setupLogoutApi()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func setupLogoutApi() {
        
        let url = AppURLs.LOGOUT
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let parameters: [String:Any] = [
            "merchant_id": id,
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
    
    func getAdvId() -> String {
        let adv_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print(adv_id)
        return adv_id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStoreSetup" {
            let vc = segue.destination as! StoreSetupViewController
            vc.setup = StoreSetup(merchant_id: merchant_id ?? "",
                                  offline: "\(responseArray["offline"] ?? "")",
                                  max_delivery_radius: "\(responseArray["max_delivery_radius"] ?? "")",
                                  min_delivery_amt: "\(responseArray["min_delivery_amt"] ?? "")",
                                  float_delivery: "\(responseArray["float_delivery"] ?? "")",
                                  delivery_fee: "\(responseArray["delivery_fee"] ?? "")",
                                  rate_per_miles: "\(responseArray["rate_per_miles"] ?? "")",
                                  is_pickup: "\(responseArray["is_pickup"] ?? "")",
                                  pickup_min_time: "\(responseArray["pickup_min_time"] ?? "")",
                                  pickup_max_time: "\(responseArray["pickup_max_time"] ?? "")",
                                  is_deliver: "\(responseArray["is_deliver"] ?? "")",
                                  deliver_min_time: "\(responseArray["deliver_min_time"] ?? "")",
                                  deliver_max_time: "\(responseArray["deliver_max_time"] ?? "")",
                                  cfee_pik: "\(responseArray["cfee_pik"] ?? "")",
                                  cfee_pik_price: "\(responseArray["cfee_pik_price"] ?? "")",
                                  cfee_del: "\(responseArray["cfee_del"] ?? "")",
                                  cfee_del_price: "\(responseArray["cfee_del_price"] ?? "")",
                                  enable_tip: "\(responseArray["enable_tip"] ?? "")",
                                  default_tip_p: "\(responseArray["default_tip_p"] ?? "")",
                                  default_tip_d: "\(responseArray["default_tip_d"] ?? "")")
        }
        else if segue.identifier == "toStoreOptions" {
            
            let vc = segue.destination as! StoreOptionsViewController
            
            vc.setup = StoreOptions(merchant_id: merchant_id ?? "",
                                    id: "\(responseArray["id"] ?? "")",
                                    enable_order_number: "\(responseArray["enable_order_number"] ?? "")",
                                    reset_order_time: "\(responseArray["reset_order_time"] ?? "")",
                                    auto_print_kitchen: "\(responseArray["auto_print_kitchen"] ?? "")",
                                    auto_print_payment: "\(responseArray["auto_print_payment"] ?? "")",
                                    future_ordering: "\(responseArray["future_ordering"] ?? "")",
                                    advance_count: "\(responseArray["advance_count"] ?? "")",
                                    enable_void_order: "\(responseArray["enable_void_order"] ?? "")")
            
        }
        else if segue.identifier == "toEmail&Sms" {
            let vc = segue.destination as! SetupEmailSmsViewController
            
            vc.setup = SetupEmailSms(merchant_id: merchant_id ?? "",
                                     enable_email: "\(responseArray["enable_email"] ?? "")",
                                     enable_message: "\(responseArray["enable_message"] ?? "")",
                                     bcc_email: "\(responseArray["bcc_email"] ?? "")",
                                     msg_no: "\(responseArray["msg_no"] ?? "")",
                                     enable_order_status_email: "\(responseArray["enable_order_status_email"] ?? "")",
                                     enable_order_status_msg: "\(responseArray["enable_order_status_msg"] ?? "")")
        }
        
        else if segue.identifier == "tochange" {
            let vc = segue.destination as! ChangePasswordViewController
            
            vc.merchant_id = merchant_id ?? ""
            vc.merch_pass = "\(responseArray["password"] ?? "")"
            
        }
        
        else if segue.identifier == "toCoupons" {
            let vc = segue.destination as! CouponViewController
            vc.merchant_id = merchant_id  ?? ""
        }
        
        else if segue.identifier == "toSetupVendor" {
            let vc = segue.destination as! SetupVendorViewController
            vc.merchant_id = merchant_id ?? ""
        }
        
        else if segue.identifier == "toSetupTax" {
            let vc = segue.destination as! SetupTaxViewController
            vc.merchant_id = merchant_id ?? ""
        }
        
        else if segue.identifier == "toRegisterSettings" {
            _ = segue.destination as! RegisterSettingsViewController
        }
        //        else if segue.identifier == "toSystemAccess" {
        //                    _ = segue.destination as! SystemAccessViewController
        //        }
        else if segue.identifier == "toLoyalty" {
            _ = segue.destination as! SetupLoyaltyViewController
        }
        else if segue.identifier == "toMIxnMatch" {
            
            _ = segue.destination as! MixnMatchPricingViewController
        }
        
        else if segue.identifier == "toInventorySetup" {
            _ = segue.destination as! SetupInventoryViewController
        }
        
        else if segue.identifier == "toQuick" {
            _ = segue.destination as! QuickAddSetupViewController
        }
        
        else if segue.identifier == "toGiftCard" {
            _ = segue.destination as! GiftCardViewController
        }
        else if segue.identifier == "toBogo" {
            _ = segue.destination as! BogoListViewController
        }
        
        else  {
            let vc = segue.destination as! SetupProfileViewController
            vc.setup = SetupProfile(merchant_id: merchant_id ?? "",
                                    name: "\(responseArray["name"] ?? "")",
                                    a_address_line_1: "\(responseArray["a_address_line_1"] ?? "")",
                                    a_address_line_2: "\(responseArray["a_address_line_2"] ?? "")",
                                    a_address_line_3: "\(responseArray["a_address_line_3"] ?? "")",
                                    email: "\(responseArray["email"] ?? "")",
                                    a_phone: "\(responseArray["a_phone"] ?? "")",
                                    a_city: "\(responseArray["a_city"] ?? "")",
                                    banner_img: "\(responseArray["banner_img"] ?? "")",
                                    img: "\(responseArray["img"] ?? "")",
                                    a_state: "\(responseArray["a_state"] ?? "")",
                                    a_zip: "\(responseArray["a_zip"] ?? "")")
        }
    }
}

extension SetupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        return stationList.count
        if more {
            return moreList.count
        }
        else {
            return stationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetupTableViewCell
        
        //        let station = stationList[indexPath.row]
        //        cell.cellLabel.text = station
        
        //        if station == "Inventory" {
        //            cell.cellIcon.setImage(UIImage(named: "Inventory_Setup"), for: .normal)
        //        }
        //        else {
        //            cell.cellIcon.setImage(UIImage(named: station), for: .normal)
        //        }
        
        
        if more {
            
            let station = moreList[indexPath.row]
            cell.cellLabel.text = station
            cell.cellIcon.setImage(UIImage(named: station), for: .normal)
        }
        else {
            
            let more = stationList[indexPath.row]
            cell.cellLabel.text = more
            cell.cellIcon.setImage(UIImage(named: more), for: .normal)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            if more {
                
                if indexPath.row == 0 {
                    
                    if UserDefaults.standard.bool(forKey: "lock_mix_match") {
                        ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        UserDefaults.standard.set(0, forKey: "modal_screen")
                        performSegue(withIdentifier: "toMIxnMatch", sender: nil)
                    }
                }
                
                else if indexPath.row == 1 {
                    
                    if UserDefaults.standard.bool(forKey: "lock_access_coupon") {
                        ToastClass.sharedToast.showToast(message: "Access Denied",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        performSegue(withIdentifier: "toCoupons", sender: nil)
                    }
                }
                
                else if indexPath.row == 2 {
                    
                    if UserDefaults.standard.bool(forKey: "lock_loyalty_program") {
                        ToastClass.sharedToast.showToast(message: "Access Denied",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        performSegue(withIdentifier: "toLoyalty", sender: nil)
                    }
                }
                
                else if indexPath.row == 3 {
                    if UserDefaults.standard.bool(forKey: "lock_gift") {
                        ToastClass.sharedToast.showToast(message: "Access Denied",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        performSegue(withIdentifier: "toGiftCard", sender: nil)
                    }
                }
                
                else {
                    if UserDefaults.standard.bool(forKey: "lock_bogo") {
                        ToastClass.sharedToast.showToast(message: "Access Denied",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        performSegue(withIdentifier: "toBogo", sender: nil)
                    }
                }
            }
            
            else {
                
                if indexPath.row == 0 {
                    
                    if UserDefaults.standard.bool(forKey: "lock_reg_set") {
                        ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        performSegue(withIdentifier: "toRegisterSettings", sender: nil)
                    }
                }
                else {
                    if UserDefaults.standard.bool(forKey: "lock_quick_add") {
                        ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                    performSegue(withIdentifier: "toQuick", sender: nil)
                    }
                }
            }
            //            if indexPath.row == 0 {
            //
            //                if UserDefaults.standard.bool(forKey: "lock_store_setup") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toStoreSetup", sender: nil)
            //                }
            //            }
            //            else if indexPath.row == 1 {
            //                if UserDefaults.standard.bool(forKey: "lock_store_options") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toStoreOptions", sender: nil)
            //                }
            //            }
            //            else if indexPath.row == 2 {
            //                if UserDefaults.standard.bool(forKey: "lock_email") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toEmail&Sms", sender: nil)
            //                }
            //            }
            //            else if indexPath.row == 3 {
            //
            //                   performSegue(withIdentifier: "tochange", sender: nil)
            //
            //            }
            //            else if indexPath.row == 4 {
            //                if UserDefaults.standard.bool(forKey: "lock_coupons") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toCoupons", sender: nil)
            //                }
            //            }
            //            //            else if indexPath.row == 5 {
            //            //                performSegue(withIdentifier: "toSetupVendor", sender: nil)
            //            //            }
            //            else if indexPath.row == 5 {
            //                if UserDefaults.standard.bool(forKey: "lock_taxes") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toSetupTax", sender: nil)
            //                }
            //            }
            //            else if indexPath.row == 6 {
            //                if UserDefaults.standard.bool(forKey: "lock_loyalty_points") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toLoyalty", sender: nil)
            //                }
            //            }
            //            else if indexPath.row == 7 {
            //                if UserDefaults.standard.bool(forKey: "lock_register_settings") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toRegisterSettings", sender: nil)
            //                }
            //            }
            //            //            else if indexPath.row == 8 {
            //            //        performSegue(withIdentifier: "tochange", sender: nil)
            //            //            }
            //            else if indexPath.row == 8 {
            //                    UserDefaults.standard.set(0, forKey: "modal_screen")
            //                    performSegue(withIdentifier: "toMIxnMatch", sender: nil)
            //            }
            //            else if indexPath.row == 9 {
            //                if UserDefaults.standard.bool(forKey: "lock_inventory") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //
            //                    performSegue(withIdentifier: "toInventorySetup", sender: nil)
            //                }
            //            }
            //            else {
            //                if UserDefaults.standard.bool(forKey: "lock_company_info") {
            //                    ToastClass.sharedToast.showToast(message: "Access Denied",
            //                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            //                }
            //                else {
            //                    performSegue(withIdentifier: "toProfile", sender: nil)
            //                }
            //            }
        }
        
        else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            if indexPath.row == 0 {
                let root = storyBoard.instantiateViewController(withIdentifier: "storeSetup") as! StoreSetupViewController
                root.setup = StoreSetup(merchant_id: merchant_id ?? "",
                                        offline: "\(responseArray["offline"] ?? "")",
                                        max_delivery_radius: "\(responseArray["max_delivery_radius"] ?? "")",
                                        min_delivery_amt: "\(responseArray["min_delivery_amt"] ?? "")",
                                        float_delivery: "\(responseArray["float_delivery"] ?? "")",
                                        delivery_fee: "\(responseArray["delivery_fee"] ?? "")",
                                        rate_per_miles: "\(responseArray["rate_per_miles"] ?? "")",
                                        is_pickup: "\(responseArray["is_pickup"] ?? "")",
                                        pickup_min_time: "\(responseArray["pickup_min_time"] ?? "")",
                                        pickup_max_time: "\(responseArray["pickup_max_time"] ?? "")",
                                        is_deliver: "\(responseArray["is_deliver"] ?? "")",
                                        deliver_min_time: "\(responseArray["deliver_min_time"] ?? "")",
                                        deliver_max_time: "\(responseArray["deliver_max_time"] ?? "")",
                                        cfee_pik: "\(responseArray["cfee_pik"] ?? "")",
                                        cfee_pik_price: "\(responseArray["cfee_pik_price"] ?? "")",
                                        cfee_del: "\(responseArray["cfee_del"] ?? "")",
                                        cfee_del_price: "\(responseArray["cfee_del_price"] ?? "")",
                                        enable_tip: "\(responseArray["enable_tip"] ?? "")",
                                        default_tip_p: "\(responseArray["default_tip_p"] ?? "")",
                                        default_tip_d: "\(responseArray["default_tip_d"] ?? "")")
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
            else if indexPath.row == 1 {
                
                let root = storyBoard.instantiateViewController(withIdentifier: "storeOptions") as! StoreOptionsViewController
                root.setup = StoreOptions(merchant_id: merchant_id ?? "",
                                          id: "\(responseArray["id"] ?? "")",
                                          enable_order_number: "\(responseArray["enable_order_number"] ?? "")",
                                          reset_order_time: "\(responseArray["reset_order_time"] ?? "")",
                                          auto_print_kitchen: "\(responseArray["auto_print_kitchen"] ?? "")",
                                          auto_print_payment: "\(responseArray["auto_print_payment"] ?? "")",
                                          future_ordering: "\(responseArray["future_ordering"] ?? "")",
                                          advance_count: "\(responseArray["advance_count"] ?? "")",
                                          enable_void_order: "\(responseArray["enable_void_order"] ?? "")")
                
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
            else if indexPath.row == 2 {
                let root = storyBoard.instantiateViewController(withIdentifier: "storeAlerts") as! SetupEmailSmsViewController
                
                root.setup = SetupEmailSms(merchant_id: merchant_id ?? "",
                                           enable_email: "\(responseArray["enable_email"] ?? "")",
                                           enable_message: "\(responseArray["enable_message"] ?? "")",
                                           bcc_email: "\(responseArray["bcc_email"] ?? "")",
                                           msg_no: "\(responseArray["msg_no"] ?? "")",
                                           enable_order_status_email: "\(responseArray["enable_order_status_email"] ?? "")",
                                           enable_order_status_msg: "\(responseArray["enable_order_status_msg"] ?? "")")
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
                
            }
            else if indexPath.row == 3 {
                let root = storyBoard.instantiateViewController(withIdentifier: "storeChange") as! ChangePasswordViewController
                
                root.merchant_id = merchant_id ?? ""
                root.merch_pass = "\(responseArray["password"] ?? "")"
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
                
            }
            else if indexPath.row == 4 {
                
                let root = storyBoard.instantiateViewController(withIdentifier: "storeCoupon") as! CouponViewController
                root.merchant_id = merchant_id  ?? ""
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
            else if indexPath.row == 5 {
                
                let root = storyBoard.instantiateViewController(withIdentifier: "storeVendor") as! SetupVendorViewController
                root.merchant_id = merchant_id  ?? ""
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
            else if indexPath.row == 6 {
                let root = storyBoard.instantiateViewController(withIdentifier: "storeTax") as! SetupTaxViewController
                root.merchant_id = merchant_id  ?? ""
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
            else {
                let root = storyBoard.instantiateViewController(withIdentifier: "storeProfile") as! SetupProfileViewController
                root.setup = SetupProfile(merchant_id: merchant_id ?? "",
                                          name: "\(responseArray["name"] ?? "")",
                                          a_address_line_1: "\(responseArray["a_address_line_1"] ?? "")",
                                          a_address_line_2: "\(responseArray["a_address_line_2"] ?? "")",
                                          a_address_line_3: "\(responseArray["a_address_line_3"] ?? "")",
                                          email: "\(responseArray["email"] ?? "")",
                                          a_phone: "\(responseArray["a_phone"] ?? "")",
                                          a_city: "\(responseArray["a_city"] ?? "")",
                                          banner_img: "\(responseArray["banner_img"] ?? "")",
                                          img: "\(responseArray["img"] ?? "")",
                                          a_state: "\(responseArray["a_state"] ?? "")",
                                          a_zip: "\(responseArray["a_zip"] ?? "")")
                showDetailViewController(UINavigationController(rootViewController: root), sender: nil)
            }
        }
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
}

extension UIView {
    func addBottomShadow() {
        
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06).cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize,
                    radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func isErrorView(numberOfShakes shakes: Float, revert: Bool) {
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
        
    }
}
