//
//  VariantInfoViewController.swift
//  
//
//  Created by Jamaluddin Syed on 10/3/23.
//

import UIKit
import MaterialComponents
import VisionKit
import BarcodeScanner

class VariantInfoViewController: UIViewController, UITextFieldDelegate {
 
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var variantName: UILabel!
    @IBOutlet weak var price: MDCOutlinedTextField!
    @IBOutlet weak var compareAtPrice: MDCOutlinedTextField!

    @IBOutlet weak var costPerItem: MDCOutlinedTextField!
    @IBOutlet weak var margin: MDCOutlinedTextField!
    @IBOutlet weak var profit: MDCOutlinedTextField!
    @IBOutlet weak var qty: MDCOutlinedTextField!
    @IBOutlet weak var customCode: MDCOutlinedTextField!
    @IBOutlet weak var reorderQty: MDCOutlinedTextField!
    @IBOutlet weak var reorderLevel: MDCOutlinedTextField!
    
    @IBOutlet weak var trackQty: UIButton!
    @IBOutlet weak var checkID: UIButton!
    @IBOutlet weak var selling: UIButton!
    @IBOutlet weak var disable: UIButton!
    @IBOutlet weak var foodStampable: UIButton!
    
    
    @IBOutlet weak var upcCode: MDCOutlinedTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var instantPO: UIButton!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var saveStackBottom: NSLayoutConstraint!
    
    @IBOutlet weak var upcLbl: UILabel!
    @IBOutlet weak var costItemInner: UIView!
    @IBOutlet weak var marginInner: UIView!
    @IBOutlet weak var profitInner: UIView!
    @IBOutlet weak var qtyInner: UIView!
    
    @IBOutlet weak var quantLbl: UILabel!
    @IBOutlet weak var sellingLbl: UILabel!
    @IBOutlet weak var checkIDlBL: UILabel!
    @IBOutlet weak var disableLbl: UILabel!
    
    
    @IBOutlet weak var salesBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    
    var activeTextField = UITextField()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var v_name = ""
    var v_id = ""
    var is_v = ""
    var p_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        variantName.text = v_name
        
        price.label.text = "Price"
        compareAtPrice.label.text = "Compare at Price"
        costPerItem.label.text = "Cost Per Item"
        margin.label.text = "Margin(%)"
        profit.label.text = "Profit($)"
        qty.label.text = "Qty"
        customCode.label.text = "Custom Code"
        reorderQty.label.text = "Reorder Qty"
        reorderLevel.label.text = "Reorder level"
        upcCode.label.text = "UPC code"
     
        
        setupFields()
        
        cancelBtn.layer.cornerRadius = 10.0
        saveBtn.layer.cornerRadius = 10.0
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        instantPO.layer.cornerRadius = 10.0
        salesBtn.layer.cornerRadius = 10.0
        
        scanBtn.layer.cornerRadius = 6.0
        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(genUpcClick))
        upcLbl.addGestureRecognizer(tapUpc)
        tapUpc.numberOfTapsRequired = 1
        upcLbl.isUserInteractionEnabled = true
        
        price.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        profit.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        costPerItem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        compareAtPrice.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
        qty.addTarget(self, action: #selector(updateText), for: .editingChanged)
        upcCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
        customCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
        reorderQty.addTarget(self, action: #selector(updateText), for: .editingChanged)
        reorderLevel.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        
        qty.delegate = self
        upcCode.delegate = self
        customCode.delegate = self
        price.delegate = self
        costPerItem.delegate = self
        compareAtPrice.delegate = self
        reorderQty.delegate = self
        reorderLevel.delegate = self
        
        
        topview.addBottomShadow()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        setupSaveUI()
        
        inventSettingsCall()
        fieldsHide()
        
        
        if UserDefaults.standard.bool(forKey: "var_api_hit") {
            loadingIndicator.isAnimating = true
            setUpVarIdApi()
        }
        else {
            
        }
    }
    
    func setupFields() {
        
        createCustomTextField(textField: price)
        createCustomTextField(textField: compareAtPrice)
        createCustomTextField(textField: customCode)
        createCustomTextField(textField: upcCode)
        createCustomTextField(textField: reorderQty)
        createCustomTextField(textField: reorderLevel)
        
        
        createCustomTextFieldCost(textField: costPerItem)
        createCustomTextFieldCost(textField: margin)
        createCustomTextFieldCost(textField: profit)
        createCustomTextFieldCost(textField: qty)
        
        price.keyboardType = .numberPad
        compareAtPrice.keyboardType = .numberPad
        reorderQty.keyboardType = .numberPad
        reorderLevel.keyboardType = .numberPad
        qty.keyboardType = .numberPad
        costPerItem.keyboardType = .numberPad
        
    }
    
    func fieldsHide() {
        
        
        if UserDefaults.standard.string(forKey: "cost_method") == "1" {
            
            costPerItem.backgroundColor = UIColor(named: "Disabled Text")
            costPerItem.setOutlineColor(.clear, for: .normal)
            costPerItem.setOutlineColor(.clear, for: .editing)
            costItemInner.isHidden = false
        }
        else {
            costPerItem.backgroundColor = .systemBackground
            costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
            costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
            costItemInner.isHidden = true
        }
        
        margin.backgroundColor = UIColor(named: "Disabled Text")
        profit.backgroundColor = UIColor(named: "Disabled Text")
        marginInner.isHidden = false
        profitInner.isHidden = false
        qtyInner.isHidden = false
        
        margin.setOutlineColor(.clear, for: .normal)
        margin.setOutlineColor(.clear, for: .editing)
        profit.setOutlineColor(.clear, for: .normal)
        profit.setOutlineColor(.clear, for: .editing)
        
        
      
        margin.layer.cornerRadius = 5
        reorderQty.layer.cornerRadius = 5
        reorderLevel.layer.cornerRadius = 5

        profit.layer.cornerRadius = 5
        costPerItem.layer.cornerRadius = 5
        
        qty.backgroundColor = UIColor(named: "Disabled Text")
        qty.setOutlineColor(.clear, for: .normal)
        qty.setOutlineColor(.clear, for: .editing)
        qty.layer.cornerRadius = 5
    }
    
    func inventSettingsCall(){
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.inventorySettingCall(merchant_id: id, completion: {isSuccess, responseData in
            
            if isSuccess {
                
                guard let setting = responseData["result"] else {
                    return
                }
                
                let response = setting as! [String:Any]
                print(response)
                let cost_per = response["cost_per"] as? String ?? ""
                let cost_method = response["cost_method"] as? String ?? ""
                print(cost_per)
                print(cost_method)
                let req_Desc = response["inv_setting"] as? String ?? ""
                if req_Desc.contains("2") {
                    UserDefaults.standard.set(true, forKey: "Po Descrip")
                }
                else{
                    UserDefaults.standard.set(false, forKey: "Po Descrip")
                }
                UserDefaults.standard.set(cost_per, forKey: "cost_per_value")
                UserDefaults.standard.set(cost_method, forKey: "6")
            }else{
                print("Api Error")
            }
        })
    }
    
    @objc func genUpcClick() {
        
        var upc = ""
        
        if upcCode.text == "" {
            upc = getGeneratedUpc(length: 12)
            let string_upc = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
            if string_upc.contains(upc) {
                ToastClass.sharedToast.showToast(message: " Duplicate UPC found", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                upcCode.text = upc
            }
        }
    }
    
    func getGeneratedUpc(length: Int) -> String {
        let characters = "0123456789"
        var result = ""
        for _ in 0..<length {
            let resInt = Int(floor(Double.random(in: 0.0...0.9) * Double(characters.count)))
            result += String(resInt)
            print(result)
        }
        
        return result
    }
                  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toVarSalesVC" {
            let vc = segue.destination as! SalesHistoryViewController
            
            if is_v == "1" {
                vc.salesVar_id  = ""
                vc.salesVar_name = v_name
                vc.salesProd_id = v_id
            }
            else {
                vc.salesVar_id  = v_id
                vc.salesVar_name = v_name
                vc.salesProd_id = p_id
            }
            print(v_id)
            print(v_name)
            print(p_id)
          }
    }
    
    func setUpVarIdApi() {
        
        ApiCalls.sharedCall.variantById(var_id: v_id, name: v_name, single: is_v) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let variant = responseData["var_data"] else {
                    return
                }
                self.getResponseValuesById(vari: variant)
                
                DispatchQueue.main.async {
                    self.loadingIndicator.isAnimating = false
                }
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValuesById(vari: Any) {
        
        let res = vari as! [String:Any]
            
        let variant = InventoryVariantId(HS_code: "\(res["HS_code"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                                         alternateName: "\(res["alternateName"] ?? "")", assigned_vendors: "\(res["assigned_vendors"] ?? "")",
                                         barcode: "\(res["barcode"] ?? "")", buy_with_product: "\(res["buy_with_product"] ?? "")",
                                         compare_price: "\(res["compare_price"] ?? "")", costperItem: "\(res["costperItem"] ?? "")",
                                         cotegory: "\(res["cotegory"] ?? "")", country_region: "\(res["country_region"] ?? "")",
                                         created_on: "\(res["created_on"] ?? "")",
                                         custom_code: "\(res["custom_code"] ?? "")", description: "\(res["description"] ?? "")",
                                         disable: "\(res["disable"] ?? "")", food_stampable: "\(res["food_stampable"] ?? "")", env: "\(res["env"] ?? "")",
                                         featured_product: "\(res["featured_product"] ?? "")", id: "\(res["id"] ?? "")",
                                         is_tobacco: "\(res["is_tobacco"] ?? "")", ischargeTax: "\(res["ischargeTax"] ?? "")",
                                         ispysical_product: "\(res["ispysical_product"] ?? "")", isstockcontinue: "\(res["isstockcontinue"] ?? "")",
                                         isvarient: "\(res["isvarient"] ?? "")", loyalty_product_id: "\(res["loyalty_product_id"] ?? "")",
                                         margin: "\(res["margin"] ?? "")", media: "\(res["media"] ?? "")",
                                         merchant_id: "\(res["merchant_id"] ?? "")", other_taxes: "\(res["other_taxes"] ?? "")",
                                         prefferd_vendor: "\(res["prefferd_vendor"] ?? "")",
                                         price: "\(res["price"] ?? "")",
                                         product_doc: "\(res["product_doc"] ?? "")", product_id: "\(res["product_id"] ?? "")",
                                         profit: "\(res["profit"] ?? "")", quantity: "\(res["quantity"] ?? "")",
                                         reorder_cost: "\(res["reorder_cost"] ?? "")", reorder_level: "\(res["reorder_level"] ?? "")",
                                         reorder_qty: "\(res["reorder_qty"] ?? "")", show_stats: "\(res["show_stats"] ?? "")",
                                         show_type: "\(res["show_type"] ?? "")", sku: "\(res["sku"] ?? "")",
                                         starting_quantity: "\(res["starting_quantity"] ?? "")", title: "\(res["title"] ?? "")",
                                         trackqnty: "\(res["trackqnty"] ?? "")", upc: "\(res["upc"] ?? "")",
                                         updated_on: "\(res["updated_on"] ?? "")", user_id: "\(res["user_id"] ?? "")")
        setupValues(variantObj: variant)
                    
    }
    
    
    func setupValues(variantObj: InventoryVariantId) {
                
        price.text = variantObj.price
        compareAtPrice.text = variantObj.compare_price
        costPerItem.text = variantObj.costperItem
        margin.text = variantObj.margin
        profit.text = variantObj.profit
        qty.text = variantObj.quantity
        customCode.text = variantObj.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        upcCode.text = variantObj.upc
        reorderQty.text = variantObj.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        reorderLevel.text = variantObj.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let track = variantObj.trackqnty
        let check_id = variantObj.is_tobacco
        let con_sell = variantObj.isstockcontinue
        let dis = variantObj.disable
        let food = variantObj.food_stampable
   
        
        UserDefaults.standard.set(variantObj.upc, forKey: "upc_previous")
        
        setCheckBox(track: track, check_id: check_id, con: con_sell, disab: dis, food: food)
    }
    
    func setCheckBox(track: String, check_id: String, con: String, disab: String, food: String) {
        
        if track == "0" {
            trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else{
            trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        if check_id == "0" {
            checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else{
            checkID.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        if con == "0" {
            selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else{
            selling.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        if disab == "0" {
            disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else{
            disable.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        if food == "0" {
            foodStampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        else{
            foodStampable .setImage(UIImage(named: "check inventory"), for: .normal)
        }
        
        
        let fontText = UIFont(name: "Manrope-Bold", size: 16.0)
        quantLbl.text = "Track Quantity"
        quantLbl.font = fontText
        sellingLbl.text = "Continue selling when out of stock"
        sellingLbl.font = fontText
        checkIDlBL.text = "Check ID"
        checkIDlBL.font = fontText
        disableLbl.text = "Disable"
        disableLbl.font = fontText
    
    }
    
    func checkQuant() -> String {
        
        if trackQty.currentImage == UIImage(named: "check inventory") {
            return "1"

        }
        else {
            return "0"

        }
    }
    
    func checkSell() -> String {
        if checkID.currentImage == UIImage(named: "check inventory") {
            return "1"

        }
        else {
            return "0"

        }
    }
    
    func checkIdBox() -> String {
        if selling.currentImage == UIImage(named: "check inventory") {
            return "1"

        }
        else {
            return "0"

        }
    }
    
    func checkDis() -> String {
        
        if disable.currentImage == UIImage(named: "check inventory") {
            return "1"

        }
        else {
            return "0"

        }
    }
    
    
    func checkFood() -> String {
      
        if foodStampable.currentImage == UIImage(named: "check inventory") {
            return "1"

        }
        else {
            return "0"

        }
    }
    
    func saveValidate() {
        
        guard let mprice = price.text, mprice != "", mprice != "0.00" else {
            price.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let c_price = price.text ?? ""
        let c_compareprice = compareAtPrice.text ?? ""
        
        if c_compareprice != "" && c_compareprice != "0.00" {
            
            let newCompareprice = Double(c_compareprice)!
            let newPrice = Double(c_price)!
            
            guard newPrice.isLessThanOrEqualTo(newCompareprice) else {
                ToastClass.sharedToast.showToast(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                compareAtPrice.isError(numberOfShakes: 3, revert: true)
                return
            }
        }
        
        
            
        guard let upcCodeText = upcCode.text, upcCodeText != "" else {
            upcCode.isError(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let string_upc = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
        
        let upc_previous = UserDefaults.standard.string(forKey: "upc_previous")
        
        if upcCodeText == upc_previous {
            
        }
        
        else {
            
            guard !string_upc.contains(upcCodeText) else {
                upcCode.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: " Duplicate UPC found", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        }
        
        let com_price = compareAtPrice.text ?? ""
        let cost = costPerItem.text ?? ""
        let marginText = margin.text ?? ""
        let profitText = profit.text ?? ""
        let quanty = qty.text ?? ""
        let custom = customCode.text ?? ""
        
        var reorder_qty = reorderQty.text ?? ""
        var reorder_level = reorderLevel.text ?? ""
        
        if reorder_qty == "" {
            reorder_qty = "0"
        }
        
        if reorder_level == "" {
            reorder_level = "0"
        }
        
        loadIndicator.isAnimating = true
        
        
        ApiCalls.sharedCall.variantUpdateCall(var_id: v_id, name: v_name, single: is_v,
                                              price: c_price, compare_price: com_price,
                                              costperItem: cost, margin: marginText,
                                              profit: profitText, quantity: quanty,
                                              upc: upcCodeText, custom_code: custom,
                                              reorder_qty: reorder_qty, reorder_level: reorder_level, reorder_cost: "",
                                              track_quantity: checkQuant(), continue_selling: checkSell(),
                                              checkid: checkIdBox(), disable: checkDis(), food_stampable: checkFood()) { isSuccess, responseData in
            
            if isSuccess {
                
                if responseData["message"] as! String == "Product Varient Updated Successfully"
                    || responseData["message"] as! String == "Single Product Updated Successfully" {
                    self.loadIndicator.isAnimating = false
                    ToastClass.sharedToast.showToast(message: " Updated Successfully", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    print("staus false")
                    self.loadIndicator.isAnimating = false
                }
            }
            else{
                print("Api Error")
            }
        }
        
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
    
        saveValidate()
    }


    
    @IBAction func checkBoxes(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
        }
        
        else if sender.tag == 2 {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
        }
        
        else if sender.tag == 3 {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
        }
        
        else if sender.tag == 4 {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
        }
        
        else if sender.tag == 5 {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
        }
        
        else {
            
            if sender.currentImage == UIImage(named: "check inventory") {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else{
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
            }
        }
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
        
        if textField.text == "0000" {
            textField.text = "00000"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == qty {
            activeTextField = textField
            
        }else if textField == upcCode {
            activeTextField = textField
            
        }else if textField == customCode {
            activeTextField = textField
        }
        else if textField == reorderQty {
            activeTextField = textField
        }
        else if textField == reorderLevel {
            activeTextField = textField
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == upcCode {
            
            let upcText = textField.text ?? ""
            
            if upcText == "" { }
            else {
                let string_upc = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
                if string_upc.contains(upcText) {
                    ToastClass.sharedToast.showToast(message: " Duplicate UPC found", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    upcCode.isError(numberOfShakes: 3, revert: true)
                    upcCode.text = ""
                }
                else {
                    upcCode.text = upcText
                }
            }
        }
    }
 
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == qty{
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        else if textField == upcCode {
            if updatetext.count > 20 {
                updatetext = String(updatetext.dropLast())
            }
        }
        else if textField == customCode {
            if updatetext.count > 30{
                updatetext = String(updatetext.dropLast())
            }
        }
        else if textField == reorderQty {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        else if textField == reorderLevel {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
    }
   
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func salesHistoryClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toVarSalesVC", sender: nil)
    }
    

    @IBAction func instantPoClick(_ sender: UIButton) {
     
        UserDefaults.standard.set(false, forKey: "var_api_hit")
        UserDefaults.standard.set("variant", forKey: "toInstantPO")
        
        if UserDefaults.standard.bool(forKey: "Po Descrip"){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "podesc") as! InstantPODescViewController
            vc.ipoProd_id = p_id
            vc.ipoVari_id = v_id
            vc.ipoIsV = is_v
            
            let transition = CATransition()
            transition.duration = 0.7
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "quantity") as! POQuantityViewController
            vc.ipoProd_id = p_id
            vc.ipoVari_id = v_id
            vc.descIsV = is_v
            
            let transition = CATransition()
            transition.duration = 0.7
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
    }

    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 16.0)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
    
    func createCustomTextFieldCost(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 16.0)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    private func setupSaveUI() {
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
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    
    @IBAction func openScan(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
        
    }
}


extension VariantInfoViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate,
                                    BarcodeScannerErrorDelegate {
    
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        let upcText = code
        
        let string_upc = UserDefaults.standard.stringArray(forKey: "variant_upcs") ?? []
        
        if string_upc.contains(upcText) {
            controller.dismiss(animated: true)
            ToastClass.sharedToast.showToast(message: " Duplicate UPC found", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            
            upcCode.text = ""
        }
        else {
            controller.dismiss(animated: true)
            upcCode.text = upcText
        }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        controller.dismiss(animated: true)
    }
}
