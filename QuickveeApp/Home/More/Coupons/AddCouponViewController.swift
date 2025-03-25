//
//  AddCouponViewController.swift
//
//
//  Created by Jamaluddin Syed on 08/03/23.
//

import UIKit
import MaterialComponents
import Alamofire

class AddCouponViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var showOnlineLabel: UILabel!
    @IBOutlet weak var showOnlineSwitch: UISwitch!
    @IBOutlet weak var couponCodeLabel: MDCOutlinedTextField!
    @IBOutlet weak var descLabel: MDCOutlinedTextField!
    @IBOutlet weak var minOrderLabel: MDCOutlinedTextField!
    @IBOutlet weak var enableRedemptionSwitch: UISwitch!
    @IBOutlet weak var enableRedemptionText: MDCOutlinedTextField!
    
    @IBOutlet weak var discountAmt: UILabel!
    @IBOutlet weak var discountPercent: UILabel!
    @IBOutlet weak var discountAmtUnder: UIView!
    @IBOutlet weak var discountPerUnder: UIView!
    
    @IBOutlet weak var enableLimit: UILabel!
    @IBOutlet weak var discountPercentText: MDCOutlinedTextField!
    @IBOutlet weak var startEndDate: UIStackView!
    
    @IBOutlet weak var startDateText: MDCOutlinedTextField!
    @IBOutlet weak var endDateText: MDCOutlinedTextField!
    @IBOutlet weak var redemptionSeparate: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var redemptionTextHeight: NSLayoutConstraint!
    @IBOutlet weak var enableRedemTextBottom: NSLayoutConstraint!
    @IBOutlet weak var enableRedeemTextTop: NSLayoutConstraint!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var maxDiscountTextField: MDCOutlinedTextField!
    @IBOutlet weak var maxDiscountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var maxDiscountBottom: NSLayoutConstraint!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var listOnlineSwitch: UISwitch!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    private var amountAsDouble : Double?
    var activeTextField = UITextField()
    private var isSymbolOnRight = false
    let formatter = NumberFormatter()
    
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
    
    var editCoupondetails: CouponEdit?
    var setmode: Int?
    var id: String?
    var merchant_id: String?
    
    var couponNameArray = [Coupon]()
    var mode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupSwitch()
        
        formatter.maximumFractionDigits = 2
        
        addBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        topview.addBottomShadow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(amtTap))
        discountAmt.addGestureRecognizer(tap)
        discountAmt.isUserInteractionEnabled = true
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(percentTap))
        discountPercent.addGestureRecognizer(tapped)
        discountPercent.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMode()
        setupUI()
    }
    
    
    func setupFields() {
        
        couponCodeLabel.label.text = "Coupon Code"
        descLabel.label.text = "Description"
        minOrderLabel.label.text = "Min Order Amount"
        enableRedemptionText.label.text = "Redemption Limit"
        discountPercentText.label.text = "Discount Amount($)"
        
        startDateText.label.text = "Start Date"
        endDateText.label.text = "End Date"
        maxDiscountTextField.label.text = "Maximum Discount Amount ($)"
        
        couponCodeLabel.delegate = self
        
        //couponCodeLabel.autocapitalizationType = .words
        descLabel.autocapitalizationType = .sentences
        
        createCustomTextField(textField: couponCodeLabel)
        createCustomTextField(textField: descLabel)
        createCustomTextField(textField: minOrderLabel)
        createCustomTextField(textField: enableRedemptionText)
        
        createCustomTextField(textField: discountPercentText)
        createCustomTextField(textField: startDateText)
        createCustomTextField(textField: endDateText)
        createCustomTextField(textField: maxDiscountTextField)
        
        
        deleteBtn.isHidden = false
        
        startDateText.delegate = self
        endDateText.delegate = self
        discountPercentText.delegate = self
        maxDiscountTextField.delegate = self
        
        minOrderLabel.keyboardType = .decimalPad
        enableRedemptionText.keyboardType = .decimalPad
        
        discountPercentText.keyboardType = .decimalPad
        maxDiscountTextField.keyboardType = .decimalPad
        
        couponCodeLabel.addTarget(self, action: #selector(updateTextCapsField), for: .editingChanged)
        enableRedemptionText.addTarget(self, action: #selector(updateTextCapsField), for: .editingChanged)
        minOrderLabel.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        discountPercentText.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        maxDiscountTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    func setupMode() {
      
        if setmode == 1 {
            
            addBtn.setTitle("Update", for: .normal)
            fillUpText()
            titleLbl.text = "Edit Coupon"
            deleteBtn.setImage(UIImage(named: "red_delete"), for: .normal)
            
        }
        
        else {
            
            addBtn.setTitle("Add", for: .normal)
            showOnlineSwitch.isOn = false
            listOnlineSwitch.isOn = false
            enableRedemptionSwitch.isOn = false
            enableRedemptionText.isHidden = true
            
            discountAmtUnder.isHidden = false
            maxDiscountTextField.isHidden = true
            maxDiscountHeight.constant = 0
            maxDiscountBottom.constant = 0
            discountPerUnder.isHidden = true
            discountPercentText.label.text = "Discount Amount($)"
            titleLbl.text = "Add Coupon"
            deleteBtn.setImage(UIImage(named: "home"), for: .normal)
            deleteBtn.backgroundColor = .black
        }
    }
  
    func setupSwitch() {
        
        showOnlineSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableRedemptionSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        listOnlineSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        showOnlineSwitch.addTarget(self, action: #selector(enableCouponOnline), for: .valueChanged)
        enableRedemptionSwitch.addTarget(self, action: #selector(enableRedemption), for: .valueChanged)
        listOnlineSwitch.addTarget(self, action: #selector(enableListOnline), for: .valueChanged)
        
    }
    
    @objc func checkCouponName() {
        
        showAlert(title: "Alert", message: "Please enter valid coupon name")
    }
    
    @objc func checkMinOrder() {
        
        showAlert(title: "Alert", message: "Please enter valid minimum order amount ")
    }
    
    @objc func checkRedemLbl() {
        showAlert(title: "Alert", message: "Please enter a valid redemption amount ")
    }
    
    @objc func checkDiscountPercent() {
        showAlert(title: "Alert", message: "Please enter a valid discount amount")
    }
    
    @objc func checkDiscountPercentage() {
        showAlert(title: "Alert", message: "Please enter a valid redemption amount ")
    }
    
    @objc func checkDiscountMaxPercent() {
        showAlert(title: "Alert", message: "Please enter a valid redemption amount ")
    }
    
    @objc func checkStartDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid start date")
    }
    
    @objc func checkEndDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid end date")
    }
    
    @objc func checkStartTimeValid() {
        showAlert(title: "Alert", message: "Please enter a valid start time")
    }
    
    @objc func checkEndTimeValid() {
        showAlert(title: "Alert", message: "Please enter a valid end time")
    }
    
    @objc func checkMinAmtLess() {
        showAlert(title: "Alert", message: "Discount amount cannot be greater than minimum amount")
    }
    
    func validateParameters() {
        
        var redemption = ""
        var dis_percent = ""
        var is_online = ""
        var list_online = ""
        var enable_redemption = ""
        var flag = ""
        var max_disc_amt = ""
        
        if checkOnlineCoupon() == "1" {
            is_online = "1"
        }
        else {
            is_online = "0"
        }
        
        if checkListOnline() == "1" {
            list_online = "1"
        }
        else {
            list_online = "0"
        }
        
        guard let coupon_code = couponCodeLabel.text, coupon_code != "",
              checkNameDuplicate(name: coupon_code) else {
            couponCodeLabel.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            couponCodeLabel.trailingView = button
            couponCodeLabel.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkCouponName), for: .touchUpInside)
            return
        }
        
        guard let desc = descLabel.text else {
            descLabel.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let min_amt = minOrderLabel.text, min_amt != "",  min_amt != "0.00" else {
            minOrderLabel.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            minOrderLabel.trailingView = button
            minOrderLabel.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkMinOrder), for: .touchUpInside)
            return
        }
        
        enable_redemption = checkRedemption()
        
        if enable_redemption == "1" {
            guard let enable_redeemText = enableRedemptionText.text, enable_redeemText != "" else {
                enableRedemptionText.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                enableRedemptionText.trailingView = button
                enableRedemptionText.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkRedemLbl), for: .touchUpInside)
                return
            }
            redemption = enable_redeemText
        }
        else {
            redemption = ""
        }
        
        flag = checkdiscountSelection()
        
        if flag == "1" { //amt
            
            guard let dis_amt = discountPercentText.text, dis_amt != "",  dis_amt != "0.00" else {
                discountPercentText.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                discountPercentText.trailingView = button
                discountPercentText.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                return
            }
            dis_percent = dis_amt
        }
        
        else { //percent
            
            guard let dis_per = discountPercentText.text, dis_per != "", dis_per != "0.00" else {
                discountPercentText.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                discountPercentText.trailingView = button
                discountPercentText.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                return
            }
            dis_percent = dis_per
            
            if dis_per == "100.00" {
                is_online = "0"
            }
            print(dis_percent)
        }
        
        if discountPercentText.label.text == "Discount Amount($)" {
            
            
            let minAmt = NSDecimalNumber(string: minOrderLabel.text!)
            let disAmt = NSDecimalNumber(string: discountPercentText.text!)
            
            
            if disAmt.compare(minAmt) == .orderedAscending {
                createCustomTextField(textField: discountPercentText)
            }
            
            else if disAmt.compare(minAmt) == .orderedSame {
                guard false else {
                    discountPercentText.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentText.trailingView = button
                    discountPercentText.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            
            else {
                guard false else {
                    discountPercentText.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentText.trailingView = button
                    discountPercentText.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            max_disc_amt = "0.00"
        }
        
        else if discountPercentText.label.text == "Discount Percentage(%)" {
            
            //            let minAmt = NSDecimalNumber(string: minOrderLabel.text!)
            //            let disAmt = NSDecimalNumber(string: discountPercentText.text!)
            //
            //
            //            if disAmt.compare(minAmt) == .orderedAscending {
            //                createCustomTextField(textField: discountPercentText)
            //            }
            //
            //            else if disAmt.compare(minAmt) == .orderedSame {
            //                guard false else {
            //                    discountPercentText.isError(numberOfShakes: 3, revert: true)
            //                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            //                    button.setImage(UIImage(named: "warning"), for: .normal)
            //                    discountPercentText.trailingView = button
            //                    discountPercentText.trailingViewMode = .always
            //                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
            //                    return
            //                }
            //            }
            //
            //            else {
            //                guard false else {
            //                    discountPercentText.isError(numberOfShakes: 3, revert: true)
            //                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            //                    button.setImage(UIImage(named: "warning"), for: .normal)
            //                    discountPercentText.trailingView = button
            //                    discountPercentText.trailingViewMode = .always
            //                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
            //                    return
            //                }
            //            }
            
            //max Discount
            
            if checkMaxDiscount(max: dis_percent) {
                
                guard let max_dis = maxDiscountTextField.text, max_dis != "" else {
                    maxDiscountTextField.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    maxDiscountTextField.trailingView = button
                    maxDiscountTextField.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
                max_disc_amt = max_dis
            }
            else {
                max_disc_amt = "0.00"
            }
        }
        
        guard let start_date = startDateText.text, start_date != "" else {
           
            startDateText.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            startDateText.trailingView = button
            startDateText.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkStartDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid start date")
            return
        }
        
        guard let end_date = endDateText.text, end_date != "" else {
            endDateText.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            endDateText.trailingView = button
            endDateText.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkEndDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid end date")
            return
        }
        
        loadIndicator.isAnimating = true
        
        if setmode == 1 {
            
            let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
            print(change_start_date)
            
            let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
            print(change_end_date)
            
            setupEditApi(is_online: is_online, list_online: list_online, id: id ?? "",
                         coupon_code: coupon_code, desc: desc,
                         min_amt: min_amt, enable_redemption: enable_redemption,
                         redemption: redemption, flag: flag,
                         max_dis: max_disc_amt, dis_percent: dis_percent,
                         start_date: change_start_date, end_date: change_end_date,
                         start_time: "", end_time: "",
                         category_id: "",coupon_type: "0", product_data: "")
        }
        else {
            print(start_date)
            print(end_date)
            
            let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: start_date)
            print(change_start_date)
            
            let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: end_date)
            print(change_end_date)
            
            setupApi(is_online: is_online, list_online: list_online, coupon_code: coupon_code,
                     desc: desc, min_amt: min_amt,
                     enable_redemption: enable_redemption,
                     redemption: redemption, flag: flag,
                     max_dis: max_disc_amt, dis_percent: dis_percent,
                     start_date: change_start_date, end_date: change_end_date,
                     start_time: "", end_time: "",
                     category_id: "", coupon_type: "0", product_data: "")
        }
    }
    
    func setupEditApi(is_online: String, list_online: String, id: String, coupon_code: String, 
                      desc: String, min_amt: String, enable_redemption: String,
                      redemption: String, flag: String, max_dis: String, dis_percent:String, 
                      start_date: String, end_date: String, start_time: String, end_time: String,
                      category_id: String,coupon_type: String, product_data: String) {
        
        let url = AppURLs.EDIT_COUPON
        
        let parameters: [String:Any] = [
            "coupon_id": id,
            "merchant_id": merchant_id!,
            "is_online" : is_online, //0
            "list_online": list_online,
            "coupon_code": coupon_code, //Test
            "description": desc, //
            "min_order_amount": min_amt,
            "enable_redemption_limit": enable_redemption, //0
            "redemption_limit": redemption, //
            "flag": flag, // 0
            "discount": dis_percent,
            "max_discount_amount": max_dis,
            "start_date": start_date,
            "end_date": end_date,
            "start_time": start_time,
            "end_time": end_time,
            "category_id": category_id,
            "coupon_type": coupon_type,
            "product_data": product_data
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.loadIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.goBack()
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func setupApi(is_online: String, list_online: String, coupon_code: String, desc: String, 
                  min_amt: String, enable_redemption: String, redemption: String,
                  flag: String, max_dis: String, dis_percent:String, start_date: String,
                  end_date: String, start_time: String, end_time: String,
                  category_id: String, coupon_type: String, product_data: String) {
        
        let url = AppURLs.ADD_COUPON
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
            "is_online" : is_online, //0
            "list_online": list_online,
            "coupon_code": coupon_code, //Test
            "description": desc, //
            "min_order_amount": min_amt,
            "enable_redemption_limit": enable_redemption, //0
            "redemption_limit": redemption, //
            "flag": flag, // 0
            "discount": dis_percent,
            "max_discount_amount": max_dis,
            "start_date": start_date,
            "end_date": end_date,
            "start_time": start_time,
            "end_time": end_time,
            "category_id": category_id,
            "coupon_type": coupon_type,
            "product_data": product_data
        ]
         
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.loadIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    
                    var destiny = 0
                    let viewcontrollerArray = self.navigationController?.viewControllers
                    if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is CouponViewController }) {
                        destiny = destinationIndex
                    }
                    
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                    //self.goBack()
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    @objc func enableCouponOnline(enableSwitch: UISwitch) {
        view.endEditing(true)
        
        if discountAmtUnder.isHidden {
            
            if discountPercentText.text == "100.00" {
                
                enableSwitch.isOn = false
                ToastClass.sharedToast.showToast(message: "Show Online is Disabled for 100% Coupon",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                
                if enableSwitch.isOn {
                    enableSwitch.isOn = true
                }
                else {
                    enableSwitch.isOn = false
                }
            }
        }
        
        else {
            
            if enableSwitch.isOn {
                enableSwitch.isOn = true
            }
            else {
                enableSwitch.isOn = false
            }
        }
    }
    
    @objc func enableListOnline(enableSwitch: UISwitch) {
        view.endEditing(true)
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
        }
        else {
            enableSwitch.isOn = false
        }
    }
    
    @objc func enableRedemption(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            enableRedemptionText.isHidden = false
            redemptionTextHeight.constant = 52.66
            scrollHeight.constant += 52.66
        }
        else {
            enableSwitch.isOn = false
            enableRedemptionText.isHidden = true
            redemptionTextHeight.constant = 0
            scrollHeight.constant -= 52.66
        }
    }
    
    @objc func amtTap() {
        view.endEditing(true)
        if (discountPercentText.text == "" || discountPercentText.text == "0.00") {
            amtClick()
        }
        else {
            showTapToast(message: " Please clear the Discount Percentage", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!, type: 1)
        }
    }
    
    func amtClick() {
        
        discountAmtUnder.isHidden = false
        discountPerUnder.isHidden = true
        discountPercentText.label.text = "Discount Amount($)"
        maxDiscountBottom.constant = 0
        
        createCustomTextField(textField: discountPercentText)
        maxDiscountTextField.isHidden = true
        maxDiscountHeight.constant = 0
    }
    
    @objc func percentTap() {
        
        view.endEditing(true)
        if discountPercentText.text == "" || discountPercentText.text == "0.00"  {
            percentClick()
            maxDiscountTextField.isHidden = false
            maxDiscountHeight.constant = 50
            maxDiscountBottom.constant = 20
            discountPercentText.label.text = "Discount Percentage(%)"
            discountPercentText.keyboardType = .numberPad
            // discountPercentText.addTarget(self, action: #selector(updateText), for: .editingChanged)
        }
        else {
            showTapToast(message: " Please clear the Discount Amount first", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!, type: 0)
        }
    }
   
    func percentClick() {
        
        discountAmtUnder.isHidden = true
        discountPerUnder.isHidden = false
        
        if discountPercentText.text == "100.00" {
            maxDiscountTextField.isHidden = true
            maxDiscountHeight.constant = 0
            maxDiscountBottom.constant = 0
        }
        else {
            maxDiscountTextField.isHidden = false
            maxDiscountHeight.constant = 50
            maxDiscountBottom.constant = 20
        }
        
        createCustomTextField(textField: discountPercentText)
        discountPercentText.trailingView?.isHidden = true
        discountPercentText.label.text = "Discount Percentage(%)"
    }
    
    func fillUpText() {
        
        couponCodeLabel.text = editCoupondetails?.cc
        descLabel.text = editCoupondetails?.desc
        minOrderLabel.text = editCoupondetails?.min
        enableRedemptionText.text = editCoupondetails?.redem_text
        
        discountPercentText.text = editCoupondetails?.dis_amount
        maxDiscountTextField.text = editCoupondetails?.max_dis
        
        
        let start_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: editCoupondetails?.start_date ?? "")
   
        startDateText.text = start_date
      
        let end_date = ToastClass.sharedToast.setCouponsDateFormat(dateStr: editCoupondetails?.end_date ?? "")
      
        endDateText.text = end_date
       
        if editCoupondetails?.online == "1" {
            showOnlineSwitch.isOn = true
        }
        else {
            showOnlineSwitch.isOn = false
        }
        
        if editCoupondetails?.list_online == "1" {
            listOnlineSwitch.isOn = true
        }
        else {
            listOnlineSwitch.isOn = false
        }
        
        if editCoupondetails?.redem == "1" {
            enableRedemptionSwitch.isOn = true
            enableRedemptionText.isHidden = false
            redemptionTextHeight.constant = 52.66
            scrollHeight.constant += 52.66
        }
        else {
            enableRedemptionSwitch.isOn = false
            enableRedemptionText.isHidden = true
            redemptionTextHeight.constant = 0
            //            scrollHeight.constant -= 52.66
        }
        
        if editCoupondetails?.flag == "1" {
            discountAmtUnder.isHidden = false
            discountPerUnder.isHidden = true
            maxDiscountTextField.isHidden = true
            amtClick()
        }
        else {
            discountAmtUnder.isHidden = true
            discountPerUnder.isHidden = false
            percentClick()
        }
    }
    
    func checkOnlineCoupon() -> String {
        
        if showOnlineSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkListOnline() -> String {
        
        if listOnlineSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkRedemption() -> String {
        
        if enableRedemptionSwitch.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func checkdiscountSelection() -> String {
        
        if discountAmtUnder.isHidden {
            return "0"
        }
        else {
            return "1"
        }
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == discountPercentText {
            if updatetext.count > 2 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
    }
    
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        //Format the number based on number of decimal digits
        //ie. USD
        
        //        if Double(cleanedAmount) ?? 0.00 {
        
        if textField == minOrderLabel {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else if textField == maxDiscountTextField {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else if textField == discountPercentText {
            
            if textField.label.text == "Discount Amount($)" {
                if Double(cleanedAmount) ?? 0.00 > 99999999 {
                    cleanedAmount = String(cleanedAmount.dropLast())
                }
            }
            
            else if textField.label.text == "Discount Percentage(%)" {
                if Double(cleanedAmount) ?? 0.00 > 10000 {
                    cleanedAmount = String(cleanedAmount.dropLast())
                }
                //   if cleanedAmount.count > 3 {
                //                    cleanedAmount = String(cleanedAmount.dropLast())
                //                }
            }
        }
     
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        //        if textField.text == "0.00" {
        //            textField.text = "0.00"
        //        }
    }
  
    @objc func updateTextCapsField(textField: MDCOutlinedTextField) {
        
        if textField == couponCodeLabel {
            
            if textField.text!.count == 12  {
                textField.text = String(textField.text!.dropLast())
            }
            
            else if textField.text!.count > 0 {
                createCustomTextField(textField: couponCodeLabel)
                couponCodeLabel.trailingView?.isHidden = true
                textField.text = textField.text?.uppercased()
            }
            
            else {
                textField.text = textField.text?.uppercased()
                
            }
        }
        
        else if textField == descLabel {
            
            if textField.text!.count == 51 {
                textField.text = String(textField.text!.dropLast())
            }
        }
        
        else if textField == enableRedemptionText {
            
            if textField.text?.count == 4 {
                textField.text = String(textField.text!.dropLast())
            }
        }
        
    }
    
    func checkNameDuplicate(name: String) -> Bool {
        
        if couponNameArray.count == 0 {
            return true
        }
        
        else {
            
            if setmode == 0 {
                for i in 0...couponNameArray.count - 1 {
                    if couponNameArray[i].name.lowercased() == name.lowercased() {
                        return false
                    }
                }
                return true
            }
            else {
                for i in 0...couponNameArray.count - 1 {
                    
                    if couponNameArray[i].name.lowercased() == name.lowercased() {
                        
                        if couponNameArray[i].id == id {
                            return true
                        }
                        return false
                    }
                }
                return true
            }
        }
    }
  
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showTapToast(message : String, font: UIFont, type : Int) {
        
        let toastButton = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-160, width: 250, height: 40))
        toastButton.text = message
        toastButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastButton.textColor = .white
        toastButton.font = font
        if type == 1 {
            toastButton.numberOfLines = 0
        }
        
        else {
            toastButton.numberOfLines = 1
        }
        
        toastButton.textAlignment = .center
        toastButton.alpha = 1.0
        toastButton.layer.cornerRadius = 10
        toastButton.clipsToBounds  =  true
        self.view.addSubview(toastButton)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastButton.alpha = 0.0
        }, completion: {(isCompleted) in
            toastButton.removeFromSuperview()
        })
    }
    
    
    func showDeleteAlert(id: String) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this coupon?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            self.setupDeleteApi(id: id)
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func setupDeleteApi(id: String) {
        
        let url = AppURLs.COUPON_DELETE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id!,
            "coupon_id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    self.navigationController?.popViewController(animated: true)
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
 
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if setmode == 1 {
            if UserDefaults.standard.bool(forKey: "lock_delete_coupon") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                
                let del_id = id ?? ""
                showDeleteAlert(id: del_id)
            }
            
        }
        else {
            let viewcontrollerArray = navigationController?.viewControllers
            var destiny = 0
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
    }
   
    @IBAction func backBtnClick(_ sender: UIButton) {
        var destiny = 0
        
        let viewcontrollerArray = self.navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is CouponViewController }) {
            destiny = destinationIndex
        }
        
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        //goBack()
    }
  
    @IBAction func addBtnClick(_ sender: UIButton) {
        validateParameters()
    }
   
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        goBack()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if activeTextField == startDateText || activeTextField == endDateText {
            openDatePicker(textField: activeTextField, tag: activeTextField.tag)
        }
        else if activeTextField == discountPercentText {
            print("yes")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == discountPercentText {
            
            if discountAmtUnder.isHidden {
                
                if discountPercentText.text == "100.00" {
                    
                    showOnlineSwitch.isOn = false
                    ToastClass.sharedToast.showToast(message: "Show Online is Disabled for 100% Coupon", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    maxDiscountTextField.isHidden = true
                    maxDiscountHeight.constant = 0
                    maxDiscountBottom.constant = 0
                }
                else {
                    maxDiscountTextField.isHidden = false
                    maxDiscountHeight.constant = 50
                    maxDiscountBottom.constant = 20
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == couponCodeLabel {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        else {
            return true
        }
    }
    
    func checkMaxDiscount(max: String) -> Bool {
        
        let max_doub = Double(max) ?? 0.00
        
        if max_doub < 100.00 {
            return true
        }
        return false
    }
}


extension AddCouponViewController {
    
    
    func openDatePicker(textField: UITextField, tag: Int) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if tag < 3 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancel(textfield: UITextField) {
        
        activeTextField.resignFirstResponder()
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker {
            if activeTextField.tag == 1 {
                checkStartDate(date: datePicker.date)
            }
            else {
                checkEndDate(date: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
        
    }
    
    
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
  
    
    func checkStartDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        let calendar = Calendar.current
        let dateToday = Date()
        let currentDay = calendar.component(.day, from: dateToday)
        let currentMonth = calendar.component(.month, from: dateToday)
        let currentYear = calendar.component(.year, from: dateToday)
        
        let startDay = calendar.component(.day, from: date)
        let startMonth = calendar.component(.month, from: date)
        let startYear = calendar.component(.year, from: date)
        
        if startYear < currentYear {
            
            showAlert(title: "Alert", message: "Start date should be greater than current date")
        }
        
        else if startYear == currentYear {
            
            if startMonth < currentMonth {
                
                showAlert(title: "Alert", message: "Start date should be greater than current date")
            }
            
            else if startMonth >= currentMonth {
                
                if startDay < currentDay {
                    
                    showAlert(title: "Alert", message: "Start date should be greater than current date")
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    endDateText.text = ""
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDateText.text = ""
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        if startDateText.text == "" {
            showAlert(title: "Alert", message: "Please enter start date first")
        }
        else {
            let startDateCheck = dateFormat.date(from: startDateText.text!)
            
            let calendar = Calendar.current
            
            let startDay = calendar.component(.day, from: startDateCheck!)
            let startMonth = calendar.component(.month, from: startDateCheck!)
            let startYear = calendar.component(.year, from: startDateCheck!)
            
            let endDay = calendar.component(.day, from: date)
            let endMonth = calendar.component(.month, from: date)
            let endYear = calendar.component(.year, from: date)
            
            if endYear < startYear {
                
                showAlert(title: "Alert", message: "")
            }
            
            else if endYear == startYear {
                
                if endMonth < startMonth {
                    
                    showAlert(title: "Alert", message: "End date should be greater than Start date")
                }
                
                else if endMonth == startMonth {
                    
                    if endDay < startDay {
                        
                        showAlert(title: "Alert", message: "End date should be greater than Start date")
                    }
                    
//                    else if endDay == startDay {
//                        showAlert(title: "Alert", message: "End date should be greater than Start date")
//                        
//                    }
                    
                    else {
                        activeTextField.text = dateFormat.string(from: date)
                    }
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
            }
        }
        
    }
}

extension AddCouponViewController {
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(.black, for: .normal)
        textField.setFloatingLabelColor(.black, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        var center = 25
        if setmode == 1 {
            center = 35
        }
        
        addBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}
