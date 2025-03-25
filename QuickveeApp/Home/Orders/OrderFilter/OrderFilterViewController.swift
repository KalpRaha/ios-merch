//
//  OrderFilterViewController.swift
//  
//
//  Created by Jamaluddin Syed on 7/31/23.
//

import UIKit
import MaterialComponents
import DropDown

class OrderFilterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var customDateView: UIView!
    @IBOutlet weak var orderTypeView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var perDayView: UIView!
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var pickup: UIButton!
    @IBOutlet weak var delivery: UIButton!
    
    @IBOutlet weak var minimumAmount: MDCOutlinedTextField!
    @IBOutlet weak var minimumBtn: UIButton!
    @IBOutlet weak var maximumAmount: MDCOutlinedTextField!
    @IBOutlet weak var perDayDate: MDCOutlinedTextField!
    @IBOutlet weak var maximumBtn: UIButton!
    
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var clearBtn: UILabel!
    
    
    @IBOutlet weak var leftTable: UITableView!
    
    var activeTextField = UITextField()
    var filterMode = ""

    let minMenu = DropDown()
    let maxMenu = DropDown()
    
    var selectFilter = 0
    
    var hideType = Bool()
    
    let amount1 = ["$0", "$100", "$150", "$200", "$250"]
    let amount2 = ["$850", "$900", "$950", "$1000"]
    
    let onlineFiters = ["Filter by Order Date", "Select Order Type", "Filter by Order Amount", "Filter Orders by Day"]
    let storeFiters = ["Filter by Order Date", "Filter by Order Amount", "Filter Orders by Day"]
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSlider.delegate = self
        
        topview.addBottomShadow()
        
        startDate.label.text = "Select Start Date"
        endDate.label.text = "Select End Date"
        
        allBtn.setTitle(" All", for: .normal)
        pickup.setTitle("  Pickup: Show pick up orders", for: .normal)
        delivery.setTitle("  Delivery: Show delivery orders", for: .normal)
        
        rangeSlider.minValue = 0.0
        rangeSlider.maxValue = 1000.0
        
        rangeSlider.selectedMaxValue = 850.0
        rangeSlider.selectedMinValue = 0.0
        
        
        
        perDayDate.label.text = "Pick a Date"
        
        applyBtn.layer.cornerRadius = 10
        cancel.layer.cornerRadius = 10
        cancel.layer.borderColor = UIColor.black.cgColor
        cancel.layer.borderWidth = 1.0
        
        customDateView.isHidden = false
        orderTypeView.isHidden = true
        perDayView.isHidden = true
        amountView.isHidden = true
        
        startDate.delegate = self
        endDate.delegate = self
        perDayDate.delegate = self
        
        setTrailingImage()
        
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        createCustomTextField(textField: minimumAmount)
        createCustomTextField(textField: maximumAmount)
        createCustomTextField(textField: perDayDate)
        
        setupMenu()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clearClick))
        clearBtn.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        clearBtn.isUserInteractionEnabled = true
        
        leftTable.separatorColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if filterMode == "new"{
            startDate.text = UserDefaults.standard.string(forKey: "valid_order_new_start_date")
            
            if UserDefaults.standard.string(forKey: "new_per_day") ==  "1" {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_new_start_date")
            }
            else {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_new_end_date")
            }
            
            perDayDate.text = UserDefaults.standard.string(forKey: "valid_order_new_start_date")
            
            var min = UserDefaults.standard.string(forKey: "valid_order_new_min_amt") ?? "0.0"
            var max = UserDefaults.standard.string(forKey: "valid_order_new_max_amt") ?? "850.0"
            
            if min == "" {
                min = "0"
            }
            if max == "" {
                max = "850"
            }
            
            rangeSlider.selectedMinValue = Double(min) ?? 0.0
            rangeSlider.selectedMaxValue = Double(max) ?? 850.0
            
            minimumAmount.text = "$\(min)"
            maximumAmount.text = "$\(max)"
        }
        
        else if filterMode == "closed" {
            startDate.text = UserDefaults.standard.string(forKey: "valid_order_closed_start_date")
            
            if UserDefaults.standard.string(forKey: "closed_per_day") ==  "1" {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_closed_start_date")
            }
            else {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_closed_end_date")
            }
            
            perDayDate.text = UserDefaults.standard.string(forKey: "valid_order_closed_start_date")
            
            var min = UserDefaults.standard.string(forKey: "valid_order_closed_min_amt") ?? "0.0"
            var max = UserDefaults.standard.string(forKey: "valid_order_closed_max_amt") ?? "850.0"
            
            if min == "" {
                min = "0"
            }
            if max == "" {
                max = "850"
            }
            
            
            rangeSlider.selectedMinValue = Double(min) ?? 0.0
            rangeSlider.selectedMaxValue = Double(max) ?? 850.0
            
            minimumAmount.text = "$\(min)"
            maximumAmount.text = "$\(max)"
        }
        
        else if filterMode == "failed"{
            startDate.text = UserDefaults.standard.string(forKey: "valid_order_failed_start_date")
            
            if UserDefaults.standard.string(forKey: "failed_per_day") ==  "1" {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_failed_start_date")
            }
            else {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_failed_end_date")
            }
            
            perDayDate.text = UserDefaults.standard.string(forKey: "valid_order_failed_start_date")
            
            var min = UserDefaults.standard.string(forKey: "valid_order_failed_min_amt") ?? "0.0"
            var max = UserDefaults.standard.string(forKey: "valid_order_failed_max_amt") ?? "850.0"
            
            if min == "" {
                min = "0"
            }
            if max == "" {
                max = "850"
            }
            
            rangeSlider.selectedMinValue = Double(min) ?? 0.0
            rangeSlider.selectedMaxValue = Double(max) ?? 850.0
            
            minimumAmount.text = "$\(min)"
            maximumAmount.text = "$\(max)"
        }
        
        else if filterMode == "paid" {
            startDate.text = UserDefaults.standard.string(forKey: "valid_order_paid_start_date")
            
            if UserDefaults.standard.string(forKey: "paid_per_day") ==  "1" {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_paid_start_date")
            }
            else {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_paid_end_date")
            }
            
            perDayDate.text = UserDefaults.standard.string(forKey: "valid_order_paid_start_date")
            
            var min = UserDefaults.standard.string(forKey: "valid_order_paid_min_amt") ?? "0.0"
            var max = UserDefaults.standard.string(forKey: "valid_order_paid_max_amt") ?? "850.0"
            
            if min == "" {
                min = "0"
            }
            if max == "" {
                max = "850"
            }
            
            rangeSlider.selectedMinValue = Double(min) ?? 0.0
            rangeSlider.selectedMaxValue = Double(max) ?? 850.0
            
            minimumAmount.text = "$\(min)"
            maximumAmount.text = "$\(max)"
        }
        
        else {
            startDate.text = UserDefaults.standard.string(forKey: "valid_order_refund_start_date")
            
            if UserDefaults.standard.string(forKey: "paid_per_day") ==  "1" {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_refund_start_date")
            }
            else {
                endDate.text = UserDefaults.standard.string(forKey: "valid_order_refund_end_date")
            }
            
            perDayDate.text = UserDefaults.standard.string(forKey: "valid_order_refund_start_date")
            
            var min = UserDefaults.standard.string(forKey: "valid_order_refund_min_amt") ?? "0.0"
            var max = UserDefaults.standard.string(forKey: "valid_order_refund_max_amt") ?? "850.0"
            
            if min == "" {
                min = "0"
            }
            if max == "" {
                max = "850"
            }
        
            rangeSlider.selectedMinValue = Double(min) ?? 0.0
            rangeSlider.selectedMaxValue = Double(max) ?? 850.0
            
            minimumAmount.text = "$\(min)"
            maximumAmount.text = "$\(max)"
        }
        
        setOrderType()
    }
    
    @objc func clearClick() {
        
        //store
        if hideType {
            
            if filterMode == "paid" {
                
                UserDefaults.standard.set("", forKey: "temp_order_paid_start_date")
                UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
                
                UserDefaults.standard.set("", forKey: "temp_order_paid_min_amt")
                UserDefaults.standard.set("", forKey: "temp_order_paid_max_amt")
                
                UserDefaults.standard.set("", forKey: "valid_order_paid_start_date")
                UserDefaults.standard.set("", forKey: "valid_order_paid_end_date")
                
                UserDefaults.standard.set("", forKey: "valid_order_paid_min_amt")
                UserDefaults.standard.set("", forKey: "valid_order_paid_max_amt")
                
            }
            
            else {
                
                UserDefaults.standard.set("", forKey: "temp_order_refund_start_date")
                UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
                
                UserDefaults.standard.set("", forKey: "temp_order_refund_min_amt")
                UserDefaults.standard.set("", forKey: "temp_order_refund_max_amt")
                
                UserDefaults.standard.set("", forKey: "valid_order_refund_start_date")
                UserDefaults.standard.set("", forKey: "valid_order_refund_end_date")
                
                UserDefaults.standard.set("", forKey: "valid_order_refund_min_amt")
                UserDefaults.standard.set("", forKey: "valid_order_refund_max_amt")
            }
            
            startDate.text = ""
            endDate.text = ""
            
            perDayDate.text = ""
            
            minimumAmount.text = "$\(0.0)"
            maximumAmount.text = "$\(850.0)"
            
            rangeSlider.selectedMinValue = 0.0
            rangeSlider.selectedMaxValue = 850.0
            rangeSlider.layoutSubviews()
            
        }
        
        else {
            
            if filterMode == "new" {
                UserDefaults.standard.set("", forKey: "temp_order_new_start_date")
                UserDefaults.standard.set("", forKey: "temp_order_new_end_date")
                
                UserDefaults.standard.set("", forKey: "temp_order_new_min_amt")
                UserDefaults.standard.set("", forKey: "temp_order_new_max_amt")
                
                UserDefaults.standard.set("", forKey: "valid_order_new_start_date")
                UserDefaults.standard.set("", forKey: "valid_order_new_end_date")
                
                UserDefaults.standard.set("", forKey: "valid_order_new_min_amt")
                UserDefaults.standard.set("", forKey: "valid_order_new_max_amt")
            }
            
            else if filterMode == "closed" {
                UserDefaults.standard.set("", forKey: "temp_order_closed_start_date")
                UserDefaults.standard.set("", forKey: "temp_order_closed_end_date")
                
                UserDefaults.standard.set("", forKey: "temp_order_closed_min_amt")
                UserDefaults.standard.set("", forKey: "temp_order_closed_max_amt")
                
                UserDefaults.standard.set("", forKey: "valid_order_closed_start_date")
                UserDefaults.standard.set("", forKey: "valid_order_closed_end_date")
                
                UserDefaults.standard.set("", forKey: "valid_order_closed_min_amt")
                UserDefaults.standard.set("", forKey: "valid_order_closed_max_amt")
            }
            
            else {
                UserDefaults.standard.set("", forKey: "temp_order_failed_start_date")
                UserDefaults.standard.set("", forKey: "temp_order_failed_end_date")
                
                UserDefaults.standard.set("", forKey: "temp_order_failed_min_amt")
                UserDefaults.standard.set("", forKey: "temp_order_failed_max_amt")
                
                UserDefaults.standard.set("", forKey: "valid_order_failed_start_date")
                UserDefaults.standard.set("", forKey: "valid_order_failed_end_date")
                
                UserDefaults.standard.set("", forKey: "valid_order_failed_min_amt")
                UserDefaults.standard.set("", forKey: "valid_order_failed_max_amt")
            }
            
            
            startDate.text = ""
            endDate.text = ""
            
            perDayDate.text = ""
            
            minimumAmount.text = "$\(0.0)"
            maximumAmount.text = "$\(850.0)"
            
            rangeSlider.selectedMinValue = 0.0
            rangeSlider.selectedMaxValue = 850.0
            rangeSlider.layoutSubviews()
        }
    }
    
    
    func setupMenu() {
        
        var mini_text = ""
        var max_text = ""
        
        minMenu.dataSource = amount1
        minMenu.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = minimumAmount
        minMenu.anchorView = minimumAmount
        
        minMenu.selectionAction = { index, title in
            self.minMenu.deselectRow(at: index)
            mini_text = title
            let mini = mini_text.dropFirst()
            
            let doub_mini = Double(mini) ?? 0.0

            let maxAmt_text = self.maximumAmount.text ?? ""
            let doll_max = maxAmt_text.dropFirst()
            let doub_max = Double(doll_max) ?? 850.0
            
            if doub_max < doub_mini {
                self.showAlert(title: "Alert", message: "Minimum amount cannot be greater than maximum amount")
            }
            
            else {
                
                self.minimumAmount.text = mini_text
                let doubleValue = Double(mini_text.dropFirst())
                self.rangeSlider.selectedMinValue = doubleValue ?? 0.0
                self.rangeSlider.layoutSubviews()
                
                let min = mini_text.dropFirst()
                
                if self.filterMode == "new"{
                    UserDefaults.standard.set(min, forKey: "temp_order_new_min_amt")
                }
                else if self.filterMode == "closed" {
                    UserDefaults.standard.set(min, forKey: "temp_order_closed_min_amt")
                }
                else if self.filterMode == "failed"{
                    UserDefaults.standard.set(min, forKey: "temp_order_failed_min_amt")
                }
                
                else if self.filterMode == "paid" {
                    UserDefaults.standard.set(min, forKey: "temp_order_paid_min_amt")
                }
                else {
                    UserDefaults.standard.set(min, forKey: "temp_order_refund_min_amt")
                }
            }
        }
        
        maxMenu.dataSource = amount2
        maxMenu.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = maximumAmount
        maxMenu.anchorView = maximumBtn
        
        maxMenu.selectionAction = { index, title in
            self.maxMenu.deselectRow(at: index)
            max_text = title
            
            let max = max_text.dropFirst()
            let doub_max = Double(max) ?? 0.0
            
            let minAmt_text = self.minimumAmount.text ?? ""
            let doll_min = minAmt_text.dropFirst()
            let doub_min = Double(doll_min) ?? 850.0
            
            if doub_min > doub_max {
                self.showAlert(title: "Alert", message: "Maximum amount cannot be less than minimum amount")
            }
            
            else {
              
                self.maximumAmount.text = max_text
                let doubleValue = Double(max_text.dropFirst())
                self.rangeSlider.selectedMaxValue = doubleValue ?? 850.0
                self.rangeSlider.layoutSubviews()
                
                let max = max_text.dropFirst()
                
                if self.filterMode == "new"{
                    UserDefaults.standard.set(max, forKey: "temp_order_new_max_amt")
                    
                }
                else if self.filterMode == "closed" {
                    UserDefaults.standard.set(max, forKey: "temp_order_closed_max_amt")
                    
                }
                else if self.filterMode == "failed"{
                    UserDefaults.standard.set(max, forKey: "temp_order_failed_max_amt")
                    
                }
                else if self.filterMode == "paid" {
                    UserDefaults.standard.set(max, forKey: "temp_order_paid_max_amt")
                }
                else {
                    UserDefaults.standard.set(max, forKey: "temp_order_refund_max_amt")
                }
            }
        }
    }
    
    
    func setTrailingImage() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "down")
        self.minimumAmount.trailingView = imageView
        self.minimumAmount.trailingViewMode = .always
        
        let image2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        image2.image = UIImage(named: "down")
        maximumAmount.trailingView = image2
        maximumAmount.trailingViewMode = .always
        
        let startDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        startDateImage.image = UIImage(named: "date_picker")
        self.startDate.trailingView = startDateImage
        self.startDate.trailingViewMode = .always
        
        let endDateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        endDateImage.image = UIImage(named: "date_picker")
        self.endDate.trailingView = endDateImage
        self.endDate.trailingViewMode = .always
        
        let perDayImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        perDayImage.image = UIImage(named: "date_picker")
        self.perDayDate.trailingView = perDayImage
        self.perDayDate.trailingViewMode = .always
    }
    
    func setOrderType() {
     
        var type = ""
        
        if filterMode == "new" {
            type = UserDefaults.standard.string(forKey: "valid_order_new_order_type") ?? ""

        }
        else if filterMode == "closed" {
            type = UserDefaults.standard.string(forKey: "valid_order_closed_order_type") ?? ""

        }
        else {
            type = UserDefaults.standard.string(forKey: "valid_order_failed_order_type") ?? ""

        }
        
       print(type)
    
        if type == "" {
            let tag = 201
            for i in 201...203 {
                if i == tag {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "select_radio"), for: .normal)
                }
                else {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "unselect_radio"), for: .normal)
                }
            }
        }
    
        else if type == "pickup" {
    
            let tag = 202
            for i in 201...203 {
                if i == tag {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "select_radio"), for: .normal)
                }
                else {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "unselect_radio"), for: .normal)
                }
            }
        }
    
        else {
    
            let tag = 203
            for i in 201...203 {
                if i == tag {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "select_radio"), for: .normal)
                }
                else {
                    let button = view.viewWithTag(i) as! UIButton
                    button.setImage(UIImage(named: "unselect_radio"), for: .normal)
                }
            }
        }
    }

    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        

        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
  
    
    @IBAction func minBtnClick(_ sender: UIButton) {
        minMenu.show()
    }
    
    
    @IBAction func maxBtnClick(_ sender: UIButton) {
        maxMenu.show()
    }
    
    
    @IBAction func orderTypeClick(_ sender: UIButton) {
        
        for i in 201...203 {
            
            if i == sender.tag {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "select_radio"), for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "unselect_radio"), for: .normal)
            }
        }
        
        if filterMode == "new"{
            if sender.tag == 201 {
                UserDefaults.standard.set("", forKey: "temp_order_new_order_type")
            }
            
            else if sender.tag == 202 {
                UserDefaults.standard.set("pickup", forKey: "temp_order_new_order_type")
            }
            
            else {
                UserDefaults.standard.set("delivery", forKey: "temp_order_new_order_type")
            }
        }
        else if filterMode == "closed" {
            if sender.tag == 201 {
                UserDefaults.standard.set("", forKey: "temp_order_closed_order_type")
            }
            
            else if sender.tag == 202 {
                UserDefaults.standard.set("pickup", forKey: "temp_order_closed_order_type")
            }
            
            else {
                UserDefaults.standard.set("delivery", forKey: "temp_order_closed_order_type")
            }
        }
        else {
            if sender.tag == 201 {
                UserDefaults.standard.set("", forKey: "temp_order_failed_order_type")
            }
            
            else if sender.tag == 202 {
                UserDefaults.standard.set("pickup", forKey: "temp_order_failed_order_type")
            }
            
            else {
                UserDefaults.standard.set("delivery", forKey: "temp_order_failed_order_type")
            }
        }
 
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {

        dismissTransition()
    }
    
    
    func dismissTransition() {
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func applyBtn(_ sender: UIButton) {
        
        if customDateView.isHidden {
            
            if filterMode == "new"{
                let temp_start = UserDefaults.standard.string(forKey: "temp_order_new_start_date") ?? ""
                let temp_end = UserDefaults.standard.string(forKey: "temp_order_new_end_date") ?? ""
                
                let temp_min = UserDefaults.standard.string(forKey: "temp_order_new_min_amt") ?? ""
                let temp_max = UserDefaults.standard.string(forKey: "temp_order_new_max_amt") ?? ""
                
                let temp_order = UserDefaults.standard.string(forKey: "temp_order_new_order_type") ?? ""

                
                UserDefaults.standard.set(temp_start, forKey: "valid_order_new_start_date")
                UserDefaults.standard.set(temp_end, forKey: "valid_order_new_end_date")
                
                UserDefaults.standard.set(temp_min, forKey: "valid_order_new_min_amt")
                UserDefaults.standard.set(temp_max, forKey: "valid_order_new_max_amt")
                
                UserDefaults.standard.set(temp_order, forKey: "valid_order_new_order_type")

                
                dismissTransition()
            }
            else if filterMode == "closed" {
                let temp_start = UserDefaults.standard.string(forKey: "temp_order_closed_start_date") ?? ""
                let temp_end = UserDefaults.standard.string(forKey: "temp_order_closed_end_date") ?? ""
                
                let temp_min = UserDefaults.standard.string(forKey: "temp_order_closed_min_amt") ?? ""
                let temp_max = UserDefaults.standard.string(forKey: "temp_order_closed_max_amt") ?? ""
                
                let temp_order = UserDefaults.standard.string(forKey: "temp_order_closed_order_type") ?? ""

                
                UserDefaults.standard.set(temp_start, forKey: "valid_order_closed_start_date")
                UserDefaults.standard.set(temp_end, forKey: "valid_order_closed_end_date")
                
                UserDefaults.standard.set(temp_min, forKey: "valid_order_closed_min_amt")
                UserDefaults.standard.set(temp_max, forKey: "valid_order_closed_max_amt")
                
                UserDefaults.standard.set(temp_order, forKey: "valid_order_closed_order_type")

                
                dismissTransition()
            }
            else if filterMode == "failed"{
                let temp_start = UserDefaults.standard.string(forKey: "temp_order_failed_start_date") ?? ""
                let temp_end = UserDefaults.standard.string(forKey: "temp_order_failed_end_date") ?? ""
                
                let temp_min = UserDefaults.standard.string(forKey: "temp_order_failed_min_amt") ?? ""
                let temp_max = UserDefaults.standard.string(forKey: "temp_order_failed_max_amt") ?? ""
                
                let temp_order = UserDefaults.standard.string(forKey: "temp_order_failed_order_type") ?? ""

                
                UserDefaults.standard.set(temp_start, forKey: "valid_order_failed_start_date")
                UserDefaults.standard.set(temp_end, forKey: "valid_order_failed_end_date")
                
                UserDefaults.standard.set(temp_min, forKey: "valid_order_failed_min_amt")
                UserDefaults.standard.set(temp_max, forKey: "valid_order_failed_max_amt")
                
                UserDefaults.standard.set(temp_order, forKey: "valid_order_failed_order_type")

                
                dismissTransition()
            }
            
            else if filterMode == "paid" {
                let temp_start = UserDefaults.standard.string(forKey: "temp_order_paid_start_date") ?? ""
                let temp_end = UserDefaults.standard.string(forKey: "temp_order_paid_end_date") ?? ""
                
                let temp_min = UserDefaults.standard.string(forKey: "temp_order_paid_min_amt") ?? ""
                let temp_max = UserDefaults.standard.string(forKey: "temp_order_paid_max_amt") ?? ""
                
                UserDefaults.standard.set(temp_start, forKey: "valid_order_paid_start_date")
                UserDefaults.standard.set(temp_end, forKey: "valid_order_paid_end_date")
                
                UserDefaults.standard.set(temp_min, forKey: "valid_order_paid_min_amt")
                UserDefaults.standard.set(temp_max, forKey: "valid_order_paid_max_amt")
                
                dismissTransition()
            }
            
            else {
                let temp_start = UserDefaults.standard.string(forKey: "temp_order_refund_start_date") ?? ""
                let temp_end = UserDefaults.standard.string(forKey: "temp_order_refund_end_date") ?? ""
                
                let temp_min = UserDefaults.standard.string(forKey: "temp_order_refund_min_amt") ?? ""
                let temp_max = UserDefaults.standard.string(forKey: "temp_order_refund_max_amt") ?? ""
                
                UserDefaults.standard.set(temp_start, forKey: "valid_order_refund_start_date")
                UserDefaults.standard.set(temp_end, forKey: "valid_order_refund_end_date")
                
                UserDefaults.standard.set(temp_min, forKey: "valid_order_refund_min_amt")
                UserDefaults.standard.set(temp_max, forKey: "valid_order_refund_max_amt")
                
                dismissTransition()
            }
        }
        
        else {
            
            if startDate.text == "" && endDate.text == "" {
                
            }
            
            else if startDate.text != "" && endDate.text == "" {
                
            }
            
            else {
                
                if filterMode == "new"{
                    
                    let temp_start = UserDefaults.standard.string(forKey: "temp_order_new_start_date") ?? ""
                    let temp_end = UserDefaults.standard.string(forKey: "temp_order_new_end_date") ?? ""
                    
                    let temp_min = UserDefaults.standard.string(forKey: "temp_order_new_min_amt") ?? ""
                    let temp_max = UserDefaults.standard.string(forKey: "temp_order_new_max_amt") ?? ""
                    
                    let temp_order = UserDefaults.standard.string(forKey: "temp_order_new_order_type") ?? ""

                    
                    UserDefaults.standard.set(temp_start, forKey: "valid_order_new_start_date")
                    UserDefaults.standard.set(temp_end, forKey: "valid_order_new_end_date")
                    
                    UserDefaults.standard.set(temp_min, forKey: "valid_order_new_min_amt")
                    UserDefaults.standard.set(temp_max, forKey: "valid_order_new_max_amt")
                    
                    UserDefaults.standard.set(temp_order, forKey: "valid_order_new_order_type")

                    
                    dismissTransition()
                }
                else if filterMode == "closed" {
                    
                    let temp_start = UserDefaults.standard.string(forKey: "temp_order_closed_start_date") ?? ""
                    let temp_end = UserDefaults.standard.string(forKey: "temp_order_closed_end_date") ?? ""
                    
                    let temp_min = UserDefaults.standard.string(forKey: "temp_order_closed_min_amt") ?? ""
                    let temp_max = UserDefaults.standard.string(forKey: "temp_order_closed_max_amt") ?? ""
                    
                    let temp_order = UserDefaults.standard.string(forKey: "temp_order_closed_order_type") ?? ""

                    
                    UserDefaults.standard.set(temp_start, forKey: "valid_order_closed_start_date")
                    UserDefaults.standard.set(temp_end, forKey: "valid_order_closed_end_date")
                    
                    UserDefaults.standard.set(temp_min, forKey: "valid_order_closed_min_amt")
                    UserDefaults.standard.set(temp_max, forKey: "valid_order_closed_max_amt")
                    
                    UserDefaults.standard.set(temp_order, forKey: "valid_order_closed_order_type")

                    
                    dismissTransition()
                }
                else if filterMode == "failed"{
                    let temp_start = UserDefaults.standard.string(forKey: "temp_order_failed_start_date") ?? ""
                    let temp_end = UserDefaults.standard.string(forKey: "temp_order_failed_end_date") ?? ""
                    
                    let temp_min = UserDefaults.standard.string(forKey: "temp_order_failed_min_amt") ?? ""
                    let temp_max = UserDefaults.standard.string(forKey: "temp_order_failed_max_amt") ?? ""
                    
                    let temp_order = UserDefaults.standard.string(forKey: "temp_order_failed_order_type") ?? ""

                    
                    UserDefaults.standard.set(temp_start, forKey: "valid_order_failed_start_date")
                    UserDefaults.standard.set(temp_end, forKey: "valid_order_failed_end_date")
                    
                    UserDefaults.standard.set(temp_min, forKey: "valid_order_failed_min_amt")
                    UserDefaults.standard.set(temp_max, forKey: "valid_order_failed_max_amt")
                    
                    UserDefaults.standard.set(temp_order, forKey: "valid_order_failed_order_type")

                    
                    dismissTransition()
                }
                
                else if filterMode == "paid" {
                    let temp_start = UserDefaults.standard.string(forKey: "temp_order_paid_start_date") ?? ""
                    let temp_end = UserDefaults.standard.string(forKey: "temp_order_paid_end_date") ?? ""
                    
                    let temp_min = UserDefaults.standard.string(forKey: "temp_order_paid_min_amt") ?? ""
                    let temp_max = UserDefaults.standard.string(forKey: "temp_order_paid_max_amt") ?? ""
                    
                    UserDefaults.standard.set(temp_start, forKey: "valid_order_paid_start_date")
                    UserDefaults.standard.set(temp_end, forKey: "valid_order_paid_end_date")
                    
                    UserDefaults.standard.set(temp_min, forKey: "valid_order_paid_min_amt")
                    UserDefaults.standard.set(temp_max, forKey: "valid_order_paid_max_amt")
                    
                    dismissTransition()
                }
                
                else {
                    let temp_start = UserDefaults.standard.string(forKey: "temp_order_refund_start_date") ?? ""
                    let temp_end = UserDefaults.standard.string(forKey: "temp_order_refund_end_date") ?? ""
                    
                    let temp_min = UserDefaults.standard.string(forKey: "temp_order_refund_min_amt") ?? ""
                    let temp_max = UserDefaults.standard.string(forKey: "temp_order_refund_max_amt") ?? ""
                    
                    UserDefaults.standard.set(temp_start, forKey: "valid_order_refund_start_date")
                    UserDefaults.standard.set(temp_end, forKey: "valid_order_refund_end_date")
                    
                    UserDefaults.standard.set(temp_min, forKey: "valid_order_refund_min_amt")
                    UserDefaults.standard.set(temp_max, forKey: "valid_order_refund_max_amt")
                    
                    dismissTransition()
                }
            }
        }
    }
}

extension OrderFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hideType {
            storeFiters.count
        }
        else {
            onlineFiters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leftTable.dequeueReusableCell(withIdentifier: "orderfiltercell", for: indexPath) as! OrderFilterLeftCell
        
        if hideType {
            
            cell.subFilterLbl.text = storeFiters[indexPath.row]
        }
        else {
            cell.subFilterLbl.text = onlineFiters[indexPath.row]
        }
        
        if indexPath.row == selectFilter {
            
            cell.subFilterLbl.font = UIFont(name: "Manrope-Bold", size: 15.0)
            cell.subFilterLbl.textColor = .black
        }
        
        else {
            
            cell.subFilterLbl.font = UIFont(name: "Manrope-Medium", size: 15.0)
            cell.subFilterLbl.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = leftTable.cellForRow(at: indexPath) as! OrderFilterLeftCell
        
        leftTable.deselectRow(at: indexPath, animated: true)
        
        if hideType {
            
            orderTypeView.isHidden = true
            view.endEditing(true)
            
            if indexPath.row == 0 {
                
                customDateView.isHidden = false
                perDayView.isHidden = true
                amountView.isHidden = true
            }
            
            else if indexPath.row == 1 {
                
                customDateView.isHidden = true
                perDayView.isHidden = true
                amountView.isHidden = false
            }
            
            else {
                
                customDateView.isHidden = true
                perDayView.isHidden = false
                amountView.isHidden = true
                
            }
        }
        
        else {
            
            view.endEditing(true)
            if indexPath.row == 0 {
                
                customDateView.isHidden = false
                orderTypeView.isHidden = true
                perDayView.isHidden = true
                amountView.isHidden = true
            }
            
            else if indexPath.row == 1 {
                
                customDateView.isHidden = true
                orderTypeView.isHidden = false
                perDayView.isHidden = true
                amountView.isHidden = true
            }
            
            else if indexPath.row == 2 {
                
                customDateView.isHidden = true
                orderTypeView.isHidden = true
                perDayView.isHidden = true
                amountView.isHidden = false
            }
            
            else {
                
                customDateView.isHidden = true
                orderTypeView.isHidden = true
                perDayView.isHidden = false
                amountView.isHidden = true
            }
        }
        selectFilter = cell.tag
        leftTable.reloadData()
    }
}
    
    
extension OrderFilterViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        
        if minValue > maxValue {
            
        }
        
        else {
            
            minimumAmount.text = "$\(Int(minValue))"
            maximumAmount.text = "$\(Int(maxValue))"
            
            let min = minimumAmount.text?.dropFirst() ?? ""
            let max = maximumAmount.text?.dropFirst() ?? ""
            
            if filterMode == "new"{
                UserDefaults.standard.set(min, forKey: "temp_order_new_min_amt")
                UserDefaults.standard.set(max, forKey: "temp_order_new_max_amt")
            }
            else if filterMode == "closed" {
                UserDefaults.standard.set(min, forKey: "temp_order_closed_min_amt")
                UserDefaults.standard.set(max, forKey: "temp_order_closed_max_amt")
            }
            else if filterMode == "failed"{
                UserDefaults.standard.set(min, forKey: "temp_order_failed_min_amt")
                UserDefaults.standard.set(max, forKey: "temp_order_failed_max_amt")
            }
            
            else if filterMode == "paid" {
                UserDefaults.standard.set(min, forKey: "temp_order_paid_min_amt")
                UserDefaults.standard.set(max, forKey: "temp_order_paid_max_amt")
            }
            else {
                UserDefaults.standard.set(min, forKey: "temp_order_refund_min_amt")
                UserDefaults.standard.set(max, forKey: "temp_order_refund_max_amt")
            }
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

extension OrderFilterViewController {
    
    func openDatePicker(textField: UITextField, tag: Int) {
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if tag == 61 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else if tag == 62 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
         
            if filterMode == "new"{
                UserDefaults.standard.set("0", forKey: "new_per_day")
            }
            else if filterMode == "closed" {
                UserDefaults.standard.set("0", forKey: "closed_per_day")
            }
            else if filterMode == "failed"{
                UserDefaults.standard.set("0", forKey: "failed_per_day")
            }
            else if filterMode == "paid" {
                UserDefaults.standard.set("0", forKey: "paid_per_day")
            }
            else {
                UserDefaults.standard.set("0", forKey: "refund_per_day")
            }
        }
        else if tag == 65 {
            
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
           
            if filterMode == "new"{
                UserDefaults.standard.set("1", forKey: "new_per_day")

            }
            else if filterMode == "closed" {
                UserDefaults.standard.set("1", forKey: "closed_per_day")

            }
            else if filterMode == "failed"{
                UserDefaults.standard.set("1", forKey: "failed_per_day")
            }
            
            else if filterMode == "paid" {
                UserDefaults.standard.set("1", forKey: "paid_per_day")
            }
            else {
                UserDefaults.standard.set("1", forKey: "refund_per_day")
            }
        }
        else {
            print("none")
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
            if activeTextField.tag == 61 {
                checkStartDate(date: datePicker.date)
            }
            else if activeTextField.tag == 62 {
                checkEndDate(date: datePicker.date)
            }
            else {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "MM/dd/yyyy"
                activeTextField.text = dateFormat.string(from: datePicker.date)
                if filterMode == "new"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_start_date")
                }
                else if filterMode == "closed" {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_start_date")
                }
                else if filterMode == "failed"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_start_date")
                }
                
                else if filterMode == "paid"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_start_date")
                }
                else {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_start_date")
                }
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    func checkStartDate(date: Date) {
        print(date)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        print(dateFormat)
     
        
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
                    
                    if filterMode == "new"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_start_date")

                    }
                    else if filterMode == "closed" {
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_start_date")

                    }
                    else if filterMode == "failed"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_start_date")

                    }
                    
                    else if filterMode == "paid"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_start_date")
                    }
                    else {
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_start_date")
                    }
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
                endDate.text = ""
               
                if filterMode == "new"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_start_date")

                }
                else if filterMode == "closed" {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_start_date")

                }
                else if filterMode == "failed"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_start_date")

                }
                
                else if filterMode == "paid"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_start_date")
                }
                else {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_start_date")
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
            
            if filterMode == "new"{
                UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_start_date")

            }
            else if filterMode == "closed" {
                UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_start_date")

            }
            else if filterMode == "failed"{
                UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_start_date")

            }
            
            else if filterMode == "paid"{
                UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_start_date")
            }
            else {
                UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_start_date")
            }
        }
    }
    
    func checkEndDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
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
                       
                        if filterMode == "new"{
                            UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_end_date")

                        }
                        else if filterMode == "closed" {
                            UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_end_date")

                        }
                        else if filterMode == "failed"{
                            UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_end_date")

                        }
                        
                        else if filterMode == "paid"{
                            UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_end_date")
                        }
                        else {
                            UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_end_date")
                        }
                    }
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                  
                    if filterMode == "new"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_end_date")

                    }
                    else if filterMode == "closed" {
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_end_date")

                    }
                    else if filterMode == "failed"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_end_date")

                    }
                    
                    else if filterMode == "paid"{
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_end_date")
                    }
                    else {
                        UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_end_date")
                    }
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
                if filterMode == "new" {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_new_end_date")

                }
                else if filterMode == "closed" {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_closed_end_date")

                }
                else if filterMode == "failed"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_failed_end_date")

                }
                
                else if filterMode == "paid"{
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_paid_end_date")
                }
                else {
                    UserDefaults.standard.set(activeTextField.text, forKey: "temp_order_refund_end_date")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        openDatePicker(textField: activeTextField, tag: activeTextField.tag)
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
}


extension OrderFilterViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}
