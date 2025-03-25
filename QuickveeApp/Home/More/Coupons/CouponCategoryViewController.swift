//
//  CouponCategoryViewController.swift
//  
//
//  Created by Jamaluddin Syed on 30/07/24.
//

import UIKit
import MaterialComponents
import Alamofire
class CouponCategoryViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var showOnlineLbl: UILabel!
    @IBOutlet weak var showOnlineSwitch: UISwitch!
    
    @IBOutlet weak var categoryField: UIView!
    @IBOutlet weak var catLbl: UILabel!
    
    @IBOutlet weak var couponCodeTextField: MDCOutlinedTextField!
    @IBOutlet weak var minOrderAmtTextfield: MDCOutlinedTextField!
    @IBOutlet weak var descriptiontextfield: MDCOutlinedTextField!
    
    @IBOutlet weak var discountAmt: UILabel!
    @IBOutlet weak var discountAmtUnder: UIView!
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var discountpercentUnder: UIView!
    
    @IBOutlet weak var discountPercentTextfield: MDCOutlinedTextField!
    @IBOutlet weak var startEndStack: UIStackView!
    @IBOutlet weak var startDateTextField: MDCOutlinedTextField!
    @IBOutlet weak var endDateTextfield: MDCOutlinedTextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catcollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var maxdiscountTextField: MDCOutlinedTextField!
    @IBOutlet weak var maxdiscountHeight: NSLayoutConstraint!
    
    private var amountAsDouble : Double?
    var activeTextField = UITextField()
    private var isSymbolOnRight = false
    let formatter = NumberFormatter()
    
    var couponNameArray = [Coupon]()
    
    var closeClick = String()
    var catMode = ""
    var couponCategories = [InventoryCategory]()
    
    var setmode: Int?
    var editCouponcatdetails: CouponEdit?
    var id: String?
    var merchant_id: String?
    var category_Id = ""
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSwitch()
        formatter.maximumFractionDigits = 2
        
        let columnLayout = CustomFlowLayout()
        collectionView.collectionViewLayout = columnLayout
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cat_tap = UITapGestureRecognizer(target: self, action: #selector(openCat))
        categoryField.addGestureRecognizer(cat_tap)
        cat_tap.numberOfTapsRequired = 1
        categoryField.isUserInteractionEnabled = true
        
        let coll_tap = UITapGestureRecognizer(target: self, action: #selector(openCat))
        collectionView.addGestureRecognizer(coll_tap)
        coll_tap.numberOfTapsRequired = 1
        collectionView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(amtTap))
        discountAmt.addGestureRecognizer(tap)
        discountAmt.isUserInteractionEnabled = true
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(percentTap))
        discountPercentage.addGestureRecognizer(tapped)
        discountPercentage.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMode()
        setupUI()
        
        refreshCategoryColl()
    }
    
    func setupUI() {
        
        addBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        topview.addBottomShadow()
        
        couponCodeTextField.label.text = "Coupon Code"
        descriptiontextfield.label.text = "Description"
        minOrderAmtTextfield.label.text = "Min Order Amount"
        discountPercentTextfield.label.text = "Discount Amount($)"
        maxdiscountTextField.label.text = "Maximum Discount Amount ($)"
        
        
        startDateTextField.label.text = "Start Date"
        endDateTextfield.label.text = "End Date"
        
        createCustomTextField(textField: couponCodeTextField)
        createCustomTextField(textField: descriptiontextfield)
        createCustomTextField(textField: minOrderAmtTextfield)
        
        createCustomTextField(textField: discountPercentTextfield)
        createCustomTextField(textField: maxdiscountTextField)
        
        createCustomTextField(textField: startDateTextField)
        createCustomTextField(textField: endDateTextfield)
        
        couponCodeTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextfield.delegate = self
        discountPercentTextfield.delegate = self
        maxdiscountTextField.delegate = self
        
        minOrderAmtTextfield.keyboardType = .decimalPad
        
        discountPercentTextfield.keyboardType = .decimalPad
        maxdiscountTextField.keyboardType = .decimalPad
        
        couponCodeTextField.addTarget(self, action: #selector(updateTextCapsField), for: .editingChanged)
        minOrderAmtTextfield.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        discountPercentTextfield.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        maxdiscountTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        categoryField.layer.borderColor = UIColor.lightGray.cgColor
        categoryField.layer.borderWidth = 1.0
        categoryField.layer.cornerRadius = 5
        
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.cornerRadius = 5
        
    }
    
    func setupMode() {
        
        if setmode == 1 {
            addBtn.setTitle("Update", for: .normal)
            fillUpText()
        }
        else {
            
            addBtn.setTitle("Add", for: .normal)
            showOnlineSwitch.isOn = false
            
            discountAmtUnder.isHidden = false
            discountpercentUnder.isHidden = true
            maxdiscountTextField.isHidden = true
            maxdiscountHeight.constant = 0
        }
    }
    
    
    func setupSwitch() {
        
        showOnlineSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        showOnlineSwitch.addTarget(self, action: #selector(enableCouponOnline), for: .valueChanged)
        
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
        
        
        var dis_amount = ""
        var dis_percent = ""
        var max_disc_amt = ""
        
        var is_online = ""
        let enable_redemption = ""
        var flag = ""
        
        if checkOnlineCoupon() == "1" {
            is_online = "1"
        }
        else {
            is_online = "0"
        }
        
        var small = [String]()
        
        for cat in couponCategories {
            small.append(cat.id)
        }
        print(small)
        let catId = small.joined(separator: ",")
        
        
        guard couponCategories.count != 0 else {
            categoryField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: " Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let coupon_code = couponCodeTextField.text, coupon_code != "",
              checkNameDuplicate(name: coupon_code) else {
            couponCodeTextField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            couponCodeTextField.trailingView = button
            couponCodeTextField.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkCouponName), for: .touchUpInside)
            return
        }
        
        guard let desc = descriptiontextfield.text else {
            descriptiontextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let min_amt = minOrderAmtTextfield.text, min_amt != "" else {
            minOrderAmtTextfield.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            minOrderAmtTextfield.trailingView = button
            minOrderAmtTextfield.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkMinOrder), for: .touchUpInside)
            return
        }
        
        
        flag = checkdiscountSelection()
        
        if flag == "1" { //amt
            print(discountPercentTextfield.text)
            guard let dis_per = discountPercentTextfield.text, dis_per != "" else {
                discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                discountPercentTextfield.trailingView = button
                discountPercentTextfield.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                return
            }
            dis_percent = dis_per
            dis_amount = dis_per
            print(dis_amount)
        }
        
        else { //percent
            
            guard let dis_per = discountPercentTextfield.text, dis_per != "" else {
                discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                discountPercentTextfield.trailingView = button
                discountPercentTextfield.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                //showAlert(title: "", message: "")
                return
            }
            dis_percent = dis_per
            dis_amount = ""
            if dis_per == "100.00" {
                is_online = "0"
            }
            
            //max Discount
            
            guard let max_dis = maxdiscountTextField.text, max_dis != "" else {
                maxdiscountTextField.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                maxdiscountTextField.trailingView = button
                maxdiscountTextField.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkDiscountPercent), for: .touchUpInside)
                //showAlert(title: "", message: "")
                return
            }
            max_disc_amt = max_dis
            dis_amount = ""
        }
        
        
        
        if discountPercentTextfield.label.text == "Discount Amount($)" {
            
            let minAmt = NSDecimalNumber(string: minOrderAmtTextfield.text!)
            let disAmt = NSDecimalNumber(string: discountPercentTextfield.text!)
            
            
            if disAmt.compare(minAmt) == .orderedAscending {
                print("discount amount is less")
                createCustomTextField(textField: discountPercentTextfield)
            }
            
            else if disAmt.compare(minAmt) == .orderedSame {
                guard false else {
                    discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentTextfield.trailingView = button
                    discountPercentTextfield.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            
            else {
                guard false else {
                    discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentTextfield.trailingView = button
                    discountPercentTextfield.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            print("")
        }
        else if discountPercentTextfield.label.text == "Discount Percentage(%)"  {
            
            
            let minAmt = NSDecimalNumber(string: minOrderAmtTextfield.text!)
            let disAmt = NSDecimalNumber(string: discountPercentTextfield.text!)
            
            
            if disAmt.compare(minAmt) == .orderedAscending {
                print("discount amount is less")
                createCustomTextField(textField: discountPercentTextfield)
            }
            
            else if disAmt.compare(minAmt) == .orderedSame {
                guard false else {
                    discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentTextfield.trailingView = button
                    discountPercentTextfield.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            
            else {
                guard false else {
                    discountPercentTextfield.isError(numberOfShakes: 3, revert: true)
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    button.setImage(UIImage(named: "warning"), for: .normal)
                    discountPercentTextfield.trailingView = button
                    discountPercentTextfield.trailingViewMode = .always
                    button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                    return
                }
            }
            print("")
            
            guard false else {
                maxdiscountTextField.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                maxdiscountTextField.trailingView = button
                maxdiscountTextField.trailingViewMode = .always
                button.addTarget(self, action: #selector(checkMinAmtLess), for: .touchUpInside)
                return
                
            }
        }
        guard let start_date = startDateTextField.text, start_date != "" else {
            startDateTextField.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            startDateTextField.trailingView = button
            startDateTextField.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkStartDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid start date")
            return
        }
        
        guard let end_date = endDateTextfield.text, end_date != "" else {
            endDateTextfield.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            endDateTextfield.trailingView = button
            endDateTextfield.trailingViewMode = .always
            button.addTarget(self, action: #selector(checkEndDateValid), for: .touchUpInside)
            showAlert(title: "Alert", message: "Please enter valid end date")
            return
        }
        
        
        
        loadingIndicator.isAnimating = true
        print(dis_amount)
        if setmode == 1 {
            print(dis_amount)
            setupEditApi(is_online: is_online, coupon_code: coupon_code, desc: desc, min_amt: min_amt, enable_redemption: enable_redemption, redemption: "", flag: flag, dis_amt: max_disc_amt, dis_percent: dis_percent, start_date: start_date, end_date: end_date, start_time: "", end_time: "", id:  id ?? "", category_id: catId, coupon_type: "1", product_data: "")
            
            
        }
        else {
            setupApi(is_online: is_online, coupon_code: coupon_code, desc: desc, min_amt: min_amt, enable_redemption: enable_redemption, redemption: "", flag: flag, dis_amt: max_disc_amt, dis_percent: dis_percent, start_date: start_date, end_date: end_date, start_time: "", end_time: "", category_id: catId, coupon_type: "1", product_data: "")
            
        }
        
        
    }
    func setupEditApi(is_online: String, coupon_code: String, desc: String, min_amt: String, enable_redemption: String,
                      redemption: String, flag: String, dis_amt: String, dis_percent:String, start_date: String, end_date: String, start_time: String, end_time: String, id: String, category_id: String,coupon_type: String, product_data: String) {
        
        let url = AppURLs.EDIT_COUPON
        
        let parameters: [String:Any] = [
            "coupon_id": id,
            "merchant_id": merchant_id!,
            "is_online" : is_online, //0
            "coupon_code": coupon_code, //Test
            "description": desc, //
            "min_order_amount": min_amt,
            "enable_redemption_limit": enable_redemption, //0
            "redemption_limit": redemption, //
            "flag": flag, // 0
            "discount": dis_percent,
            "max_discount_amount": dis_amt,
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
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
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
    
    
    func setupApi(is_online: String, coupon_code: String, desc: String, min_amt: String, enable_redemption: String,
                  redemption: String, flag: String, dis_amt: String, dis_percent:String, start_date: String, end_date: String, start_time: String, end_time: String,category_id: String, coupon_type: String,product_data: String) {
        
        let url = AppURLs.ADD_COUPON
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id!,
            "is_online" : is_online, //0
            "coupon_code": coupon_code, //Test
            "description": desc, //
            "min_order_amount": min_amt,
            "enable_redemption_limit": enable_redemption, //0
            "redemption_limit": redemption, //
            "flag": flag, // 0
            "discount": dis_percent,
            "max_discount_amount": dis_amt,
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
                    self.loadingIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
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
    
    @objc func openCat() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateCouponSelected = self
        vc.catMode = "couponVc"
        vc.selectCategory = couponCategories
        vc.apiMode = "category"
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @IBAction func addbtnClick(_ sender: UIButton) {
        
        if setmode == 1 {
            validateParameters()
        }
        else {
            validateParameters()
        }
    }
    
    @IBAction func catcloseBtnClick(_ sender: UIButton) {
        
        let position = sender.tag
        couponCategories.remove(at: position)
        
        if couponCategories.count == 0 {
            refreshCategoryColl()
        }else {
            collectionView.reloadData()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func enableCouponOnline(enableSwitch: UISwitch) {
        view.endEditing(true)
        if discountAmtUnder.isHidden {
            
            if discountPercentTextfield.text == "100.00" {
                enableSwitch.isOn = false
                ToastClass.sharedToast.showToast(message: "Show Online is Disabled for 100% Coupon", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
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
    
    @objc func amtTap() {
        view.endEditing(true)
        if (discountPercentTextfield.text == "" || discountPercentTextfield.text == "0.00") {
            amtClick()
            
        }
        
        else {
            ToastClass.sharedToast.showToast(message: "Please clear the Discount Percentage", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
        }
    }
    
    func amtClick() {
        discountAmtUnder.isHidden = false
        discountpercentUnder.isHidden = true
        maxdiscountTextField.isHidden = true
        maxdiscountHeight.constant = 0
        
        discountPercentTextfield.text = ""
        discountPercentTextfield.label.text = "Discount Amount($)"
        createCustomTextField(textField: discountPercentTextfield)
    }
    
    
    @objc func percentTap() {
        view.endEditing(true)
        if discountPercentTextfield.text == "" || discountPercentTextfield.text == "0.00"  {
            percentClick()
        }
        
        else {
            ToastClass.sharedToast.showToast(message: "Please clear the Discount Amount first", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
            
        }
    }
    
    
    func percentClick() {
        discountAmtUnder.isHidden = true
        discountpercentUnder.isHidden = false
        maxdiscountTextField.isHidden = false
        maxdiscountHeight.constant = 50
        
        discountPercentTextfield.text = ""
        discountPercentTextfield.label.text = "Discount Percentage(%)"
        createCustomTextField(textField: discountPercentTextfield)
        discountPercentTextfield.trailingView?.isHidden = true
    }
    
    func refreshCategoryColl() {
        
        if couponCategories.count == 0 {
            collectionView.isHidden = true
            categoryField.isHidden = false
        }
        else {
            collectionView.isHidden = false
            categoryField.isHidden =  true
        }
        
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if height <= 53 {
            catcollHeight.constant = 53
        }
        else {
            catcollHeight.constant = height
        }
        scrollHeight.constant = 650 + catcollHeight.constant
        self.view.layoutIfNeeded()
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
    
    func fillUpText() {
        
        couponCodeTextField.text = editCouponcatdetails?.cc
        descriptiontextfield.text = editCouponcatdetails?.desc
        minOrderAmtTextfield.text = editCouponcatdetails?.min
        discountPercentTextfield.text = editCouponcatdetails?.dis_amount
        maxdiscountTextField.text = editCouponcatdetails?.max_dis
        
        startDateTextField.text = editCouponcatdetails?.start_date
        endDateTextfield.text = editCouponcatdetails?.end_date
        
        if editCouponcatdetails?.online == "1" {
            showOnlineSwitch.isOn = true
        }
        else {
            showOnlineSwitch.isOn = false
            
        }
        
        if editCouponcatdetails?.flag == "1" {
            discountAmtUnder.isHidden = false
            discountpercentUnder.isHidden = true
            maxdiscountTextField.isHidden = true
            maxdiscountHeight.constant = 0
            amtClick()
        }
        else {
            discountAmtUnder.isHidden = true
            discountpercentUnder.isHidden = false
            maxdiscountTextField.isHidden = false
            maxdiscountHeight.constant = 50
            percentClick()
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if activeTextField == startDateTextField || activeTextField == endDateTextfield {
            openDatePicker(textField: activeTextField, tag: activeTextField.tag)
        }
        
        else if activeTextField == discountPercentTextfield {
            print("yes")
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == discountPercentTextfield {
            
            if discountAmtUnder.isHidden {
                
                if discountPercentTextfield.text == "100.00" {
                    showOnlineSwitch.isOn = false
                    ToastClass.sharedToast.showToast(message: "Show Online is Disabled for 100% Coupon", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == couponCodeTextField {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
            
        }
        else {
            return true
        }
        
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            print(cleanedAmount)
            if character.isNumber {
                cleanedAmount.append(character)
            }
            print(cleanedAmount)
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        //Format the number based on number of decimal digits
        //ie. USD
        
        //        if Double(cleanedAmount) ?? 0.00 {
        
        if textField == minOrderAmtTextfield {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        else if textField == discountPercentTextfield {
            
            if textField.label.text == "Discount Amount($)" {
                if Double(cleanedAmount) ?? 0.00 > 99999999 {
                    cleanedAmount = String(cleanedAmount.dropLast())
                }
            }
            
            else {
                if Double(cleanedAmount) ?? 0.00 > 99999999 {
                    cleanedAmount = String(cleanedAmount.dropLast())
                }
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
        
        if textField == couponCodeTextField {
            
            if textField.text!.count == 12  {
                textField.text = String(textField.text!.dropLast())
            }
            
            else if textField.text!.count > 0 {
                createCustomTextField(textField: couponCodeTextField)
                couponCodeTextField.trailingView?.isHidden = true
                textField.text = textField.text?.uppercased()
            }
            
            else {
                textField.text = textField.text?.uppercased()
                
            }
        }
        
        else if textField == descriptiontextfield {
            
            if textField.text!.count == 51 {
                textField.text = String(textField.text!.dropLast())
            }
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
    
    func checkNameDuplicate(name: String) -> Bool {
        
        if couponNameArray.count == 0 {
            return true
        }
        
        else {
            
            if setmode == 0 {
                for i in 0...couponNameArray.count - 1 {
                    if couponNameArray[i].name == name.lowercased() {
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
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func checkOnlineCoupon() -> String {
        
        if showOnlineSwitch.isOn {
            return "1"
        }
        else {
            return "0"
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
    
    
    private func setUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        var center = 25
        if setmode == 1 {
            center = 35
        }
        
        addBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(center)),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

extension CouponCategoryViewController {
    
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
        dateFormat.dateFormat = "yyyy-MM-dd"
        
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
                    endDateTextfield.text = ""
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDateTextfield.text = ""
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        if startDateTextField.text == "" {
            showAlert(title: "Alert", message: "Please enter start date first")
        }
        else {
            let startDateCheck = dateFormat.date(from: startDateTextField.text!)
            
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
                    
                    else if endDay == startDay {
                        showAlert(title: "Alert", message: "End date should be greater than Start date")
                        
                    }
                    
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

extension CouponCategoryViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        couponCategories = categoryArray
        collectionView.reloadData()
        refreshCategoryColl()
    }
}


extension CouponCategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return couponCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CouponCategoryCell
        cell.catTitle.text = couponCategories[indexPath.row].title
        cell.catCloseBtn.setImage(UIImage(named: "white close"), for: .normal)
        cell.borderView.backgroundColor = .black
        
        
        cell.borderView.layer.cornerRadius = 5.0
        cell.catCloseBtn.tag = indexPath.row
        
        refreshCategoryColl()
        return cell
    }
}
