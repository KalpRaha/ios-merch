//
//  SetupLoyaltyViewController.swift
//
//
//  Created by Pallavi on 11/06/24.
//

import UIKit
import MaterialComponents


class SetupLoyaltyViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addBonusBtn: UIButton!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var pointsAwarded: MDCOutlinedTextField!
    @IBOutlet weak var pointsRedem: MDCOutlinedTextField!
    @IBOutlet weak var minPoints: MDCOutlinedTextField!
    
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var currentPoints: UILabel!
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var big_switch = [Bool]()
    
    private var isSymbolOnRight = false
    var modeGo = ""
    var promo_id = ""
    
    var switchLoyalEnabled = ""
    var current = ""
    var name_array = [String]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var loyalty: Loyalty_Program?
    var promo_array = [Promotion_List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        addBonusBtn.layer.cornerRadius = 10
        addBonusBtn.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        addBonusBtn.layer.borderWidth = 1.0
        
        createCustomTextField(textField: pointsAwarded)
        createCustomTextField(textField: pointsRedem)
        createCustomTextField(textField: minPoints)
        
        pointsAwarded.label.text = "$1 = "
        pointsRedem.label.text = "1 Point = "
        minPoints.label.text = "Minimum Points Redemption"
        
        updateBtn.layer.cornerRadius = 10
        
        enableSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        enableSwitch.addTarget(self, action: #selector(enableLoyalty), for: .valueChanged)
        
        pointsAwarded.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        pointsRedem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        minPoints.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        pointsAwarded.keyboardType = .numberPad
        pointsRedem.keyboardType = .numberPad
        minPoints.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        scrollView.isHidden = true
        loadIndicator.isAnimating = true
        
        setupApi()
    }
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getLoyaltyProgramList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                self.getResponseValues(response: responseData["loyalty_program_data"] ?? [:])
            }
            else{
                print("Api Error")
            }
        }
    }
    
    
    func getResponseValues(response: Any) {
        
        let loyalty_list = response as! [String:Any]
        
        loyalty = Loyalty_Program(admin_id: "\(loyalty_list["admin_id"] ?? "")",
                                  current_points: "\(loyalty_list["current_points"] ?? "")",
                                  enable_loyalty: "\(loyalty_list["enable_loyalty"] ?? "")",
                                  merchant_id: "\(loyalty_list["merchant_id"] ?? "")",
                                  min_points_redemption: "\(loyalty_list["min_points_redemption"] ?? "")",
                                  points_per_dollar: "\(loyalty_list["points_per_dollar"] ?? "")",
                                  redemption_value: "\(loyalty_list["redemption_value"] ?? "")",
                                  promotion_array: loyalty_list["promotion_array"])
        
        currentPoints.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        currentPoints.backgroundColor = .clear
        
        grayView.backgroundColor = UIColor(named: "Disabled Text")
        grayView.layer.cornerRadius = 10
        
        current = loyalty?.current_points ?? ""
        
        let points = loyalty?.points_per_dollar ?? ""
        
        pointsAwarded.text = points
        pointsRedem.text = loyalty?.redemption_value
        minPoints.text = loyalty?.min_points_redemption
        
        let enable = loyalty?.enable_loyalty ?? ""
        
        setEnableDisableLoyalty(enable: enable)
        
        getPromotionDetails(promotion: loyalty?.promotion_array, points: points)
    }
    
    func getPromotionDetails(promotion: Any, points: String) {
        
        let promo = promotion as? [[String:Any]] ?? []
        
        var promoArr = [Promotion_List]()
        var nameArr = [String]()
        
        for res in promo {
            
            let loyal_promo = Promotion_List(promotion_id: "\(res["promotion_id"] ?? "")",
                                             enable_promotion: "\(res["enable_promotion"] ?? "")",
                                             promotion_name: "\(res["promotion_name"] ?? "")",
                                             bonus_points: "\(res["bonus_points"] ?? "")",
                                             start_date: "\(res["start_date"] ?? "")",
                                             end_date: "\(res["end_date"] ?? "")")
            
            promoArr.append(loyal_promo)
            nameArr.append(loyal_promo.promotion_name)
        }
        promo_array = promoArr
        name_array = nameArr
        
        var bonus = 0.00
        
        var small_switch = [Bool]()
        
        for promos in promo_array {
            
            if checkForDates(start: promos.start_date, end: promos.end_date) && promos.enable_promotion == "1" {
                
                let doub_add = Double(promos.bonus_points) ?? 0.00
                bonus += doub_add
            }
        }
        
        for promos in promo_array {
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let end_date = dateFormat.date(from: promos.end_date) ?? Date()
            
            if enableEndDate(date: end_date) {
                small_switch.append(true)
            }
            
            else {
                small_switch.append(false)
            }
        }
        
        big_switch = small_switch
        
        let doub_point = Double(points) ?? 0.00
        let total = doub_point + bonus
        currentPoints.text = "\(total)"
        
        
        DispatchQueue.main.async {
            self.tableHeight.constant = CGFloat(170 * self.promo_array.count)
            self.scrollHeight.constant = 700 + self.tableHeight.constant
            self.tableview.reloadData()
            
            self.scrollView.isHidden = false
            self.updateBtn.isEnabled = true
            self.loadIndicator.isAnimating = false
            self.loadingIndicator.isAnimating = false
        }
    }
    
    
    func setEnableDisableLoyalty(enable: String) {
        
        if enable == "1" {
            enableSwitch.isOn = true
            enableSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            enableSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        
        else {
            enableSwitch.isOn = false
            enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            enableSwitch.thumbTintColor = .white
        }
    }
    
    @objc func enableLoyalty(enableSwitch: UISwitch) {
        
        if enableSwitch.isOn {
            enableSwitch.isOn = true
            switchLoyalEnabled = "1"
            enableSwitch.onTintColor = UIColor(hexString: "#CCDFFF")
            enableSwitch.thumbTintColor = UIColor(hexString: "#0A64F9")
        }
        else {
            enableSwitch.isOn = false
            switchLoyalEnabled = "0"
            enableSwitch.onTintColor = UIColor(hexString: "#E2E2E2")
            enableSwitch.thumbTintColor = .white
        }
    }
    
    func checkLoyaltySwitch() -> String {
        
        if switchLoyalEnabled == "1" {
            return "1"
        }
        else {
            return "0"
        }
    }
    
    @objc func enableBonus(enableSwitch: UISwitch) {
        
        if big_switch[enableSwitch.tag] {
            
            if enableSwitch.isOn {
                enableSwitch.isOn = true
                promo_array[enableSwitch.tag].enable_promotion = "1"
            }
            
            else {
                enableSwitch.isOn = false
                promo_array[enableSwitch.tag].enable_promotion = "0"
            }
        }
        
        else {
            
            if enableSwitch.isOn {
                enableSwitch.isOn = false
                promo_array[enableSwitch.tag].enable_promotion = "0"
                ToastClass.sharedToast.showToast(message: "Invalid Date", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                enableSwitch.isOn = false
                promo_array[enableSwitch.tag].enable_promotion = "0"
            }
        }
        
        tableview.reloadData()
    }
    
    func checkBonusSwitch() -> String {
        
        var enable_array = [String]()
        
        for id in promo_array {
            
            if id.enable_promotion == "1" {
                enable_array.append(id.promotion_id)
            }
        }
        
        if enable_array.count == 0 {
            return "0"
        }
        else {
            let enable = enable_array.joined(separator: ",")
            return enable
        }
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func createBonusClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "add_bonus_points") {
            ToastClass.sharedToast.showToast(message: "Acces Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            modeGo = "add"
            performSegue(withIdentifier: "toCreateBonus", sender: nil)
        }
    }
    
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "edit_loyalty_program") {
            
            ToastClass.sharedToast.showToast(message: "Acces Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            guard let points = pointsAwarded.text, points != "" else {
                pointsAwarded.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            guard let redem = pointsRedem.text, redem != "" else {
                pointsRedem.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            guard let minPoints = minPoints.text, minPoints != "" else {
                minPoints.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            let enable_promo = checkBonusSwitch()
            
            loadingIndicator.isAnimating = true
            scrollView.isHidden = true
            loadIndicator.isAnimating = true
            updateBtn.isEnabled = false
            
            ApiCalls.sharedCall.updateLoyaltyProgram(merchant_id: id, admin_id: "", current_points: current,
                                                     points_per_dollar: points, redemption_value: redem,
                                                     min_points_redemption: minPoints, enable_loyalty: checkLoyaltySwitch(),
                                                     enable_promotion_id: enable_promo) { isSuccess, responseData in
                
                if isSuccess {
                    
                    self.setupApi()
                    ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else{
                    print("Api Error")
                    self.updateBtn.isEnabled = true
                    self.loadingIndicator.isAnimating = false
                }
            }
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCreateBonus" {
            
            let vc = segue.destination as! CreateBonusViewController
            
            if modeGo == "edit" {
                vc.promotion_id = promo_id
            }
            vc.mode = modeGo
            vc.namePromo = name_array
        }
    }
    
    func checkForDates(start: String, end: String) -> Bool {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let end_date = dateFormat.date(from: end) ?? Date()
        let start_date = dateFormat.date(from: start) ?? Date()
        
        if checkStartDate(date: start_date) {
            return checkEndDate(date: end_date)
        }
        else {
            return false
        }
    }
    
    func checkStartDate(date: Date) -> Bool {
        
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
        
        print(currentDay)
        print(currentMonth)
        print(currentYear)
        
        print(startDay)
        print(startMonth)
        print(startYear)
        
        if startYear < currentYear {
            return true
        }
        
        else if startYear == currentYear {
            
            if startMonth < currentMonth {
                return true
                
            }
            
            else if startMonth == currentMonth {
                
                if startDay <= currentDay {
                    return true
                }
                
                else {
                    return false
                }
            }
            
            else {
                return false
            }
        }
        
        else {
            return false
        }
    }
    
    func checkEndDate(date: Date) -> Bool {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        let dateToday = Date()
        
        let currentDay = calendar.component(.day, from: dateToday)
        let currentMonth = calendar.component(.month, from: dateToday)
        let currentYear = calendar.component(.year, from: dateToday)
        
        let endDay = calendar.component(.day, from: date)
        let endMonth = calendar.component(.month, from: date)
        let endYear = calendar.component(.year, from: date)
        
        if endYear < currentYear {
            return false
        }
        
        else if endYear == currentYear {
            
            if endMonth < currentMonth {
                
                return false
            }
            
            else if endMonth == currentMonth {
                
                if endDay < currentDay {
                    
                    return false
                }
                
                else {
                    return true
                }
            }
            
            else {
               return true
            }
        }
        
        else {
            return true
        }
    }
    
    func enableEndDate(date: Date) -> Bool {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        let dateToday = Date()
        
        let currentDay = calendar.component(.day, from: dateToday)
        let currentMonth = calendar.component(.month, from: dateToday)
        let currentYear = calendar.component(.year, from: dateToday)
        
        let endDay = calendar.component(.day, from: date)
        let endMonth = calendar.component(.month, from: date)
        let endYear = calendar.component(.year, from: date)
        
        if endYear < currentYear {
            return false
        }
        
        else if endYear == currentYear {
            
            if endMonth < currentMonth {
                
                return false
            }
            
            else if endMonth == currentMonth {
                
                if endDay < currentDay {
                    
                    return false
                }
                
                else {
                    return true
                }
            }
            
            else {
               return true
            }
        }
        
        else {
            return true
        }
    }
}

extension SetupLoyaltyViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    func addShadow(viewShadow: UIView) {
        viewShadow.layer.shadowColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 0.22).cgColor
        viewShadow.layer.shadowOpacity = 1
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 3
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
        
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
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
        
        if Double(cleanedAmount) ?? 00000 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
        
        if textField.text == "000" {
            textField.text = ""
        }
    }
}

extension SetupLoyaltyViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return promo_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LoyaltyTableViewCell
        
        addShadow(viewShadow: cell.borderView)
        cell.borderView.layer.cornerRadius = 10
        
        cell.disableView.layer.cornerRadius = 10
        cell.disableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        cell.promoView.layer.cornerRadius = 10
        cell.promoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cell.promotionName.text = promo_array[indexPath.row].promotion_name
        cell.promotionValue.text = "$1 = \(promo_array[indexPath.row].bonus_points)"
        
        
        let formattedDate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: promo_array[indexPath.row].start_date)
        
        print(formattedDate)
        let dateTime = formattedDate
        
        let dateComponents = dateTime.split(separator: " ")
        print(dateComponents)
        
        let date = String(dateComponents[0])
        
        let formattedDate1 = ToastClass.sharedToast.setCouponsDateFormat(dateStr: promo_array[indexPath.row].end_date)
        
        print(formattedDate)
        let dateTime1 = formattedDate1
        
        let dateComponents1 = dateTime1.split(separator: " ")
        print(dateComponents)
        
        let date1 = String(dateComponents1[0])
    
        let dates = "\(date)-\(date1)"
        
       print(dates)
        
        cell.validDates.text = dates
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let end_date = dateFormat.date(from: promo_array[indexPath.row].end_date) ?? Date()
        
        cell.switchDisable.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cell.switchDisable.tag = indexPath.row
        cell.switchDisable.addTarget(self, action: #selector(enableBonus), for: .valueChanged)
        
        if promo_array[indexPath.row].enable_promotion == "1" {
            
            cell.switchDisable.onTintColor = UIColor(hexString: "#CCDFFF")
            cell.switchDisable.thumbTintColor = UIColor(hexString: "#0A64F9")
            cell.switchDisable.isOn = true
            cell.borderView.layer.borderWidth = 1.0
            cell.borderView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        }
        else {
            
            cell.switchDisable.onTintColor = UIColor(hexString: "#E2E2E2")
            cell.switchDisable.thumbTintColor = .white
            cell.switchDisable.isOn = false
            cell.borderView.layer.borderWidth = 0.0
            cell.borderView.layer.borderColor = UIColor(hexString: "#0A64F9").cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        modeGo = "edit"
        promo_id = promo_array[indexPath.row].promotion_id
        performSegue(withIdentifier: "toCreateBonus", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}


struct Loyalty_Program {
    
    let admin_id: String
    let current_points: String
    let enable_loyalty: String
    let merchant_id: String
    let min_points_redemption: String
    let points_per_dollar: String
    let redemption_value: String
    let promotion_array: Any
}


struct Promotion_List {
    
    let promotion_id: String
    var enable_promotion: String
    let promotion_name: String
    let bonus_points: String
    let start_date: String
    let end_date: String
}
