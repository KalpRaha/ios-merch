//
//  BulkPricingViewController.swift
//
//  Created by Jamaluddin Syed on 2/9/24.
//

import UIKit
import MaterialComponents

class BulkPricingViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bulkTextFL: MDCOutlinedTextField!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    
    var arrofvarients = [ProductById]()
    var varientempty = [String]()
    var activeTextField = UITextField()
    
    var prod = ""
    var bp_price = ""
    var b_qty = ""
    var bprod_id = ""
    var bulk_percetage = ""
    var bulk_unselect = [String]()
    var bulk_unselect_ids = [String]()
    
    var bulk_unselect_names = [String]()
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bulkTextFL.label.text = "Name of Deal"
        topView.addBottomShadow()
        createCustomTextField(textField: bulkTextFL)
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
        doneBtn.layer.cornerRadius = 10
        
        tableview.dataSource = self
        tableview.delegate = self
        
        if bulk_percetage == "0" {
            bulkTextFL.text = "Buy \(b_qty) Get $\(bp_price) off Each"
        }
        else {
            bulkTextFL.text = "Buy \(b_qty) Get \(bp_price)% off Each"
        }
        
        bulkTextFL.addTarget(self, action: #selector(updateText), for: .editingChanged)
        bulkTextFL.delegate = self
        
        setupUI()
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        bulkTextFL.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        bulkTextFL.addGestureRecognizer(swipeDown)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backBtn.isEnabled = true
        cancelBtn.isEnabled = true

        if arrofvarients.count == 0 {
            selectAllBtn.isHidden = true
            scrollHeight.constant = 290
        }else {
            getVarientNames()
            selectAllBtn.isHidden = false
            scrollHeight.constant = 230 + CGFloat(60 * bulk_unselect_names.count)
        }
    }
    
    
    func removeVarientsId(id: String) {
        
        tableview.isHidden = true
        loadIndicator.isAnimating = true
         
        for i in 0..<varientempty.count {
            
            if varientempty[i] == id {
                varientempty.remove(at: i)
                break
            }
        }
       
        tableview.isHidden = false
        loadIndicator.isAnimating = false
    }
    
    func getVarientNames() {
        var small = [String]()
        var smallId = [String]()
        
        for ids in  0..<arrofvarients.count {
            if bulk_unselect.contains(where: {$0 == arrofvarients[ids].id}) {
                small.append(arrofvarients[ids].variant)
                smallId.append(arrofvarients[ids].id)
            }
        }
        
        bulk_unselect_names = small
        bulk_unselect_ids = smallId
    }
  
    
    @IBAction func selectAllBtnClick(_ sender: UIButton) {
        
        if arrofvarients.count == 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
            
            if selectAllBtn.currentTitle == "Select All" {
                cell.imageCheck.isHidden = false
                cell.imageWidth.constant = 26
                cell.variLable.textColor = UIColor.black
                selectAllBtn.setTitle("Unselect All", for: .normal)
            }else  {
                cell.imageCheck.isHidden = true
                cell.imageWidth.constant = 0
                cell.variLable.textColor = UIColor(named: "varLable")
                selectAllBtn.setTitle("Select All", for: .normal)
            }
            
        }
        else{
            for i in 0..<bulk_unselect_names.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
                
                if selectAllBtn.currentTitle == "Select All" {
                    
                    if cell.imageCheck.isHidden {
                        cell.imageCheck.isHidden = false
                        cell.imageWidth.constant = 26
                        cell.variLable.textColor = UIColor.black
                        varientempty.append(bulk_unselect_ids[indexPath.row])
                    }
                    
                    else {
                    }
                }
                else {
                    if cell.imageCheck.isHidden {
                        
                    }
                    else {
                        cell.imageCheck.isHidden = true
                        cell.imageWidth.constant = 0
                        cell.variLable.textColor = UIColor(named: "varLbl")
                        let ids = bulk_unselect_ids[indexPath.row]
                        removeVarientsId(id: ids)
                    }
                }
            }
            
            if selectAllBtn.currentTitle == "Select All" {
                selectAllBtn.setTitle("Unselect All", for: .normal)
            }
            
            else {
                selectAllBtn.setTitle("Select All", for: .normal)

            }
        }
    }
    
    
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        print(bulk_unselect_names.count)
        var exe_add = false
        if arrofvarients.count == 0 {
            
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
            if cell.imageCheck.isHidden {
                exe_add = false
                
            }else {
                exe_add = true
            }
            
        }
        else {
            for i in 0..<bulk_unselect_names.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
                if cell.imageCheck.isHidden == true {
                    exe_add = false
                }
                else {
                    exe_add = true
                    break
                }
            }
        }
        
        if exe_add {
            callAddApi()
        }
        else {
            ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
    }
    
    func callAddApi() {
           
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var empty = ""
        if arrofvarients.count == 0 {
            empty = bprod_id
        }else {
            empty = varientempty.joined(separator: ",")
            
        }
        let bulk_Title = bulkTextFL.text ?? ""
        
        self.loadingIndicator.isAnimating = true
        backBtn.isEnabled = false
        cancelBtn.isEnabled = false
        
        ApiCalls.sharedCall.addBulkPricingApiCall(merchant_id: id, product_id: bprod_id, variant_id: empty, admin_id: id, bulk_price_tittle: bulk_Title, bulk_price: bp_price, bulk_qty: b_qty, is_percentage: bulk_percetage) { isSuccess, responseData in
            
            if isSuccess {
                
                if responseData["message"] as! String == "Failed" {
                    ToastClass.sharedToast.showToast(message: "Name of Deal already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.loadingIndicator.isAnimating = false
                        let viewcontrollerArray = self.navigationController?.viewControllers
                        var destiny = 4
                        
                        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PriceBulkViewController }) {
                            destiny = destinationIndex
                        }
                        self.backBtn.isEnabled = true
                        self.cancelBtn.isEnabled = true
                        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                        
                    }
                    
                } else {
                    let list = responseData["message"]
                    self.getResponseValues(list: list)
                }
                
                
            }else{
                print("Api Error")
            }
        }
        
    }
    
    func getResponseValues(list: Any) {
        let response = list as! String
        print(response)
        ToastClass.sharedToast.showToast(message: "Bulk Pricing Added Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingIndicator.isAnimating = false
            
            let viewcontrollerArray = self.navigationController?.viewControllers
            var destiny = 4
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                destiny = destinationIndex
            }
            self.backBtn.isEnabled = true
            self.cancelBtn.isEnabled = true
            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
    }
    
    
    @IBAction func homebtnClick(_ sender: UIButton) {
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 4
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

            if let swipeGesture = gesture as? UISwipeGestureRecognizer {

                switch swipeGesture.direction {
                case .right:
                    print("Swiped right")
                    if gesture.state == UIGestureRecognizer.State.ended {
                        let endTap = gesture.location(in: view)
                        let arbitraryValue = bulkTextFL.closestPosition(to: endTap)
                        bulkTextFL.selectedTextRange = bulkTextFL.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    }
                case .left:
                    print("Swiped left")
                    if gesture.state == UIGestureRecognizer.State.ended {
                        let endTap = gesture.location(in: view)
                        let arbitraryValue = bulkTextFL.closestPosition(to: endTap)
                        bulkTextFL.selectedTextRange = bulkTextFL.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    }
                default:
                    let endTap = gesture.location(in: view)
                    let arbitraryValue = bulkTextFL.closestPosition(to: endTap)
                    bulkTextFL.selectedTextRange = bulkTextFL.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    break
                }
            }
        }

    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 14.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        doneBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: doneBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: doneBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        
        
        tableview.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: tableview.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: tableview.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}

extension BulkPricingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == bulkTextFL {
           activeTextField = textField
        }
        
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == bulkTextFL {
            if updatetext.count > 50 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
        
    }
}
    


extension BulkPricingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrofvarients.count == 0{
            return 1
        } else {
            return bulk_unselect_names.count
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "BulkTableViewCell", for: indexPath)as! BulkTableViewCell
        cell.imageWidth.constant = 0
        cell.selectionStyle = .none
        if bulk_unselect_names.count == 0 {
            cell.variLable.text = prod
            
        }
        else {
            cell.variLable.text = bulk_unselect_names[indexPath.row]
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
        tableview.deselectRow(at: indexPath, animated: true)
        
        if cell.imageCheck.isHidden  {
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLable.textColor = UIColor.black
            if arrofvarients.count > 0 {
                varientempty.append(bulk_unselect_ids[indexPath.row])
            }
        }
        else {
            cell.imageCheck.isHidden = true
            cell.imageWidth.constant = 0
            cell.variLable.textColor = UIColor(named: "varLbl")
            if arrofvarients.count > 0 {
                let ids = bulk_unselect_ids[indexPath.row]
                removeVarientsId(id: ids)
            }
        }
        print(varientempty)
        
        if varientempty.count == bulk_unselect_names.count {
            selectAllBtn.setTitle("Unselect All", for: .normal)
        }
        else {
            selectAllBtn.setTitle("Select All", for: .normal)
        }
    }
}

