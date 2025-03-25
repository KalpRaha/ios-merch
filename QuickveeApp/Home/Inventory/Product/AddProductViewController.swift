////
////  AddProductViewController.swift
////
////
////  Created by Jamaluddin Syed on 9/11/23.
////
//
//import UIKit
//import MaterialComponents
//import DropDown
//import VisionKit
//import BarcodeScanner
//
//class AddProductViewController: UIViewController {
//    
//    @IBOutlet weak var lblUpc: UILabel!
//    @IBOutlet weak var topview: UIView!
//    @IBOutlet weak var productName: MDCOutlinedTextField!
//    @IBOutlet weak var descField: MDCOutlinedTextField!
//    
//    
//    @IBOutlet weak var brandField: MDCOutlinedTextField!
//    @IBOutlet weak var cancelBtn: UIButton!
//    @IBOutlet weak var saveBtn: UIButton!
//    @IBOutlet weak var addAttribute: UIButton!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var tableview: UITableView!
//    
//    @IBOutlet weak var scroll: UIScrollView!
//    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
//    @IBOutlet weak var catColl: UICollectionView!
//    @IBOutlet weak var scrollview: UIView!
//    @IBOutlet weak var tax_collection: UICollectionView!
//    
//    @IBOutlet weak var categoryField: UIView!
//    
//    @IBOutlet weak var cat_lbl: UILabel!
//    @IBOutlet weak var attTable: UITableView!
//    
//    @IBOutlet weak var addAttriBtnHeight: NSLayoutConstraint!
//    @IBOutlet weak var cat_coll_height: NSLayoutConstraint!
//    @IBOutlet weak var attTableHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var tax_coll_height: NSLayoutConstraint!
//
//    @IBOutlet weak var upperView: UIView!
//    @IBOutlet weak var dupView: UIView!
//    
//    @IBOutlet weak var tripleWidth: NSLayoutConstraint!
//    @IBOutlet weak var maxView: UIView!
//   
//    //    @IBOutlet weak var bulkTitleLbl: UILabel!
////    @IBOutlet weak var thirdView: UIView!
////
//    var upcCode = ""
//    
//    var arrTax = [SetupTaxes]()
//    var collArrTax = [SetupTaxes]()
//    var arrTaxId = [String]()
//    var arrTaxNames = [String]()
//    var prodCategories = [InventoryCategory]()
//    var productId = [String]()
//    var catsAddArr = [InventoryCategory]()
//    var closeClick = String()
//    var productOptions = [InventoryOptions]()
//    var isSelectedData = [Bool]()
//    let transparentView = UIView()
//    let menu = DropDown()
//    var selectedButton = UIButton()
//    var taxDropList = [SetupTaxes]()
//    var addattrIndex = 0
//    var isbulk = false
//    
//    var bulkpricingArr = [BulkPricingModel]()
//    
//    var goMode = ""
//    
//    var newEditAtt = [String]()
//    
//    var result = [String]()
//    var catMode = ""
//    
//    var arrOptVl1 = [String]()
//    var arrOptVl2 = [String]()
//    var arrOptVl3 = [String]()
//    
//    var unsel_var_array = [String]()
//    
//    var attNameArray = [InventoryOptions]()
//
//    var activeTextField = UITextField()
//    var activeTextUpcText = ""
//    var inventoryOpt: InventoryOptions?
//    
//    let loadingIndicator: ProgressView = {
//        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        return progress
//    }()
//    
//    let loadIndicator: ProgressView = {
//        let progress = ProgressView(colors: [.white], lineWidth: 3)
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        return progress
//    }()
//        
//    var pay = String()
//    var variantsArray = [ProductById]()
//    
//    var p_id = ""
//    var mode = ""
//    var prod_purchaseQty = ""
//    var editProd: ProductById?
//    
//    private var isSymbolOnRight = false
//    var scanIndex = 0
//    var editCombo = 0
//    var addCombo = 0
//    
//    var m_id = ""
//    var vari_id = ""
//    var varname = ""
//    var isVarient = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        catColl.dataSource = self
//        catColl.delegate = self
//    
//        tax_collection.delegate = self
//        tax_collection.dataSource = self
//        tax_collection.layer.cornerRadius = 5
//        tax_collection.layer.borderColor = UIColor(named: "borderColor")?.cgColor
//        tax_collection.layer.borderWidth = 1.0
//        
////        createCustomTextField(textField: productName)
////        createCustomTextField(textField: descField)
////        createCustomTextField(textField: brandField)
//        
//        productName.label.text = "Product Name"
//        descField.label.text = "Description"
//        brandField.label.text = "Brand"
//        
//        topview.addBottomShadow()
//        
//        cancelBtn.layer.cornerRadius = 10
//        saveBtn.layer.cornerRadius = 10
//        
//        cancelBtn.layer.borderColor = UIColor.black.cgColor
//        cancelBtn.layer.borderWidth = 1.0
//        
//        addAttribute.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
//        addAttribute.layer.borderWidth = 1.0
//        addAttribute.layer.cornerRadius = 5
//        addAttribute.backgroundColor = .white
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(openDrop))
//        tax_collection.addGestureRecognizer(tap)
//        tap.numberOfTapsRequired = 1
//        tax_collection.isUserInteractionEnabled = true
//        
//        let columnLayout = CustomFlowLayout()
//        catColl.collectionViewLayout = columnLayout
//        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        
//        let colLayout = CustomFlowLayout()
//        tax_collection.collectionViewLayout = colLayout
//        colLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        
//        let cat_tap = UITapGestureRecognizer(target: self, action: #selector(openCatScreen))
//        cat_lbl.addGestureRecognizer(cat_tap)
//        cat_tap.numberOfTapsRequired = 1
//        cat_lbl.isUserInteractionEnabled = true
//        
//        
//        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(genUpcClick))
//        lblUpc.addGestureRecognizer(tapUpc)
//        tapUpc.numberOfTapsRequired = 1
//        lblUpc.isUserInteractionEnabled = true
//        
////        let first_tap = UITapGestureRecognizer(target: self, action: #selector(purchaseQtyClick))
////        maxView.addGestureRecognizer(first_tap)
////        first_tap.numberOfTapsRequired = 1
////        maxView.isUserInteractionEnabled = true
////
////        let second_tap = UITapGestureRecognizer(target: self, action: #selector(dupClick))
////        dupView.addGestureRecognizer(second_tap)
////        second_tap.numberOfTapsRequired = 1
////        dupView.isUserInteractionEnabled = true
//        
////        let third_tap = UITapGestureRecognizer(target: self, action: #selector(purchaseQtyClick))
////        thirdView.addGestureRecognizer(third_tap)
////        third_tap.numberOfTapsRequired = 1
////        thirdView.isUserInteractionEnabled = true
//        
//        
//        categoryField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
//        categoryField.layer.borderWidth = 1.0
//        categoryField.layer.cornerRadius = 5
//        catColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
//        catColl.layer.borderWidth = 1.0
//        catColl.layer.cornerRadius = 5
//        
//        productName.delegate = self
//        productName.addTarget(self, action: #selector(updateText), for: .editingChanged)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//     
//        saveBtn.isEnabled = true
//        upperView.isHidden = true
//        if mode == "add" {
//            
//            saveBtn.setTitle("Add", for: .normal)
//            tripleWidth.constant = 0
//            titleLbl.text = "Add Product"
//            attTableHeight.constant = CGFloat(73 * productOptions.count)
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + cat_coll_height.constant +
//                    tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                    
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count)
//                }
//            }
//            
//            if variantsArray.count == 0 {
//                
//                let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
//                                            brand: "", tags: "", upc: "",
//                                            id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "", title: "", quantity: "", ischargeTax: "",
//                                            updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                            assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
//                                            show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
//                                            created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
//                                            buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
//                                            media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
//                                            reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
//                
//                variantsArray.append(emptyProd)
//                
//                print(variantsArray.count)
//                attTableHeight.constant = CGFloat(73 * productOptions.count)
//                
//                if cat_coll_height.constant > 53.0 {
//                    
//                    if tax_coll_height.constant > 53.0 {
//                        
//                        scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + cat_coll_height.constant +
//                        tax_coll_height.constant + 20
//                    }
//                    
//                    else {
//                        scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                    }
//                }
//                else {
//                    
//                    if tax_coll_height.constant > 53.0 {
//                        
//                        scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                    }
//                    
//                    else {
//                        scrollHeight.constant =  1300 + CGFloat(73 * productOptions.count)
//                    }
//                    
//                }
//                print(scrollHeight.constant)
//            }
//            
//            
//            else {
//                
//                adjustAttributeCombos()
//                
//                
//                if addCombo == 1 {
//                    for variants in 0..<variantsArray.count {
//                        
//                        let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
//                                                    brand: "", tags: "", upc: "",
//                                                    id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "", title: "", quantity: "", ischargeTax: "",
//                                                    updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                    assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
//                                                    show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
//                                                    created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
//                                                    buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
//                                                    media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
//                                                    reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
//                        
//                        variantsArray[variants] = emptyProd
//                        
//                    }
//                    addCombo = 0
//                }
//            }
//            var isSel = [Bool]()
//            for i in 0..<variantsArray.count {
//                
//                if i == 0 {
//                    isSel.append(true)
//                }
//                else {
//                    isSel.append(false)
//                }
//            }
//            isSelectedData = isSel
//            tableview.reloadData()
//            
//            if catMode == "back" {
//                if !UserDefaults.standard.bool(forKey: "tax_add_var") {
//                    setupTaxApi()
//                }
//            }
//            
//            if catMode == "back" {
//                prodCategories = []
//            }
//            else {
//                prodCategories = catsAddArr
//            }
//            catColl.reloadData()
//        }
//        //edit
//        else {
//            saveBtn.setTitle("Update", for: .normal)
//            tripleWidth.constant = 50
//            titleLbl.text = "Edit Product"
//            
//            loadingIndicator.isAnimating = true
//            addAttribute.isHidden = true
//            addAttriBtnHeight.constant = 0
//            if editCombo == 0 && UserDefaults.standard.string(forKey: "toInstantPO") == "toprod" {
//                setUpProductApiId()
//            }
//            else {
//                adjustAttributeCombos()
//                setcollectionHeight()
//                taxSubviews()
//            }
//            
//            if catMode == "back" {
//            }
//            else {
//                if closeClick == "false" {
//                    prodCategories = catsAddArr
//                }
//            }
//            catColl.reloadData()
//            
//            print(isSelectedData)
//            if variantsArray.count == 0 {
//                var isSel = [Bool]()
//                isSel.append(true)
//                isSelectedData = isSel
//            }
//            else {
//                var isSel = [Bool]()
//                for i in 0..<variantsArray.count {
//                    
//                    if i == 0 {
//                        isSel.append(true)
//                    }
//                    else {
//                        isSel.append(false)
//                    }
//                }
//                isSelectedData = isSel
//            }
//            tableview.reloadData()
//            loadingIndicator.isAnimating = false
//        }
//        print(isSelectedData.count)
//        refreshCategoryColl()
//        inventSettingsCall()
//        
//        attTable.estimatedSectionHeaderHeight = 0
//        attTable.estimatedSectionFooterHeight = 0
//        
//        loadingIndicator.isAnimating = false
//    }
//    
//    func collSubviews() {
//        
//        self.setcollectionHeight()
//    }
//    
//    func setcollectionHeight() {
//
//        let height = catColl.collectionViewLayout.collectionViewContentSize.height
//        cat_coll_height.constant = height
//        self.view.layoutIfNeeded()
//        
//        if mode == "add" {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//               
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        //edit
//        else {
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//    }
//    
//    func taxSubviews() {
//        
//        self.setTaxcollectionHeight()
//    }
//    
//    func setTaxcollectionHeight() {
//
//        let height = tax_collection.collectionViewLayout.collectionViewContentSize.height
//        tax_coll_height.constant = height
//        self.view.layoutIfNeeded()
//        
//        if mode == "add" {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//               
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        //edit
//        else {
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//
//    }
//    
//    @objc func openCatScreen() {
//        openCat()
//        
//    }
//    
////    @objc func dupClick() {
////
////        performSegue(withIdentifier: "toDuplicate", sender: nil)
////    }
////
////    @objc func bulkClick() {
////
////        performSegue(withIdentifier: "toAddBulk", sender: nil)
////    }
////
////    @objc func purchaseQtyClick() {
////
////        performSegue(withIdentifier: "toAddPurchase", sender: nil)
////
////    }
//    
//    @objc func genUpcClick() {
//        
//        if mode == "add" {
//            
//            var upcCode = ""
//            
//            for upc in 0..<variantsArray.count {
//                
//                if variantsArray[upc].upc == "" {
//                    upcCode = getGeneratedUpc(length: 20)
//                    variantsArray[upc].upc = upcCode
//                }
//            }
//            tableview.reloadData()
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                let upcCode = getGeneratedUpc(length: 20)
//                editProd?.upc = upcCode
//                tableview.reloadData()
//            }
//            
//            else {
//                
//                for prods in 0..<variantsArray.count {
//                    
//                    if variantsArray[prods].upc == "" {
//                        let upcCode = getGeneratedUpc(length: 20)
//                        variantsArray[prods].upc = upcCode
//                    }
//                }
//                tableview.reloadData()
//            }
//        }
//    }
//    
//   
//    
//    func getGeneratedUpc(length: Int) -> String {
//        let characters = "0123456789"
//        var result = ""
//        for _ in 0..<length {
//            let resInt = Int(floor(Double.random(in: 0.0...0.9) * Double(characters.count)))
//            result += String(resInt)
//            print(result)
//        }
//        
//        return result
//    }
//    
//    func inventSettingsCall(){
//        ApiCalls.sharedCall.inventorySettingCall(merchant_id: m_id, completion: {isSuccess, responseData in
//            
//            if isSuccess {
//                
//                guard let setting = responseData["result"] else {
//                    return
//                }
//
//                let response = setting as! [String:Any]
//                print(response)
//                let cost_per = response["cost_per"] as? String ?? ""
//                let cost_method = response["cost_method"] as? String ?? ""
//                print(cost_per)
//                print(cost_method)
//                let req_Desc = response["inv_setting"] as? String ?? ""
//                if req_Desc.contains("2") {
//                    UserDefaults.standard.set(true, forKey: "Po Descrip")
//                }
//                else{
//                    UserDefaults.standard.set(false, forKey: "Po Descrip")
//                }
//                UserDefaults.standard.set(cost_per, forKey: "cost_per_value")
//                UserDefaults.standard.set(cost_method, forKey: "cost_method")
//            }else{
//                print("Api Error")
//            }
//        })
//    }
//    
//    func refreshCategoryColl() {
//        
//        if prodCategories.count == 0 {
//            cat_coll_height.constant = 53.0
//            self.view.layoutIfNeeded()
//            catColl.isHidden = true
//            categoryField.isHidden = false
//        }
//        else {
//            catColl.isHidden = false
//            categoryField.isHidden = true
//        }
//        if mode == "add" {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//               
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        //edit
//        else {
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//    }
//    
//    func openCat(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
//        
//        print(prodCategories)
//        if mode == "add" {
//            vc.selectCategory = prodCategories
//        }
//        else {
//            vc.selectCategory = prodCategories
//        }
//      //  vc.vc1 = self
//        vc.catMode = "addProductVc"
//        let transition = CATransition()
//        transition.duration = 0.7
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
//    
//    func setUpProductApiId() {
//        
//        ApiCalls.sharedCall.productById(product_id: p_id, merchant_id: m_id) { isSuccess, responseData in
//            
//            if isSuccess {
//                
//                guard let list = responseData["productdata"] else {
//                    return
//                }
//                
//                self.getResponseById(list: list)
//                
//                guard let var_list = responseData["varients"] else {
//                    return
//                }
//                
//                print(var_list)
//                
//                self.getVarients(list: var_list)
//                
//                guard let var_list = responseData["bulk_pricing"] else {
//                    return
//                }
//                
//                self.getBulk(list: var_list)
//                
//                guard let unselect_list = responseData["all_unassigned_vars_array"] else {
//                    return
//                }
//                self.unsel_var_array = unselect_list as! [String]
//                
//                guard let opt_list = responseData["options"] else {
//                    return
//                }
//                print(opt_list)
//                
//                self.getOptions(opt_list: opt_list)
//                
//                
//                guard let cat_list = responseData["coll"] else {
//                    return
//                }
//                
//                self.getCats(cat_list: cat_list)
//                
//                DispatchQueue.main.async {
////                    self.loadingIndicator.isAnimating = false
//                    self.tableview.reloadData()
//                    self.catColl.reloadData()
//                }
//            }else{
//                print("Api Error")
//            }
//        }
//    }
//    
//    func getResponseById(list: Any) {
//        
//        let product = list as! [String: Any]
//        
//        let productEdit = ProductById(alternateName: "\(product["alternateName"] ?? "")", admin_id: "\(product["admin_id"] ?? "")",
//                                      description: "\(product["description"] ?? "")", starting_quantity: "\(product["starting_quantity"] ?? "")",
//                                      margin: "\(product["margin"] ?? "")", brand: "\(product["brand"] ?? "")",
//                                      tags: "\(product["tags"] ?? "")", upc: "\(product["upc"] ?? "")",
//                                      id: "\(product["id"] ?? "")", sku: "\(product["sku"] ?? "")",
//                                      disable: "\(product["disable"] ?? "")", food_stampable: "\(product["food_stampable"] ?? "")", isvarient: "\(product["isvarient"] ?? "")",
//                                      title: "\(product["title"] ?? "")", quantity: "\(product["quantity"] ?? "")",
//                                      ischargeTax: "\(product["ischargeTax"] ?? "")", updated_on: "\(product["updated_on"] ?? "")",
//                                      isstockcontinue: "\(product["isstockcontinue"] ?? "")", trackqnty: "\(product["trackqnty"] ?? "")",
//                                      profit: "\(product["profit"] ?? "")", custom_code: "\(product["custom_code"] ?? "")",
//                                      assigned_vendors: "\(product["assigned_vendors"] ?? "")", barcode: "\(product["barcode"] ?? "")",
//                                      country_region: "\(product["country_region"] ?? "")", ispysical_product: "\(product["ispysical_product"] ?? "")",
//                                      show_status: "\(product["show_status"] ?? "")", HS_code: "\(product["HS_code"] ?? "")",
//                                      price: "\(product["price"] ?? "")", featured_product: "\(product["featured_product"] ?? "")",
//                                      merchant_id: "\(product["merchant_id"] ?? "")", created_on: "\(product["created_on"] ?? "")",
//                                      prefferd_vendor: "\(product["prefferd_vendor"] ?? "")", reorder_cost: "\(product["reorder_cost"] ?? "")",
//                                      other_taxes: "\(product["other_taxes"] ?? "")", buy_with_product: "\(product["buy_with_product"] ?? "")",
//                                      costperItem: "\(product["costperItem"] ?? "")", is_tobacco: "\(product["is_tobacco"] ?? "")",
//                                      product_doc: "\(product["product_doc"] ?? "")", user_id: "\(product["user_id"] ?? "")",
//                                      media: "\(product["media"] ?? "")", compare_price: "\(product["compare_price"] ?? "")",
//                                      loyalty_product_id: "\(product["loyalty_product_id"] ?? "")", show_type: "\(product["show_type"] ?? "")",
//                                      cotegory: "\(product["cotegory"] ?? "")", reorder_level: "\(product["reorder_level"] ?? "")",
//                                      env: "\(product["env"] ?? "")", variant: "", reorder_qty: "\(product["reorder_qty"] ?? "")", purchase_qty: "\(product["purchase_qty"] ?? "")")
//        
//        editProd = productEdit
//        
//        let purQuantity = productEdit.purchase_qty
//        prod_purchaseQty = purQuantity
//        
//        isVarient = editProd?.isvarient ?? ""
//        print(isVarient)
//        let productCat = productEdit.cotegory
//        productId = productCat.components(separatedBy: ",")
//        inflateView(prod: productEdit)
//        let prodTx = productEdit.other_taxes
//        arrTaxId = prodTx.components(separatedBy: ",")
//        if catMode == "back" {
//            setupTaxApi()
//        }
//        tableview.reloadData()
//    }
//    
//    
//    func inflateView(prod: ProductById) {
//        
//        productName.text = prod.title
//        descField.text = prod.description
//    }
//    
//    
//    @IBAction func cat_btn_click(_ sender: UIButton) {
//        openCat()
//    }
//    
//    func getVarients(list: Any) {
//        
//        let variants = list as! [[String: Any]]
//        
//        var small_var = [ProductById]()
//        
//        for vars in variants {
//            
//            let varArr = ProductById(alternateName: "\(vars["alternateName"] ?? "")", admin_id: "\(vars["admin_id"] ?? "")",
//                                     description: "\(vars["description"] ?? "")", starting_quantity: "\(vars["starting_quantity"] ?? "")",
//                                     margin: "\(vars["margin"] ?? "")", brand: "\(vars["brand"] ?? "")",
//                                     tags: "\(vars["tags"] ?? "")", upc: "\(vars["upc"] ?? "")",
//                                     id: "\(vars["id"] ?? "")", sku: "\(vars["sku"] ?? "")",
//                                     disable: "\(vars["disable"] ?? "")", food_stampable: "\(vars["food_stampable"] ?? "")", isvarient: "\(vars["isvarient"] ?? "")",
//                                     title: "\(vars["title"] ?? "")", quantity: "\(vars["quantity"] ?? "")",
//                                     ischargeTax: "\(vars["ischargeTax"] ?? "")", updated_on: "\(vars["updated_on"] ?? "")",
//                                     isstockcontinue: "\(vars["isstockcontinue"] ?? "")", trackqnty: "\(vars["trackqnty"] ?? "")",
//                                     profit: "\(vars["profit"] ?? "")", custom_code: "\(vars["custom_code"] ?? "")",
//                                     assigned_vendors: "\(vars["assigned_vendors"] ?? "")", barcode: "\(vars["barcode"] ?? "")",
//                                     country_region: "\(vars["country_region"] ?? "")", ispysical_product: "\(vars["ispysical_vars"] ?? "")",
//                                     show_status: "\(vars["show_status"] ?? "")", HS_code: "\(vars["HS_code"] ?? "")",
//                                     price: "\(vars["price"] ?? "")", featured_product: "\(vars["featured_vars"] ?? "")",
//                                     merchant_id: "\(vars["merchant_id"] ?? "")", created_on: "\(vars["created_on"] ?? "")",
//                                     prefferd_vendor: "\(vars["prefferd_vendor"] ?? "")", reorder_cost: "\(vars["reorder_cost"] ?? "")",
//                                     other_taxes: "\(vars["other_taxes"] ?? "")", buy_with_product: "\(vars["buy_with_vars"] ?? "")",
//                                     costperItem: "\(vars["costperItem"] ?? "")", is_tobacco: "\(vars["is_tobacco"] ?? "")",
//                                     product_doc: "\(vars["vars_doc"] ?? "")", user_id: "\(vars["user_id"] ?? "")",
//                                     media: "\(vars["media"] ?? "")", compare_price: "\(vars["compare_price"] ?? "")",
//                                     loyalty_product_id: "\(vars["loyalty_vars_id"] ?? "")", show_type: "\(vars["show_type"] ?? "")",
//                                     cotegory: "\(vars["cotegory"] ?? "")", reorder_level: "\(vars["reorder_level"] ?? "")",
//                                     env: "\(vars["env"] ?? "")", variant: "\(vars["variant"] ?? "")", reorder_qty: "\(vars["reorder_qty"] ?? "")", purchase_qty: "\(vars["purchase_qty"] ?? "")")
//            
//            small_var.append(varArr)
//            print(small_var)
//            
////            let varient_purQuantity = varArr.purchase_qty
////            varient_p_qty = varient_purQuantity.components(separatedBy: ",")
////           print(varient_p_qty)
////
//        }
//        variantsArray = small_var
//        
//        
//        print(variantsArray)
//        print(variantsArray.count)
//        
//        if variantsArray.count == 0 {
//            var isSel = [Bool]()
//            isSel.append(true)
//            isSelectedData = isSel
//        }else {
//            var isSel = [Bool]()
//            for i in 0..<variantsArray.count {
//                
//                if i == 0 {
//                    isSel.append(true)
//                }
//                else {
//                    isSel.append(false)
//                }
//            }
//            isSelectedData = isSel
//        }
//        tableview.separatorStyle = .none
//    }
//    
//    func getBulk(list: Any) {
//        
//        let bulk = list as! [[String: Any]]
//        var smallbulk = [BulkPricingModel]()
//
//        for b_pricing in bulk {
//            
//            
//            let bulkname = BulkPricingModel(id: "\(b_pricing["id"] ?? "")", merchant_id: "\(b_pricing["merchant_id"] ?? "")", product_id: "\(b_pricing["product_id"] ?? "")", bulk_price: "\(b_pricing["bulk_price"] ?? "")", bulk_qty: "\(b_pricing["bulk_qty"] ?? "")", bulk_price_title: "\(b_pricing["bulk_price_tittle"] ?? "")", is_percentage: "\(b_pricing["is_percentage"] ?? "")")
//            
//           smallbulk.append(bulkname)
//            print(bulkname)
//        }
//        bulkpricingArr = smallbulk
//        print(bulkpricingArr)
//        if bulkpricingArr.count == 0 {
//            isbulk = false
//        }else{
//            isbulk = true
//        }
//    }
//    
//    
//    func getOptions(opt_list: Any) {
//        
//        
//        let response = opt_list as? [String: Any] ?? [:]
//        if response.count != 0 {
//            var smallres = [InventoryOptions]()
//            let options = InventoryOptions(id: "\(response["id"] ?? "")", product_id: "\(response["product_id"] ?? "")",
//                                           options1: "\(response["options1"] ?? "")", optionsvl1: "\(response["optionsvl1"] ?? "")",
//                                           options2: "\(response["options2"] ?? "")", optionsvl2: "\(response["optionsvl2"] ?? "")",
//                                           options3: "\(response["options3"] ?? "")", optionsvl3: "\(response["optionsvl3"] ?? "")",
//                                           merchant_id: "\(response["merchant_id"] ?? "")", admin_id: "\(response["admin_id"] ?? "")")
//            
//            print(options)
//            
//            if options.options1 != "" {
//                let opt = InventoryOptions(id: options.id, product_id: "", options1: options.options1, optionsvl1: options.optionsvl1, options2: "",
//                                           optionsvl2: "", options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                smallres.append(opt)
//            }
//            if options.options2 != "" {
//                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: options.options2,
//                                           optionsvl2: options.optionsvl2, options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                smallres.append(opt)
//            }
//            if options.options3 != "" {
//                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: "",
//                                           optionsvl2: "", options3: options.options3, optionsvl3: options.optionsvl3, merchant_id: "", admin_id: "")
//                smallres.append(opt)
//            }
//            print(smallres)
//            
//            if editCombo == 1 {
//                for smallre in 0..<smallres.count {
//                    
//                    if smallre == 0 {
//                        smallres[smallre].optionsvl1 = arrOptVl1.joined(separator: ",")
//                    }
//                    
//                    else if smallre == 1 {
//                        smallres[smallre].optionsvl2 = arrOptVl2.joined(separator: ",")
//                    }
//                    
//                    else {
//                        smallres[smallre].optionsvl3 = arrOptVl3.joined(separator: ",")
//                    }
//                    
//                }
//            }
//            productOptions = smallres
//            print(productOptions)
//        }
//        attTableHeight.constant = CGFloat(73 * productOptions.count)
//        attTable.reloadData()
//    }
//    
//    
//    
//    
//    func getCats(cat_list: Any) {
//        
//        
//        let response = cat_list as! [[String:Any]]
//        var smallres = [InventoryCategory]()
//        
//        for res in response {
//            
//            let category = InventoryCategory(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
//                                             description: "\(res["description"] ?? "")", categoryBanner: "\(res["categoryBanner"] ?? "")",
//                                             show_online: "\(res["show_online"] ?? "")", show_status: "\(res["show_status"] ?? "")",
//                                             cat_show_status: "\(res["cat_show_status"] ?? "")", alternateName: "\(res["alternateName"] ?? "")",
//                                             merchant_id: "\(res["merchant_id"] ?? "")", is_deleted: "\(res["is_deleted"] ?? "")",
//                                             user_id: "\(res["user_id"] ?? "")", created_on: "\(res["created_on"] ?? "")",
//                                             updated_on: "\(res["updated_on"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
//                                             use_point: "\(res["use_point"] ?? "")", earn_point: "\(res["earn_point"] ?? "")")
//            
//            smallres.append(category)
//        }
//        
//        if catMode == "back" {
//            prodCategories = smallres
//            var prod = [InventoryCategory]()
//            for cat in prodCategories {
//                
//                if productId.contains(cat.id) {
//                    prod.append(cat)
//                }
//            }
//            
//            prodCategories = prod
//        }
//        
//        else {
//            if closeClick == "false" {
//                prodCategories = catsAddArr
//            }
//        }
//        
//        if prodCategories.count == 0 {
//            catColl.isHidden = true
//            categoryField.isHidden = false
//        }
//        else {
//            catColl.isHidden = false
//            categoryField.isHidden = true
//        }
//        print(cat_coll_height.constant)
//        
//        DispatchQueue.main.async {
//            self.catColl.reloadData()
//           // self.setcollectionHeight()
//        }
//        
//        if variantsArray.count == 0 {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        else if variantsArray.count == 1 {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                    
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        else {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//    }
//    
//    
//    func setupTaxApi() {
//        
//        ApiCalls.sharedCall.productTaxList(merchant_id: m_id) { isSuccess, responseData in
//            
//            if isSuccess {
//                
//                guard let list = responseData["result"] else {
//                    return
//                }
//                guard let list_status = responseData["status"], list_status as! Int != 0 else {
//                    return
//                }
//                
//                print(list)
//                self.getResponseTaxes(list: list)
//            }else{
//                print("Api Error")
//            }
//        }
//    }
//    
//    func getResponseTaxes(list: Any) {
//        
//        let response = list as! [[String:Any]]
//        var first = 0
//        var taxArray = [SetupTaxes]()
//        for res in response {
//            
//            let setTax = SetupTaxes(alternateName: "\(res["alternateName"] ?? "")",
//                                    created_on: "\(res["created_on"] ?? "")",
//                                    displayname: "\(res["displayname"] ?? "")",
//                                    id: "\(res["id"] ?? "")",
//                                    merchant_id: "\(res["merchant_id"] ?? "")",
//                                    percent: "\(res["percent"] ?? "")",
//                                    title: "\(res["title"] ?? "")",
//                                    user_id: "\(res["user_id"] ?? "")")
//            if first != 0 {
//                taxArray.append(setTax)
//            }
//            first += 1
//            print(setTax)
//        }
//        arrTax = taxArray
//        print(arrTax)
//        
//        var taxName = [String]()
//        
//        for tax in arrTax {
//            taxName.append(tax.title)
//        }
//        
//        arrTaxNames = taxName
//        
//        
//        if mode == "edit" {
//            
//            var taxempty = [SetupTaxes]()
//            for tax in arrTax {
//                
//                if arrTaxId.contains(tax.id) {
//                    taxempty.append(tax)
//                }
//            }
//            collArrTax = taxempty
//        }
//        else {
//            var addDef = [SetupTaxes]()
//            addDef.append(arrTax[0])
//            collArrTax = addDef
//        }
//        tax_collection.reloadData()
//        
//        setupDrop()
//        
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        
//        if segue.identifier ==  "toAddVarAttri" {
//            
//            let vc = segue.destination as! AddVariantAttributeViewController
//
//            if mode == "add" {
//                if goMode == "addBtn" {
//                    vc.mode = mode
//                    vc.goMode = goMode
//                    if productOptions.count == 0 {
//                        vc.selectedAtt = []
//                    }
//                    else {
//                        vc.selectedAtt = productOptions
//                    }
//                }
//                else {
//                    vc.mode = mode
//                    vc.options = inventoryOpt
//                    vc.goMode = goMode
//                }
//            }
//            //edit
//            else {
//                vc.mode = mode
//                vc.options = inventoryOpt
//            }
//            //vc.vc = self
//        }
//        
//        else if segue.identifier == "toSalesVc" {
//            
//            let vc = segue.destination as! SalesHistoryViewController
//            
//            vc.salesProd_id = p_id
//            vc.salesVar_id  = vari_id
//            vc.salesVar_name = varname
//        }
//        
//        else if segue.identifier == "toAddBulk" {
//            
//            let vc = segue.destination as! AddBulkPricingViewController
//            if variantsArray.count == 0 {
//                vc.prod_title = productName.text ?? ""
//            }else {
//                vc.varientArr = variantsArray
//            }
//            vc.prod_id = p_id
//            vc.arrofBulk = bulkpricingArr
//           vc.addUnselect = unsel_var_array
//        }
//        
//        else if segue.identifier == "toAddPurchase" {
//            
//            let vc = segue.destination as! AddPurchaseQtyViewController
//            if variantsArray.count == 0 {
//                vc.singleProd = productName.text ?? ""
//                vc.product_PurchaseQty = prod_purchaseQty
//            }
//            else {
//                vc.varientArr = variantsArray
//            }
//            vc.is_Varient = isVarient
//            vc.prod_id = p_id
//            
//        }
//        
//        else {
//            
//            let vc = segue.destination as! DuplicateViewController
//            
//            vc.duplicateProdCat = prodCategories
//            vc.duplicateProdOptions = productOptions
//            vc.duplicateTaxes = collArrTax
//            vc.catMode = "back"
//            
//            if variantsArray.count == 0 {
//                editProd?.upc = ""
//                vc.singleProd = editProd
//            }
//            else {
//                
//                for i in 0..<variantsArray.count {
//                    variantsArray[i].upc = ""
//                }
//                vc.duplicateVariants = variantsArray
//            }
//        }
//    }
//    
//    func setupDrop() {
//        
//        menu.dataSource = arrTaxNames
//        menu.backgroundColor = .white
//        menu.anchorView = tax_collection
//        menu.separatorColor = .black
//        menu.layer.cornerRadius = 10.0
//        menu.selectionAction = { index, title in
//            
//            if self.collArrTax.count == 0 {
//                self.collArrTax.append(self.arrTax[index])
//                self.menu.deselectRow(at: index)
//            }
//            else {
//                if self.collArrTax.contains(where: {$0.id == self.arrTax[index].id}) {
//                    self.menu.deselectRow(at: index)
//                }
//                else {
//                    self.collArrTax.append(self.arrTax[index])
//                    self.menu.deselectRow(at: index)
//                }
//            }
//            self.tax_collection.reloadData()
//        }
//    }
//    
//    @objc func openDrop() {
//        
//        menu.show()
//       // addTransparentView(frames: tax_collection.frame)
//    }
//   
//    func data(optName :String, optValue: String, editele: [String]) {
//        
//        if mode == "add" {
//            
//            if goMode == "addBtn" {
//                
//                if addattrIndex == 0 {
//                    let opt = InventoryOptions(id: "", product_id: "", options1: optName, optionsvl1: optValue, options2: "",
//                                               optionsvl2: "", options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                    productOptions.append(opt)
//                    
//                    arrOptVl1 = optValue.components(separatedBy: ",")
//                }
//                
//                else if addattrIndex == 1 {
//                    let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: optName,
//                                               optionsvl2: optValue, options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                    productOptions.append(opt)
//                    arrOptVl2 = optValue.components(separatedBy: ",")
//                }
//                
//                else if addattrIndex == 2 {
//                    let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: "", optionsvl2: "",
//                                               options3: optName, optionsvl3: optValue, merchant_id: "", admin_id: "")
//                    
//                    productOptions.append(opt)
//                    arrOptVl3 = optValue.components(separatedBy: ",")
//                    addAttribute.isHidden = true
//                    addAttriBtnHeight.constant = 0
//                }
//                
//                else {
//                    addAttribute.isHidden = true
//                    addAttriBtnHeight.constant = 0
//                }
//            }
//            
//            else {
//                //cellclick
//                
//                if addattrIndex == 0 {
//                    productOptions[addattrIndex].optionsvl1 = optValue
//                    arrOptVl1 = optValue.components(separatedBy: ",")
//                }
//                
//                else if addattrIndex == 1 {
//                    productOptions[addattrIndex].optionsvl2 = optValue
//                    arrOptVl2 = optValue.components(separatedBy: ",")
//                }
//                
//                else if addattrIndex == 2 {
//                    productOptions[addattrIndex].optionsvl3 = optValue
//                    arrOptVl3 = optValue.components(separatedBy: ",")
//                }
//            }
//            
//            addCombo = 1
//        }
//        
//        else {
//            
//            if addattrIndex == 0 {
//                productOptions[addattrIndex].optionsvl1 = optValue
//                print(productOptions)
//                arrOptVl1 = optValue.components(separatedBy: ",")
//                
//                for ele in editele {
//                    newEditAtt.append(ele)
//                }
//            }
//            
//            else if addattrIndex == 1 {
//                productOptions[addattrIndex].optionsvl2 = optValue
//                print(productOptions)
//                arrOptVl2 = optValue.components(separatedBy: ",")
//                
//                for ele in editele {
//                    newEditAtt.append(ele)
//                }
//            }
//            
//            else if addattrIndex == 2 {
//                productOptions[addattrIndex].optionsvl3 = optValue
//                print(productOptions)
//                arrOptVl3 = optValue.components(separatedBy: ",")
//                
//                for ele in editele {
//                    newEditAtt.append(ele)
//                }
//            }
//            
//            editCombo = 1
//        }
//        
//        print(productOptions.count)
//        print(productOptions)
//        print(arrOptVl1)
//        print(arrOptVl2)
//        print(arrOptVl3)
//        
//        attTableHeight.constant = CGFloat(73 * productOptions.count)
//        
//        if mode == "add" {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant = 1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant = 1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        
//        // edit
//        else {
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                }
//                
//                else {
//                    
//                    scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    tax_coll_height.constant + 10
//                }
//                
//                else {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//        attTable.reloadData()
//    }
//    
// 
//    @IBAction func addVariAttributeClick(_ sender: UIButton) {
//        goMode = "addBtn"
//        attNameArray = productOptions
//        addattrIndex = productOptions.count
//        performSegue(withIdentifier: "toAddVarAttri", sender: nil)
//    }
//    
//    
//    @IBAction func salesHistoryBtn(_ sender: UIButton) {
//        
//        if variantsArray.count == 0 {
//            vari_id = ""
//            varname = editProd?.title ?? ""
//            
//        }else {
//            vari_id = variantsArray[sender.tag].id
//            varname = variantsArray[sender.tag].variant
//            
//        }
//        performSegue(withIdentifier: "toSalesVc", sender: nil)
//    }
//    
//    
//    @IBAction func instantPOBtnClick(_ sender: UIButton) {
//        
//        print(sender.tag)
//        
//        UserDefaults.standard.set("prod", forKey: "toInstantPO")
//        
//        if UserDefaults.standard.bool(forKey: "Po Descrip"){
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "podesc") as! InstantPODescViewController
//            if variantsArray.count == 0 {
//                vc.ipoVari_id = ""
//            }
//            else {
//                vc.ipoVari_id = variantsArray[sender.tag].id
//            }
//            vc.ipoProd_id = p_id
//            
//            let transition = CATransition()
//            transition.duration = 0.7
//            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
//            self.navigationController?.view.layer.add(transition, forKey: nil)
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
//        else {
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "quantity") as! POQuantityViewController
//            if variantsArray.count == 0 {
//                vc.ipoVari_id = ""
//            }
//            else {
//                vc.ipoVari_id = variantsArray[sender.tag].id
//            }
//            vc.ipoProd_id = p_id
//        
//            let transition = CATransition()
//            transition.duration = 0.7
//            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
//            self.navigationController?.view.layer.add(transition, forKey: nil)
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
//    }
//    
//    
//    @IBAction func threeDotsClick(_ sender: UIButton) {
//        
//        
////        if isbulk {
//////            bulkTitleLbl.text = "Bulk Pricing"
////        }else
////        {
//////            bulkTitleLbl.text = "Add Bulk Pricing"
////        }
//        
//        if upperView.isHidden {
//            upperView.isHidden = false
//        }
//        
//        else {
//            upperView.isHidden = true
//        }
//    
//        dupView.layer.cornerRadius = 10
//        dupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        maxView.layer.cornerRadius = 10
//        maxView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        upperView.layer.cornerRadius = 10
//        upperView.layer.shadowColor =  UIColor.lightGray.cgColor
//        upperView.layer.shadowOpacity = 1
//        upperView.layer.shadowRadius = 3
//        upperView.layer.shadowOffset = CGSize.zero
//    }
//    
//    
//    
//    @IBAction func backBtnClick(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    
//    @IBAction func trackQtyClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            
//            if variantsArray.count == 0 {
//                editProd?.trackqnty = "1"
//            }
//            else {
//                variantsArray[sender.tag].trackqnty = "1"
//            }
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.trackqnty = "0"
//            }
//            else {
//                variantsArray[sender.tag].trackqnty = "0"
//            }
//        }
//        
//    }
//    
//    
//    @IBAction func sellingClick(_ sender: UIButton) {
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.isstockcontinue = "1"
//            }
//            else {
//                variantsArray[sender.tag].isstockcontinue = "1"
//            }
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.isstockcontinue = "0"
//            }
//            else {
//                variantsArray[sender.tag].isstockcontinue = "0"
//            }
//        }
//        
//    }
//    
//    
//    @IBAction func checkidClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.is_tobacco = "1"
//            }
//            else {
//                variantsArray[sender.tag].is_tobacco = "1"
//            }
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.is_tobacco = "0"
//            }
//            else {
//                variantsArray[sender.tag].is_tobacco = "0"
//            }
//        }
//        
//    }
//    
//    
//    @IBAction func disableClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.disable = "1"
//            }
//            else {
//                variantsArray[sender.tag].disable = "1"
//            }
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.disable = "0"
//            }
//            else {
//                variantsArray[sender.tag].disable = "0"
//            }
//        }
//        
//    }
//    
//    @IBAction func foodStampableClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.food_stampable = "1"
//            }
//            else {
//                variantsArray[sender.tag].food_stampable = "1"
//            }
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            if variantsArray.count == 0 {
//                editProd?.food_stampable = "0"
//            }
//            else {
//                variantsArray[sender.tag].food_stampable = "0"
//            }
//        }
//        
//    }
//    
//    @IBAction func taxCloseBtn(_ sender: UIButton) {
//        
//        let position = sender.tag
//        collArrTax.remove(at: position)
//        tax_collection.reloadData()
//        
//    }
//    
//    
//    
//    
//    @IBAction func categoryCloseClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "white close"){
//            let position = sender.tag
//            prodCategories.remove(at: position)
//            if prodCategories.count == 0 {
//                refreshCategoryColl()
//            }
//            else {
//                
//                if mode == "add" {
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                        }
//                    }
//                }
//                
//                else {
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            scrollHeight.constant = 1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                        }
//                    }
//                }
//                catColl.reloadData()
//            }
//        }else {
//            openCat()
//        }
//        
//    }
//
//    
//    
//    
//    @IBAction func saveBtnClick(_ sender: UIButton) {
//        
//        if saveBtn.currentTitle == "Add" {
//            tableview.reloadData()
//            validateAddParams()
//            
//        }
//        
//        else {
//            tableview.reloadData()
//            validateEditParams()
//
//        }
//                
//    }
//    
//    @IBAction func CancelbtnClick(_ sender: UIButton) {
//        
//       navigationController?.popViewController(animated: true)
//    }
//    
//    func validateAddParams() {
//        
//        
//        guard let name = productName.text, name != "" else {
//            productName.isError(numberOfShakes: 3, revert: true)
//            showToastMedium(message: " Enter product name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            return
//        }
//        
//        let desc = descField.text ?? ""
//        
//        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
//        
//        var prod = AddProduct(merchant_id: m_id, title: name, description: desc, price: "", compare_price: "",
//                              costperItem: "", margin: "", profit: "", ischargeTax: "", trackqnty: "",
//                              isstockcontinue: "", quantity: "", collection: "", isvarient: "", created_on: "", optionid: "",
//                              optionarray: "", optionarray1: "", optionarray2: "",
//                              optionvalue: "", optionvalue1: "", optionvalue2: "",
//                              other_taxes: "", bought_product: "", featured_product: "", varid: "",
//                              varvarient: "", varprice: "", varcompareprice: "", varcostperitem: "",
//                              varquantity: "", upc: "", custom_code: "", reorder_qty: "", reorder_level: "",
//                              reorder_cost: "", is_tobacco: "", disable: "", food_stampable: "", varupc: "", varcustomcode: "",
//                              vartrackqnty: "", varcontinue_selling: "", varcheckid: "", vardisable: "", varfood_stampable: "",
//                              varmargin: "", varprofit: "", varreorder_qty: "", varreorder_level: "", varreorder_cost: "")
//        
//        guard prodCategories.count != 0 else {
//            categoryField.isErrorView(numberOfShakes: 3, revert: true)
//            showToastMedium(message: " Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            return
//        }
//        
//        var small = [String]()
//        for cat in prodCategories {
//            small.append(cat.id)
//        }
//        
//        var smalltax = [String]()
//        for tax in collArrTax {
//            smalltax.append(tax.id)
//        }
//        
//        prod.collection = small.joined(separator: ",")
//        
//        if smalltax.count == 0  {
//            prod.other_taxes = ""
//            prod.ischargeTax = "0"
//        }
//        else {
//            prod.other_taxes = smalltax.joined(separator: ",")
//            prod.ischargeTax = "1"
//        }
//        
//        if productOptions.count == 0 {
//            prod.isvarient = "0"
//            
//            let index = IndexPath(row: 0, section: 0)
//            let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//            
//            let costperitem = variantsArray[0].costperItem
//            prod.costperItem = costperitem
//            
//            guard let price = variantsArray[0].price, price != "", price != "0.00" else {
//                cell.price.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.price = price
//            
//            let c_price = prod.price
//            let c_compareprice = variantsArray[0].compare_price
//            print(c_compareprice)
//            
//            if c_compareprice != "" && c_compareprice != "0.00" {
//                
//                let newCompareprice = Double(c_compareprice)!
//                let newPrice = Double(c_price)!
//                
//                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                    showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.comparePrice.isError(numberOfShakes: 3, revert: true)
//                    
//                    return
//                }
//            }
//            
//            prod.compare_price = c_compareprice
//            prod.margin = variantsArray[0].margin
//            prod.profit = variantsArray[0].profit
//            
//            guard let quant = variantsArray[0].quantity, quant != "" else {
//                cell.qty.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.quantity = quant
//            prod.custom_code = variantsArray[0].custom_code
//            
//            guard let upc_code = variantsArray[0].upc, upc_code != "" else {
//                cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.upc = upc_code
//            
//            if variantsArray[0].reorder_qty == "" {
//                prod.reorder_qty = "0"
//            }
//            else{
//                prod.reorder_qty = variantsArray[0].reorder_qty
//            }
//            
//            if variantsArray[0].reorder_level == "" {
//                prod.reorder_level = "0"
//            }
//            else{
//                prod.reorder_level = variantsArray[0].reorder_level
//            }
//            
//            
//            
//            prod.trackqnty = variantsArray[0].trackqnty
//            prod.isstockcontinue = variantsArray[0].isstockcontinue
//            prod.is_tobacco = variantsArray[0].is_tobacco
//            prod.disable = variantsArray[0].disable
//            prod.food_stampable = variantsArray[0].food_stampable
//            
//            loadIndicator.isAnimating = true
//            print(prod)
//            print(prod)
//            
//            saveBtn.isEnabled = false
//            
//            ApiCalls.sharedCall.productAddCall(id: prod.merchant_id, title: prod.title, description: prod.description,
//                                               price: prod.price, compare_price: prod.compare_price,
//                                               costperItem: prod.costperItem, margin: prod.margin,
//                                               profit: prod.profit, ischargeTax: prod.ischargeTax,
//                                               trackqnty: prod.trackqnty, isstockcontinue: prod.isstockcontinue,
//                                               quantity: prod.quantity, collection: prod.collection, isvarient: "0",
//                                               created_on: "", optionarray: "", optionarray1: "", optionarray2: "",
//                                               optionvalue: "", optionvalue1: "", optionvalue2: "",
//                                               other_taxes: prod.other_taxes, bought_product: "",
//                                               featured_product: "", varvarient: "", varprice: "",
//                                               varcompareprice: "", varcostperitem: "", varquantity: "",
//                                               upc: prod.upc, custom_code: prod.custom_code, reorder_qty: prod.reorder_qty,
//                                               reorder_level: prod.reorder_level, reorder_cost: "", is_tobacco: prod.is_tobacco,
//                                               disable: prod.disable, food_stampable: prod.food_stampable, varupc: "", varcustomcode: "",
//                                               vartrackqnty: "", varcontinue_selling: "", varcheckid: "",
//                                               vardisable: "", varfood_stampable: "", varmargin: "", varprofit: "", varreorder_qty: "",
//                                               varreorder_level: "", varreorder_cost: "") { isSuccess, responseData in
//                
//                if isSuccess {
//                    
//                    if let list = responseData["message"] as? String {
//                        print(list)
//                        if list == "Success" {
//                            self.showToastLarge(message: " Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                self.loadIndicator.isAnimating = false
//                                self.navigationController?.popViewController(animated: true)
//                                self.saveBtn.isEnabled = true
//                            }
//                        }
//                        else{
//                            self.showToastLarge(message: " Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            self.loadIndicator.isAnimating = false
//                            self.saveBtn.isEnabled = true
//                        }
//                    }
//                }
//                else {
//                    
//                }
//            }
//        }
//        
//        else {
//            
//            prod.isvarient = "1"
//            
//            var cost_item_arr = [String]()
//            var price_arr = [String]()
//            var compare_arr = [String]()
//            var margin_arr = [String]()
//            var profit_arr = [String]()
//            var quantity_arr = [String]()
//            var custom_arr = [String]()
//            var upc_arr = [String]()
//            
//            var track_arr = [String]()
//            var sell_arr = [String]()
//            var check_arr = [String]()
//            var disable_arr = [String]()
//            var foodStamp_arr = [String]()
//            
//            var reorderQty_arr = [String]()
//            var reorderLevel_arr = [String]()
//           
//            
//            
//            var v_variant_arr = [String]()
//            
//            for product in 0..<variantsArray.count {
//                
//                let costperitem = variantsArray[product].costperItem
//                cost_item_arr.append(costperitem)
//                
//                guard let price = variantsArray[product].price, price != "", price != "0.00" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    cell.price.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                price_arr.append(price)
//                
//                let c_price = price
//                let c_compareprice = variantsArray[product].compare_price
//
//                if c_compareprice != "" && c_compareprice != "0.00" {
//                    
//                    let newCompareprice = Double(c_compareprice)!
//                    let newPrice = Double(c_price)!
//                    
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                        showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                        cell.comparePrice.isError(numberOfShakes: 3, revert: true)
//                        
//                        return
//                    }
//                }
//                
//                compare_arr.append(c_compareprice)
//                margin_arr.append(variantsArray[product].margin)
//                profit_arr.append(variantsArray[product].profit)
//                
//                guard let quant = variantsArray[product].quantity, quant != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    cell.qty.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                
//                quantity_arr.append(quant)
//                custom_arr.append(variantsArray[product].custom_code)
//                
//                guard let upcCode = variantsArray[product].upc, upcCode != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                    return
//                }
//                upc_arr.append(upcCode)
////                v_variant_arr.append(result[product])
//                
//                track_arr.append(variantsArray[product].trackqnty)
//                sell_arr.append(variantsArray[product].isstockcontinue)
//                check_arr.append(variantsArray[product].is_tobacco)
//                disable_arr.append(variantsArray[product].disable)
//                foodStamp_arr.append(variantsArray[product].food_stampable)
//                
//                reorderQty_arr.append(variantsArray[product].reorder_qty)
//                reorderLevel_arr.append(variantsArray[product].reorder_level)
//            }
//            
//            if result.count == 0 {
//                
//                if productOptions.count == 3 {
//                    v_variant_arr.append("\(productOptions[0].optionsvl1)/\(productOptions[1].optionsvl2)/\(productOptions[2].optionsvl3)")
//                }
//                else if productOptions.count == 2 {
//                    v_variant_arr.append("\(productOptions[0].optionsvl1)/\(productOptions[1].optionsvl2)")
//                }
//                else {
//                    v_variant_arr.append("\(productOptions[0].optionsvl1)")
//                }
//            }
//            else {
//                v_variant_arr = result
//            }
//            prod.varvarient = v_variant_arr.joined(separator: ",")
//            
//            prod.varcostperitem = cost_item_arr.joined(separator: ",")
//            prod.varprice = price_arr.joined(separator: ",")
//            prod.varcompareprice = compare_arr.joined(separator: ",")
//            prod.varmargin = margin_arr.joined(separator: ",")
//            prod.varupc = upc_arr.joined(separator: ",")
//            prod.varprofit = profit_arr.joined(separator: ",")
//            prod.varcustomcode = custom_arr.joined(separator: ",")
//            prod.varquantity = quantity_arr.joined(separator: ",")
//            
//            prod.varreorder_qty = reorderQty_arr.joined(separator: ",")
//            prod.varreorder_level = reorderLevel_arr.joined(separator: ",")
//
//            
//            prod.vartrackqnty = track_arr.joined(separator: ",")
//            prod.varcontinue_selling = sell_arr.joined(separator: ",")
//            prod.varcheckid = check_arr.joined(separator: ",")
//            prod.vardisable = disable_arr.joined(separator: ",")
//            prod.varfood_stampable = foodStamp_arr.joined(separator: ",")
//            
//            
//            
//            
//            print(productOptions)
//            print(productOptions.count)
//            
//            if productOptions.count > 0 {
//                
//                for opt in 0..<productOptions.count {
//                    
//                    if opt == 0 {
//                        prod.optionarray = productOptions[opt].options1
//                        prod.optionvalue = productOptions[opt].optionsvl1
//                    }
//                    
//                    else if opt == 1 {
//                        prod.optionarray1 = productOptions[opt].options2
//                        prod.optionvalue1 = productOptions[opt].optionsvl2
//                    }
//                    
//                    else {
//                        prod.optionarray2 = productOptions[opt].options3
//                        prod.optionvalue2 = productOptions[opt].optionsvl3
//                    }
//                }
//            }
//            
//            
//            print(prod)
//            print(prod)
//            loadIndicator.isAnimating = true
//            saveBtn.isEnabled = false
//            
//            ApiCalls.sharedCall.productAddCall(id: prod.merchant_id, title: prod.title, description: prod.description,
//                                               price: "", compare_price: "", costperItem: "", margin: "",
//                                               profit: "", ischargeTax: prod.ischargeTax, trackqnty: "",
//                                               isstockcontinue: "", quantity: "", collection: prod.collection,
//                                               isvarient: prod.isvarient, created_on: "",
//                                               optionarray: prod.optionarray, optionarray1: prod.optionarray1,
//                                               optionarray2: prod.optionarray2, optionvalue: prod.optionvalue,
//                                               optionvalue1: prod.optionvalue1, optionvalue2: prod.optionvalue2,
//                                               other_taxes: prod.other_taxes, bought_product: "",
//                                               featured_product: "", varvarient: prod.varvarient,
//                                               varprice: prod.varprice, varcompareprice: prod.varcompareprice,
//                                               varcostperitem: prod.varcostperitem, varquantity: prod.varquantity,
//                                               upc: "", custom_code: "", reorder_qty: "", reorder_level: "",
//                                               reorder_cost: "", is_tobacco: "", disable: "", food_stampable: "",
//                                               varupc: prod.varupc,
//                                               varcustomcode: prod.varcustomcode, vartrackqnty: prod.vartrackqnty,
//                                               varcontinue_selling: prod.varcontinue_selling, varcheckid: prod.varcheckid,
//                                               vardisable: prod.vardisable, varfood_stampable: prod.varfood_stampable,
//                                               varmargin: prod.varmargin,
//                                               varprofit: prod.varprofit, varreorder_qty: prod.varreorder_qty,
//                                               varreorder_level: prod.varreorder_level, varreorder_cost: "") { isSuccess, responseData in
//                
//                if isSuccess {
//                    
//                    if let list = responseData["message"] as? String {
//                        print(list)
//                        if list == "Success" {
//                            self.showToastLarge(message: " Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                self.navigationController?.popViewController(animated: true)
//                                self.saveBtn.isEnabled = true
//                            }
//                        }
//                        else{
//                            self.showToastMedium(message: " Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            self.saveBtn.isEnabled = true
//                        }
//                    }
//                }
//                else {
//                    
//                }
//            }
//        }
//    }
//    
//    func validateEditParams() {
//        
//        guard let name = productName.text, name != "" else {
//            productName.isError(numberOfShakes: 3, revert: true)
//            
//            return
//        }
//        let desc = descField.text ?? ""
//        
//        var prod = AddProduct(merchant_id: m_id, title: name, description: desc, price: "", compare_price: "", costperItem: "", margin: "", profit: "", ischargeTax: "", trackqnty: "", isstockcontinue: "", quantity: "", collection: "", isvarient: "", created_on: "", optionid: "", optionarray: "", optionarray1: "", optionarray2: "", optionvalue: "", optionvalue1: "", optionvalue2: "", other_taxes: "", bought_product: "", featured_product: "", varid: "", varvarient: "", varprice: "", varcompareprice: "", varcostperitem: "", varquantity: "", upc: "", custom_code: "", reorder_qty: "", reorder_level: "", reorder_cost: "", is_tobacco: "", disable: "", food_stampable: "", varupc: "", varcustomcode: "", vartrackqnty: "", varcontinue_selling: "", varcheckid: "", vardisable: "", varfood_stampable: "", varmargin: "", varprofit: "", varreorder_qty: "", varreorder_level: "", varreorder_cost: "")
//        
//        
//        guard prodCategories.count != 0 else{
//            categoryField.isErrorView(numberOfShakes: 3, revert: true)
//            showToastMedium(message: " Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            return
//        }
//        
//        var small = [String]()
//        for cat in prodCategories {
//            small.append(cat.id)
//        }
//        var smalltax = [String]()
//        for tax in collArrTax {
//            smalltax.append(tax.id)
//        }
//        
//        prod.collection = small.joined(separator: ",")
//        
//        if smalltax.count == 0  {
//            prod.other_taxes = ""
//            prod.ischargeTax = "0"
//        }
//        else {
//            prod.other_taxes = smalltax.joined(separator: ",")
//            prod.ischargeTax = "1"
//        }
//        
//        print(smalltax)
//        print(prod.other_taxes)
//        
//        var cost_item_arr = [String]()
//        var price_arr = [String]()
//        var compare_arr = [String]()
//        var margin_arr = [String]()
//        var profit_arr = [String]()
//        var quantity_arr = [String]()
//        var custom_arr = [String]()
//        var upc_arr = [String]()
//        
//        var track_arr = [String]()
//        var sell_arr = [String]()
//        var check_arr = [String]()
//        var disable_arr = [String]()
//        var foodStamp_arr = [String]()
//        
//        var reorderQty_arr = [String]()
//        var reorderLevel_arr = [String]()
//        
//        var v_id_arr = [String]()
//        var v_variant_arr = [String]()
//        
//        if variantsArray.count == 0 {
//            
//            let index = IndexPath(row: 0, section: 0)
//            let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//            
//            let costperitem = cell.costPerItem.text ?? ""
//            prod.costperItem = costperitem
//            
//            guard let price = cell.price.text, price != "", price != "0.00" else {
//                cell.price.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            prod.price = price
//            
//            let c_price = prod.price
//            let c_compareprice = cell.comparePrice.text ?? ""
//            
//            if c_compareprice != "" && c_compareprice != "0.00" {
//                
//                let newCompareprice = Double(c_compareprice)!
//                let newPrice = Double(c_price)!
//                
//                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                    showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.comparePrice.isError(numberOfShakes: 3, revert: true)
//                    
//                    return
//                }
//            }
//            prod.compare_price = c_compareprice
//            prod.margin = cell.margin.text ?? ""
//            prod.profit = cell.profit.text ?? ""
//            
//            guard let quant = cell.qty.text, quant != "" else {
//                cell.qty.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            
//            guard let upcCode = cell.upcCode.text, upcCode != "" else {
//                cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            let custom_code = cell.customCode.text ?? ""
//            
//            let track_qty = editProd?.trackqnty ?? ""
//            let stock = editProd?.isstockcontinue ?? ""
//            let is_tobacco = editProd?.is_tobacco ?? ""
//            let disable = editProd?.disable ?? ""
//            let food_stampable = editProd?.food_stampable ?? ""
//            
//            let reorder_qty = cell.reorderQty.text ?? ""
//            let reorder_level = cell.reorderLevel.text ?? ""
//            
//            
//            if reorder_qty == "" {
//                prod.reorder_qty = "0"
//            }
//            else{
//                prod.reorder_qty = reorder_qty
//            }
//            
//            if reorder_level == "" {
//                prod.reorder_level = "0"
//            }
//            else{
//                prod.reorder_level = reorder_level
//            }
//            
//            let prod_id = editProd?.id ?? ""
//            
//            let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
//            
//            print(editProd!)
//            loadIndicator.isAnimating = true
//            saveBtn.isEnabled = false
//            
//            ApiCalls.sharedCall.productEditCall(merchant_id: m_id, admin_id: "", title: name,
//                                                alternateName: "",
//                                                description: desc, price: prod.price,
//                                                compare_price: prod.compare_price, costperItem: prod.costperItem,
//                                                margin: prod.margin, profit: prod.profit, ischargeTax: prod.ischargeTax,
//                                                sku: "", upc: upcCode, custom_code: custom_code,
//                                                barcode: "", trackqnty: track_qty, isstockcontinue: stock,
//                                                quantity: quant, ispysical_product: "", country_region: "",
//                                                collection: prod.collection, HS_code: "", isvarient: "0",
//                                                multiplefiles: "", img_color_lbl: "", created_on: "",
//                                                productid: prod_id, optionarray: "", optionarray1: "",
//                                                optionarray2: "", optionvalue: "",
//                                                optionvalue1: "", optionvalue2: "",
//                                                other_taxes: prod.other_taxes , bought_product: "",
//                                                featured_product: "", varvarient: "",
//                                                varprice: "", varquantity: "", varsku: "", varbarcode: "",
//                                                files: "", doc_file: "", optionid: "",
//                                                varupc: "", varcustomcode: "", reorder_qty: prod.reorder_qty,
//                                                reorder_level: prod.reorder_level,
//                                                reorder_cost: "", is_tobacco: is_tobacco, disable: disable,
//                                                food_stampable: food_stampable,
//                                                vartrackqnty: "", varcontinue_selling: "", varcheckid: "",
//                                                vardisable: "", varfood_stampable: "", varmargin: "", varprofit: "",
//                                                varreorder_qty: "", varreorder_level: "", varreorder_cost: "",
//                                                varcostperitem: "", varcompareprice: "", var_id: "")
//            { isSuccess, responseData in
//                
//                if isSuccess {
//                    self.showToastLarge(message: " Product updated successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.loadIndicator.isAnimating = false
//                        self.saveBtn.isEnabled = true
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    
//                }
//                else {
//                    self.saveBtn.isEnabled = true
//                }
//            }
//        }
//        
//        else {
//            
//            for product in 0..<variantsArray.count {
//                
//                
//                let costperitem = variantsArray[product].costperItem
//                cost_item_arr.append(costperitem)
//                
//                guard let price = variantsArray[product].price, price != "", price != "0.00" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    cell.price.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                
//                price_arr.append(price)
//                
//                let c_price = price
//                let c_compareprice = variantsArray[product].compare_price
//                
//                if c_compareprice != "" && c_compareprice != "0.00"{
//                    
//                    let newCompareprice = Double(c_compareprice)!
//                    let newPrice = Double(c_price)!
//                    
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                        showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                        cell.comparePrice.isError(numberOfShakes: 3, revert: true)
//                        
//                        return
//                    }
//                }
//                
//                compare_arr.append(c_compareprice)
//                
//                margin_arr.append(variantsArray[product].margin)
//                profit_arr.append(variantsArray[product].profit)
//                
//                guard let quant = variantsArray[product].quantity, quant != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    cell.qty.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Please enter quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                quantity_arr.append(quant)
//                custom_arr.append(variantsArray[product].custom_code)
//                
//                guard let upcCode = variantsArray[product].upc, upcCode != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                upc_arr.append(upcCode)
//                
//                v_id_arr.append(variantsArray[product].id)
//                if result.count == 0 {
//                    v_variant_arr.append(variantsArray[product].variant)
//                }
//                
//                track_arr.append(variantsArray[product].trackqnty)
//                sell_arr.append(variantsArray[product].isstockcontinue)
//                check_arr.append(variantsArray[product].is_tobacco)
//                disable_arr.append(variantsArray[product].disable)
//                foodStamp_arr.append(variantsArray[product].food_stampable)
//                
//                reorderQty_arr.append(variantsArray[product].reorder_qty)
//                reorderLevel_arr.append(variantsArray[product].reorder_level)
//            }
//            
//            
//            if result.count != 0 {
//                v_variant_arr = result
//            }
//            
//            prod.varid = v_id_arr.joined(separator: ",")
//            prod.varvarient = v_variant_arr.joined(separator: ",")
//            
//            prod.varcostperitem = cost_item_arr.joined(separator: ",")
//            prod.varprice = price_arr.joined(separator: ",")
//            prod.varcompareprice = compare_arr.joined(separator: ",")
//            prod.varmargin = margin_arr.joined(separator: ",")
//            prod.varupc = upc_arr.joined(separator: ",")
//            prod.varprofit = profit_arr.joined(separator: ",")
//            prod.varcustomcode = custom_arr.joined(separator: ",")
//            prod.varquantity = quantity_arr.joined(separator: ",")
//            
//            prod.vartrackqnty = track_arr.joined(separator: ",")
//            prod.varcontinue_selling = sell_arr.joined(separator: ",")
//            prod.varcheckid = check_arr.joined(separator: ",")
//            prod.vardisable = disable_arr.joined(separator: ",")
//            prod.varfood_stampable = foodStamp_arr.joined(separator: ",")
//            
//            prod.varreorder_qty = reorderQty_arr.joined(separator: ",")
//            prod.varreorder_level = reorderLevel_arr.joined(separator: ",")
//            
//            
//            
//            prod.isvarient = "1"
//            
//            
//            print(prod)
//            print(prod)
//            print(productOptions)
//            for opt in 0..<productOptions.count {
//                
//                if opt == 0 {
//                    prod.optionarray = productOptions[opt].options1
//                    prod.optionvalue = productOptions[opt].optionsvl1
//                }
//                
//                else if opt == 1 {
//                    prod.optionarray1 = productOptions[opt].options2
//                    prod.optionvalue1 = productOptions[opt].optionsvl2
//
//                }
//                
//                else {
//                    prod.optionarray2 = productOptions[opt].options3
//                    prod.optionvalue2 = productOptions[opt].optionsvl3
//                }
//            }
//            
//            prod.optionid = productOptions[0].id
//            
//            print(prod)
//            loadIndicator.isAnimating = true
//            saveBtn.isEnabled = false
//
//            let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
//            
//            ApiCalls.sharedCall.productEditCall(merchant_id: m_id, admin_id: "", title: name,
//                                                alternateName: "",
//                                                description: desc, price: "", compare_price: "", costperItem: "",
//                                                margin: "", profit: "", ischargeTax: prod.ischargeTax, sku: "", upc: "",
//                                                custom_code: "", barcode: "", trackqnty: "", isstockcontinue: "", quantity: "",
//                                                ispysical_product: "", country_region: "",
//                                                collection: prod.collection, HS_code: "", isvarient: "1",
//                                                multiplefiles: "", img_color_lbl: "",
//                                                created_on: "", productid: editProd?.id ?? "",
//                                                optionarray: prod.optionarray, optionarray1: prod.optionarray1,
//                                                optionarray2: prod.optionarray2,
//                                                optionvalue: prod.optionvalue, optionvalue1: prod.optionvalue1,
//                                                optionvalue2: prod.optionvalue2, other_taxes: prod.other_taxes,
//                                                bought_product: "", featured_product: "", varvarient: prod.varvarient,
//                                                varprice: prod.varprice,
//                                                varquantity: prod.varquantity, varsku: "", varbarcode: "", files: "",
//                                                doc_file: "",
//                                                optionid: prod.optionid, varupc: prod.varupc, varcustomcode: prod.varcustomcode,
//                                                reorder_qty: "",
//                                                reorder_level: "", reorder_cost: "", is_tobacco: prod.is_tobacco,
//                                                disable: prod.disable, food_stampable: "",
//                                                vartrackqnty: prod.vartrackqnty, varcontinue_selling: prod.varcontinue_selling,
//                                                varcheckid: prod.varcheckid, vardisable: prod.vardisable, varfood_stampable: prod.varfood_stampable,
//                                                varmargin: prod.varmargin, varprofit: prod.varprofit,
//                                                varreorder_qty: prod.varreorder_qty, varreorder_level: prod.varreorder_level, varreorder_cost: "",
//                                                varcostperitem: prod.varcostperitem, varcompareprice: prod.varcompareprice,
//                                                var_id: prod.varid) { isSuccess, responseData in
//                
//                if isSuccess {
//                    
//                    self.showToastLarge(message: " Product updated successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.loadIndicator.isAnimating = false
//                        self.navigationController?.popViewController(animated: true)
//                        self.saveBtn.isEnabled = true
//                    }
//                    
//                }
//                else {
//                    self.saveBtn.isEnabled = true
//                }
//            }
//        }
//    }
//
//    
//    func adjustAttributeCombos() {
//        
//        if mode == "add" {
//            
//            if productOptions.count > 0 {
//                
//                
//                if arrOptVl1.count == 1 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
//                    
//                    variantsArray[0].title = arrOptVl1[0]
//                    
//                    let resultCount = variantsArray.count - 1
//                    variantsArray.removeLast(resultCount)
//                    
//                }
//                
//                else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 0 {
//                    
//                    variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])"
//                    
//                    let resultCount = variantsArray.count - 1
//                    variantsArray.removeLast(resultCount)
//                    
//                    
//                }
//                
//                else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 1 {
//                    
//                    variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])/\(arrOptVl3[0])"
//                    
//                    let resultCount = variantsArray.count - 1
//                    variantsArray.removeLast(resultCount)
//                }
//                
//                else {
//                    
//                    if arrOptVl1.count == 1 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
//                        
//                        variantsArray[0].title = arrOptVl1[0]
//                        
//                        let resultCount = variantsArray.count - 1
//                        variantsArray.removeLast(resultCount)
//                        
//                    }
//                    
//                    else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 0 {
//                        
//                        variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])"
//                        
//                        
//                        
//                        let resultCount = variantsArray.count - 1
//                        variantsArray.removeLast(resultCount)
//                        
//                        
//                    }
//                    
//                    else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 1 {
//                        
//                        variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])/\(arrOptVl3[0])"
//                        
//                        
//                        let resultCount = variantsArray.count - 1
//                        variantsArray.removeLast(resultCount)
//                    }
//                    
//                    if arrOptVl1.count > 0 && arrOptVl2.count > 0 &&  arrOptVl3.count == 0 {
//                        
//                        result = arrOptVl1.flatMap { s1 in
//                            arrOptVl2.map { s2 in
//                                "\(s1)/\(s2)"
//                            }
//                        }
//                        
//                        print(result)
//                        print(result.count)
//                        print(variantsArray.count)
//                        
//                        var resCount = 0
//                        
//                        if result.count > variantsArray.count {
//                            resCount = result.count - variantsArray.count
//                            
//                            for _ in 0..<resCount {
//                                
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
//                                                                 margin: "", brand: "", tags: "",upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "", updated_on: "",
//                                                                 isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "", reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00", is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "", reorder_level: "",
//                                                                 env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                            }
//                            for va in 0..<variantsArray.count {
//                                print()
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        else if result.count < variantsArray.count {
//                            resCount = variantsArray.count - result.count
//                            
//                            variantsArray.removeLast(resCount)
//                        }
//                        else {
//                            
//                        }
//                    }
//                    
//                    
//                    else if arrOptVl1.count > 0 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
//                        
//                        
//                        result = arrOptVl1
//                        
//                        var resCount = 0
//                        
//                        if result.count > variantsArray.count {
//                            resCount = result.count - variantsArray.count
//                            
//                            for _ in 0..<resCount {
//                                
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
//                                                                 margin: "", brand: "",
//                                                                 tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "", updated_on: "",
//                                                                 isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "", reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00", is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "", reorder_level: "",
//                                                                 env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                                
//                            }
//                            for va in 0..<variantsArray.count {
//                                
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        else if result.count < variantsArray.count {
//                            resCount = variantsArray.count - result.count
//                            
//                            variantsArray.removeLast(resCount)
//                        }
//                        else {
//                            
//                        }
//                        
//                    }
//                    
//                    else {
//                        
//                        result = arrOptVl1.flatMap { s1 in
//                            arrOptVl2.flatMap { s2 in
//                                arrOptVl3.map { s3 in
//                                    "\(s1)/\(s2)/\(s3)"
//                                }
//                            }
//                        }
//                        print(result)
//                        
//                        var resCount = 0
//                        
//                        if result.count > variantsArray.count {
//                            resCount = result.count - variantsArray.count
//                            
//                            for _ in 0..<resCount {
//                                
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
//                                                                 margin: "", brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "", updated_on: "",
//                                                                 isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "", reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00", is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "", reorder_level: "",
//                                                                 env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                                
//                            }
//                            for va in 0..<variantsArray.count {
//                                
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        else if result.count < variantsArray.count {
//                            resCount = variantsArray.count - result.count
//                            
//                            variantsArray.removeLast(resCount)
//                        }
//                        else {
//                            
//                        }
//                    }
//                }
//            }
//            
//            else {
//                
//                var resCount = 0
//                print(variantsArray.count)
//                print(result.count)
//                resCount = variantsArray.count - 1
//                
//                variantsArray.removeLast(resCount)
//            }
//            
//            attTableHeight.constant = CGFloat(73 * productOptions.count)
//            
//        }
//        
//        //edit
//        else {
//            
//            print(arrOptVl1)
//            print(arrOptVl2)
//            print(arrOptVl3)
//            
//             if variantsArray.count == 0 {
//               
//            }
//            
//            else {
//                print("options")
//                
//                print(arrOptVl1.count)
//                print(arrOptVl2)
//                print(arrOptVl3)
//                
//                if arrOptVl1.count == 1 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
//                    
//                    variantsArray[0].title = arrOptVl1[0]
//                    
//                }
//                
//                else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 0 {
//                    
//                    variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])"
//                    
//                }
//                
//                else if arrOptVl1.count == 1 && arrOptVl2.count == 1 && arrOptVl3.count == 1 {
//                    
//                    variantsArray[0].title = "\(arrOptVl1[0])/\(arrOptVl2[0])/\(arrOptVl3[0])"
//                    
//                }
//                
//                else {
//                    
//                    if arrOptVl1.count > 0 && arrOptVl2.count == 0 && arrOptVl3.count == 0 {
//                        
//                        let var_count = variantsArray.count
//                        result = arrOptVl1
//                        
//                        print(variantsArray.count)
//                        print(result.count)
//                        
//                        if var_count < arrOptVl1.count {
//                            
//                            let diff = result.count - var_count
//                            
//                            for _ in 0..<diff {
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "",
//                                                                 description: "", starting_quantity: "",
//                                                                 margin: "", brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "", updated_on: "",
//                                                                 isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "", reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00", is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "", reorder_level: "",
//                                                                 env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                            }
//                            for va in 0..<variantsArray.count {
//                                
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        else {}
//                    }
//                    
//                    else if arrOptVl1.count > 0 && arrOptVl2.count > 0 && arrOptVl3.count == 0 {
//                        
//                        print(variantsArray.count)
//                        
//                        result = arrOptVl1.flatMap { s1 in
//                            arrOptVl2.map { s2 in
//                                "\(s1)/\(s2)"
//                            }
//                        }
//                    
//                        var consmallres = [String]()
//                        
//                        for res in newEditAtt {
//                            
//                            for res2 in result {
//                                
//                                if res2.contains(res) {
//                                    consmallres.append(res2)
//                                }
//                            }
//                        }
//                        
//                        for small in consmallres {
//                            
//                            if result.contains(small) {
//                                result.removeAll(where: {$0 == small})
//                            }
//                        }
//                        
//                        result.append(contentsOf: consmallres)
//                        
//                        var uniqueArray = [String]()
//                        
//                        for res in result {
//                            
//                            if uniqueArray.contains(res) {}
//                            else {
//                                uniqueArray.append(res)
//                            }
//                        }
//                        
//                        result = uniqueArray
//                        
//                        print(result)
//                        let var_count = variantsArray.count
//                        print(var_count)
//                        if var_count < result.count {
//                            
//                            let diff = result.count - var_count
//                            
//                            for _ in 0..<diff {
//                                
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
//                                                                 margin: "", brand: "", tags: "",upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "", updated_on: "",
//                                                                 isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "", reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00", is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "", reorder_level: "",
//                                                                 env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                                
//                            }
//                            print(variantsArray)
//                            
//                            for va in 0..<variantsArray.count {
//                                
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        else {}
//                    }
//                    
//                    else {
//                        
//                        result = arrOptVl1.flatMap { s1 in
//                            arrOptVl2.flatMap { s2 in
//                                arrOptVl3.map { s3 in
//                                    "\(s1)/\(s2)/\(s3)"
//                                }
//                            }
//                        }
//                        
//                        print(result)
//                        
//                        
//                        var consmallres = [String]()
//
//                        for res in newEditAtt {
//                            for res2 in result {
//                                if res2.contains(res) {
//                                    consmallres.append(res2)
//                                }
//                            }
//                        }
//                        
//                        for small in consmallres {
//                            if result.contains(small) {
//                                result.removeAll(where: {$0 == small})
//                            }
//                        }
//
//                        result.append(contentsOf: consmallres)
//                        
//                        var uniqueArray = [String]()
//                        for res in result {
//                            
//                            if uniqueArray.contains(res) {}
//                            else {
//                                uniqueArray.append(res)
//                            }
//                        }
//                        
//                        result = uniqueArray
//                        
//                        let var_count = variantsArray.count
//                        print(variantsArray.count)
//                        print(result.count)
//                        if var_count < result.count {
//                            
//                            let diff = result.count - var_count
//                            
//                            for _ in 0..<diff {
//                                variantsArray.append(ProductById(alternateName: "", admin_id: "", description: "",
//                                                                 starting_quantity: "", margin: "", brand: "",
//                                                                 tags: "", upc: "", id: "",
//                                                                 sku: "", disable: "0", food_stampable: "0", isvarient: "",
//                                                                 title: "", quantity: "", ischargeTax: "",
//                                                                 updated_on: "", isstockcontinue: "1", trackqnty: "1",
//                                                                 profit: "", custom_code: "",
//                                                                 assigned_vendors: "", barcode: "", country_region: "",
//                                                                 ispysical_product: "", show_status: "", HS_code: "",
//                                                                 price: "0.00", featured_product: "",
//                                                                 merchant_id: "", created_on: "", prefferd_vendor: "",
//                                                                 reorder_cost: "",
//                                                                 other_taxes: "", buy_with_product: "", costperItem: "0.00",
//                                                                 is_tobacco: "0",
//                                                                 product_doc: "", user_id: "", media: "", compare_price: "",
//                                                                 loyalty_product_id: "", show_type: "", cotegory: "",
//                                                                 reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: ""))
//                            }
//                            for va in 0..<variantsArray.count {
//                                
//                                if variantsArray[va].variant == "" {
//                                    variantsArray[va].variant = result[va]
//                                }
//                            }
//                        }
//                        
//                        else { }
//                    }
//                }
//            }
//            
//            if cat_coll_height.constant > 53.0 {
//                
//                if tax_coll_height.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 10
//                }
//                
//                else {
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                }
//            }
//            else {
//                
//                if tax_coll_height.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                    cat_coll_height.constant + 10
//                }
//                
//                else {
//                    scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                }
//            }
//        }
//    }
//
//    
//    @IBAction func deleteBtnClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "red_delete") {
//            
//            let position = sender.tag
//            productOptions.remove(at: position)
//            
//            loadingIndicator.isAnimating = true
//            
//            if position == 0 {
//                print(position)
//                arrOptVl1 = arrOptVl2
//                arrOptVl2 = arrOptVl3
//                arrOptVl3 = []
//            }
//            
//            else if position == 1 {
//                print(position)
//                arrOptVl2 = arrOptVl3
//                arrOptVl3 = []
//            }
//            
//            else {
//                arrOptVl3 = []
//            }
//            
//            attTable.reloadData()
//            attTableHeight.constant = CGFloat(73 * productOptions.count)
//            if productOptions.count < 3 {
//                addAttribute.isHidden = false
//                addAttriBtnHeight.constant = 45
//            }
//            else {
//                addAttribute.isHidden = true
//                addAttriBtnHeight.constant = 0
//            }
//            print(variantsArray.count)
//            adjustAttributeCombos()
//            print(variantsArray.count)
//            
//            for variants in 0..<variantsArray.count {
//                
//                let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
//                                            brand: "",
//                                            tags: "", upc: "",
//                                            id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "", title: "", quantity: "", ischargeTax: "",
//                                            updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                            assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
//                                            show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
//                                            created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
//                                            buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
//                                            media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
//                                            reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
//                
//                variantsArray[variants] = emptyProd
//                
//            }
//            tableview.reloadData()
//        }
//        
//        else {
//           
//            if mode == "add" {
//                goMode = "cellClick"
//                let index = sender.tag
//                inventoryOpt = productOptions[index]
//                addattrIndex = index
//            }
//            
//            else {
//                
//                let index = sender.tag
//                print(productOptions.count)
//                
//                if index == 0 {
//                    
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    if productOptions.count == 1 {}
//                    else if productOptions.count == 2 {
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                    else {
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                        arrOptVl3 = productOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                }
//                else if index == 1 {
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    
//                    if productOptions.count == 1 {}
//                    else if productOptions.count == 2 {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                        arrOptVl3 = productOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                }
//                
//                else {
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    
//                    if productOptions.count == 1 {
//                    }
//                    else if productOptions.count == 2 {}
//                    else {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//            }
//            performSegue(withIdentifier: "toAddVarAttri", sender: nil)
//        }
//    }
//    
//    
//    @IBAction func openScan(_ sender: UIButton) {
//        
//        scanIndex = sender.tag
//        
//        let vc = BarcodeScannerViewController()
//        vc.codeDelegate = self
//        vc.errorDelegate = self
//        vc.dismissalDelegate = self
//        
//        self.present(vc, animated: true)
//    }
//}
//
//extension AddProductViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate,
//                                    BarcodeScannerErrorDelegate {
//
//
//    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        
//        let urlString = code
//        
//        print(urlString)
//        
//        if mode == "add" {
//            
//            let index = IndexPath(row: 0, section: scanIndex)
//            let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//            
//            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//            if upcUnique.contains(urlString) {
//                controller.dismiss(animated: true)
//                showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                cell.upcCode.text = ""
//                variantsArray[scanIndex].upc = ""
//            }
//            else {
//                
//                if variantsArray.contains(where: {$0.upc == urlString}) {
//                    
//                    if scanIndex == variantsArray.firstIndex(where: {$0.upc == urlString}) {
//                        variantsArray[scanIndex].upc = urlString
//                        tableview.reloadData()
//                        controller.dismiss(animated: true)
//                    }
//                    else {
//                        controller.dismiss(animated: true)
//                        showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                        cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                        cell.upcCode.text = ""
//                        variantsArray[scanIndex].upc = ""
//                    }
//                }
//                else {
//                    variantsArray[scanIndex].upc = urlString
//                    print(urlString)
//                    tableview.reloadData()
//                    controller.dismiss(animated: true)
//                }
//            }
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                let index = IndexPath(row: 0, section: scanIndex)
//                let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                
//                let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                
//                if upcUnique.contains(urlString) {
//                    controller.dismiss(animated: true)
//                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                    cell.upcCode.text = ""
//                    editProd?.upc = ""
//                }
//                else {
//                    controller.dismiss(animated: true)
//                    editProd?.upc = urlString
//                    tableview.reloadData()
//                }
//            }
//            else {
//                
//                let index = IndexPath(row: 0, section: scanIndex)
//                let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                
//                let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                
//                if upcUnique.contains(urlString) {
//                    controller.dismiss(animated: true)
//                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                    cell.upcCode.text = ""
//                    variantsArray[scanIndex].upc = ""
//                }
//                else {
//                    
//                    if variantsArray.contains(where: {$0.upc == urlString}) {
//                        
//                        if scanIndex == variantsArray.firstIndex(where: {$0.upc == urlString}) {
//                            variantsArray[scanIndex].upc = urlString
//                            tableview.reloadData()
//                            controller.dismiss(animated: true)
//                        }
//                        else {
//                            controller.dismiss(animated: true)
//                            showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                            cell.upcCode.text = ""
//                            variantsArray[scanIndex].upc = ""
//                        }
//                    }
//                    else {
//                        variantsArray[scanIndex].upc = urlString
//                        print(urlString)
//                        tableview.reloadData()
//                        controller.dismiss(animated: true)
//                    }
//                }
//            }
//        }
//    }
//    
//    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
//        controller.dismiss(animated: true)
//    }
//    
//    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
//        controller.dismiss(animated: true)
//    }
//    
//    
//}
//
//
//extension AddProductViewController: UITextFieldDelegate {
//    
//    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        
//        if mode == "add" {
//            
//            if textField == productName {
//                
//            }
//            
//            else {
//                
//                let index = IndexPath(row: 0, section: textField.tag)
//                let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                
//                
//                if textField == cell.costPerItem {
//                    
//                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
//                    print(cost_per_value)
//                    let cost_per_item = textField.text ?? ""
//                    
//                    guard cost_per_item != "" else {
//                        return
//                    }
//                    
//                    if cost_per_value == "" || cost_per_value == "0.00" {
//                        
//                        let price = "0.00"
//                        let profit = "0.00"
//                        let margin = "0.00"
//                        
//                        variantsArray[index.section].costperItem = cost_per_item
//                        variantsArray[index.section].price = price
//                        variantsArray[index.section].margin = profit
//                        variantsArray[index.section].profit = margin
//                        
//                        for variants in 0..<variantsArray.count {
//                            
//                            if variantsArray[variants].costperItem == "0.00" {
//                                variantsArray[variants].costperItem = cost_per_item
//                                variantsArray[variants].price = price
//                                variantsArray[variants].margin = margin
//                                variantsArray[variants].profit = profit
//                            }
//                        }
//                        tableview.reloadData()
//                    }
//                    
//                    else {
//                        
//                        let cost_per_value_doub = Double(cost_per_value) ?? 0.00
//                        let percent = cost_per_value_doub/100
//                        
//                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                        let profit = cost_per_item_doub * percent
//                        let price = cost_per_item_doub + profit
//                        let margin = (profit / price) * 100
//                        
//                        variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
//                        variantsArray[index.section].price = String(format: "%.2f", price)
//                        variantsArray[index.section].margin = String(format: "%.2f", margin)
//                        variantsArray[index.section].profit = String(format: "%.2f", profit)
//                        
//                        print(variantsArray.count)
//                        for variants in 0..<variantsArray.count {
//                            
//                            if variantsArray[variants].costperItem == "0.00" {
//                                variantsArray[variants].costperItem = cost_per_item
//                                variantsArray[variants].price = String(format: "%.2f", price)
//                                variantsArray[variants].margin = String(format: "%.2f", margin)
//                                variantsArray[variants].profit = String(format: "%.2f", profit)
//                            }
//                        }
//                        tableview.reloadData()
//                    }
//                }
//                
//                else if textField == cell.price {
//                    
//                    let price = cell.price.text ?? "0.00"
//                    variantsArray[index.section].price = price
//                    let cpi = variantsArray[index.section].costperItem
//                    
//                    let cost_per_doub = Double(cpi) ?? 0.00
//                    let price_doub = Double(price) ?? 0.00
//                    
//                    if cost_per_doub == 0.00 {
//                        let profit = ""
//                        let margin = ""
//                        variantsArray[index.section].margin = String(format: "%.2f", margin)
//                        variantsArray[index.section].profit = String(format: "%.2f", profit)
//                        
//                        for variants in 0..<variantsArray.count {
//                            
//                            if variantsArray[variants].price == "0.00" {
//                                variantsArray[variants].price = price
//                                variantsArray[variants].margin = String(format: "%.2f", margin)
//                                variantsArray[variants].profit = String(format: "%.2f", profit)
//                            }
//                        }
//                    }
//                    else {
//                        let profit = price_doub - cost_per_doub
//                        let margin = (profit / price_doub) * 100
//                        variantsArray[index.section].margin = String(format: "%.2f", margin)
//                        variantsArray[index.section].profit = String(format: "%.2f", profit)
//                        
//                        for variants in 0..<variantsArray.count {
//                            
//                            if variantsArray[variants].price == "0.00" {
//                                variantsArray[variants].price = price
//                                variantsArray[variants].margin = String(format: "%.2f", margin)
//                                variantsArray[variants].profit = String(format: "%.2f", profit)
//                            }
//                        }
//                    }
//                    tableview.reloadData()
//                    
//                }
//                else if textField == cell.comparePrice {
//                    
//                    let cprice = cell.comparePrice.text ?? ""
//                    variantsArray[index.section].compare_price = cprice
//                    tableview.reloadData()
//                    
//                    for variants in 0..<variantsArray.count {
//                        
//                        if variantsArray[variants].compare_price == "" {
//                            variantsArray[variants].compare_price = cprice
//                        }
//                    }
//                    tableview.reloadData()
//                }
//                else if textField == cell.qty {
//                    
//                    let quty = cell.qty.text ?? ""
//                    variantsArray[index.section].quantity = quty
//                    tableview.reloadData()
//                    
//                    for variants in 0..<variantsArray.count {
//                        
//                        if variantsArray[variants].quantity == "" {
//                            variantsArray[variants].quantity = quty
//                        }
//                    }
//                    tableview.reloadData()
//                }
//                else if textField == cell.customCode {
//                    let custom = cell.customCode.text ?? ""
//                    variantsArray[index.section].custom_code = custom
//                    tableview.reloadData()
//                }
//                
//                else if textField == cell.reorderQty {
//                    let reqty = cell.reorderQty.text ?? ""
//                    variantsArray[index.section].reorder_qty = reqty
//                    tableview.reloadData()
//                }
//                else if textField == cell.reorderLevel {
//                    let relvl = cell.reorderLevel.text ?? ""
//                    variantsArray[index.section].reorder_level = relvl
//                    tableview.reloadData()
//                }
//                else if textField == cell.upcCode {
//                    
//                    let upcText = cell.upcCode.text ?? ""
//                    
//                    if upcText == "" {
//                        variantsArray[index.section].upc = ""
//                    }
//                    else {
//                        
//                        let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                        
//                        if upcUnique.contains(upcText) {
//                            showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                            cell.upcCode.text = ""
//                            variantsArray[index.section].upc = ""
//                        }
//                        else {
//                            
//                            if variantsArray.contains(where: {$0.upc == upcText}) {
//                                
//                                if textField.tag  == variantsArray.firstIndex(where: {$0.upc == upcText}) {
//                                    
//                                    variantsArray[index.section].upc = upcText
//                                    tableview.reloadData()
//                                }
//                                else {
//                                    
//                                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                                    cell.upcCode.text = ""
//                                    variantsArray[index.section].upc = ""
//                                }
//                            }
//                            else {
//                                
//                                variantsArray[index.section].upc = upcText
//                                tableview.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                
//                if textField == productName {
//                    
//                }
//                
//                else {
//                    let index = IndexPath(row: 0, section: 0)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
//                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
//                    let percent = cost_per_value_doub/100
//                                        
//                    if textField == cell.costPerItem {
//                        
//                        let cost_per_item = textField.text ?? ""
//                        
//                        guard cost_per_item != "" else {
//                            return
//                        }
//                        
//                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                        let price = cell.price.text ?? "0.00"
//                        let price_doub = Double(price) ?? 0.00
//                        let profit = Double(price_doub) - cost_per_item_doub
//                        let margin = (profit / price_doub) * 100
//                        
//                        editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
//                        //editProd?.price = String(format: "%.2f", price)
//                        editProd?.margin = String(format: "%.2f", margin)
//                        editProd?.profit = String(format: "%.2f", profit)
//                        
//                        if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
//                            editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
//                            editProd?.margin = "0.00"
//                            editProd?.profit = "0.00"
//                        }
//                        else {
//                            if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
//                                
//                                editProd?.costperItem = "0.00"
//                                editProd?.margin = "0.00"
//                                editProd?.profit = "0.00"
//                                
//                            }
//                            
//                            else {
//                                
//                                editProd?.costperItem = String(format: "%.2f", cost_per_item_doub)
//                                editProd?.margin = String(format: "%.2f", margin)
//                                editProd?.profit = String(format: "%.2f", profit)
//                                
//                            }
//                        }
//                        
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.price {
//                        
//                        let price = cell.price.text ?? ""
//                        editProd?.price = price
//                        let price_doub = Double(price) ?? 0.00
//                        
//                        let cost_per_item = cell.costPerItem.text ?? ""
//                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                        let profit = Double(price_doub) - cost_per_item_doub
//                        let margin = (profit / price_doub) * 100
//                        
//                        if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
//                            
//                            editProd?.margin = "0.00"
//                            editProd?.profit = "0.00"
//                        }
//                        else {
//                            
//                            if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
//                                editProd?.margin = "0.00"
//                                editProd?.profit = "0.00"
//                            }
//                            else {
//                                editProd?.margin = String(format: "%.2f", margin)
//                                editProd?.profit = String(format: "%.2f", profit)
//                            }
//                        }
//                        
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.comparePrice {
//                        
//                        let cprice = cell.comparePrice.text ?? ""
//                        editProd?.compare_price = cprice
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.qty {
//                        
//                        let quty = cell.qty.text ?? ""
//                        editProd?.quantity = quty
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.customCode {
//                        
//                        let custom = cell.customCode.text ?? ""
//                        editProd?.custom_code = custom
//                        tableview.reloadData()
//                    }
//                    else if textField == cell.reorderQty {
//                        let reqty = cell.reorderQty.text ?? ""
//                        editProd?.reorder_qty = reqty
//                        tableview.reloadData()
//                    }
//                    else if textField == cell.reorderLevel {
//                        let relvl = cell.reorderLevel.text ?? ""
//                        editProd?.reorder_level = relvl
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.upcCode {
//                        
//                        let upcText = cell.upcCode.text ?? ""
//                        
//                        if upcText == "" {
//                            editProd?.upc = ""
//                        }
//                        else {
//                            
//                            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                            
//                            if upcUnique.contains(upcText){
//                                if upcText == activeTextUpcText { }
//                                else {
//                                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                                    cell.upcCode.isError(numberOfShakes:  3, revert: true)
//                                    cell.upcCode.text = ""
//                                    editProd?.upc = ""
//                                }
//                            }else {
//                                editProd?.upc = upcText
//                                tableview.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//            else {
//                
//                if textField == productName {
//                    
//                }
//                
//                else {
//                    
//                    let index = IndexPath(row: 0, section: textField.tag)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
//                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
//                    let percent = cost_per_value_doub/100
//                    
//                    if textField == cell.costPerItem {
//                        
//                        let cost_per_item = textField.text ?? ""
//                        
//                        guard cost_per_item != "" else {
//                            return
//                        }
//                                                
//                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                        let price = cell.price.text ?? "0.00"
//                        let price_doub = Double(price) ?? 0.00
//                        let profit = Double(price_doub) - cost_per_item_doub
//                        let margin = (profit / price_doub) * 100
//                        
//                        if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
//                            variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
//                            variantsArray[index.section].margin = "0.00"
//                            variantsArray[index.section].profit = "0.00"
//                        }
//                        else {
//                            if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
//                                
//                                variantsArray[index.section].costperItem = "0.00"
//                                variantsArray[index.section].margin = "0.00"
//                                variantsArray[index.section].profit = "0.00"
//                                
//                            }
//                            
//                            else {
//                                
//                                variantsArray[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
//                                variantsArray[index.section].margin = String(format: "%.2f", margin)
//                                variantsArray[index.section].profit = String(format: "%.2f", profit)
//                                
//                            }
//                        }
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.price {
//                        
//                        let price = cell.price.text ?? ""
//                        variantsArray[index.section].price = price
//                        
//                        let price_doub = Double(price) ?? 0.00
//                        
//                        let cost_per_item = variantsArray[index.section].costperItem
//                        let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                        
//                        let profit = Double(price_doub) - cost_per_item_doub
//                        let margin = (profit / price_doub) * 100
//                        
//                        if cost_per_item_doub < 0 || cost_per_item_doub == 0.00 || cost_per_item_doub < 0 || cost_per_item_doub < 0.00 {
//                            
//                            variantsArray[index.section].margin = "0.00"
//                            variantsArray[index.section].profit = "0.00"
//                        }
//                        else {
//                            
//                            if price_doub < 0 || price_doub == 0.00 || price_doub < 0 || price_doub < 0.00 {
//                                variantsArray[index.section].margin = "0.00"
//                                variantsArray[index.section].profit = "0.00"
//                            }
//                            else {
//                                variantsArray[index.section].margin = String(format: "%.2f", margin)
//                                variantsArray[index.section].profit = String(format: "%.2f", profit)
//                            }
//                        }
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.comparePrice {
//                        
//                        let cprice = cell.comparePrice.text ?? ""
//                        variantsArray[index.section].compare_price = cprice
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.qty {
//                        
//                        let quty = cell.qty.text ?? ""
//                        variantsArray[index.section].quantity = quty
//                        tableview.reloadData()
//                    }
//                    
//                    else if textField == cell.customCode {
//                        
//                        let custom = cell.customCode.text ?? ""
//                        variantsArray[index.section].custom_code = custom
//                        tableview.reloadData()
//                    }
//                    else if textField == cell.reorderQty {
//                        let reqty = cell.reorderQty.text ?? ""
//                        variantsArray[index.section].reorder_qty = reqty
//                        tableview.reloadData()
//                    }
//                    else if textField == cell.reorderLevel {
//                        let relvl = cell.reorderLevel.text ?? ""
//                        variantsArray[index.section].reorder_level = relvl
//                        tableview.reloadData()
//                    }
//                    
//                    
//                    else if textField == cell.upcCode {
//                        
//                        let upcText = cell.upcCode.text ?? ""
//                        
//                        if upcText == "" {
//                            variantsArray[index.section].upc = ""
//                        }
//                        else {
//                            
//                            let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                            
//                            if upcUnique.contains(upcText) {
//                                if upcText == activeTextUpcText { }
//                                else {
//                                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                                    cell.upcCode.text = ""
//                                    variantsArray[index.section].upc = ""
//                                }
//                            }
//                            else {
//                                
//                                if variantsArray.contains(where: {$0.upc == upcText}) {
//                                    if textField.tag  == variantsArray.firstIndex(where: {$0.upc == upcText}) {
//                                        variantsArray[index.section].upc = upcText
//                                        tableview.reloadData()
//                                    }
//                                    else {
//                                        showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                                        cell.upcCode.isError(numberOfShakes: 3, revert: true)
//                                        cell.upcCode.text = ""
//                                        variantsArray[index.section].upc = ""
//                                    }
//                                }
//                                else {
//                                    variantsArray[index.section].upc = upcText
//                                    tableview.reloadData()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        
//        if mode == "add" {
//            
//            if textField == productName {
//                activeTextField = textField
//            }
//            else {
//                let index = IndexPath(row: 0, section: textField.tag)
//                let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                
//                if textField == cell.qty {
//                    activeTextField = textField
//                }
//                else if textField == cell.customCode {
//                    activeTextField = textField
//                }
//                else if  textField == cell.upcCode {
//                    
//                    activeTextField = textField
//                }
//                else if  textField == cell.reorderQty {
//                    
//                    activeTextField = textField
//                }
//                else if  textField == cell.reorderLevel {
//                    activeTextField = textField
//                }
//            }
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                
//                if textField == productName {
//                    activeTextField = textField
//                }
//                else {
//                    let index = IndexPath(row: 0, section: 0)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    if textField == cell.qty {
//                        activeTextField = textField
//                    }
//                    else if textField == cell.customCode {
//                        activeTextField = textField
//                    }
//                    else if  textField == cell.upcCode {
//                        activeTextUpcText = textField.text ?? ""
//                        activeTextField = textField
//                    }
//                    else if  textField == cell.reorderQty {
//                        
//                        activeTextField = textField
//                    }
//                    else if  textField == cell.reorderLevel {
//                        activeTextField = textField
//                    }
//                }
//            }
//            
//            else {
//                
//                if textField == productName {
//                    activeTextField = textField
//                }
//                else {
//                    let index = IndexPath(row: 0, section: textField.tag)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    if textField == cell.qty {
//                        activeTextField = textField
//                    }
//                    else if textField == cell.customCode {
//                        activeTextField = textField
//                    }
//                    else if  textField == cell.upcCode {
//                        activeTextUpcText = textField.text ?? ""
//                         activeTextField = textField
//                    }
//                    else if  textField == cell.reorderQty {
//                        
//                        activeTextField = textField
//                    }
//                    else if  textField == cell.reorderLevel {
//                        activeTextField = textField
//                    }
//                }
//            }
//        }
//    }
//   
//
//    @objc func updateText(textField: MDCOutlinedTextField) {
//        
//        if mode == "add" {
//            
//            var updatetext = textField.text ?? ""
//            
//            if textField == productName {
//                if updatetext.count > 50 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//            
//            else {
//                
//                let index = IndexPath(row: 0, section: textField.tag)
//                let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                
//                if textField == cell.qty  {
//                    if updatetext.count > 6 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                else if textField == cell.customCode {
//                    if updatetext.count > 30 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                else if textField == cell.upcCode {
//                    if updatetext.count > 20 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                
//                else if textField == cell.reorderQty {
//                    if updatetext.count > 6 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                else if textField == cell.reorderLevel {
//                    if updatetext.count > 6 {
//                        updatetext = String(updatetext.dropLast())
//                        
//                    }
//                }
//            }
//            
//            activeTextField.text = updatetext
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                
//                var updatetext = textField.text ?? ""
//                
//                if textField == productName{
//                    if updatetext.count > 50 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                
//                else {
//                    
//                    let index = IndexPath(row: 0, section: 0)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    if textField == cell.qty  {
//                        if updatetext.count > 6 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.customCode {
//                        if updatetext.count > 30 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.upcCode {
//                        if updatetext.count > 20 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.reorderQty {
//                        if updatetext.count > 6{
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.reorderLevel {
//                        if updatetext.count > 6 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                }
//                
//                activeTextField.text = updatetext
//            }
//            
//            else {
//                
//                var updatetext = textField.text ?? ""
//                
//                if textField == productName {
//                    if updatetext.count > 50 {
//                        updatetext = String(updatetext.dropLast())
//                    }
//                }
//                
//                else {
//                    
//                    let index = IndexPath(row: 0, section: textField.tag)
//                    let cell = tableview.cellForRow(at: index) as! ProductVariantTableViewCell
//                    
//                    if textField == cell.qty {
//                        if updatetext.count > 6 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.customCode {
//                        if updatetext.count > 30 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.upcCode {
//                        if updatetext.count > 20 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.reorderQty {
//                        if updatetext.count > 6 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                    else if textField == cell.reorderLevel {
//                        if updatetext.count > 6 {
//                            updatetext = String(updatetext.dropLast())
//                        }
//                    }
//                }
//
//                activeTextField.text = updatetext
//            }
//        }
//    }
//    
//    @objc func updateTextField(textField: MDCOutlinedTextField) {
//       
//        var cleanedAmount = ""
//        
//        for character in textField.text ?? "" {
//            print(cleanedAmount)
//            if character.isNumber {
//                cleanedAmount.append(character)
//            }
//            print(cleanedAmount)
//        }
//        
//        if isSymbolOnRight {
//            cleanedAmount = String(cleanedAmount.dropLast())
//        }
//        
//        if Double(cleanedAmount) ?? 00000 > 99999999 {
//            cleanedAmount = String(cleanedAmount.dropLast())
//        }
//        
//        let amount = Double(cleanedAmount) ?? 0.0
//        let amountAsDouble = (amount / 100.0)
//        var amountAsString = String(amountAsDouble)
//        if cleanedAmount.last == "0" {
//            amountAsString.append("0")
//        }
//        textField.text = amountAsString
//        
//        if textField.text == "000" {
//            textField.text = ""
//        }
//    }
//    
//}
//
//
//extension AddProductViewController {
//    
//    func checkExist(result: String) -> Bool {
//        
//        for res in newEditAtt {
//            if result.contains(res) {
//                return true
//            }
//        }
//        return false
//    }
//}
//
//
//extension AddProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if collectionView == tax_collection {
//            return collArrTax.count
//        }
//        else {
//            if prodCategories.count == 0 {
//                return 0
//            }
//            else {
//                return prodCategories.count + 1
//            }
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if collectionView == tax_collection {
//            
//            let cell = tax_collection.dequeueReusableCell(withReuseIdentifier: "tax_cell", for: indexPath) as! AddProdTaxCell
//            cell.borderView.layer.cornerRadius = 5.0
//            cell.close_btn.layer.cornerRadius = 5.0
//            cell.taxName.text = collArrTax[indexPath.row].title
//            
//            cell.borderView.backgroundColor = .black
//            cell.close_btn.tag = indexPath.row
//            
//            taxSubviews()
//            return cell
//            
//        }
//        
//        else {
//            
//            let cell = catColl.dequeueReusableCell(withReuseIdentifier: "cat_cell", for: indexPath) as! CategoryAddProductCell
//            
//            if indexPath.row == prodCategories.count {
//                cell.cat_name_cell.text = ""
//                cell.cellCloseBtn.setImage(UIImage(named: "CatAddBtn"), for: .normal)
//                cell.borderView.backgroundColor = .systemBackground
//            }
//            
//            else {
//                cell.cat_name_cell.text = prodCategories[indexPath.row].title
//                cell.cellCloseBtn.setImage(UIImage(named: "white close"), for: .normal)
//                cell.borderView.backgroundColor = .black
//            }
//            cell.borderView.layer.cornerRadius = 5.0
//            cell.cellCloseBtn.tag = indexPath.row
//            
//            collSubviews()
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if collectionView == tax_collection {
//            
//            tax_collection.deselectItem(at: indexPath, animated: true)
//        }
//        
//        else {
//            
//            catColl.deselectItem(at: indexPath, animated: true)
//        }
//    }
//    
//    
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 0
//    }
//}
//
//extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == tableview {
//            
//            if variantsArray.count == 0 {
//                return isSelectedData.count
//            }
//            else {
//                return variantsArray.count
//            }
//        }
//        else if tableView == attTable {
//            return 1
//        }
//        
//        else {
//            return 1
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == tableview {
//            if isSelectedData[section] == false{
//                return 0
//            }else{
//                return 1
//            }
//        }
//        else if tableView == attTable {
//            return productOptions.count
//        }
//        else {
//            return arrTax.count
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        if tableView == tableview {
//            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductVariantTableViewCell
//            
//            cell.price.label.text = "Price"
//            cell.comparePrice.label.text = "Compare At Price"
//            cell.costPerItem.label.text = "Cost Per Item"
//            cell.margin.label.text = "Margin(%)"
//            cell.profit.label.text = "Profit($)"
//            cell.qty.label.text = "QTY"
//            cell.customCode.label.text = "Custom Code"
//            cell.upcCode.label.text = "UPC Code"
//            cell.reorderQty.label.text = "Reorder Qty"
//            cell.reorderLevel.label.text = "Reoder Level"
//            
////            createCustomTextField(textField: cell.price)
////            createCustomTextField(textField: cell.costPerItem)
////            createCustomTextField(textField: cell.margin)
////            createCustomTextField(textField: cell.profit)
////            createCustomTextField(textField: cell.qty)
////            createCustomTextField(textField: cell.customCode)
////            createCustomTextField(textField: cell.upcCode)
////            createCustomTextField(textField: cell.comparePrice)
////            createCustomTextField(textField: cell.reorderQty)
////            createCustomTextField(textField: cell.reorderLevel)
//
//            
//            cell.margin.backgroundColor = UIColor(named: "Disabled Text")
//            cell.profit.backgroundColor = UIColor(named: "Disabled Text")
//            cell.margin.setOutlineColor(.clear, for: .normal)
//            cell.margin.setOutlineColor(.clear, for: .editing)
//            cell.profit.setOutlineColor(.clear, for: .normal)
//            cell.profit.setOutlineColor(.clear, for: .editing)
//            cell.margin.layer.cornerRadius = 5
//            cell.profit.layer.cornerRadius = 5
//            
//            cell.costPerItem.keyboardType = .numberPad
//            cell.price.keyboardType = .numberPad
//            cell.qty.keyboardType = .numberPad
//            cell.comparePrice.keyboardType = .numberPad
//            cell.reorderQty.keyboardType = .numberPad
//            cell.reorderLevel.keyboardType = .numberPad
//
//            cell.costPerItem.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
//            cell.price.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
//            cell.comparePrice.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
//            cell.margin.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
//            cell.profit.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
//
//            cell.qty.addTarget(self, action: #selector(updateText), for: .editingChanged)
//            cell.customCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
//            cell.upcCode.addTarget(self, action: #selector(updateText), for: .editingChanged)
//            cell.reorderQty.addTarget(self, action: #selector(updateText), for: .editingChanged)
//            cell.reorderLevel.addTarget(self, action: #selector(updateText), for: .editingChanged)
//
//            
//            
//            cell.costPerItem.tag = indexPath.section
//            cell.price.tag = indexPath.section
//            cell.comparePrice.tag = indexPath.section
//            cell.margin.tag = indexPath.section
//            cell.profit.tag = indexPath.section
//            cell.qty.tag = indexPath.section
//            cell.customCode.tag = indexPath.section
//            cell.upcCode.tag = indexPath.section
//            cell.instantBtn.tag = indexPath.section
//            cell.salesHistoryBtn.tag = indexPath.section
//            cell.reorderQty.tag = indexPath.section
//            cell.reorderLevel.tag = indexPath.section
//
//
//            cell.trackQty.tag = indexPath.section
//            cell.selling.tag = indexPath.section
//            cell.checkID.tag = indexPath.section
//            cell.disable.tag = indexPath.section
//            cell.foodstampable.tag = indexPath.section
//          
//            cell.costPerItem.delegate = self
//            cell.price.delegate =  self
//            cell.comparePrice.delegate = self
//            cell.margin.delegate = self
//            cell.profit.delegate = self
//            cell.qty.delegate = self
//            cell.customCode.delegate = self
//            cell.upcCode.delegate = self
//            cell.reorderQty.delegate = self
//            cell.reorderLevel.delegate = self
//            
//            cell.scanBtn.tag = indexPath.section
//
//            cell.instantBtn.layer.cornerRadius = 10.0
//            cell.salesHistoryBtn.layer.cornerRadius = 10.0
//            cell.scanBtn.layer.cornerRadius = 5.0
//            
//            if mode == "add" {
//
//                var variants = variantsArray[indexPath.section]
//             
//                cell.price.text = variants.price
//                cell.comparePrice.text = variants.compare_price
//                cell.costPerItem.text = variants.costperItem
//                cell.margin.text = variants.margin
//                cell.profit.text = variants.profit
//                cell.qty.text = variants.quantity
//                cell.customCode.text = variants.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                cell.upcCode.text = variants.upc
//                cell.reorderQty.text = variants.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                cell.reorderLevel.text = variants.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                
//                if result.count == 0 {
//                    variants.variant = ""
//                }
//                else {
//                    variants.variant = result[indexPath.section]
//                }
//                
//                if variants.trackqnty == "1"{
//                    cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
//                }
//                else {
//                    cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                }
//                
//                if variants.isstockcontinue == "1"{
//                    cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
//                }
//                else {
//                    cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                }
//                
//                if variants.is_tobacco == "1"{
//                    cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
//                }
//                else {
//                    cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                }
//                
//                if variants.disable == "1"{
//                    cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
//                }
//                else {
//                    cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                }
//                
//                if variants.food_stampable == "1"{
//                    cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
//                }
//                else {
//                    cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                }
//                
//                cell.instantBtn.isHidden = true
//                cell.salesHeight.constant = 0
//                cell.costItemInner.isHidden = true
//                cell.qtyInner.isHidden = true
//
//                variantsArray[indexPath.section] = variants
//            }
//            //edit
//            else{
//                
//                var variants: ProductById?
//                
//                let cost_method = UserDefaults.standard.string(forKey: "cost_method")
//                //avg is enabled
//                print(newEditAtt)
//                if newEditAtt.count == 0 {
//                    
//                    if cost_method == "1" {
//                        
//                        cell.costPerItem.backgroundColor = UIColor(named: "Disabled Text")
//                        cell.costPerItem.setOutlineColor(.clear, for: .normal)
//                        cell.costPerItem.setOutlineColor(.clear, for: .editing)
//                        cell.costItemInner.isHidden = false
//                    }
//                    else {
//                        cell.costPerItem.backgroundColor = .systemBackground
//                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                        cell.costItemInner.isHidden = true
//                    }
//                    
//                    cell.qty.backgroundColor = UIColor(named: "Disabled Text")
//                    cell.qty.setOutlineColor(.clear, for: .normal)
//                    cell.qty.setOutlineColor(.clear, for: .editing)
//                    cell.qtyInner.isHidden = false
//                }
//                else {
//                    
//                    if checkExist(result: result[indexPath.section]) {
//                        
//                        cell.costPerItem.backgroundColor = .systemBackground
//                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                        cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                        cell.costItemInner.isHidden = true
//                        
//                        cell.qty.backgroundColor = .systemBackground
//                        cell.qty.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                        cell.qty.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
//                        cell.qtyInner.isHidden = true
//                    }
//                    
//                    else {
//                        
//                        if cost_method == "1" {
//                            
//                            cell.costPerItem.backgroundColor = UIColor(named: "Disabled Text")
//                            cell.costPerItem.setOutlineColor(.clear, for: .normal)
//                            cell.costPerItem.setOutlineColor(.clear, for: .editing)
//                            cell.costItemInner.isHidden = false
//                        }
//                        else {
//                            cell.costPerItem.backgroundColor = .systemBackground
//                            cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                            cell.costPerItem.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//                            cell.costItemInner.isHidden = true
//                        }
//                        
//                        cell.qty.backgroundColor = UIColor(named: "Disabled Text")
//                        cell.qty.setOutlineColor(.clear, for: .normal)
//                        cell.qty.setOutlineColor(.clear, for: .editing)
//                        cell.qtyInner.isHidden = false
//                    }
//                }
//
//                if variantsArray.count == 0 {
//                    variants = editProd
//                    
//                    cell.price.text = variants?.price
//                    cell.comparePrice.text = variants?.compare_price
//                    cell.costPerItem.text = variants?.costperItem
//                    cell.margin.text = variants?.margin
//                    cell.profit.text = variants?.profit
//                    cell.qty.text = variants?.quantity
//                    cell.customCode.text = variants?.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    cell.upcCode.text = variants?.upc
//                    cell.reorderQty.text = variants?.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    cell.reorderLevel.text = variants?.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    
//                    if variants?.trackqnty == "1"{
//                        cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.isstockcontinue == "1"{
//                        cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.is_tobacco == "1"{
//                        cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.disable == "1"{
//                        cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.food_stampable == "1"{
//                        cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                }
//                
//                else {
//                    variants = variantsArray[indexPath.section]
//                   // varient_p_qty = variants?.purchase_qty ?? ""
//                   // print(varient_p_qty)
//                    cell.price.text = variants?.price
//                    cell.comparePrice.text = variants?.compare_price
//                    cell.costPerItem.text = variants?.costperItem
//                    cell.margin.text = variants?.margin
//                    cell.profit.text = variants?.profit
//                    cell.qty.text = variants?.quantity
//                    cell.customCode.text = variants?.custom_code.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    cell.upcCode.text = variants?.upc
//                    cell.reorderQty.text = variants?.reorder_qty.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    cell.reorderLevel.text = variants?.reorder_level.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    
//                    if variants?.trackqnty == "1"{
//                        cell.trackQty.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.trackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.isstockcontinue == "1"{
//                        cell.selling.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.selling.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.is_tobacco == "1"{
//                        cell.checkID.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.checkID.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.disable == "1"{
//                        cell.disable.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.disable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                    if variants?.food_stampable == "1"{
//                        cell.foodstampable.setImage(UIImage(named: "check inventory"), for: .normal)
//                    }
//                    else {
//                        cell.foodstampable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//                    }
//                    
//                }
////                if result.count == 0 {
////                    variants?.variant = "strong"
////                }
////                else {
////                    variants?.variant = result[indexPath.section]
////                }
//                
//                cell.instantBtn.isHidden = false
//                cell.salesHeight.constant = 45
//            }
//            return cell
//        }
//        
//        else {
//            
//            let cell = attTable.dequeueReusableCell(withIdentifier: "addattrcell", for: indexPath) as! AddAttrCell
//            
//            if mode == "add" {
//                cell.delete_btn.setImage(UIImage(named: "red_delete"), for: .normal)
//            }
//            else {
//                cell.delete_btn.setImage(UIImage(named: "next"), for: .normal)
//            }
//            print(productOptions)
//            
//            
//            if productOptions[indexPath.row].options1 == "" && productOptions[indexPath.row].options2 == "" {
//                cell.attName.text = productOptions[indexPath.row].options3
//            }
//            else if productOptions[indexPath.row].options2 == "" && productOptions[indexPath.row].options3 == "" {
//                cell.attName.text = productOptions[indexPath.row].options1
//            }
//            else {
//                cell.attName.text = productOptions[indexPath.row].options2
//            }
//            
//            cell.delete_btn.tag = indexPath.row
//           
//            cell.attName.textColor = .black
//            cell.delete_btn.layer.cornerRadius = 5
//            cell.borderview.dropAttShadow()
//            
//            
//            return cell
//        }
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        if tableView == tableview {
//            
//            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 100))
//            
//            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
//            btn2.setImage(UIImage(named: "down"), for: .normal)
//           // btn2.addTarget(self, action: #selector(sayAction(_:)), for: .touchUpInside)
//            btn2.backgroundColor = .clear
//            
//            let btn1 = UIButton(frame: CGRect(x:10, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 50, height: 50))
//            btn1.titleLabel?.numberOfLines = 0
//            btn1.titleLabel?.lineBreakMode = .byWordWrapping
//            btn1.titleLabel?.adjustsFontSizeToFitWidth = true
//            btn1.titleLabel?.minimumScaleFactor = 0.5
//            
//            if mode == "add" {
//                if variantsArray.count == 1 {
//                    if arrOptVl3.count != 0 {
//                        btn1.setTitle("\(arrOptVl1[0])/\(arrOptVl2[0])/\(arrOptVl3[0])", for: .normal)
//                    }
//                    else if arrOptVl2.count != 0 {
//                        btn1.setTitle("\(arrOptVl1[0])/\(arrOptVl2[0])", for: .normal)
//                    }
//                    
//                    else if arrOptVl1.count != 0 {
//                        btn1.setTitle("\(arrOptVl1[0])", for: .normal)
//                    }
//                    else {
//                        if productOptions.count == 0 {
//                            btn1.setTitle("", for: .normal)
//                        }
//                        else {
//                            btn1.setTitle("\(productOptions[0].optionsvl1)/\(productOptions[0].optionsvl2)/\(productOptions[0].optionsvl3)", for: .normal)
//                        }
//                    }
//                }
//                else {
//                    btn1.setTitle("\(result[section])", for: .normal)
//                }
//            }
//            else {
//                if variantsArray.count == 0 {
//                    btn1.setTitle("\(editProd?.title ?? "")", for: .normal)
//                }
//                else {
//                    if result.count == 0 {
//                        btn1.setTitle("\(variantsArray[section].variant)", for: .normal)
//                    }
//                    else {
//                        btn1.setTitle("\(result[section])", for: .normal)
//                    }
//                }
//                
//            }
//            
//            btn1.setTitleColor(.black, for: .normal)
//            btn1.contentHorizontalAlignment = .left
//            btn1.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 18.0)!
//         //   btn1.addTarget(self, action: #selector(sayAction(_:)), for: .touchUpInside)
//            
//            btn1.tag = section
//            btn2.tag = section
//            headerView.addSubview(btn1)
//            headerView.addSubview(btn2)
//            
//            return headerView
//        }
//        
//        else if tableView == attTable {
//            return nil
//        }
//        
//        else {
//            return nil
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == tableview {
//            return UITableView.automaticDimension
//        }
//        
//        else if tableView == attTable{
//            return  73
//        }
//        
//        else {
//            return 50
//        }
//    }
//    
//    func sayAct(tag: Int) {
//        
//        if isSelectedData[tag] == true {
//            
//        }
//        else {
//            
//            for select in 0..<isSelectedData.count {
//                
//                if select == tag {
//                    isSelectedData[select] = true
//                }
//                else {
//                    isSelectedData[select] = false
//                }
//            }
//            tableview.reloadData()
//           
//        }
//    }
//    
//    @objc func sayAction(sender: UIButton){
//        
//        if mode == "add" {
//            
//            if variantsArray.count == 1 {
//                
//            }
//            
//            else {
//                
//                if isSelectedData[sender.tag] == true {
//                    isSelectedData[sender.tag] = false
//                    
//                    //decrease scroll height
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant = 550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant = 550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant =  550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant =  550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count)
//                        }
//                        
//                    }
//                }
//                
//                else {
//                    for select in 0..<isSelectedData.count {
//                        
//                        if isSelectedData[select] == true {
//                            isSelectedData[select].toggle()
//                        }
//                        else if select == sender.tag {
//                            isSelectedData[select].toggle()
//                        }
//                        else {
//                            print("")
//                        }
//                    }
//                    
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            scrollHeight.constant =  1300 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                        }
//                    }
//                }
//                tableview.reloadData()
//            }
//        }
//        //edit
//        else {
//            
//            if variantsArray.count == 0 {
//                
//            }
//            
//            else {
//                
//                if isSelectedData[sender.tag] == true {
//                    isSelectedData[sender.tag] = false
//                    
//                    //decrease scroll height
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant = 550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant = 550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                            
//                            scrollHeight.constant =  550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            
//                            scrollHeight.constant =  550 + 50 * CGFloat(variantsArray.count) + CGFloat(73 * productOptions.count)
//                        }
//                        
//                    }
//                }
//                
//                else {
//                    for select in 0..<isSelectedData.count {
//                        
//                        if isSelectedData[select] == true {
//                            isSelectedData[select].toggle()
//                        }
//                        else if select == sender.tag {
//                            isSelectedData[select].toggle()
//                        }
//                        else {
//                            print("")
//                        }
//                    }
//                    if cat_coll_height.constant > 53.0 {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + tax_coll_height.constant + 20
//                        }
//                        
//                        else {
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) + cat_coll_height.constant + 10
//                        }
//                    }
//                    else {
//                        
//                        if tax_coll_height.constant > 53.0 {
//                         
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count) +
//                            tax_coll_height.constant + 10
//                        }
//                        
//                        else {
//                            scrollHeight.constant =  1350 + 50 * CGFloat(variantsArray.count - 1) + CGFloat(73 * productOptions.count)
//                        }
//                    }
//                }
//                tableview.reloadData()
//            }
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        if tableView == tableview {
//            
//            
//        }
//        
//        else if tableView == attTable {
//            
//            if mode == "add" {
//                goMode = "cellClick"
//                let index = indexPath.row
//                inventoryOpt = productOptions[index]
//                addattrIndex = index
//            }
//            
//            else {
//                let index = indexPath.row
//                print(productOptions.count)
//
//                if index == 0 {
//                    
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    if productOptions.count == 1 {}
//                    else if productOptions.count == 2 {
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                    else {
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                        arrOptVl3 = productOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                }
//                else if index == 1 {
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    
//                    if productOptions.count == 1 {}
//                    else if productOptions.count == 2 {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                        arrOptVl3 = productOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                }
//                
//                else {
//                    inventoryOpt = productOptions[index]
//                    addattrIndex = index
//                    
//                    if productOptions.count == 1 {
//                    }
//                    else if productOptions.count == 2 {}
//                    else {
//                        arrOptVl1 = productOptions[0].optionsvl1.components(separatedBy: ",")
//                        arrOptVl2 = productOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//            }
//            performSegue(withIdentifier: "toAddVarAttri", sender: nil)
//        }
//    }
//}
