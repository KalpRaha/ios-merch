//
//  StoreSetupViewController.swift
//  
//
//  Created by Jamaluddin Syed on 23/02/23.
//

import UIKit
import MaterialComponents
import Alamofire
import DropDown

class StoreSetupViewController: UIViewController {
    
    
    @IBOutlet weak var onlineOrderSwitch: UISwitch!
    @IBOutlet weak var enablePickSwitch: UISwitch!
    @IBOutlet weak var enableDelSwitch: UISwitch!
    @IBOutlet weak var enableTip: UISwitch!

    @IBOutlet weak var minAmt: MDCOutlinedTextField!
    @IBOutlet weak var delRadius: MDCOutlinedTextField!
    @IBOutlet weak var minDelFee: MDCOutlinedTextField!
    @IBOutlet weak var delRateMile: MDCOutlinedTextField!
    @IBOutlet weak var minPickTime: MDCOutlinedTextField!
    @IBOutlet weak var maxPickTime: MDCOutlinedTextField!
    @IBOutlet weak var minDelTime: MDCOutlinedTextField!
    @IBOutlet weak var maxDelTime: MDCOutlinedTextField!
    @IBOutlet weak var delConFee: MDCOutlinedTextField!
    @IBOutlet weak var pickConFee: MDCOutlinedTextField!
    
    @IBOutlet weak var updateBtm: UIButton!
    
    @IBOutlet weak var defTipPick: MDCOutlinedTextField!
    @IBOutlet weak var defTipDel: MDCOutlinedTextField!
    @IBOutlet weak var busHours: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tapView: UIView!
    
    @IBOutlet weak var scrollheight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var flatDeliFee: UIButton!
    @IBOutlet weak var perMileFee: UIButton!
    @IBOutlet weak var delRateHeight: NSLayoutConstraint!
    @IBOutlet weak var tipDelBtn: UIButton!
    @IBOutlet weak var tipPickBtn: UIButton!
    @IBOutlet weak var delCheck: UIButton!
    @IBOutlet weak var pickCheck: UIButton!
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var storeSetupLabel: UILabel!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    private var amountAsDouble : Double?
    private var isSymbolOnRight = false
    
    let pickup_menu = DropDown()
    let del_menu = DropDown()
    
    let tip_for_pickup = ["None", "10%", "15%", "20%", "25%"]
    let tip_for_del = ["None", "10%", "15%", "20%", "25%"]
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let formatter = NumberFormatter()
    
    var setup: StoreSetup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupMenus()
        setupSwitch()
        
        print(setup!)
        //StoreSetup(offline: "1", max_delivery_radius: "0.00", min_delivery_amt: "0.0", flag: "0", delivery_fee: "0.0", rate_per_miles: "",
        //is_pickup: "Yes", pickup_min_time: "", pickup_max_time: "", is_deliver: "No", deliver_min_time: "", deliver_max_time: "",
        //cfee_pik: "0", cfee_pik_price: "0", cfee_del: "0", cfee_del_price: "", enable_tip: "0", default_tip_p: "0", default_tip_d: "0")
        
        formatter.maximumFractionDigits = 2
        
        updateBtm.layer.cornerRadius = 10
        
        topView.addBottomShadow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toBusiness(_:)))
        tap.numberOfTapsRequired = 1
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(tap)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        defTipPick.trailingView = imageView
        
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageview.image = UIImage(named: "down")
        defTipDel.trailingView = imageview
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()

        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            storeSetupLabel.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            storeSetupLabel.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        
    }
    
    func setupFields() {
        
        minAmt.label.text = "Min Amount for Delivery (\u{0024})"
        delRadius.label.text = "Delivery Radius (miles)"
        minDelFee.label.text = "Delivery Fee (\u{0024})"
        delRateMile.label.text = "Delivery rate per miles (\u{0024})"
        minPickTime.label.text = "Min"
        maxPickTime.label.text = "Max"
        minDelTime.label.text = "Min"
        maxDelTime.label.text = "Max"
        delConFee.label.text = "Delivery convenience fee"
        pickConFee.label.text = "Pickup Convenience fee"
        defTipPick.label.text = "Default Tip for Pickup"
        defTipDel.label.text = "Default Tip for Delivery"
        
        onlineOrderSwitch.isOn = checkOnlineOrderSwitch()
        minAmt.text = setup?.min_delivery_amt
        delRadius.text = setup?.max_delivery_radius
        
        minDelFee.text = setup?.delivery_fee
        delRateMile.text = setup?.rate_per_miles
        minPickTime.text = setup?.pickup_min_time
        maxPickTime.text = setup?.pickup_max_time
        minDelTime.text = setup?.deliver_min_time
        maxDelTime.text = setup?.deliver_max_time
                
        delConFee.text = setup?.cfee_del_price
        
        if setup?.cfee_pik_price == "0" {
            pickConFee.text = ""
        }
        else {
            pickConFee.text = setup?.cfee_pik_price
        }
        
        if setup?.default_tip_d == "0" {
            defTipDel.text = "None"
        }
        else {
            defTipDel.text = "\(setup!.default_tip_d)%"
        }
        
        if setup?.default_tip_p == "0" {
            defTipPick.text = "None"
        }
        else {
            defTipPick.text = "\(setup!.default_tip_p)%"
        }
            
        enablePickSwitch.isOn = checkPickSwitch()
        enablePickSwitch.isUserInteractionEnabled = true
        
        checkFloatFee()

        
        enableDelSwitch.isOn = checkDelSwitch()
        checkFieldsDel()
        
        checkcFeePick()
        checkcFeeDel()
        
        enableTip.isOn = checkEnableTipSwitch()
        checkFieldsTip()
        
        minAmt.keyboardType = .decimalPad
        delRadius.keyboardType = .decimalPad
        minDelFee.keyboardType = .decimalPad
        delRateMile.keyboardType = .decimalPad
        minPickTime.keyboardType = .numberPad
        maxPickTime.keyboardType = .numberPad
        minDelTime.keyboardType = .numberPad
        maxDelTime.keyboardType = .numberPad
        delConFee.keyboardType = .decimalPad
        pickConFee.keyboardType = .decimalPad
        
        minDelFee.label.text = "Delivery Fee (\u{0024})"
        delRateMile.label.text = "Delivery rate per miles (\u{0024})"
        minPickTime.label.text = "Min"
        maxPickTime.label.text = "Max"
        minDelTime.label.text = "Min"
        maxDelTime.label.text = "Max"
        delConFee.label.text = "Delivery convenience fee"
        pickConFee.label.text = "Pickup Convenience fee"
        defTipPick.label.text = "Default Tip for Pickup"
        defTipDel.label.text = "Default Tip for Delivery"
        
        createCustomTextField(textField: minAmt)
        createCustomTextField(textField: delRadius)
        createCustomTextField(textField: minDelFee)
        createCustomTextField(textField: delRateMile)
        createCustomTextField(textField: minPickTime)
        createCustomTextField(textField: maxPickTime)
        createCustomTextField(textField: minDelTime)
        createCustomTextField(textField: maxDelTime)
        createCustomTextField(textField: delConFee)
        createCustomTextField(textField: pickConFee)
        createCustomTextField(textField: defTipPick)
        createCustomTextField(textField: defTipDel)
        
        minAmt.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        delRadius.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        minDelFee.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        delRateMile.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        delConFee.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        pickConFee.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        minDelTime.addTarget(self, action: #selector(updateLimitTextField), for: .editingChanged)
        minPickTime.addTarget(self, action: #selector(updateLimitTextField), for: .editingChanged)
        maxDelTime.addTarget(self, action: #selector(updateLimitTextField), for: .editingChanged)
        maxPickTime.addTarget(self, action: #selector(updateLimitTextField), for: .editingChanged)
    }
    
    func setupMenus() {
        
        pickup_menu.dataSource = tip_for_pickup
        pickup_menu.anchorView = tipPickBtn
        pickup_menu.backgroundColor = .white
        
        pickup_menu.selectionAction = { index, title in
            self.pickup_menu.deselectRow(at: index)
            self.defTipPick.text = title
        }
        
        del_menu.dataSource = tip_for_del
        del_menu.anchorView = tipDelBtn
        del_menu.backgroundColor = .white
        
        del_menu.selectionAction = { index, title in
            self.del_menu.deselectRow(at: index)
            self.defTipDel.text = title
            
        }
    }
    
    func setupSwitch() {
        
        onlineOrderSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableDelSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enablePickSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableTip.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        onlineOrderSwitch.addTarget(self, action: #selector(onlineOrderSwitchAction), for: .valueChanged)
        enableDelSwitch.addTarget(self, action: #selector(delSwitchAction), for: .valueChanged)
        enablePickSwitch.addTarget(self, action: #selector(pickSwitchAction), for: .valueChanged)
        enableTip.addTarget(self, action: #selector(tipSwitchAction), for: .valueChanged)
    }
    
    @objc func minPickEdit() {
//        showAlert(title: "Alert", message: "Minimum Pick up time cannot be blank")
    }
    
    @objc func maxPickEdit() {
//        showAlert(title: "Alert", message: "Maximum pick up time cannot be blank")

    }
    
    @objc func minDelEdit() {
//        showAlert(title: "Alert", message: "Minimum delivery time cannot be blank")
    }
    
    @objc func maxDelEdit() {
//        showAlert(title: "Alert", message: "Maximum delivery time cannot be blank")

    }
    
    @objc func delConEdit() {
//        showAlert(title: "Alert", message: "Delivery Convenience fee cannot be blank")
    }
    
    @objc func pickConEdit() {
//        showAlert(title: "Alert", message: "Pick up Convenience fee cannot be blank")
    }
    
    func validateParameters() {
        
        let merch_id = setup?.merchant_id
        let offline = checkOnlineParams()   //0
        
        // MIN AMT AND RADIUS
        
        guard let del_amnt = minAmt.text else {
            return
        }
        
        guard let del_radius = delRadius.text else {
            return
        }
        
        let del_amt = del_amnt //50.00
        let del_rad = del_radius //60.00
        
        //FLAT DEL FEE AND DEL RATE
        
        let f_fee = checkFloatFeeParams() //0
        print(f_fee)
        var del_fee = ""
        var del_rate_mile = ""
        
        if f_fee == "1" {
            del_fee = minDelFee.text ?? ""
            del_rate_mile = delRateMile.text ?? ""
        }
        else {
            del_fee = minDelFee.text ?? ""
            del_rate_mile = ""
        }
        
        // ENABLE PICKUP
        
        var is_pick = checkPickParams()
        var minPick = ""
        var maxPick = ""
        
        if is_pick == "Yes" {
            
            guard let min_pick = minPickTime.text, min_pick != "" else {
                showAlert(title: "Alert", message: "Minimum Pick up time cannot be blank")
                minPickTime.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                minPickTime.trailingView = button
                minPickTime.trailingViewMode = .always
                button.addTarget(self, action: #selector(minPickEdit), for: .touchUpInside)
                return
            }
            
            guard let max_pick = maxPickTime.text, max_pick != "" else {
                showAlert(title: "Alert", message: "Maximum Pick up time cannot be blank")
                maxPickTime.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                maxPickTime.trailingView = button
                maxPickTime.trailingViewMode = .always
                button.addTarget(self, action: #selector(maxPickEdit), for: .touchUpInside)
                return
            }
        
        let intMax = Int(max_pick)
        let intMin = Int(min_pick)
 
        guard intMax! > intMin! else {
            showAlert(title: "Alert", message: "Minimum pick up time must be less than maximum pick up time.")
            return
        }
        
        let min_pik = min_pick
        let max_pik = max_pick //40
            
            minPick = min_pik //45
            maxPick = max_pik //55
        }
        
        else {
            minPick = ""
            maxPick = ""
        }
        
        // ENABLE DELIVERY
        
        let is_del = checkDelParams() // yes
        var minDel = ""
        var maxDel = ""
        
        if is_del == "Yes" {
            
            guard let min_del = minDelTime.text, min_del != "" else {
                showAlert(title: "Alert", message: "Minimum delivery time cannot be blank")
                minDelTime.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                minDelTime.trailingView = button
                minDelTime.trailingViewMode = .always
                button.addTarget(self, action: #selector(minDelEdit), for: .touchUpInside)
                return
            }
            
            guard let max_del = maxDelTime.text, max_del != "" else {
                showAlert(title: "Alert", message: "Maximum delivery time cannot be blank")
                maxDelTime.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                maxDelTime.trailingView = button
                maxDelTime.trailingViewMode = .always
                button.addTarget(self, action: #selector(maxDelEdit), for: .touchUpInside)
                return
            }
            
            let intMaxDel = Int(max_del)
            let intMinDel = Int(min_del)
            
            guard intMaxDel! > intMinDel! else {
                showAlert(title: "Alert", message: "Minimum delivery time must be less than maximum delivery time")
                return
            }
            
        
            minDel = min_del //45
            maxDel = max_del //55
        }
        
        else {
            minDel = ""
            maxDel = ""
        }
        
        // CONVENIENCE FEE
        
        let cf_del = checkcFeeDelParams() //1
        var cfDelPrice = ""
        
        if cf_del == "1" {
            guard let cf_del_price = delConFee.text, cf_del_price != "" else {
                showAlert(title: "Alert", message: "Delivery Convenience fee cannot be blank")
                delConFee.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                delConFee.trailingView = button
                delConFee.trailingViewMode = .always
                button.addTarget(self, action: #selector(delConEdit), for: .touchUpInside)
                return
            }
            cfDelPrice = cf_del_price //2.00
        }
        else {
            cfDelPrice = ""
        }
        
        let cf_pik = checkcFeePickParams() //1
        var cfPickPrice = ""
        
        if cf_pik == "1" {
            guard let cf_pik_price = pickConFee.text, cf_pik_price != "" else {
                showAlert(title: "Alert", message: "Pick up Convenience fee cannot be blank")
                pickConFee.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                pickConFee.trailingView = button
                pickConFee.trailingViewMode = .always
                button.addTarget(self, action: #selector(pickConEdit), for: .touchUpInside)
                return
            } //1.00
            cfPickPrice = cf_pik_price
        }
        else {
            cfPickPrice =  ""
        }
        
        // TIP
        
        let enable_tip = tipParams()//1
        var def_tip_d = ""
        var def_tip_p = ""
        if enable_tip == "1" {
            def_tip_d = defTipDel.text ?? ""//20
            def_tip_p = defTipPick.text ?? ""
            
        }
        else {
            def_tip_d = defTipDel.text ?? ""
            def_tip_p = defTipPick.text ?? ""
        }
        
        loadingIndicator.isAnimating = true
        
        setupApi(merchant_id: merch_id!, offline: offline, min_del_amt: del_amt, del_rad: del_rad,
                 f_fee: f_fee, del_fee: del_fee, del_rate_mile: del_rate_mile, is_pickup: is_pick,
                 min_pik: minPick, max_pik: maxPick,
                 is_del: is_del, min_del: minDel, max_del: maxDel,
                 cf_del: cf_del, cf_pik: cf_pik, cf_del_price: cfDelPrice, cf_pik_price: cfPickPrice,
                 enable_tip: enable_tip, def_tip_d: def_tip_d, def_tip_p: def_tip_p)
    }
    
    
    func setupApi(merchant_id: String, offline: String, min_del_amt: String, del_rad: String,
                  f_fee: String, del_fee: String, del_rate_mile: String, is_pickup: String,
                  min_pik: String, max_pik: String,
                  is_del: String, min_del: String, max_del: String,
                  cf_del: String, cf_pik: String, cf_del_price: String, cf_pik_price: String,
                  enable_tip: String, def_tip_d: String, def_tip_p: String) {
        
        let url = AppURLs.UPDATE_STORE_SETUP

        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "offline": offline,
            "min_delivery_amt": min_del_amt,
            "max_delivery_radius":del_rad,
            "float_fee":f_fee,
            "delivery_fee":del_fee,
            "rate_per_miles":del_rate_mile,
            "is_deliver":is_del,
            "is_pickup": is_pickup,
            "pickup_min_time":min_pik,
            "pickup_max_time":max_pik,
            "deliver_min_time":min_del,
            "deliver_max_time":max_del,
            "cf_del":cf_del,
            "cf_pik":cf_pik,
            "cf_del_price":cf_del_price,
            "cf_pik_price":cf_pik_price,
            "enable_tip":enable_tip,
            "default_tip_d":def_tip_d,
            "default_tip_p":def_tip_p
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                print("success")
                self.loadingIndicator.isAnimating = false
//                self.showAlert(title: "Successful", message: "Updated Successfully!")
                self.view.endEditing(true)
                ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        view.endEditing(true)
        validateParameters()
    }
    
    
    // MARK: online order

    @objc func onlineOrderSwitchAction(onlineSwitch: UISwitch) {
        
        if onlineSwitch.isOn {
            onlineSwitch.isOn = true
        }
        
        else {
            onlineSwitch.isOn = false
        }
    }
    
    func checkOnlineOrderSwitch() -> Bool {
        
        if setup?.offline == "0" {
            return true
        }
        else {
            return false
        }
    }
    
    func checkOnlineParams() -> String {
        
        if onlineOrderSwitch.isOn {
            return "0"
        }
        
        else {
            return "1"
        }
    }
    
    // MARK: DELIVERY SWITCH
    
    @objc func delSwitchAction(delSwitch: UISwitch) {
        
        if delSwitch.isOn {
            delSwitch.isOn = true
            activeDelColors()
        }
        
        else {
            delSwitch.isOn = false
            deactiveDelColors()
        }
    }
    
    @objc func pickSwitchAction(pickSwitch: UISwitch) {
        
        if pickSwitch.isOn {
            pickSwitch.isOn = true
            activePickColors()
        }
        
        else {
            pickSwitch.isOn = false
            deactivePickColors()
        }
    }
    
    func activeDelColors() {
        minDelTime.isUserInteractionEnabled = true
        maxDelTime.isUserInteractionEnabled = true
        minDelTime.setTextColor(.black, for: .normal)
        maxDelTime.setTextColor(.black, for: .normal)
    }
    
    func deactiveDelColors() {
        minDelTime.isUserInteractionEnabled = false
        maxDelTime.isUserInteractionEnabled = false
        minDelTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        maxDelTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
    }
    
    func activePickColors() {
        minPickTime.isUserInteractionEnabled = true
        maxPickTime.isUserInteractionEnabled = true
        minPickTime.setTextColor(.black, for: .normal)
        maxPickTime.setTextColor(.black, for: .normal)
    }
    
    func deactivePickColors() {
        minPickTime.isUserInteractionEnabled = false
        maxPickTime.isUserInteractionEnabled = false
        minPickTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        maxPickTime.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
    }
    
    func checkDelSwitch() -> Bool {
        
        if setup?.is_deliver == "Yes" {
            return true
        }
        else {
            return false
        }
    }
    
    func checkPickSwitch() -> Bool {
        
        if setup?.is_pickup == "Yes" {
            return true
        }
        else {
            return false
        }
    }
    
    func checkFieldsDel() {
        
        if enableDelSwitch.isOn {
            activeDelColors()
            
        }
        else {
            deactiveDelColors()
        }
    }
    
    func checkDelParams() -> String {
        
        if enableDelSwitch.isOn {
            return "Yes"
        }
        else {
            return "No"
        }
    }
    
    func checkPickParams() -> String {
        
        if enablePickSwitch.isOn {
            return "Yes"
        }
        else {
            return "No"
        }
    }
    
    // MARK: Convenience Fee Del
    
    func checkcFeeDelParams() -> String {
        
        if delCheck.currentImage == UIImage(named: "square_check") {
            return "1"
        }
        else {
            return "0"
        }
    }
        
    func checkcFeeDel() {
        
        if setup?.cfee_del == "1" {
            activecFeeDel()
        }
        else {
            deactivecFeeDel()
        }
    }
    
    func activecFeeDel() {
        delCheck.setImage(UIImage(named: "square_check"), for: .normal)
        delConFee.isUserInteractionEnabled = true
        delConFee.setTextColor(.black, for: .normal)
    }
    
    func deactivecFeeDel() {
        delCheck.setImage(UIImage(named: "square_uncheck"), for: .normal)
        delConFee.isUserInteractionEnabled = false
        delConFee.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        delConFee.text = ""
    }
    
    // MARK: Convenience Fee Pick
    
    func checkcFeePick() {
        
        if setup?.cfee_pik == "1" {
           activecFeePick()
        }
        else {
            deactivecFeePick()
        }
    }
    
    func checkcFeePickParams() -> String {
        
        if pickCheck.currentImage == UIImage(named: "square_check") {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    func activecFeePick() {
        pickCheck.setImage(UIImage(named: "square_check"), for: .normal)
        pickConFee.isUserInteractionEnabled = true
        pickConFee.setTextColor(.black, for: .normal)
    }
    
    func deactivecFeePick() {
        pickCheck.setImage(UIImage(named: "square_uncheck"), for: .normal)
        pickConFee.isUserInteractionEnabled = false
        pickConFee.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        
        pickConFee.text = ""

    }
    
    // MARK: Tip
    
    func checkFieldsTip() {
        
        if enableTip.isOn {
            enableTip.isOn = true
            activeTip()
        }
        
        else {
            enableTip.isOn = false
            deactiveTip()
        }
    }
    
    func activeTip() {
        defTipPick.isUserInteractionEnabled = true
        defTipDel.isUserInteractionEnabled = true
        tipPickBtn.isUserInteractionEnabled = true
        tipDelBtn.isUserInteractionEnabled = true
        
        defTipDel.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        defTipDel.setTextColor(.black, for: .normal)
        defTipDel.trailingViewMode = .always
        
        defTipPick.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        defTipPick.setTextColor(.black, for: .normal)
        defTipPick.trailingViewMode = .always
    }
    
    func deactiveTip() {
        defTipPick.isUserInteractionEnabled = false
        defTipDel.isUserInteractionEnabled = false
        tipPickBtn.isUserInteractionEnabled = false
        tipDelBtn.isUserInteractionEnabled = false
        
        defTipDel.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        defTipDel.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        defTipDel.trailingViewMode = .always
        defTipDel.trailingView?.backgroundColor = .lightGray
        
        defTipPick.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        defTipPick.setTextColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        defTipPick.trailingViewMode = .always
        defTipPick.trailingView?.backgroundColor = .lightGray
        
        defTipDel.text = "None"
        defTipPick.text = "None"
    }
    
    @objc func tipSwitchAction(tipSwitch: UISwitch) {
        
        if tipSwitch.isOn {
            tipSwitch.isOn = true
            defTipPick.isUserInteractionEnabled = true
            defTipDel.isUserInteractionEnabled = true
            tipPickBtn.isUserInteractionEnabled = true
            tipDelBtn.isUserInteractionEnabled = true
            activeTip()
        }
        
        else {
            tipSwitch.isOn = false
            defTipPick.isUserInteractionEnabled = false
            defTipDel.isUserInteractionEnabled = false
            tipPickBtn.isUserInteractionEnabled = false
            tipDelBtn.isUserInteractionEnabled = false
            deactiveTip()
        }
    }
    
    func checkEnableTipSwitch() -> Bool {
        
        if setup?.enable_tip == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    func tipParams() -> String {
        
        if enableTip.isOn {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    @IBAction func tipDelBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        del_menu.show()
    }
    
    
    @IBAction func tipPickBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        pickup_menu.show()
    }

    // MARK: Flag
    
    func checkFloatFeeParams() -> String {
        
        if flatDeliFee.currentImage == UIImage(named: "select_radio") {
            return "0"
        }
        
        else {
            return "1"
        }
    }
    
    func checkFloatFee() {
        
        if setup?.float_delivery == "0" {
            flatDeliFee.setImage(UIImage(named: "select_radio"), for: .normal)
            perMileFee.setImage(UIImage(named: "unselect_radio"), for: .normal)
            minDelFee.label.text = "Delivery Fee (\u{0024})"
            delRateMile.isHidden = true
            delRateHeight.constant = 0
        }
        else {
            perMileFee.setImage(UIImage(named: "select_radio"), for: .normal)
            flatDeliFee.setImage(UIImage(named: "unselect_radio"), for: .normal)
            minDelFee.label.text = "Min Delivery Fee (\u{0024})"
            createCustomTextField(textField: minDelFee)
            delRateMile.isHidden = false
            delRateHeight.constant = 51.33
        }
    }
    
    // MARK: MISC
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toBusinessHours" {
            let vc = segue.destination as! SetupBusinessHoursViewController
            vc.merchant_id = setup?.merchant_id
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
    
    @IBAction func radioClick(_ sender: UIButton) {
        
        if sender.tag == 1 {
            flatFeeClick(sender: sender)
        }
        
        else {
            perMileClick(sender: sender)
        }
    }
    
    func flatFeeClick(sender: UIButton) {
        
        sender.setImage(UIImage(named: "select_radio"), for: .normal)
        perMileFee.setImage(UIImage(named: "unselect_radio"), for: .normal)
        minDelFee.label.text = "Delivery Fee (\u{0024})"
        delRateMile.isHidden = true
        delRateHeight.constant = 0
    }
    
    func perMileClick(sender: UIButton) {
        
        sender.setImage(UIImage(named: "select_radio"), for: .normal)
        flatDeliFee.setImage(UIImage(named: "unselect_radio"), for: .normal)
        minDelFee.label.text = "Min Delivery Fee (\u{0024})"
        createCustomTextField(textField: minDelFee)
        delRateMile.isHidden = false
        delRateHeight.constant = 51.33
    }
    
    
    @IBAction func delCheckClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "square_uncheck") {
           activecFeeDel()
        }
        else {
            deactivecFeeDel()
        }
    }
    
    
    @IBAction func pickCheckClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "square_uncheck") {
            activecFeePick()
            
        }
        else {
            deactivecFeePick()
        }
    }
    
    
    
    @objc func toBusiness(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toBusinessHours", sender: nil)
        
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
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        
        if textField == minAmt {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        else if textField == delRadius {
            if Double(cleanedAmount) ?? 0.00 > 99999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        else if textField == minDelFee {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        else if textField == delRateMile {
            if Double(cleanedAmount) ?? 0.00 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        
        else if textField == delConFee {
            if Double(cleanedAmount) ?? 0.00 > 999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
            
            else if textField.text?.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
                
            }
        }
        
        else if textField == pickConFee {
            if Double(cleanedAmount) ?? 0.00 > 999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
            
            else if textField.text?.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
                
            }
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        if textField.text == "0.00" {
            textField.text = "0.00"
        }
        
//        if Double(cleanedAmount) ?? 0.00 < 10000 {
//
//            let amount = Double(cleanedAmount) ?? 0.0
//            let amountAsDouble = (amount / 100.0)
//            var amountAsString = String(amountAsDouble)
//            if cleanedAmount.last == "0" {
//                amountAsString.append("0")
//            }
//            textField.text = amountAsString
//        }
//        else {
//            let updatetext = cleanedAmount.dropLast()
//            let amount = Double(updatetext) ?? 0.0
//            let amountAsDouble = (amount / 100.0)
//            let amountAsString = formatter.string(from: NSNumber(value: amountAsDouble)) ?? ""
//            textField.text = amountAsString
//        }
    }
    
    
    @objc func updateLimitTextField(textField: MDCOutlinedTextField) {
        
        if textField == minDelTime || textField == minPickTime
            || textField == maxPickTime || textField == maxDelTime {
            
            if textField.text?.count == 4 {
                textField.text = String(textField.text!.dropLast())
            }
            
            else if textField.text?.count == 1 {
                textField.trailingView?.isHidden = true
                createCustomTextField(textField: textField)
            }
        }
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .normal)
        textField.trailingViewMode = .always
        
    }

    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        updateBtm.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: updateBtm.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: updateBtm.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}

extension MDCOutlinedTextField {
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(delete(_:))
            ||  action.description.contains("_replace")
        {
            return false
        }
        
        return true
    }
}


struct StoreSetup {
    
    let merchant_id: String
    let offline: String
    let max_delivery_radius: String
    let min_delivery_amt: String
    let float_delivery: String
    let delivery_fee: String
    let rate_per_miles: String
    let is_pickup: String
    let pickup_min_time: String
    let pickup_max_time: String
    let is_deliver: String
    let deliver_min_time: String
    let deliver_max_time: String
    let cfee_pik: String
    let cfee_pik_price: String
    let cfee_del: String
    let cfee_del_price: String
    let enable_tip: String
    let default_tip_p: String
    let default_tip_d: String
}


