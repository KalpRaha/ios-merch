//
//  AddBusinessHoursViewController.swift
//  
//
//  Created by Jamaluddin Syed on 27/02/23.
//

import UIKit
import MaterialComponents
import LabelSwitch
import Alamofire

class AddBusinessHoursViewController: UIViewController, LabelSwitchDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addHoursBtn: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addHoursView: UIView!
    
    @IBOutlet weak var aboveHrsView: UIView!
    @IBOutlet weak var textStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var verticalStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addStack: UIStackView!
    
    var activeTextField = UITextField()
    var openTime1 = MDCOutlinedTextField()
    var closeTime1 = MDCOutlinedTextField()
    var openTime2 = MDCOutlinedTextField()
    var closeTime2 = MDCOutlinedTextField()
    var labelSwitch = LabelSwitch()
    var viewControl: SetupBusinessHoursViewController?
    var delete_btn1: UIButton?
    var delete_btn2: UIButton?
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let timeArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                     11, 12, 13, 14, 15, 16, 17, 18, 19,
                     20, 21, 22, 23]
    
    @IBOutlet weak var verticalTrailingCons: NSLayoutConstraint!
    
    @IBOutlet weak var verticalLeadingCons: NSLayoutConstraint!
    
    
    var delete_click = 0

    let leftSwipe = LabelSwitchConfig(text: "Open",
                                      textColor: .white,
                                      font: UIFont.systemFont(ofSize: 15),
                                      backgroundColor: UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0))
    
    let rightSwipe = LabelSwitchConfig(text: "Close",
                                       textColor: .white,
                                       font: UIFont(name: "Manrope-Medium", size: 15.0)!,
                                       backgroundColor: .black)
    
    //var constraint: NSLayoutConstraint?
    
    var setup: AddHours?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekLabel.text = setup?.week
        
        addHoursBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addHoursBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addHoursBtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        addHoursView.layer.borderColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
        addHoursView.layer.borderWidth = 1.0
        
        addHoursView.layer.cornerRadius = 10
        addHoursView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        saveBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
    
        setupFields()
        setupSwitch()
        
        print(setup)
        
       
        
        let tapKey = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        aboveHrsView.addGestureRecognizer(tapKey)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setupWhiteUI()
    }
    
    func setupFields() {
        
        openTime1.label.text = "Open Time"
        openTime1.delegate = self
        createCustomTextField(textField: openTime1)
        
        closeTime1.label.text = "Close Time"
        closeTime1.delegate = self
        createCustomTextField(textField: closeTime1)
        
        textStack.addArrangedSubview(openTime1)
        textStack.addArrangedSubview(closeTime1)
        
        openTime1.tag = 11
        closeTime1.tag = 12
        openTime2.tag = 13
        closeTime2.tag = 14
        
        if setup?.textCount == "0" {
            addHoursBtn.setTitle("Add Hours", for: .normal)
            addHoursBtn.setImage(UIImage(named: "Add_Button"), for: .normal)
            addHoursBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            addHoursBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            addHoursBtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            verticalStackHeight.constant = 50
            
            openTime2.isHidden = true
            closeTime2.isHidden = true
            
            openTime1.text = setup?.start_time_1
            closeTime1.text = setup?.end_time_1
        }
        else {
            addHoursBtn.setTitle("Delete", for: .normal)
            addHoursBtn.setImage(nil, for: .normal)
            verticalStackHeight.constant = 130
            addMultipleTime()
            
            openTime1.text = setup?.start_time_1
            closeTime1.text = setup?.end_time_1
            openTime2.text = setup?.start_time_2
            closeTime2.text = setup?.end_time_2
        }
    }
    
    func setupSwitch() {
        
        labelSwitch = LabelSwitch(center: CGPoint(x: addHoursView!.bounds.size.width - 50, y: 27), leftConfig: leftSwipe, rightConfig: rightSwipe)
        labelSwitch.fullSizeTapEnabled = true
        labelSwitch.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        addHoursView?.addSubview(labelSwitch)
        
        labelSwitch.delegate = self
        
        if setup?.is_holiday == "0" {
            labelSwitch.curState = .R
        }
        else {
            labelSwitch.curState = .L
        }
    }
    
    func switchChangToState(sender: LabelSwitch) {
        
        switch sender.curState {
        case .L:
            print("left state")
        case .R:
            print("right state")
        }
    }
    
    func addMultipleTime() {
        
        openTime2.label.text = "Open Time"
        openTime2.delegate = self
        createCustomTextField(textField: openTime2)
        
        closeTime2.label.text = "Close Time"
        closeTime2.delegate = self
        createCustomTextField(textField: closeTime2)
        
        openTime2.isHidden = false
        closeTime2.isHidden = false

        addStack.addArrangedSubview(openTime2)
        addStack.addArrangedSubview(closeTime2)
        
    }
    
    func setupApi(start_time_1: String, end_time_1: String, start_time_2: String, end_time_2: String) {
        
        let url = AppURLs.UPDATE_BUSINESS_HOURS

        let day_1 = setup?.week
        let open_hour_1 = start_time_1
        let close_hour_1 = end_time_1
        let day_code_1 = setup?.day_code
        
        var is_close_1 = ""
        let multiple_time_1 = "0"
        
        var day_2 = ""
        var open_hour_2 = ""
        var close_hour_2 = ""
        var day_code_2 = ""
        
        var is_close_2 = ""
        var multiple_time_2 = ""
        
        if labelSwitch.curState == .L {
            is_close_1 = "1"
        }
        
        else {
            is_close_1 = "0"
        }
        
        if openTime2.isHidden {
            day_2 = ""
            open_hour_2 = ""
            close_hour_2 = ""
            multiple_time_2 = ""
            is_close_2 = ""
            day_code_2 = ""
        }
        else {
            day_2 = setup!.week
            open_hour_2 = start_time_2
            close_hour_2 = end_time_2
            is_close_2 = is_close_1
            multiple_time_2 = "1"
            day_code_2 = setup!.day_code
        }
        
        
        let parameters: [String:Any] = [
            "merchant_id": setup!.merchant_id,
            "day[0]" : day_1!,
            "open_hr[0]": open_hour_1,
            "close_hr[0]": close_hour_1,
            "is_close[0]": is_close_1,
            "multiple_time[0]": multiple_time_1,
            "day_code[0]": day_code_1!,
            "day[1]": day_2,
            "open_hr[1]": open_hour_2,
            "close_hr[1]": close_hour_2,
            "is_close[1]": is_close_2,
            "multiple_time[1]": multiple_time_2,
            "day_code[1]": day_code_2
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func validateParameters() {
        
        guard let start_time_1 = openTime1.text else {
            openTime1.isError(numberOfShakes: 3, revert: true)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(UIImage(named: "warning"), for: .normal)
            openTime1.trailingView = button
            openTime1.trailingViewMode = .always
            button.addTarget(self, action: #selector(startTime1), for: .touchUpInside)
            return
        }
        
        if openTime2.isHidden {
            
            guard let end_time_1 = closeTime1.text,
                  check_End_Time(start_time_1: start_time_1, end_time_1: end_time_1, start_time_2: "") else {
                closeTime1.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                closeTime1.trailingView = button
                closeTime1.trailingViewMode = .always
                button.addTarget(self, action: #selector(endTime1), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: closeTime1)
            
            setupApi(start_time_1: start_time_1, end_time_1: end_time_1, start_time_2: "", end_time_2: "")
        }
        
        else {
            
            guard let start_time_2 = openTime2.text, start_time_2 != "" else {
                openTime2.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                openTime2.trailingView = button
                openTime2.trailingViewMode = .always
                button.addTarget(self, action: #selector(startTime2), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: openTime2)
            
            guard let end_time_2 = closeTime2.text, end_time_2 != "" else {
                closeTime2.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                closeTime2.trailingView = button
                closeTime2.trailingViewMode = .always
                button.addTarget(self, action: #selector(endTime2), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: closeTime2)
            
            guard let end_time_1 = closeTime1.text,
                  check_End_Time(start_time_1: start_time_1, end_time_1: end_time_1, start_time_2: openTime2.text!) else {
                closeTime1.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                closeTime1.trailingView = button
                closeTime1.trailingViewMode = .always
                button.addTarget(self, action: #selector(endTime1), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: closeTime1)
                
            guard check_Start_Time(start_time_2: start_time_2, end_time_1: end_time_1, end_time_2: end_time_2) else {
                openTime2.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                openTime2.trailingView = button
                openTime2.trailingViewMode = .always
                button.addTarget(self, action: #selector(startTime2), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: openTime2)
            
            guard checkEnd_Time(start_time_2: start_time_2, end_time_2: end_time_2, start_time_1: start_time_1) else {
                closeTime2.isError(numberOfShakes: 3, revert: true)
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                button.setImage(UIImage(named: "warning"), for: .normal)
                closeTime2.trailingView = button
                closeTime2.trailingViewMode = .always
                button.addTarget(self, action: #selector(endTime2), for: .touchUpInside)
                return
            }
            
            createCustomTextField(textField: closeTime2)
        
            setupApi(start_time_1: start_time_1, end_time_1: end_time_1, start_time_2: start_time_2, end_time_2: end_time_2)
        }
        
        self.loadIndicator.isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true)
            self.viewControl?.blackView.isHidden = true
            self.loadIndicator.isAnimating = false
            self.viewControl?.setupApi()
        }
    }
    
    @objc func startTime1() {
        
        showAlert(title: "Alert", message: "Please enter valid start time")
    }
    
    @objc func endTime1() {
        
        showAlert(title: "Alert", message: "Please enter valid end time")
    }
    
    @objc func startTime2() {
        
        showAlert(title: "Alert", message: "Please enter valid start time")
    }
    
    @objc func endTime2() {
        
        showAlert(title: "Alert", message: "Please enter valid end time")
    }
    
    
    
    
    func check_End_Time(start_time_1: String, end_time_1: String, start_time_2: String) -> Bool{
        
        let start_prefix = Int(start_time_1.prefix(2))
        let end_prefix = Int(end_time_1.prefix(2))
        
        let start_suffix = start_time_1.suffix(2)
        let end_suffix = end_time_1.suffix(2)
        
        let open_prefix = Int(start_time_2.prefix(2))
        let open_suffix = start_time_2.suffix(2)
        
        
        if openTime2.isHidden {
            
            if timeArray.firstIndex(of: start_prefix!)! < timeArray.firstIndex(of: end_prefix!)! {
                
                return true
            }
            
            else if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! {
                
                if Int(start_suffix)! < Int(end_suffix)! {
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
            
            if timeArray.firstIndex(of: start_prefix!)! < timeArray.firstIndex(of: end_prefix!)! &&
                timeArray.firstIndex(of:end_prefix!)! < timeArray.firstIndex(of:open_prefix!)! {
                
                return true
            }
            
            else if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! ||
                        timeArray.firstIndex(of:end_prefix!)! == timeArray.firstIndex(of:open_prefix!)! {
                
                if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! {
                    
                    if Int(start_suffix)! < Int(end_suffix)! {
                        return true
                    }
                    else {
                        return false
                    }
                }
                
                else {
                    if Int(end_suffix)! < Int(open_suffix)! {
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
            else {
                return false
            }
        }
    }
    
    func check_Start_Time(start_time_2: String, end_time_1: String, end_time_2: String) -> Bool {
        
        let start_prefix = Int(start_time_2.prefix(2))
        let end_prefix = Int(end_time_1.prefix(2))
        let open_prefix = Int(end_time_2.prefix(2))
        
        let start_suffix = start_time_2.suffix(2)
        let end_suffix = end_time_1.suffix(2)
        let open_suffix = end_time_2.suffix(2)
        
        if timeArray.firstIndex(of: start_prefix!)! > timeArray.firstIndex(of: end_prefix!)! &&
            timeArray.firstIndex(of: start_prefix!)! < timeArray.firstIndex(of: open_prefix!)! {
            
            return true
        }
        
        else if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! ||
                    timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: open_prefix!)! {
            
            if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! {
                
                if Int(start_suffix)! > Int(end_suffix)! {
                    return true
                }
                else {
                    return false
                }
            }
            
            else {
                if Int(start_suffix)! < Int(open_suffix)! {
                    return true
                }
                else {
                    return false
                }
            }
        }
        else {
            return false
        }
    }
    
    
    func checkEnd_Time(start_time_2: String, end_time_2: String, start_time_1: String) -> Bool {
        
        let start_prefix = Int(start_time_2.prefix(2))
        let end_prefix = Int(end_time_2.prefix(2))
        let open_prefix = Int(start_time_1.prefix(2))
        
        let start_suffix = start_time_2.suffix(2)
        let end_suffix = end_time_2.suffix(2)
        let open_suffix = start_time_1.suffix(2)
        
        if timeArray.firstIndex(of: start_prefix!)! < timeArray.firstIndex(of: end_prefix!)! {
            
            return true
        }
        
        else if timeArray.firstIndex(of: start_prefix!)! == timeArray.firstIndex(of: end_prefix!)! {
        
            if Int(start_suffix)! < Int(end_suffix)! {
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
    
    
    @IBAction func addHoursClick(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Add Hours" {
            addMultipleTime()
            sender.setTitle("Delete", for: .normal)
            sender.setImage(nil, for: .normal)
            verticalStackHeight.constant = 130
        }
        
        else if sender.titleLabel?.text == "Delete" {
            
           
            verticalStack.alignment = .leading
            verticalLeadingCons.constant = -40
            verticalTrailingCons.constant = -40
            
            delete_btn1 = UIButton(frame: CGRect(x: view.bounds.size.width - 50, y: 105, width: 40, height: 40))
            delete_btn1!.setImage(UIImage(named: "blue_delete"), for: .normal)
            delete_btn1!.addTarget(self, action: #selector(deleteClick1), for: .touchUpInside)
            addHoursView.addSubview(delete_btn1!)
            
            delete_btn2 = UIButton(frame: CGRect(x: view.bounds.size.width - 50, y: 175, width: 40, height: 40))
            delete_btn2!.setImage(UIImage(named: "blue_delete"), for: .normal)
            delete_btn2!.addTarget(self, action: #selector(deleteClick2), for: .touchUpInside)
            addHoursView.addSubview(delete_btn2!)
            
            sender.setTitle("Cancel", for: .normal)
            
        }
        
        else {
            //            verticalStack.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //            constraint?.constant = 10
            
            sender.setTitle("Add Hours", for: .normal)
            addHoursBtn.setImage(UIImage(named: "Add_Button"), for: .normal)
            sender.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            sender.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            sender.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

            verticalLeadingCons.constant = 10
            verticalTrailingCons.constant = 10
            textStack.transform = CGAffineTransform(translationX: 2.0, y: 0.0)
            addStack?.transform = CGAffineTransform(translationX: 2.0, y: 0.0)

            delete_btn1?.isHidden = true
            delete_btn2?.isHidden = true
            
        }
    }
    
    func removeFromStack(tag: Int) {
        
        if tag == 0 {
            print("first delete")
            delete_click = 1
        }
        
        else {
            print("second delete")
            delete_click = 2
        }
        
        openTime2.text = ""
        closeTime2.text = ""
        
        addStack.removeArrangedSubview(openTime2)
        addStack.removeArrangedSubview(closeTime2)
        openTime2.isHidden = true
        closeTime2.isHidden = true
        delete_btn2?.isHidden = true
        verticalStackHeight.constant = 50
        
        verticalStack.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        textStack.transform = CGAffineTransform(translationX: 2.0, y: 0.0)
        addStack?.transform = CGAffineTransform(translationX: 2.0, y: 0.0)
        delete_btn1?.isHidden = true
        delete_btn2?.isHidden = true
        
        addHoursBtn.setTitle("Add Hours", for: .normal)
        addHoursBtn.setImage(UIImage(named: "Add_Button"), for: .normal)
        addHoursBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addHoursBtn.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        addHoursBtn.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        
    }
    
    @objc func deleteClick1() {
        
        removeFromStack(tag: 0)
        verticalLeadingCons.constant = 10
        verticalTrailingCons.constant = 10
        
    }
    
    @objc func deleteClick2() {
        removeFromStack(tag: 1)
        verticalLeadingCons.constant = 10
        verticalTrailingCons.constant = 10
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        validateParameters()
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true)
        
        viewControl?.blackView.isHidden = true
        
    }
    
    @objc func dismissKey() {
        self.dismiss(animated: true)
        self.viewControl?.blackView.isHidden = true
    }
}
    
extension AddBusinessHoursViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(.black, for: .normal)
        textField.setFloatingLabelColor(.black, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "alarm"), for: .normal)
        textField.trailingView = button
        textField.trailingViewMode = .always
    }
    
    
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset.bottom = contentInset.bottom + 100
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        
    }
}

extension AddBusinessHoursViewController  {
    
    func openDatePicker(textField: UITextField, tag: Int) {
        
        let datePicker = UIDatePicker()
        var doneBtn = UIBarButtonItem()
        if activeTextField == openTime1 {
            datePicker.datePickerMode = .time
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else if activeTextField == closeTime1 {
            datePicker.datePickerMode = .time
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dateDoneBtn))
        }
        else if activeTextField == openTime2 {
            datePicker.datePickerMode = .time
            doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeDoneBtn))
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
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClick))
        let flexibleBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelBtn, doneBtn, flexibleBtn], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancelBtnClick(textfield: UITextField) {
        activeTextField.resignFirstResponder()
    }
    
    @objc func datePickerHandler(datePicker: UIDatePicker) {
        print(datePicker.date)
    }
    
    @objc func dateDoneBtn() {
        
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField == openTime1 {
                checkStartTime(time: datePicker.date)
            }
            else {
                checkEndTime(time: datePicker.date)
            }
            activeTextField.resignFirstResponder()
        }
    }
    
    @objc func timeDoneBtn() {
        if let datePicker = activeTextField.inputView as? UIDatePicker{
            if activeTextField == openTime2 {
                checkExtraStartTime(time: datePicker.date)
            }
            else {
                checkExtraEndTime(time: datePicker.date)
            }
            activeTextField.resignFirstResponder()
        }
    }
    
    func checkStartTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm aa"
        let starttime = dateFormat.string(from: time)
        print(starttime)
        
        let start = starttime.suffix(2)
        print(start)
        
        if start == "PM" {
            let hours = starttime.prefix(2)
            let hoursInt = Int(hours)!
            var hoursString = "12"
            if hoursInt != 12 {
                let hours = 12 + hoursInt
                hoursString = "\(hours)"
            }
            dateFormat.dateFormat = ":mm"
            activeTextField.text = "\(hoursString)\(dateFormat.string(from: time))"
        }
        
        else if start == "AM" {
            let hours = starttime.prefix(2)
            let hoursInt = Int(hours)!
            let hours12 = "00"
            if hoursInt == 12 {
                dateFormat.dateFormat = ":mm"
                activeTextField.text = "\(hours12)\(dateFormat.string(from: time))"
            }
            
            else {
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = dateFormat.string(from: time)
            }
            
        }
        
        else {
            dateFormat.dateFormat = "hh:mm"
            activeTextField.text = dateFormat.string(from: time)
        }
    }
    
    func checkEndTime(time: Date) {
        
        if openTime1.text == "" {
            showAlert(title: "Alert", message: "Start Time not set, Please set a start time first.")
        }
        else {
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm aa"
            let starttime = dateFormat.string(from: time)
            print(starttime)
            
            let start = starttime.suffix(2)
            print(start)
            
            if start == "PM" {
                let hours = starttime.prefix(2)
                let hoursInt = Int(hours)!
                var hoursString = "12"
                if hoursInt != 12 {
                    let hours = 12 + hoursInt
                    hoursString = "\(hours)"
                }
                dateFormat.dateFormat = ":mm"
                activeTextField.text = "\(hoursString)\(dateFormat.string(from: time))"
            }
            
            else if start == "AM" {
                let hours = starttime.prefix(2)
                let hoursInt = Int(hours)!
                let hours12 = "00"
                if hoursInt == 12 {
                    dateFormat.dateFormat = ":mm"
                    activeTextField.text = "\(hours12)\(dateFormat.string(from: time))"
                }
                
                else {
                    dateFormat.dateFormat = "hh:mm"
                    activeTextField.text = dateFormat.string(from: time)
                }
                
            }
            
            else {
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = dateFormat.string(from: time)
            }
        }
    }
    
    func checkExtraStartTime(time: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm aa"
        let starttime = dateFormat.string(from: time)
        print(starttime)
        
        let start = starttime.suffix(2)
        print(start)
        
        if start == "PM" {
            let hours = starttime.prefix(2)
            let hoursInt = Int(hours)!
            var hoursString = "12"
            if hoursInt != 12 {
                let hours = 12 + hoursInt
                hoursString = "\(hours)"
            }
            dateFormat.dateFormat = ":mm"
            activeTextField.text = "\(hoursString)\(dateFormat.string(from: time))"
        }
        
        else if start == "AM" {
            let hours = starttime.prefix(2)
            let hoursInt = Int(hours)!
            let hours12 = "00"
            if hoursInt == 12 {
                dateFormat.dateFormat = ":mm"
                activeTextField.text = "\(hours12)\(dateFormat.string(from: time))"
            }
            
            else {
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = dateFormat.string(from: time)
            }
            
        }
        
        else {
            dateFormat.dateFormat = "hh:mm"
            activeTextField.text = dateFormat.string(from: time)
        }
    }
    
    func checkExtraEndTime(time: Date) {
        
        if openTime2.text == "" {
            showAlert(title: "Alert", message: "Start Time not set, Please set a start time first.")
        }
        else {
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm aa"
            let starttime = dateFormat.string(from: time)
            print(starttime)
            
            let start = starttime.suffix(2)
            print(start)
            
            if start == "PM" {
                let hours = starttime.prefix(2)
                let hoursInt = Int(hours)!
                var hoursString = "12"
                if hoursInt != 12 {
                    let hours = 12 + hoursInt
                    hoursString = "\(hours)"
                }
                dateFormat.dateFormat = ":mm"
                activeTextField.text = "\(hoursString)\(dateFormat.string(from: time))"
            }
            
            else if start == "AM" {
                let hours = starttime.prefix(2)
                let hoursInt = Int(hours)!
                let hours12 = "00"
                if hoursInt == 12 {
                    dateFormat.dateFormat = ":mm"
                    activeTextField.text = "\(hours12)\(dateFormat.string(from: time))"
                }
                
                else {
                    dateFormat.dateFormat = "hh:mm"
                    activeTextField.text = dateFormat.string(from: time)
                }
                
            }
            
            else {
                dateFormat.dateFormat = "hh:mm"
                activeTextField.text = dateFormat.string(from: time)
            }
            
        }
    }
}

extension AddBusinessHoursViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        openDatePicker(textField: activeTextField, tag: activeTextField.tag)
    }
}

extension AddBusinessHoursViewController {
    
    private func setupWhiteUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        saveBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(35)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: loadIndicator.widthAnchor)
        ])
    }
}

struct AddHours{
    
    let merchant_id: String
    let textCount: String
    let week: String
    let start_time_1: String
    let end_time_1: String
    let start_time_2: String
    let end_time_2: String
    let day_code: String
    let is_holiday: String
}
