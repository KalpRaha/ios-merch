//
//  PassCodeViewController.swift
//
//
//  Created by Jamaluddin Syed on 10/9/23.
//

import UIKit
import Alamofire
import AdSupport
import WebKit

class PassCodeViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var stackFourth: UIStackView!
    @IBOutlet weak var stackThird: UIStackView!
    @IBOutlet weak var stackSecond: UIStackView!
    @IBOutlet weak var stackfirst: UIStackView!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtm: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    
    @IBOutlet weak var passview: UIView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    var whiteIndex = 0
    var pinCode = ""
    var coll_height = CGFloat()
    var setHeight = 0
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let numberarray = ["1", "2", "3"]
    let numberarray1 = ["4", "5", "6"]
    let numberarray2 = ["7", "8", "9"]
    let numberarray3 = ["", "0", ""]
    
    var webview = WKWebView()
    var page = URL(string: "https://quickvee.com/merchants/login")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "LoggedIn")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        hideAppear()
    }
    
    
    func hideAppear() {
     
        circularBorder(button: oneBtn)
        circularBorder(button: twoBtn)
        circularBorder(button: threeBtn)
        circularBorder(button: fourBtm)
        circularBorder(button: fiveBtn)
        circularBorder(button: sixBtn)
        circularBorder(button: sevenBtn)
        circularBorder(button: eightBtn)
        circularBorder(button: nineBtn)
        circularBorder(button: zeroBtn)
        
        firstBtn.layer.cornerRadius = 8
        secondBtn.layer.cornerRadius = 8
        thirdBtn.layer.cornerRadius = 8
        fourthBtn.layer.cornerRadius = 8
        
        UserDefaults.standard.set(false, forKey: "home_return")
        
        setupUI()
        
        webview.navigationDelegate = self
        
        if #available(iOS 14.0, *) {
            webview.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            
        }
        
        webview.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        webview.load(URLRequest(url: page!))
        
        loadingIndicator.isAnimating = true
        passview.isHidden = true
        stackfirst.isHidden = true
        stackSecond.isHidden = true
        stackThird.isHidden = true
        stackFourth.isHidden = true
        logoutBtn.isHidden = true
        
        firstBtn.alpha = 0.4
        secondBtn.alpha = 0.4
        thirdBtn.alpha = 0.4
        fourthBtn.alpha = 0.4
        
        whiteIndex = 0
        pinCode = ""
                
    }
    
    func showAppear() {
        
        loadingIndicator.isAnimating = false
        passview.isHidden = false
        stackfirst.isHidden = false
        stackSecond.isHidden = false
        stackThird.isHidden = false
        stackFourth.isHidden = false
        logoutBtn.isHidden = false
        
        loadingIndicator.removeFromSuperview()
    }
   
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        
        setupUI()
        
        loadingIndicator.isAnimating = true
        passview.isHidden = true
        stackfirst.isHidden = true
        stackSecond.isHidden = true
        stackThird.isHidden = true
        stackFourth.isHidden = true
        logoutBtn.isHidden = true
        setupLogoutApi()
    }
    
    @IBAction func codesClicked(_ sender: UIButton) {
        
        if sender.tag == 11 {
            
            if whiteIndex >= 4 {
                
                fourthBtn.alpha = 0.4
                whiteIndex -= 1
                pinCode = String(pinCode.dropLast())
                
            }
            
            else if whiteIndex == 3 {
                thirdBtn.alpha = 0.4
                whiteIndex -= 1
                pinCode = String(pinCode.dropLast())
                
            }
            
            else if whiteIndex == 2 {
                secondBtn.alpha = 0.4
                whiteIndex -= 1
                pinCode = String(pinCode.dropLast())
                
            }
            
            else if whiteIndex == 1 {
                firstBtn.alpha = 0.4
                whiteIndex -= 1
                pinCode = String(pinCode.dropLast())
                
            }
        }
        
        else {
            
            if whiteIndex == 0 {
                firstBtn.alpha = 1
                whiteIndex += 1
                pinCode.append(sender.currentTitle ?? "")
            }
            
            else if whiteIndex == 1 {
                secondBtn.alpha = 1
                whiteIndex += 1
                pinCode.append(sender.currentTitle ?? "")
            }
            
            else if whiteIndex == 2 {
                thirdBtn.alpha = 1
                whiteIndex += 1
                pinCode.append(sender.currentTitle ?? "")
            }
            
            else if whiteIndex == 3 {
                fourthBtn.alpha = 1
                whiteIndex += 1
                pinCode.append(sender.currentTitle ?? "")
                
                setupUI()
                
                passview.isHidden = true
                stackfirst.isHidden = true
                stackSecond.isHidden = true
                stackThird.isHidden = true
                stackFourth.isHidden = true
                logoutBtn.isHidden = true
                loadingIndicator.isAnimating = true
                
                print(pinCode)
                setupPassApi(pin: pinCode)
            }
        }
    }
    
    func setupPassApi(pin: String) {
        
        let merchant = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.passCodeCall(merchant_id: merchant) { isSuccess, responseData in
            
            if isSuccess {
                
                if let variant = responseData["status"], variant as! Int != 0  {
                    
                    self.getEmpId(variant: responseData["result"])
                }
                
                else {
                    self.invalid()
                }
            }
        }
    }
    
    func invalid() {
        
        self.passview.isHidden = false
        self.stackfirst.isHidden = false
        self.stackSecond.isHidden = false
        self.stackThird.isHidden = false
        self.stackFourth.isHidden = false
        self.logoutBtn.isHidden = false
        self.loadingIndicator.isAnimating = false
        
        self.loadingIndicator.removeFromSuperview()
        
        self.passview.shake(numberOfShakes: 3, revert: true)
        ToastClass.sharedToast.showToast(message: "Invalid Passcode",
                                         font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        self.whiteIndex = 0
        self.pinCode = ""
        self.firstBtn.alpha = 0.4
        self.secondBtn.alpha = 0.4
        self.thirdBtn.alpha = 0.4
        self.fourthBtn.alpha = 0.4
        print("Api Error")
    }
    
    
    
    func getEmpId(variant: Any) {
        
        let variant_emp = variant as! [[String: Any]]
        var per_array = [String]()
        
        var match_found = false
        
        for vari in variant_emp {
            
            let pin = vari["pin"] as? String ?? ""
            
            if pin == pinCode {
                
                match_found = true
                
                let emp = PassEmp(id: "\(vari["id"] ?? "")", f_name: "\(vari["f_name"] ?? "")",
                                  l_name: "\(vari["l_name"] ?? "")", phone: "\(vari["phone"] ?? "")",
                                  email: "\(vari["email"] ?? "")", pin: "\(vari["pin"] ?? "")",
                                  wages_per_hr: "\(vari["wages_per_hr"] ?? "")", role: "\(vari["role"] ?? "")",
                                  merchant_id: "\(vari["merchant_id"] ?? "")", admin_id: "\(vari["admin_id"] ?? "")",
                                  address: "\(vari["address"] ?? "")", city: "\(vari["city"] ?? "")",
                                  state: "\(vari["state"] ?? "")", zipcode: "\(vari["zipcode"] ?? "")",
                                  is_employee: "\(vari["is_employee"] ?? "")", permissions: "\(vari["permissions"] ?? "")",
                                  break_time: "\(vari["break_time"] ?? "")", break_allowed: "\(vari["break_allowed"] ?? "")",
                                  is_login: "\(vari["is_login"] ?? "")", login_time: "\(vari["login_time"] ?? "")",
                                  status: "\(vari["status"] ?? "")", created_from: "\(vari["created_from"] ?? "")",
                                  created_at: "\(vari["created_at"] ?? "")", updated_from: "\(vari["updated_from"] ?? "")",
                                  updated_at: "\(vari["updated_at"] ?? "")", menu_list: "\(vari["menu_list"] ?? "")",
                                  enable_backend_access: "\(vari["enable_backend_access"] ?? "")",
                                  enable_pos_access: "\(vari["enable_pos_access"] ?? "")",
                                  password: "\(vari["password"] ?? "")", read_pass: "\(vari["read_pass"] ?? "")",
                                  assigned_store: "\(vari["assigned_store"] ?? "")", is_admin: "\(vari["is_admin"] ?? "")")
                
                let permission = emp.permissions
                per_array = permission.components(separatedBy: ",")
                                
                let emp_id = emp.id
                let emp_name = emp.f_name
                
                let email = emp.email
                let read = emp.read_pass
                let enable_backend = emp.enable_backend_access
                let assigned_store = emp.assigned_store
                
                UserDefaults.standard.set(emp_id, forKey: "emp_po_id")
                UserDefaults.standard.set(emp_name, forKey: "merchant_name")
                
                UserDefaults.standard.set(email, forKey: "email_webview")
                UserDefaults.standard.set(read, forKey: "read_pass_webview")
                UserDefaults.standard.set(enable_backend, forKey: "backend_access_webview")
                UserDefaults.standard.set(assigned_store, forKey: "assigned_store")
                
                break
            }
        }
        
        if match_found {
            
            let stores = UserDefaults.standard.string(forKey: "assigned_store") ?? ""
            let merch = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            if stores.contains(merch) {
                codePermission(per_array: per_array)
                UserDefaults.standard.set(pinCode, forKey: "emp_passcode")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loadingIndicator.isAnimating = false
                    self.loadingIndicator.removeFromSuperview()
                    self.performSegue(withIdentifier: "passcodetoHome", sender: nil)
                }
            }
        }
        else {
            invalid()
        }
        
//        //store stats
//
//        if per_array.contains("SR") {
//            UserDefaults.standard.set(false, forKey: "lock_store_reports")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_store_reports")
//        }
//
//        if per_array.contains("AR") {
//            UserDefaults.standard.set(false, forKey: "lock_all_shift_report")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_all_shift_report")
//        }
//
//        if per_array.contains("OR") {
//            UserDefaults.standard.set(false, forKey: "lock_own_shift_report")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_own_shift_report")
//        }
//
//        if per_array.contains("VR") {
//            UserDefaults.standard.set(false, forKey: "lock_view_credit_report")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_view_credit_report")
//        }
//
//        //home
//
//        if per_array.contains("SC") {
//            UserDefaults.standard.set(false, forKey: "lock_setup_screen")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_setup_screen")
//        }
//
//        if per_array.contains("AI") {
//            UserDefaults.standard.set(false, forKey: "lock_inventory_screen")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_inventory_screen")
//        }
//
//        if per_array.contains("GC") {
//            UserDefaults.standard.set(false, forKey: "lock_gift_screen")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_gift_screen")
//        }
//
//        //users
//
//        if per_array.contains("MO") {
//            UserDefaults.standard.set(false, forKey: "lock_manage_user")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_manage_user")
//        }
//        if per_array.contains("AE") {
//            UserDefaults.standard.set(false, forKey: "lock_add_user")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_add_user")
//        }
//        if per_array.contains("EE") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_user")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_user")
//        }
//        if per_array.contains("DE") {
//            UserDefaults.standard.set(false, forKey: "lock_delete_user")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_delete_user")
//        }
//
//        //setup
//        if per_array.contains("OP") {
//            UserDefaults.standard.set(false, forKey: "lock_store_options")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_store_options")
//        }
//
//        if per_array.contains("SP") {
//            UserDefaults.standard.set(false, forKey: "lock_store_setup")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_store_setup")
//        }
//
//        if per_array.contains("QA") {
//            UserDefaults.standard.set(false, forKey: "lock_quickadd")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_quickadd")
//        }
//
//        if per_array.contains("ALP") {
//            UserDefaults.standard.set(false, forKey: "lock_loyalty_points")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_loyalty_points")
//        }
//
//        if per_array.contains("C") {
//            UserDefaults.standard.set(false, forKey: "lock_coupons")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_coupons")
//        }
//
//        if per_array.contains("T") {
//            UserDefaults.standard.set(false, forKey: "lock_taxes")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_taxes")
//        }
//
//        if per_array.contains("AL") {
//            UserDefaults.standard.set(false, forKey: "lock_email")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_email")
//        }
//
//        if per_array.contains("SY") {
//            UserDefaults.standard.set(false, forKey: "lock_system_access")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_system_access")
//        }
//
//        if per_array.contains("HA") {
//            UserDefaults.standard.set(false, forKey: "lock_hardware")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_hardware")
//        }
//
//        if per_array.contains("PS") {
//            UserDefaults.standard.set(false, forKey: "lock_register_settings")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_register_settings")
//        }
//
//        if per_array.contains("IS") {
//            UserDefaults.standard.set(false, forKey: "lock_inventory")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_inventory")
//        }
//
//        if per_array.contains("PT") {
//            UserDefaults.standard.set(false, forKey: "lock_receipt_template")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_receipt_template")
//        }
//
//        if per_array.contains("ST") {
//            UserDefaults.standard.set(false, forKey: "lock_company_info")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_company_info")
//        }
//
//        // coupons
//
//        if per_array.contains("RO") {
//            UserDefaults.standard.set(false, forKey: "lock_delete_coupon")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_delete_coupon")
//        }
//
//        if per_array.contains("UO") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_coupon")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_coupon")
//        }
//
//        if per_array.contains("AO") {
//            UserDefaults.standard.set(false, forKey: "lock_add_coupon")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_add_coupon")
//        }
//
//        // customers
//
//        if per_array.contains("DP") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_remove_points")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_remove_points")
//        }
//
//        if per_array.contains("AB") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_add_points")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_add_points")
//        }
//
//        if per_array.contains("RU") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_delete")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_delete")
//        }
//
//        if per_array.contains("PU") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_disable")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_disable")
//        }
//
//        if per_array.contains("UU") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_edit")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_edit")
//        }
//
//        if per_array.contains("AU") {
//            UserDefaults.standard.set(false, forKey: "lock_customer_add")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_customer_add")
//        }
//
//        //gift card
//
//        if per_array.contains("GB") {
//            UserDefaults.standard.set(false, forKey: "lock_gift_add")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_gift_add")
//        }
//
//        if per_array.contains("RB") {
//            UserDefaults.standard.set(false, forKey: "lock_gift_remove")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_gift_remove")
//        }
//
//        //inventory
//
//        if per_array.contains("ED") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_items")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_items")
//        }
//
//        if per_array.contains("AD") {
//            UserDefaults.standard.set(false, forKey: "lock_add_items")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_add_items")
//        }
//
//        if per_array.contains("DS") {
//            UserDefaults.standard.set(false, forKey: "lock_disable_item")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_disable_item")
//        }
//
//        if per_array.contains("RI") {
//            UserDefaults.standard.set(false, forKey: "lock_delete_items")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_delete_items")
//        }
//
//        if per_array.contains("UC") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_category")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_category")
//        }
//
//        if per_array.contains("CC") {
//            UserDefaults.standard.set(false, forKey: "lock_add_category")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_add_category")
//        }
//
//        if per_array.contains("PC") {
//            UserDefaults.standard.set(false, forKey: "lock_disable_category")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_disable_category")
//        }
//
//        if per_array.contains("RC") {
//            UserDefaults.standard.set(false, forKey: "lock_delete_category")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_delete_category")
//        }
//
//        if per_array.contains("CV") {
//            UserDefaults.standard.set(false, forKey: "lock_add_vendor")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_add_vendor")
//        }
//
//        if per_array.contains("UV") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_vendor")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_vendor")
//        }
//
//        if per_array.contains("PV") {
//            UserDefaults.standard.set(false, forKey: "lock_disable_vendor")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_disable_vendor")
//        }
//
//        if per_array.contains("EO") {
//            UserDefaults.standard.set(false, forKey: "lock_create_po")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_create_po")
//        }
//
//        if per_array.contains("VI") {
//            UserDefaults.standard.set(false, forKey: "lock_view_po")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_view_po")
//        }
//
//        if per_array.contains("EP") {
//            UserDefaults.standard.set(false, forKey: "lock_edit_po")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_edit_po")
//        }
//
//        if per_array.contains("RP") {
//            UserDefaults.standard.set(false, forKey: "lock_receive_po")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_receive_po")
//        }
//
//        if per_array.contains("VP") {
//            UserDefaults.standard.set(false, forKey: "lock_void_po")
//        }
//        else {
//            UserDefaults.standard.set(true, forKey: "lock_void_po")
//        }
        
    }
    
    func codePermission(per_array: [String]) {
        
        //homescreen
        if per_array.contains("O") {
            UserDefaults.standard.set(false, forKey: "lock_orders")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_orders")
        }
        
        if per_array.contains("GC") {
            UserDefaults.standard.set(false, forKey: "lock_gift")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_gift")
        }
        
        if per_array.contains("SS") {
            UserDefaults.standard.set(false, forKey: "lock_setup")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_setup")
        }
        
        if per_array.contains("D") {
            UserDefaults.standard.set(false, forKey: "lock_dashboard")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_dashboard")
        }
        
        if per_array.contains("CU") {
            UserDefaults.standard.set(false, forKey: "lock_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_customer")
        }
        
        if per_array.contains("MR") {
            UserDefaults.standard.set(false, forKey: "lock_more")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_more")
        }
        
        if per_array.contains("PR") {
            UserDefaults.standard.set(false, forKey: "lock_print_register")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_print_register")
        }
        
        //inventory category
        if per_array.contains("CC") {
            UserDefaults.standard.set(false, forKey: "lock_add_category")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_category")
        }
        
        if per_array.contains("PC") {
            UserDefaults.standard.set(false, forKey: "lock_disable_category")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_disable_category")
        }
        
        if per_array.contains("RC") {
            UserDefaults.standard.set(false, forKey: "lock_delete_category")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_category")
        }
        
        if per_array.contains("UC") {
            UserDefaults.standard.set(false, forKey: "lock_edit_category")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_category")
        }
        
        //inventory items
        
        if per_array.contains("ED") {
            UserDefaults.standard.set(false, forKey: "lock_edit_product")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_product")
        }
        
        if per_array.contains("AD") {
            UserDefaults.standard.set(false, forKey: "lock_add_product")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_product")
        }
        
        if per_array.contains("DS") {
            UserDefaults.standard.set(false, forKey: "lock_disable_product")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_disable_product")
        }
        
        if per_array.contains("RI") {
            UserDefaults.standard.set(false, forKey: "lock_delete_product")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_product")
        }
        
        //inventory access and manage
        
        if per_array.contains("AI") {
            UserDefaults.standard.set(false, forKey: "lock_access_inventory")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_inventory")
        }
        
        if per_array.contains("MC") {
            UserDefaults.standard.set(false, forKey: "lock_manage_categories")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_categories")
        }
        
        if per_array.contains("MP") {
            UserDefaults.standard.set(false, forKey: "lock_manage_products")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_products")
        }
        
        if per_array.contains("MA") {
            UserDefaults.standard.set(false, forKey: "lock_manage_attributes")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_attributes")
        }
        
        if per_array.contains("MB") {
            UserDefaults.standard.set(false, forKey: "lock_manage_brands")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_brands")
        }
        
        if per_array.contains("MT") {
            UserDefaults.standard.set(false, forKey: "lock_manage_tags")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_tags")
        }
        
        if per_array.contains("L") {
            UserDefaults.standard.set(false, forKey: "lock_manage_lottery")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_lottery")
        }
        
        if per_array.contains("LA") {
            UserDefaults.standard.set(false, forKey: "lock_add_lottery")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_lottery")
        }
        
        if per_array.contains("LE") {
            UserDefaults.standard.set(false, forKey: "lock_edit_lottery")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_lottery")
        }
        
        if per_array.contains("LD") {
            UserDefaults.standard.set(false, forKey: "lock_delete_lottery")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_lottery")
        }
        
        //stocktake
        
        if per_array.contains("AK") {
            UserDefaults.standard.set(false, forKey: "lock_access_stocktake")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_stocktake")
        }
        
        if per_array.contains("CK") {
            UserDefaults.standard.set(false, forKey: "lock_add_stocktake")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_stocktake")
        }
        
        if per_array.contains("VK") {
            UserDefaults.standard.set(false, forKey: "lock_view_stocktake")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_view_stocktake")
        }
        
        if per_array.contains("EK") {
            UserDefaults.standard.set(false, forKey: "lock_edit_stocktake")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_stocktake")
        }
        
        if per_array.contains("OK") {
            UserDefaults.standard.set(false, forKey: "lock_void_stocktake")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_void_stocktake")
        }
        
        // gift card
        if per_array.contains("GB") {
            UserDefaults.standard.set(false, forKey: "lock_add_gift")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_gift")
        }
        
        if per_array.contains("RB") {
            UserDefaults.standard.set(false, forKey: "lock_remove_gift")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_remove_gift")
        }
        
        //more
        if per_array.contains("PS") {
            UserDefaults.standard.set(false, forKey: "lock_reg_set")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_reg_set")
        }
        
        if per_array.contains("QA") {
            UserDefaults.standard.set(false, forKey: "lock_quick_add")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_quick_add")
        }
        
        if per_array.contains("AMM") {
            UserDefaults.standard.set(false, forKey: "lock_mix_match")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_mix_match")
        }
        
        if per_array.contains("AM") {
            UserDefaults.standard.set(false, forKey: "add_mix_match")
        }
        else {
            UserDefaults.standard.set(true, forKey: "add_mix_match")
        }
        
        if per_array.contains("EM") {
            UserDefaults.standard.set(false, forKey: "edit_mix_match")
        }
        else {
            UserDefaults.standard.set(true, forKey: "edit_mix_match")
        }
        
        if per_array.contains("DM") {
            UserDefaults.standard.set(false, forKey: "delete_mix_match")
        }
        else {
            UserDefaults.standard.set(true, forKey: "delete_mix_match")
        }
        
        // store settings
        
        if per_array.contains("AS") {
            UserDefaults.standard.set(false, forKey: "lock_store_access")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_store_access")
        }
        
        if per_array.contains("ST") {
            UserDefaults.standard.set(false, forKey: "lock_store_info")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_store_info")
        }
        
        if per_array.contains("SE") {
            UserDefaults.standard.set(false, forKey: "lock_report_time")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_report_time")
        }
        
        if per_array.contains("SY") {
            UserDefaults.standard.set(false, forKey: "lock_system_access")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_system_access")
        }
        
        if per_array.contains("AL") {
            UserDefaults.standard.set(false, forKey: "lock_alert")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_alert")
        }
        
        if per_array.contains("OP") {
            UserDefaults.standard.set(false, forKey: "lock_store_options")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_store_options")
        }
        
        //LP
        
        if per_array.contains("ALP") {
            UserDefaults.standard.set(false, forKey: "lock_loyalty_program")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_loyalty_program")
        }
        
        if per_array.contains("EL") {
            UserDefaults.standard.set(false, forKey: "edit_loyalty_program")
        }
        else {
            UserDefaults.standard.set(true, forKey: "edit_loyalty_program")
        }
        
        if per_array.contains("AB") {
            UserDefaults.standard.set(false, forKey: "add_bonus_points")
        }
        else {
            UserDefaults.standard.set(true, forKey: "add_bonus_points")
        }
        
        if per_array.contains("EB") {
            UserDefaults.standard.set(false, forKey: "edit_bonus_points")
        }
        else {
            UserDefaults.standard.set(true, forKey: "edit_bonus_points")
        }
        
        if per_array.contains("DB") {
            UserDefaults.standard.set(false, forKey: "delete_bonus_points")
        }
        else {
            UserDefaults.standard.set(true, forKey: "delete_bonus_points")
        }
        
        if per_array.contains("SC") {
            UserDefaults.standard.set(false, forKey: "lock_store_setup")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_store_setup")
        }
        
        if per_array.contains("IS") {
            UserDefaults.standard.set(false, forKey: "lock_inventory_settings")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_inventory_settings")
        }
        
        //coupon
        if per_array.contains("AO") {
            UserDefaults.standard.set(false, forKey: "lock_add_coupon")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_coupon")
        }
        
        if per_array.contains("UO") {
            UserDefaults.standard.set(false, forKey: "lock_edit_coupon")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_coupon")
        }
        
        if per_array.contains("RO") {
            UserDefaults.standard.set(false, forKey: "lock_delete_coupon")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_coupon")
        }
        
        if per_array.contains("C") {
            UserDefaults.standard.set(false, forKey: "lock_access_coupon")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_coupon")
        }
        
        //reporting
        if per_array.contains("DG") {
            UserDefaults.standard.set(false, forKey: "lock_dashboard_graph")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_dashboard_graph")
        }
        
        
        if per_array.contains("AR") {
            UserDefaults.standard.set(false, forKey: "lock_access_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_reports")
        }
        
        if per_array.contains("SA") {
            UserDefaults.standard.set(false, forKey: "lock_sales_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_sales_reports")
        }
        
        if per_array.contains("IN") {
            UserDefaults.standard.set(false, forKey: "lock_inventory_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_inventory_reports")
        }
        
        if per_array.contains("PA") {
            UserDefaults.standard.set(false, forKey: "lock_payment_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_payment_reports")
        }
        
        if per_array.contains("RA") {
            UserDefaults.standard.set(false, forKey: "lock_register_activity")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_register_activity")
        }
        
        if per_array.contains("RR") {
            UserDefaults.standard.set(false, forKey: "lock_refund_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_refund_reports")
        }
        
        if per_array.contains("LR") {
            UserDefaults.standard.set(false, forKey: "lock_loyalty_report")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_loyalty_report")
        }
        
        if per_array.contains("SR") {
            UserDefaults.standard.set(false, forKey: "lock_sc_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_sc_reports")
        }
        
        if per_array.contains("GR") {
            UserDefaults.standard.set(false, forKey: "lock_gc_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_gc_reports")
        }
        
        if per_array.contains("CM") {
            UserDefaults.standard.set(false, forKey: "lock_customer_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_customer_reports")
        }
        
        if per_array.contains("ER") {
            UserDefaults.standard.set(false, forKey: "lock_employee_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_employee_reports")
        }
        
        if per_array.contains("TR") {
            UserDefaults.standard.set(false, forKey: "lock_tax_reports")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_tax_reports")
        }
        
        if per_array.contains("EH") {
            UserDefaults.standard.set(false, forKey: "lock_employee_hours")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_employee_hours")
        }
        
        //customers
        
        if per_array.contains("AU") {
            UserDefaults.standard.set(false, forKey: "lock_add_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_customer")
        }
        
        if per_array.contains("UU") {
            UserDefaults.standard.set(false, forKey: "lock_edit_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_customer")
        }
        
        if per_array.contains("PU") {
            UserDefaults.standard.set(false, forKey: "lock_disable_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_disable_customer")
        }
        
        if per_array.contains("RU") {
            UserDefaults.standard.set(false, forKey: "lock_delete_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_customer")
        }
        
        if per_array.contains("IP") {
            UserDefaults.standard.set(false, forKey: "lock_add_points_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_points_customer")
        }
        
        if per_array.contains("DP") {
            UserDefaults.standard.set(false, forKey: "lock_delete_points_customer")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_points_customer")
        }
        
        //vendors
        
        if per_array.contains("CV") {
            UserDefaults.standard.set(false, forKey: "lock_add_vendors")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_add_vendors")
        }
        
        if per_array.contains("UV") {
            UserDefaults.standard.set(false, forKey: "lock_edit_vendors")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_vendors")
        }
        
        if per_array.contains("PV") {
            UserDefaults.standard.set(false, forKey: "lock_disable_vendors")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_disable_vendors")
        }
        
        if per_array.contains("AV") {
            UserDefaults.standard.set(false, forKey: "lock_access_vendors")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_vendors")
        }
        
        //PO
        
        if per_array.contains("EO") {
            UserDefaults.standard.set(false, forKey: "lock_create_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_create_po")
        }
        
        if per_array.contains("VI") {
            UserDefaults.standard.set(false, forKey: "lock_view_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_view_po")
        }
        
        if per_array.contains("EP") {
            UserDefaults.standard.set(false, forKey: "lock_edit_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_edit_po")
        }
        
        if per_array.contains("RP") {
            UserDefaults.standard.set(false, forKey: "lock_receive_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_receive_po")
        }
        
        if per_array.contains("VP") {
            UserDefaults.standard.set(false, forKey: "lock_void_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_void_po")
        }
        
        if per_array.contains("AP") {
            UserDefaults.standard.set(false, forKey: "lock_access_po")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_po")
        }
        
        //taxes
        
        if per_array.contains("T") {
            UserDefaults.standard.set(false, forKey: "lock_access_taxes")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_taxes")
        }
        
        // orders
        
        if per_array.contains("UP") {
            UserDefaults.standard.set(false, forKey: "lock_update_order_status")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_update_order_status")
        }
        
        //employees
        
        if per_array.contains("AE") {
            UserDefaults.standard.set(false, forKey: "lock_access_employees")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_employees")
        }
        
        if per_array.contains("ME") {
            UserDefaults.standard.set(false, forKey: "lock_manage_employees")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_manage_employees")
        }
        
        if per_array.contains("TI") {
            UserDefaults.standard.set(false, forKey: "lock_access_timesheet")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_access_timesheet")
        }
        
        if per_array.contains("DE") {
            UserDefaults.standard.set(false, forKey: "lock_delete_employees")
        }
        else {
            UserDefaults.standard.set(true, forKey: "lock_delete_employees")
        }
    }
    
    func setupLogoutApi() {
        
        let url = AppURLs.LOGOUT
        let merchant = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let parameters: [String:Any] = [
            "merchant_id": merchant,
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
                    self.loadingIndicator.isAnimating = false
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    func getAdvId() -> String {
        let adv_id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print(adv_id)
        return adv_id
    }
    
    func showAlertLogout(title: String, message: String) {
        
        loadingIndicator.isAnimating = false
        
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
            
            self.passview.isHidden = false
            self.stackfirst.isHidden = false
            self.stackSecond.isHidden = false
            self.stackThird.isHidden = false
            self.stackFourth.isHidden = false
            self.loadingIndicator.isAnimating = false
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! HomeViewController
        vc.page = webview.url
    }
    
    
    func circularBorder(button: UIButton) {
        
        button.layer.borderColor = UIColor(red: 141.0/255.0, green: 199.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        
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

extension PassCodeViewController {
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        showAppear()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//
//            let mail = UserDefaults.standard.string(forKey: "merchant_email") ?? ""
//            let pass = UserDefaults.standard.string(forKey: "merchant_password") ?? ""
//
//            self.webview.evaluateJavaScript("var input = document.getElementsByName('username')[0]; input.focus(); document.execCommand('insertText', false, \'\(mail)\')") {_,error in
//
//                print(error)
//
//                if error == nil {
//                    self.webview.evaluateJavaScript("var input = document.getElementsByName('password')[0]; input.focus(); document.execCommand('insertText', false, \'\(pass)\')") {_,error in
//                        print(error)
//                        if error == nil {
//                            self.webview.evaluateJavaScript("document.querySelector('.MuiButtonBase-root.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.customer-btn.css-1hw9j7s').click()") { res, error in
//                                print(error)
//                                if error == nil {
//
                                    
//                                }
//                            }
//                        }
//                    }
//                }
//                else {
//                }
//            }
//        }
    }
}

extension UIView {
    
    func shake(numberOfShakes shakes: Float, revert: Bool) {
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}


struct PassEmp {
    
    let id: String
    let f_name: String
    let l_name: String
    let phone: String
    let email: String
    let pin: String
    let wages_per_hr: String
    let role: String
    let merchant_id: String
    let admin_id: String
    let address: String
    let city: String
    let state: String
    let zipcode: String
    let is_employee: String
    let permissions: String
    let break_time: String
    let break_allowed: String
    let is_login: String
    let login_time: String
    let status: String
    let created_from: String
    let created_at: String
    let updated_from: String
    let updated_at: String
    let menu_list: String
    let enable_backend_access: String
    let enable_pos_access: String
    let password: String
    let read_pass: String
    let assigned_store: String
    let is_admin: String
}
