//
//  VendorFilterViewController.swift
//  
//
//  Created by Jamaluddin Syed on 27/03/23.
//

import UIKit
import MaterialComponents

class VendorFilterViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var dateRange: UIButton!
    @IBOutlet weak var customRange: UIButton!
    
    @IBOutlet weak var dateOptions: UIView!
    @IBOutlet weak var customOptions: UIView!
    
    @IBOutlet weak var today: UIButton!
    @IBOutlet weak var yesterday: UIButton!
    @IBOutlet weak var last7days: UIButton!
    @IBOutlet weak var thismonth: UIButton!
    
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    @IBOutlet weak var startTime: MDCOutlinedTextField!
    @IBOutlet weak var endTime: MDCOutlinedTextField!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    var mode = 0
    
    var activeTextField = UITextField()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        setDateRangeOptions()
        
        setupField()

        applyBtn.layer.cornerRadius = 10
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.integer(forKey: "vendorDateMode") == 10 {
            setDateOptions()
            dateSelected()

        }
        else {
            setCustomOptions()
        }
    }
    
    
    func setDateRangeOptions() {
        
        dateOptions.isHidden = false
        customOptions.isHidden = true
        
        today.setTitle(" Today", for: .normal)
        yesterday.setTitle(" Yesterday", for: .normal)
        last7days.setTitle(" Last 7 Days", for: .normal)
        thismonth.setTitle(" This Month", for: .normal)
        
        today.setImage(UIImage(named: "select_radio"), for: .normal)
        yesterday.setImage(UIImage(named: "unselect_radio"), for: .normal)
        last7days.setImage(UIImage(named: "unselect_radio"), for: .normal)
        thismonth.setImage(UIImage(named: "unselect_radio"), for: .normal)
                
    }
    
    func setupField() {
        
        startDate.label.text = "Start Date"
        endDate.label.text = "End Date"
        startTime.label.text = "Start Time"
        endTime.label.text = "End Time"
        
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        createCustomTextField(textField: startTime)
        createCustomTextField(textField: endTime)
        
        let date_image_start = UIImageView(image: UIImage(named: "date_picker"))
        startDate.trailingView = date_image_start
        startDate.trailingViewMode = .always
        
        let date_image_end = UIImageView(image: UIImage(named: "date_picker"))
        endDate.trailingView = date_image_end
        endDate.trailingViewMode = .always
        
        let time_image_start = UIImageView(image: UIImage(named: "time_picker"))
        startTime.trailingView = time_image_start
        startTime.trailingViewMode = .always
        
        let time_image_end = UIImageView(image: UIImage(named: "time_picker"))
        endTime.trailingView = time_image_end
        endTime.trailingViewMode = .always
        
        startDate.delegate = self
        endDate.delegate = self
        startTime.delegate = self
        endTime.delegate = self
    }
    
    
    @IBAction func filterModeClick(_ sender: UIButton) {
        
        if sender.tag == 10 {
           setDateOptions()
        }
        
        else {
            setCustomOptions()
        }
    }
    
    func setDateOptions() {
        
        startDate.text = ""
        endDate.text = ""
        startTime.text = ""
        endTime.text = ""
        mode = 0
        UserDefaults.standard.set(10, forKey: "tempVendorDateMode")
        dateRange.setTitleColor(.black, for: .normal)
        customRange.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
        dateRange.titleLabel?.font = UIFont(name: "Manrope-Bold", size: 15.0)
        customRange.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 15.0)
        dateOptions.isHidden = false
        customOptions.isHidden = true
        view.endEditing(true)
    }
    
    func setCustomOptions() {
        
        startDate.text = UserDefaults.standard.string(forKey: "save_vendor_start_date")
        endDate.text = UserDefaults.standard.string(forKey: "save_vendor_end_date")
        startTime.text = ""
        endDate.text = ""
        mode = 1
        UserDefaults.standard.set(20, forKey: "tempVendorDateMode")
        dateRange.setTitleColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0), for: .normal)
        customRange.setTitleColor(.black, for: .normal)
        dateRange.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 15.0)
        customRange.titleLabel?.font = UIFont(name: "Manrope-Bold", size: 15.0)
        dateOptions.isHidden = true
        customOptions.isHidden = false
    }

    
    @IBAction func dateBtnsClick(_ sender: UIButton) {
        
        print(sender.tag)
        for i in 1...4 {
            if i == sender.tag {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "select_radio"), for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "unselect_radio"), for: .normal)
            }
        }
        UserDefaults.standard.set(sender.tag, forKey: "vendorDate")
    }
    
    func dateSelected() {
        
        let buttonSelect = UserDefaults.standard.integer(forKey: "vendorDate")
        
        for i in 1...4 {
            if i == buttonSelect {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "select_radio"), for: .normal)
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.setImage(UIImage(named: "unselect_radio"), for: .normal)
            }
        }
        
        
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func applyBtnClick(_ sender: UIButton) {
        
        if mode == 0 {
            print("date")
            let viewMode = UserDefaults.standard.integer(forKey: "tempVendorDateMode")
            UserDefaults.standard.set(viewMode, forKey: "vendorDateMode")
            let tag = UserDefaults.standard.integer(forKey: "vendorDate")
            getDateTime(tag: tag)
            
        }
        else {
            print("custom")
            
            guard let startDate = startDate.text, startDate != "" else {
                startDate.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            guard let endDate = endDate.text, endDate != "" else {
                endDate.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            let viewMode = UserDefaults.standard.integer(forKey: "tempVendorDateMode")
            UserDefaults.standard.set(viewMode, forKey: "vendorDateMode")
            
            UserDefaults.standard.set("\(startDate)", forKey: "save_vendor_start_date")
            UserDefaults.standard.set("\(endDate)", forKey: "save_vendor_end_date")
                        
            UserDefaults.standard.set("\(startDate) 00:00:00", forKey: "vendor_start_date")
            UserDefaults.standard.set("\(endDate) 23:59:59", forKey: "vendor_end_date")
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    
}

extension VendorFilterViewController {
    
    func getDateTime(tag: Int) {
        
        var startDate = ""
        var endDate = ""
        
        let date = Date()
        let calendar = Calendar.current
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        
        switch tag {
            
        case 1: //Today
            break
        case 2: //yesterday
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -1, to: date)
            startDate = "\(df.string(from: ydate!)) 00:00:00"
            endDate = "\(df.string(from: ydate!)) 23:59:59"
            print("\(startDate) \(endDate)")
            UserDefaults.standard.set(startDate, forKey: "vendor_start_date")
            UserDefaults.standard.set(endDate, forKey: "vendor_end_date")
            break
        case 3: //last 7 days
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -6, to: date)
            startDate = "\(df.string(from: ydate!)) 00:00:00"
            endDate = "\(df.string(from: date)) 23:59:59"
            print("\(startDate) \(endDate)")
            UserDefaults.standard.set(startDate, forKey: "vendor_start_date")
            UserDefaults.standard.set(endDate, forKey: "vendor_end_date")
            break
        case 4 : //this month
            df.dateFormat = "yyyy-MM"
            print("\(df.string(from: date))-01 00:00:00")
            startDate = "\(df.string(from: date))-01 00:00:00"
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            print(df.string(from: date))
            endDate = df.string(from: date)
            print("\(startDate) \(endDate)")
            UserDefaults.standard.set(startDate, forKey: "vendor_start_date")
            UserDefaults.standard.set(endDate, forKey: "vendor_end_date")
            break
        default:
            print("")
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
    
    func openDatePicker(textField: UITextField, tag: Int) {
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if tag < 13 {
            datePicker.datePickerMode = .date
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else {
            datePicker.datePickerMode = .time
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
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
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            if activeTextField.tag == 11 {
                checkStartDate(date: datePicker.date)
            }
            else {
                checkEndDate(date: datePicker.date)
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    @objc func timeDoneBtn() {
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField.tag == 13 {
                checkStartTime(time: datePicker.date)
            }
            else {
                checkEndTime(time: datePicker.date)
            }
            
            
        }
        activeTextField.resignFirstResponder()
    }
    
    
    func checkStartDate(date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        
        let startDay = calendar.component(.day, from: date)
        let startMonth = calendar.component(.month, from: date)
        let startYear = calendar.component(.year, from: date)
        
        let currentDate = Date()
        let currentDay = calendar.component(.day, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        if startYear > currentYear {
            
            showAlert(title: "Alert", message: "Start date cannot be greater than current date")
        }
        
        else if startYear == currentYear {
            
            if startMonth > currentMonth {
                
                showAlert(title: "Alert", message: "Start date cannot be greater than current date")
            }
            
            else if startMonth <= currentMonth {
                
                if startDay > currentDay {
                    
                    showAlert(title: "Alert", message: "Start date cannot be greater than current date")
                }
                
                else {
                    activeTextField.text = dateFormat.string(from: date)
                    endDate.text = ""
                    UserDefaults.standard.set(activeTextField.text, forKey: "vendor_start_date")
                }
            }
        }
            
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
            UserDefaults.standard.set(activeTextField.text, forKey: "vendor_start_date")
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
                
                else if endMonth >= startMonth {
                    
                    if endDay < startDay {
                        
                        showAlert(title: "Alert", message: "End date cannot be earlier than start date")
                    }
                    
                    else {
                        activeTextField.text = dateFormat.string(from: date)
                        UserDefaults.standard.set(activeTextField.text, forKey: "vendor_end_date")
                    }
                }
            }
            else {
                activeTextField.text = dateFormat.string(from: date)
                UserDefaults.standard.set(activeTextField.text, forKey: "vendor_end_date")
            }
        }
    }
    
    func checkStartTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        activeTextField.text = dateFormat.string(from: time)
    }
    
    func checkEndTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        activeTextField.text = dateFormat.string(from: time)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        openDatePicker(textField: activeTextField, tag: activeTextField.tag)
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}
