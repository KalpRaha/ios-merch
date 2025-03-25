//
//  FilterNewViewController.swift
//  
//
//  Created by Jamaluddin Syed on 29/05/23.
//

import UIKit
import MaterialComponents
import Alamofire

class FilterNewViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var dateRange: UIButton!
    @IBOutlet weak var orderSource: UIButton!
    @IBOutlet weak var orderType: UIButton!
    @IBOutlet weak var category: UIButton!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var sixthBtn: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startTime: MDCOutlinedTextField!
    @IBOutlet weak var endTime: MDCOutlinedTextField!
    
    var identity:Int?
    var categoryList = [String]()
    var activeTextField = UITextField()
    
    let orderSourceArray = ["All", "Online", "In Store"]
    let orderTypeArray = ["All", "Pickup", "Delivery"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(identity!)
        
        firstBtn.setTitle(" Today", for: .normal)
        firstBtn.tag = 101
        secondBtn.setTitle(" Yesterday", for: .normal)
        secondBtn.tag = 102
        thirdBtn.setTitle(" Last 7 Days", for: .normal)
        thirdBtn.tag = 103
        fourthBtn.setTitle(" This Month", for: .normal)
        fourthBtn.tag = 104
        sixthBtn.setTitle(" Custom", for: .normal)
        sixthBtn.tag = 105
        
        showRadioDateBtn(identity: identity!)
        tableview.allowsSelection = true
        tableview.isUserInteractionEnabled = true
        
        dateRange.setTitle("Date Range", for: .normal)
        dateRange.setTitleColor(UIColor.black, for: .normal)
        orderSource.setTitle("Order Source", for: .normal)
        orderSource.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
        orderType.setTitle("Order Type", for: .normal)
        orderType.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
        category.setTitle("Category", for: .normal)
        category.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
        
        applyButton.layer.cornerRadius = 10
        
        setFilterOptions(identifier:identity!)
        
        let imagein = UIImageView(image: UIImage(named: "date_picker"))
        startDate.trailingView = imagein
        startDate.trailingViewMode = .always
        
        let imageout = UIImageView(image: UIImage(named: "date_picker"))
        endDate.trailingView = imageout
        endDate.trailingViewMode = .always
                
        let timein = UIImageView(image: UIImage(named: "time_picker"))
        startTime.trailingView = timein
        startTime.trailingViewMode = .always
        
        let timeout = UIImageView(image: UIImage(named: "time_picker"))
        endTime.trailingView = timeout
        endTime.trailingViewMode = .always
        
        
        startDate.delegate = self
        endDate.delegate = self
        startTime.delegate = self
        endTime.delegate = self
        
        startDate.label.text = "Start Date"
        endDate.label.text = "End Date"
        startTime.label.text = "Start Time"
        endTime.label.text = "End Time"
        
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        createCustomTextField(textField: startTime)
        createCustomTextField(textField: endTime)
        
    
//        if UserDefaults.standard.object(forKey: "Category_Titles") != nil {
//            categoryList = UserDefaults.standard.object(forKey: "Category_Titles") as! [String]
//        }
//        
//        else {
            categoryFiltersApi()
        //}
        
        UserDefaults.standard.set(true, forKey: "os_filter_loaded")
        UserDefaults.standard.set(true, forKey: "ot_filter_loaded")
        UserDefaults.standard.set(true, forKey: "cat_filter_loaded")
        
        topView.addBottomShadow()
        
        
    }
    
    func showRadioDateBtn(identity: Int) {
        
        UserDefaults.standard.set(11, forKey: "filterSubCategory")
        tableview.isHidden = true
        let selected = showDateFilter(identity: identity)
        
        if selected == 105 {
            showDateTimeInputs()
            startDate.text = UserDefaults.standard.string(forKey: "custom_start_date")
            endDate.text = UserDefaults.standard.string(forKey: "custom_end_date")
            scroll.isScrollEnabled = true
        }
        else {
            hideDateTimeInputs()
            startDate.text = ""
            endDate.text = ""
            scroll.isScrollEnabled = false
        }
        
        for i in 101...105 {
            if i == selected {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "select_radio"), for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "unselect_radio"), for: .normal)
            }
        }
        
        
    }
    
    func showDateFilter(identity: Int) -> Int {
        
        switch identity {
            
        case 0:
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_sales")
            
        case 1:
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_item")
            
        case 2:
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_order")
            
        default:
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_taxes")
        }
    }
    
    func showDateTimeInputs() {
        
        dateLabel.isHidden = false
        startDate.isHidden = false
        endDate.isHidden = false
        timeLabel.isHidden = false
        startTime.isHidden = false
        endTime.isHidden = false
        
        
    }
    
    func hideDateTimeInputs() {
        
        dateLabel.isHidden = true
        startDate.isHidden = true
        endDate.isHidden = true
        timeLabel.isHidden = true
        startTime.isHidden = true
        endTime.isHidden = true
    }
    
    
    func setFilterOptions(identifier: Int) {
        
        switch identifier {
            
        case 0:
            orderType.isHidden = true
            orderSource.isHidden = true
            category.isHidden = true
            break
            
        case 1:
            orderType.isHidden = false
            orderSource.isHidden = false
            category.isHidden = false
            break
            
        case 2:
            orderType.isHidden = true
            orderSource.isHidden = false
            category.isHidden = true
            break
            
        default:
            orderType.isHidden = false
            orderSource.isHidden = false
            category.isHidden = true
        }
    }
    
    
    @IBAction func subCategoryClicked(_ sender: UIButton) {
        
        selectSubCategory(tag: sender.tag)
    }
    
    
    func selectSubCategory(tag: Int) {
        
        for i in 11...14 {
            if i == tag {
                let button = view.viewWithTag(i) as! UIButton
                button.setTitleColor(.black, for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
            }
        }
        if tag != 11 {
            scroll.isHidden = true
            tableview.isHidden = false
        }
        else {
            scroll.isHidden = false
            tableview.isHidden = true
        }
        UserDefaults.standard.set(tag, forKey: "filterSubCategory")
        tableview.reloadData()
    }
    
    func categoryFiltersApi() {
        
        let url = AppURLs.FILTER_CATEGORY

        let parameters: [String:Any] = [
            "merchant_id": UserDefaults.standard.string(forKey: "merchant_id")!
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    let jsonDict = json["result"] as! [Any]
                    print(jsonDict)
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
    
    func getResponseValues(responseValues: [Any]) {
        
        print(responseValues)
        
        for response in responseValues {
            let res = response as! [String:Any]
            categoryList.append(res["title"] as! String)
        }
        categoryList.insert("All", at: 0)
        
        print(categoryList)
     //   UserDefaults.standard.set(categoryList, forKey: "Category_Titles")
        
        tableview.reloadData()
    }
    
    
    @IBAction func filterButtonClick(_ sender: UIButton) {
        
        filterRadios(tag: sender.tag)
    }
    
    func filterRadios(tag:Int) {
        
        if identity == 0 {
            UserDefaults.standard.set(tag,forKey: "tempDateTimeFilter_sales")
        }
        else if identity == 1 {
            UserDefaults.standard.set(tag,forKey: "tempDateTimeFilter_item")
        }
        else if identity == 2 {
            UserDefaults.standard.set(tag,forKey: "tempDateTimeFilter_order")
        }
        else {
            UserDefaults.standard.set(tag,forKey: "tempDateTimeFilter_taxes")
        }
        
        for i in 101...105 {
            if i == tag {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "select_radio"), for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "unselect_radio"), for: .normal)
            }
        }
        if tag == 105 {
            showDateTimeInputs()
            scroll.isScrollEnabled = true
        }
        else {
            hideDateTimeInputs()
            scroll.isScrollEnabled = false
        }
    }
    
    func setOrderSource() {
        
        if identity == 0 {
            if UserDefaults.standard.integer(forKey: "validOrderSource_sales") == 0 {
                UserDefaults.standard.set("9", forKey: "orderSource_sales")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderSource_sales") == 1 {
                UserDefaults.standard.set("5", forKey: "orderSource_sales")
            }
            else {
                UserDefaults.standard.set("6", forKey: "orderSource_sales")
            }
        }
        else if identity == 1 {
            if UserDefaults.standard.integer(forKey: "validOrderSource_item") == 0 {
                UserDefaults.standard.set("9", forKey: "orderSource_item")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderSource_item") == 1 {
                UserDefaults.standard.set("5", forKey: "orderSource_item")
            }
            else {
                UserDefaults.standard.set("6", forKey: "orderSource_item")
            }
        }
        else if identity == 2 {
            if UserDefaults.standard.integer(forKey: "validOrderSource_order") == 0 {
                UserDefaults.standard.set("9", forKey: "orderSource_order")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderSource_order") == 1 {
                UserDefaults.standard.set("5", forKey: "orderSource_order")
            }
            else {
                UserDefaults.standard.set("6", forKey: "orderSource_order")
            }
        }
        
        else {
            if UserDefaults.standard.integer(forKey: "validOrderSource_taxes") == 0 {
                UserDefaults.standard.set("9", forKey: "orderSource_taxes")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderSource_taxes") == 1 {
                UserDefaults.standard.set("5", forKey: "orderSource_taxes")
            }
            else {
                UserDefaults.standard.set("6", forKey: "orderSource_taxes")
            }
        }
        
    }
    
    func setOrderType() {
        
        if identity == 0 {
            if UserDefaults.standard.integer(forKey: "validOrderType_sales") == 0 {
                UserDefaults.standard.set("both", forKey: "orderType_sales")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderType_sales") == 1 {
                UserDefaults.standard.set("pickup", forKey: "orderType_sales")
            }
            else {
                UserDefaults.standard.set("delivery", forKey: "orderType_sales")
            }
        }
        else if identity == 1 {
            if UserDefaults.standard.integer(forKey: "validOrderType_item") == 0 {
                UserDefaults.standard.set("both", forKey: "orderType_item")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderType_item") == 1 {
                UserDefaults.standard.set("pickup", forKey: "orderType_item")
            }
            else {
                UserDefaults.standard.set("delivery", forKey: "orderType_item")
            }
        }
        else {
            if UserDefaults.standard.integer(forKey: "validOrderType_taxes") == 0 {
                UserDefaults.standard.set("both", forKey: "orderType_taxes")
            }
            else if UserDefaults.standard.integer(forKey: "validOrderType_taxes") == 1 {
                UserDefaults.standard.set("pickup", forKey: "orderType_taxes")
            }
            else {
                UserDefaults.standard.set("delivery", forKey: "orderType_taxes")
            }
        }
    }
    
    func setCategory() {
        
        let id = UserDefaults.standard.integer(forKey: "validCategory_item")
        if id == 0 {
            UserDefaults.standard.set("all", forKey: "category_item")
        }
        else {
            UserDefaults.standard.set("\(categoryList[id])", forKey: "category_item")

        }
    }
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        backScreen()
        
    }
    
    func backScreen() {
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
        
    }
    
    
    @IBAction func applyButtonClick(_ sender: UIButton) {
        
        switch identity {
            
        case 0:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempDateTimeFilter_sales"), forKey: "dateTimeFilter_sales")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderSource_sales"), forKey: "validOrderSource_sales")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderType_sales"), forKey: "validOrderType_sales")
            break
            
        case 1:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempDateTimeFilter_item"), forKey: "dateTimeFilter_item")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderSource_item"), forKey: "validOrderSource_item")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderType_item"), forKey: "validOrderType_item")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempCategory_item"), forKey: "validCategory_item")
            break
            
        case 2:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempDateTimeFilter_order"), forKey: "dateTimeFilter_order")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderSource_order"), forKey: "validOrderSource_order")
            break
            
        default:
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempDateTimeFilter_taxes"), forKey: "dateTimeFilter_taxes")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderSource_taxes"), forKey: "validOrderSource_taxes")
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "tempOrderType_taxes"), forKey: "validOrderType_taxes")
        
        }
        
        UserDefaults.standard.set(0, forKey: "changeOrderSource_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_item")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_order")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeOrderType_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderType_item")
        UserDefaults.standard.set(0, forKey: "changeOrderType_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeCategory_item")

        
        setOrderSource()
        setOrderType()
        setCategory()
        
        if identity == 0 {
            
            if UserDefaults.standard.integer(forKey: "dateTimeFilter_sales") == 105 {
                
                if startDate.text == "" {
                    
                    showAlert(title: "Alert", message: "Start Date cannot be empty")
                }
                else if endDate.text == "" {
                    showAlert(title: "Alert", message: "End Date cannot be empty")
                }   
                else {
                    backScreen()
                }
            }
            
            else {
                backScreen()
            }
        }
        
        else if identity == 1 {
            if UserDefaults.standard.integer(forKey: "dateTimeFilter_item") == 105 {
                
                if startDate.text == "" {
                    showAlert(title: "Alert", message: "Start Date cannot be empty")
                }
                else if endDate.text == "" {
                    showAlert(title: "Alert", message: "End Date cannot be empty")
                }
                else {
                    backScreen()
                }
            }
            else {
                backScreen()
            }
        }
        
        else if identity == 2 {
            if UserDefaults.standard.integer(forKey: "dateTimeFilter_order") == 105 {
                
                if startDate.text == "" {
                    showAlert(title: "Alert", message: "Start Date cannot be empty")
                }
                
                else if endDate.text == "" {
                    showAlert(title: "Alert", message: "End Date cannot be empty")
                }
                else {
                    backScreen()
                }
            }
            else {
                backScreen()
            }
        }
        
        else {
            if UserDefaults.standard.integer(forKey: "dateTimeFilter_taxes") == 105 {
                if startDate.text == "" {
                    showAlert(title: "Alert", message: "Start Date cannot be empty")
                }
                else if endDate.text == "" {
                    showAlert(title: "Alert", message: "End Date cannot be empty")
                }
                else {
                    backScreen()
                }
            }
            else {
                backScreen()
            }
        }
    }
    
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        switch UserDefaults.standard.integer(forKey: "filterSubCategory") {
            
        case 12:
            var deselect = 0
            if UserDefaults.standard.bool(forKey: "os_filter_loaded") {
                UserDefaults.standard.set(false, forKey: "os_filter_loaded")
                if identity == 0 {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderSource_sales")
                }
                else if identity == 1 {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderSource_item")
                }
                else if identity == 2 {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderSource_order")
                }
                else {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderSource_taxes")
                }
            }
            else {
                if identity == 0 {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderSource_sales")
                }
                else if identity == 1 {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderSource_item")
                }
                else if identity == 2 {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderSource_order")
                }
                else {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderSource_taxes")
                }
            }
            if identity == 0 {
                UserDefaults.standard.set(1, forKey: "changeOrderSource_sales")
            }
            else if identity == 1 {
                UserDefaults.standard.set(1, forKey: "changeOrderSource_item")
            }
            else if identity == 2 {
                UserDefaults.standard.set(1, forKey: "changeOrderSource_order")
            }
            else {
                UserDefaults.standard.set(1, forKey: "changeOrderSource_taxes")
            }
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            if identity == 0 {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderSource_sales")
            }
            else if identity == 1 {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderSource_item")
            }
            else if identity == 2 {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderSource_order")
            }
            else {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderSource_taxes")
            }
            let indexPath = IndexPath(item: deselect, section: 0)
            tableview.reloadRows(at: [indexPath], with: .fade)
            break
            
        case 13:
            var deselect = 0
            if UserDefaults.standard.bool(forKey: "ot_filter_loaded") {
                UserDefaults.standard.set(false, forKey: "ot_filter_loaded")
                if identity == 0 {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderType_sales")
                }
                else if identity == 1 {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderType_item")
                }
                else {
                    deselect = UserDefaults.standard.integer(forKey: "validOrderType_taxes")
                }
            }
            else {
                if identity == 0 {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderType_sales")
                }
                else if identity == 1 {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderType_item")
                }
                else {
                    deselect = UserDefaults.standard.integer(forKey: "tempOrderType_taxes")
                }
            }
            if identity == 0 {
                UserDefaults.standard.set(1, forKey: "changeOrderType_sales")
            }
            else if identity == 1 {
                UserDefaults.standard.set(1, forKey: "changeOrderType_item")
            }
            else {
                UserDefaults.standard.set(1, forKey: "changeOrderType_taxes")
            }
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            if identity == 0 {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderType_sales")
            }
            else if identity == 1 {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderType_item")
            }
            else {
                UserDefaults.standard.set(sender.tag, forKey: "tempOrderType_taxes")
            }
            let indexPath = IndexPath(item: deselect, section: 0)
            tableview.reloadRows(at: [indexPath], with: .fade)
            break
        case 14:
            var deselect = 0
            if UserDefaults.standard.bool(forKey: "cat_filter_loaded") {
                UserDefaults.standard.set(false, forKey: "cat_filter_loaded")
                deselect = UserDefaults.standard.integer(forKey: "validCategory_item")
            }
            else {
                deselect = UserDefaults.standard.integer(forKey: "tempCategory_item")
            }
            UserDefaults.standard.set(1, forKey: "changeCategory_item")
            sender.setImage(UIImage(named: "select_radio"), for: .normal)
            UserDefaults.standard.set(sender.tag, forKey: "tempCategory_item")
            let indexPath = IndexPath(item: deselect, section: 0)
            tableview.reloadRows(at: [indexPath], with: .fade)
            break
        default:
            break
        }
        
    }
    
    
    
    
    func checkOSChange() -> Int {
        
        if identity == 0 {
            if UserDefaults.standard.integer(forKey: "changeOrderSource_sales") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        else if identity == 1 {
            if UserDefaults.standard.integer(forKey: "changeOrderSource_item") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        else if identity == 2 {
            if UserDefaults.standard.integer(forKey: "changeOrderSource_order") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        
        else {
            if UserDefaults.standard.integer(forKey: "changeOrderSource_taxes") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        
    }
    
    func checkOTChange() -> Int {
        
        if identity == 0 {
            if UserDefaults.standard.integer(forKey: "changeOrderType_sales") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        else if identity == 1 {
            if UserDefaults.standard.integer(forKey: "changeOrderType_item") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        else {
            if UserDefaults.standard.integer(forKey: "changeOrderType_taxes") == 1 {
                return 1
            }
            else {
                return 0
            }
        }
        
    }
    
    func checkCategoryChange() -> Int {
        
        if UserDefaults.standard.integer(forKey: "changeCategory_item") == 1 {
            return 1
        }
        else {
            return 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("dismiss")
        
        UserDefaults.standard.set(false, forKey: "os_filter_loaded")
        UserDefaults.standard.set(false, forKey: "ot_filter_loaded")
        UserDefaults.standard.set(false, forKey: "cat_filter_loaded")
        
        UserDefaults.standard.set(0, forKey: "changeOrderSource_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_item")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_order")
        UserDefaults.standard.set(0, forKey: "changeOrderSource_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeOrderType_sales")
        UserDefaults.standard.set(0, forKey: "changeOrderType_item")
        UserDefaults.standard.set(0, forKey: "changeOrderType_taxes")
        
        UserDefaults.standard.set(0, forKey: "changeCategory_item")
    }
}

extension FilterNewViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.integer(forKey: "filterSubCategory") == 12 {
            return orderSourceArray.count
        }
        else if UserDefaults.standard.integer(forKey: "filterSubCategory") == 13 {
            return orderTypeArray.count
        }
        else if UserDefaults.standard.integer(forKey: "filterSubCategory") == 14 {
            return categoryList.count
        }
        else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterNewTableViewCell
        
        switch UserDefaults.standard.integer(forKey: "filterSubCategory") {
            
        case 12:
            if checkOSChange() == 1 {
                if identity == 0 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderSource_sales") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else if identity == 1 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderSource_item") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else if identity == 2 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderSource_order") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderSource_taxes") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
            }
            else {
                
                if identity == 0 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderSource_sales") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
                else if identity == 1 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderSource_item") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
                else if identity == 2 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderSource_order") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
                else {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderSource_taxes") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
            }
            
            cell.categories.setTitle(" "+orderSourceArray[indexPath.row], for: .normal)
            break
            
        case 13:
            
            if checkOTChange() == 1 {
                if identity == 0 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderType_sales") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else if identity == 1 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderType_item") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "tempOrderType_taxes") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
            }
            else {
                
                if identity == 0 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderType_sales") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                else if identity == 1 {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderType_item") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
                else {
                    if indexPath.row == UserDefaults.standard.integer(forKey: "validOrderType_taxes") {
                        cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                    }
                    else {
                        cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                        
                    }
                }
                
            }
            
            cell.categories.setTitle(" "+orderTypeArray[indexPath.row], for: .normal)
            break
            
        case 14:
            
            if checkCategoryChange() == 1 {
                
                if indexPath.row ==  UserDefaults.standard.integer(forKey: "tempCategory_item") {
                    cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                }
                else {
                    cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                }
            }
            else {
                if indexPath.row ==  UserDefaults.standard.integer(forKey: "validCategory_item") {
                    cell.categories.setImage(UIImage(named: "select_radio"), for: .normal)
                }
                else {
                    cell.categories.setImage(UIImage(named: "unselect_radio"), for: .normal)
                }
            }
            
            cell.categories.setTitle("  "+categoryList[indexPath.row], for: .normal)
            break
            
        default:
            print("")
        }
        cell.categories.tag = indexPath.row
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FilterNewViewController {
    
    func openDatePicker(textField: UITextField, tag: Int) {
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if tag == 21 || tag == 22 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else if tag == 23 || tag == 24 {
            datePicker.datePickerMode = .time
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
        }
        datePicker.addTarget(self, action: #selector(datePickerHandler(datePicker:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancelBtnClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField.tag == 21 {
                checkStartDate(date: datePicker.date)
            }
            else if activeTextField.tag == 22 {
                checkEndDate(date: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    @objc func timeDoneBtn() {
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "hh:mm"
            if activeTextField.tag == 23 {
                checkStartTime(time: datePicker.date)
            }
            else if activeTextField.tag == 24 {
                checkEndTime(time: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
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
        
        if startYear > currentYear {
            
            showAlert(title: "Alert", message: "Start date cannot be greater than current date")
        }
        
        else if startYear == currentYear {
            
            if startMonth > currentMonth {
                
                showAlert(title: "Alert", message: "Start date cannot be greater than current date")
            }
            
            else if startMonth == currentMonth {
                
                if startDay > currentDay {
                    
                    showAlert(title: "Alert", message: "Start date cannot be greater than current date")
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    endDate.text = ""
                    UserDefaults.standard.set(activeTextField.text, forKey: "custom_start_date")
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
                endDate.text = ""
                UserDefaults.standard.set(activeTextField.text, forKey: "custom_start_date")
            }
        }
            
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
            UserDefaults.standard.set(activeTextField.text, forKey: "custom_start_date")
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        if startDate.text == "" {
            showAlert(title: "Alert", message: "Please enter start date first")
        }
        else {
            let startDateCheck = dateFormat.date(from: startDate.text!)
            
            let calendar = Calendar.current
            
            let startDay = calendar.component(.day, from: startDateCheck!)
            let startMonth = calendar.component(.month, from: startDateCheck!)
            let startYear = calendar.component(.year, from: startDateCheck!)
            
            let endDay = calendar.component(.day, from: date)
            let endMonth = calendar.component(.month, from: date)
            let endYear = calendar.component(.year, from: date)
            
            if endYear < startYear {
                
                showAlert(title: "Alert", message: "End date cannot be earlier than start date")
            }
            
            else if endYear == startYear {
                
                if endMonth < startMonth {
                    
                    showAlert(title: "Alert", message: "End date cannot be earlier than start date")
                }
                
                else if endMonth == startMonth {
                    
                    if endDay < startDay {
                        
                        showAlert(title: "Alert", message: "End date cannot be earlier than start date")
                    }
                    
                    else {
                        activeTextField.text = dateFormat.string(from: date)
                        UserDefaults.standard.set(activeTextField.text, forKey: "custom_end_date")
                    }
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    UserDefaults.standard.set(activeTextField.text, forKey: "custom_end_date")
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
                UserDefaults.standard.set(activeTextField.text, forKey: "custom_end_date")
            }
        }
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
    
    func checkStartTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        
        

        activeTextField.text = dateFormat.string(from: time)
        UserDefaults.standard.set(activeTextField.text, forKey: "custom_start_time")


    }
    
    func checkEndTime(time: Date) {
        
        if startTime.text == ""{
            showAlert(title: "Alert", message: "Start Time not set, Please set a start time first.")
        }
        else {
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm"
            
            let calendar = Calendar.current
            let todaycal = dateFormat.date(from: startTime.text!)
            
            activeTextField.text = dateFormat.string(from: time)
            UserDefaults.standard.set(activeTextField.text, forKey: "custom_end_time")
            
            
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
    
    
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        openDatePicker(textField: activeTextField, tag: activeTextField.tag)
    }
}

extension FilterNewViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}
