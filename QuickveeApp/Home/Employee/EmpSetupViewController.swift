//
//  EmpSetupViewController.swift
//
//
//  Created by Jamaluddin Syed on 6/12/24.
//

import UIKit
import MaterialComponents

class EmpSetupViewController: UIViewController {
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var firstName: MDCOutlinedTextField!
    @IBOutlet weak var lastName: MDCOutlinedTextField!
    @IBOutlet weak var pin: MDCOutlinedTextField!
    
    @IBOutlet weak var pinInnerView: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var managerView: UIView!
    @IBOutlet weak var cashierView: UIView!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var timeClockView: UIView!
    
    @IBOutlet weak var managerLbl: UILabel!
    @IBOutlet weak var cashierLbl: UILabel!
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var managerImg: UIImageView!
    @IBOutlet weak var cashierImg: UIImageView!
    @IBOutlet weak var driverImg: UIImageView!
    @IBOutlet weak var timeImg: UIImageView!
    
    @IBOutlet weak var managerWidth: NSLayoutConstraint!
    @IBOutlet weak var cashWidth: NSLayoutConstraint!
    @IBOutlet weak var driverWidth: NSLayoutConstraint!
    @IBOutlet weak var timeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var homecoll: UICollectionView!
    @IBOutlet weak var regcoll: UICollectionView!
    @IBOutlet weak var storecoll: UICollectionView!
    @IBOutlet weak var usercoll: UICollectionView!
    @IBOutlet weak var giftcoll: UICollectionView!
    @IBOutlet weak var inventcoll: UICollectionView!
    @IBOutlet weak var couponcoll: UICollectionView!
    @IBOutlet weak var setupcoll: UICollectionView!
    @IBOutlet weak var customcoll: UICollectionView!
    
    @IBOutlet weak var numberBreakd: MDCOutlinedTextField!
    @IBOutlet weak var minBreaks: MDCOutlinedTextField!
    @IBOutlet weak var numberPaidBreaks: MDCOutlinedTextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var homecollHeight: NSLayoutConstraint!
    @IBOutlet weak var regCollHeight: NSLayoutConstraint!
    @IBOutlet weak var storeCollHieght: NSLayoutConstraint!
    @IBOutlet weak var userCollHeight: NSLayoutConstraint!
    @IBOutlet weak var giftCollHeight: NSLayoutConstraint!
    @IBOutlet weak var inventCollHeight: NSLayoutConstraint!
    @IBOutlet weak var couponCollHeight: NSLayoutConstraint!
    @IBOutlet weak var setupCollHeight: NSLayoutConstraint!
    @IBOutlet weak var customCollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var pinCheck = [String]()
    var activeTextField = UITextField()
    
    let border = UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    let home = ["Setup Screen", "Gift Card", "Inventory Screen"]
    
    let register = ["No Sale", "Vendor Payout", "Cash Drop", "Receipts",
                    "Refund", "Add New Item", "Change Price", "Discount",
                    "OTD Price", "Cash Payment", "Credit Debit Payment", "Close/Open Shift",
                    "Dispatch Center", "Item Discount", "Add/Remove Tax", "Food EBT",
                    "Cash EBT", "Gift Card(Issue/Redeem)", "Custom Item", "Cash Back", "Void", "21 PLUS PRODUCT MANUALLY VERIFIED"]
    
    let store = ["Store Reports", "All Shift Report", "Own Shift Report", "View Credit Card Report"]
    
    let user = ["Manage Own Profile", "Add User", "Edit User", "Delete User"]
    
    let gift = ["Add Gift Card Balance", "Remove Gift Card Balance"]
    
    let invent = ["Edit Items", "Add Items", "Disable Item", "Delete Items",
                  "Edit Categories", "Add Categories", "Disable Categories", "Delete Categories",
                  "Add Vendor", "Edit Vendor", "Disable Vendor", "Create PO", "View PO's", "Edit PO's",
                  "Receive PO's", "Void PO's"]
    
    let coupons = ["Add Coupon", "Edit Coupon", "Delete Coupon"]
    
    let setup = ["Company Info", "Receipt Footer Text", "Inventory", "Register Settings",
                 "Hardware", "System Access", "Email & SMS Alert", "Taxes",
                 "Store Options", "Coupons", "Loyalty Program", "Quickadd", "Store Setup"]
    
    let custom = ["Add Customer", "Edit Customer", "Disable Customer", "Delete Customer", "Add Points", "Remove Points"]
    
    var per_arr = [String]()
    
    var mode: String?
    var emp_id: String?
    var employee: Employee?
    
    var set_role = ""
    
    var managerCheck = false
    var cashierCheck = false
    var driverCheck = false
    var timeCheck = false
    
    var addEmpClick = true
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        saveBtn.layer.cornerRadius = 10.0
        cancelBtn.layer.cornerRadius = 10.0
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        createCustomTextField(textField: firstName)
        createCustomTextField(textField: lastName)
        createCustomTextField(textField: pin)
        
        createCustomTextField(textField: numberBreakd)
        createCustomTextField(textField: minBreaks)
        createCustomTextField(textField: numberPaidBreaks)
        
        pinInnerView.backgroundColor = UIColor(named: "Disabled Text")
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(manageTouch))
        managerView.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        managerView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(cashTouch))
        cashierView.addGestureRecognizer(tap2)
        tap2.numberOfTapsRequired = 1
        cashierView.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(driveTouch))
        driverView.addGestureRecognizer(tap3)
        tap3.numberOfTapsRequired = 1
        driverView.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(timeTouch))
        timeClockView.addGestureRecognizer(tap4)
        tap4.numberOfTapsRequired = 1
        timeClockView.isUserInteractionEnabled = true
        
        firstName.label.text = "First Name\u{002A}"
        lastName.label.text = "Last Name"
        pin.label.text = "PIN\u{002A}"
        
        numberBreakd.label.text = "Number of breaks Allowed\u{002A}"
        minBreaks.label.text = "Minutes per Break\u{002A}"
        numberPaidBreaks.label.text = "Number of Paid Breaks Per day\u{002A}"
        
        pin.keyboardType = .numberPad
        numberBreakd.keyboardType = .numberPad
        minBreaks.keyboardType = .numberPad
        numberPaidBreaks.keyboardType = .numberPad
        
        pin.delegate = self
        numberBreakd.delegate = self
        minBreaks.delegate = self
        numberPaidBreaks.delegate = self
        
        pin.addTarget(self, action: #selector(updateText), for: .editingChanged)
        numberBreakd.addTarget(self, action: #selector(updateText), for: .editingChanged)
        minBreaks.addTarget(self, action: #selector(updateText), for: .editingChanged)
        numberPaidBreaks.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        managerView.layer.cornerRadius = 10.0
        cashierView.layer.cornerRadius = 10.0
        driverView.layer.cornerRadius = 10.0
        timeClockView.layer.cornerRadius = 10.0
        
        managerView.layer.borderWidth = 1.0
        cashierView.layer.borderWidth = 1.0
        driverView.layer.borderWidth = 1.0
        timeClockView.layer.borderWidth = 1.0
        
        
        homecoll.delegate = self
        homecoll.dataSource = self
        
        regcoll.delegate = self
        regcoll.dataSource = self
        
        storecoll.delegate = self
        storecoll.dataSource = self
        
        usercoll.delegate = self
        usercoll.dataSource = self
        
        giftcoll.delegate = self
        giftcoll.dataSource = self
        
        inventcoll.delegate = self
        inventcoll.dataSource = self
        
        couponcoll.delegate = self
        couponcoll.dataSource = self
        
        setupcoll.delegate = self
        setupcoll.dataSource = self
        
        customcoll.delegate = self
        customcoll.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        if mode == "add" {
            
            deleteBtn.isHidden = true
            
            pinInnerView.isHidden = true
            pin.setTextColor(.black, for: .normal)
            topLabel.text = "Add Employee"
            
            managerLbl.textColor = .black
            cashierLbl.textColor = .black
            driverLbl.textColor = .black
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 0
            driverWidth.constant = 0
            timeWidth.constant = 0
            
            saveBtn.setTitle("Add", for: .normal)
            
            set_role = ""
            setupTables()
        }
        else {
            
            deleteBtn.isHidden = false
            
            pinInnerView.isHidden = false
            pin.setTextColor(border, for: .normal)
            topLabel.text = "Edit Employee"
            saveBtn.setTitle("Save", for: .normal)
            
            loadingIndicator.isAnimating = true
            scrollView.isHidden = true
            setupApi()
        }
    }
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp = emp_id ?? ""
        
        ApiCalls.sharedCall.getEmpById(merchant_id: id, emp_id: emp) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
                self.setupTables()
                
            }
            
            else {
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let res = response as! [String:Any]
        
        employee = Employee(id: "\(res["id"] ?? "")", f_name: "\(res["f_name"] ?? "")",
                            l_name: "\(res["l_name"] ?? "")", phone: "\(res["phone"] ?? "")",
                            email: "\(res["email"] ?? "")", pin: "\(res["pin"] ?? "")",
                            wages_per_hr: "\(res["wages_per_hr"] ?? "")", role: "\(res["role"] ?? "")",
                            merchant_id: "\(res["merchant_id"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                            address: "\(res["address"] ?? "")", city: "\(res["city"] ?? "")",
                            state: "\(res["state"] ?? "")", zipcode: "\(res["zipcode"] ?? "")",
                            is_employee: "\(res["is_employee"] ?? "")",
                            permissions: "\(res["permissions"] ?? "")", paid_breaks: "\(res["paid_breaks"] ?? "")",
                            break_time: "\(res["break_time"] ?? "")",
                            break_allowed: "\(res["break_allowed"] ?? "")", is_login: "\(res["is_login"] ?? "")",
                            login_time: "\(res["login_time"] ?? "")",
                            status: "\(res["status"] ?? "")", created_from: "\(res["created_from"] ?? "")",
                            created_at: "\(res["created_at"] ?? "")",
                            updated_from: "\(res["updated_from"] ?? "")", updated_at: "\(res["updated_at"] ?? "")",
                            menu_list: "\(res["menu_list"] ?? "")")
        
        firstName.text = employee?.f_name
        lastName.text = employee?.l_name
        pin.text = employee?.pin
        
        numberBreakd.text = employee?.break_allowed
        minBreaks.text = employee?.break_time
        numberPaidBreaks.text = employee?.paid_breaks
        
        let role = employee?.role ?? ""
        setRole(role: role)
        
        let permission = employee?.permissions ?? ""
        
        per_arr = permission.components(separatedBy: ",")
        
    }
    
    func setRole(role: String) {
        
        
        if role == "manager" {
            
            managerLbl.textColor = UIColor(hexString: "#0A64F9")
            cashierLbl.textColor = .black
            driverLbl.textColor = .black
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 20
            cashWidth.constant = 0
            driverWidth.constant = 0
            timeWidth.constant = 0
            
            set_role = role
        }
        
        else if role == "cashier" {
            
            managerLbl.textColor = .black
            cashierLbl.textColor = UIColor(hexString: "#0A64F9")
            driverLbl.textColor = .black
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 20
            driverWidth.constant = 0
            timeWidth.constant = 0
            
            set_role = role
        }
        
        else if role == "driver" {
            
            managerLbl.textColor = .black
            cashierLbl.textColor = .black
            driverLbl.textColor = UIColor(hexString: "#0A64F9")
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 0
            driverWidth.constant = 20
            timeWidth.constant = 0
            
            set_role = role
        }
        
        else {
            managerLbl.textColor = .black
            cashierLbl.textColor = .black
            driverLbl.textColor = .black
            timeLbl.textColor = UIColor(hexString: "#0A64F9")
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 0
            driverWidth.constant = 0
            timeWidth.constant = 20
            
            set_role = role
        }
    }
    
    
    func setupTables() {
        
        homecollHeight.constant = 128
        regCollHeight.constant = 704
        storeCollHieght.constant = 128
        userCollHeight.constant = 128
        giftCollHeight.constant = 64
        inventCollHeight.constant = 512
        couponCollHeight.constant = 128
        setupCollHeight.constant = 448
        customCollHeight.constant = 192
        
        homecoll.reloadData()
        regcoll.reloadData()
        storecoll.reloadData()
        usercoll.reloadData()
        giftcoll.reloadData()
        inventcoll.reloadData()
        couponcoll.reloadData()
        setupcoll.reloadData()
        customcoll.reloadData()
        
        let home = homecollHeight.constant
        let reg = regCollHeight.constant
        let store = storeCollHieght.constant
        let user = userCollHeight.constant
        let invent = giftCollHeight.constant
        let coupon = couponCollHeight.constant
        let setup = setupCollHeight.constant
        let custom = customCollHeight.constant
        
        scrollHeight.constant = home + reg + store + user + invent + coupon + setup + custom + 1722
        
        loadingIndicator.isAnimating = false
        scrollView.isHidden = false
    }
    
    @objc func manageTouch() {
        
        if managerLbl.textColor != UIColor(hexString: "#0A64F9") {
            
            managerLbl.textColor = UIColor(hexString: "#0A64F9")
            cashierLbl.textColor = .black
            driverLbl.textColor = .black
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 20
            cashWidth.constant = 0
            driverWidth.constant = 0
            timeWidth.constant = 0
            
            set_role = "manager"
            
            managerCheck = true
            cashierCheck = false
            driverCheck = false
            timeCheck = false
            
            homecoll.reloadData()
            regcoll.reloadData()
            storecoll.reloadData()
            usercoll.reloadData()
            giftcoll.reloadData()
            inventcoll.reloadData()
            couponcoll.reloadData()
            setupcoll.reloadData()
            customcoll.reloadData()
            
            
            
            let pre_arr = ["NO", "VE", "CA", "RE", "RF", "NI", "CH", "DI", "OT",
                           "CT",  "CR", "CL", "CD", "ID", "AT", "FO",
                           "CE", "GI", "CI", "CB", "VD", "21","AI",
                           "EO", "VI", "EP", "RP", "VP",
                           "SR", "AR", "OR", "VR", "MO", "AE",
                           "EE", "DE", "GB", "RB", "ED", "AD",
                           "DS", "RI", "UC", "CC", "PC", "RC",
                           "CV", "UV", "PV", "AO", "UO", "RO",
                           "ST", "PT", "IS", "PS", "HA", "SY",
                           "AL", "T", "OP", "C", "ALP", "QA",
                           "SP", "AU", "UU", "PU", "RU", "AB",
                           "DP", "SC", "GC"]
            
            
//            let pre_arr = ["1", "2", "3", "4", "5", "6", "8", "9", "10",
//                           "11",  "12", "13", "72", "94", "98", "99",
//                           "100", "101", "102", "104", "106", "108",
//                           "109", "110", "111", "112", "113",
//                           "14", "15", "16", "17", "18", "20",
//                           "21", "23", "95", "96", "25", "26",
//                           "27", "28", "29", "30", "31", "32",
//                           "33", "34", "35", "37", "38", "39",
//                           "58", "59", "61", "62", "65", "66",
//                           "67", "68", "70", "73", "74", "91",
//                           "93", "51", "52", "53", "54", "75",
//                           "76", "SC", "97"]
            
            per_arr = pre_arr
        }
    }
    
    @objc func cashTouch() {
        
        if cashierLbl.textColor != UIColor(hexString: "#0A64F9") {
            
            managerLbl.textColor = .black
            cashierLbl.textColor = UIColor(hexString: "#0A64F9")
            driverLbl.textColor = .black
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 20
            driverWidth.constant = 0
            timeWidth.constant = 0
            
            set_role = "cashier"
            
            managerCheck = false
            cashierCheck = true
            driverCheck = false
            timeCheck = false
            
            homecoll.reloadData()
            regcoll.reloadData()
            storecoll.reloadData()
            usercoll.reloadData()
            giftcoll.reloadData()
            inventcoll.reloadData()
            couponcoll.reloadData()
            setupcoll.reloadData()
            customcoll.reloadData()
            
            let pre_arr = ["NO", "VE", "CA", "RE", "RF", "CT", "CR", "CL", "FO", "CE", "GI", "OR", "MO", "SP"]
            
            per_arr = pre_arr
        }
    }
    
    @objc func driveTouch() {
        
        if driverLbl.textColor != UIColor(hexString: "#0A64F9") {
            
            managerLbl.textColor = .black
            cashierLbl.textColor = .black
            driverLbl.textColor = UIColor(hexString: "#0A64F9")
            timeLbl.textColor = .black
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 0
            driverWidth.constant = 20
            timeWidth.constant = 0
            
            set_role = "driver"
            
            managerCheck = false
            cashierCheck = false
            driverCheck = true
            timeCheck = false
            
            homecoll.reloadData()
            regcoll.reloadData()
            storecoll.reloadData()
            usercoll.reloadData()
            giftcoll.reloadData()
            inventcoll.reloadData()
            couponcoll.reloadData()
            setupcoll.reloadData()
            customcoll.reloadData()
            
            let pre_arr = ["CL", "CD"]
            
            per_arr = pre_arr
        }
    }
    
    @objc func timeTouch() {
        
        if timeLbl.textColor != UIColor(hexString: "#0A64F9") {
            
            managerLbl.textColor = .black
            cashierLbl.textColor = .black
            driverLbl.textColor = .black
            timeLbl.textColor = UIColor(hexString: "#0A64F9")
            
            managerView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            cashierView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            driverView.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
            timeClockView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
            
            managerWidth.constant = 0
            cashWidth.constant = 0
            driverWidth.constant = 0
            timeWidth.constant = 20
            
            set_role = "time_clock"
            
            managerCheck = false
            cashierCheck = false
            driverCheck = false
            timeCheck = true
            
            homecoll.reloadData()
            regcoll.reloadData()
            storecoll.reloadData()
            usercoll.reloadData()
            giftcoll.reloadData()
            inventcoll.reloadData()
            couponcoll.reloadData()
            setupcoll.reloadData()
            customcoll.reloadData()
            
            let pre_arr = ["CL"]
            
            per_arr = pre_arr
        }
    }
    
    func deleteEmp() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let emp = emp_id ?? ""
        
        ApiCalls.sharedCall.deleteEmployee(merchant_id: id, emp_id: emp) { isSuccess, responseData in
            
            if isSuccess {
                
                if let status = responseData["status"], status as! Int == 1  {
                    print(status)
                    let msg = responseData["message"] as? String ?? ""
                    ToastClass.sharedToast.showToast(message: msg,
                                                     font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
            }
        }
    }
    
    func checkPaidBreak(paid: String, num: String) -> Bool {
        
        let paidNumber = Int(paid) ?? 0
        let num = Int(num) ?? 0
        
        if paidNumber > num {
            return false
        }
        return true
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_user")  {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
           
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this employee?",
                                                    preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                
                
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                self.deleteEmp()
                
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            guard addEmpClick else {
                return
            }
        }
        
        addEmpClick = false
        loadIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let fname = firstName.text, fname != "" else {
            firstName.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Name",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        let l_name = lastName.text ?? ""
        
        guard let pin_text = pin.text, pin_text != "" else {
            pin.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Pin",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        guard pin_text.count == 4 else {
            pin.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter 4 digit pin",
                                             font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        if mode == "add" {
            
            guard !pinCheck.contains(pin_text) else {
                pin.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Please choose another pin. Pin is already registered.",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
                loadIndicator.isAnimating = false
                addEmpClick = true
                return
            }
        }
        
        guard set_role != "" else {
            ToastClass.sharedToast.showToast(message: "Select Employee Role",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        guard let numBreaks  = numberBreakd.text, numBreaks != "" else {
            numberBreakd.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Number of breaks allowed per day",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        guard let minBreak = minBreaks.text, minBreak != "" else {
            minBreaks.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Minutes per day",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        guard let paidBreak = numberPaidBreaks.text, paidBreak != "" else {
            numberPaidBreaks.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Number of paid breaks per day",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        guard checkPaidBreak(paid: paidBreak, num: numBreaks) else {
            ToastClass.sharedToast.showToast(message: "Paid breaks should not be more than number of break allowed per day",
                                             font: UIFont(name: "Manrope-Medium", size: 10.0)!)
            loadIndicator.isAnimating = false
            addEmpClick = true
            return
        }
        
        let per_array = per_arr.sorted(by: {$0 < $1})
        
        let per = per_array.joined(separator: ",")
        
        var emp = ""
        
        if sender.currentTitle == "Add" {
            emp = ""
        }
        
        else {
            emp = emp_id ?? ""
        }
        
        //       let per_allow = per.components(separatedBy: ",")
        
        
        ApiCalls.sharedCall.addEditEmployee(merchant_id: id, admin_id: id, employee_id: emp,
                                            f_name: fname, l_name: l_name, role: set_role,
                                            pin: pin_text, permissions: per, break_allowed: numBreaks,
                                            break_time: minBreak, paid_breaks: paidBreak,
                                            status: "1") { isSuccess, responseData in
            
            if isSuccess {
                
                if let status = responseData["status"], status as! Int == 1  {
                    self.loadIndicator.isAnimating = false
                    let msg = responseData["message"] as? String ?? ""
                    
                    let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
                    
                    if emp_id == emp {
                        UserDefaults.standard.set(fname, forKey: "merchant_name")
                    }
                    
                    ToastClass.sharedToast.showToast(message: msg,
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    if self.mode == "add" {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            else {
                self.loadIndicator.isAnimating = false
            }
        }
    }
}

extension EmpSetupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == homecoll {
            return home.count
        }
        
        else if collectionView == regcoll {
            return register.count
        }
        
        else if collectionView == storecoll {
            return store.count
        }
        
        else if collectionView == usercoll {
            return user.count
        }
        
        else if collectionView == giftcoll {
            return gift.count
        }
        
        else if collectionView == inventcoll {
            return invent.count
        }
        
        else if collectionView == couponcoll {
            return coupons.count
        }
        
        else if collectionView == setupcoll {
            return setup.count
        }
        
        else {
            return custom.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homecoll {
            
            let cell = homecoll.dequeueReusableCell(withReuseIdentifier: "emphomecell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // Setup Screen
                
                if per_arr.contains("SC") || managerCheck {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    UserDefaults.standard.set(false, forKey: "lock_setup")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    UserDefaults.standard.set(true, forKey: "lock_setup")
                }
                
            }
            
            else if indexPath.row == 1 { // gift card
                
                if per_arr.contains("GC") || managerCheck {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    UserDefaults.standard.set(false, forKey: "lock_gift")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    UserDefaults.standard.set(true, forKey: "lock_gift")
                }
            }
            
            else { // inventory screen
                
                if per_arr.contains("AI") || managerCheck {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    UserDefaults.standard.set(false, forKey: "lock_inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    UserDefaults.standard.set(true, forKey: "lock_inventory")
                }
            }
            
            cell.setEmpLbl.text = home[indexPath.row]
            return cell
        }
        
        else if collectionView == regcoll {
            
            let cell = regcoll.dequeueReusableCell(withReuseIdentifier: "empregcell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // no sale
                
                if per_arr.contains("NO") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // vendor payout
                
                if per_arr.contains("VE") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // cash drop
                
                if per_arr.contains("CA") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 3 { // receipts
                
                if per_arr.contains("RE") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 4 { // refund
                
                if per_arr.contains("RF") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 5 { // add new item
                
                if per_arr.contains("NI") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 6 { // change price
                
                if per_arr.contains("CH") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 7 { // discount
                
                if per_arr.contains("DI") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 8 { // otd price
                
                if per_arr.contains("OT") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 9 { //cash payment
                
                if per_arr.contains("CT") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 10 { // credit debit payment
                
                if per_arr.contains("CR") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 11 { // close open shift
                
                if per_arr.contains("CL") || managerCheck || cashierCheck || driverCheck || timeCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 12 { // dispatch center
                
                if per_arr.contains("CD") || managerCheck || driverCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 13 { // item discount
                
                if per_arr.contains("ID") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 14 { // add/remove tax
                
                if per_arr.contains("AT") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 15 { // food ebt
                
                if per_arr.contains("FO") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 16 { // cash ebt
                
                if per_arr.contains("CE") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 17 { // gift card(issue/redeem)
                
                if per_arr.contains("GI") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 18 { // custom item
                
                if per_arr.contains("CI") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 19  { // cash back
                
                if per_arr.contains("CB") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 20 { // void
                
                if per_arr.contains("VD") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            else { // 21 plus
                if per_arr.contains("21") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = register[indexPath.row]
            return cell
        }
        
        else if collectionView == storecoll {
            
            let cell = storecoll.dequeueReusableCell(withReuseIdentifier: "empstorecell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // store reports
                
                if per_arr.contains("SR") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // all shift report
                
                if per_arr.contains("AR") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // own shift report
                
                if per_arr.contains("OR") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // view credit card report
                
                if per_arr.contains("VR") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = store[indexPath.row]
            return cell
        }
        
        else if collectionView == usercoll {
            
            let cell = usercoll.dequeueReusableCell(withReuseIdentifier: "empusercell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // manage own profile
                
                if per_arr.contains("MO") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // add user
                
                if per_arr.contains("AE") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // edit user
                
                if per_arr.contains("EE") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // delete user
                
                if per_arr.contains("DE") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = user[indexPath.row]
            return cell
        }
        
        else if collectionView == giftcoll {
            
            let cell = giftcoll.dequeueReusableCell(withReuseIdentifier: "empgiftcell", for: indexPath) as! EmpSetCollectionViewCell
            
//            if indexPath.row == 0 { // add gift card balance
//
//                if per_arr.contains("95") || managerCheck {
//
//                    cell.setEmpImg.image = UIImage(named: "check inventory")
//                }
//                else {
//                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
//                }
//            }
//
//            else { // remove gift card balance
//
//                if per_arr.contains("96") || managerCheck {
//
//                    cell.setEmpImg.image = UIImage(named: "check inventory")
//                }
//                else {
//                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
//                }
//            }
            
            
            if indexPath.row == 0 { // add gift card balance
                
                if per_arr.contains("GB") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // remove gift card balance
                
                if per_arr.contains("RB") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            
            
            cell.setEmpLbl.text = gift[indexPath.row]
            return cell
        }
        
        else if collectionView == inventcoll {
            
            let cell = inventcoll.dequeueReusableCell(withReuseIdentifier: "empinventcell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // edit items
                
                if per_arr.contains("ED") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // add items
                
                if per_arr.contains("AD") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // disable items
                
                if per_arr.contains("DS") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 3 { // delete items
                
                if per_arr.contains("RI") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 4 { // edit cat
                
                if per_arr.contains("UC") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 5 { // add cat
                
                if per_arr.contains("CC") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 6 { // disable cat
                
                if per_arr.contains("PC") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 7 { // delete cat
                
                if per_arr.contains("RC") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 8 { // add vendor
                
                if per_arr.contains("CV") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 9 { // edit vendor
                
                if per_arr.contains("UV") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 10 { // disable vendor
                
                if per_arr.contains("PV") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 11 { // create po
                
                if per_arr.contains("EO") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 12 { // view po
                
                if per_arr.contains("VI") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 13 { // edit po
                
                if per_arr.contains("EP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 14 { // receive po
                
                if per_arr.contains("RP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // void po
                
                if per_arr.contains("VP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = invent[indexPath.row]
            return cell
        }
        
        else if collectionView == couponcoll {
            
            let cell = couponcoll.dequeueReusableCell(withReuseIdentifier: "empcouponcell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { //add coupon
                
                if per_arr.contains("AO") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // edit coupon
                
                if per_arr.contains("UO") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // delete coupon
                
                if per_arr.contains("RO") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                
            }
            
            cell.setEmpLbl.text = coupons[indexPath.row]
            return cell
        }
        
        else if collectionView == setupcoll {
            
            let cell = setupcoll.dequeueReusableCell(withReuseIdentifier: "empsetupcell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // company info
                
                if per_arr.contains("ST") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // receipt footer text
                
                if per_arr.contains("PT") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // inventory
                
                if per_arr.contains("IS") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 3 { // reg settings
                
                if per_arr.contains("PS") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 4 { // hardware
                
                if per_arr.contains("HA") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 5 { // system access
                
                if per_arr.contains("SY") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 6 { // email
                
                if per_arr.contains("AL") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 7 { //taxes
                
                if per_arr.contains("T") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 8 { // store options
                
                if per_arr.contains("OP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 9 { // coupons
                
                if per_arr.contains("C") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 10 { // loyalty program
                
                if per_arr.contains("ALP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 11 { // quickadd
                
                if per_arr.contains("QA") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // store setup
                
                if per_arr.contains("SP") || managerCheck || cashierCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = setup[indexPath.row]
            return cell
        }
        
        else {
            
            let cell = customcoll.dequeueReusableCell(withReuseIdentifier: "empcustomcell", for: indexPath) as! EmpSetCollectionViewCell
            
            if indexPath.row == 0 { // add customer
                
                if per_arr.contains("AU") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 1 { // edit customer
                
                if per_arr.contains("UU") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else if indexPath.row == 2 { // disable customer
                
                if per_arr.contains("PU") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            if indexPath.row == 3 { // delete customer
                
                if per_arr.contains("RU") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            if indexPath.row == 4 { // add points
                
                if per_arr.contains("AB") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            else { // remove points
                
                if per_arr.contains("DP") || managerCheck {
                    
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
            }
            
            cell.setEmpLbl.text = custom[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let cell = collectionView.cellForItem(at: indexPath) as! EmpSetCollectionViewCell
          
          var click = 0
          
          if cell.setEmpImg.image == UIImage(named: "check inventory") {
              cell.setEmpImg.image = UIImage(named: "uncheck inventory")
              click = 0
          }
          
          else {
              cell.setEmpImg.image = UIImage(named: "check inventory")
              click = 1
          }
          
          if collectionView == homecoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      
                      per_arr.removeAll(where: {$0 == "SC"})
                      UserDefaults.standard.set(true, forKey: "lock_setup")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "GC"})
                     // per_arr.removeAll(where: {$0 == "97"})
                      UserDefaults.standard.set(true, forKey: "lock_gift")
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "AI"})
                      UserDefaults.standard.set(true, forKey: "lock_inventory")
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      
                      per_arr.append("SC")
                      UserDefaults.standard.set(false, forKey: "lock_setup")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("GC")
                      UserDefaults.standard.set(false, forKey: "lock_gift")
                  }
                  
                  else {
                      per_arr.append("AI")
                      UserDefaults.standard.set(false, forKey: "lock_inventory")
                  }
              }
          }
          
          else if collectionView == regcoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "NO"})
                     // per_arr.removeAll(where: {$0 == "1"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "VE"})
                     // per_arr.removeAll(where: {$0 == "2"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "CA"})
                     // per_arr.removeAll(where: {$0 == "3"})
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.removeAll(where: {$0 == "RE"})
                    //  per_arr.removeAll(where: {$0 == "4"})
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.removeAll(where: {$0 == "CF"})
                    //  per_arr.removeAll(where: {$0 == "5"})
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.removeAll(where: {$0 == "QU"})
                   //   per_arr.removeAll(where: {$0 == "6"})
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.removeAll(where: {$0 == "CH"})
                     // per_arr.removeAll(where: {$0 == "8"})
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.removeAll(where: {$0 == "DI"})
                     // per_arr.removeAll(where: {$0 == "9"})
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.removeAll(where: {$0 == "OT"})
                     // per_arr.removeAll(where: {$0 == "10"})
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.removeAll(where: {$0 == "CT"})
                     // per_arr.removeAll(where: {$0 == "11"})
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.removeAll(where: {$0 == "CR"})
                    //  per_arr.removeAll(where: {$0 == "12"})
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.removeAll(where: {$0 == "CL"})
                     // per_arr.removeAll(where: {$0 == "13"})
                  }
                  
                  else if indexPath.row == 12 {
                      per_arr.removeAll(where: {$0 == "CD"})
                     // per_arr.removeAll(where: {$0 == "72"})
                  }
                  
                  else if indexPath.row == 13 {
                      per_arr.removeAll(where: {$0 == "ID"})
                     // per_arr.removeAll(where: {$0 == "94"})
                  }
                  
                  else if indexPath.row == 14 {
                      per_arr.removeAll(where: {$0 == "AT"})
                     // per_arr.removeAll(where: {$0 == "98"})
                  }
                  
                  else if indexPath.row == 15 {
                      per_arr.removeAll(where: {$0 == "FO"})
                     // per_arr.removeAll(where: {$0 == "99"})
                  }
                  
                  else if indexPath.row == 16 {
                      per_arr.removeAll(where: {$0 == "CE"})
                     // per_arr.removeAll(where: {$0 == "100"})
                  }
                  
                  else if indexPath.row == 17 {
                      per_arr.removeAll(where: {$0 == "GI"})
                     // per_arr.removeAll(where: {$0 == "101"})
                  }
                  
                  else if indexPath.row == 18 {
                      per_arr.removeAll(where: {$0 == "CI"})
                     // per_arr.removeAll(where: {$0 == "102"})
                  }
                  
                  else if indexPath.row == 19 {
                      per_arr.removeAll(where: {$0 == "CB"})
                     // per_arr.removeAll(where: {$0 == "104"})
                  }
                  
                  else if indexPath.row == 20 {
                      per_arr.removeAll(where: {$0 == "VD"})
                     // per_arr.removeAll(where: {$0 == "106"})
                  }
                  else {
                      per_arr.removeAll(where: {$0 == "21"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "NO"})
                     // per_arr.append("1")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "VE"})
                    //  per_arr.append("2")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "CA"})
                     // per_arr.append("3")
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.removeAll(where: {$0 == "RE"})
                    //  per_arr.append("4")
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.removeAll(where: {$0 == "CF"})
                     // per_arr.append("5")
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.removeAll(where: {$0 == "QU"})
                      // per_arr.append("6")
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.removeAll(where: {$0 == "CH"})
                      // per_arr.append("8")
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.removeAll(where: {$0 == "DI"})
                     // per_arr.append("9")
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.removeAll(where: {$0 == "OT"})
                     // per_arr.append("10")
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.removeAll(where: {$0 == "CT"})
                      // per_arr.append("11")
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.removeAll(where: {$0 == "CR"})
                      // per_arr.append("12")
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.removeAll(where: {$0 == "CL"})
                      //per_arr.append("13")
                  }
                  
                  else if indexPath.row == 12 {
                      per_arr.removeAll(where: {$0 == "CD"})
                     // per_arr.append("72")
                  }
                  
                  else if indexPath.row == 13 {
                      per_arr.removeAll(where: {$0 == "ID"})
                     // per_arr.append("94")
                  }
                  
                  else if indexPath.row == 14 {
                      per_arr.removeAll(where: {$0 == "AT"})
                     // per_arr.append("98")
                  }
                  
                  else if indexPath.row == 15 {
                      per_arr.removeAll(where: {$0 == "FO"})
                      //per_arr.append("99")
                  }
                  
                  else if indexPath.row == 16 {
                      per_arr.removeAll(where: {$0 == "CE"})
                     // per_arr.append("100")
                  }
                  
                  else if indexPath.row == 17 {
                      per_arr.removeAll(where: {$0 == "GI"})
                     // per_arr.append("101")
                  }
                  
                  else if indexPath.row == 18 {
                      per_arr.removeAll(where: {$0 == "CI"})
                      //per_arr.append("102")
                  }
                  
                  else if indexPath.row == 19 {
                      per_arr.removeAll(where: {$0 == "CB"})
                     // per_arr.append("104")
                  }
                  
                  else  if indexPath.row == 20 {
                      per_arr.removeAll(where: {$0 == "VD"})
                     // per_arr.append("106")
                  }
                  else {
                      per_arr.removeAll(where: {$0 == "21"})
                  }
              }
          }
          
          else if collectionView == storecoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "SR"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "AR"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "OR"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "VR"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("SR")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("AR")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.append("OR")
                  }
                  
                  else {
                      per_arr.append("VR")
                  }
              }
          }
          
          else if collectionView == usercoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "MO"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "AE"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "EE"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "DE"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("MO")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("AE")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.append("EE")
                  }
                  
                  else {
                      per_arr.append("DE")
                  }
              }
          }
          
          else if collectionView == giftcoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "GB"})
                      //per_arr.removeAll(where: {$0 == "95"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "RB"})
                     // per_arr.removeAll(where: {$0 == "96"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("GB")
                      //per_arr.append("95")
                  }
                  
                  else {
                      per_arr.append("RB")
                     // per_arr.append("96")
                  }
              }
          }
          
          else if collectionView == inventcoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "ED"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "AD"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "DS"})
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.removeAll(where: {$0 == "RI"})
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.removeAll(where: {$0 == "UC"})
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.removeAll(where: {$0 == "CC"})
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.removeAll(where: {$0 == "PC"})
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.removeAll(where: {$0 == "RC"})
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.removeAll(where: {$0 == "CV"})
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.removeAll(where: {$0 == "UV"})
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.removeAll(where: {$0 == "PV"})
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.removeAll(where: {$0 == "EO"})
                  }
                  
                  else if indexPath.row == 12 {
                      per_arr.removeAll(where: {$0 == "VI"})
                  }
                  
                  else if indexPath.row == 13 {
                      per_arr.removeAll(where: {$0 == "EP"})
                  }
                  
                  else if indexPath.row == 14 {
                      per_arr.removeAll(where: {$0 == "RP"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "VP"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("ED")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("AD")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.append("DS")
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.append("RI")
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.append("UC")
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.append("CC")
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.append("PC")
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.append("RC")
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.append("CV")
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.append("UV")
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.append("PV")
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.append("EO")
                  }
                  
                  else if indexPath.row == 12 {
                      per_arr.append("VI")
                  }
                  
                  else if indexPath.row == 13 {
                      per_arr.append("EP")
                  }
                  
                  else if indexPath.row == 14 {
                      per_arr.append("RP")
                  }
                  
                  else {
                      per_arr.append("VP")
                  }
              }
          }
          
          else if collectionView == couponcoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "AO"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "UO"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "RO"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("AO")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("UO")
                  }
                  
                  else {
                      per_arr.append("RO")
                  }
              }
          }
          
          else if collectionView == setupcoll {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "ST"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "PT"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "IS"})
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.removeAll(where: {$0 == "PS"})
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.removeAll(where: {$0 == "HA"})
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.removeAll(where: {$0 == "SY"})
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.removeAll(where: {$0 == "AL"})
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.removeAll(where: {$0 == "T"})
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.removeAll(where: {$0 == "OP"})
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.removeAll(where: {$0 == "C"})
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.removeAll(where: {$0 == "ALP"})
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.removeAll(where: {$0 == "QA"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "SP"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("ST")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("PT")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.append("IS")
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.append("PS")
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.append("HA")
                  }
                  
                  else if indexPath.row == 5 {
                      per_arr.append("SY")
                  }
                  
                  else if indexPath.row == 6 {
                      per_arr.append("AL")
                  }
                  
                  else if indexPath.row == 7 {
                      per_arr.append("T")
                  }
                  
                  else if indexPath.row == 8 {
                      per_arr.append("OP")
                  }
                  
                  else if indexPath.row == 9 {
                      per_arr.append("C")
                  }
                  
                  else if indexPath.row == 10 {
                      per_arr.append("ALP")
                  }
                  
                  else if indexPath.row == 11 {
                      per_arr.append("QA")
                  }
                  
                  else {
                      per_arr.append("SP")
                  }
              }
          }
          
          else {
              
              if click == 0 {
                  
                  if indexPath.row == 0 {
                      per_arr.removeAll(where: {$0 == "AU"})
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.removeAll(where: {$0 == "UU"})
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.removeAll(where: {$0 == "PU"})
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.removeAll(where: {$0 == "RU"})
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.removeAll(where: {$0 == "AB"})
                  }
                  
                  else {
                      per_arr.removeAll(where: {$0 == "DP"})
                  }
              }
              
              else {
                  
                  if indexPath.row == 0 {
                      per_arr.append("AU")
                  }
                  
                  else if indexPath.row == 1 {
                      per_arr.append("UU")
                  }
                  
                  else if indexPath.row == 2 {
                      per_arr.append("PU")
                  }
                  
                  else if indexPath.row == 3 {
                      per_arr.append("RU")
                  }
                  
                  else if indexPath.row == 4 {
                      per_arr.append("AB")
                  }
                  
                  else {
                      per_arr.append("DP")
                  }
              }
          }
      }
}

extension EmpSetupViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        return CGSize(width: width/2 - 10, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension EmpSetupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == pin  {
            if updatetext.count > 4 {
                updatetext = String(updatetext.dropLast())
            }
        }
        else if textField == numberBreakd {
            if updatetext.count > 2 {
                updatetext = String(updatetext.dropLast())
            }
        }
        else if textField == numberPaidBreaks {
            if updatetext.count > 2 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        else {
            if updatetext.count > 2 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        activeTextField.text = updatetext
    }
}

extension EmpSetupViewController {
    
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
        
        saveBtn.addSubview(loadIndicator)
        
        var center = 40
        if mode == "add" {
            center = 30
        }
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}
