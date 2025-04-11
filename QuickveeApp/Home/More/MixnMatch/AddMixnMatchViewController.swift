//
//  AddMixnMatchViewController.swift
//
//
//  Created by Pallavi on 18/06/24.
//

import UIKit
import MaterialComponents
import BarcodeScanner

protocol AddMixnMatchDelegate: AnyObject {
    
    func setSelectedMixVariants(mix: [VariantMixMatchModel], price: String, is_percent: String)
}

class AddMixnMatchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dealNameTextfield: MDCOutlinedTextField!
    @IBOutlet weak var descriptionTextField: MDCOutlinedTextField!
    @IBOutlet weak var qtyTextfield: MDCOutlinedTextField!
    
    @IBOutlet weak var discountTextfield: MDCOutlinedTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var addVarientLbl: UILabel!
    
    @IBOutlet weak var viewsView: UIView!
    @IBOutlet weak var dollerBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    
    @IBOutlet weak var btnStack: UIStackView!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    var addVariantArray = [VariantMixMatchModel]()
    var variantArray = [VariantMixMatchModel]()
    
    var searchVarArray = [VariantMixMatchModel]()
    var subvarArray =  [VariantMixMatchModel]()
    
    var varient_List = [MixVariantModel]()
    
    var itemsEditIds = ""
    var itemsAllEditIds = [String]()
    var selectedAllEditIds = [String]()
    var widthArr = [String]()
    
    weak var delegate: AddMixnMatchDelegate?
    
    var price = ""
    var qty = ""
    var searching = false
    var cleanedAmount = ""
    private var isSymbolOnRight = false
    
    var is_percent = ""
    var mode = ""
    var e_deal_name = ""
    var e_discount = ""
    var e_qty = ""
    var e_desc = ""
    var activeTextField = UITextField()
    var e_m_id = ""
    // var e_price = ""
    var edit_dollre_price = ""
    
    
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
    
    let Indicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        setupUI()
        qtyTextfield.delegate = self
        discountTextfield.delegate = self
        qtyTextfield.addTarget(self, action: #selector(updateText), for: .editingChanged)
        tableView.separatorStyle = .singleLine
        searchBar.placeholder = "Search Variant"
        descriptionTextField.label.text = "Description"
        
        dealNameTextfield.autocapitalizationType = .words
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        tableHeight.constant = tableView.contentSize.height
        scrollHeight.constant = viewsView.bounds.size.height + 80 + tableHeight.constant
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        subvarArray = variantArray
        print(price)
        print(is_percent)
        
        
        if mode == "add" {
            
            doneBtn.setTitle("Done", for: .normal)
            
            
            var amount = ""
            if is_percent == "0" {
                dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
                percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
                discountTextfield.label.text = "Discount Per Item ($)"
                amount = price.replacingOccurrences(of: "$", with: "")
                descriptionTextField.text = "Buy \(qty ) Get $\(amount) off Each"
             
                is_percent = "0"
                
            }
            else {
                amount = price.replacingOccurrences(of: "$", with: "")
                descriptionTextField.text = "Buy \(qty ) Get \(amount)% off Each"
                percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
                dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
                discountTextfield.label.text = "Discount Per Item (%)"
             
                is_percent = "1"
            }
            qtyTextfield.text = qty
            discountTextfield.text = amount
            edit_dollre_price = discountTextfield.text ?? ""
            getWidth()
            // getAddVariant()
            //            tableHeight.constant = CGFloat(130 * variantArray.count)
            //            scrollHeight.constant = viewsView.bounds.size.height + 80 + tableHeight.constant
        }
        else {
            
            doneBtn.setTitle("Update", for: .normal)
            dealNameTextfield.text = e_deal_name
            
            descriptionTextField.text = e_desc
            qtyTextfield.text = e_qty
            discountTextfield.text = e_discount
            
            if is_percent == "0" {
                dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
                percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
                discountTextfield.label.text = "Discount Per Item ($)"
                edit_dollre_price = discountTextfield.text ?? ""
                is_percent = "0"
            }else {
                percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
                percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
                dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
                discountTextfield.label.text = "Discount Per Item (%)"
                edit_dollre_price = discountTextfield.text ?? ""
                is_percent = "1"
            }
            cancelBtn.setTitle("Delete", for: .normal)
            cancelBtn.setTitleColor(UIColor.red, for: .normal)
            cancelBtn.layer.borderWidth = 1
            cancelBtn.layer.borderColor = UIColor.red.cgColor
            
            tableView.isHidden = true
            Indicator.isAnimating = true
            variantListApi()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.searchTextField.leftViewMode = .never
        
        searchBar.searchTextField.backgroundColor = .white
        
        let button = UIImageView.init()
        button.image = UIImage(named: "searchmix")
        
        searchBar.searchTextField.rightViewMode = .always
    }
    
    func setUI() {
        
        let color = UIColor.black
        let placeholder = discountTextfield.placeholder ?? ""
        
        discountTextfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        createCustomTextField(textField: dealNameTextfield)
        createCustomTextField(textField: descriptionTextField)
        createCustomTextField(textField: qtyTextfield)
        createCustomTextField(textField: discountTextfield)
        
        dealNameTextfield.label.text = "Name of Deal"
        descriptionTextField.label.text = "Description"
        qtyTextfield.label.text = "Minimum Quantity"
        qtyTextfield.keyboardType = .numberPad
        discountTextfield.keyboardType = .numberPad
        
        
        if is_percent == "0" {
            discountTextfield.label.text = "Discount Per Item ($)"
        }
        else {
            discountTextfield.label.text = "Discount Per Item(%)"
        }
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
        doneBtn.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        topView.addBottomShadow()
        
        discountTextfield.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        //        descriptionTextField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        let varientGest = UITapGestureRecognizer(target: self, action: #selector(addVarientClick))
        addVarientLbl.addGestureRecognizer(varientGest)
        addVarientLbl.isUserInteractionEnabled = true
        varientGest.numberOfTapsRequired = 1
        
        btnStack.layer.cornerRadius = 5
        dollerBtn.layer.cornerRadius = 5
        percentBtn.layer.cornerRadius = 5
    }
    
    func getAddVariant() {
        
        let newVariants = variantArray.filter { newVariant in
            
            if newVariant.mix.isvarient == "1" {
                !variantArray.contains { $0.mix.var_id == newVariant.mix.var_id }
            }
            else {
                !variantArray.contains { $0.mix.var_id == newVariant.mix.product_id }
            }
            
        }
        
        if !newVariants.isEmpty {
            variantArray.append(contentsOf: newVariants)
            subvarArray.append(contentsOf: newVariants)
        }
    }
    
    
    
    func getvarId() -> [[String:[String]]] {
        
        var small = [[String:[String]]]()
        
        for id in 0..<variantArray.count {
            
            if variantArray[id].mix.isvarient == "1" {
                
                small.append([variantArray[id].mix.id:[variantArray[id].mix.var_id]])
            }else{
                small.append([variantArray[id].mix.product_id:[""]])
            }
        }
        print(small)
        return small
        
    }
    
    func getWidth() {
        
        let lbl = UILabel()
        var smallWidth = [String]()
        
        for varient in  variantArray {
            
            if varient.mix.isvarient == "1" {
                
                lbl.text = "$\(varient.mix.var_price)"
            }
            else {
                lbl.text = "$\(varient.mix.price)"
                
            }
            lbl.font = UIFont(name: "Manrope-Bold", size: 18.0)
            lbl.sizeToFit()
            let w = lbl.frame.size.width + 10.0
            smallWidth.append(String(format: "%.2f", w))
        }
        
        widthArr = smallWidth
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
        var small = [MixVariantModel]()
        for res in response {
            
            let variant = MixVariantModel(id: "\(res["id"] ?? "")",
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
    
    func getEditVarients(list: [MixVariantModel]) {
        
        for variant in list {
            
            if variant.isvarient == "1" {
                
                if selectedAllEditIds.contains(where: { $0 == variant.var_id})  {
                    
                    variantArray.append(VariantMixMatchModel(mix: variant, isSelect: true))
                }
            }
            else {
                if selectedAllEditIds.contains(where: { $0 == variant.product_id})  {
                    
                    variantArray.append(VariantMixMatchModel(mix: variant, isSelect: true))
                }
            }
        }
        print("@@\(variantArray.count)")
        subvarArray = variantArray
        getWidth()
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.Indicator.isAnimating = false
            self.tableView.reloadData()
        }
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
    
    
    func removeVarient(arr: VariantMixMatchModel, index: Int) {
        
        if searching {
            
            searchVarArray.remove(at: index)
            
            if arr.mix.isvarient == "1" {
                subvarArray.removeAll(where: {$0.mix.var_id == arr.mix.var_id})
                variantArray.removeAll(where: {$0.mix.var_id == arr.mix.var_id})
            }
            else {
                subvarArray.removeAll(where: {$0.mix.product_id == arr.mix.product_id})
                variantArray.removeAll(where: {$0.mix.product_id == arr.mix.product_id})
            }
        }
        
        else {
            variantArray.remove(at: index)
            if arr.mix.isvarient == "1" {
                subvarArray.removeAll(where: {$0.mix.var_id == arr.mix.var_id})
            }
            else {
                subvarArray.removeAll(where: {$0.mix.product_id == arr.mix.product_id})
            }
        }
        tableView.reloadData()
    }
    
    @objc func addVarientClick(_ sender: UIButton) {
        
        if mode == "add" {
            
            UserDefaults.standard.set(0, forKey: "modal_screen")
            print(edit_dollre_price)
            delegate?.setSelectedMixVariants(mix: variantArray, price: edit_dollre_price, is_percent: is_percent)
            navigationController?.popViewController(animated: true)
        }
        else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "selectmixnmatch") as! SelectMixnMatchViewController
            
            vc.delegate = self
            vc.mixSelectedVariants = variantArray
            
            vc.mode = "edit"
            vc.e_price = edit_dollre_price
            print("Addvarian \(is_percent)")
            vc.isperc = is_percent
            
            
            for select in variantArray {
                
                if select.mix.isvarient == "1" {
                    itemsAllEditIds.removeAll(where: {$0 == select.mix.var_id})
                }
                else {
                    
                    itemsAllEditIds.removeAll(where: {$0 == select.mix.product_id})
                }
            }
            
            vc.mix_exist_ids = itemsAllEditIds
            
            UserDefaults.standard.set(2, forKey: "modal_screen")
            
            present(vc, animated: true)
        }
    }
    
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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
        }
        
    }
    
    
    @IBAction func dollarBtnClick(_ sender: UIButton) {
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.setImage(UIImage(named: "dolllerSym"), for: .normal)
        percentBtn.setImage(UIImage(named: "PercentSymbol"), for: .normal)
        
        discountTextfield.label.text = "Discount Per Item ($)"
        cleanedAmount = ""
        discountTextfield.text = ""
        discountTextfield.text = "0.00"
        is_percent = "0"
        edit_dollre_price = discountTextfield.text ?? ""
        
    }
    
    
    @IBAction func percentBtnClick(_ sender: UIButton) {
        
        percentBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
        dollerBtn.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        percentBtn.setImage(UIImage(named: "PerwhiteIcon"), for: .normal)
        dollerBtn.setImage(UIImage(named: "dollerGrey"), for: .normal)
        
        discountTextfield.label.text = "Discount Per Item (%)"
        cleanedAmount = ""
        discountTextfield.text = ""
        discountTextfield.text = "0.00"
        is_percent = "1"
        edit_dollre_price = discountTextfield.text ?? ""
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "delete_mix_match") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
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
                
                UserDefaults.standard.set(0, forKey: "modal_screen")
                let viewcontrollerArray = self.navigationController?.viewControllers
                var destiny = 4
                
                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is MixnMatchPricingViewController }) {
                    destiny = destinationIndex
                }
                
                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            }
        }
    }
    
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            validateData()
        }
        else {
            
            if UserDefaults.standard.bool(forKey: "edit_mix_match") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                validateData()
            }
        }
    }
    
    func validateData() {
        
        guard let name = dealNameTextfield.text, name != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Deal name",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            dealNameTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let disc = discountTextfield.text, disc != "", disc != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Valid Discount Price",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            discountTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let discrip = descriptionTextField.text, discrip != "", discrip != "0.00" else {
            ToastClass.sharedToast.showToast(message: "Enter Valid Description Price",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            descriptionTextField.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        guard let qty = qtyTextfield.text, qty != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Quantity",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            qtyTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        if variantArray.count == 0 {
            ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
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
            
            print(var_dict)
            
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
        
        print(emp)
        addMixApiCall(items_id: emp)
    }
    
    
    func addMixApiCall(items_id: String) {
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let d_name = dealNameTextfield.text ?? ""
        let price = discountTextfield.text ?? ""
        let s_qty = qtyTextfield.text ?? ""
        let desc = descriptionTextField.text ?? ""
        
        print(is_percent)
        
        var m_id = ""
        
        if doneBtn.currentTitle == "Done" {
            m_id = ""
            
        }else {
            m_id = e_m_id
        }
        
        loadIndicator.isAnimating = true
        self.doneBtn.isEnabled = false
        
        
        ApiCalls.sharedCall.addMixnMatchPricingApiCall(
            merchant_id: id, items_id: items_id, deal_name: d_name, min_qty: s_qty,
            is_percent: is_percent, discount: price, is_enable: "1", description: desc, mix_id: m_id)
        { isSuccess, responseData in
            
            
            DispatchQueue.main.async {
                
                if isSuccess {
                    
                    if let message = responseData["message"] as? String, message == "Failed" {
                        self.doneBtn.isEnabled = true
                        
                        if let viewcontrollerArray = self.navigationController?.viewControllers,
                           let destinationIndex = viewcontrollerArray.firstIndex(where: { $0 is MixnMatchPricingViewController }) {
                            
                            self.navigationController?.popToViewController(viewcontrollerArray[destinationIndex], animated: true)
                        }
                    }
                    
                    else {
                        
                        let list = responseData["message"] as? String ?? "Success"
                        ToastClass.sharedToast.showToast(
                            message: list,
                            font: UIFont(name: "Manrope-SemiBold", size: 14.0)!
                        )
                        
                        self.loadIndicator.isAnimating = false
                        UserDefaults.standard.set(0, forKey: "modal_screen")
                        
                        if let viewcontrollerArray = self.navigationController?.viewControllers,
                           let destinationIndex = viewcontrollerArray.firstIndex(where: { $0 is MixnMatchPricingViewController }) {
                            
                            self.navigationController?.popToViewController(viewcontrollerArray[destinationIndex], animated: true)
                        }
                    }
                } else {
                    print("API Error")
                }
                self.doneBtn.isEnabled = true
            }
        }
    }
   
    
    func deletAPiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.deleteMixnMatchApiCall(merchant_id: id, mix_id: e_m_id ){isSuccess, responceData in
            
            if isSuccess {
                
                ToastClass.sharedToast.showToast(message: "Data deleted Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                self.loadingIndicator.isAnimating = false
                let viewcontrollerArray = self.navigationController?.viewControllers
                var destiny = 4
                
                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is MixnMatchPricingViewController }) {
                    destiny = destinationIndex
                }
                self.backBtn.isEnabled = true
                UserDefaults.standard.set(0, forKey: "modal_screen")
                
                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            }
            else {
                print("API error")
                self.loadingIndicator.isAnimating = false
            }
        }
    }
 
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
           
        }
        
        else {
            searching = true
            searchVarArray = subvarArray.filter{ $0.mix.title.lowercased().contains(searchText.lowercased())
                ||  $0.mix.var_upc.lowercased().contains(searchText.lowercased())
                ||  $0.mix.upc.lowercased().contains(searchText.lowercased())
                ||  $0.mix.custom_code.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
        
    }
  
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        UserDefaults.standard.set(0, forKey: "modal_screen")
        print(variantArray)
        if mode == "add" {
            delegate?.setSelectedMixVariants(mix: variantArray, price: price, is_percent: is_percent)
        }
        navigationController?.popViewController(animated: true)
    }
    
}


//func doubleText(currentTitle : String ) {
//    
//    
//    for character in currentTitle {
//        
//        cleanedAmount.append(character)
//    }
//    
//    if priceView.backgroundColor == .black {
//        if Double(cleanedAmount) ?? 00000 > 99999999 {
//            cleanedAmount = String(cleanedAmount.dropLast())
//        }
//    }
//    else {
//        if Double(cleanedAmount) ?? 00000 > 9999 {
//            cleanedAmount = String(cleanedAmount.dropLast())
//        }
//    }
//            
//    let amount = Double(cleanedAmount) ?? 0.0
//    let amountAsDouble = (amount / 100.0)
//    print(amountAsDouble)
//    var amountAsString = String(amountAsDouble)
//    if cleanedAmount.last == "0" {
//        amountAsString.append("0")
//    }
//    
//    if priceView.backgroundColor == .black {
//        priceTextField.text = "$\(amountAsString)"
//    }
//    
//    else {
//        priceTextField.text = "\(amountAsString)%"
//    }
//    
//    
//    if priceTextField.text == "0000" {
//        priceTextField.text = "00000"
//    }


extension AddMixnMatchViewController {
    
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
        
        if is_percent == "0" {
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
        
        if textField == discountTextfield  {
            
            let u_qty = qtyTextfield.text ?? ""
            let u_price = discountTextfield.text ?? ""
            
            
            if dollerBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") {
                descriptionTextField.text = "Buy \(u_qty) Get $\(u_price) off Each"
                edit_dollre_price = u_price
            }
            else {
                
                descriptionTextField.text = "Buy \(u_qty) Get \(u_price)% off Each"
                edit_dollre_price = "\(u_price)"
            }
            
            // getlessAmtVarient()
            
        }
        if textField.text == "000" {
            textField.text = ""
           
        }
    }
  
    func getlessAmtVarient() {
      
        var small = [VariantMixMatchModel]()
    
        let amt = discountTextfield.text ?? ""
   
        for i in 0..<variantArray.count {
            
            if variantArray[i].mix.isvarient == "1" {
                let checkless = checkPrice(varamt: variantArray[i].mix.var_price, textAmt: amt)
                if checkless {
               
                }
                else {
                    small.append(variantArray[i])
                }
            }
            else {
                
                let checkless = checkPrice(varamt: variantArray[i].mix.price, textAmt: amt)
                if checkless {
                    
                }
                else {
                    small.append(variantArray[i])
                }
            }
        }
        variantArray = small
        tableView.reloadData()
    }
  
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
      
        if textField == discountTextfield  {
            
            let u_qty = qtyTextfield.text ?? ""
            let u_price = discountTextfield.text ?? ""
          
           
            if is_percent == "0" {
                
                descriptionTextField.text = "Buy \(u_qty) Get $\(u_price) off Each"
                getlessAmtVarient()
            }
            else {
                discountTextfield.text = u_price
                descriptionTextField.text = "Buy \(u_qty) Get \(u_price)% off Each"
            }
           
            print(textField.text ?? "")
            if textField.text == "" || textField.text == "0.00"{
                variantArray = subvarArray
                tableView.reloadData()
            }
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
    
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
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
        
        
        tableView.addSubview(Indicator)
        
        NSLayoutConstraint.activate([
            Indicator.centerXAnchor
                .constraint(equalTo: tableView.centerXAnchor, constant: 0),
            Indicator.centerYAnchor
                .constraint(equalTo: tableView.centerYAnchor),
            Indicator.widthAnchor
                .constraint(equalToConstant: 30),
            Indicator.heightAnchor
                .constraint(equalTo: self.Indicator.widthAnchor)
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



extension AddMixnMatchViewController :  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        performSearch(searchText: "")
    }
}

extension AddMixnMatchViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
        
        searchBar.text = code
        
        performSearch(searchText: code)
        controller.dismiss(animated: true)
        
    }
}

extension AddMixnMatchViewController : UITableViewDelegate , UITableViewDataSource {
    
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMixnMatchCell", for: indexPath) as! AddMixnMatchCell
            
            let variant = searchVarArray[indexPath.row]
            
            if variant.mix.isvarient == "1"{
                
                cell.priceLbl.text = variant.mix.var_price
                cell.varientlbl.text = variant.mix.variant
                cell.upclbl.text = variant.mix.var_upc
            }else {
                cell.priceLbl.text = variant.mix.price
                cell.upclbl.text = variant.mix.upc
                cell.varientlbl.isHidden = true
            }
            
            cell.titleLbl.text = variant.mix.title
            
        
                cell.contentView.backgroundColor = UIColor.white
           
            cell.closeBtn.tag = indexPath.row
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMixnMatchCell", for: indexPath) as! AddMixnMatchCell
            
            let variant = variantArray[indexPath.row]
            
            if variant.mix.isvarient == "1" {
                
                let title = variant.mix.title
                let variantName = variant.mix.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                cell.priceLbl.text = "$\(variant.mix.var_price)"
                cell.varientlbl.text = variant.mix.variant
                cell.upclbl.text = variant.mix.var_upc
                
            }
            else {
                cell.titleLbl.text = variant.mix.title
                cell.priceLbl.text = "$\(variant.mix.price)"
                cell.upclbl.text = variant.mix.upc
                cell.varientlbl.isHidden = true
            }
          
         
                cell.contentView.backgroundColor = UIColor.white
          
            
            cell.closeBtn.tag = indexPath.row
            
            return cell
        }
    }
}


extension AddMixnMatchViewController : UITextFieldDelegate  {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
   
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == qtyTextfield  {
            
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
            
            else if updatetext == "0"  && updatetext.count == 1 {
                updatetext = String(updatetext.dropLast())
            }
            
            
            activeTextField.text = updatetext
            
            let u_price = discountTextfield.text ?? ""
            
            
            if dollerBtn.backgroundColor == UIColor.init(hexString: "#0A64F9") {
                descriptionTextField.text = "Buy \(activeTextField.text ?? "") Get $\(u_price) off Each"
            }
            else {
                descriptionTextField.text = "Buy \(activeTextField.text ?? "") Get \(u_price)% off Each"
            }
        }
    }
}

extension AddMixnMatchViewController: SelectMixnMatchDelegate {
    
    
    func addSelectedMixVariants(arr: [VariantMixMatchModel]) {
        
        print(arr)
       
        if arr.count == 0 {
            
        }
        else {
            
            variantArray.removeAll()
            subvarArray.removeAll()
            tableView.isHidden = true
            Indicator.isAnimating = true
           
            for variant in arr {
                if variant.mix.isvarient == "1" {
                    if variantArray.contains(where: { $0.mix.var_id == variant.mix.var_id}) {
                    }
                    else{
                        variantArray.append(variant)
                        subvarArray.append(variant)
                    }
                }
                else {
                    if variantArray.contains(where: { $0.mix.product_id == variant.mix.product_id}) {
                    }
                    else{
                        variantArray.append(variant)
                        subvarArray.append(variant)
                    }
                }
            }
        }
   
        
//                         variantArray = arr
//           i              subvarArray = arr
        
        tableView.isHidden = false
        Indicator.isAnimating = false
            getWidth()
            tableView.reloadData()
            
        
            //        tableHeight.constant = CGFloat(150 * variantArray.count)
            //        scrollHeight.constant = viewsView.bounds.size.height + 80 +  tableHeight.constant
            //        view.layoutIfNeeded()
        
    }
}
