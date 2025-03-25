  //
//  PlusViewController.swift
//
//
//  Created by Jamaluddin Syed on 09/07/24.
//

import UIKit
import MaterialComponents
import BarcodeScanner

protocol PlusSelectedCategory: AnyObject {
    
    func getSelectedCats(reverseCategory: [InventoryCategory], reverseBrandsTags: [String],
                         reverseTaxes: [SetupTaxes], apiMode: String)
}

protocol PlusAttributeVariant : AnyObject {
    
    func getAddedAtttributes(optName: String, optValue: String, newEdit: [String])
}

//Add Product View Controller
class PlusViewController: UIViewController {
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scroll: UIView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var collView: UIView!
    @IBOutlet weak var attView: UIView!
    @IBOutlet weak var variantsView: UIView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var upcLbl: UILabel!
    
    @IBOutlet weak var productField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    @IBOutlet weak var brandView: UIView!
    
    @IBOutlet weak var selectBrandLbl: UILabel!
    @IBOutlet weak var brandInnerView: UIView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandCloseBtn: UIButton!
    
    @IBOutlet weak var catColl: UICollectionView!
    @IBOutlet weak var tagColl: UICollectionView!
    @IBOutlet weak var taxesColl: UICollectionView!
    
    @IBOutlet weak var catcollHeight: NSLayoutConstraint!
    @IBOutlet weak var tagCollHeight: NSLayoutConstraint!
    @IBOutlet weak var taxCollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var attTable: UITableView!
    @IBOutlet weak var attHeight: NSLayoutConstraint!
    
    @IBOutlet weak var variantsTable: UITableView!
    @IBOutlet weak var addVarBtn: UIButton!
    @IBOutlet weak var addVarBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var addVarTop: NSLayoutConstraint!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var dupView: UIView!
    @IBOutlet weak var maxView: UIView!
    
    @IBOutlet weak var tripleWidth: NSLayoutConstraint!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var isSymbolOnRight = false
    
    var isSelectedData = [Bool]()
    
    var isQuantity = [String]()
    
    var arrTaxId = [String]()
    var arrTax = [SetupTaxes]()
    var collTax = [SetupTaxes]()
    
    var arrCatId = [String]()
    var arrCat = [InventoryCategory]()
    var collCat = [InventoryCategory]()
    
    var collTag = [String]()
    
    var productOptions = [InventoryOptions]()
    
    var newEditArr = [String]()
    var result = [String]()
    
    var activeTextField = UITextField()
    var activeTextUpcText = ""
    
    var scanIndex = 0
    var editCombo = 0
    var addCombo = 0
    
    var p_id = ""
    var mode = ""
    
    var variantMode = ""
    var variantGoMode = "plus"
    var attIndex = 0
    var selectAtt = [InventoryOptions]()
    var selectOption: InventoryOptions?
    
    var arrOptVl1 = [String]()
    var arrOptVl2 = [String]()
    var arrOptVl3 = [String]()
    
    var prod_purchaseQty = ""
    var variantsArray = [ProductById]()
    var editProd: ProductById?
    
    var unsel_var_array = [String]()
    
    var vari_id = ""
    var varname = ""
    var isVarient = ""
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productField.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
        descField.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
        
        
        productField.autocapitalizationType = .words
        descField.autocapitalizationType = .sentences
        
        productField.placeholder = "Enter Name"
        selectBrandLbl.text = "Select Brand"
        descField.placeholder = "Enter Product Description"
        
        productField.smartDashesType = .no
        
        brandView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        brandView.layer.borderWidth = 1.0
        catColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        catColl.layer.borderWidth = 1.0
        tagColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        tagColl.layer.borderWidth = 1.0
        taxesColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        taxesColl.layer.borderWidth = 1.0
        
        brandView.layer.cornerRadius = 5.0
        catColl.layer.cornerRadius = 5.0
        tagColl.layer.cornerRadius = 5.0
        taxesColl.layer.cornerRadius = 5.0
        
        let colLay = CustomFlowLayout()
        catColl.collectionViewLayout = colLay
        colLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collLay = CustomFlowLayout()
        tagColl.collectionViewLayout = collLay
        collLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let colllLay = CustomFlowLayout()
        taxesColl.collectionViewLayout = colllLay
        colllLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        addVarBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
        addVarBtn.layer.borderWidth = 1.0
        addVarBtn.layer.cornerRadius = 5
        addVarBtn.backgroundColor = .white
        
        let brand_tap = UITapGestureRecognizer(target: self, action: #selector(openBrandScreen))
        brandView.addGestureRecognizer(brand_tap)
        brand_tap.numberOfTapsRequired = 1
        brandView.isUserInteractionEnabled = true
        
        let cat_tap = UITapGestureRecognizer(target: self, action: #selector(openCatScreen))
        catColl.addGestureRecognizer(cat_tap)
        cat_tap.numberOfTapsRequired = 1
        catColl.isUserInteractionEnabled = true
        
        let tag_tap = UITapGestureRecognizer(target: self, action: #selector(openTagScreen))
        tagColl.addGestureRecognizer(tag_tap)
        tag_tap.numberOfTapsRequired = 1
        tagColl.isUserInteractionEnabled = true
        
        let tax_tap = UITapGestureRecognizer(target: self, action: #selector(openTaxScreen))
        taxesColl.addGestureRecognizer(tax_tap)
        tax_tap.numberOfTapsRequired = 1
        taxesColl.isUserInteractionEnabled = true
        
        let first_tap = UITapGestureRecognizer(target: self, action: #selector(purchaseQtyClick))
        maxView.addGestureRecognizer(first_tap)
        first_tap.numberOfTapsRequired = 1
        maxView.isUserInteractionEnabled = true
        
        let second_tap = UITapGestureRecognizer(target: self, action: #selector(dupClick))
        dupView.addGestureRecognizer(second_tap)
        second_tap.numberOfTapsRequired = 1
        dupView.isUserInteractionEnabled = true
        
        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(genUpcClick))
        upcLbl.addGestureRecognizer(tapUpc)
        tapUpc.numberOfTapsRequired = 1
        upcLbl.isUserInteractionEnabled = true
        
        cancelBtn.layer.cornerRadius = 10
        saveBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        attTable.estimatedSectionFooterHeight = 0
        attTable.estimatedSectionHeaderHeight = 0
        variantsTable.estimatedSectionFooterHeight = 0
        
        productField.delegate = self
        productField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        
        if #available(iOS 15.0, *) {
            variantsTable.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        topview.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        
        saveBtn.isEnabled = true
        upperView.isHidden = true
     
        
        if mode == "add" {
            
         
            saveBtn.setTitle("Add", for: .normal)
            tripleWidth.constant = 0
            titleText.text = "Add Product"
            
            if variantsArray.count == 0 {
                
                let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
                                            brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0",
                                            isvarient: "", is_lottery: "", title: "", quantity: "", ischargeTax: "",
                                            updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
                                            assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
                                            show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
                                            created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
                                            buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
                                            media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
                                            reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
                
                variantsArray.append(emptyProd)
            }
            
            var isSel = [Bool]()
            for i in 0..<variantsArray.count {
                
                if i == 0 {
                    isSel.append(true)
                }
                else {
                    isSel.append(false)
                }
            }
            isSelectedData = isSel
            
            selectBrandLbl.text = "Select Brand"
            brandInnerView.isHidden = true
            brandName.text = ""
            brandCloseBtn.isHidden = true
            
            setupTax()
            setCollHeight(coll: scrollView)
        }
        
        //edit
        else {
            
            saveBtn.setTitle("Update", for: .normal)
            tripleWidth.constant = 50
            titleText.text = "Edit Product"
            
            scroll.isHidden = true
            loadingIndicator.isAnimating = true
            setUpProductApiId()
        }
        inventSettingsCall()
    }
  
    func setUpProductApiId() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productById(product_id: p_id, merchant_id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["productdata"] else {
                    return
                }
                
                self.getResponseById(list: list)
                
                guard let var_list = responseData["varients"] else {
                    return
                }
                
                self.getVarients(list: var_list)
                
                guard let opt_list = responseData["options"] else {
                    return
                }
                
                self.getOptions(opt_list: opt_list)
                
                //                guard let var_list = responseData["bulk_pricing"] else {
                //                    return
                //                }
                //
                //                self.getBulk(list: var_list)
                //
                //                guard let unselect_list = responseData["all_unassigned_vars_array"] else {
                //                    return
                //                }
                //
                //                self.unsel_var_array = unselect_list as! [String]
                
                guard let cat_list = responseData["coll"] else {
                    return
                }
                
                self.getCats(cat_list: cat_list)
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseById(list: Any) {
        
        let product = list as? [String: Any] ?? [:]
        
        let productEdit = ProductById(alternateName: "\(product["alternateName"] ?? "")", admin_id: "\(product["admin_id"] ?? "")",
                                      description: "\(product["description"] ?? "")", starting_quantity: "\(product["starting_quantity"] ?? "")",
                                      margin: "\(product["margin"] ?? "")", brand: "\(product["brand"] ?? "")", tags: "\(product["tags"] ?? "")", upc: "\(product["upc"] ?? "")",
                                      id: "\(product["id"] ?? "")", sku: "\(product["sku"] ?? "")",
                                      disable: "\(product["disable"] ?? "")", food_stampable: "\(product["food_stampable"] ?? "")", isvarient: "\(product["isvarient"] ?? "")", is_lottery: "\(product["is_lottery"] ?? "")",
                                      title: "\(product["title"] ?? "")", quantity: "\(product["quantity"] ?? "")",
                                      ischargeTax: "\(product["ischargeTax"] ?? "")", updated_on: "\(product["updated_on"] ?? "")",
                                      isstockcontinue: "\(product["isstockcontinue"] ?? "")", trackqnty: "\(product["trackqnty"] ?? "")",
                                      profit: "\(product["profit"] ?? "")", custom_code: "\(product["custom_code"] ?? "")",
                                      assigned_vendors: "\(product["assigned_vendors"] ?? "")", barcode: "\(product["barcode"] ?? "")",
                                      country_region: "\(product["country_region"] ?? "")", ispysical_product: "\(product["ispysical_product"] ?? "")",
                                      show_status: "\(product["show_status"] ?? "")", HS_code: "\(product["HS_code"] ?? "")",
                                      price: "\(product["price"] ?? "")", featured_product: "\(product["featured_product"] ?? "")",
                                      merchant_id: "\(product["merchant_id"] ?? "")", created_on: "\(product["created_on"] ?? "")",
                                      prefferd_vendor: "\(product["prefferd_vendor"] ?? "")", reorder_cost: "\(product["reorder_cost"] ?? "")",
                                      other_taxes: "\(product["other_taxes"] ?? "")", buy_with_product: "\(product["buy_with_product"] ?? "")",
                                      costperItem: "\(product["costperItem"] ?? "")", is_tobacco: "\(product["is_tobacco"] ?? "")",
                                      product_doc: "\(product["product_doc"] ?? "")", user_id: "\(product["user_id"] ?? "")",
                                      media: "\(product["media"] ?? "")", compare_price: "\(product["compare_price"] ?? "")",
                                      loyalty_product_id: "\(product["loyalty_product_id"] ?? "")", show_type: "\(product["show_type"] ?? "")",
                                      cotegory: "\(product["cotegory"] ?? "")", reorder_level: "\(product["reorder_level"] ?? "")",
                                      env: "\(product["env"] ?? "")", variant: "", reorder_qty: "\(product["reorder_qty"] ?? "")", purchase_qty: "\(product["purchase_qty"] ?? "")")
        
        editProd = productEdit
        
        let purQuantity = productEdit.purchase_qty
        prod_purchaseQty = purQuantity
        
        isVarient = editProd?.isvarient ?? ""
        
        inflateView(prod: productEdit)
        
        let cat = productEdit.cotegory
        arrCatId = cat.components(separatedBy: ",")
        
        let tax = productEdit.other_taxes
        arrTaxId = tax.components(separatedBy: ",")
        
        let brand = productEdit.brand
        
        if brand != "" && brand != "<null>" {
            selectBrandLbl.text = ""
            brandInnerView.isHidden = false
            brandName.text = brand
            brandCloseBtn.isHidden = false
        }
        else {
            selectBrandLbl.text = "Select Brand"
            brandInnerView.isHidden = true
            brandName.text = ""
            brandCloseBtn.isHidden = true
        }
        brandInnerView.layer.cornerRadius = 5.0
        
        let prod_tags = productEdit.tags
        
        if prod_tags != "<null>" && prod_tags != ""{
            
            collTag = prod_tags.components(separatedBy: ",")
            tagColl.reloadData()
        }
        else {
            collTag = []
        }
        setupTax()
    }
    
    func inflateView(prod: ProductById) {
        
        productField.text = prod.title
        descField.text = prod.description
    }
    
    func setupTax() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productTaxList(merchant_id: m_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                guard let list_status = responseData["status"], list_status as! Int != 0 else {
                    return
                }
                
                self.getResponseTaxes(list: list)
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseTaxes(list: Any) {
        
        let response = list as! [[String:Any]]
        var first = 0
        var taxArray = [SetupTaxes]()
        for res in response {
            
            let setTax = SetupTaxes(alternateName: "\(res["alternateName"] ?? "")",
                                    created_on: "\(res["created_on"] ?? "")",
                                    displayname: "\(res["displayname"] ?? "")",
                                    id: "\(res["id"] ?? "")",
                                    merchant_id: "\(res["merchant_id"] ?? "")",
                                    percent: "\(res["percent"] ?? "")",
                                    title: "\(res["title"] ?? "")",
                                    user_id: "\(res["user_id"] ?? "")")
            if first != 0 {
                taxArray.append(setTax)
            }
            first += 1
        }
        arrTax = taxArray
        
        if mode == "add" {
            
            collTax = [arrTax[0]]
        }
        else {
            
            var smallTax = [SetupTaxes]()
            
            for tax in arrTax {
                
                if arrTaxId.contains(where: {$0 == tax.id}) {
                    smallTax.append(tax)
                }
            }
            
            collTax = smallTax
        }
        
        DispatchQueue.main.async {
            self.taxesColl.reloadData()
        }
    }
    
    @objc func genUpcClick() {
        
        if mode == "add" {
            
            var upcCode = ""
            
            for upc in 0..<variantsArray.count {
                
                if variantsArray[upc].upc == "" {
                    upcCode = getGeneratedUpc(length: 12)
                    variantsArray[upc].upc = upcCode
                }
            }
            variantsTable.reloadData()
        }
        //edit
        else {
            
            if variantsArray.count == 0 {
                let upcCode = getGeneratedUpc(length: 12)
                editProd?.upc = upcCode
                variantsTable.reloadData()
            }
            
            else {
                
                for prods in 0..<variantsArray.count {
                    
                    if variantsArray[prods].upc == "" {
                        let upcCode = getGeneratedUpc(length: 12)
                        variantsArray[prods].upc = upcCode
                    }
                }
                variantsTable.reloadData()
            }
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
    
    func getCats(cat_list: Any) {
        
        let response = cat_list as! [[String:Any]]
        var catArray = [InventoryCategory]()
        
        for res in response {
            
            let category = InventoryCategory(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                             description: "\(res["description"] ?? "")", categoryBanner: "\(res["categoryBanner"] ?? "")",
                                             show_online: "\(res["show_online"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                             cat_show_status: "\(res["cat_show_status"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")", alternateName: "\(res["alternateName"] ?? "")",
                                             merchant_id: "\(res["merchant_id"] ?? "")", is_deleted: "\(res["is_deleted"] ?? "")",
                                             user_id: "\(res["user_id"] ?? "")", created_on: "\(res["created_on"] ?? "")",
                                             updated_on: "\(res["updated_on"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                                             use_point: "\(res["use_point"] ?? "")", earn_point: "\(res["earn_point"] ?? "")")
            
            catArray.append(category)
        }
        
        var smallCat = [InventoryCategory]()
        
        for cat in catArray {
            
            if arrCatId.contains(where: {$0 == cat.id}) {
                smallCat.append(cat)
            }
        }
        collCat = smallCat
        self.scroll.isHidden = false
        self.loadingIndicator.isAnimating = false
        DispatchQueue.main.async {
            self.catColl.reloadData()
        }
    }
    
    func getVarients(list: Any) {
        
        let variants = list as! [[String: Any]]
        
        var small_var = [ProductById]()
        
        for vars in variants {
            
            let varArr = ProductById(alternateName: "\(vars["alternateName"] ?? "")", admin_id: "\(vars["admin_id"] ?? "")",
                                     description: "\(vars["description"] ?? "")", starting_quantity: "\(vars["starting_quantity"] ?? "")",
                                     margin: "\(vars["margin"] ?? "")", brand: "\(vars["brand"] ?? "")", tags: "\(vars["tags"] ?? "")", upc: "\(vars["upc"] ?? "")",
                                     id: "\(vars["id"] ?? "")", sku: "\(vars["sku"] ?? "")",
                                     disable: "\(vars["disable"] ?? "")", food_stampable: "\(vars["food_stampable"] ?? "")", isvarient: "\(vars["isvarient"] ?? "")", is_lottery: "\(vars["is_lottery"] ?? "")",
                                     title: "\(vars["title"] ?? "")", quantity: "\(vars["quantity"] ?? "")",
                                     ischargeTax: "\(vars["ischargeTax"] ?? "")", updated_on: "\(vars["updated_on"] ?? "")",
                                     isstockcontinue: "\(vars["isstockcontinue"] ?? "")", trackqnty: "\(vars["trackqnty"] ?? "")",
                                     profit: "\(vars["profit"] ?? "")", custom_code: "\(vars["custom_code"] ?? "")",
                                     assigned_vendors: "\(vars["assigned_vendors"] ?? "")", barcode: "\(vars["barcode"] ?? "")",
                                     country_region: "\(vars["country_region"] ?? "")", ispysical_product: "\(vars["ispysical_vars"] ?? "")",
                                     show_status: "\(vars["show_status"] ?? "")", HS_code: "\(vars["HS_code"] ?? "")",
                                     price: "\(vars["price"] ?? "")", featured_product: "\(vars["featured_vars"] ?? "")",
                                     merchant_id: "\(vars["merchant_id"] ?? "")", created_on: "\(vars["created_on"] ?? "")",
                                     prefferd_vendor: "\(vars["prefferd_vendor"] ?? "")", reorder_cost: "\(vars["reorder_cost"] ?? "")",
                                     other_taxes: "\(vars["other_taxes"] ?? "")", buy_with_product: "\(vars["buy_with_vars"] ?? "")",
                                     costperItem: "\(vars["costperItem"] ?? "")", is_tobacco: "\(vars["is_tobacco"] ?? "")",
                                     product_doc: "\(vars["vars_doc"] ?? "")", user_id: "\(vars["user_id"] ?? "")",
                                     media: "\(vars["media"] ?? "")", compare_price: "\(vars["compare_price"] ?? "")",
                                     loyalty_product_id: "\(vars["loyalty_vars_id"] ?? "")", show_type: "\(vars["show_type"] ?? "")",
                                     cotegory: "\(vars["cotegory"] ?? "")", reorder_level: "\(vars["reorder_level"] ?? "")",
                                     env: "\(vars["env"] ?? "")", variant: "\(vars["variant"] ?? "")", reorder_qty: "\(vars["reorder_qty"] ?? "")", purchase_qty: "\(vars["purchase_qty"] ?? "")")
            
            small_var.append(varArr)
        }
        variantsArray = small_var
        
        if variantsArray.count == 0 {
            var isSel = [Bool]()
            var isQty = [String]()
            isSel.append(true)
            isQty.append("0")
            isSelectedData = isSel
            isQuantity = isQty
        }
        else {
            var isSel = [Bool]()
            var isQty = [String]()
            for i in 0..<variantsArray.count {
                
                if i == 0 {
                    isSel.append(true)
                }
                else {
                    isSel.append(false)
                }
                isQty.append("0")
            }
            isSelectedData = isSel
            isQuantity = isQty
        }
        DispatchQueue.main.async {
            self.variantsTable.reloadData()
        }
    }
    
    func getOptions(opt_list: Any) {
        
        let response = opt_list as? [String: Any] ?? [:]
        if response.count != 0 {
            var smallres = [InventoryOptions]()
            let options = InventoryOptions(id: "\(response["id"] ?? "")", product_id: "\(response["product_id"] ?? "")",
                                           options1: "\(response["options1"] ?? "")", optionsvl1: "\(response["optionsvl1"] ?? "")",
                                           options2: "\(response["options2"] ?? "")", optionsvl2: "\(response["optionsvl2"] ?? "")",
                                           options3: "\(response["options3"] ?? "")", optionsvl3: "\(response["optionsvl3"] ?? "")",
                                           merchant_id: "\(response["merchant_id"] ?? "")", admin_id: "\(response["admin_id"] ?? "")")
            
            if options.options1 != "" {
                let opt = InventoryOptions(id: options.id, product_id: "", options1: options.options1, optionsvl1: options.optionsvl1, options2: "",
                                           optionsvl2: "", options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
                smallres.append(opt)
            }
            if options.options2 != "" {
                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: options.options2,
                                           optionsvl2: options.optionsvl2, options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
                smallres.append(opt)
            }
            if options.options3 != "" {
                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: "",
                                           optionsvl2: "", options3: options.options3, optionsvl3: options.optionsvl3, merchant_id: "", admin_id: "")
                smallres.append(opt)
            }
            
            productOptions = smallres
        }
        
        DispatchQueue.main.async {
            self.attTable.reloadData()
        }
    }
    
    func getBulk(list: Any) {
        
    }
    
    func inventSettingsCall() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.inventorySettingCall(merchant_id: m_id) {isSuccess, responseData in
            
            if isSuccess {
                
                guard let setting = responseData["result"] else {
                    return
                }
                
                let response = setting as! [String:Any]
                let cost_per = response["cost_per"] as? String ?? ""
                let cost_method = response["cost_method"] as? String ?? ""
                
                let req_Desc = response["inv_setting"] as? String ?? ""
                if req_Desc.contains("2") {
                    UserDefaults.standard.set(true, forKey: "Po Descrip")
                }
                else{
                    UserDefaults.standard.set(false, forKey: "Po Descrip")
                }
                UserDefaults.standard.set(cost_per, forKey: "cost_per_value")
                UserDefaults.standard.set(cost_method, forKey: "cost_method")
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func setCollHeight(coll: UIScrollView) {
        
        if coll == catColl {
            let height = catColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                catcollHeight.constant = 50
            }
            else {
                catcollHeight.constant = height
            }
        }
        
        else if coll == taxesColl {
            let height = taxesColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                taxCollHeight.constant = 50
            }
            else {
                taxCollHeight.constant = height
            }
        }
        else if coll == tagColl {
            let height = tagColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                tagCollHeight.constant = 50
            }
            else {
                tagCollHeight.constant = height
            }
        }
        else {
            
        }
        attHeight.constant = CGFloat(70 * productOptions.count)
        
        let cat = catcollHeight.constant
        let tag = tagCollHeight.constant
        let tax = taxCollHeight.constant
        
        var var_count = variantsArray.count
        
        if var_count == 0 || var_count == 1 {
            
            if mode == "add" {
                scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 706
                if productOptions.count == 3 {
                    addVarBtn.isHidden = true
                    addVarBtnHeight.constant = 0
                    addVarTop.constant = 0
                }
                else {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 776
                    addVarBtn.isHidden = false
                    addVarBtnHeight.constant = 50
                    addVarTop.constant = 20
                }
            }
            
            else {
                //771 = 826
                scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 751
                addVarBtn.isHidden = true
                addVarBtnHeight.constant = 0
                addVarTop.constant = 0
            }
        }
        else {
            var_count = variantsArray.count - 1
            if mode == "add" {
                if productOptions.count == 3 {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 706 + CGFloat(50 * var_count)
                    addVarBtn.isHidden = true
                    addVarBtnHeight.constant = 0
                    addVarTop.constant = 0
                }
                else {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 776 + CGFloat(50 * var_count)
                    addVarBtn.isHidden = false
                    addVarBtnHeight.constant = 50
                    addVarTop.constant = 20
                }
            }
            
            else {
                //771 = 826
                scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 751 + CGFloat(50 * var_count)
                addVarBtn.isHidden = true
                addVarBtnHeight.constant = 0
                addVarTop.constant = 0
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func openCatScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegatePlus = self
        vc.catMode = "addProductVc"
        vc.selectCategory = collCat
        vc.apiMode = "category"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func openBrandScreen() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        

        vc.delegatePlus = self
        vc.catMode = "addProductVc"
        
        let brand = brandName.text ?? ""
        vc.selectBrandsTags = [brand]
        vc.apiMode = "brands"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func openTagScreen() {
        
        if collTag.count == 15 {
            ToastClass.sharedToast.showToast(message: "You cannot select more than 15 items",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
            
            vc.delegatePlus = self
            vc.catMode = "addProductVc"
            vc.selectBrandsTags = collTag
            vc.apiMode = "tags"
            present(vc, animated: true, completion: {
                vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            })
        }
    }
    
    @objc func openTaxScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegatePlus = self
        vc.catMode = "addProductVc"
        vc.selectTaxes = collTax
        vc.taxes = arrTax
        vc.apiMode = "taxes"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func dupClick() {

        performSegue(withIdentifier: "toDuplicate", sender: nil)
    }
    
    @objc func bulkClick() {
        performSegue(withIdentifier: "toAddBulk", sender: nil)
    }
    
    @objc func purchaseQtyClick() {
        performSegue(withIdentifier: "toAddPurchase", sender: nil)
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func closeCatBtnClick(_ sender: UIButton) {
        collCat.remove(at: sender.tag)
        catColl.reloadData()
    }
    
    
    @IBAction func closeTagBtnClick(_ sender: UIButton) {
        collTag.remove(at: sender.tag)
        tagColl.reloadData()
    }
    
    
    @IBAction func closeTaxBtnClick(_ sender: UIButton) {
        collTax.remove(at: sender.tag)
        taxesColl.reloadData()
    }
    
    @IBAction func trackQtyClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            
            if variantsArray.count == 0 {
                editProd?.trackqnty = "1"
            }
            else {
                variantsArray[sender.tag].trackqnty = "1"
            }
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.trackqnty = "0"
            }
            else {
                variantsArray[sender.tag].trackqnty = "0"
            }
        }
    }
    
    
    @IBAction func sellingClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.isstockcontinue = "1"
            }
            else {
                variantsArray[sender.tag].isstockcontinue = "1"
            }
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.isstockcontinue = "0"
            }
            else {
                variantsArray[sender.tag].isstockcontinue = "0"
            }
        }
    }
    
    
    @IBAction func checkidClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.is_tobacco = "1"
            }
            else {
                variantsArray[sender.tag].is_tobacco = "1"
            }
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.is_tobacco = "0"
            }
            else {
                variantsArray[sender.tag].is_tobacco = "0"
            }
        }
        
    }
  
    @IBAction func disableClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_disable_product") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            if sender.currentImage == UIImage(named: "uncheck inventory") {
                sender.setImage(UIImage(named: "check inventory"), for: .normal)
                if variantsArray.count == 0 {
                    editProd?.disable = "1"
                }
                else {
                    variantsArray[sender.tag].disable = "1"
                }
            }
            else {
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                if variantsArray.count == 0 {
                    editProd?.disable = "0"
                }
                else {
                    variantsArray[sender.tag].disable = "0"
                }
            }
        }
    }
    
    @IBAction func foodStampableClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.food_stampable = "1"
            }
            else {
                variantsArray[sender.tag].food_stampable = "1"
            }
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            if variantsArray.count == 0 {
                editProd?.food_stampable = "0"
            }
            else {
                variantsArray[sender.tag].food_stampable = "0"
            }
        }
        
    }
 
    @IBAction func threeDotsClick(_ sender: UIButton) {
        
        if upperView.isHidden {
            upperView.isHidden = false
        }
        
        else {
            upperView.isHidden = true
        }
        
        dupView.layer.cornerRadius = 10
        dupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        maxView.layer.cornerRadius = 10
        maxView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        upperView.layer.cornerRadius = 10
        upperView.layer.shadowColor =  UIColor.lightGray.cgColor
        upperView.layer.shadowOpacity = 1
        upperView.layer.shadowRadius = 3
        upperView.layer.shadowOffset = CGSize.zero
    }
    
    
    @IBAction func attDeleteBtnClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "red_delete") {
            
            let position = sender.tag
            productOptions.remove(at: position)
            
            if productOptions.count == 2 {
                
                if position == 0 {
                    arrOptVl1 = arrOptVl2
                    arrOptVl2 = arrOptVl3
                    arrOptVl3 = []
                }
                else if position == 1 {
                    arrOptVl2 = arrOptVl3
                    arrOptVl3 = []
                }
                else {
                    arrOptVl3 = []
                }
            }
            
            else if productOptions.count == 1 {
                
                if position == 0 {
                    arrOptVl1 = arrOptVl2
                    arrOptVl2 = []
                    arrOptVl3 = []
                }
                else if position == 1 {
                    arrOptVl2 = []
                    arrOptVl3 = []
                }
            }
            
            else {
                arrOptVl1 = []
                arrOptVl2 = []
                arrOptVl3 = []
            }
            
            attTable.reloadData()
            attHeight.constant = CGFloat(70 * productOptions.count)
            
            if productOptions.count == 3 {
                addVarBtn.isHidden = true
                addVarBtnHeight.constant = 0
            }
            else {
                addVarBtn.isHidden = false
                addVarBtnHeight.constant = 50
            }
            refreshVariantTable()
        }
    }
    
    
    @IBAction func brandCloseBtnClick(_ sender: UIButton) {
        
        selectBrandLbl.text = "Select Brand"
        brandInnerView.isHidden = true
        brandName.text = ""
        brandCloseBtn.isHidden = true
    }
    
    @IBAction func addVariantBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addVariantAtt") as! AddVariantAttributeViewController
        
        variantMode = "add"
        vc.subMode = variantMode
        vc.mode = mode
        vc.goMode = variantGoMode
        if productOptions.count == 0 {
            vc.selectedAtt = []
        }
        else  {
            vc.selectedAtt = productOptions
        }
        vc.delegatePlus = self
        
        present(vc, animated: true)
    }
    
    
    @IBAction func salesHistoryBtnClick(_ sender: UIButton) {
        
        if variantsArray.count == 0 {
            vari_id = ""
            varname = editProd?.title ?? ""
            
        }else {
            vari_id = variantsArray[sender.tag].id
            varname = variantsArray[sender.tag].variant
            
        }
        
        performSegue(withIdentifier: "toSalesVc", sender: nil)
        
    }
    
    
    @IBAction func instantBtnClick(_ sender: UIButton) {
        
        
        UserDefaults.standard.set("prod", forKey: "toInstantPO")
        
        if UserDefaults.standard.bool(forKey: "Po Descrip"){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "podesc") as! InstantPODescViewController
            if variantsArray.count == 0 {
                vc.ipoVari_id = ""
            }
            else {
                vc.ipoVari_id = variantsArray[sender.tag].id
            }
            vc.ipoProd_id = p_id
            
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
            if variantsArray.count == 0 {
                vc.ipoVari_id = ""
            }
            else {
                vc.ipoVari_id = variantsArray[sender.tag].id
            }
            vc.ipoProd_id = p_id
            
            let transition = CATransition()
            transition.duration = 0.7
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            validateAddParams()
        }
        else {
            validateEditParams()
        }
    }
    
    func validateAddParams() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = productField.text, name != "" else {
            productField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter product name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let desc = descField.text ?? ""
        
        let brand = brandName.text ?? ""
        
        var tags = ""
        
        if collTag.count == 0 {
            tags = ""
        }
        else {
            tags = collTag.joined(separator: ",")
        }
        
        guard collCat.count != 0 else{
            ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small = [String]()
        for cat in collCat {
            small.append(cat.id)
        }
        
        let collection = small.joined(separator: ",")
        
        var smalltax = [String]()
        for tax in collTax {
            smalltax.append(tax.id)
        }
        
        var other_taxes = ""
        var ischargeTax = ""
        
        if smalltax.count == 0  {
            other_taxes = ""
            ischargeTax = "0"
        }
        else {
            other_taxes = smalltax.joined(separator: ",")
            ischargeTax = "1"
        }
        
        if productOptions.count == 0 {
            
            let index = IndexPath(row: 0, section: 0)
            let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
            let costperitem = variantsArray[0].costperItem
            
            guard let price = variantsArray[0].price, price != "", price != "0.00" else {
                cell.price.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let c_price = price
            let c_compareprice = variantsArray[0].compare_price
            
            if c_compareprice != "" && c_compareprice != "0.00" {
                
                let newCompareprice = Double(c_compareprice)!
                let newPrice = Double(c_price)!
                
                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                    ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                    
                    return
                }
            }
            
            let margin = variantsArray[0].margin
            let profit = variantsArray[0].profit
            
            guard let quant = variantsArray[0].quantity, quant != "" else {
                cell.qty.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let custom_code = variantsArray[0].custom_code
            
            guard let upc_code = variantsArray[0].upc, upc_code != "" else {
                cell.upcCode.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            var reorder_qty = variantsArray[0].reorder_qty
            var reorder_level = variantsArray[0].reorder_level
            
            if reorder_qty == "" {
                reorder_qty = "0"
            }
            
            if reorder_level == "" {
                reorder_level = "0"
            }
            
            let trackqnty = variantsArray[0].trackqnty
            let isstockcontinue = variantsArray[0].isstockcontinue
            let is_tobacco = variantsArray[0].is_tobacco
            let disable = variantsArray[0].disable
            let food_stampable = variantsArray[0].food_stampable
            
            loadIndicator.isAnimating = true
            
            saveBtn.isEnabled = false
            
            ApiCalls.sharedCall.productAddCall(id: m_id, title: name, description: desc,
                                               brand: brand, tags: tags,
                                               price: price,
                                               compare_price: c_compareprice,
                                               costperItem: costperitem, margin: margin,
                                               profit: profit, ischargeTax: ischargeTax,
                                               trackqnty: trackqnty, isstockcontinue: isstockcontinue,
                                               quantity: quant, collection: collection,
                                               isvarient: "0", is_lottery: "0",
                                               created_on: "",
                                               optionarray: "", optionarray1: "", optionarray2: "",
                                               optionvalue: "", optionvalue1: "", optionvalue2: "",
                                               other_taxes: other_taxes, bought_product: "",
                                               featured_product: "", varvarient: "",
                                               varprice: "",
                                               varcompareprice: "", varcostperitem: "",
                                               varquantity: "",
                                               upc: upc_code, custom_code: custom_code,
                                               reorder_qty: reorder_qty,
                                               reorder_level: reorder_level, reorder_cost: "",
                                               is_tobacco: is_tobacco,
                                               disable: disable, food_stampable: food_stampable,
                                               varupc: "",
                                               varcustomcode: "",
                                               vartrackqnty: "", varcontinue_selling: "",
                                               varcheckid: "",
                                               vardisable: "", varfood_stampable: "", varmargin: "",
                                               varprofit: "", varreorder_qty: "",
                                               varreorder_level: "", varreorder_cost: "")
            { isSuccess, responseData in
                
                if isSuccess {
                    
                    if let list = responseData["message"] as? String {
                        if list == "Success" {
                            ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.loadIndicator.isAnimating = false
                            self.navigationController?.popViewController(animated: true)
                            self.saveBtn.isEnabled = true
                        }
                        else{
                            ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.loadIndicator.isAnimating = false
                            self.saveBtn.isEnabled = true
                        }
                    }
                }
                else {
                    
                }
            }
        }
        
        else {
            var cost_item_arr = [String]()
            var price_arr = [String]()
            var compare_arr = [String]()
            var margin_arr = [String]()
            var profit_arr = [String]()
            var quantity_arr = [String]()
            var custom_arr = [String]()
            var upc_arr = [String]()
            
            var track_arr = [String]()
            var sell_arr = [String]()
            var check_arr = [String]()
            var disable_arr = [String]()
            var foodStamp_arr = [String]()
            
            var reorderQty_arr = [String]()
            var reorderLevel_arr = [String]()
            
            var v_variant_arr = [String]()
            
            for product in 0..<variantsArray.count {
                
                let costperitem = variantsArray[product].costperItem
                cost_item_arr.append(costperitem)
                
                guard let price = variantsArray[product].price, price != "", price != "0.00" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.price.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                price_arr.append(price)
                
                let c_price = price
                let c_compareprice = variantsArray[product].compare_price
                
                if c_compareprice != "" && c_compareprice != "0.00" {
                    
                    let newCompareprice = Double(c_compareprice)!
                    let newPrice = Double(c_price)!
                    
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                        ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                        
                        return
                    }
                }
                
                compare_arr.append(c_compareprice)
                margin_arr.append(variantsArray[product].margin)
                profit_arr.append(variantsArray[product].profit)
                
                guard let quant = variantsArray[product].quantity, quant != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.qty.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
                quantity_arr.append(quant)
                custom_arr.append(variantsArray[product].custom_code)
                
                guard let upcCode = variantsArray[product].upc, upcCode != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    return
                }
                upc_arr.append(upcCode)
                
                track_arr.append(variantsArray[product].trackqnty)
                sell_arr.append(variantsArray[product].isstockcontinue)
                check_arr.append(variantsArray[product].is_tobacco)
                disable_arr.append(variantsArray[product].disable)
                foodStamp_arr.append(variantsArray[product].food_stampable)
                
                reorderQty_arr.append(variantsArray[product].reorder_qty)
                reorderLevel_arr.append(variantsArray[product].reorder_level)
            }
            
            if result.count == 0 {
                
                if productOptions.count == 3 {
                    v_variant_arr.append("\(productOptions[0].optionsvl1)/\(productOptions[1].optionsvl2)/\(productOptions[2].optionsvl3)")
                }
                else if productOptions.count == 2 {
                    v_variant_arr.append("\(productOptions[0].optionsvl1)/\(productOptions[1].optionsvl2)")
                }
                else {
                    v_variant_arr.append("\(productOptions[0].optionsvl1)")
                }
            }
            else {
                v_variant_arr = result
            }
            let varvarient = v_variant_arr.joined(separator: ",")
            
            let varcostperitem = cost_item_arr.joined(separator: ",")
            let varprice = price_arr.joined(separator: ",")
            let varcompareprice = compare_arr.joined(separator: ",")
            let varmargin = margin_arr.joined(separator: ",")
            let varupc = upc_arr.joined(separator: ",")
            let varprofit = profit_arr.joined(separator: ",")
            let varcustomcode = custom_arr.joined(separator: ",")
            let varquantity = quantity_arr.joined(separator: ",")
            
            let varreorder_qty = reorderQty_arr.joined(separator: ",")
            let varreorder_level = reorderLevel_arr.joined(separator: ",")
            
            let vartrackqnty = track_arr.joined(separator: ",")
            let varcontinue_selling = sell_arr.joined(separator: ",")
            let varcheckid = check_arr.joined(separator: ",")
            let vardisable = disable_arr.joined(separator: ",")
            let varfood_stampable = foodStamp_arr.joined(separator: ",")
            
            var optionarray = ""
            var optionvalue = ""
            
            var optionarray1 = ""
            var optionvalue1 = ""
            
            var optionarray2 = ""
            var optionvalue2 = ""
            
            if productOptions.count > 0 {
                
                for opt in 0..<productOptions.count {
                    
                    if opt == 0 {
                        optionarray = productOptions[opt].options1
                        optionvalue = productOptions[opt].optionsvl1
                    }
                    
                    else if opt == 1 {
                        optionarray1 = productOptions[opt].options2
                        optionvalue1 = productOptions[opt].optionsvl2
                    }
                    
                    else {
                        optionarray2 = productOptions[opt].options3
                        optionvalue2 = productOptions[opt].optionsvl3
                    }
                }
            }
            
            loadIndicator.isAnimating = true
            saveBtn.isEnabled = false
            
            ApiCalls.sharedCall.productAddCall(id: m_id, title: name, description: desc,
                                               brand: brand, tags: tags,
                                               price: "", compare_price: "",
                                               costperItem: "", margin: "", profit: "",
                                               ischargeTax: ischargeTax, trackqnty: "",
                                               isstockcontinue: "", quantity: "",
                                               collection: collection, isvarient: "1", is_lottery: "0",
                                               created_on: "",
                                               optionarray: optionarray,
                                               optionarray1: optionarray1,
                                               optionarray2: optionarray2,
                                               optionvalue: optionvalue,
                                               optionvalue1: optionvalue1,
                                               optionvalue2: optionvalue2,
                                               other_taxes: other_taxes,
                                               bought_product: "",
                                               featured_product: "",
                                               varvarient: varvarient,
                                               varprice: varprice,
                                               varcompareprice: varcompareprice,
                                               varcostperitem: varcostperitem,
                                               varquantity: varquantity,
                                               upc: "", custom_code: "", reorder_qty: "", reorder_level: "",
                                               reorder_cost: "", is_tobacco: "", disable: "",
                                               food_stampable: "",
                                               varupc: varupc,
                                               varcustomcode: varcustomcode,
                                               vartrackqnty: vartrackqnty,
                                               varcontinue_selling: varcontinue_selling,
                                               varcheckid: varcheckid,
                                               vardisable: vardisable,
                                               varfood_stampable: varfood_stampable,
                                               varmargin: varmargin,
                                               varprofit: varprofit,
                                               varreorder_qty: varreorder_qty,
                                               varreorder_level: varreorder_level,
                                               varreorder_cost: "")
            {    isSuccess, responseData in
                
                if isSuccess {
                    
                    if let list = responseData["message"] as? String {
                        if list == "Success" {
                            ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.navigationController?.popViewController(animated: true)
                            self.saveBtn.isEnabled = true
                        }
                        else{
                            ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.saveBtn.isEnabled = true
                        }
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    func validateEditParams() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = productField.text, name != "" else {
            productField.isErrorView(numberOfShakes: 3, revert: true)
            return
        }
        let desc = descField.text ?? ""
        
        let brand = brandName.text ?? ""
        
        var tags = ""
        
        if collTag.count == 0 {
            tags = ""
        }
        else {
            tags = collTag.joined(separator: ",")
        }
        
        guard collCat.count != 0 else{
            ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small = [String]()
        for cat in collCat {
            small.append(cat.id)
        }
        
        let collection = small.joined(separator: ",")
        
        var smalltax = [String]()
        for tax in collTax {
            smalltax.append(tax.id)
        }
        
        var other_taxes = ""
        var ischargeTax = ""
        
        if smalltax.count == 0  {
            other_taxes = ""
            ischargeTax = "0"
        }
        else {
            other_taxes = smalltax.joined(separator: ",")
            ischargeTax = "1"
        }
        
        var cost_item_arr = [String]()
        var price_arr = [String]()
        var compare_arr = [String]()
        var margin_arr = [String]()
        var profit_arr = [String]()
        var quantity_arr = [String]()
        var custom_arr = [String]()
        var upc_arr = [String]()
        
        var track_arr = [String]()
        var sell_arr = [String]()
        var check_arr = [String]()
        var disable_arr = [String]()
        var foodStamp_arr = [String]()
        
        var reorderQty_arr = [String]()
        var reorderLevel_arr = [String]()
        
        var v_id_arr = [String]()
        var v_variant_arr = [String]()
        
        if variantsArray.count == 0 {
            
            let index = IndexPath(row: 0, section: 0)
            let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
            let costperitem = cell.costPerItem.text ?? ""
            
            guard let price = cell.price.text, price != "", price != "0.00" else {
                cell.price.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let c_price = price
            let c_compareprice = cell.comparePrice.text ?? ""
            
            if c_compareprice != "" && c_compareprice != "0.00" {
                
                let newCompareprice = Double(c_compareprice) ?? 0.00
                let newPrice = Double(c_price) ?? 0.00
                
                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                    ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                    
                    return
                }
            }
            
            let margin = cell.margin.text ?? ""
            let profit = cell.profit.text ?? ""
            
            guard let quant = cell.qty.text, quant != "" else {
                cell.qty.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            guard let upcCode = cell.upcCode.text, upcCode != "" else {
                cell.upcCode.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let custom_code = cell.customCode.text ?? ""
            
            let track_qty = editProd?.trackqnty ?? ""
            let stock = editProd?.isstockcontinue ?? ""
            let is_tobacco = editProd?.is_tobacco ?? ""
            let disable = editProd?.disable ?? ""
            let food_stampable = editProd?.food_stampable ?? ""
            
            var reorder_qty = cell.reorderQty.text ?? ""
            var reorder_level = cell.reorderLevel.text ?? ""
            
            
            if reorder_qty == "" {
                reorder_qty = "0"
            }
            
            if reorder_level == "" {
                reorder_level = "0"
            }
            
            let prod_id = editProd?.id ?? ""
            
            loadIndicator.isAnimating = true
            saveBtn.isEnabled = false
            
            ApiCalls.sharedCall.productEditCall(merchant_id: m_id, admin_id: "", title: name,
                                                alternateName: "",
                                                description: desc,
                                                brand: brand, tags: tags,
                                                price: price,
                                                compare_price: c_compareprice,
                                                costperItem: costperitem,
                                                margin: margin, profit: profit,
                                                ischargeTax: ischargeTax,
                                                sku: "", upc: upcCode, custom_code: custom_code,
                                                barcode: "", trackqnty: track_qty,
                                                isstockcontinue: stock,
                                                quantity: quant, ispysical_product: "",
                                                country_region: "",
                                                collection: collection, HS_code: "",
                                                isvarient: "0", is_lottery: "0",
                                                multiplefiles: "", img_color_lbl: "",
                                                created_on: "",
                                                productid: prod_id,
                                                optionarray: "",
                                                optionarray1: "",
                                                optionarray2: "",
                                                optionvalue: "",
                                                optionvalue1: "",
                                                optionvalue2: "",
                                                other_taxes: other_taxes ,
                                                bought_product: "",
                                                featured_product: "", varvarient: "",
                                                varprice: "", varquantity: "", varsku: "",
                                                varbarcode: "",
                                                files: "", doc_file: "", optionid: "",
                                                varupc: "", varcustomcode: "",
                                                reorder_qty: reorder_qty,
                                                reorder_level: reorder_level,
                                                reorder_cost: "", is_tobacco: is_tobacco,
                                                disable: disable,
                                                food_stampable: food_stampable,
                                                vartrackqnty: "", varcontinue_selling: "",
                                                varcheckid: "",
                                                vardisable: "", varfood_stampable: "",
                                                varmargin: "", varprofit: "",
                                                varreorder_qty: "", varreorder_level: "",
                                                varreorder_cost: "",
                                                varcostperitem: "", varcompareprice: "",
                                                var_id: "")
            { isSuccess, responseData in
                
                if isSuccess {
                    ToastClass.sharedToast.showToast(message: "Product updated successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.loadIndicator.isAnimating = false
                    self.saveBtn.isEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.saveBtn.isEnabled = true
                }
            }
        }
        
        else {
            
            for product in 0..<variantsArray.count {
                
                
                let costperitem = variantsArray[product].costperItem
                cost_item_arr.append(costperitem)
                
                guard let price = variantsArray[product].price, price != "", price != "0.00" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.price.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
                price_arr.append(price)
                
                let c_price = price
                let c_compareprice = variantsArray[product].compare_price
                
                if c_compareprice != "" && c_compareprice != "0.00"{
                    
                    let newCompareprice = Double(c_compareprice)!
                    let newPrice = Double(c_price)!
                    
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                        ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                        
                        return
                    }
                }
                
                compare_arr.append(c_compareprice)
                
                margin_arr.append(variantsArray[product].margin)
                profit_arr.append(variantsArray[product].profit)
                
                guard let quant = variantsArray[product].quantity, quant != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.qty.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Please enter quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                quantity_arr.append(quant)
                custom_arr.append(variantsArray[product].custom_code)
                
                guard let upcCode = variantsArray[product].upc, upcCode != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                upc_arr.append(upcCode)
                
                v_id_arr.append(variantsArray[product].id)
                if result.count == 0 {
                    v_variant_arr.append(variantsArray[product].variant)
                }
                
                track_arr.append(variantsArray[product].trackqnty)
                sell_arr.append(variantsArray[product].isstockcontinue)
                check_arr.append(variantsArray[product].is_tobacco)
                disable_arr.append(variantsArray[product].disable)
                foodStamp_arr.append(variantsArray[product].food_stampable)
                
                reorderQty_arr.append(variantsArray[product].reorder_qty)
                reorderLevel_arr.append(variantsArray[product].reorder_level)
            }
            
            
            if result.count != 0 {
                v_variant_arr = result
            }
            
            let varid = v_id_arr.joined(separator: ",")
            let varvarient = v_variant_arr.joined(separator: ",")
            
            let varcostperitem = cost_item_arr.joined(separator: ",")
            let varprice = price_arr.joined(separator: ",")
            let varcompareprice = compare_arr.joined(separator: ",")
            let varmargin = margin_arr.joined(separator: ",")
            let varupc = upc_arr.joined(separator: ",")
            let varprofit = profit_arr.joined(separator: ",")
            let varcustomcode = custom_arr.joined(separator: ",")
            let varquantity = quantity_arr.joined(separator: ",")
            
            let vartrackqnty = track_arr.joined(separator: ",")
            let varcontinue_selling = sell_arr.joined(separator: ",")
            let varcheckid = check_arr.joined(separator: ",")
            let vardisable = disable_arr.joined(separator: ",")
            let varfood_stampable = foodStamp_arr.joined(separator: ",")
            
            let varreorder_qty = reorderQty_arr.joined(separator: ",")
            let varreorder_level = reorderLevel_arr.joined(separator: ",")
            
            var optionarray = ""
            var optionvalue = ""
            
            var optionarray1 = ""
            var optionvalue1 = ""
            
            var optionarray2 = ""
            var optionvalue2 = ""
            
            for opt in 0..<productOptions.count {
                
                if opt == 0 {
                    optionarray = productOptions[opt].options1
                    optionvalue = productOptions[opt].optionsvl1
                }
                
                else if opt == 1 {
                    optionarray1 = productOptions[opt].options2
                    optionvalue1 = productOptions[opt].optionsvl2
                    
                }
                
                else {
                    optionarray2 = productOptions[opt].options3
                    optionvalue2 = productOptions[opt].optionsvl3
                }
            }
            
            let optionid = productOptions[0].id
            
            loadIndicator.isAnimating = true
            saveBtn.isEnabled = false
            
            
            ApiCalls.sharedCall.productEditCall(merchant_id: m_id, admin_id: "", title: name,
                                                alternateName: "", description: desc,
                                                brand: brand, tags: tags,
                                                price: "", compare_price: "", costperItem: "",
                                                margin: "", profit: "", ischargeTax: ischargeTax,
                                                sku: "", upc: "",
                                                custom_code: "", barcode: "",
                                                trackqnty: "", isstockcontinue: "", quantity: "",
                                                ispysical_product: "", country_region: "",
                                                collection: collection, HS_code: "", isvarient: "1", is_lottery: "0",
                                                multiplefiles: "", img_color_lbl: "",
                                                created_on: "", productid: editProd?.id ?? "",
                                                optionarray: optionarray,
                                                optionarray1: optionarray1,
                                                optionarray2: optionarray2,
                                                optionvalue: optionvalue,
                                                optionvalue1: optionvalue1,
                                                optionvalue2: optionvalue2,
                                                other_taxes: other_taxes,
                                                bought_product: "", featured_product: "",
                                                varvarient: varvarient,
                                                varprice: varprice,
                                                varquantity: varquantity,
                                                varsku: "", varbarcode: "", files: "", doc_file: "",
                                                optionid: optionid, varupc: varupc, varcustomcode: varcustomcode,
                                                reorder_qty: "",
                                                reorder_level: "", reorder_cost: "",
                                                is_tobacco: "", disable: "", food_stampable: "",
                                                vartrackqnty: vartrackqnty,
                                                varcontinue_selling: varcontinue_selling,
                                                varcheckid: varcheckid,
                                                vardisable: vardisable,
                                                varfood_stampable: varfood_stampable,
                                                varmargin: varmargin,
                                                varprofit: varprofit,
                                                varreorder_qty: varreorder_qty,
                                                varreorder_level: varreorder_level,
                                                varreorder_cost: "",
                                                varcostperitem: varcostperitem,
                                                varcompareprice: varcompareprice,
                                                var_id: varid) { isSuccess, responseData in
                
                if isSuccess {
                    
                    ToastClass.sharedToast.showToast(message: "Product updated successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    self.loadIndicator.isAnimating = false
                    self.saveBtn.isEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.saveBtn.isEnabled = true
                }
            }
        }
    }
    
    
    @IBAction func openScan(_ sender: UIButton) {
        
        scanIndex = sender.tag
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDuplicate" {
            
            let vc = segue.destination as! DuplicatePlusViewController
            
            let brand = brandName.text ?? ""
            vc.dupBrandNameLbl = brand
            
            let desc = descField.text ?? ""
            vc.dupProdDesc = desc
            
            if variantsArray.count == 0 {
                editProd?.upc = ""
                vc.singleProd = editProd
            }
            else {
                
                for i in 0..<variantsArray.count {
                    variantsArray[i].upc = ""
                }
                vc.dupProdVariants = variantsArray
            }
            
            vc.dupProdCat = collCat
            vc.dupProdTag = collTag
            vc.dupProdTaxes = collTax
            vc.dupProdOptions = productOptions
            vc.dupArrTaxes = arrTax
        }
        
        else if segue.identifier == "toSalesVc" {
            
            let vc = segue.destination as! SalesHistoryViewController
            
            vc.salesProd_id = p_id
            vc.salesVar_id  = vari_id
            vc.salesVar_name = varname
        }
        
        else if segue.identifier == "toAddPurchase" {
            
            let vc = segue.destination as! AddPurchaseQtyViewController
            if variantsArray.count == 0 {
                let name = productField.text ?? ""
                vc.singleProd = name
                vc.product_PurchaseQty = prod_purchaseQty
            }
            else {
                vc.varientArr = variantsArray
            }
            vc.is_Varient = isVarient
            vc.prod_id = p_id
            
        }
    }
}

extension PlusViewController: PlusSelectedCategory {
    
    func getSelectedCats(reverseCategory: [InventoryCategory], reverseBrandsTags: [String],
                         reverseTaxes: [SetupTaxes], apiMode: String) {
        
        scroll.isHidden = true
        loadingIndicator.isAnimating = true
        
        if apiMode == "category" {
            collCat = reverseCategory
            if reverseCategory.count == 0 {
                catColl.reloadData()
                setCollHeight(coll: catColl)
            }
            else {
                catColl.reloadData()
                setCollHeight(coll: catColl)
            }
        }
        else if apiMode == "brands" {
            if reverseBrandsTags.count != 0 {
                selectBrandLbl.text = ""
                brandInnerView.isHidden = false
                brandName.text = reverseBrandsTags[0]
                brandCloseBtn.isHidden = false
            }
            else {
                selectBrandLbl.text = "Select Brand"
                brandInnerView.isHidden = true
                brandName.text = ""
                brandCloseBtn.isHidden = true
            }
            brandInnerView.layer.cornerRadius = 5.0
        }
        else if apiMode == "tags" {
            
            var smallTag = [String]()
            
            for tag in reverseBrandsTags {
                smallTag.append(tag)
            }
            collTag = smallTag
            if smallTag.count == 0 {
                tagColl.reloadData()
                setCollHeight(coll: tagColl)
            }
            else {
                tagColl.reloadData()
                setCollHeight(coll: tagColl)
            }
        }
        else {
            collTax = reverseTaxes
            if reverseTaxes.count == 0 {
                taxesColl.reloadData()
                setCollHeight(coll: taxesColl)
            }
            else {
                taxesColl.reloadData()
                setCollHeight(coll: tagColl)
            }
        }
        scroll.isHidden = false
        loadingIndicator.isAnimating = false
    }
}

extension PlusViewController: PlusAttributeVariant {
    
    
    func getAddedAtttributes(optName: String, optValue: String, newEdit: [String]) {
        
        if variantMode == "add" {
            
            if productOptions.count == 0 {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: optName, optionsvl1: optValue,
                                              options2: "", optionsvl2: "",
                                              options3: "", optionsvl3: "",
                                              merchant_id: "", admin_id: "")
                productOptions = [option]
                arrOptVl1 = option.optionsvl1.components(separatedBy: ",")
            }
            else if productOptions.count == 1 {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: "", optionsvl1: "",
                                              options2: optName, optionsvl2: optValue,
                                              options3: "", optionsvl3: "",
                                              merchant_id: "", admin_id: "")
                productOptions.append(option)
                arrOptVl2 = option.optionsvl2.components(separatedBy: ",")
            }
            else {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: "", optionsvl1: "",
                                              options2: "", optionsvl2: "",
                                              options3: optName, optionsvl3: optValue,
                                              merchant_id: "", admin_id: "")
                productOptions.append(option)
                arrOptVl3 = option.optionsvl3.components(separatedBy: ",")
            }
        }
        else {
            
            if attIndex == 0 {
                productOptions[attIndex].optionsvl1 = optValue
                arrOptVl1 = optValue.components(separatedBy: ",")
            }
            else if attIndex == 1 {
                productOptions[attIndex].optionsvl2 = optValue
                arrOptVl2 = optValue.components(separatedBy: ",")
            }
            else if attIndex == 2 {
                productOptions[attIndex].optionsvl3 = optValue
                arrOptVl3 = optValue.components(separatedBy: ",")
            }
            else {
                
            }
            newEditArr = newEdit
        }
        
        refreshVariantTable()
        
    }
    
    func refreshVariantTable() {
        
        if arrOptVl1.count == 1 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
            result = [arrOptVl1[0]]
        }
        
        else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 0 {
            result = ["\(arrOptVl1[0])/\(arrOptVl2[0])"]
        }
        
        else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 1 {
            result = ["\(arrOptVl1[0])/\(arrOptVl2[0])/\(arrOptVl3[0])"]
        }
        
        else if arrOptVl1.count > 0 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
            
            result = arrOptVl1
        }
        
        else if arrOptVl1.count > 0 && arrOptVl2.count > 0 && arrOptVl3.count == 0 {
            
            let res = arrOptVl1.flatMap { s1 in
                arrOptVl2.map { s2 in
                    "\(s1)/\(s2)"
                }
            }
            
            var endResult = [String]()
            
            for combo in res {
                
                if result.contains(combo) {}
                else {
                    endResult.append(combo)
                }
            }
            result.append(contentsOf: endResult)
            
            let filter = result.filter{res.contains($0)}
            result = filter
        }
        
        else if arrOptVl1.count > 0 && arrOptVl2.count > 0 && arrOptVl3.count > 0 {
            
            let res = arrOptVl1.flatMap { s1 in
                arrOptVl2.flatMap { s2 in
                    arrOptVl3.map { s3 in
                        "\(s1)/\(s2)/\(s3)"
                    }
                }
            }
            var endResult = [String]()
            
            for combo in res {
                
                if result.contains(combo) {}
                else {
                    endResult.append(combo)
                }
            }
            result.append(contentsOf: endResult)
            
            let filter = result.filter{res.contains($0)}
            result = filter
        }
        
        else {
            result = []
        }
        
        if result.count == 0 {
            
            let count = variantsArray.count - 1
            variantsArray.removeLast(count)
            isSelectedData.removeLast(count)
        }
        else if result.count > variantsArray.count {
            
            let count = result.count - variantsArray.count
            for _ in 0..<count {
                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
                                                 brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0",
                                                 isvarient: "", is_lottery: "", title: "", quantity: "", ischargeTax: "",
                                                 updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
                                                 assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
                                                 show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
                                                 created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
                                                 buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
                                                 media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
                                                 reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: ""))
                isSelectedData.append(false)
                isQuantity.append("1")
            }
        }
        else if result.count < variantsArray.count {
            
            let count = variantsArray.count - result.count
            variantsArray.removeLast(count)
            isSelectedData.removeLast(count)
            isQuantity.removeLast(count)
        }
        
        if isSelectedData.allSatisfy({$0 == false}) {
            let count = isSelectedData.count - 1
            isSelectedData[count] = true
        }
        
        attTable.reloadData()
        variantsTable.reloadData()
        setCollHeight(coll: attTable)
    }
}

extension PlusViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if mode == "add" {
            
            if textField == productField {
                
            }
            
            else {
                
                let index = IndexPath(row: 0, section: textField.tag)
                let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                
                
                if textField == cell.costPerItem {
                    
                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
                    let cost_per_item = textField.text ?? ""
                    
                    guard cost_per_item != "" else {
                        return
                    }
                    
                    if cost_per_value == "" || cost_per_value == "0.00" {
                        
                        let price = "0.00"
                        let profit = "0.00"
                        let margin = "0.00"
                        
                        variantsArray[index.section].costperItem = cost_per_item
                        variantsArray[index.section].price = price
                        variantsArray[index.section].margin = profit
                        variantsArray[index.section].profit = margin
                        
                        for variants in 0..<variantsArray.count {
                            
                            if variantsArray[variants].costperItem == "0.00" {
                                variantsArray[variants].costperItem = cost_per_item
                                variantsArray[variants].price = price
                                variantsArray[variants].margin = margin
                                variantsArray[variants].profit = profit
                            }
                        }
                        variantsTable.reloadData()
                    }
                    
                    else {
                        
                        let cost_per_value_doub = Double(cost_per_value) ?? 0.00
                        let percent = cost_per_value_doub/100
                        
                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                        let profit = cost_per_item_doub * percent
                        let price = cost_per_item_doub + profit
                        let margin = (profit / price) * 100
                        
                        variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
                        variantsArray[index.section].price = String(format: "%.2f", price)
                        variantsArray[index.section].margin = String(format: "%.2f", margin)
                        variantsArray[index.section].profit = String(format: "%.2f", profit)
                        
                        for variants in 0..<variantsArray.count {
                            
                            if variantsArray[variants].costperItem == "0.00" {
                                variantsArray[variants].costperItem = cost_per_item
                                variantsArray[variants].price = String(format: "%.2f", price)
                                variantsArray[variants].margin = String(format: "%.2f", margin)
                                variantsArray[variants].profit = String(format: "%.2f", profit)
                            }
                        }
                        variantsTable.reloadData()
                    }
                }
                
                else if textField == cell.price {
                    
                    let price = cell.price.text ?? "0.00"
                    variantsArray[index.section].price = price
                    let cpi = variantsArray[index.section].costperItem
                    
                    let cost_per_doub = Double(cpi) ?? 0.00
                    let price_doub = Double(price) ?? 0.00
                    
                    if cost_per_doub == 0.00 {
                        let profit = ""
                        let margin = ""
                        variantsArray[index.section].margin = String(format: "%.2f", margin)
                        variantsArray[index.section].profit = String(format: "%.2f", profit)
                        
                        for variants in 0..<variantsArray.count {
                            
                            if variantsArray[variants].price == "0.00" {
                                variantsArray[variants].price = price
                                variantsArray[variants].margin = String(format: "%.2f", margin)
                                variantsArray[variants].profit = String(format: "%.2f", profit)
                            }
                        }
                    }
                    else {
                        let profit = price_doub - cost_per_doub
                        let margin = (profit / price_doub) * 100
                        variantsArray[index.section].margin = String(format: "%.2f", margin)
                        variantsArray[index.section].profit = String(format: "%.2f", profit)
                        
                        for variants in 0..<variantsArray.count {
                            
                            if variantsArray[variants].price == "0.00" {
                                variantsArray[variants].price = price
                                variantsArray[variants].margin = String(format: "%.2f", margin)
                                variantsArray[variants].profit = String(format: "%.2f", profit)
                            }
                        }
                    }
                    variantsTable.reloadData()
                }
                else if textField == cell.comparePrice {
                    
                    let cprice = cell.comparePrice.text ?? ""
                    variantsArray[index.section].compare_price = cprice
                    variantsTable.reloadData()
                    
                    for variants in 0..<variantsArray.count {
                        
                        if variantsArray[variants].compare_price == "" {
                            variantsArray[variants].compare_price = cprice
                        }
                    }
                    variantsTable.reloadData()
                }
                else if textField == cell.qty {
                    
                    let quty = cell.qty.text ?? ""
                    variantsArray[index.section].quantity = quty
                    variantsTable.reloadData()
                    
                    for variants in 0..<variantsArray.count {
                        
                        if variantsArray[variants].quantity == "" {
                            variantsArray[variants].quantity = quty
                        }
                    }
                    variantsTable.reloadData()
                }
                else if textField == cell.customCode {
                    let custom = cell.customCode.text ?? ""
                    variantsArray[index.section].custom_code = custom
                    variantsTable.reloadData()
                }
                
                else if textField == cell.reorderQty {
                    let reqty = cell.reorderQty.text ?? ""
                    variantsArray[index.section].reorder_qty = reqty
                    variantsTable.reloadData()
                }
                else if textField == cell.reorderLevel {
                    let relvl = cell.reorderLevel.text ?? ""
                    variantsArray[index.section].reorder_level = relvl
                    variantsTable.reloadData()
                }
                else if textField == cell.upcCode {
                    
                    let upcText = cell.upcCode.text ?? ""
                    
                    if upcText == "" {
                        variantsArray[index.section].upc = ""
                    }
                    else {
                        
                        let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                        
                        if upcUnique.contains(upcText) {
                            ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            cell.upcCode.isError(numberOfShakes: 3, revert: true)
                            cell.upcCode.text = ""
                            variantsArray[index.section].upc = ""
                        }
                        else {
                            
                            if variantsArray.contains(where: {$0.upc == upcText}) {
                                
                                if textField.tag  == variantsArray.firstIndex(where: {$0.upc == upcText}) {
                                    
                                    variantsArray[index.section].upc = upcText
                                    variantsTable.reloadData()
                                }
                                else {
                                    
                                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                                    cell.upcCode.text = ""
                                    variantsArray[index.section].upc = ""
                                }
                            }
                            else {
                                
                                variantsArray[index.section].upc = upcText
                                variantsTable.reloadData()
                            }
                        }
                    }
                }
            }
        }
        //edit
        else {
            
            if variantsArray.count == 0 {
                
                if textField == productField {
                    
                }
                
                else {
                    let index = IndexPath(row: 0, section: 0)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
                    _ = cost_per_value_doub/100
                    
                    if textField == cell.costPerItem {
                        
                        let cost_per_item = textField.text ?? ""
                        
                        guard cost_per_item != "" else {
                            return
                        }
                        
                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                        let price = cell.price.text ?? "0.00"
                        let price_doub = Double(price) ?? 0.00
                        let profit = Double(price_doub) - cost_per_item_doub
                        let margin = (profit / price_doub) * 100
                        
                        editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
                        //editProd?.price = String(format: "%.2f", price)
                        editProd?.margin = String(format: "%.2f", margin)
                        editProd?.profit = String(format: "%.2f", profit)
                        
                        if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
                            editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
                            editProd?.margin = "0.00"
                            editProd?.profit = "0.00"
                        }
                        else {
                            if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
                                
                                editProd?.costperItem = "0.00"
                                editProd?.margin = "0.00"
                                editProd?.profit = "0.00"
                                
                            }
                            
                            else {
                                
                                editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
                                editProd?.margin = String(format: "%.2f", margin)
                                editProd?.profit = String(format: "%.2f", profit)
                                
                            }
                        }
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.price {
                        
                        let price = cell.price.text ?? ""
                        editProd?.price = price
                        let price_doub = Double(price) ?? 0.00
                        
                        let cost_per_item = cell.costPerItem.text ?? ""
                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                        let profit = Double(price_doub) - cost_per_item_doub
                        let margin = (profit / price_doub) * 100
                        
                        if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
                            
                            editProd?.margin = "0.00"
                            editProd?.profit = "0.00"
                        }
                        else {
                            
                            if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
                                editProd?.margin = "0.00"
                                editProd?.profit = "0.00"
                            }
                            else {
                                editProd?.margin = String(format: "%.2f", margin)
                                editProd?.profit = String(format: "%.2f", profit)
                            }
                        }
                        
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.comparePrice {
                        
                        let cprice = cell.comparePrice.text ?? ""
                        editProd?.compare_price = cprice
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.qty {
                        
                        let quty = cell.qty.text ?? ""
                        editProd?.quantity = quty
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.customCode {
                        
                        let custom = cell.customCode.text ?? ""
                        editProd?.custom_code = custom
                        variantsTable.reloadData()
                    }
                    else if textField == cell.reorderQty {
                        let reqty = cell.reorderQty.text ?? ""
                        editProd?.reorder_qty = reqty
                        variantsTable.reloadData()
                    }
                    else if textField == cell.reorderLevel {
                        let relvl = cell.reorderLevel.text ?? ""
                        editProd?.reorder_level = relvl
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.upcCode {
                        
                        let upcText = cell.upcCode.text ?? ""
                        
                        if upcText == "" {
                            editProd?.upc = ""
                        }
                        else {
                            
                            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                            
                            if upcUnique.contains(upcText){
                                if upcText == activeTextUpcText { }
                                else {
                                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                    cell.upcCode.isError(numberOfShakes:  3, revert: true)
                                    cell.upcCode.text = ""
                                    editProd?.upc = ""
                                }
                            }else {
                                editProd?.upc = upcText
                                variantsTable.reloadData()
                            }
                        }
                    }
                }
            }
            else {
                
                if textField == productField {
                    
                }
                
                else {
                    
                    let index = IndexPath(row: 0, section: textField.tag)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
                    _ = cost_per_value_doub/100
                    
                    if textField == cell.costPerItem {
                        
                        let cost_per_item = textField.text ?? ""
                        
                        guard cost_per_item != "" else {
                            return
                        }
                        
                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                        let price = cell.price.text ?? "0.00"
                        let price_doub = Double(price) ?? 0.00
                        let profit = Double(price_doub) - cost_per_item_doub
                        let margin = (profit / price_doub) * 100
                        
                        if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
                            variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
                            variantsArray[index.section].margin = "0.00"
                            variantsArray[index.section].profit = "0.00"
                        }
                        else {
                            if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
                                
                                variantsArray[index.section].costperItem = "0.00"
                                variantsArray[index.section].margin = "0.00"
                                variantsArray[index.section].profit = "0.00"
                                
                            }
                            
                            else {
                                
                                variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
                                variantsArray[index.section].margin = String(format: "%.2f", margin)
                                variantsArray[index.section].profit = String(format: "%.2f", profit)
                                
                            }
                        }
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.price {
                        
                        let price = cell.price.text ?? ""
                        variantsArray[index.section].price = price
                        
                        let price_doub = Double(price) ?? 0.00
                        
                        let cost_per_item = variantsArray[index.section].costperItem
                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                        
                        let profit = Double(price_doub) - cost_per_item_doub
                        let margin = (profit / price_doub) * 100
                        
                        if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
                            
                            variantsArray[index.section].margin = "0.00"
                            variantsArray[index.section].profit = "0.00"
                        }
                        else {
                            
                            if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
                                variantsArray[index.section].margin = "0.00"
                                variantsArray[index.section].profit = "0.00"
                            }
                            else {
                                variantsArray[index.section].margin = String(format: "%.2f", margin)
                                variantsArray[index.section].profit = String(format: "%.2f", profit)
                            }
                        }
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.comparePrice {
                        
                        let cprice = cell.comparePrice.text ?? ""
                        variantsArray[index.section].compare_price = cprice
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.qty {
                        
                        let quty = cell.qty.text ?? ""
                        variantsArray[index.section].quantity = quty
                        variantsTable.reloadData()
                    }
                    
                    else if textField == cell.customCode {
                        
                        let custom = cell.customCode.text ?? ""
                        variantsArray[index.section].custom_code = custom
                        variantsTable.reloadData()
                    }
                    else if textField == cell.reorderQty {
                        let reqty = cell.reorderQty.text ?? ""
                        variantsArray[index.section].reorder_qty = reqty
                        variantsTable.reloadData()
                    }
                    else if textField == cell.reorderLevel {
                        let relvl = cell.reorderLevel.text ?? ""
                        variantsArray[index.section].reorder_level = relvl
                        variantsTable.reloadData()
                    }
                    
                    
                    else if textField == cell.upcCode {
                        
                        let upcText = cell.upcCode.text ?? ""
                        
                        if upcText == "" {
                            variantsArray[index.section].upc = ""
                        }
                        else {
                            
                            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                            
                            if upcUnique.contains(upcText) {
                                if upcText == activeTextUpcText { }
                                else {
                                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                                    cell.upcCode.text = ""
                                    variantsArray[index.section].upc = ""
                                }
                            }
                            else {
                                
                                if variantsArray.contains(where: {$0.upc == upcText}) {
                                    if textField.tag  == variantsArray.firstIndex(where: {$0.upc == upcText}) {
                                        variantsArray[index.section].upc = upcText
                                        variantsTable.reloadData()
                                    }
                                    else {
                                        ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                        cell.upcCode.isError(numberOfShakes: 3, revert: true)
                                        cell.upcCode.text = ""
                                        variantsArray[index.section].upc = ""
                                    }
                                }
                                else {
                                    variantsArray[index.section].upc = upcText
                                    variantsTable.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if mode == "add" {
            
            if textField == productField {
                activeTextField = textField
            }
            else {
                let index = IndexPath(row: 0, section: textField.tag)
                let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                
                if textField == cell.qty {
                    activeTextField = textField
                }
                else if textField == cell.customCode {
                    activeTextField = textField
                }
                else if  textField == cell.upcCode {
                    
                    activeTextField = textField
                }
                else if  textField == cell.reorderQty {
                    
                    activeTextField = textField
                }
                else if  textField == cell.reorderLevel {
                    activeTextField = textField
                }
            }
        }
        //edit
        else {
            
            if variantsArray.count == 0 {
                
                if textField == productField {
                    activeTextField = textField
                }
                else {
                    let index = IndexPath(row: 0, section: 0)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    if textField == cell.qty {
                        activeTextField = textField
                    }
                    else if textField == cell.customCode {
                        activeTextField = textField
                    }
                    else if  textField == cell.upcCode {
                        activeTextUpcText = textField.text ?? ""
                        activeTextField = textField
                    }
                    else if  textField == cell.reorderQty {
                        
                        activeTextField = textField
                    }
                    else if  textField == cell.reorderLevel {
                        activeTextField = textField
                    }
                }
            }
            
            else {
                
                if textField == productField {
                    activeTextField = textField
                }
                else {
                    let index = IndexPath(row: 0, section: textField.tag)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    if textField == cell.qty {
                        activeTextField = textField
                    }
                    else if textField == cell.customCode {
                        activeTextField = textField
                    }
                    else if  textField == cell.upcCode {
                        activeTextUpcText = textField.text ?? ""
                        activeTextField = textField
                    }
                    else if  textField == cell.reorderQty {
                        
                        activeTextField = textField
                    }
                    else if  textField == cell.reorderLevel {
                        activeTextField = textField
                    }
                }
            }
        }
    }
    
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        if mode == "add" {
            
            var updatetext = textField.text ?? ""
            
            if textField == productField {
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
            
            else {
                
                let index = IndexPath(row: 0, section: textField.tag)
                let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                
                if textField == cell.qty  {
                    if updatetext.count > 6 {
                        updatetext = String(updatetext.dropLast())
                    }
                }
                else if textField == cell.customCode {
                    if updatetext.count > 30 {
                        updatetext = String(updatetext.dropLast())
                    }
                }
                else if textField == cell.upcCode {
                    if updatetext.count > 20{
                        updatetext = String(updatetext.dropLast())
                    }
                }
                
                else if textField == cell.reorderQty {
                    if updatetext.count > 6 {
                        updatetext = String(updatetext.dropLast())
                    }
                }
                else if textField == cell.reorderLevel {
                    if updatetext.count > 6 {
                        updatetext = String(updatetext.dropLast())
                        
                    }
                }
            }
            
            activeTextField.text = updatetext
        }
        //edit
        else {
            
            if variantsArray.count == 0 {
                
                var updatetext = textField.text ?? ""
                
                if textField == productField {
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
                
                else {
                    
                    let index = IndexPath(row: 0, section: 0)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    if textField == cell.qty  {
                        if updatetext.count > 6 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.customCode {
                        if updatetext.count > 30 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.upcCode {
                        if updatetext.count > 20 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.reorderQty {
                        if updatetext.count > 6{
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.reorderLevel {
                        if updatetext.count > 6 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                }
                
                activeTextField.text = updatetext
            }
            
            else {
                
                var updatetext = textField.text ?? ""
                
                if textField == productField {
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
                
                else {
                    
                    let index = IndexPath(row: 0, section: textField.tag)
                    let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    
                    if textField == cell.qty {
                        if updatetext.count > 6 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.customCode {
                        if updatetext.count > 30 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.upcCode {
                        if updatetext.count > 20 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.reorderQty {
                        if updatetext.count > 6 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                    else if textField == cell.reorderLevel {
                        if updatetext.count > 6 {
                            updatetext = String(updatetext.dropLast())
                        }
                    }
                }
                
                activeTextField.text = updatetext
            }
        }
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
}

extension PlusViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate,
                              BarcodeScannerErrorDelegate {
    
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        let urlString = code
        
        if mode == "add" {
            
            let index = IndexPath(row: 0, section: scanIndex)
            let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
            if upcUnique.contains(urlString) {
                controller.dismiss(animated: true)
                ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                cell.upcCode.isError(numberOfShakes: 3, revert: true)
                cell.upcCode.text = ""
                variantsArray[scanIndex].upc = ""
            }
            else {
                
                if variantsArray.contains(where: {$0.upc == urlString}) {
                    
                    if scanIndex == variantsArray.firstIndex(where: {$0.upc == urlString}) {
                        variantsArray[scanIndex].upc = urlString
                        variantsTable.reloadData()
                        controller.dismiss(animated: true)
                    }
                    else {
                        controller.dismiss(animated: true)
                        ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        cell.upcCode.isError(numberOfShakes: 3, revert: true)
                        cell.upcCode.text = ""
                        variantsArray[scanIndex].upc = ""
                    }
                }
                else {
                    variantsArray[scanIndex].upc = urlString
                    variantsTable.reloadData()
                    controller.dismiss(animated: true)
                }
            }
        }
        //edit
        else {
            
            if variantsArray.count == 0 {
                let index = IndexPath(row: 0, section: scanIndex)
                let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                
                let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                
                if upcUnique.contains(urlString) {
                    controller.dismiss(animated: true)
                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    cell.upcCode.text = ""
                    editProd?.upc = ""
                }
                else {
                    controller.dismiss(animated: true)
                    editProd?.upc = urlString
                    variantsTable.reloadData()
                }
            }
            else {
                
                let index = IndexPath(row: 0, section: scanIndex)
                let cell = variantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                
                let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                
                if upcUnique.contains(urlString) {
                    controller.dismiss(animated: true)
                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    cell.upcCode.text = ""
                    variantsArray[scanIndex].upc = ""
                }
                else {
                    
                    if variantsArray.contains(where: {$0.upc == urlString}) {
                        
                        if scanIndex == variantsArray.firstIndex(where: {$0.upc == urlString}) {
                            variantsArray[scanIndex].upc = urlString
                            variantsTable.reloadData()
                            controller.dismiss(animated: true)
                        }
                        else {
                            controller.dismiss(animated: true)
                            ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            cell.upcCode.isError(numberOfShakes: 3, revert: true)
                            cell.upcCode.text = ""
                            variantsArray[scanIndex].upc = ""
                        }
                    }
                    else {
                        variantsArray[scanIndex].upc = urlString
                        variantsTable.reloadData()
                        controller.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        controller.dismiss(animated: true)
    }
}

extension PlusViewController {
    
    func checkExist(result: String) -> Bool {
        return true
    }
}

extension PlusViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == catColl {
            
            return collCat.count
        }
        
        else if collectionView == tagColl {
            
            return collTag.count
        }
        
        else {
            
            return collTax.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == catColl {
            
            let cell = catColl.dequeueReusableCell(withReuseIdentifier: "catcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = collCat[indexPath.row].title
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: catColl)
            
            return cell
            
        }
        
        else if collectionView == tagColl {
            
            let cell = tagColl.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = collTag[indexPath.row]
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: tagColl)
            
            return cell
        }
        
        else {
            
            let cell = taxesColl.dequeueReusableCell(withReuseIdentifier: "taxcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = collTax[indexPath.row].title
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: taxesColl)
            
            return cell
        }
    }
}

extension PlusViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == variantsTable {
            if variantsArray.count == 0 {
                return isSelectedData.count
            }
            else {
                return variantsArray.count
            }
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == variantsTable {
            if isSelectedData[section] {
                return 1
            }else{
                return 0
            }
        }
        else {
            return productOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == variantsTable {
            
            let cell = variantsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductVariantTableViewCell
            
            cell.price.label.text = "Price"
            cell.comparePrice.label.text = "Compare At Price"
            cell.costPerItem.label.text = "Cost Per Item"
            cell.margin.label.text = "Margin(%)"
            cell.profit.label.text = "Profit($)"
            cell.qty.label.text = "QTY"
            cell.customCode.label.text = "Custom Code"
            cell.upcCode.label.text = "UPC Code"
            cell.reorderQty.label.text = "Reorder Qty"
            cell.reorderLevel.label.text = "Reoder Level"
            
            createCustomTextField(textField: cell.price)
            createCustomTextField(textField: cell.costPerItem)
            createCustomTextField(textField: cell.margin)
            createCustomTextField(textField: cell.profit)
            createCustomTextField(textField: cell.qty)
            createCustomTextField(textField: cell.customCode)
            createCustomTextField(textField: cell.upcCode)
            createCustomTextField(textField: cell.comparePrice)
            createCustomTextField(textField: cell.reorderQty)
            createCustomTextField(textField: cell.reorderLevel)
            
            cell.margin.backgroundColor = UIColor(named: "Disabled Text")
            cell.profit.backgroundColor = UIColor(named: "Disabled Text")
            cell.margin.setOutlineColor(.clear, for: .normal)
            cell.margin.setOutlineColor(.clear, for: .editing)
            cell.profit.setOutlineColor(.clear, for: .normal)
            cell.profit.setOutlineColor(.clear, for: .editing)
            cell.margin.layer.cornerRadius = 5
            cell.profit.layer.cornerRadius = 5
            
            cell.costPerItem.keyboardType = .numberPad
            cell.price.keyboardType = .numberPad
            cell.qty.keyboardType = .numberPad
            cell.comparePrice.keyboardType = .numberPad
            cell.reorderQty.keyboardType = .numberPad
            cell.reorderLevel.keyboardType = .numberPad
            
            cell.costPerItem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
            cell.price.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
            cell.comparePrice.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
            cell.margin.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
            cell.profit.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
            
            cell.qty.addTarget(self, action: #selector(updateText), for: .editingChanged)
            cell.customCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
            cell.upcCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
            cell.reorderQty.addTarget(self, action: #selector(updateText), for: .editingChanged)
            cell.reorderLevel.addTarget(self, action: #selector(updateText), for: .editingChanged)
            
            cell.costPerItem.tag = indexPath.section
            cell.price.tag = indexPath.section
            cell.comparePrice.tag = indexPath.section
            cell.margin.tag = indexPath.section
            cell.profit.tag = indexPath.section
            cell.qty.tag = indexPath.section
            cell.customCode.tag = indexPath.section
            cell.upcCode.tag = indexPath.section
            cell.instantBtn.tag = indexPath.section
            cell.salesHistoryBtn.tag = indexPath.section
            cell.reorderQty.tag = indexPath.section
            cell.reorderLevel.tag = indexPath.section
            
            cell.trackQty.tag = indexPath.section
            cell.selling.tag = indexPath.section
            cell.checkID.tag = indexPath.section
            cell.disable.tag = indexPath.section
            cell.foodstampable.tag = indexPath.section
            
            cell.costPerItem.delegate = self
            cell.price.delegate =  self
            cell.comparePrice.delegate = self
            cell.margin.delegate = self
            cell.profit.delegate = self
            cell.qty.delegate = self
            cell.customCode.delegate = self
            cell.upcCode.delegate = self
            cell.reorderQty.delegate = self
            cell.reorderLevel.delegate = self
            
            cell.scanBtn.tag = indexPath.section
            
            cell.instantBtn.layer.cornerRadius = 10.0
            cell.salesHistoryBtn.layer.cornerRadius = 10.0
            cell.scanBtn.layer.cornerRadius = 5.0
            
            if mode == "add" {
                
                var variants = variantsArray[indexPath.section]
                
                cell.price.text = variants.price
                cell.comparePrice.text = variants.compare_price
                cell.costPerItem.text = variants.costperItem
                cell.margin.text = variants.margin
                cell.profit.text = variants.profit
                cell.qty.text = variants.quantity
                cell.customCode.text = variants.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                cell.upcCode.text = variants.upc
                cell.reorderQty.text = variants.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                cell.reorderLevel.text = variants.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                if result.count == 0 {
                    variants.variant = ""
                }
                else {
                    variants.variant = result[indexPath.section]
                }
                
                if variants.trackqnty == "1"{
                    cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                else {
                    cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                if variants.isstockcontinue == "1"{
                    cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                else {
                    cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                if variants.is_tobacco == "1"{
                    cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                else {
                    cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                if variants.disable == "1"{
                    cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                else {
                    cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                if variants.food_stampable == "1"{
                    cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                else {
                    cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                cell.instantBtn.isHidden = true
                cell.salesHistoryBtn.isHidden = true
                cell.salesHeight.constant = 0
                cell.costItemInner.isHidden = true
                cell.qtyInner.isHidden = true
                
                variantsArray[indexPath.section] = variants
            }
            
            //edit
            else {
                
                let cost_method = UserDefaults.standard.string(forKey: "cost_method")
                //avg is enabled
                
                if isQuantity[indexPath.section] == "1" {
                    
                    cell.costPerItem.backgroundColor = .systemBackground
                    cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
                    cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
                    cell.costItemInner.isHidden = true
                    
                    cell.qty.backgroundColor = .systemBackground
                    cell.qty.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
                    cell.qty.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
                    cell.qtyInner.isHidden = true
                }
                
                else {
                    
                    if cost_method == "1" {
                        
                        cell.costPerItem.backgroundColor = UIColor(named: "Disabled Text")
                        cell.costPerItem.setOutlineColor(.clear, for: .normal)
                        cell.costPerItem.setOutlineColor(.clear, for: .editing)
                        cell.costItemInner.isHidden = false
                    }
                    else {
                        cell.costPerItem.backgroundColor = .systemBackground
                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
                        cell.costItemInner.isHidden = true
                    }
                    
                    cell.qty.backgroundColor = UIColor(named: "Disabled Text")
                    cell.qty.setOutlineColor(.clear, for: .normal)
                    cell.qty.setOutlineColor(.clear, for: .editing)
                    cell.qtyInner.isHidden = false
                }
                
                var variants: ProductById?
                
                if variantsArray.count == 0 {
                    variants = editProd
                    
                    cell.price.text = variants?.price
                    cell.comparePrice.text = variants?.compare_price
                    cell.costPerItem.text = variants?.costperItem
                    cell.margin.text = variants?.margin
                    cell.profit.text = variants?.profit
                    cell.qty.text = variants?.quantity
                    cell.customCode.text = variants?.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    cell.upcCode.text = variants?.upc
                    cell.reorderQty.text = variants?.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    cell.reorderLevel.text = variants?.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    if variants?.trackqnty == "1"{
                        cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.isstockcontinue == "1"{
                        cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.is_tobacco == "1"{
                        cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.disable == "1"{
                        cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.food_stampable == "1"{
                        cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                }
                
                else {
                    variants = variantsArray[indexPath.section]
                    cell.price.text = variants?.price
                    cell.comparePrice.text = variants?.compare_price
                    cell.costPerItem.text = variants?.costperItem
                    cell.margin.text = variants?.margin
                    cell.profit.text = variants?.profit
                    cell.qty.text = variants?.quantity
                    cell.customCode.text = variants?.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    cell.upcCode.text = variants?.upc
                    cell.reorderQty.text = variants?.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    cell.reorderLevel.text = variants?.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    if variants?.trackqnty == "1"{
                        cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.isstockcontinue == "1"{
                        cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.is_tobacco == "1"{
                        cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.disable == "1"{
                        cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                    
                    if variants?.food_stampable == "1"{
                        cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                }
                cell.instantBtn.isHidden = false
                cell.salesHistoryBtn.isHidden = false
                cell.salesHeight.constant = 45
            }
            
            return cell
        }
        
        else {
            
            let cell = attTable.dequeueReusableCell(withIdentifier: "attrcell", for: indexPath) as! AddAttrCell
            
            if mode == "add" {
                cell.delete_btn.setImage(UIImage(named: "red_delete"), for: .normal)
            }
            else {
                cell.delete_btn.setImage(UIImage(named: "next"), for: .normal)
            }
            
            if productOptions[indexPath.row].options1 == "" && productOptions[indexPath.row].options2 == "" {
                cell.attName.text = productOptions[indexPath.row].options3
            }
            else if productOptions[indexPath.row].options2 == "" && productOptions[indexPath.row].options3 == "" {
                cell.attName.text = productOptions[indexPath.row].options1
            }
            else {
                cell.attName.text = productOptions[indexPath.row].options2
            }
            
            cell.delete_btn.layer.cornerRadius = 5
            cell.delete_btn.tag = indexPath.row
            cell.borderview.dropAttShadow()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == attTable {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addVariantAtt") as! AddVariantAttributeViewController
            
            variantMode = "edit"
            vc.subMode = variantMode
            vc.mode = mode
            vc.goMode = variantGoMode
            
            vc.delegatePlus = self
            vc.selectedAtt = productOptions
            let index = indexPath.row
            attIndex = index
            vc.options = productOptions[index]
            
            if mode == "edit" {
                
                if productOptions.count == 3 {
                    
                    if index == 0 {
                        let opt1 = productOptions[1].optionsvl2.components(separatedBy: ",")
                        arrOptVl2 = opt1
                        let opt2 = productOptions[2].optionsvl3.components(separatedBy: ",")
                        arrOptVl3 = opt2
                    }
                    else if index == 1 {
                        let opt1 = productOptions[0].optionsvl1.components(separatedBy: ",")
                        arrOptVl1 = opt1
                        let opt2 = productOptions[2].optionsvl3.components(separatedBy: ",")
                        arrOptVl3 = opt2
                    }
                    else {
                        let opt1 = productOptions[0].optionsvl1.components(separatedBy: ",")
                        arrOptVl1 = opt1
                        let opt2 = productOptions[1].optionsvl2.components(separatedBy: ",")
                        arrOptVl2 = opt2
                    }
                }
                else if productOptions.count == 2 {
                    if index == 0 {
                        let opt1 = productOptions[1].optionsvl2.components(separatedBy: ",")
                        arrOptVl2 = opt1
                    }
                    else {
                        let opt1 = productOptions[0].optionsvl1.components(separatedBy: ",")
                        arrOptVl1 = opt1
                    }
                }
                vc.editEleArr = newEditArr
            }
            
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == variantsTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 50))
            headerView.backgroundColor = UIColor(hexString: "#F9F9F9")
            headerView.tag = section
            
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRect(x: 10, y: headerView.frame.size.height - 1, width: (headerView.frame.size.width - 20), height: 1)
            
            if isSelectedData[section] {
                bottomLayer.backgroundColor = UIColor.clear.cgColor
            }
            else {
                bottomLayer.backgroundColor = UIColor(named: "borderColor")?.cgColor
            }
            headerView.layer.addSublayer(bottomLayer)
            
            let openImg = UIImageView(frame: CGRect(x: (tableView.frame.size.width - 60), y: 0, width: 50, height: 50))
            openImg.image = UIImage(named: "down")
            openImg.contentMode = .center
            
            let variantLabel = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width - 70), height: 50))
            variantLabel.textColor = .black
            
            if mode == "add" {
                if productOptions.count > 0 {
                    variantLabel.text = result[section]
                }
            }
            //edit
            else {
                if variantsArray.count == 0 {
                    variantLabel.text = editProd?.title
                }
                else if result.count == 0 {
                    variantLabel.text = variantsArray[section].variant
                }
                else {
                    variantLabel.text = result[section]
                }
            }
            variantLabel.font = UIFont(name: "Manrope-Medium", size: 15.0)!
            variantLabel.numberOfLines = 0
            variantLabel.lineBreakMode = .byWordWrapping
            variantLabel.minimumScaleFactor = 0.5
            
            let header_tap = UITapGestureRecognizer(target: self, action: #selector(sayAction(_:)))
            headerView.addGestureRecognizer(header_tap)
            headerView.isUserInteractionEnabled = true
            headerView.addSubview(variantLabel)
            headerView.addSubview(openImg)
            
            return headerView
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == variantsTable {
            return 50
        }
        
        else {
            return 0
        }
    }
    
    func sayAct(tag: Int) {
        
        if isSelectedData[tag] {
            
        }
        else {
            
            for select in 0..<isSelectedData.count {
                
                if select == tag {
                    isSelectedData[select] = true
                }
                else {
                    isSelectedData[select] = false
                }
            }
            variantsTable.reloadData()
        }
    }
    
    @objc func sayAction(_ gesture: UITapGestureRecognizer) {
        
        let tagView = gesture.view?.tag ?? 0
        
        //single
        if variantsArray.count == 1 || variantsArray.count == 0 {
            
            //true
            if isSelectedData[tagView] {
                
                ////                isSelectedData[tagView].toggle()
                ////
                ////                let cat = catcollHeight.constant - 50
                ////                let tax = taxCollHeight.constant - 50
                ////
                ////                if mode == "add" {
                ////                    scrollHeight.constant = 614 + cat + tax + attHeight.constant + 150
                ////                    if productOptions.count == 3 {
                ////                        addVarBtn.isHidden = true
                ////                        addVarBtnHeight.constant = 0
                ////                        addVarTop.constant = 0
                ////                    }
                ////                    else {
                ////                        scrollHeight.constant = 614 + cat + tax + attHeight.constant + 220
                ////                        addVarBtn.isHidden = false
                ////                        addVarBtnHeight.constant = 50
                ////                        addVarTop.constant = 20
                ////                    }
                //                }
                //                else {
                //                    //771 = 826
                //                    scrollHeight.constant = 614 + cat + tax + attHeight.constant + 195
                //                    addVarBtn.isHidden = true
                //                    addVarBtnHeight.constant = 0
                //                    addVarTop.constant = 0
                //                }
            }
            //false
            else {
                
                isSelectedData[tagView].toggle()
                
                let cat = catcollHeight.constant
                let tag = tagCollHeight.constant
                let tax = taxCollHeight.constant
                
                if mode == "add" {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 706
                    if productOptions.count == 3 {
                        addVarBtn.isHidden = true
                        addVarBtnHeight.constant = 0
                        addVarTop.constant = 0
                    }
                    else {
                        scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 776
                        addVarBtn.isHidden = false
                        addVarBtnHeight.constant = 50
                        addVarTop.constant = 20
                    }
                }
                else {
                    //771 = 826
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + 751
                    addVarBtn.isHidden = true
                    addVarBtnHeight.constant = 0
                    addVarTop.constant = 0
                }
            }
        }
        // multiple
        else {
            //true
            if isSelectedData[tagView] {
                let var_count = variantsArray.count
                isSelectedData[tagView].toggle()
                
                let cat = catcollHeight.constant
                let tag = tagCollHeight.constant
                let tax = taxCollHeight.constant
                
                
                if mode == "add" {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + CGFloat(50 * var_count)
                    if productOptions.count == 3 {
                        addVarBtn.isHidden = true
                        addVarBtnHeight.constant = 0
                        addVarTop.constant = 0
                    }
                    else {
                        scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + CGFloat(50 * var_count)
                        addVarBtn.isHidden = false
                        addVarBtnHeight.constant = 50
                        addVarTop.constant = 20
                    }
                }
                else {
                    scrollHeight.constant = 614 + cat + tag + tax + attHeight.constant + CGFloat(50 * var_count)
                    addVarBtn.isHidden = true
                    addVarBtnHeight.constant = 0
                    addVarTop.constant = 0
                }
            }
            // false
            else {
                
                for select in 0..<isSelectedData.count {
                    
                    if isSelectedData[select] {
                        isSelectedData[select].toggle()
                    }
                    else if select == tagView {
                        isSelectedData[select].toggle()
                    }
                }
                
                setCollHeight(coll: variantsTable)
            }
        }
        variantsTable.reloadData()
    }
}

extension PlusViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    
    private func setUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        saveBtn.addSubview(loadIndicator)
        var center = 40
        if mode == "add" {
            center = 30
        }
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
        
        scrollView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: scrollView.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: scrollView.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

struct InventoryOptions {
    let id: String
    let product_id: String
    let options1: String
    var optionsvl1: String
    let options2: String
    var optionsvl2: String
    let options3: String
    var optionsvl3: String
    let merchant_id: String
    let admin_id: String
}


struct ProductById {
    
    var alternateName: String
    var admin_id: String
    var description: String
    var starting_quantity: String
    var margin: String
    var brand: String
    var tags: String
    var upc: String?
    var id: String
    var sku: String
    var disable: String
    var food_stampable: String
    var isvarient: String
    var is_lottery: String
    var title: String
    var quantity: String?
    var ischargeTax: String
    var updated_on: String
    var isstockcontinue: String
    var trackqnty: String
    var profit: String
    var custom_code: String
    var assigned_vendors: String
    var barcode: String
    var country_region: String
    var ispysical_product: String
    var show_status: String
    var HS_code: String
    var price: String?
    var featured_product: String
    var merchant_id: String
    var created_on: String
    var prefferd_vendor: String
    var reorder_cost: String
    var other_taxes: String
    var buy_with_product: String
    var costperItem: String
    var is_tobacco: String
    var product_doc: String
    var user_id: String
    var media: String
    var compare_price: String
    var loyalty_product_id: String
    var show_type: String
    var cotegory: String
    var reorder_level: String
    var env: String
    var variant: String
    var reorder_qty: String
    var purchase_qty: String
}

struct AddProduct {
    
    var merchant_id: String
    var title: String
    var description: String
    var price: String
    var compare_price: String
    var costperItem: String
    var margin: String
    var profit: String
    var ischargeTax: String
    var trackqnty: String
    var isstockcontinue: String
    var quantity: String
    var collection: String
    var isvarient: String
    var created_on: String
    var optionid: String
    var optionarray: String
    var optionarray1: String
    var optionarray2: String
    var optionvalue: String
    var optionvalue1: String
    var optionvalue2: String
    var other_taxes: String
    var bought_product: String
    var featured_product: String
    var varid: String
    var varvarient: String
    var varprice: String
    var varcompareprice: String
    var varcostperitem: String
    var varquantity: String
    var upc: String
    var custom_code: String
    var reorder_qty: String
    var reorder_level: String
    var reorder_cost: String
    var is_tobacco: String
    var disable: String
    var food_stampable: String
    var varupc: String
    var varcustomcode: String
    var vartrackqnty: String
    var varcontinue_selling: String
    var varcheckid: String
    var vardisable: String
    var varfood_stampable: String
    var varmargin: String
    var varprofit: String
    var varreorder_qty: String
    var varreorder_level: String
    var varreorder_cost: String
}
