////
////  DuplicateViewController.swift
////  
////
////  Created by Jamaluddin Syed on 1/3/24.
////
//
//import UIKit
//import MaterialComponents
//import DropDown
//import BarcodeScanner
//
//protocol MyDataSendingDelegate: AnyObject {
//    
//    func getSelCats(arr: [InventoryCategory], dupclose: String, catmode: String)
//}
//
//class DuplicateViewController: UIViewController, MyDataSendingDelegate {
//    
//    
//    @IBOutlet weak var productName: MDCOutlinedTextField!
//    @IBOutlet weak var descField: MDCOutlinedTextField!
//    @IBOutlet weak var catView: UIView!
//    @IBOutlet weak var catColl: UICollectionView!
//    @IBOutlet weak var taxescoll: UICollectionView!
//    @IBOutlet weak var attributeTable: UITableView!
//    @IBOutlet weak var variantsTable: UITableView!
//    @IBOutlet weak var addAttrBtn: UIButton!
//    @IBOutlet weak var addAttrBtnHeight: NSLayoutConstraint!
//    @IBOutlet weak var attHeight: NSLayoutConstraint!
//    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
//    @IBOutlet weak var dupcatCollHeight: NSLayoutConstraint!
//    @IBOutlet weak var dupTaxCollHeight: NSLayoutConstraint!
//    @IBOutlet weak var cancelBtn: UIButton!
//    @IBOutlet weak var saveBtn: UIButton!
//    
//    @IBOutlet weak var genUpcLbl: UILabel!
//    
//    var activeTextField = UITextField()
//    var scanDupIndex = 0
//    private var isDupSymbolOnRight = false
//    
//    var duplicateProdCat = [InventoryCategory]()
//    var duplicateProdOptions = [InventoryOptions]()
//    var duplicateTaxes = [SetupTaxes]()
//    var duplicateTableTaxes = [SetupTaxes]()
//    var duplicateTaxNames = [String]()
//    var duplicateVariants = [ProductById]()
//    var duplicateArrTax = [SetupTaxes]()
//    var catsDupAddArr = [InventoryCategory]()
//    var dupClose = String()
//    var dupInventoryOpt: InventoryOptions?
//    
//    var duplicateSelectedData = [Bool]()
//    var singleProd: ProductById?
//    var dupMenu = DropDown()
//    
//    var catMode = ""
//    var dupVariantMode = ""
//    var dupGoMode = "dup"
//    
//    var dupAddAttrIndex = 0
//    var dupAddCombo = 0
//    var dupResult = [String]()
//    
//    var dupAttNameArray = [InventoryOptions]()
//    
//    var dupArrOptVl1 = [String]()
//    var dupArrOptVl2 = [String]()
//    var dupArrOptVl3 = [String]()
//    
//    let loadIndicator: ProgressView = {
//        let progress = ProgressView(colors: [.white], lineWidth: 3)
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        return progress
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        createCustomTextField(textField: productName)
//        createCustomTextField(textField: descField)
//        
//        productName.label.text = "Product Name"
//        descField.label.text = "Description"
//        
//        catView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
//        catView.layer.borderWidth = 1.0
//        catView.layer.cornerRadius = 5
//        catColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
//        catColl.layer.borderWidth = 1.0
//        catColl.layer.cornerRadius = 5
//        
//        cancelBtn.layer.cornerRadius = 10
//        saveBtn.layer.cornerRadius = 10
//        
//        cancelBtn.layer.borderColor = UIColor.black.cgColor
//        cancelBtn.layer.borderWidth = 1.0
//        
//        let tapTax = UITapGestureRecognizer(target: self, action: #selector(openDropDup))
//        taxescoll.addGestureRecognizer(tapTax)
//        tapTax.numberOfTapsRequired = 1
//        taxescoll.isUserInteractionEnabled = true
//        
//        let tapCat = UITapGestureRecognizer(target: self, action: #selector(openDup))
//        catView.addGestureRecognizer(tapCat)
//        tapCat.numberOfTapsRequired = 1
//        catView.isUserInteractionEnabled = true
//        
//        let columnLayout = CustomFlowLayout()
//        catColl.collectionViewLayout = columnLayout
//        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        
//        let colLayout = CustomFlowLayout()
//        taxescoll.collectionViewLayout = colLayout
//        colLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        
//        addAttrBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
//        addAttrBtn.layer.borderWidth = 1.0
//        addAttrBtn.layer.cornerRadius = 5
//        addAttrBtn.backgroundColor = .white
//        
//        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(dupGenUpc))
//        genUpcLbl.addGestureRecognizer(tapUpc)
//        tapUpc.numberOfTapsRequired = 1
//        genUpcLbl.isUserInteractionEnabled = true
//        
//        productName.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        setUI()
//       
//        if duplicateProdOptions.count < 3 {
//            addAttrBtn.isHidden = false
//            addAttrBtnHeight.constant = 45
//        }
//        
//        else {
//            addAttrBtn.isHidden = true
//            addAttrBtnHeight.constant = 0
//        }
//        
//        
//        if dupAddCombo == 0 {
//            
//            if duplicateVariants.count == 0 {
//                
//                let emptyProd = ProductById(alternateName: "\(singleProd?.alternateName ?? "")",
//                                            admin_id: "\(singleProd?.admin_id ?? "")",
//                                            description: "\(singleProd?.description ?? "")",
//                                            starting_quantity: "\(singleProd?.starting_quantity ?? "")",
//                                            margin: "\(singleProd?.margin ?? "")", 
//                                            brand: "\(singleProd?.brand ?? "")", tags: "\(singleProd?.tags ?? "")",
//                                            upc: "\(singleProd?.upc ?? "")",
//                                            id: "\(singleProd?.id ?? "")", sku: "\(singleProd?.sku ?? "")",
//                                            disable: "\(singleProd?.disable ?? "")", food_stampable: "\(singleProd?.food_stampable ?? "")",
//                                            isvarient: "\(singleProd?.isvarient ?? "")", title: "\(singleProd?.title ?? "")",
//                                            quantity: "\(singleProd?.quantity ?? "")",
//                                            ischargeTax: "\(singleProd?.ischargeTax ?? "")", 
//                                            updated_on: "\(singleProd?.updated_on ?? "")", 
//                                            isstockcontinue: "\(singleProd?.isstockcontinue ?? "")",
//                                            trackqnty: "\(singleProd?.trackqnty ?? "")", profit: "\(singleProd?.profit ?? "")",
//                                            custom_code: "\(singleProd?.custom_code ?? "")",
//                                            assigned_vendors: "\(singleProd?.assigned_vendors ?? "")",
//                                            barcode: "\(singleProd?.barcode ?? "")",
//                                            country_region: "\(singleProd?.country_region ?? "")",
//                                            ispysical_product: "\(singleProd?.alternateName ?? "")", 
//                                            show_status: "\(singleProd?.show_status ?? "")",
//                                            HS_code: "\(singleProd?.HS_code ?? "")", price: "\(singleProd?.price ?? "")",
//                                            featured_product: "\(singleProd?.featured_product ?? "")",
//                                            merchant_id: "\(singleProd?.merchant_id ?? "")",
//                                            created_on: "\(singleProd?.created_on ?? "")",
//                                            prefferd_vendor: "\(singleProd?.prefferd_vendor ?? "")",
//                                            reorder_cost: "\(singleProd?.reorder_cost ?? "")",
//                                            other_taxes: "\(singleProd?.other_taxes ?? "")",
//                                            buy_with_product: "\(singleProd?.buy_with_product ?? "")",
//                                            costperItem: "\(singleProd?.costperItem ?? "")",
//                                            is_tobacco: "\(singleProd?.is_tobacco ?? "")",
//                                            product_doc: "\(singleProd?.product_doc ?? "")",
//                                            user_id: "\(singleProd?.user_id ?? "")",
//                                            media: "\(singleProd?.media ?? "")",
//                                            compare_price: "\(singleProd?.compare_price ?? "")",
//                                            loyalty_product_id: "\(singleProd?.loyalty_product_id ?? "")",
//                                            show_type: "\(singleProd?.show_type ?? "")",
//                                            cotegory: "\(singleProd?.cotegory ?? "")",
//                                            reorder_level: "\(singleProd?.reorder_level ?? "")",
//                                            env: "\(singleProd?.env ?? "")",
//                                            variant: "\(singleProd?.variant ?? "")",
//                                            reorder_qty: "\(singleProd?.reorder_qty ?? "")", purchase_qty: "\(singleProd?.purchase_qty ?? "")")
//                
//                duplicateVariants.append(emptyProd)
//            }
//        }
//        else {
//            dupAdjustAttributes()
//           
//            if dupAddCombo == 1 {
//                for variants in 0..<duplicateVariants.count {
//                    
//                    let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "", 
//                                                brand: "", tags: "", upc: "",
//                                                id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "", title: "", quantity: "", ischargeTax: "",
//                                                updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                                assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
//                                                show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
//                                                created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
//                                                buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
//                                                media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
//                                                reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
//                    
//                    duplicateVariants[variants] = emptyProd
//                    
//                }
//            }
//        }
//        
//        var isSel = [Bool]()
//        for i in 0..<duplicateVariants.count {
//            
//            if i == 0 {
//                isSel.append(true)
//            }
//            else {
//                isSel.append(false)
//            }
//        }
//        duplicateSelectedData = isSel
//        variantsTable.reloadData()
//        
//        print(duplicateSelectedData)
//        
//        if catMode == "back" {
//            if !UserDefaults.standard.bool(forKey: "tax_add_var") {
//                setupTaxApi()
//            }
//        }
//        
//        print(duplicateProdCat)
//        if catMode == "back" {
//        }
//        else {
//            if dupClose == "false" {
//                duplicateProdCat = catsDupAddArr
//            }
//        }
//        catColl.reloadData()
//        
//        refreshDupCategoryColl()
//        
//        variantsTable.separatorStyle = .none
//        
//        addAttrBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
//        addAttrBtn.layer.borderWidth = 1.0
//        addAttrBtn.layer.cornerRadius = 5
//        addAttrBtn.backgroundColor = .white
//        
//        attributeTable.estimatedSectionHeaderHeight = 0
//        attributeTable.estimatedSectionFooterHeight = 0
//        
//    }
//    
//    @objc func dupGenUpc() {
//        
//        var upcCode = ""
//        
//        for upc in 0..<duplicateVariants.count {
//            
//            if duplicateVariants[upc].upc == "" {
//                upcCode = getGeneratedUpc(length: 20)
//                duplicateVariants[upc].upc = upcCode
//            }
//        }
//        variantsTable.reloadData()
//    }
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
//    
//    func setDupMenu() {
//        
//        dupMenu.dataSource = duplicateTaxNames
//        dupMenu.backgroundColor = .white
//        dupMenu.anchorView = taxescoll
//        dupMenu.separatorColor = .black
//        dupMenu.layer.cornerRadius = 10.0
//        dupMenu.selectionAction = { index, title in
//            
//            if self.duplicateTaxes.count == 0 {
//                self.duplicateTaxes.append(self.duplicateTableTaxes[index])
//                self.dupMenu.deselectRow(at: index)
//            }
//            else {
//                if self.duplicateTaxes.contains(where: {$0.id == self.duplicateTableTaxes[index].id}) {
//                    self.dupMenu.deselectRow(at: index)
//                }
//                else {
//                    self.duplicateTaxes.append(self.duplicateTableTaxes[index])
//                    self.dupMenu.deselectRow(at: index)
//                }
//            }
//            self.taxescoll.reloadData()
//        }
//    }
//    
//    func refreshDupCategoryColl() {
//        
//        if duplicateProdCat.count == 0 {
//            catColl.isHidden = true
//            catView.isHidden = false
//            dupcatCollHeight.constant = 53.0
//            self.view.layoutIfNeeded()
//        }
//        else {
//            let height = catColl.collectionViewLayout.collectionViewContentSize.height
//            dupcatCollHeight.constant = height
//            self.view.layoutIfNeeded()
//            
//            let h1 = taxescoll.collectionViewLayout.collectionViewContentSize.height
//            dupTaxCollHeight.constant = h1
//            self.view.layoutIfNeeded()
//            
//            catColl.isHidden = false
//            catView.isHidden = true
//        }
//        
//        attHeight.constant = CGFloat(73 * duplicateProdOptions.count)
//        
//        if dupcatCollHeight.constant > 53.0 {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//            }
//           
//        }
//        else {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupTaxCollHeight.constant + 10
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//            }
//        }
//    }
//    
//    func collDupSubviews() {
//        
//        self.setDupcollectionHeight()
//    }
//    
//    func setDupcollectionHeight() {
//        
//        let height = catColl.collectionViewLayout.collectionViewContentSize.height
//        dupcatCollHeight.constant = height
//        self.view.layoutIfNeeded()
//        
//        if dupcatCollHeight.constant > 53.0 {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//            }
//            
//        }
//        else {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupTaxCollHeight.constant + 10
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//            }
//        }
//    }
//    
//    
//    func dupTaxSubviews() {
//        
//        self.setDupTaxcollectionHeight()
//    }
//    
//    func setDupTaxcollectionHeight() {
//
//        let height = taxescoll.collectionViewLayout.collectionViewContentSize.height
//        dupTaxCollHeight.constant = height
//        self.view.layoutIfNeeded()
//        
//        if dupcatCollHeight.constant > 53.0 {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//            }
//            
//        }
//        else {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupTaxCollHeight.constant + 10
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//            }
//        }
//
//    }
//    
//    func setupTaxApi() {
//        
//        let m_id  = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
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
//        duplicateTableTaxes = taxArray
//        
//        var taxName = [String]()
//        
//        for tax in duplicateTableTaxes {
//            taxName.append(tax.title)
//        }
//        
//        duplicateTaxNames = taxName
//        
//        setDupMenu()
//        taxescoll.reloadData()
//    }
//    
//    @objc func openDropDup() {
//        
//        dupMenu.show()
//    }
//    
//    @objc func openDup() {
//        
//        openDupCat()
//    }
//    
//    
//    
//    @IBAction func addAttrClick(_ sender: UIButton) {
//        
//        dupAttNameArray = duplicateProdOptions
//        
//        let index = duplicateProdOptions.count
//        if index == 0 {
//            dupAddAttrIndex = index
//        }
//        else if index == 1 {
//            dupAddAttrIndex = index
//            
//            if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//            }
//            else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//            }
//            else {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//            }
//        }
//    
//        else {
//            dupAddAttrIndex = index
//            
//            if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//            }
//            else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//            }
//            else {
//                dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//            }
//            
//            if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//            }
//            else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//            }
//            else {
//                dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//            }
//        }
//        performSegue(withIdentifier: "dupToAddVar", sender: nil)
//    }
//    
//    
//    @IBAction func dupCatClick(_ sender: UIButton) {
//        
//        openDupCat()
//    }
//    
//    func getSelCats(arr: [InventoryCategory], dupclose: String, catmode: String) {
//        dupClose = dupclose
//        if dupclose == "false" {
//            catsDupAddArr = arr
//        }
//        catMode = catmode
//    }
//    
//    func dupData(optName :String, optValue: String, editele: [String]) {
//        
//        if dupGoMode == "dupAddBtn" {
//            
//            if dupAddAttrIndex == 0 {
//                let opt = InventoryOptions(id: "", product_id: "", options1: optName, optionsvl1: optValue, options2: "",
//                                           optionsvl2: "", options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                duplicateProdOptions.append(opt)
//                
//                dupArrOptVl1 = optValue.components(separatedBy: ",")
//            }
//            
//            else if dupAddAttrIndex == 1 {
//                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: optName,
//                                           optionsvl2: optValue, options3: "", optionsvl3: "", merchant_id: "", admin_id: "")
//                duplicateProdOptions.append(opt)
//                dupArrOptVl2 = optValue.components(separatedBy: ",")
//            }
//            
//            else if dupAddAttrIndex == 2 {
//                let opt = InventoryOptions(id: "", product_id: "", options1: "", optionsvl1: "", options2: "", optionsvl2: "",
//                                           options3: optName, optionsvl3: optValue, merchant_id: "", admin_id: "")
//                
//                duplicateProdOptions.append(opt)
//                dupArrOptVl3 = optValue.components(separatedBy: ",")
//                addAttrBtn.isHidden = true
//                addAttrBtnHeight.constant = 0
//            }
//            
//            else {
//                addAttrBtn.isHidden = true
//                addAttrBtnHeight.constant = 0
//            }
//        }
//        
//        else {
//            //dupcellclick
//            
//            if dupAddAttrIndex == 0 {
//                duplicateProdOptions[dupAddAttrIndex].optionsvl1 = optValue
//                dupArrOptVl1 = optValue.components(separatedBy: ",")
//            }
//            
//            else if dupAddAttrIndex == 1 {
//                duplicateProdOptions[dupAddAttrIndex].optionsvl2 = optValue
//                dupArrOptVl2 = optValue.components(separatedBy: ",")
//            }
//            
//            else if dupAddAttrIndex == 2 {
//                duplicateProdOptions[dupAddAttrIndex].optionsvl3 = optValue
//                dupArrOptVl3 = optValue.components(separatedBy: ",")
//            }
//        }
//        
//        dupAddCombo = 1
//        attHeight.constant = CGFloat(73 * duplicateProdOptions.count)
//        attributeTable.reloadData()
//    }
//    
//    func dupAdjustAttributes() {
//        
//        print(dupArrOptVl1)
//        print(dupArrOptVl2)
//        print(dupArrOptVl3)
//        
//        if duplicateProdOptions.count > 0 {
//            
//            
//            if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 0 && dupArrOptVl3.count == 0 {
//                
//                duplicateVariants[0].title = dupArrOptVl1[0]
//                
//                dupResult = dupArrOptVl1
//                
//                let resultCount = duplicateVariants.count - 1
//                duplicateVariants.removeLast(resultCount)
//                
//            }
//            
//            else if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 1 && dupArrOptVl3.count == 0 {
//                
//                duplicateVariants[0].title = "\(dupArrOptVl1[0])/\(dupArrOptVl2[0])"
//                
//                dupResult = dupArrOptVl1.flatMap { s1 in
//                    dupArrOptVl2.map { s2 in
//                        "\(s1)/\(s2)"
//                    }
//                }
//                
//                let resultCount = duplicateVariants.count - 1
//                duplicateVariants.removeLast(resultCount)
//                
//                
//            }
//            
//            else if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 1 && dupArrOptVl3.count == 1 {
//                
//                duplicateVariants[0].title = "\(dupArrOptVl1[0])/\(dupArrOptVl2[0])/\(dupArrOptVl3[0])"
//                
//                dupResult = dupArrOptVl1.flatMap { s1 in
//                    dupArrOptVl2.flatMap { s2 in
//                        dupArrOptVl3.map { s3 in
//                            "\(s1)/\(s2)/\(s3)"
//                        }
//                    }
//                }
//                
//                let resultCount = duplicateVariants.count - 1
//                duplicateVariants.removeLast(resultCount)
//            }
//            
//            else {
//                
//                if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 0 && dupArrOptVl3.count == 0 {
//                    
//                    duplicateVariants[0].title = dupArrOptVl1[0]
//                    
//                    
//                    
//                    let resultCount = duplicateVariants.count - 1
//                    duplicateVariants.removeLast(resultCount)
//                    
//                }
//                
//                else if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 1 && dupArrOptVl3.count == 0 {
//                    
//                    duplicateVariants[0].title = "\(dupArrOptVl1[0])/\(dupArrOptVl2[0])"
//                    
//                    dupResult = dupArrOptVl1.flatMap { s1 in
//                        dupArrOptVl2.map { s2 in
//                            "\(s1)/\(s2)"
//                        }
//                    }
//                    
//                    let resultCount = duplicateVariants.count - 1
//                    duplicateVariants.removeLast(resultCount)
//                    
//                    
//                }
//                
//                else if dupArrOptVl1.count == 1 && dupArrOptVl2.count == 1 && dupArrOptVl3.count == 1 {
//                    
//                    duplicateVariants[0].title = "\(dupArrOptVl1[0])/\(dupArrOptVl2[0])/\(dupArrOptVl3[0])"
//                    
//                    dupResult = dupArrOptVl1.flatMap { s1 in
//                        dupArrOptVl2.flatMap { s2 in
//                            dupArrOptVl3.map { s3 in
//                                "\(s1)/\(s2)/\(s3)"
//                            }
//                        }
//                    }
//                    
//                    
//                    let resultCount = duplicateVariants.count - 1
//                    duplicateVariants.removeLast(resultCount)
//                }
//                
//                if dupArrOptVl1.count > 0 && dupArrOptVl2.count > 0 &&  dupArrOptVl3.count == 0 {
//                    
//                    dupResult = dupArrOptVl1.flatMap { s1 in
//                        dupArrOptVl2.map { s2 in
//                            "\(s1)/\(s2)"
//                        }
//                    }
//                    
//                    print(dupResult)
//                    print(dupResult.count)
//                    print(duplicateVariants.count)
//                    
//                    var resCount = 0
//                    
//                    if dupResult.count > duplicateVariants.count {
//                        resCount = dupResult.count - duplicateVariants.count
//                        
//                        for _ in 0..<resCount {
//                            
//                            duplicateVariants.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
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
//                        }
//                        for va in 0..<duplicateVariants.count {
//                            print()
//                            if duplicateVariants[va].variant == "" {
//                                duplicateVariants[va].variant = dupResult[va]
//                            }
//                        }
//                    }
//                    else if dupResult.count < duplicateVariants.count {
//                        resCount = duplicateVariants.count - dupResult.count
//                        
//                        duplicateVariants.removeLast(resCount)
//                    }
//                    else {
//                        
//                    }
//                }
//                
//                
//                else if dupArrOptVl1.count > 0 && dupArrOptVl2.count == 0 && dupArrOptVl3.count == 0 {
//                    
//                    
//                    dupResult = dupArrOptVl1
//                    
//                    var resCount = 0
//                    
//                    if dupResult.count > duplicateVariants.count {
//                        resCount = dupResult.count - duplicateVariants.count
//                        
//                        for _ in 0..<resCount {
//                            
//                            duplicateVariants.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
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
//                        }
//                        for va in 0..<duplicateVariants.count {
//                            
//                            if duplicateVariants[va].variant == "" {
//                                duplicateVariants[va].variant = dupResult[va]
//                            }
//                        }
//                    }
//                    else if dupResult.count < duplicateVariants.count {
//                        resCount = duplicateVariants.count - dupResult.count
//                        
//                        duplicateVariants.removeLast(resCount)
//                    }
//                    else {
//                        
//                    }
//                    print(dupResult)
//                }
//                
//                else {
//                    
//                    dupResult = dupArrOptVl1.flatMap { s1 in
//                        dupArrOptVl2.flatMap { s2 in
//                            dupArrOptVl3.map { s3 in
//                                "\(s1)/\(s2)/\(s3)"
//                            }
//                        }
//                    }
//                    print(dupResult)
//                    
//                    var resCount = 0
//                    
//                    if dupResult.count > duplicateVariants.count {
//                        resCount = dupResult.count - duplicateVariants.count
//                        
//                        for _ in 0..<resCount {
//                            
//                            duplicateVariants.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "",
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
//                        }
//                        for va in 0..<duplicateVariants.count {
//                            
//                            if duplicateVariants[va].variant == "" {
//                                duplicateVariants[va].variant = dupResult[va]
//                            }
//                        }
//                    }
//                    else if dupResult.count < duplicateVariants.count {
//                        resCount = duplicateVariants.count - dupResult.count
//                        
//                        duplicateVariants.removeLast(resCount)
//                    }
//                    else {
//                        
//                    }
//                }
//            }
//        }
//        
//        else {
//            
//            var resCount = 0
//            print(duplicateVariants.count)
//            print(dupResult.count)
//            resCount = duplicateVariants.count - 1
//            
//            duplicateVariants.removeLast(resCount)
//        }
//        
//        print(duplicateVariants.count)
//        attHeight.constant = CGFloat(73 * duplicateProdOptions.count)
//        
//        if dupcatCollHeight.constant > 53.0 {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//            }
//            
//            else {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//            }
//            
//        }
//        else {
//            
//            if dupTaxCollHeight.constant > 53.0 {
//                
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) +
//                dupTaxCollHeight.constant + 10
//            }
//            
//            else {
//                scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//            }
//        }
//        print(scrollHeight.constant)
//    }
//    
//    func openDupCat() {
//        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
//        
//        vc.catMode = "dupProductVC"
//        vc.selectCategory = duplicateProdCat
//        let transition = CATransition()
//        transition.duration = 0.7
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController?.view.layer.add(transition, forKey: nil)
//        self.navigationController?.pushViewController(vc, animated: false)
//        
//    }
//    
//    
//    @IBAction func dupTrackQtyClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            
//            duplicateVariants[sender.tag].trackqnty = "1"
//            
//            
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            duplicateVariants[sender.tag].trackqnty = "0"
//        }
//    }
//    
//    
//    @IBAction func dupSellClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            duplicateVariants[sender.tag].isstockcontinue = "1"
//            
//            
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            duplicateVariants[sender.tag].isstockcontinue = "0"
//        }
//    }
//    
//    
//    @IBAction func dupCheckIdClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            duplicateVariants[sender.tag].is_tobacco = "1"
//            
//            
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            duplicateVariants[sender.tag].is_tobacco = "0"
//        }
//    }
//    
//    
//    @IBAction func dupDisableClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            duplicateVariants[sender.tag].disable = "1"
//            
//            
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            duplicateVariants[sender.tag].disable = "0"
//        }
//    }
//    
//    
//    @IBAction func dubFoodClick(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "uncheck inventory") {
//            sender.setImage(UIImage(named: "check inventory"), for: .normal)
//            duplicateVariants[sender.tag].food_stampable = "1"
//            
//            
//        }
//        else {
//            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            duplicateVariants[sender.tag].food_stampable = "0"
//        }
//        
//    }
//    
//    @IBAction func backBtnClick(_ sender: UIButton) {
//        
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func dupTaxCloseClick(_ sender: UIButton) {
//        
//        let position = sender.tag
//        duplicateTaxes.remove(at: position)
//        taxescoll.reloadData()
//        
//    }
//    
//    
//    @IBAction func catCloseBtn(_ sender: UIButton) {
//        
//        if sender.currentImage == UIImage(named: "white close") {
//           
//            let position = sender.tag
//            duplicateProdCat.remove(at: position)
//            if duplicateProdCat.count == 0 {
//                refreshDupCategoryColl()
//            }
//            else {
//                catColl.reloadData()
//            }
//        }
//        
//        else {
//            openDupCat()
//        }
//    }
//    
//    
//    @IBAction func deleteBtnClick(_ sender: UIButton) {
//        
//        if dupArrOptVl1.count == 0 {
//            
//            if duplicateProdOptions.count == 1 {
//                
//                if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                }
//            }
//            
//            else if duplicateProdOptions.count == 2 {
//                if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                }
//                
//                if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                }
//                
//            }
//            
//            else {
//                if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                }
//                
//                if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                }
//                
//                if duplicateProdOptions[2].optionsvl1 == "" && duplicateProdOptions[2].optionsvl2 == "" {
//                    dupArrOptVl3 = duplicateProdOptions[2].optionsvl3.components(separatedBy: ",")
//                }
//                else if duplicateProdOptions[2].optionsvl2 == "" && duplicateProdOptions[2].optionsvl3 == "" {
//                    dupArrOptVl3 = duplicateProdOptions[2].optionsvl1.components(separatedBy: ",")
//                }
//                else {
//                    dupArrOptVl3 = duplicateProdOptions[2].optionsvl2.components(separatedBy: ",")
//                }
//            }
//        }
//                
//        if sender.currentImage == UIImage(named: "red_delete") {
//            
//            let position = sender.tag
//            duplicateProdOptions.remove(at: position)
//            
//            if position == 0 {
//                print(position)
//                dupArrOptVl1 = dupArrOptVl2
//                dupArrOptVl2 = dupArrOptVl3
//                dupArrOptVl3 = []
//            }
//            
//            else if position == 1 {
//                print(position)
//                dupArrOptVl2 = dupArrOptVl3
//                dupArrOptVl3 = []
//            }
//            
//            else {
//                dupArrOptVl3 = []
//            }
//            attributeTable.reloadData()
//            attHeight.constant = CGFloat(73 * duplicateProdOptions.count)
//            
//            if duplicateProdOptions.count < 3 {
//                addAttrBtn.isHidden = false
//                addAttrBtnHeight.constant = 45
//            }
//            else {
//                addAttrBtn.isHidden = true
//                addAttrBtnHeight.constant = 0
//            }
//            dupAdjustAttributes()
//                        
//            for variants in 0..<duplicateVariants.count {
//                
//                let emptyProd = ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "", 
//                                            brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0", isvarient: "", title: "", quantity: "", ischargeTax: "",
//                                            updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
//                                            assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
//                                            show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
//                                            created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
//                                            buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
//                                            media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
//                                            reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: "")
//                
//                duplicateVariants[variants] = emptyProd
//                
//            }
//            variantsTable.reloadData()
//            
//            if dupcatCollHeight.constant > 53.0 {
//                
//                if dupTaxCollHeight.constant > 53.0 {
//                    
//                    scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 10
//                }
//                
//                else {
//                    scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//                }
//            }
//            else {
//                
//                if dupTaxCollHeight.constant > 53.0 {
//                 
//                    scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupTaxCollHeight.constant + 10
//                }
//                
//                else {
//                    scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//                    
//                }
//            }
//        }
//        
//        else {
//            print("white")
//        }
//    }
//    
//    
//    
//    
//    @IBAction func openScanDup(_ sender: UIButton) {
//        
//        scanDupIndex = sender.tag
//        
//        let vc = BarcodeScannerViewController()
//        vc.codeDelegate = self
//        vc.errorDelegate = self
//        vc.dismissalDelegate = self
//        
//        self.present(vc, animated: true)
//    }
//    
//    
//    
//    @IBAction func homeBtnClick(_ sender: UIButton) {
//        
//        var destiny = 0
//        
//        let viewcontrollerArray = navigationController?.viewControllers
//        
//        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
//            destiny = destinationIndex
//        }
//        
//        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
//    }
//    
//}
//
//extension DuplicateViewController: UITextFieldDelegate {
//    
//    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        
//        
//        if textField == productName {
//            
//        }
//        
//        else {
//            
//            let index = IndexPath(row: 0, section: textField.tag)
//            let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//            
//            
//            if textField == cell.dupCostPer {
//                
//                let cost_per_value = UserDefaults.standard.string(forKey: "cost_per_value") ?? "0"
//                let cost_per_item = textField.text ?? ""
//                
//                guard cost_per_item != "" else {
//                    return
//                }
//                
//                if cost_per_value == "" || cost_per_value == "0.00" {
//                    
//                    let price = "0.00"
//                    let profit = "0.00"
//                    let margin = "0.00"
//                    
//                    duplicateVariants[index.section].costperItem = cost_per_item
//                    duplicateVariants[index.section].price = price
//                    duplicateVariants[index.section].margin = margin
//                    duplicateVariants[index.section].profit = profit
//                    
//                    for variants in 0..<duplicateVariants.count {
//                        
//                        if duplicateVariants[variants].costperItem == "0.00" {
//                            duplicateVariants[variants].costperItem = cost_per_item
//                            duplicateVariants[variants].price = price
//                            duplicateVariants[index.section].margin = margin
//                            duplicateVariants[index.section].profit = profit
//                        }
//                    }
//                    variantsTable.reloadData()
//                }
//                
//                else {
//                    
//                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
//                    let percent = cost_per_value_doub/100
//                    
//                    let cost_per_item_doub = Double(cost_per_item) ?? 0.00
//                    let profit = cost_per_item_doub * percent
//                    let price = cost_per_item_doub + profit
//                    let margin = (profit / price) * 100
//                    
//                    duplicateVariants[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
//                    duplicateVariants[index.section].price = String(format: "%.2f", price)
//                    duplicateVariants[index.section].margin = String(format: "%.2f", margin)
//                    duplicateVariants[index.section].profit = String(format: "%.2f", profit)
//                    
//                    print(duplicateVariants.count)
//                    for variants in 0..<duplicateVariants.count {
//                        
//                        if duplicateVariants[variants].costperItem == "0.00" {
//                            duplicateVariants[variants].costperItem = cost_per_item
//                            duplicateVariants[variants].price = String(format: "%.2f", price)
//                            duplicateVariants[variants].margin = String(format: "%.2f", margin)
//                            duplicateVariants[variants].profit = String(format: "%.2f", profit)
//                        }
//                    }
//                    variantsTable.reloadData()
//                }
//            }
//            
//            else if textField == cell.dupprice {
//                
//                let price = cell.dupprice.text ?? "0.00"
//                duplicateVariants[index.section].price = price
//                let cpi = duplicateVariants[index.section].costperItem
//                
//                let cost_per_doub = Double(cpi) ?? 0.00
//                let price_doub = Double(price) ?? 0.00
//                
//                if cost_per_doub == 0.00 {
//                    let profit = ""
//                    let margin = ""
//                    duplicateVariants[index.section].margin = String(format: "%.2f", margin)
//                    duplicateVariants[index.section].profit = String(format: "%.2f", profit)
//                    
//                    for variants in 0..<duplicateVariants.count {
//                        
//                        if duplicateVariants[variants].price == "0.00" {
//                            duplicateVariants[variants].price = price
//                            duplicateVariants[index.section].margin = String(format: "%.2f", margin)
//                            duplicateVariants[index.section].profit = String(format: "%.2f", profit)
//                        }
//                    }
//                }
//                else {
//                    let profit = price_doub - cost_per_doub
//                    let margin = (profit / price_doub) * 100
//                    duplicateVariants[index.section].margin = String(format: "%.2f", margin)
//                    duplicateVariants[index.section].profit = String(format: "%.2f", profit)
//                    
//                    for variants in 0..<duplicateVariants.count {
//                        
//                        if duplicateVariants[variants].price == "0.00" {
//                            duplicateVariants[variants].price = price
//                            duplicateVariants[index.section].margin = String(format: "%.2f", margin)
//                            duplicateVariants[index.section].profit = String(format: "%.2f", profit)
//                        }
//                    }
//                }
//                variantsTable.reloadData()
//                
//            }
//            else if textField == cell.dupCompare {
//                
//                let cprice = cell.dupCompare.text ?? ""
//                duplicateVariants[index.section].compare_price = cprice
//                variantsTable.reloadData()
//                
//                for variants in 0..<duplicateVariants.count {
//                    
//                    if duplicateVariants[variants].compare_price == "" {
//                        duplicateVariants[variants].compare_price = cprice
//                    }
//                }
//                variantsTable.reloadData()
//            }
//            else if textField == cell.dupQty {
//                
//                let quty = cell.dupQty.text ?? ""
//                duplicateVariants[index.section].quantity = quty
//                variantsTable.reloadData()
//                
//                for variants in 0..<duplicateVariants.count {
//                    
//                    if duplicateVariants[variants].quantity == "" {
//                        duplicateVariants[variants].quantity = quty
//                    }
//                }
//                variantsTable.reloadData()
//            }
//            else if textField == cell.dupCustom {
//                let custom = cell.dupCustom.text ?? ""
//                duplicateVariants[index.section].custom_code = custom
//                variantsTable.reloadData()
//            }
//            else if textField == cell.dupReorderQty {
//                let reqty = cell.dupReorderQty.text ?? ""
//                duplicateVariants[index.section].reorder_qty = reqty
//                variantsTable.reloadData()
//            }
//            else if textField == cell.dupReorderLevel {
//                let relevel = cell.dupReorderLevel.text ?? ""
//                duplicateVariants[index.section].reorder_level = relevel
//                variantsTable.reloadData()
//            }
//            else if textField == cell.dupUpcCode {
//                
//                let upcText = cell.dupUpcCode.text ?? ""
//                
//                if upcText == "" {
//                    duplicateVariants[index.section].upc = ""
//                }
//                else {
//                    
//                    let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//                    
//                    if upcUnique.contains(upcText) {
//                        showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                        cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//                        cell.dupUpcCode.text = ""
//                        duplicateVariants[index.section].upc = ""
//                    }
//                    else {
//                        
//                        if duplicateVariants.contains(where: {$0.upc == upcText}) {
//                            
//                            if textField.tag  == duplicateVariants.firstIndex(where: {$0.upc == upcText}) {
//                                
//                                duplicateVariants[index.section].upc = upcText
//                                variantsTable.reloadData()
//                            }
//                            else {
//                                
//                                showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                                cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//                                cell.dupUpcCode.text = ""
//                                duplicateVariants[index.section].upc = ""
//                            }
//                        }
//                        else {
//                            
//                            duplicateVariants[index.section].upc = upcText
//                            variantsTable.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        if textField == productName {
//            activeTextField = textField
//        }
//        else {
//            let index = IndexPath(row: 0, section: textField.tag)
//            let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//            
//            if textField == cell.dupQty {
//                activeTextField = textField
//            }
//            else if textField == cell.dupCustom {
//                activeTextField = textField
//            }
//            else if  textField == cell.dupUpcCode {
//                activeTextField = textField
//            }
//            else if  textField == cell.dupReorderQty {
//                activeTextField = textField
//            }
//            else if  textField == cell.dupReorderLevel {
//                activeTextField = textField
//            }
//        }
//    }
//    
//    @objc func dupUpdateText(textField: MDCOutlinedTextField) {
//        
//        var updatetext = textField.text ?? ""
//        
//        if textField == productName {
//            if updatetext.count > 50 {
//                updatetext = String(updatetext.dropLast())
//            }
//        }
//        
//        else {
//            
//            let index = IndexPath(row: 0, section: textField.tag)
//            let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//            
//            if textField == cell.dupQty  {
//                if updatetext.count > 6 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//            else if textField == cell.dupCustom {
//                if updatetext.count > 30 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//            else if textField == cell.dupUpcCode {
//                if updatetext.count > 20 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//            
//            else if textField == cell.dupReorderQty {
//                if updatetext.count > 6 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//            else if textField == cell.dupReorderLevel {
//                if updatetext.count > 6 {
//                    updatetext = String(updatetext.dropLast())
//                }
//            }
//        }
//        
//        activeTextField.text = updatetext
//    }
//    
//    @objc func dupUpdateTextField(textField: MDCOutlinedTextField) {
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
//        if isDupSymbolOnRight {
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
//}
//
//extension DuplicateViewController {
//    
//
//    func validateDupParams() {
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
//        guard duplicateProdCat.count != 0 else {
//            catView.isErrorView(numberOfShakes: 3, revert: true)
//            showToastMedium(message: " Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            return
//        }
//        
//        var small = [String]()
//        for cat in duplicateProdCat {
//            small.append(cat.id)
//        }
//        
//        var smalltax = [String]()
//        for tax in duplicateTaxes {
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
//        if duplicateProdOptions.count == 0 {
//            prod.isvarient = "0"
//            
//            let index = IndexPath(row: 0, section: 0)
//            let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//            
//            let costperitem = duplicateVariants[0].costperItem
//            prod.costperItem = costperitem
//            
//            guard let price = duplicateVariants[0].price, price != "", price != "0.00" else {
//                cell.dupprice.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.price = price
//            
//            let c_price = prod.price
//            let c_compareprice = duplicateVariants[0].compare_price
//            print(c_compareprice)
//            
//            if c_compareprice != "" && c_compareprice != "0.00" {
//                
//                let newCompareprice = Double(c_compareprice)!
//                let newPrice = Double(c_price)!
//                
//                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                    showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.dupCompare.isError(numberOfShakes: 3, revert: true)
//                    
//                    return
//                }
//            }
//            
//            prod.compare_price = c_compareprice
//            prod.margin = duplicateVariants[0].margin
//            prod.profit = duplicateVariants[0].profit
//            
//            guard let quant = duplicateVariants[0].quantity, quant != "" else {
//                cell.dupQty.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.quantity = quant
//            prod.custom_code = duplicateVariants[0].custom_code
//            
//            guard let upc_code = duplicateVariants[0].upc, upc_code != "" else {
//                cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//                showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                return
//            }
//            
//            prod.upc = upc_code
//            
//            prod.trackqnty = duplicateVariants[0].trackqnty
//            prod.isstockcontinue = duplicateVariants[0].isstockcontinue
//            prod.is_tobacco = duplicateVariants[0].is_tobacco
//            prod.disable = duplicateVariants[0].disable
//            prod.food_stampable = duplicateVariants[0].food_stampable
//            
//            if duplicateVariants[0].reorder_qty == "" {
//                prod.reorder_qty = "0"
//            }
//            else{
//                prod.reorder_qty = duplicateVariants[0].reorder_qty
//            }
//            
//            if duplicateVariants[0].reorder_level == "" {
//                prod.reorder_level = "0"
//            }
//            else{
//                prod.reorder_level = duplicateVariants[0].reorder_level
//            }
//            
//            
//            
//            
//            loadIndicator.isAnimating = true
//            print(prod)
//            print(prod)
//            
//            saveBtn.isEnabled = false
//            
//            ApiCalls.sharedCall.productDuplicateProduct(merchant_id: m_id, admin_id: m_id, title: prod.title,
//                                                        alternateName: "", description: prod.description, price: prod.price,
//                                                        compare_price: prod.compare_price, costperItem: prod.costperItem,
//                                                        margin: prod.margin, profit: prod.profit, ischargeTax: prod.ischargeTax,
//                                                        sku: "", upc: prod.upc, custom_code: prod.custom_code,
//                                                        barcode: "", trackqnty: prod.trackqnty,
//                                                        isstockcontinue: prod.isstockcontinue, quantity: prod.quantity,
//                                                        ispysical_product: "", country_region: "", collection: prod.collection,
//                                                        HS_code: "", isvarient: "0", multiplefiles: "", img_color_lbl: "",
//                                                        created_on: "", productid: "", optionarray: "",
//                                                        optionarray1: "", optionarray2: "", optionvalue: "",
//                                                        optionvalue1: "", optionvalue2: "", other_taxes: prod.other_taxes,
//                                                        bought_product: "", featured_product: "", varvarient: "",
//                                                        varprice: "", varquantity: "", varsku: "", varbarcode: "",
//                                                        files: "", doc_file: "", optionid: "", varupc: "",
//                                                        varcustomcode: "", reorder_qty: prod.reorder_qty, reorder_level: prod.reorder_level,
//                                                        reorder_cost: "", is_tobacco: prod.is_tobacco, disable: prod.disable,
//                                                        food_stampable: prod.food_stampable,
//                                                        vartrackqnty: "", varcontinue_selling: "", varcheckid: "",
//                                                        vardisable: "", varfood_stampable: "", varmargin: "", varprofit: "",
//                                                        varreorder_qty: "", varreorder_level: "",
//                                                        varreorder_cost: "", varcostperitem: "",
//                                                        varcompareprice: "", var_id: "") { isSuccess, responseData in
//                
//                if isSuccess {
//                    
//                    if let list = responseData["message"] as? String {
//                        print(list)
//                        if list == "Success" {
//                            self.loadIndicator.isAnimating = false
//                            self.showToastLarge(message: " Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                
//                                var destiny = 0
//                                
//                                let viewcontrollerArray = self.navigationController?.viewControllers
//                                print(viewcontrollerArray)
//                                
//                                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
//                                    destiny = destinationIndex
//                                }
//                                
//                                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
//                                
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
//            var reorderQty_arr = [String]()
//            var reorderLevel_arr = [String]()
//            
//            
//            var track_arr = [String]()
//            var sell_arr = [String]()
//            var check_arr = [String]()
//            var disable_arr = [String]()
//            var foodStamp_arr = [String]()
//            
//            var v_variant_arr = [String]()
//            
//            for product in 0..<duplicateVariants.count {
//                
//                let costperitem = duplicateVariants[product].costperItem
//                cost_item_arr.append(costperitem)
//                
//                guard let price = duplicateVariants[product].price, price != "", price != "0.00" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//                    cell.dupprice.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                price_arr.append(price)
//                
//                let c_price = price
//                let c_compareprice = duplicateVariants[product].compare_price
//
//                if c_compareprice != "" && c_compareprice != "0.00" {
//                    
//                    let newCompareprice = Double(c_compareprice)!
//                    let newPrice = Double(c_price)!
//                    
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
//                        showToastXL(message: " Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                        cell.dupCompare.isError(numberOfShakes: 3, revert: true)
//                        
//                        return
//                    }
//                }
//                
//                compare_arr.append(c_compareprice)
//                margin_arr.append(duplicateVariants[product].margin)
//                profit_arr.append(duplicateVariants[product].profit)
//                
//                guard let quant = duplicateVariants[product].quantity, quant != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//                    cell.dupQty.isError(numberOfShakes: 3, revert: true)
//                    showToastMedium(message: " Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    return
//                }
//                
//                quantity_arr.append(quant)
//                custom_arr.append(duplicateVariants[product].custom_code)
//                
//                guard let upcCode = duplicateVariants[product].upc, upcCode != "" else {
//                    sayAct(tag: product)
//                    let index = IndexPath(row: 0, section: product)
//                    let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//                    showToastMedium(message: " Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//                    return
//                }
//                upc_arr.append(upcCode)
////                v_variant_arr.append(result[product])
//                
//                track_arr.append(duplicateVariants[product].trackqnty)
//                sell_arr.append(duplicateVariants[product].isstockcontinue)
//                check_arr.append(duplicateVariants[product].is_tobacco)
//                disable_arr.append(duplicateVariants[product].disable)
//                foodStamp_arr.append(duplicateVariants[product].food_stampable)
//                
//                
//                reorderQty_arr.append(duplicateVariants[product].reorder_qty)
//                reorderLevel_arr.append(duplicateVariants[product].reorder_level)
//                
//            }
//            
//            
//            print(duplicateProdOptions)
//            if dupResult.count == 0 {
//                
//                if duplicateProdOptions.count == 3 {
//                    
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[2].optionsvl1 == "" && duplicateProdOptions[2].optionsvl2 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[2].optionsvl2 == "" && duplicateProdOptions[2].optionsvl3 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//                else if duplicateProdOptions.count == 2 {
//                    
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//                else {
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//                dupAdjustAttributes()
//            }
//            v_variant_arr = dupResult
//            print(v_variant_arr)
//            print(dupResult)
//            prod.varvarient = v_variant_arr.joined(separator: ",")
//            
//            print(prod.varvarient)
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
//            
//            
//            prod.vartrackqnty = track_arr.joined(separator: ",")
//            prod.varcontinue_selling = sell_arr.joined(separator: ",")
//            prod.varcheckid = check_arr.joined(separator: ",")
//            prod.vardisable = disable_arr.joined(separator: ",")
//            prod.varfood_stampable = foodStamp_arr.joined(separator: ",")
//           
//            
//            prod.varreorder_qty = reorderQty_arr.joined(separator: ",")
//            prod.varreorder_level = reorderLevel_arr.joined(separator: ",")
//
//            
//            print(duplicateProdOptions)
//            print(duplicateProdOptions.count)
//            
//            if duplicateProdOptions.count > 0 {
//                
//                for opt in 0..<duplicateProdOptions.count {
//                    
//                    if opt == 0 {
//                        
//                        if duplicateProdOptions[opt].options1 == "" && duplicateProdOptions[opt].options2 == "" {
//                            prod.optionarray = duplicateProdOptions[opt].options3
//                        }
//                        else if duplicateProdOptions[opt].options2 == "" && duplicateProdOptions[opt].options3 == "" {
//                            prod.optionarray = duplicateProdOptions[opt].options1
//                        }
//                        else {
//                            prod.optionarray = duplicateProdOptions[opt].options2
//                        }
//                        
//                        if duplicateProdOptions[opt].optionsvl1 == "" && duplicateProdOptions[opt].optionsvl2 == "" {
//                            prod.optionvalue = duplicateProdOptions[opt].optionsvl3
//                        }
//                        else if duplicateProdOptions[opt].optionsvl2 == "" && duplicateProdOptions[opt].optionsvl3 == "" {
//                            prod.optionvalue = duplicateProdOptions[opt].optionsvl1
//                        }
//                        else {
//                            prod.optionvalue = duplicateProdOptions[opt].optionsvl2
//                        }
//                        
//                    }
//                    
//                    else if opt == 1 {
//                        if duplicateProdOptions[opt].options1 == "" && duplicateProdOptions[opt].options2 == "" {
//                            prod.optionarray1 = duplicateProdOptions[opt].options3
//                        }
//                        else if duplicateProdOptions[opt].options2 == "" && duplicateProdOptions[opt].options3 == "" {
//                            prod.optionarray1 = duplicateProdOptions[opt].options1
//                        }
//                        else {
//                            prod.optionarray1 = duplicateProdOptions[opt].options2
//                        }
//                        
//                        if duplicateProdOptions[opt].optionsvl1 == "" && duplicateProdOptions[opt].optionsvl2 == "" {
//                            prod.optionvalue1 = duplicateProdOptions[opt].optionsvl3
//                        }
//                        else if duplicateProdOptions[opt].optionsvl2 == "" && duplicateProdOptions[opt].optionsvl3 == "" {
//                            prod.optionvalue1 = duplicateProdOptions[opt].optionsvl1
//                        }
//                        else {
//                            prod.optionvalue1 = duplicateProdOptions[opt].optionsvl2
//                        }
//                    }
//                    
//                    else {
//                        if duplicateProdOptions[opt].options1 == "" && duplicateProdOptions[opt].options2 == "" {
//                            prod.optionarray2 = duplicateProdOptions[opt].options3
//                        }
//                        else if duplicateProdOptions[opt].options2 == "" && duplicateProdOptions[opt].options3 == "" {
//                            prod.optionarray2 = duplicateProdOptions[opt].options1
//                        }
//                        else {
//                            prod.optionarray2 = duplicateProdOptions[opt].options2
//                        }
//                        
//                        if duplicateProdOptions[opt].optionsvl1 == "" && duplicateProdOptions[opt].optionsvl2 == "" {
//                            prod.optionvalue2 = duplicateProdOptions[opt].optionsvl3
//                        }
//                        else if duplicateProdOptions[opt].optionsvl2 == "" && duplicateProdOptions[opt].optionsvl3 == "" {
//                            prod.optionvalue2 = duplicateProdOptions[opt].optionsvl1
//                        }
//                        else {
//                            prod.optionvalue2 = duplicateProdOptions[opt].optionsvl2
//                        }
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
//            ApiCalls.sharedCall.productDuplicateProduct(merchant_id: m_id, admin_id: m_id, title: prod.title, alternateName: "",
//                                                        description: prod.description, price: "", compare_price: "",
//                                                        costperItem: "", margin: "", profit: "",
//                                                        ischargeTax: prod.ischargeTax, sku: "", upc: "", custom_code: "",
//                                                        barcode: "", trackqnty: "", isstockcontinue: "",
//                                                        quantity: "", ispysical_product: "", country_region: "",
//                                                        collection: prod.collection, HS_code: "", isvarient: prod.isvarient,
//                                                        multiplefiles: "", img_color_lbl: "", created_on: "",
//                                                        productid: "", optionarray: prod.optionarray,
//                                                        optionarray1: prod.optionarray1, optionarray2: prod.optionarray2,
//                                                        optionvalue: prod.optionvalue, optionvalue1: prod.optionvalue1,
//                                                        optionvalue2: prod.optionvalue2, other_taxes: prod.other_taxes, 
//                                                        bought_product: "", featured_product: "", varvarient: prod.varvarient,
//                                                        varprice: prod.varprice, varquantity: prod.varquantity, varsku: "",
//                                                        varbarcode: "", files: "", doc_file: "", optionid: "", varupc: prod.varupc,
//                                                        varcustomcode: prod.varcustomcode, reorder_qty: "", reorder_level: "",
//                                                        reorder_cost: "", is_tobacco: "", disable: "", food_stampable: "", vartrackqnty: prod.vartrackqnty,
//                                                        varcontinue_selling: prod.varcontinue_selling, varcheckid: prod.varcheckid,
//                                                        vardisable: prod.vardisable, varfood_stampable: prod.varfood_stampable,varmargin: prod.varmargin,
//                                                        varprofit: prod.varprofit, varreorder_qty: prod.varreorder_qty,
//                                                        varreorder_level: prod.varreorder_level, varreorder_cost: "",
//                                                        varcostperitem: prod.varcostperitem, varcompareprice: prod.varcompareprice,
//                                                        var_id: "") { isSuccess, responseData in
//                
//                if isSuccess {
//                    
//                    if let list = responseData["message"] as? String {
//                        print(list)
//                        if list == "Success" {
//                            self.showToastLarge(message: " Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                                var destiny = 0
//                                
//                                let viewcontrollerArray = self.navigationController?.viewControllers
//                                
//                                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
//                                    destiny = destinationIndex
//                                }
//                                
//                                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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
//    @IBAction func addBtnClick(_ sender: UIButton) {
//        
//        validateDupParams()
//        
//    }
//    
//    
//    @IBAction func cancelBtnClick(_ sender: UIButton) {
//        
//        navigationController?.popViewController(animated: true)
//    }
//    
//    
//}
//
//
//
//
//
//extension DuplicateViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
//    
//    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
//        
//        let urlString = code
//        
//        let index = IndexPath(row: 0, section: scanDupIndex)
//        let cell = variantsTable.cellForRow(at: index) as! DuplicateVarTableViewCell
//        
//        let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
//        if upcUnique.contains(urlString) {
//            controller.dismiss(animated: true)
//            showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//            cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//            cell.dupUpcCode.text = ""
//            duplicateVariants[scanDupIndex].upc = ""
//        }
//        else {
//            
//            if duplicateVariants.contains(where: {$0.upc == urlString}) {
//                
//                if scanDupIndex == duplicateVariants.firstIndex(where: {$0.upc == urlString}) {
//                    duplicateVariants[scanDupIndex].upc = urlString
//                    variantsTable.reloadData()
//                    controller.dismiss(animated: true)
//                }
//                else {
//                    controller.dismiss(animated: true)
//                    showToastMedium(message: " Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//                    cell.dupUpcCode.isError(numberOfShakes: 3, revert: true)
//                    cell.dupUpcCode.text = ""
//                    duplicateVariants[scanDupIndex].upc = ""
//                }
//            }
//            else {
//                duplicateVariants[scanDupIndex].upc = urlString
//                print(urlString)
//                variantsTable.reloadData()
//                controller.dismiss(animated: true)
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
//}
//
//
//extension DuplicateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if collectionView == catColl {
//            
//            if duplicateProdCat.count == 0 {
//                return 0
//            }
//            else {
//                return duplicateProdCat.count + 1
//            }
//        }
//        
//        else {
//            
//            return duplicateTaxes.count
//        }
//    }
//        
//
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if collectionView == catColl {
//            
//            let cell = catColl.dequeueReusableCell(withReuseIdentifier: "dupcatcell", for: indexPath) as! DuplicateCatCollectionViewCell
//            
//            if indexPath.row == duplicateProdCat.count {
//                cell.catLabel.text = ""
//                cell.catClose.setImage(UIImage(named: "CatAddBtn"), for: .normal)
//                cell.borderView.backgroundColor = .systemBackground
//            }
//            
//            else {
//                cell.catLabel.text = duplicateProdCat[indexPath.row].title
//                cell.catClose.setImage(UIImage(named: "white close"), for: .normal)
//                cell.borderView.backgroundColor = .black
//            }
//            cell.borderView.layer.cornerRadius = 5.0
//            cell.catClose.tag = indexPath.row
//            
//            collDupSubviews()
//            return cell
//        }
//        
//        else {
//            
//            let cell = taxescoll.dequeueReusableCell(withReuseIdentifier: "duplicateTax", for: indexPath) as! DuplicateTaxCollectionViewCell
//            
//            cell.borderView.layer.cornerRadius = 5.0
//            cell.tax_close.layer.cornerRadius = 5.0
//            cell.tax_name.text = duplicateTaxes[indexPath.row].title
//            cell.tax_close.setImage(UIImage(named: "white close"), for: .normal)
//            cell.borderView.backgroundColor = .black
//            cell.tax_close.tag = indexPath.row
//            
//            dupTaxSubviews()
//            return cell
//        }
//    }
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
//
//extension DuplicateViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        if tableView == attributeTable {
//            return 1
//        }
//        
//        else {
//            return duplicateVariants.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if tableView == attributeTable {
//            return duplicateProdOptions.count
//        }
//        
//        else {
//            
//            if duplicateSelectedData[section] == false {
//                return 0
//            }
//            else {
//                return 1
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == attributeTable {
//            
//            let cell = attributeTable.dequeueReusableCell(withIdentifier: "duplicateOptions", for: indexPath) as! DuplicateOptionsTableViewCell
//            
//            cell.deleteClick.setImage(UIImage(named: "red_delete"), for: .normal)
//            
//            if duplicateProdOptions[indexPath.row].options1 == "" && duplicateProdOptions[indexPath.row].options2 == "" {
//                cell.attName.text = duplicateProdOptions[indexPath.row].options3
//            }
//            else if duplicateProdOptions[indexPath.row].options2 == "" && duplicateProdOptions[indexPath.row].options3 == "" {
//                cell.attName.text = duplicateProdOptions[indexPath.row].options1
//            }
//            else {
//                cell.attName.text = duplicateProdOptions[indexPath.row].options2
//            }
//            
//            cell.deleteClick.tag = indexPath.row
//            cell.borderView.dropAttShadow()
//            return cell
//        }
//        
//        else {
//            
//            var variants: ProductById?
//            
//            let cell = variantsTable.dequeueReusableCell(withIdentifier: "duplicateVarients", for: indexPath) as! DuplicateVarTableViewCell
//            
//            createCustomTextField(textField: cell.dupCostPer)
//            createCustomTextField(textField: cell.dupprice)
//            createCustomTextField(textField: cell.dupMargin)
//            createCustomTextField(textField: cell.dupProfit)
//            createCustomTextField(textField: cell.dupCompare)
//            createCustomTextField(textField: cell.dupQty)
//            createCustomTextField(textField: cell.dupCustom)
//            createCustomTextField(textField: cell.dupUpcCode)
//            createCustomTextField(textField: cell.dupReorderQty)
//            createCustomTextField(textField: cell.dupReorderLevel)
//
//            
//            cell.dupMargin.backgroundColor = UIColor(named: "Disabled Text")
//            cell.dupProfit.backgroundColor = UIColor(named: "Disabled Text")
//            cell.dupMargin.setOutlineColor(.clear, for: .normal)
//            cell.dupMargin.setOutlineColor(.clear, for: .editing)
//            cell.dupProfit.setOutlineColor(.clear, for: .normal)
//            cell.dupProfit.setOutlineColor(.clear, for: .editing)
//            cell.dupMargin.layer.cornerRadius = 5
//            cell.dupProfit.layer.cornerRadius = 5
//            
//            
//            cell.dupprice.label.text = "Price"
//            cell.dupCompare.label.text = "Compare At Price"
//            cell.dupCostPer.label.text = "Cost Per Item"
//            cell.dupMargin.label.text = "Margin(%)"
//            cell.dupProfit.label.text = "Profit($)"
//            cell.dupQty.label.text = "QTY"
//            cell.dupCustom.label.text = "Custom Code"
//            cell.dupUpcCode.label.text = "UPC Code"
//            cell.dupReorderQty.label.text = "Reorder Qty"
//            cell.dupReorderLevel.label.text = "Reorder Level"
//            
//            cell.dupprice.keyboardType = .numberPad
//            cell.dupCompare.keyboardType = .numberPad
//            cell.dupCostPer.keyboardType = .numberPad
//            cell.dupQty.keyboardType = .numberPad
//            cell.dupReorderQty.keyboardType = .numberPad
//            cell.dupReorderLevel.keyboardType = .numberPad
//            
//            
//            cell.dupCostPer.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
//            cell.dupprice.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
//            cell.dupCompare.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
//            cell.dupMargin.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
//            cell.dupProfit.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
//           
//            
//            cell.dupReorderQty.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
//            cell.dupReorderLevel.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
//            cell.dupQty.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
//            cell.dupCustom.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
//            cell.dupUpcCode.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
//            
//            cell.dupCostPer.tag = indexPath.section
//            cell.dupprice.tag = indexPath.section
//            cell.dupCompare.tag = indexPath.section
//            cell.dupMargin.tag = indexPath.section
//            cell.dupProfit.tag = indexPath.section
//            cell.dupQty.tag = indexPath.section
//            cell.dupCustom.tag = indexPath.section
//            cell.dupUpcCode.tag = indexPath.section
//            cell.dupReorderQty.tag = indexPath.section
//            cell.dupReorderLevel.tag = indexPath.section
//            
//            
//            cell.duptrackQty.tag = indexPath.section
//            cell.dupSell.tag = indexPath.section
//            cell.dupCheckId.tag = indexPath.section
//            cell.dupDisable.tag = indexPath.section
//            cell.dubFood.tag = indexPath.section
//            
//            cell.dupScanBtn.tag = indexPath.section
//            
//            cell.dupCostPer.delegate = self
//            cell.dupprice.delegate =  self
//            cell.dupCompare.delegate = self
//            cell.dupMargin.delegate = self
//            cell.dupProfit.delegate = self
//            cell.dupQty.delegate = self
//            cell.dupCustom.delegate = self
//            cell.dupUpcCode.delegate = self
//            cell.dupReorderQty.delegate = self
//            cell.dupReorderLevel.delegate = self
//            
//            variants = duplicateVariants[indexPath.section]
//                
//            cell.dupCostPer.text = variants?.costperItem
//            cell.dupprice.text = variants?.price
//            cell.dupMargin.text = variants?.margin
//            cell.dupProfit.text = variants?.profit
//            cell.dupCompare.text = variants?.compare_price
//            cell.dupQty.text = variants?.quantity
//            cell.dupCustom.text = variants?.custom_code
//            cell.dupUpcCode.text = variants?.upc
//            cell.dupReorderQty.text = variants?.reorder_qty
//            cell.dupReorderLevel.text = variants?.reorder_level
//            
//            
//            if variants?.trackqnty == "1"{
//                cell.duptrackQty.setImage(UIImage(named: "check inventory"), for: .normal)
//            }
//            else {
//                cell.duptrackQty.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            }
//            
//            if variants?.isstockcontinue == "1"{
//                cell.dupSell.setImage(UIImage(named: "check inventory"), for: .normal)
//            }
//            else {
//                cell.dupSell.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            }
//            
//            if variants?.is_tobacco == "1"{
//                cell.dupCheckId.setImage(UIImage(named: "check inventory"), for: .normal)
//            }
//            else {
//                cell.dupCheckId.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            }
//            
//            if variants?.disable == "1"{
//                cell.dupDisable.setImage(UIImage(named: "check inventory"), for: .normal)
//            }
//            else {
//                cell.dupDisable.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            }
//            if variants?.food_stampable == "1"{
//                cell.dubFood.setImage(UIImage(named: "check inventory"), for: .normal)
//            }
//            else {
//                cell.dubFood.setImage(UIImage(named: "uncheck inventory"), for: .normal)
//            }
//    
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if tableView == attributeTable {
//            
//            let index = indexPath.row
//            dupInventoryOpt = duplicateProdOptions[index]
//            dupAddAttrIndex = index
//            if index == 0 {
//                dupInventoryOpt = duplicateProdOptions[index]
//                dupAddAttrIndex = index
//                if duplicateProdOptions.count == 1 {}
//                else if duplicateProdOptions.count == 2 {
//                    if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//                else {
//                    if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl2 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[2].optionsvl1 == "" && duplicateProdOptions[2].optionsvl2 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[2].optionsvl2 == "" && duplicateProdOptions[2].optionsvl3 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//            }
//            else if index == 1 {
//                dupInventoryOpt = duplicateProdOptions[index]
//                dupAddAttrIndex = index
//                
//                if duplicateProdOptions.count == 1 {}
//                else if duplicateProdOptions.count == 2 {
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//                else {
//                    
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[2].optionsvl1 == "" && duplicateProdOptions[2].optionsvl2 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[2].optionsvl2 == "" && duplicateProdOptions[2].optionsvl3 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl3 = duplicateProdOptions[2].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//            }
//        
//            else {
//                dupInventoryOpt = duplicateProdOptions[index]
//                dupAddAttrIndex = index
//                
//                if duplicateProdOptions.count == 1 {
//                }
//                else if duplicateProdOptions.count == 2 {}
//                else {
//                    if duplicateProdOptions[0].optionsvl1 == "" && duplicateProdOptions[0].optionsvl2 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[0].optionsvl2 == "" && duplicateProdOptions[0].optionsvl3 == "" {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl1 = duplicateProdOptions[0].optionsvl2.components(separatedBy: ",")
//                    }
//                    
//                    if duplicateProdOptions[1].optionsvl1 == "" && duplicateProdOptions[1].optionsvl2 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[1].optionsvl3.components(separatedBy: ",")
//                    }
//                    else if duplicateProdOptions[1].optionsvl2 == "" && duplicateProdOptions[1].optionsvl3 == "" {
//                        dupArrOptVl3 = duplicateProdOptions[1].optionsvl1.components(separatedBy: ",")
//                    }
//                    else {
//                        dupArrOptVl3 = duplicateProdOptions[1].optionsvl2.components(separatedBy: ",")
//                    }
//                }
//            }
//            performSegue(withIdentifier: "dupToAddVar", sender: nil)
//        }
//        
//        else {
//            
//            variantsTable.deselectRow(at: indexPath, animated: true)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        if tableView == variantsTable {
//            
//            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 100))
//            
//            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
//            btn2.setImage(UIImage(named: "down"), for: .normal)
//            btn2.addTarget(self, action: #selector(sayAction(_:)), for: .touchUpInside)
//            btn2.backgroundColor = .clear
//            
//            let btn1 = UIButton(frame: CGRect(x:10, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 50, height: 50))
//            btn1.titleLabel?.numberOfLines = 0
//            btn1.titleLabel?.lineBreakMode = .byWordWrapping
//            btn1.titleLabel?.adjustsFontSizeToFitWidth = true
//            btn1.titleLabel?.minimumScaleFactor = 0.5
//            
//            if dupAddCombo == 0 {
//                
//                if duplicateVariants.count == 1 && duplicateProdOptions.count == 0 {
//                    btn1.setTitle("", for: .normal)
//                }
//                else {
//                    if dupResult.count > 0 {
//                        btn1.setTitle("\(dupResult[section])", for: .normal)
//                    }
//                    else {
//                        btn1.setTitle("\(duplicateVariants[section].variant)", for: .normal)
//                    }
//                }
//            }
//            else {
//                
//                if duplicateVariants.count == 1 {
//                   
//                    if dupArrOptVl3.count != 0 {
//                        btn1.setTitle("\(dupArrOptVl1[0])/\(dupArrOptVl2[0])/\(dupArrOptVl3[0])", for: .normal)
//                    }
//                    else if dupArrOptVl2.count != 0 {
//                        btn1.setTitle("\(dupArrOptVl1[0])/\(dupArrOptVl2[0])", for: .normal)
//                    }
//                    
//                    else if dupArrOptVl1.count != 0 {
//                        btn1.setTitle("\(dupArrOptVl1[0])", for: .normal)
//                    }
//                }
//                else {
//                    
//                    btn1.setTitle("\(dupResult[section])", for: .normal)
//                }
//            }
//            
//            btn1.setTitleColor(.black, for: .normal)
//            btn1.contentHorizontalAlignment = .left
//            btn1.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 18.0)!
//            btn1.addTarget(self, action: #selector(sayAction(_:)), for: .touchUpInside)
//            
//            btn1.tag = section
//            btn2.tag = section
//            headerView.addSubview(btn1)
//            headerView.addSubview(btn2)
//            
//            return headerView
//        }
//        else {
//            return nil
//        }
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if tableView == attributeTable {
//            return 73
//        }
//        
//        else {
//            return UITableView.automaticDimension
//        }
//    }
//    
//    func sayAct(tag: Int) {
//        
//        if duplicateSelectedData[tag] == true {
//            
//        }
//        else {
//            
//            for select in 0..<duplicateSelectedData.count {
//                
//                if select == tag {
//                    duplicateSelectedData[select] = true
//                }
//                else {
//                    duplicateSelectedData[select] = false
//                }
//            }
//            variantsTable.reloadData()
//        }
//    }
//    
//    @objc func sayAction(_ sender: UIButton){
//        
//        if duplicateVariants.count == 1 {
//            
//        }
//        
//        else {
//            
//            if duplicateSelectedData[sender.tag] == true {
//                duplicateSelectedData[sender.tag] = false
//                
//                //decrease scroll height
//                if dupcatCollHeight.constant > 53.0 {
//                    
//                    if dupTaxCollHeight.constant > 53.0 {
//                        
//                        dupTaxCollHeight.constant = 550 + 50 * CGFloat(duplicateVariants.count) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//                    }
//                    
//                    else {
//                        
//                        scrollHeight.constant = 550 + 50 * CGFloat(duplicateVariants.count) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//                    }
//                }
//                else {
//                    
//                    if dupTaxCollHeight.constant > 53.0 {
//                        
//                        scrollHeight.constant =  550 + 50 * CGFloat(duplicateVariants.count) + CGFloat(73 * duplicateProdOptions.count) +
//                        dupTaxCollHeight.constant + 10
//                    }
//                    
//                    else {
//                        
//                        scrollHeight.constant =  550 + 50 * CGFloat(duplicateVariants.count) + CGFloat(73 * duplicateProdOptions.count)
//                    }
//                    
//                }
//            }
//            
//            else {
//                for select in 0..<duplicateSelectedData.count {
//                    
//                    if duplicateSelectedData[select] == true {
//                        duplicateSelectedData[select].toggle()
//                    }
//                    else if select == sender.tag {
//                        duplicateSelectedData[select].toggle()
//                    }
//                    else {
//                        print("")
//                    }
//                }
//                
//                if dupcatCollHeight.constant > 53.0 {
//                    
//                    if dupTaxCollHeight.constant > 53.0 {
//                        
//                        scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + dupTaxCollHeight.constant + 20
//                    }
//                    
//                    else {
//                        scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) + dupcatCollHeight.constant + 10
//                    }
//                }
//                else {
//                    
//                    if dupTaxCollHeight.constant > 53.0 {
//                        
//                        scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count) +
//                        dupTaxCollHeight.constant + 10
//                    }
//                    
//                    else {
//                        scrollHeight.constant =  1270 + 50 * CGFloat(duplicateVariants.count - 1) + CGFloat(73 * duplicateProdOptions.count)
//                    }
//                }
//            }
//        }
//        variantsTable.reloadData()
//    }
//}
//
//extension DuplicateViewController {
//    
//    
//    func createCustomTextField(textField: MDCOutlinedTextField) {
//        textField.font = UIFont(name: "Manrope-SemiBold", size: 13.0)
//        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
//        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
//        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
//        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
//        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
//        textField.setNormalLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
//    }
//    
//    
//    private func setUI() {
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .light
//        }
//        saveBtn.addSubview(loadIndicator)
//    
//        
//        NSLayoutConstraint.activate([
//            loadIndicator.centerXAnchor
//                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(30)),
//            loadIndicator.centerYAnchor
//                .constraint(equalTo: saveBtn.centerYAnchor),
//            loadIndicator.widthAnchor
//                .constraint(equalToConstant: 15),
//            loadIndicator.heightAnchor
//                .constraint(equalTo: self.loadIndicator.widthAnchor)
//        ])
//    }
//}
