//
//  AddEditLotteryViewController.swift
//
//
//  Created by Jamaluddin Syed on 03/09/24.
//

import UIKit
import MaterialComponents
import BarcodeScanner

class AddEditLotteryViewController: UIViewController {
    
    
    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var upcField: UITextField!
    
    @IBOutlet weak var trackQtyBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addProductLbl: UILabel!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var genUpcLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var del_width: NSLayoutConstraint!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    var categoryLottery = [InventoryCategory]()
    var cat_ids = [String]()
    
    var lottery_id = ""
    var mode = ""
    var track_check = ""
    
    private var isSymbolOnRight = false
    var activeTextField = UITextField()
    
    var lotteryProduct: ProductById?
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topview.addBottomShadow()
        
        productNameField.autocapitalizationType = .words
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
        addBtn.layer.cornerRadius = 10
        
        let colLay = CustomFlowLayout()
        collection.collectionViewLayout = colLay
        colLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collection.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        collection.layer.borderWidth = 1.0
        collection.layer.cornerRadius = 10
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(openCategory))
        categoryView.addGestureRecognizer(tap1)
        tap1.numberOfTapsRequired = 1
        categoryView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(openCategory))
        collection.addGestureRecognizer(tap2)
        tap2.numberOfTapsRequired = 1
        collection.isUserInteractionEnabled = true
        
        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(genUpcClick))
        genUpcLbl.addGestureRecognizer(tapUpc)
        tapUpc.numberOfTapsRequired = 1
        genUpcLbl.isUserInteractionEnabled = true
        
        priceField.keyboardType = .numberPad
        quantityField.keyboardType = .numberPad
        
        productNameField.delegate = self
        priceField.delegate = self
        quantityField.delegate = self
        upcField.delegate = self
        
        productNameField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        quantityField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        upcField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        priceField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        
        if mode == "update" {
            
            setupApi()
            addProductLbl.text = "Edit Lottery"
            deleteBtn.isHidden = false
            del_width.constant = 50
            addBtn.setTitle("Update", for: .normal)
            quantityField.isEnabled = false
        }
        else {
            
            trackQtyBtn.setImage(UIImage(named: "check inventory"), for: .normal)
            track_check = "1"
            addProductLbl.text = "Add Lottery"
            deleteBtn.isHidden = true
            del_width.constant = 0
            addBtn.setTitle("Add", for: .normal)
            scrollHeight.constant = 620
            quantityField.isEnabled = true
        }
    }
    
    func setupApi() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productById(product_id: lottery_id, merchant_id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["productdata"] else {
                    return
                }
                
                self.getResponseById(list: list)
                
                guard let cat_list = responseData["coll"] else {
                    return
                }
                
                self.getCats(cat_list: cat_list)
            }
            else {
                print("Api Failed")
            }
        }
    }
    
    func getResponseById(list: Any) {
        
        let product = list as! [String: Any]
        
        let productEdit = ProductById(alternateName: "\(product["alternateName"] ?? "")",
                                      admin_id: "\(product["admin_id"] ?? "")",
                                      description: "\(product["description"] ?? "")",
                                      starting_quantity: "\(product["starting_quantity"] ?? "")",
                                      margin: "\(product["margin"] ?? "")",
                                      brand: "\(product["brand"] ?? "")",
                                      tags: "\(product["tags"] ?? "")",
                                      upc: "\(product["upc"] ?? "")",
                                      id: "\(product["id"] ?? "")",
                                      sku: "\(product["sku"] ?? "")",
                                      disable: "\(product["disable"] ?? "")",
                                      food_stampable: "\(product["food_stampable"] ?? "")",
                                      isvarient: "\(product["isvarient"] ?? "")",
                                      is_lottery: "\(product["is_lottery"] ?? "")",
                                      title: "\(product["title"] ?? "")",
                                      quantity: "\(product["quantity"] ?? "")",
                                      ischargeTax: "\(product["ischargeTax"] ?? "")",
                                      updated_on: "\(product["updated_on"] ?? "")",
                                      isstockcontinue: "\(product["isstockcontinue"] ?? "")",
                                      trackqnty: "\(product["trackqnty"] ?? "")",
                                      profit: "\(product["profit"] ?? "")",
                                      custom_code: "\(product["custom_code"] ?? "")",
                                      assigned_vendors: "\(product["assigned_vendors"] ?? "")",
                                      barcode: "\(product["barcode"] ?? "")",
                                      country_region: "\(product["country_region"] ?? "")",
                                      ispysical_product: "\(product["ispysical_product"] ?? "")",
                                      show_status: "\(product["show_status"] ?? "")",
                                      HS_code: "\(product["HS_code"] ?? "")",
                                      price: "\(product["price"] ?? "")",
                                      featured_product: "\(product["featured_product"] ?? "")",
                                      merchant_id: "\(product["merchant_id"] ?? "")",
                                      created_on: "\(product["created_on"] ?? "")",
                                      prefferd_vendor: "\(product["prefferd_vendor"] ?? "")",
                                      reorder_cost: "\(product["reorder_cost"] ?? "")",
                                      other_taxes: "\(product["other_taxes"] ?? "")",
                                      buy_with_product: "\(product["buy_with_product"] ?? "")",
                                      costperItem: "\(product["costperItem"] ?? "")",
                                      is_tobacco: "\(product["is_tobacco"] ?? "")",
                                      product_doc: "\(product["product_doc"] ?? "")",
                                      user_id: "\(product["user_id"] ?? "")",
                                      media: "\(product["media"] ?? "")",
                                      compare_price: "\(product["compare_price"] ?? "")",
                                      loyalty_product_id: "\(product["loyalty_product_id"] ?? "")",
                                      show_type: "\(product["show_type"] ?? "")",
                                      cotegory: "\(product["cotegory"] ?? "")",
                                      reorder_level: "\(product["reorder_level"] ?? "")",
                                      env: "\(product["env"] ?? "")", variant: "",
                                      reorder_qty: "\(product["reorder_qty"] ?? "")",
                                      purchase_qty: "\(product["purchase_qty"] ?? "")")
        
        lotteryProduct = productEdit
        
        let name = lotteryProduct?.title ?? ""
        let price = lotteryProduct?.price ?? ""
        let quantity = lotteryProduct?.quantity ?? ""
        let upc = lotteryProduct?.upc ?? ""
        let track = lotteryProduct?.trackqnty ?? ""
        
        if track == "1" {
            track_check = "1"
            trackQtyBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        else {
            track_check = "0"
            trackQtyBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        let cat = lotteryProduct?.cotegory ?? ""
        
        cat_ids = cat.components(separatedBy: ",")
        
        productNameField.text = name
        priceField.text = price
        quantityField.text = quantity
        upcField.text = upc
    }
    
    func getCats(cat_list: Any) {
        
        let response = cat_list as! [[String:Any]]
        var catArray = [InventoryCategory]()
        
        for res in response {
            
            let category = InventoryCategory(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                             description: "\(res["description"] ?? "")",
                                             categoryBanner: "\(res["categoryBanner"] ?? "")",
                                             show_online: "\(res["show_online"] ?? "")",
                                             show_status: "\(res["show_status"] ?? "")",
                                             cat_show_status: "\(res["cat_show_status"] ?? "")", 
                                             is_lottery: "\(res["is_lottery"] ?? "")",
                                             alternateName: "\(res["alternateName"] ?? "")",
                                             merchant_id: "\(res["merchant_id"] ?? "")",
                                             is_deleted: "\(res["is_deleted"] ?? "")",
                                             user_id: "\(res["user_id"] ?? "")",
                                             created_on: "\(res["created_on"] ?? "")",
                                             updated_on: "\(res["updated_on"] ?? "")",
                                             admin_id: "\(res["admin_id"] ?? "")",
                                             use_point: "\(res["use_point"] ?? "")",
                                             earn_point: "\(res["earn_point"] ?? "")")
            
            catArray.append(category)
        }
        
        var smallCat = [InventoryCategory]()
        
        for cat in catArray {
            
            if cat_ids.contains(where: {$0 == cat.id}) {
                smallCat.append(cat)
            }
        }
        
        if smallCat.count > 0 {
            
            categoryLottery = smallCat
            
            if collection.isHidden {
                collection.isHidden = false
                categoryView.isHidden = true
            }
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        else {
            
            collection.isHidden = true
            categoryView.isHidden = false
        }
    }
  
    @objc func openCategory() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateLottery = self
        vc.catMode = "lotteryVc"
        vc.selectCategory = categoryLottery
        vc.apiMode = "category"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func genUpcClick() {
        
        if upcField.text == "" {
            let upcCode = getGeneratedUpc(length: 12)
            upcField.text = upcCode
        }
    }
    
    func getGeneratedUpc(length: Int) -> String {
        
        let characters = "0123456789"
        var result = ""
        for _ in 0..<length {
            let resInt = Int(floor(Double.random(in: 0.0...0.9) * Double(characters.count)))
            result += String(resInt)
        }
        
        return result
    }
    
    func validateAddParams() {
        
        guard let name = productNameField.text, name != "" else {
            productNameField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Product Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let price = priceField.text, price != "" else {
            priceField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let quantity = quantityField.text, quantity != "" else {
            quantityField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small_id = [String]()
        
        if categoryLottery.count > 0 {
            
            for category_id in categoryLottery {
                small_id.append(category_id.id)
            }
        }
        else {
            
            guard false else {
                collection.isErrorView(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        }
        
        let cat_id = small_id.joined(separator: ",")
        
        guard let upc = upcField.text, upc != "" else {
            upcField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let track_qty = track_check
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.productAddCall(id: m_id, title: name, description: "",
                                           brand: "", tags: "", price: price, compare_price: "0.00",
                                           costperItem: "0.00", margin: "0.00", profit: "0.00",
                                           ischargeTax: "0", trackqnty: track_qty, isstockcontinue: "0",
                                           quantity: quantity, collection: cat_id, isvarient: "0",
                                           is_lottery: "1", created_on: "",
                                           optionarray: "", optionarray1: "", optionarray2: "",
                                           optionvalue: "", optionvalue1: "", optionvalue2: "",
                                           other_taxes: "", bought_product: "",
                                           featured_product: "", varvarient: "",
                                           varprice: "", varcompareprice: "",
                                           varcostperitem: "", varquantity: "",
                                           upc: upc, custom_code: "", reorder_qty: "0",
                                           reorder_level: "0", reorder_cost: "0.00",
                                           is_tobacco: "0", disable: "0", food_stampable: "0",
                                           varupc: "", varcustomcode: "", vartrackqnty: "",
                                           varcontinue_selling: "", varcheckid: "", vardisable: "",
                                           varfood_stampable: "", varmargin: "", varprofit: "",
                                           varreorder_qty: "", varreorder_level: "", varreorder_cost: "") { isSuccess, responseData in
            
            
            if isSuccess {
                
                
                if let list = responseData["message"] as? String {
                    print(list)
                    if list == "Success" {
                        self.loadIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.loadIndicator.isAnimating = false
                        ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                }
            }
            else {
                print("failed")
                self.loadIndicator.isAnimating = false
            }
        }
    }
    
    
    func validateEditParams() {
        
        let id = lottery_id
        
        guard let name = productNameField.text, name != "" else {
            productNameField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Product Name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let price = priceField.text, price != "" else {
            priceField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        guard let quantity = quantityField.text, quantity != "" else {
            quantityField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small_id = [String]()
        
        if categoryLottery.count > 0 {
            
            for category_id in categoryLottery {
                small_id.append(category_id.id)
            }
        }
        else {
            
            guard false else {
                collection.isErrorView(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
        }
        
        let cat_id = small_id.joined(separator: ",")
        
        guard let upc = upcField.text, upc != "" else {
            upcField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let track_qty = track_check
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.productEditCall(merchant_id: m_id, admin_id: "", title: name,
                                            alternateName: "", description: "", brand: "", tags: "",
                                            price: price, compare_price: "0.00", costperItem: "0.00",
                                            margin: "0.00", profit: "0.00", ischargeTax: "0",
                                            sku: "", upc: upc, custom_code: "",
                                            barcode: "", trackqnty: track_qty, isstockcontinue: "0",
                                            quantity: quantity, ispysical_product: "", country_region: "",
                                            collection: cat_id, HS_code: "",
                                            isvarient: "0", is_lottery: "1",
                                            multiplefiles: "", img_color_lbl: "", created_on: "",
                                            productid: id,
                                            optionarray: "", optionarray1: "", optionarray2: "",
                                            optionvalue: "", optionvalue1: "", optionvalue2: "",
                                            other_taxes: "", bought_product: "",
                                            featured_product: "", varvarient: "",
                                            varprice: "", varquantity: "", varsku: "",
                                            varbarcode: "", files: "", doc_file: "", optionid: "",
                                            varupc: "", varcustomcode: "", reorder_qty: "0",
                                            reorder_level: "0", reorder_cost: "0.00", is_tobacco: "0",
                                            disable: "0", food_stampable: "0",
                                            vartrackqnty: "", varcontinue_selling: "", varcheckid: "",
                                            vardisable: "", varfood_stampable: "",
                                            varmargin: "", varprofit: "",
                                            varreorder_qty: "", varreorder_level: "",
                                            varreorder_cost: "", varcostperitem: "", varcompareprice: "",
                                            var_id: "") { isSuccess, responseData in
            
            if isSuccess {
                
                self.loadIndicator.isAnimating = false
                ToastClass.sharedToast.showToast(message: "Product updated successfully",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.loadIndicator.isAnimating = false
            }
        }
    }
  
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_lottery") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this product?",
                                                    preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in

            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                self.setupDeleteApi()
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func setupDeleteApi() {
        
        let id = lottery_id
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productDeleteCall(product_id: id, id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: "Product delete successfully",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                print("Api Error")
            }
        }
    }

    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
 
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if mode == "update" {
            validateEditParams()
        }
        else {
            validateAddParams()
        }
    }
 
    @IBAction func trackQtyClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            track_check = "1"
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        else {
            track_check = "0"
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
    }
 
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        categoryLottery.remove(at: sender.tag)
        if categoryLottery.count > 0 {
            collection.reloadData()
        }
        else {
            setCatHeight()
            collection.isHidden = true
            categoryView.isHidden = false
        }
    }
    
    func setCatHeight() {
        
        let height = collection.collectionViewLayout.collectionViewContentSize.height
        
        if height <= 50 {
            collHeight.constant = 50
        }
        else {
            collHeight.constant = height
        }
        scrollHeight.constant = 620 + collHeight.constant
        
        if categoryLottery.count == 0 {
            
            categoryView.isHidden = false
            collection.isHidden = true
        }
        else {
            categoryView.isHidden = true
            collection.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
}

extension AddEditLotteryViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == productNameField {
            activeTextField = textField
        }
        if textField == priceField {
            activeTextField = textField
        }
        else if textField == quantityField {
            activeTextField = textField
        }
        else if  textField == upcField {
            activeTextField = textField
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == upcField {
            
            let upcText = textField.text ?? ""
            
            let string_upc = UserDefaults.standard.stringArray(forKey: "lottery_upcs_list") ?? []
            
            if string_upc.contains(upcText) {
                ToastClass.sharedToast.showToast(message: "Duplicate UPC found",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                upcField.text = ""
            }
            else {
                upcField.text = upcText
            }
        }
    }
    
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == productNameField {
            
            if updatetext.count > 50 {
                updatetext = String(updatetext.dropLast())
            }
            
            else {
                
                let update = updatetext.last
                
                if update == "," || update == "~"
                    || update == "/" || update == "-"
                    || update ==  "\u{005c}" {
                    updatetext = String(updatetext.dropLast())
                }
            }
        }
        
        else if textField == quantityField {
            if updatetext.count > 6 {
                updatetext = String(updatetext.dropLast())
            }
        }
        
        else if textField == upcField {
            if updatetext.count > 20 {
                updatetext = String(updatetext.dropLast())
            }
        }
        activeTextField.text = updatetext
    }
    
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
    
    private func setUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        addBtn.addSubview(loadIndicator)
        var center = 40
        if mode == "add" {
            center = 30
        }
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}

extension AddEditLotteryViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        if categoryArray.count > 0 {
            
            categoryLottery = categoryArray
            
            if collection.isHidden {
                collection.isHidden = false
                categoryView.isHidden = true
            }
        }
        else {
            collection.isHidden = true
            categoryView.isHidden = false
        }
        collection.reloadData()
    }
}

extension AddEditLotteryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryLottery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "catcell", for: indexPath) as! PlusCollCollectionViewCell
        
        cell.catPlusLbl.text = categoryLottery[indexPath.row].title
        cell.borderview.layer.cornerRadius = 5.0
        cell.closeBtn.tag = indexPath.row
        
        setCatHeight()
        
        return cell
    }
}
