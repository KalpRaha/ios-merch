//
//  CreateBOGODealViewController.swift
//
//
//  Created by Pallavi on 28/01/25.
//

import UIKit
import MaterialComponents

protocol AddBogoDelegate: AnyObject {
    
    func setSelectedBogoVarient(mix: [VariantBogoModel])
}

class CreateBOGODealViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var noEndDateSwitch: UISwitch!
    
    @IBOutlet weak var dealNameTextfield: MDCOutlinedTextField!
    @IBOutlet weak var describeDealTextfield: UITextField!
    @IBOutlet weak var qtyTextfield: MDCOutlinedTextField!
    @IBOutlet weak var discountQtyTextfield: MDCOutlinedTextField!
    @IBOutlet weak var discountperItemTextfield: MDCOutlinedTextField!
    @IBOutlet weak var startDate: MDCOutlinedTextField!
    @IBOutlet weak var endDate: MDCOutlinedTextField!
    
    @IBOutlet weak var AddVarientBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    @IBOutlet weak var dollerBtn: UIButton!
    
    @IBOutlet weak var startEndDateStack: UIStackView!
    @IBOutlet weak var dateStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var createTitle: UILabel!
    
    @IBOutlet weak var viewsview: UIView!
        
    private var isSymbolOnRight = false
    
    var mode = ""
    var noEndDate = ""
    var discount_type = ""
    var dollarAmt = ""
    var bogo_id = ""
    
    var searching = false
    var bogoObj : BogoModel?
    
    var bogo_mix_exist_ids = [String]()
    var itemsEditIds = ""
    
    var variantArray = [VariantBogoModel]()
    var subvarArray =  [VariantBogoModel]()
    var searchVarArray = [VariantBogoModel]()
    
    var varient_List = [BogoVariantModel]()
    
    var widthArr = [String]()
    var activeTextField = UITextField()
    var selectedAllEditIds = [String]()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.isHidden = true
        noEndDateSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        setMode()
        subvarArray = []
    }
    
    func setMode() {
        
        if mode == "add" {
            createTitle.text = "Create BOGO Deal"
            doneBtn.setTitle("Done", for: .normal)
            
            noEndDateSwitch.isOn = false
            dateStackHeightConstraint.constant = 53
            startEndDateStack.isHidden = false
            
            discount_type = "2"
            
            dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
            percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
            
            dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
            percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
            
            discountperItemTextfield.label.text = "Discount Per Item ($)"
        }
        else {
            
            createTitle.text = "Edit BOGO Deal"
            doneBtn.setTitle("Update", for: .normal)
            cancelBtn.setTitle("Delete", for: .normal)
            cancelBtn.tintColor = .red
            cancelBtn.layer.borderWidth = 1
            cancelBtn.layer.borderColor = UIColor.red.cgColor
            
            dealNameTextfield.text = bogoObj?.deal_name
            describeDealTextfield.text = bogoObj?.desc
            discountperItemTextfield.text = bogoObj?.discount
            discount_type = bogoObj?.discount_type ?? ""
            itemsEditIds = bogoObj?.items ?? ""
            bogo_id = bogoObj?.id ?? ""
            
            
            if discount_type == "2" {
                percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
                percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
                
                dollarAmt = discountperItemTextfield.text ?? ""
            }
            else {
                dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
                dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
                dollarAmt = ""
            }
            
            let startdate = bogoObj?.start_date ?? ""
            let enddate = bogoObj?.end_date ?? ""
            
            let sdate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: startdate)
            let edate = ToastClass.sharedToast.setCouponsDateFormat(dateStr: enddate)
            
            if startdate ==  "0000-00-00" {
                
                dateStackHeightConstraint.constant = 0
                startEndDateStack.isHidden = true
                noEndDateSwitch.isOn = true
                noEndDateSwitch.thumbTintColor = .systemBlue
                startDate.text = ""
                
            }else {
                startEndDateStack.isHidden = false
                dateStackHeightConstraint.constant = 53
                noEndDateSwitch.isOn = false
                noEndDateSwitch.thumbTintColor = .white
                startDate.text = sdate
                
            }
            
            if enddate ==  "0000-00-00" {
                
                startEndDateStack.isHidden = true
                dateStackHeightConstraint.constant = 0
                noEndDateSwitch.isOn = true
                noEndDateSwitch.thumbTintColor = .systemBlue
                endDate.text = ""
            }else {
                
                startEndDateStack.isHidden = false
                dateStackHeightConstraint.constant = 53
                noEndDateSwitch.isOn = false
                noEndDateSwitch.thumbTintColor = .white
                endDate.text = edate
            }
            
            if noEndDateSwitch.isOn {
                noEndDate = "1"
            }
            else {
                noEndDate = "0"
            }
            let buy_qty = bogoObj?.buy_qty
            let free_qty = bogoObj?.free_qty
            qtyTextfield.text = buy_qty
            discountQtyTextfield.text = free_qty
            
            variantListApi()
        }
    }
    
    
    func setUI() {
        
        createCustomTextField(textField: dealNameTextfield)
        createCustomTextField(textField: describeDealTextfield)
        createCustomTextField(textField: qtyTextfield)
        createCustomTextField(textField: discountQtyTextfield)
        createCustomTextField(textField: discountperItemTextfield)
        createCustomTextField(textField: startDate)
        createCustomTextField(textField: endDate)
        
        dealNameTextfield.label.text = "Name of Deal"
        qtyTextfield.label.text = "Quantity"
        discountQtyTextfield.label.text = " Quantity"
        discountperItemTextfield.label.text = "Discount Per Item"
        startDate.label.text = "Start Date"
        endDate.label.text = "End Date"
                
        startDate.delegate = self
        endDate.delegate = self
        discountperItemTextfield.delegate = self
        qtyTextfield.delegate = self
        discountQtyTextfield.delegate = self
        
        qtyTextfield.keyboardType = .numberPad
        discountQtyTextfield.keyboardType = .numberPad
        discountperItemTextfield.keyboardType = .numberPad
        
        AddVarientBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 5
        doneBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        percentBtn.layer.cornerRadius = 5
        dollerBtn.layer.cornerRadius = 5
        
        describeDealTextfield.isUserInteractionEnabled = false
        
        discountperItemTextfield.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        qtyTextfield.addTarget(self, action: #selector(updateText), for: .editingChanged)
        discountQtyTextfield.addTarget(self, action: #selector(updateText), for: .editingChanged)
    }
    
    
    func getvarId() -> [[String:[String]]] {
        
        var small = [[String:[String]]]()
        
        for id in 0..<variantArray.count {
            
            if variantArray[id].bogo.isvarient == "1" {
                
                small.append([variantArray[id].bogo.id:[variantArray[id].bogo.var_id]])
            }else{
                small.append([variantArray[id].bogo.product_id:[""]])
            }
        }
        return small
    }
    
    func validateData() {
        
        guard let name = dealNameTextfield.text, name != "" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Deal name",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            dealNameTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        if noEndDateSwitch.isOn {
            
            
        }
        else {
            guard let start_date = startDate.text, start_date != "" else {
                
                ToastClass.sharedToast.showToast(message: "Please enter valid start date",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                startDate.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            guard let end_date = endDate.text, end_date != "" else {
                
                ToastClass.sharedToast.showToast(message: "Please enter valid end date",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                endDate.isError(numberOfShakes: 3, revert: true)
                
                return
            }
            
        }
        
        guard let qty = qtyTextfield.text, qty != "", qty != "0" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            qtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        
        guard let freeQty = discountQtyTextfield.text, freeQty != "", freeQty != "0" else {
            
            ToastClass.sharedToast.showToast(message: "Enter Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            qtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let bqty = Int(qtyTextfield.text ?? "0") ?? 0
        let fqty = Int(discountQtyTextfield.text ?? "0") ?? 0
        
        
        guard bqty > fqty else {
            
            ToastClass.sharedToast.showToast(message: "Free Quantity must be less than Buy Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountQtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let disc = discountperItemTextfield.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Valid Discount Price",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountperItemTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        if variantArray.count == 0 {
            ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            guard let name = describeDealTextfield.text, name != "" else {
                return
            }
            setDataMix()
        }
    }
    
    func setDataMix() {
        
        let varientId = getvarId()
        
        var textstring = [[String:[String]]]()
        var keyarr = [String]()
        var indexKey = 0
        
        for idd in varientId {
            
            for (key,value) in idd {
                
                if keyarr.contains(where: {$0 == key}) {
                    
                    indexKey = keyarr.firstIndex(where: {$0 == key}) ?? 0
                    let val = textstring[indexKey]
                    var varval = val[key]!
                    varval.append(contentsOf: value)
                    textstring[indexKey].updateValue(varval, forKey: key)
                }
                
                else {
                    keyarr.append(key)
                    textstring.append(idd)
                }
            }
        }
        
        var idarr = [[String:Any]]()
        for var_dict in textstring {
            
            for (dict_key, dict_value) in var_dict {
                
                idarr.append([dict_key:dict_value])
                //print(idarr)  //["604169:[\"\"]", "607682:[\"1293014\", \"1293015\", \"1293016\"]"]
            }
        }
        
        var varString = ""
        for vars in 0..<idarr.count {
            
            if vars == idarr.count - 1 {
                let firststr = "\(idarr[vars])".dropFirst()
                let laststr = firststr.dropLast()
                varString += laststr
            }
            
            else {
                let firststr = "\(idarr[vars])".dropFirst()
                let laststr = firststr.dropLast()
                varString += "\(laststr),"
            }
        }
        let emp = "{\(varString)}"
        
        addBogoApiCall(items_id: emp)
    }
    
    func addBogoApiCall(items_id: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        let d_name = dealNameTextfield.text ?? ""
        let price = discountperItemTextfield.text ?? ""
        let buy_qty = qtyTextfield.text ?? ""
        let Free_qty = discountQtyTextfield.text ?? ""
        let desc = describeDealTextfield.text ?? ""
        let sDate = startDate.text ?? ""
        let eDate = endDate.text ?? ""
        
        let change_start_date = ToastClass.sharedToast.setCouponlistDate(dateStr: sDate)
        let change_end_date = ToastClass.sharedToast.setCouponlistDate(dateStr: eDate)
        
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addBogoApiCall(merchant_id: id, deal_name: d_name,
                                           description: desc, no_end_date: noEndDate,
                                           use_with_coupon: "1", buy_qty: buy_qty,
                                           free_qty: Free_qty, discount: price,
                                           discount_type: discount_type , items: items_id,
                                           start_date: change_start_date, end_date: change_end_date,
                                           id: bogo_id) { isSuccess, responseData in
            
            if isSuccess {
                
                let list = responseData["msg"]
                
                
                ToastClass.sharedToast.showToast(message: list as! String,
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                self.loadIndicator.isAnimating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            else {
                print("Api Error")
            }
            
            self.doneBtn.isEnabled = true
        }
    }
    
    func deletAPiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.deletebogoApiCall(merchant_id: id, bogo_id: bogo_id) { isSuccess, responceData in
            
            if isSuccess {
                
                let list = responceData["msg"] as! String
                
                print(list)
                
                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                self.loadingIndicator.isAnimating = false
                
                self.navigationController?.popViewController(animated: true)
                
                
            }
            else {
                print("API error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
    @objc func checkStartDateValid() {
        showAlert(title: "Alert", message: "Please enter a valid start date")
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        if cancelBtn.currentTitle == "Delete" {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this deal?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            }
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                self.deletAPiCall()
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else {
            
            let viewcontrollerArray = self.navigationController?.viewControllers
            var destiny = 4
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is BogoListViewController }) {
                destiny = destinationIndex
            }
            
            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            
        }
    }
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        
        validateData()
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @IBAction func noEndDateSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            startEndDateStack.isHidden = true
            dateStackHeightConstraint.constant = 0
            noEndDate = "1"
            sender.thumbTintColor = .systemBlue
        }
        else {
            startEndDateStack.isHidden = false
            dateStackHeightConstraint.constant = 53
            noEndDate = "0"
            sender.thumbTintColor = .white
        }
        
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        let index = sender.tag
        if searching {
            
            let arr = searchVarArray[index]
            removeVarient(arr: arr, index: index)
        }
        else {
            let arr = variantArray[sender.tag]
            removeVarient(arr: arr, index: index)
            if variantArray.count == 0 {
                searchBar.isHidden = true
            }
        }
    }
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
        discountperItemTextfield.text = ""
        discountperItemTextfield.label.text = "Discount Per Item (%)"
        discount_type = "1"
        dollarAmt = ""
    }
    
    @IBAction func dollerBtnClick(_ sender: UIButton) {
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        discountperItemTextfield.text = ""
        discountperItemTextfield.label.text = "Discount Per Item ($)"
        discount_type = "2"
        dollarAmt = ""
    }
    
    
    @IBAction func AddVarientBtnClick(_ sender: UIButton) {
        
        guard let disc = discountperItemTextfield.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Amount",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountperItemTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "selectBogoVariant") as! SelectBogoVariantViewController
        
        vc.mode = mode
        vc.bogo_mix_exist_ids = bogo_mix_exist_ids
        vc.disc_amt = dollarAmt
        vc.bogoSelectedVariants = variantArray
        vc.adddelegate = self
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    func getWidth() {
        
        let lbl = UILabel()
        var smallWidth = [String]()
        
        for varient in  variantArray {
            
            if varient.bogo.isvarient == "1" {
                
                lbl.text = "$\(varient.bogo.var_price)"
            }
            else {
                lbl.text = "$\(varient.bogo.price)"
                
            }
            lbl.font = UIFont(name: "Manrope-Bold", size: 18.0)
            lbl.sizeToFit()
            let w = lbl.frame.size.width + 10.0
            smallWidth.append(String(format: "%.2f", w))
        }
        
        widthArr = smallWidth
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if activeTextField == startDate || activeTextField == endDate {
            openDatePicker(textField: activeTextField, tag: activeTextField.tag)
        }
        else if activeTextField == discountperItemTextfield {
            activeTextField = textField
        }
        else if activeTextField == qtyTextfield {
            activeTextField = textField
        }
        else if activeTextField == discountQtyTextfield {
            activeTextField = textField
        }
    }
    
    func checkPrice(varamt: String, textAmt: String) -> Bool {
        
        let v_amt = Double(varamt) ?? 0.00
        let textAmt = Double(textAmt) ?? 0.00
        
        if v_amt > textAmt {
            return false
        }
        return true
    }
    
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = (100 * doub) / 100
        
        return div
        
    }
    
    func calculateQty(qty: String, freeQty: String) -> String {
        
        let buyQty = Int(qty) ?? 0
        let freeqty = Int(freeQty) ?? 0
        
        
        let finalqty = buyQty - freeqty
        
        return String(finalqty)
    }
    
    func convertStringToDictionary(text: String) -> [String:Any] {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any) {
        
        let response = varient as! [[String: Any]]
        var small = [BogoVariantModel]()
        for res in response {
            
            let variant = BogoVariantModel(id: "\(res["id"] ?? "")",
                                           title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")",
                                           upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")",
                                           price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")",
                                           variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")",
                                           product_id: "\(res["product_id"] ?? "")",
                                           costperItem: "\(res["costperItem"] ?? "")",
                                           is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            
            if variant.is_lottery == "0" {
                small.append(variant)
            }
        }
        varient_List = small
        getEditItemsIds()
        
        getEditVarients(list: varient_List)
        
    }
    
    func getEditItemsIds() {
        
        var small = [String]()
        var keyArr = [String]()
        var valuesArr = [String]()
        
        let items = convertStringToDictionary(text: itemsEditIds)
        
        for (key, value) in items {
            keyArr.append(key)
            
            let valueId = value as? [String] ?? []
            for val in valueId {
                if val.count == 0 {
                    
                }else {
                    valuesArr.append(val)
                }
            }
            small = keyArr + valuesArr
            selectedAllEditIds = small
            
        }
    }
    
    func getEditVarients(list: [BogoVariantModel]) {
        
        for variant in list {
            
            if variant.isvarient == "1" {
                
                if selectedAllEditIds.contains(where: { $0 == variant.var_id})  {
                    
                    variantArray.append(VariantBogoModel(bogo: variant, isSelect: true))
                    
                }
            }
            else {
                if selectedAllEditIds.contains(where: { $0 == variant.product_id})  {
                    
                    variantArray.append(VariantBogoModel(bogo: variant, isSelect: true))
                }
            }
        }
        
        
        subvarArray = variantArray
        getWidth()
        
        if variantArray.count == 0 {
            searchBar.isHidden = true
        }
        else {
            searchBar.isHidden = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func removeVarient(arr: VariantBogoModel, index: Int) {
        
        if searching {
            
            searchVarArray.remove(at: index)
            
            if arr.bogo.isvarient == "1" {
                subvarArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
                variantArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
            }
            else {
                subvarArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
                variantArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
            }
        }
        
        else {
            variantArray.remove(at: index)
            if arr.bogo.isvarient == "1" {
                subvarArray.removeAll(where: {$0.bogo.var_id == arr.bogo.var_id})
            }
            else {
                subvarArray.removeAll(where: {$0.bogo.product_id == arr.bogo.product_id})
            }
        }
        tableView.reloadData()
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        
        else {
            searching = true
            searchVarArray = subvarArray.filter{ $0.bogo.title.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.var_upc.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.upc.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.custom_code.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
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
    
    func createCustomTextField(textField: UITextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    private func setupUI() {
        
        cancelBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: cancelBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: cancelBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        doneBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: doneBtn.centerXAnchor, constant: 45),
            loadIndicator.centerYAnchor
                .constraint(equalTo: doneBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
        
    }
    
}

extension CreateBOGODealViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        performSearch(searchText: "")
    }
}

extension CreateBOGODealViewController {
    
    
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
        
        if Double(cleanedAmount) ?? 0 > 99999999 {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        if discount_type == "2" {
            if Double(cleanedAmount) ?? 00000 > 99999999 {
                cleanedAmount = String(cleanedAmount.dropLast())
            }
        }
        else {
            if Double(cleanedAmount) ?? 0.00 > 10000 {
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
        
        
        if textField == discountperItemTextfield  {
            
            let qty = Int(qtyTextfield.text ?? "0") ?? 0
            let freeQty = Int(discountQtyTextfield.text ?? "0") ?? 0
            
            let discount = Double(discountperItemTextfield.text ?? "0") ?? 0.0
            
            guard qty > 0, freeQty > 0, qty > freeQty else {
                describeDealTextfield.text = ""
                return
            }
            
            let buyQty = qty - freeQty
            
            let discountType = percentBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") ? "%" : "$"
            
            
            if discount < 100 {
                describeDealTextfield.text = "Buy \(buyQty) Get \(freeQty) off on  \(discount) \(discountType) item each"
            }
            else {
                describeDealTextfield.text = "Buy \(buyQty) Get \(freeQty) Free"
                
            }
            
        }
        
        if textField.text == "000" {
            textField.text = ""
            
        }
    }
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == qtyTextfield  {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
            
        }
        else if textField == discountQtyTextfield  {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
            
        }
        
        activeTextField.text = updatetext
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        tableHeight.constant = tableView.contentSize.height
        scrollHeight.constant = viewsview.bounds.size.height + 80 + tableHeight.constant
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    func getlessAmtVarient() {
        
        var small = [VariantBogoModel]()
        
        let amt = discountperItemTextfield.text ?? ""
        
        for i in 0..<variantArray.count {
            
            if variantArray[i].bogo.isvarient == "1" {
                let checkless = checkPrice(varamt: variantArray[i].bogo.var_price, textAmt: amt)
                if checkless {
                    
                }
                else {
                    small.append(variantArray[i])
                }
            }
            else {
                
                let checkless = checkPrice(varamt: variantArray[i].bogo.price, textAmt: amt)
                if checkless {
                    
                }
                else {
                    small.append(variantArray[i])
                }
            }
        }
        variantArray = small
        subvarArray = small
        tableView.reloadData()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let qty = Int(qtyTextfield.text ?? "0") ?? 0
        let freeQty = Int(discountQtyTextfield.text ?? "0") ?? 0
        
        let discount = Double(discountperItemTextfield.text ?? "0") ?? 0.00
        
        let buyQty = qty - freeQty
        
        let discountType = percentBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") ? "%" : "$"
        
        let formattedDiscount = String(format: "%.2f", discount)
        
        if textField == discountperItemTextfield {
            
            if discount_type == "2" {
                
                dollarAmt = formattedDiscount
                getlessAmtVarient()
            }
            else {
                dollarAmt = ""
            }
            
            if textField.text == "" || textField.text == "0.00"{
                variantArray = subvarArray
                tableView.reloadData()
            }
            
        }
        else if textField == qtyTextfield || textField == discountQtyTextfield  {
            
            
        }
        
        
        guard qty > 0, freeQty > 0, qty > freeQty, discount > 0.00 else {
            describeDealTextfield.text = ""
            return
        }
        
        if discount_type == "2" {
            describeDealTextfield.text = "Buy \(buyQty) Get \(freeQty) off on \(discountType)\(formattedDiscount) item each"
        }
        else {
            if discount < 100 {
                describeDealTextfield.text = "Buy \(buyQty) Get \(freeQty) off on  \(formattedDiscount) \(discountType) item each"
                
            }
            else {
                describeDealTextfield.text = "Buy \(buyQty) Get \(freeQty) Free"
                
            }
            
        }
    }
}


extension CreateBOGODealViewController  {
    
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
                    endDate.text = ""
                }
            }
        }
        
        else {
            activeTextField.text = dateFormat.string(from: date)
            endDate.text = ""
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

extension CreateBOGODealViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVarArray.count
        }
        else {
            return variantArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatBogoDealCell", for: indexPath) as! CreatBogoDealCell
            
            let variant = searchVarArray[indexPath.row]
            
            
            if variant.bogo.isvarient ==  "1" {
                
                let title = variant.bogo.title
                let variantName = variant.bogo.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                cell.varientlbl.isHidden = false
                cell.priceLbl.text = "$\(variant.bogo.var_price)"
                cell.upclbl.text = variant.bogo.var_upc
                cell.varientlbl.text = variant.bogo.variant
            }
            else {
                
                cell.varientlbl.isHidden = true
                cell.titleLbl.text = variant.bogo.title
                cell.priceLbl.text = "$\(variant.bogo.price)"
                cell.upclbl.text = variant.bogo.upc
            }
            
            if variantArray.count != 0 {
                let widthDoub = Double(widthArr[indexPath.row]) ?? 0.00
                cell.viewWidth.constant = widthDoub
                cell.contentView.backgroundColor = UIColor.white
            }
            
            cell.closeBtn.tag = indexPath.row
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatBogoDealCell", for: indexPath) as! CreatBogoDealCell
            
            let variant = variantArray[indexPath.row]
            
            if variant.bogo.isvarient ==  "1" {
                
                let title = variant.bogo.title
                let variantName = variant.bogo.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                cell.varientlbl.isHidden = false
                cell.priceLbl.text = "$\(variant.bogo.var_price)"
                cell.upclbl.text = variant.bogo.var_upc
                cell.varientlbl.text = variant.bogo.variant
            }
            else {
                
                cell.varientlbl.isHidden = true
                cell.titleLbl.text = variant.bogo.title
                cell.priceLbl.text = "$\(variant.bogo.price)"
                cell.upclbl.text = variant.bogo.upc
            }
            
            if variantArray.count != 0 {
                let widthDoub = Double(widthArr[indexPath.row]) ?? 0.00
                cell.viewWidth.constant = widthDoub
                cell.contentView.backgroundColor = UIColor.white
            }
            
            cell.closeBtn.tag = indexPath.row
            return cell
            
        }
    }
}

extension CreateBOGODealViewController : SelectBogoDelegate {
    
    func addSelectedBogoVariants(arr: [VariantBogoModel]) {
        
        variantArray = arr
        subvarArray = arr
        
        if variantArray.count == 0 {
            searchBar.isHidden = true
            
        }
        else {
            searchBar.isHidden = false
        }
        
        if arr.count != 0 {
            getWidth()
        }
        tableView.reloadData()
        
    }
}
