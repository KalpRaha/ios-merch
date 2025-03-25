//
//  BulkEditViewController.swift
//  
//
//  Created by Jamaluddin Syed on 2/9/24.
//

import UIKit
import MaterialComponents

class BulkEditViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var nameTextFl: MDCOutlinedTextField!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var radioPriceBtn: UIButton!
    @IBOutlet weak var radioPercentBtn: UIButton!
    
    @IBOutlet weak var quantityTextFl: MDCOutlinedTextField!
    @IBOutlet weak var discountTextFl: MDCOutlinedTextField!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    var bulk_id = ""
    var editvarient = [ProductById]()
    var editBulk = [BulkPricingModel]()
    var price_edit = ""
    var Qty_edit = ""
    
    var edit_p_Title = ""
    var unAssingVar = [String]()
    
    var selectVarient = [BulkVarientModel]()
    var varientNames = [String]()
    
    var varientId = ""
    var selectEmpty = [String]()
    var product_id = ""
    var percent = ""
    var isProd = false
    var prodSelect = true
    
    
    private var isSymbolOnRight = false
    var activeTextField = UITextField()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
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
        
        topView.addBottomShadow()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        createCustomTextField(textField: nameTextFl)
        createCustomTextField(textField: discountTextFl)
        createCustomTextField(textField: quantityTextFl)
        nameTextFl.label.text = "Name"
        
        quantityTextFl.label.text = "Quantity"
        discountTextFl.keyboardType = .numberPad
        quantityTextFl.keyboardType = .numberPad
        
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor =  UIColor(named: "deletBorder")?.cgColor
        deleteBtn.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        
        discountTextFl.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        quantityTextFl.addTarget(self, action: #selector(updateText), for: .editingChanged)
        quantityTextFl.delegate = self
        nameTextFl.addTarget(self, action: #selector(updateText), for: .editingChanged)
        nameTextFl.delegate = self
        
        setupUI()
        
        let price_tap = UITapGestureRecognizer(target: self, action: #selector(priceTap))
        priceLbl.addGestureRecognizer(price_tap)
        priceLbl.isUserInteractionEnabled = true
        price_tap.numberOfTapsRequired = 1
        
        let percent_tap = UITapGestureRecognizer(target: self, action: #selector(percentTap))
        percentLbl.addGestureRecognizer(percent_tap)
        percentLbl.isUserInteractionEnabled = true
        percent_tap.numberOfTapsRequired = 1
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        nameTextFl.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .left
        nameTextFl.addGestureRecognizer(swipeDown)
        
        print(edit_p_Title)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backBtn.isEnabled = true
        getBulkApi()
        
        
    }
    
    func removeVarientsId(id: String) {
        
        for i in 0..<selectVarient.count {
            
            if selectEmpty[i] == id {
                selectEmpty.remove(at: i)
                break
            }
        }
    }
    
    
    
    func getBulkApi() {
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        ApiCalls.sharedCall.getBulkPricingApiCall(merchant_id: id, bulk_pricing_id: bulk_id ) { isSuccess, responseData in
            if isSuccess {
                
                guard let list = responseData["bulk_price"] else {
                    return
                }
                
                self.getBulkResponse(list: list)
                
                guard let var_list = responseData["bulk_price_variants"] else {
                    return
                }
                
                self.getbulkVarient(list: var_list)
                
                guard let unv_list = responseData["all_unassigned_str_vars"] else {
                    return
                }
                
                self.getunassignedVarient(list: unv_list )
                self.verifyUnAssingVarient()
                self.getTitles()
                
                DispatchQueue.main.async {
                    self.scrollHeight.constant = 460 + CGFloat(60 * self.selectVarient.count)
                    self.tableview.reloadData()
                }
            }else{
                print("Api Error")
            }
        }
    }
    
    
    func getBulkResponse(list: Any) {
        
        let bulkid = list as! [String: Any]
        
        
        
        let bulkPName = BulkPricingModel(id: "\(bulkid["id"] ?? "" )",
                                         merchant_id: "\(bulkid["merchant_id"] ?? "")",
                                         product_id: "\(bulkid["product_id"] ?? "")",
                                         bulk_price: "\(bulkid["bulk_price"] ?? "")",
                                         bulk_qty: "\(bulkid["bulk_qty"] ?? "")",
                                         bulk_price_title: "\(bulkid["bulk_price_tittle"] ?? "")",
                                         is_percentage: "\(bulkid["is_percentage"] ?? "")")
        
        
        
        discountTextFl.text = bulkPName.bulk_price
        quantityTextFl.text = bulkPName.bulk_qty
        nameTextFl.text = bulkPName.bulk_price_title
        percent = bulkPName.is_percentage
        print(percent)
        
        
        if percent == "0" {
            radioPriceBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            radioPercentBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
            discountTextFl.label.text = "Discount in Price"
        }else {
            radioPercentBtn.setImage(UIImage(named: "select_radio"), for: .normal)
            radioPriceBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
            discountTextFl.label.text = "Discount in Percent"
        }
    }
    
    
    func getbulkVarient(list: Any){
        let bulk_varient = list as! [[String: Any]]
        
        var  smallVar =  [BulkVarientModel]()
        
        for pricing in bulk_varient{
            let  b_varname  = BulkVarientModel(id: "\(pricing["id"] ?? "" )",
                                               merchant_id: "\(pricing["merchant_id"] ?? "" )",
                                               bulk_pricing_id: "\(pricing["bulk_pricing_id"] ?? "" )",
                                               product_id: "\(pricing["product_id"] ?? "" )",
                                               variant_id: "\(pricing ["variant_id"] ?? "" )")
            smallVar.append(b_varname)
        }
        print(smallVar.count)
        selectVarient = smallVar
    }
    
    func getunassignedVarient(list : Any){
        
        let un_varient = list as! String
        
        unAssingVar.append(un_varient)
        unAssingVar = un_varient.components(separatedBy: ",")
    }
    
    func verifyUnAssingVarient() {
        
        var small = [BulkVarientModel]()
        if unAssingVar[0] == "" {
            
        }
        else {
            
            for index in 0..<unAssingVar.count{
                
                let  b_Name  = BulkVarientModel(id: "", merchant_id: "", bulk_pricing_id: "",
                                                product_id: "", variant_id: unAssingVar[index])
                small.append(b_Name)
            }
            selectVarient.append(contentsOf: small)
            
            print(selectVarient.count)
        }
    }
    
    func getTitles() {
        var smallNames = [String]()
        
        for name in  0..<selectVarient.count{
            
            if editvarient.contains(where: { $0.id == selectVarient[name].variant_id}) {
                
                let index = editvarient.firstIndex(where: { $0.id == selectVarient[name].variant_id}) ?? 0
                
                smallNames.append(editvarient[index].variant)
            }
        }
        varientNames = smallNames
    }
    
    
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 4
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @objc func priceTap() {
        radioPriceBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        radioPercentBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        percent = "0"
        discountTextFl.label.text = "Discount in Price"
        createCustomTextField(textField: discountTextFl)
        discountTextFl.text = ""
    }
    
    @IBAction func priceRbtn(_ sender: Any) {
        priceTap()
    }
    
    @objc func percentTap() {
        radioPriceBtn.setImage(UIImage(named: "unselect_radio"), for: .normal)
        radioPercentBtn.setImage(UIImage(named: "select_radio"), for: .normal)
        percent = "1"
        discountTextFl.label.text = "Discount in Percent"
        createCustomTextField(textField: discountTextFl)
        discountTextFl.text = ""
    }
    
    @IBAction func percentRbtn(_ sender: Any) {
        percentTap()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this deal?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            self.backBtn.isEnabled = false
            self.loadingIndicator.isAnimating = true
            self.deleteApi()
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func deleteApi() {
        ApiCalls.sharedCall.deleteBulkPricingApiCall(id: bulk_id) { isSuccess, responseData in
            
            if isSuccess {
                
                ToastClass.sharedToast.showToast(message: "Bulk Price deleted Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingIndicator.isAnimating = false
                    let viewcontrollerArray = self.navigationController?.viewControllers
                    var destiny = 4
                    
                    if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                        destiny = destinationIndex
                    }
                    self.backBtn.isEnabled = true
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                }
            }
            else{
                print("Api Error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = nameTextFl.text, name != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Deal name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            nameTextFl.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let disc = discountTextFl.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Valid Discount Price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountTextFl.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let qty = quantityTextFl.text, qty != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            quantityTextFl.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let numTitle = Int(qty) ?? 0
        
        if numTitle  < 1 {
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)

        }
        else {
            
            var select = ""
            
            if isProd {
                
                if prodSelect {
                    select = product_id
                    callUpdate(id: id, isvarient: "0", select: select, name: name, qty: qty, disc: disc)
                } else {
                    ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
            }
            else {
                
                if selectEmpty.count == 0 {
                    ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    
                } else {
                    
                    select = selectEmpty.joined(separator: ",")
                    callUpdate(id: id, isvarient: "1", select: select, name: name, qty: qty, disc: disc)
                    
                }
            }
        }
    }
    
    func callUpdate(id: String, isvarient: String, select: String, name: String, qty: String, disc: String) {
        
        
        self.loadIndicator.isAnimating = true
        backBtn.isEnabled = false
        
        ApiCalls.sharedCall.updateBulkPricingApiCall(merchant_id: id, bulk_pricing_id: bulk_id,
                                                     product_id: product_id, is_variant: isvarient, variant_id: select,
                                                     bulk_price_title: name, bulk_qty: qty, bulk_price: disc,
                                                     is_percentage: percent) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: "Bulk Pricing Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadIndicator.isAnimating = false
                    
                    let viewcontrollerArray = self.navigationController?.viewControllers
                    var destiny = 0
                    
                    if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                        destiny = destinationIndex
                    }
                    self.backBtn.isEnabled = true
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                }
            }
            else{
                print("Api Error")
                self.loadIndicator.isAnimating = false
                
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

            if let swipeGesture = gesture as? UISwipeGestureRecognizer {

                switch swipeGesture.direction {
                case .right:
                    print("Swiped right")
                    if gesture.state == UIGestureRecognizer.State.ended {
                        let endTap = gesture.location(in: view)
                        let arbitraryValue = nameTextFl.closestPosition(to: endTap)
                        nameTextFl.selectedTextRange = nameTextFl.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    }
                case .left:
                    print("Swiped left")
                    if gesture.state == UIGestureRecognizer.State.ended {
                        let endTap = gesture.location(in: view)
                        let arbitraryValue = nameTextFl.closestPosition(to: endTap)
                        nameTextFl.selectedTextRange = nameTextFl.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    }
                default:
                    let endTap = gesture.location(in: view)
                    let arbitraryValue = nameTextFl.closestPosition(to: endTap)
                    nameTextFl.selectedTextRange = nameTextFl.textRange(from: arbitraryValue!, to: arbitraryValue!)
                    break
                }
            }
        }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
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
        
        
        deleteBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: deleteBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: deleteBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        updateBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: updateBtn.centerXAnchor, constant: 45),
            loadIndicator.centerYAnchor
                .constraint(equalTo: updateBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
}

extension BulkEditViewController : UITextFieldDelegate {
    
    
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
        
        if percent == "0" {
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            if Double(cleanedAmount) ?? 00000 > 9999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
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
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == nameTextFl {
            if updatetext.count > 50 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        if textField == quantityTextFl  {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == quantityTextFl {
           activeTextField = textField
        }
        
    }
}

extension BulkEditViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectVarient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulkEditTableViewCell", for: indexPath) as! BulkEditTableViewCell
        cell.imageWidth.constant = 0
        cell.selectionStyle = .none
        
        cell.imageCheck.image = UIImage(named: "greencheck")
        
        if editvarient.count == 0 {
            cell.variLbl.text = edit_p_Title
           isProd = true
            
        }else {
            cell.variLbl.text = varientNames[indexPath.row]
            isProd = false
        }
        
        if selectVarient[indexPath.row].id == "" {
            cell.imageCheck.isHidden = true
            cell.imageWidth.constant = 0
            cell.variLbl.textColor = UIColor(named: "varLbl")
        } else {
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLbl.textColor = UIColor.black
            selectEmpty.append(selectVarient[indexPath.row].variant_id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as!  BulkEditTableViewCell
        cell.imageCheck.image = UIImage(named: "greencheck")
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cell.imageCheck.isHidden {
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLbl.textColor = UIColor.black
            
            if editvarient.count == 0 {
                prodSelect = true
            } else {
                selectEmpty.append(selectVarient[indexPath.row].variant_id)
            }
        }
        else {
            cell.imageCheck.isHidden = true
            cell.imageWidth.constant = 0
            cell.variLbl.textColor = UIColor(named: "varLbl")
            
            if editvarient.count == 0 {
                prodSelect = false
            } else {
                let id = selectVarient[indexPath.row].variant_id
                removeVarientsId(id: id)
                print(id)
            }
        }
    }
}




struct BulkVarientModel {
    var id: String
    var merchant_id: String
    var bulk_pricing_id : String
    var product_id: String
    var variant_id : String
    
}
