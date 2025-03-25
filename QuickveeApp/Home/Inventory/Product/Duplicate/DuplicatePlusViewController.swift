//
//  DuplicatePlusViewController.swift
//
//
//  Created by Jamaluddin Syed on 12/07/24.
//

import UIKit
import MaterialComponents
import BarcodeScanner

class DuplicatePlusViewController: UIViewController {
    
    
    @IBOutlet weak var dupProductField: UITextField!
    @IBOutlet weak var dupDescField: UITextField!
    
    @IBOutlet weak var dupBrandView: UIView!
    @IBOutlet weak var dupSelectBrandLabel: UILabel!
    @IBOutlet weak var dupBrandInnerView: UIView!
    @IBOutlet weak var dupBrandName: UILabel!
    @IBOutlet weak var dupBrandCloseBtn: UIButton!
    
    @IBOutlet weak var dupCatColl: UICollectionView!
    @IBOutlet weak var dupTagColl: UICollectionView!
    @IBOutlet weak var dupTaxesColl: UICollectionView!
    
    @IBOutlet weak var dupcatcollHeight: NSLayoutConstraint!
    @IBOutlet weak var duptagCollHeight: NSLayoutConstraint!
    @IBOutlet weak var duptaxCollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dupVariantsTable: UITableView!
    @IBOutlet weak var dupAttTable: UITableView!
    @IBOutlet weak var dupAddVarBtn: UIButton!
    
    @IBOutlet weak var dupAddBtnTop: NSLayoutConstraint!
    @IBOutlet weak var dupAddBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var dupattHeight: NSLayoutConstraint!
    
    @IBOutlet weak var duptopview: UIView!
    @IBOutlet weak var genUpcLbl: UILabel!
    
    @IBOutlet weak var dupSaveBtn: UIButton!
    @IBOutlet weak var dupCancelBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scroll: UIView!
    @IBOutlet weak var dupScrollHeight: NSLayoutConstraint!
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private var isDupSymbolOnRight = false
    
    var scanDupIndex = 0
    
    var dupisSelectedData = [Bool]()
    
    var dupInventoryOpt: InventoryOptions?
    var singleProd: ProductById?
    
    var dupProdDesc = ""
    var dupBrandNameLbl = ""
    
    var dupProdCat = [InventoryCategory]()
    var dupProdOptions = [InventoryOptions]()
    var dupArrTaxes = [SetupTaxes]()
    var dupProdTaxes = [SetupTaxes]()
    var dupProdTag = [String]()
    var dupProdVariants = [ProductById]()
    
    var dupVariantMode = ""
    var dupVariantGoMode = "duplus"
    var dupattIndex = 0
    
    var duparrOptVl1 = [String]()
    var duparrOptVl2 = [String]()
    var duparrOptVl3 = [String]()
    var dupresult = [String]()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dupProductField.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
        dupDescField.layer.borderColor = UIColor(hexString: "#E4E8EF").cgColor
        
        dupProductField.placeholder = "Enter Name"
        dupSelectBrandLabel.text = "Select Brand"
        dupDescField.placeholder = "Enter Product Description"
        dupProductField.smartDashesType = .no
        dupProductField.autocapitalizationType = .words
        dupDescField.autocapitalizationType = .sentences
        
        dupProductField.delegate = self
        dupProductField.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
        
        dupSaveBtn.setTitle("Add", for: .normal)
        dupCancelBtn.layer.cornerRadius = 10
        dupSaveBtn.layer.cornerRadius = 10
        
        dupCancelBtn.layer.borderColor = UIColor.black.cgColor
        dupCancelBtn.layer.borderWidth = 1.0
        
        let colLay = CustomFlowLayout()
        dupCatColl.collectionViewLayout = colLay
        colLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        dupBrandView.layer.cornerRadius = 5.0
        dupCatColl.layer.cornerRadius = 5.0
        dupTagColl.layer.cornerRadius = 5.0
        dupTaxesColl.layer.cornerRadius = 5.0
        
        dupBrandView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        dupBrandView.layer.borderWidth = 1.0
        dupCatColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        dupCatColl.layer.borderWidth = 1.0
        dupTagColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        dupTagColl.layer.borderWidth = 1.0
        dupTaxesColl.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        dupTaxesColl.layer.borderWidth = 1.0
        
        let collLay = CustomFlowLayout()
        dupTagColl.collectionViewLayout = collLay
        collLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let colllLay = CustomFlowLayout()
        dupTaxesColl.collectionViewLayout = colllLay
        colllLay.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        dupAddVarBtn.layer.borderColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
        dupAddVarBtn.layer.borderWidth = 1.0
        dupAddVarBtn.layer.cornerRadius = 5
        dupAddVarBtn.backgroundColor = .white
        
        let cat_tap = UITapGestureRecognizer(target: self, action: #selector(openCatScreen))
        dupCatColl.addGestureRecognizer(cat_tap)
        cat_tap.numberOfTapsRequired = 1
        dupCatColl.isUserInteractionEnabled = true
        
        let brand_tap = UITapGestureRecognizer(target: self, action: #selector(openBrandScreen))
        dupBrandView.addGestureRecognizer(brand_tap)
        brand_tap.numberOfTapsRequired = 1
        dupBrandView.isUserInteractionEnabled = true
        
        let tag_tap = UITapGestureRecognizer(target: self, action: #selector(openTagScreen))
        dupTagColl.addGestureRecognizer(tag_tap)
        tag_tap.numberOfTapsRequired = 1
        dupTagColl.isUserInteractionEnabled = true
        
        let tax_tap = UITapGestureRecognizer(target: self, action: #selector(openTaxScreen))
        dupTaxesColl.addGestureRecognizer(tax_tap)
        tax_tap.numberOfTapsRequired = 1
        dupTaxesColl.isUserInteractionEnabled = true
        
        let tapUpc = UITapGestureRecognizer(target: self, action: #selector(dupGenUpc))
        genUpcLbl.addGestureRecognizer(tapUpc)
        tapUpc.numberOfTapsRequired = 1
        genUpcLbl.isUserInteractionEnabled = true
        
        dupAttTable.estimatedSectionFooterHeight = 0
        dupAttTable.estimatedSectionHeaderHeight = 0
        dupVariantsTable.estimatedSectionFooterHeight = 0
        
        if #available(iOS 15.0, *) {
            dupVariantsTable.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        duptopview.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        
        if dupProdVariants.count == 0 {
            
            let emptyProd = ProductById(alternateName: "\(singleProd?.alternateName ?? "")",
                                        admin_id: "\(singleProd?.admin_id ?? "")",
                                        description: "\(singleProd?.description ?? "")",
                                        starting_quantity: "\(singleProd?.starting_quantity ?? "")",
                                        margin: "\(singleProd?.margin ?? "")",
                                        brand: "\(singleProd?.brand ?? "")", tags: "\(singleProd?.tags ?? "")",
                                        upc: "\(singleProd?.upc ?? "")",
                                        id: "\(singleProd?.id ?? "")", sku: "\(singleProd?.sku ?? "")",
                                        disable: "\(singleProd?.disable ?? "")", food_stampable: "\(singleProd?.food_stampable ?? "")",
                                        isvarient: "\(singleProd?.isvarient ?? "")", is_lottery: "\(singleProd?.is_lottery ?? "")", title: "\(singleProd?.title ?? "")",
                                        quantity: "\(singleProd?.quantity ?? "")",
                                        ischargeTax: "\(singleProd?.ischargeTax ?? "")",
                                        updated_on: "\(singleProd?.updated_on ?? "")",
                                        isstockcontinue: "\(singleProd?.isstockcontinue ?? "")",
                                        trackqnty: "\(singleProd?.trackqnty ?? "")", profit: "\(singleProd?.profit ?? "")",
                                        custom_code: "\(singleProd?.custom_code ?? "")",
                                        assigned_vendors: "\(singleProd?.assigned_vendors ?? "")",
                                        barcode: "\(singleProd?.barcode ?? "")",
                                        country_region: "\(singleProd?.country_region ?? "")",
                                        ispysical_product: "\(singleProd?.alternateName ?? "")",
                                        show_status: "\(singleProd?.show_status ?? "")",
                                        HS_code: "\(singleProd?.HS_code ?? "")", price: "\(singleProd?.price ?? "")",
                                        featured_product: "\(singleProd?.featured_product ?? "")",
                                        merchant_id: "\(singleProd?.merchant_id ?? "")",
                                        created_on: "\(singleProd?.created_on ?? "")",
                                        prefferd_vendor: "\(singleProd?.prefferd_vendor ?? "")",
                                        reorder_cost: "\(singleProd?.reorder_cost ?? "")",
                                        other_taxes: "\(singleProd?.other_taxes ?? "")",
                                        buy_with_product: "\(singleProd?.buy_with_product ?? "")",
                                        costperItem: "\(singleProd?.costperItem ?? "")",
                                        is_tobacco: "\(singleProd?.is_tobacco ?? "")",
                                        product_doc: "\(singleProd?.product_doc ?? "")",
                                        user_id: "\(singleProd?.user_id ?? "")",
                                        media: "\(singleProd?.media ?? "")",
                                        compare_price: "\(singleProd?.compare_price ?? "")",
                                        loyalty_product_id: "\(singleProd?.loyalty_product_id ?? "")",
                                        show_type: "\(singleProd?.show_type ?? "")",
                                        cotegory: "\(singleProd?.cotegory ?? "")",
                                        reorder_level: "\(singleProd?.reorder_level ?? "")",
                                        env: "\(singleProd?.env ?? "")",
                                        variant: "\(singleProd?.variant ?? "")",
                                        reorder_qty: "\(singleProd?.reorder_qty ?? "")",
                                        purchase_qty: "\(singleProd?.purchase_qty ?? "")")
            dupProdVariants.append(emptyProd)
        }
        
        let brand = dupBrandNameLbl
        
        if brand != "" && brand != "<null>" {
            dupSelectBrandLabel.text = ""
            dupBrandInnerView.isHidden = false
            dupBrandName.text = brand
            dupBrandCloseBtn.isHidden = false
        }
        else {
            dupSelectBrandLabel.text = "Select Brand"
            dupBrandInnerView.isHidden = true
            dupBrandName.text = ""
            dupBrandCloseBtn.isHidden = true
        }
        dupBrandInnerView.layer.cornerRadius = 5.0
        
        var isSel = [Bool]()
        for i in 0..<dupProdVariants.count {
            
            if i == 0 {
                isSel.append(true)
            }
            else {
                isSel.append(false)
            }
        }
        
        dupisSelectedData = isSel
        dupVariantsTable.reloadData()
        setCollHeight(coll: scrollView)
    }
    
    @objc func dupGenUpc() {
        
        var upcCode = ""
        
        for upc in 0..<dupProdVariants.count {
            
            if dupProdVariants[upc].upc == "" {
                upcCode = getGeneratedUpc(length: 12)
                dupProdVariants[upc].upc = upcCode
            }
        }
        dupVariantsTable.reloadData()
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
    
    func setCollHeight(coll: UIScrollView) {
        
        if coll == dupCatColl {
            let height = dupCatColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                dupcatcollHeight.constant = 50
            }
            else {
                dupcatcollHeight.constant = height
            }
        }
        
        else if coll == dupTaxesColl {
            let height = dupTaxesColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                duptaxCollHeight.constant = 50
            }
            else {
                duptaxCollHeight.constant = height
            }
        }
        
        else if coll == dupTagColl {
            let height = dupTagColl.collectionViewLayout.collectionViewContentSize.height
            if height <= 50 {
                duptagCollHeight.constant = 50
            }
            else {
                duptagCollHeight.constant = height
            }
        }
        else {
            
        }
        dupattHeight.constant = CGFloat(70 * dupProdOptions.count)
        
        let cat = dupcatcollHeight.constant
        let tag = duptagCollHeight.constant
        let tax = duptaxCollHeight.constant
        
        var var_count = dupProdVariants.count
        
        if var_count == 0 || var_count == 1 {
            
            if dupProdOptions.count == 3 {
                dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 656
                dupAddVarBtn.isHidden = true
                dupAddBtnHeight.constant = 0
                dupAddBtnTop.constant = 0
            }
            else {
                dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 726
                dupAddVarBtn.isHidden = false
                dupAddBtnHeight.constant = 50
                dupAddBtnTop.constant = 20
            }
        }
        else {
            
            var_count -= 1
            if dupProdOptions.count == 3 {
                dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 656 + CGFloat(50 * var_count)
                dupAddVarBtn.isHidden = true
                dupAddBtnHeight.constant = 0
                dupAddBtnTop.constant = 0
            }
            else {
                dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 726 + CGFloat(50 * var_count)
                dupAddVarBtn.isHidden = false
                dupAddBtnHeight.constant = 50
                dupAddBtnTop.constant = 20
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func openCatScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateDuplicate = self
        vc.catMode = "dupProductVC"
        vc.selectCategory = dupProdCat
        vc.apiMode = "category"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func openBrandScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateDuplicate = self
        vc.catMode = "dupProductVC"
        let brand = dupBrandName.text ?? ""
        vc.selectBrandsTags = [brand]
        vc.apiMode = "brands"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @objc func openTagScreen() {
        
        if dupProdTag.count == 15 {
            ToastClass.sharedToast.showToast(message: "You cannot select more than 15 items",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
            
            vc.delegateDuplicate = self
            vc.catMode = "dupProductVC"
            vc.selectBrandsTags = dupProdTag
            vc.apiMode = "tags"
            present(vc, animated: true, completion: {
                vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            })
        }
    }
    
    @objc func openTaxScreen() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateDuplicate = self
        vc.catMode = "dupProductVC"
        vc.taxes = dupArrTaxes
        vc.selectTaxes = dupProdTaxes
        vc.apiMode = "taxes"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    
    @IBAction func dupAttDeleteClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "red_delete") {
            
            let position = sender.tag
            dupProdOptions.remove(at: position)
            
            if dupresult.count == 0 {
                
                if dupProdOptions.count == 2 {
                    
                    if position == 0 {
                        duparrOptVl1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                        duparrOptVl2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                        duparrOptVl3 = []
                    }
                    else if position == 1 {
                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                        duparrOptVl2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                        duparrOptVl3 = []
                    }
                    else {
                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                        duparrOptVl2 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                        duparrOptVl3 = []
                    }
                }
                
                else if dupProdOptions.count == 1 {
                    if position == 0 {
                        duparrOptVl1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                        duparrOptVl2 = []
                        duparrOptVl3 = []
                    }
                    else if position == 1 {
                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                        duparrOptVl2 = []
                        duparrOptVl3 = []
                    }
                    else {
                        duparrOptVl1 = []
                        duparrOptVl2 = []
                        duparrOptVl3 = []
                    }
                }
                
                else {
                    duparrOptVl1 = []
                    duparrOptVl2 = []
                    duparrOptVl3 = []
                }
                
                //                if position == 0 {
                //
                //                    if dupProdOptions.count == 1 {
                //                        duparrOptVl1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                //                        duparrOptVl2 = []
                //                        duparrOptVl3 = []
                //                    }
                //                    else if dupProdOptions.count == 2 {
                //                        duparrOptVl1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                //                        duparrOptVl2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                //                        duparrOptVl3 = []
                //                    }
                //                    else { //0
                //                        duparrOptVl1 = []
                //                        duparrOptVl2 = []
                //                        duparrOptVl3 = []
                //                    }
                //                }
                //
                //                else if position == 1 {
                //                    if dupProdOptions.count == 1 {
                //                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                //                        duparrOptVl2 = []
                //                        duparrOptVl3 = []
                //                    }
                //                    else if dupProdOptions.count == 2 {
                //                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                //                        duparrOptVl2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                //                        duparrOptVl3 = []
                //                    }
                //                    else { //0
                //                    }
                //                }
                //
                //                else { //2
                //                    if dupProdOptions.count == 2 {
                //                        duparrOptVl1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                //                        duparrOptVl2 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                //                        duparrOptVl3 = []
                //                    }
                //                    else {}
                //                }
            }
            
            else {
                
                if dupProdOptions.count == 2 {
                    
                    if position == 0 {
                        duparrOptVl1 = duparrOptVl2
                        duparrOptVl2 = duparrOptVl3
                        duparrOptVl3 = []
                    }
                    
                    else if position == 1 {
                        duparrOptVl2 = duparrOptVl3
                        duparrOptVl3 = []
                    }
                    
                    else {
                        duparrOptVl3 = []
                    }
                    
                }
                else if dupProdOptions.count == 1 {
                    
                    if position == 0 {
                        duparrOptVl1 = duparrOptVl2
                        duparrOptVl2 = []
                        duparrOptVl3 = []
                    }
                    else if position == 1 {
                        duparrOptVl2 = []
                        duparrOptVl3 = []
                    }
                }
                else {
                    duparrOptVl1 = []
                    
                }
            }
            
            dupAttTable.reloadData()
            dupattHeight.constant = CGFloat(70 * dupProdOptions.count)
            
            if dupProdOptions.count < 3 {
                dupAddVarBtn.isHidden = false
                dupAddBtnHeight.constant = 50
            }
            else {
                dupAddVarBtn.isHidden = true
                dupAddBtnHeight.constant = 0
            }
            
            dupRefreshVariantTable()
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dupTrackQtyClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            
            dupProdVariants[sender.tag].trackqnty = "1"
            
            
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            dupProdVariants[sender.tag].trackqnty = "0"
        }
    }
    
    
    @IBAction func dupSellClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            dupProdVariants[sender.tag].isstockcontinue = "1"
            
            
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            dupProdVariants[sender.tag].isstockcontinue = "0"
        }
    }
    
    
    @IBAction func dupCheckIdClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            dupProdVariants[sender.tag].is_tobacco = "1"
            
            
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            dupProdVariants[sender.tag].is_tobacco = "0"
        }
    }
    
    
    @IBAction func dupDisableClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            dupProdVariants[sender.tag].disable = "1"
            
            
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            dupProdVariants[sender.tag].disable = "0"
        }
    }
    
    
    @IBAction func dubFoodClick(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            sender.setImage(UIImage(named: "check inventory"), for: .normal)
            dupProdVariants[sender.tag].food_stampable = "1"
            
            
        }
        else {
            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            dupProdVariants[sender.tag].food_stampable = "0"
        }
        
    }
    
    
    @IBAction func dupBrandCloseClick(_ sender: UIButton) {
        
        dupSelectBrandLabel.text = "Select Brand"
        dupBrandInnerView.isHidden = true
        dupBrandName.text = ""
        dupBrandCloseBtn.isHidden = true
    }
    
    
    @IBAction func dupCloseCatClick(_ sender: UIButton) {
        
        dupProdCat.remove(at: sender.tag)
        dupCatColl.reloadData()
    }
    
    
    @IBAction func dupTaxCloseClick(_ sender: UIButton) {
        
        dupProdTaxes.remove(at: sender.tag)
        dupTaxesColl.reloadData()
    }
    
    
    @IBAction func dupTagCloseClick(_ sender: UIButton) {
        
        dupProdTag.remove(at: sender.tag)
        dupTagColl.reloadData()
    }
    
    
    @IBAction func dupAddVarClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addVariantAtt") as! AddVariantAttributeViewController
        
        dupVariantMode = "add"
        vc.subMode = dupVariantMode
        vc.mode = "add"
        vc.goMode = dupVariantGoMode
        if dupProdOptions.count == 0 {
            vc.selectedAtt = []
        }
        else  {
            vc.selectedAtt = dupProdOptions
        }
        
        if dupProdOptions.count == 0 {
        }
        else if dupProdOptions.count == 1 {
            let opt = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
            duparrOptVl1 = opt
        }
        else {
            let opt1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
            duparrOptVl1 = opt1
            let opt2 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
            duparrOptVl2 = opt2
        }
        
        vc.delegateDuplicate = self
        present(vc, animated: true)
    }
    
    
    @IBAction func dupOpenScan(_ sender: UIButton) {
        
        scanDupIndex = sender.tag
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
        
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        validateDupParams()
    }
    
    func validateDupParams() {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = dupProductField.text, name != "" else {
            dupProductField.isErrorView(numberOfShakes: 3, revert: true)
            ToastClass.sharedToast.showToast(message: "Enter product name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        let desc = dupDescField.text ?? ""
        
        let brand = dupBrandName.text ?? ""
        
        var tags = ""
        
        if dupProdTag.count == 0 {
            tags = ""
        }
        else {
            tags = dupProdTag.joined(separator: ",")
        }
        
        guard dupProdCat.count != 0 else {
            ToastClass.sharedToast.showToast(message: "Category not selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        
        var small = [String]()
        for cat in dupProdCat {
            small.append(cat.id)
        }
        
        var smalltax = [String]()
        for tax in dupProdTaxes {
            smalltax.append(tax.id)
        }
        
        let collection = small.joined(separator: ",")
        
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
        
        if dupProdOptions.count == 0 {
            
            let index = IndexPath(row: 0, section: 0)
            let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
            let costperitem = dupProdVariants[0].costperItem
            
            guard let price = dupProdVariants[0].price, price != "", price != "0.00" else {
                cell.price.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let c_price = price
            let c_compareprice = dupProdVariants[0].compare_price
            
            if c_compareprice != "" && c_compareprice != "0.00" {
                
                let newCompareprice = Double(c_compareprice)!
                let newPrice = Double(c_price)!
                
                guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                    ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                    
                    return
                }
            }
            
            let margin = dupProdVariants[0].margin
            let profit = dupProdVariants[0].profit
            
            guard let quant = dupProdVariants[0].quantity, quant != "" else {
                cell.qty.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let custom_code = dupProdVariants[0].custom_code
            
            guard let upc_code = dupProdVariants[0].upc, upc_code != "" else {
                cell.upcCode.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            let trackqnty = dupProdVariants[0].trackqnty
            let isstockcontinue = dupProdVariants[0].isstockcontinue
            let is_tobacco = dupProdVariants[0].is_tobacco
            let disable = dupProdVariants[0].disable
            let food_stampable = dupProdVariants[0].food_stampable
            
            var reorder_qty = dupProdVariants[0].reorder_qty
            
            if reorder_qty == "" {
                reorder_qty = "0"
            }
            
            var reorder_level = dupProdVariants[0].reorder_level
            
            if reorder_qty == "" {
                reorder_level = "0"
            }
            
            loadIndicator.isAnimating = true
            
            dupSaveBtn.isEnabled = false
            
            ApiCalls.sharedCall.productDuplicateProduct(merchant_id: m_id, admin_id: m_id, title: name,
                                                        alternateName: "",
                                                        description: desc,
                                                        brand: brand, tags: tags,
                                                        price: price, compare_price: c_compareprice,
                                                        costperItem: costperitem, margin: margin,
                                                        profit: profit, ischargeTax: ischargeTax,
                                                        sku: "", upc: upc_code, custom_code: custom_code,
                                                        barcode: "", trackqnty: trackqnty,
                                                        isstockcontinue: isstockcontinue,
                                                        quantity: quant,
                                                        ispysical_product: "", country_region: "",
                                                        collection: collection,
                                                        HS_code: "", isvarient: "0", is_lottery: "0",
                                                        multiplefiles: "", img_color_lbl: "",
                                                        created_on: "", productid: "",
                                                        optionarray: "",
                                                        optionarray1: "",
                                                        optionarray2: "",
                                                        optionvalue: "",
                                                        optionvalue1: "",
                                                        optionvalue2: "",
                                                        other_taxes: other_taxes,
                                                        bought_product: "", featured_product: "",
                                                        varvarient: "", varprice: "", varquantity: "",
                                                        varsku: "", varbarcode: "", files: "",
                                                        doc_file: "", optionid: "", varupc: "",
                                                        varcustomcode: "", reorder_qty: reorder_qty,
                                                        reorder_level: reorder_level,
                                                        reorder_cost: "",
                                                        is_tobacco: is_tobacco, disable: disable,
                                                        food_stampable: food_stampable,
                                                        vartrackqnty: "", varcontinue_selling: "", varcheckid: "",
                                                        vardisable: "", varfood_stampable: "", varmargin: "", varprofit: "",
                                                        varreorder_qty: "", varreorder_level: "",
                                                        varreorder_cost: "", varcostperitem: "",
                                                        varcompareprice: "", var_id: "") { isSuccess, responseData in
                
                if isSuccess {
                    
                    if let list = responseData["message"] as? String {
                        print(list)
                        if list == "Success" {
                            self.loadIndicator.isAnimating = false
                            ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            
                            var destiny = 0
                            
                            let viewcontrollerArray = self.navigationController?.viewControllers
                            
                            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                                destiny = destinationIndex
                            }
                            
                            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                            
                            self.dupSaveBtn.isEnabled = true
                        }
                    }
                    else{
                        ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        self.loadIndicator.isAnimating = false
                        self.dupSaveBtn.isEnabled = true
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
            var reorderQty_arr = [String]()
            var reorderLevel_arr = [String]()
            
            
            var track_arr = [String]()
            var sell_arr = [String]()
            var check_arr = [String]()
            var disable_arr = [String]()
            var foodStamp_arr = [String]()
            
            var v_variant_arr = [String]()
            
            for product in 0..<dupProdVariants.count {
                
                let costperitem = dupProdVariants[product].costperItem
                cost_item_arr.append(costperitem)
                
                guard let price = dupProdVariants[product].price, price != "", price != "0.00" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.price.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Enter valid price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                price_arr.append(price)
                
                let c_price = price
                let c_compareprice = dupProdVariants[product].compare_price
                
                if c_compareprice != "" && c_compareprice != "0.00" {
                    
                    let newCompareprice = Double(c_compareprice)!
                    let newPrice = Double(c_price)!
                    
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    guard newPrice.isLessThanOrEqualTo(newCompareprice) else  {
                        ToastClass.sharedToast.showToast(message: "Compare price must be greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        cell.comparePrice.isError(numberOfShakes: 3, revert: true)
                        
                        return
                    }
                }
                
                compare_arr.append(c_compareprice)
                margin_arr.append(dupProdVariants[product].margin)
                profit_arr.append(dupProdVariants[product].profit)
                
                guard let quant = dupProdVariants[product].quantity, quant != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    cell.qty.isError(numberOfShakes: 3, revert: true)
                    ToastClass.sharedToast.showToast(message: "Please Enter Quantity", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    return
                }
                
                quantity_arr.append(quant)
                custom_arr.append(dupProdVariants[product].custom_code)
                
                guard let upcCode = dupProdVariants[product].upc, upcCode != "" else {
                    sayAct(tag: product)
                    let index = IndexPath(row: 0, section: product)
                    let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
                    ToastClass.sharedToast.showToast(message: "Enter UPC code", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    return
                }
                upc_arr.append(upcCode)
                
                if dupresult.count == 0 {
                    v_variant_arr.append(dupProdVariants[product].variant)
                }
                
                track_arr.append(dupProdVariants[product].trackqnty)
                sell_arr.append(dupProdVariants[product].isstockcontinue)
                check_arr.append(dupProdVariants[product].is_tobacco)
                disable_arr.append(dupProdVariants[product].disable)
                foodStamp_arr.append(dupProdVariants[product].food_stampable)
                
                reorderQty_arr.append(dupProdVariants[product].reorder_qty)
                reorderLevel_arr.append(dupProdVariants[product].reorder_level)
                
            }
            
            if dupresult.count != 0 {
                v_variant_arr = dupresult
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
            
            if dupProdOptions.count > 0 {
                
                for opt in 0..<dupProdOptions.count {
                    
                    if opt == 0 {
                        
                        if dupProdOptions[opt].options1 == "" && dupProdOptions[opt].options2 == "" {
                            optionarray = dupProdOptions[opt].options3
                        }
                        else if dupProdOptions[opt].options2 == "" && dupProdOptions[opt].options3 == "" {
                            optionarray = dupProdOptions[opt].options1
                        }
                        else {
                            optionarray = dupProdOptions[opt].options2
                        }
                        
                        if dupProdOptions[opt].optionsvl1 == "" && dupProdOptions[opt].optionsvl2 == "" {
                            optionvalue = dupProdOptions[opt].optionsvl3
                        }
                        else if dupProdOptions[opt].optionsvl2 == "" && dupProdOptions[opt].optionsvl3 == "" {
                            optionvalue = dupProdOptions[opt].optionsvl1
                        }
                        else {
                            optionvalue = dupProdOptions[opt].optionsvl2
                        }
                    }
                    
                    else if opt == 1 {
                        if dupProdOptions[opt].options1 == "" && dupProdOptions[opt].options2 == "" {
                            optionarray1 = dupProdOptions[opt].options3
                        }
                        else if dupProdOptions[opt].options2 == "" && dupProdOptions[opt].options3 == "" {
                            optionarray1 = dupProdOptions[opt].options1
                        }
                        else {
                            optionarray1 = dupProdOptions[opt].options2
                        }
                        
                        if dupProdOptions[opt].optionsvl1 == "" && dupProdOptions[opt].optionsvl2 == "" {
                            optionvalue1 = dupProdOptions[opt].optionsvl3
                        }
                        else if dupProdOptions[opt].optionsvl2 == "" && dupProdOptions[opt].optionsvl3 == "" {
                            optionvalue1 = dupProdOptions[opt].optionsvl1
                        }
                        else {
                            optionvalue1 = dupProdOptions[opt].optionsvl2
                        }
                    }
                    
                    else {
                        if dupProdOptions[opt].options1 == "" && dupProdOptions[opt].options2 == "" {
                            optionarray2 = dupProdOptions[opt].options3
                        }
                        else if dupProdOptions[opt].options2 == "" && dupProdOptions[opt].options3 == "" {
                            optionarray2 = dupProdOptions[opt].options1
                        }
                        else {
                            optionarray2 = dupProdOptions[opt].options2
                        }
                        
                        if dupProdOptions[opt].optionsvl1 == "" && dupProdOptions[opt].optionsvl2 == "" {
                            optionvalue2 = dupProdOptions[opt].optionsvl3
                        }
                        else if dupProdOptions[opt].optionsvl2 == "" && dupProdOptions[opt].optionsvl3 == "" {
                            optionvalue2 = dupProdOptions[opt].optionsvl1
                        }
                        else {
                            optionvalue2 = dupProdOptions[opt].optionsvl2
                        }
                    }
                }
            }
            
            loadIndicator.isAnimating = true
            dupSaveBtn.isEnabled = false
            
            ApiCalls.sharedCall.productDuplicateProduct(merchant_id: m_id, admin_id: m_id,
                                                        title: name, alternateName: "",
                                                        description: desc,
                                                        brand: brand, tags: tags,
                                                        price: "", compare_price: "",
                                                        costperItem: "", margin: "", profit: "",
                                                        ischargeTax: ischargeTax, sku: "", upc: "", custom_code: "",
                                                        barcode: "", trackqnty: "", isstockcontinue: "",
                                                        quantity: "", ispysical_product: "", country_region: "",
                                                        collection: collection,
                                                        HS_code: "", isvarient: "1", is_lottery: "0",
                                                        multiplefiles: "", img_color_lbl: "", created_on: "",
                                                        productid: "",
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
                                                        optionid: "", varupc: varupc,
                                                        varcustomcode: varcustomcode,
                                                        reorder_qty: "", reorder_level: "",
                                                        reorder_cost: "", is_tobacco: "", disable: "",
                                                        food_stampable: "", vartrackqnty: vartrackqnty,
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
                                                        var_id: "") { isSuccess, responseData in
                
                if isSuccess {
                    
                    if let list = responseData["message"] as? String {
                        print(list)
                        if list == "Success" {
                            ToastClass.sharedToast.showToast(message: "Successfully created product", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                var destiny = 0
                                
                                let viewcontrollerArray = self.navigationController?.viewControllers
                                
                                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                                    destiny = destinationIndex
                                }
                                
                                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                                self.dupSaveBtn.isEnabled = true
                        }
                        else{
                            ToastClass.sharedToast.showToast(message: "Product already exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.dupSaveBtn.isEnabled = true
                        }
                    }
                }
                else {
                    
                }
            }
        }
    }
}

extension DuplicatePlusViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        
        if textField == dupProductField {
            
        }
        
        else {
            
            let index = IndexPath(row: 0, section: textField.tag)
            let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
            
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
                    
                    dupProdVariants[index.section].costperItem = cost_per_item
                    dupProdVariants[index.section].price = price
                    dupProdVariants[index.section].margin = margin
                    dupProdVariants[index.section].profit = profit
                    
                    for variants in 0..<dupProdVariants.count {
                        
                        if dupProdVariants[variants].costperItem == "0.00" {
                            dupProdVariants[variants].costperItem = cost_per_item
                            dupProdVariants[variants].price = price
                            dupProdVariants[index.section].margin = margin
                            dupProdVariants[index.section].profit = profit
                        }
                    }
                    dupVariantsTable.reloadData()
                }
                
                else {
                    
                    let cost_per_value_doub = Double(cost_per_value) ?? 0.00
                    let percent = cost_per_value_doub/100
                    
                    let cost_per_item_doub = Double(cost_per_item) ?? 0.00
                    let profit = cost_per_item_doub * percent
                    let price = cost_per_item_doub + profit
                    let margin = (profit / price) * 100
                    
                    dupProdVariants[index.section].costperItem = String(format: "%.2f", cost_per_item_doub)
                    dupProdVariants[index.section].price = String(format: "%.2f", price)
                    dupProdVariants[index.section].margin = String(format: "%.2f", margin)
                    dupProdVariants[index.section].profit = String(format: "%.2f", profit)
                    
                    print(dupProdVariants.count)
                    for variants in 0..<dupProdVariants.count {
                        
                        if dupProdVariants[variants].costperItem == "0.00" {
                            dupProdVariants[variants].costperItem = cost_per_item
                            dupProdVariants[variants].price = String(format: "%.2f", price)
                            dupProdVariants[variants].margin = String(format: "%.2f", margin)
                            dupProdVariants[variants].profit = String(format: "%.2f", profit)
                        }
                    }
                    dupVariantsTable.reloadData()
                }
            }
            
            else if textField == cell.price {
                
                let price = cell.price.text ?? "0.00"
                dupProdVariants[index.section].price = price
                let cpi = dupProdVariants[index.section].costperItem
                
                let cost_per_doub = Double(cpi) ?? 0.00
                let price_doub = Double(price) ?? 0.00
                
                if cost_per_doub == 0.00 {
                    let profit = ""
                    let margin = ""
                    dupProdVariants[index.section].margin = String(format: "%.2f", margin)
                    dupProdVariants[index.section].profit = String(format: "%.2f", profit)
                    
                    for variants in 0..<dupProdVariants.count {
                        
                        if dupProdVariants[variants].price == "0.00" {
                            dupProdVariants[variants].price = price
                            dupProdVariants[index.section].margin = String(format: "%.2f", margin)
                            dupProdVariants[index.section].profit = String(format: "%.2f", profit)
                        }
                    }
                }
                else {
                    let profit = price_doub - cost_per_doub
                    let margin = (profit / price_doub) * 100
                    dupProdVariants[index.section].margin = String(format: "%.2f", margin)
                    dupProdVariants[index.section].profit = String(format: "%.2f", profit)
                    
                    for variants in 0..<dupProdVariants.count {
                        
                        if dupProdVariants[variants].price == "0.00" {
                            dupProdVariants[variants].price = price
                            dupProdVariants[index.section].margin = String(format: "%.2f", margin)
                            dupProdVariants[index.section].profit = String(format: "%.2f", profit)
                        }
                    }
                }
                dupVariantsTable.reloadData()
                
            }
            else if textField == cell.comparePrice {
                
                let cprice = cell.comparePrice.text ?? ""
                dupProdVariants[index.section].compare_price = cprice
                dupVariantsTable.reloadData()
                
                for variants in 0..<dupProdVariants.count {
                    
                    if dupProdVariants[variants].compare_price == "" {
                        dupProdVariants[variants].compare_price = cprice
                    }
                }
                dupVariantsTable.reloadData()
            }
            else if textField == cell.qty {
                
                let quty = cell.qty.text ?? ""
                dupProdVariants[index.section].quantity = quty
                dupVariantsTable.reloadData()
                
                for variants in 0..<dupProdVariants.count {
                    
                    if dupProdVariants[variants].quantity == "" {
                        dupProdVariants[variants].quantity = quty
                    }
                }
                dupVariantsTable.reloadData()
            }
            else if textField == cell.customCode {
                let custom = cell.customCode.text ?? ""
                dupProdVariants[index.section].custom_code = custom
                dupVariantsTable.reloadData()
            }
            else if textField == cell.reorderQty {
                let reqty = cell.reorderQty.text ?? ""
                dupProdVariants[index.section].reorder_qty = reqty
                dupVariantsTable.reloadData()
            }
            else if textField == cell.reorderLevel {
                let relevel = cell.reorderLevel.text ?? ""
                dupProdVariants[index.section].reorder_level = relevel
                dupVariantsTable.reloadData()
            }
            else if textField == cell.upcCode {
                
                let upcText = cell.upcCode.text ?? ""
                
                if upcText == "" {
                    dupProdVariants[index.section].upc = ""
                }
                else {
                    
                    let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
                    
                    if upcUnique.contains(upcText) {
                        ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        cell.upcCode.isError(numberOfShakes: 3, revert: true)
                        cell.upcCode.text = ""
                        dupProdVariants[index.section].upc = ""
                    }
                    else {
                        
                        if dupProdVariants.contains(where: {$0.upc == upcText}) {
                            
                            if textField.tag  == dupProdVariants.firstIndex(where: {$0.upc == upcText}) {
                                
                                dupProdVariants[index.section].upc = upcText
                                dupVariantsTable.reloadData()
                            }
                            else {
                                
                                ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                cell.upcCode.isError(numberOfShakes: 3, revert: true)
                                cell.upcCode.text = ""
                                dupProdVariants[index.section].upc = ""
                            }
                        }
                        else {
                            
                            dupProdVariants[index.section].upc = upcText
                            dupVariantsTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dupProductField {
            activeTextField = textField
        }
        else {
            let index = IndexPath(row: 0, section: textField.tag)
            let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
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
    
    
    
    @objc func dupUpdateTextField(textField: MDCOutlinedTextField) {
        
        var cleanedAmount = ""
        
        for character in textField.text ?? "" {
            print(cleanedAmount)
            if character.isNumber {
                cleanedAmount.append(character)
            }
            print(cleanedAmount)
        }
        
        if isDupSymbolOnRight {
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
    
    @objc func dupUpdateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if textField == dupProductField {
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
            let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
            
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

extension DuplicatePlusViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        let urlString = code
        
        let index = IndexPath(row: 0, section: scanDupIndex)
        let cell = dupVariantsTable.cellForRow(at: index) as! ProductVariantTableViewCell
        
        let upcUnique = UserDefaults.standard.stringArray(forKey: "upcs_list") ?? []
        if upcUnique.contains(urlString) {
            controller.dismiss(animated: true)
            ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            cell.upcCode.isError(numberOfShakes: 3, revert: true)
            cell.upcCode.text = ""
            dupProdVariants[scanDupIndex].upc = ""
        }
        else {
            
            if dupProdVariants.contains(where: {$0.upc == urlString}) {
                
                if scanDupIndex == dupProdVariants.firstIndex(where: {$0.upc == urlString}) {
                    dupProdVariants[scanDupIndex].upc = urlString
                    dupVariantsTable.reloadData()
                    controller.dismiss(animated: true)
                }
                else {
                    controller.dismiss(animated: true)
                    ToastClass.sharedToast.showToast(message: "Duplicate upc found", font:  UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    cell.upcCode.isError(numberOfShakes: 3, revert: true)
                    cell.upcCode.text = ""
                    dupProdVariants[scanDupIndex].upc = ""
                }
            }
            else {
                dupProdVariants[scanDupIndex].upc = urlString
                print(urlString)
                dupVariantsTable.reloadData()
                controller.dismiss(animated: true)
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

extension DuplicatePlusViewController: PlusSelectedCategory {
    
    func getSelectedCats(reverseCategory: [InventoryCategory], reverseBrandsTags: [String],
                         reverseTaxes: [SetupTaxes], apiMode: String) {
        
        scroll.isHidden = true
        loadingIndicator.isAnimating = true
        
        if apiMode == "category" {
            dupProdCat = reverseCategory
            if reverseCategory.count == 0 {
                dupCatColl.reloadData()
                setCollHeight(coll: dupCatColl)
            }
            else {
                dupCatColl.reloadData()
            }
        }
        else if apiMode == "brands" {
            if reverseBrandsTags.count != 0 {
                dupSelectBrandLabel.text = ""
                dupBrandInnerView.isHidden = false
                dupBrandName.text = reverseBrandsTags[0]
                dupBrandCloseBtn.isHidden = false
            }
            else {
                dupSelectBrandLabel.text = "Select Brand"
                dupBrandInnerView.isHidden = true
                dupBrandName.text = ""
                dupBrandCloseBtn.isHidden = true
            }
            dupBrandInnerView.layer.cornerRadius = 5.0
        }
        else if apiMode == "tags" {
            
            var smallTag = [String]()
            
            for tag in reverseBrandsTags {
                smallTag.append(tag)
            }
            dupProdTag = smallTag
            if smallTag.count == 0 {
                dupTagColl.reloadData()
                setCollHeight(coll: dupTagColl)
            }
            else {
                dupTagColl.reloadData()
            }
        }
        else {
            dupProdTaxes = reverseTaxes
            if reverseTaxes.count == 0 {
                dupTaxesColl.reloadData()
                setCollHeight(coll: dupTaxesColl)
            }
            else {
                dupTaxesColl.reloadData()
            }
        }
        scroll.isHidden = false
        loadingIndicator.isAnimating = false
    }
}

extension DuplicatePlusViewController: PlusAttributeVariant {
    
    func getAddedAtttributes(optName: String, optValue: String, newEdit: [String]) {
        
        if dupVariantMode == "add" {
            
            if dupProdOptions.count == 0 {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: optName, optionsvl1: optValue,
                                              options2: "", optionsvl2: "",
                                              options3: "", optionsvl3: "",
                                              merchant_id: "", admin_id: "")
                dupProdOptions = [option]
                duparrOptVl1 = option.optionsvl1.components(separatedBy: ",")
            }
            else if dupProdOptions.count == 1 {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: "", optionsvl1: "",
                                              options2: optName, optionsvl2: optValue,
                                              options3: "", optionsvl3: "",
                                              merchant_id: "", admin_id: "")
                dupProdOptions.append(option)
                duparrOptVl2 = option.optionsvl2.components(separatedBy: ",")
            }
            else {
                
                let option = InventoryOptions(id: "", product_id: "",
                                              options1: "", optionsvl1: "",
                                              options2: "", optionsvl2: "",
                                              options3: optName, optionsvl3: optValue,
                                              merchant_id: "", admin_id: "")
                dupProdOptions.append(option)
                duparrOptVl3 = option.optionsvl3.components(separatedBy: ",")
            }
        }
        else {
            
            if dupattIndex == 0 {
                dupProdOptions[dupattIndex].optionsvl1 = optValue
                duparrOptVl1 = optValue.components(separatedBy: ",")
            }
            else if dupattIndex == 1 {
                dupProdOptions[dupattIndex].optionsvl2 = optValue
                duparrOptVl2 = optValue.components(separatedBy: ",")
            }
            else if dupattIndex == 2 {
                dupProdOptions[dupattIndex].optionsvl3 = optValue
                duparrOptVl3 = optValue.components(separatedBy: ",")
            }
            else {
                
            }
        }
        
        dupRefreshVariantTable()
    }
    
    func dupRefreshVariantTable() {
        
        if duparrOptVl1.count == 1 && duparrOptVl2.count == 0 && duparrOptVl3.count == 0 {
            dupresult = [duparrOptVl1[0]]
        }
        
        else if duparrOptVl1.count == 1 && duparrOptVl2.count == 1 && duparrOptVl3.count == 0 {
            dupresult = ["\(duparrOptVl1[0])/\(duparrOptVl2[0])"]
        }
        
        else if duparrOptVl1.count == 1 && duparrOptVl2.count == 1 && duparrOptVl3.count == 1 {
            dupresult = ["\(duparrOptVl1[0])/\(duparrOptVl2[0])/\(duparrOptVl3[0])"]
        }
        
        else if duparrOptVl1.count > 0 && duparrOptVl2.count == 0 && duparrOptVl3.count == 0 {
            dupresult = duparrOptVl1
        }
        
        else if duparrOptVl1.count > 0 && duparrOptVl2.count > 0 && duparrOptVl3.count == 0 {
            
            let res = duparrOptVl1.flatMap { s1 in
                duparrOptVl2.map { s2 in
                    "\(s1)/\(s2)"
                }
            }
            
            var endResult = [String]()
            
            for combo in res {
                
                if dupresult.contains(combo) {}
                else {
                    endResult.append(combo)
                }
            }
            dupresult.append(contentsOf: endResult)
            
            let filter = dupresult.filter{res.contains($0)}
            dupresult = filter
        }
        
        else if duparrOptVl1.count > 0 && duparrOptVl2.count > 0 && duparrOptVl3.count > 0 {
            
            let res = duparrOptVl1.flatMap { s1 in
                duparrOptVl2.flatMap { s2 in
                    duparrOptVl3.map { s3 in
                        "\(s1)/\(s2)/\(s3)"
                    }
                }
            }
            
            var endResult = [String]()
            
            for combo in res {
                
                if dupresult.contains(combo) {}
                else {
                    endResult.append(combo)
                }
            }
            dupresult.append(contentsOf: endResult)
            
            let filter = dupresult.filter{res.contains($0)}
            dupresult = filter
        }
        
        else {
            dupresult = []
        }
        
        if dupresult.count == 0 {
            
            let count = dupProdVariants.count - 1
            dupProdVariants.removeLast(count)
            dupisSelectedData.removeLast(count)
        }
        
        else if dupresult.count > dupProdVariants.count {
            
            let count = dupresult.count - dupProdVariants.count
            for _ in 0..<count {
                dupProdVariants.append(ProductById(alternateName: "", admin_id: "", description: "", starting_quantity: "", margin: "",
                                                   brand: "", tags: "", upc: "", id: "", sku: "", disable: "0", food_stampable: "0",
                                                   isvarient: "", is_lottery: "", title: "", quantity: "", ischargeTax: "",
                                                   updated_on: "", isstockcontinue: "1", trackqnty: "1", profit: "", custom_code: "",
                                                   assigned_vendors: "", barcode: "", country_region: "", ispysical_product: "",
                                                   show_status: "", HS_code: "", price: "0.00", featured_product: "", merchant_id: "",
                                                   created_on: "", prefferd_vendor: "", reorder_cost: "", other_taxes: "",
                                                   buy_with_product: "", costperItem: "0.00", is_tobacco: "0", product_doc: "", user_id: "",
                                                   media: "", compare_price: "", loyalty_product_id: "", show_type: "", cotegory: "",
                                                   reorder_level: "", env: "", variant: "", reorder_qty: "", purchase_qty: ""))
                dupisSelectedData.append(false)
            }
        }
        else if dupresult.count < dupProdVariants.count {
            let count = dupProdVariants.count - dupresult.count
            dupProdVariants.removeLast(count)
            dupisSelectedData.removeLast(count)
        }
        
        if dupisSelectedData.allSatisfy({$0 == false}) {
            let count = dupisSelectedData.count - 1
            dupisSelectedData[count] = true
        }
        
        dupAttTable.reloadData()
        dupVariantsTable.reloadData()
        setCollHeight(coll: dupAttTable)
    }
}

extension DuplicatePlusViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == dupCatColl {
            
            return dupProdCat.count
        }
        
        else if collectionView == dupTagColl {
            
            return dupProdTag.count
        }
        
        else {
            
            return dupProdTaxes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dupCatColl {
            
            let cell = dupCatColl.dequeueReusableCell(withReuseIdentifier: "catcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = dupProdCat[indexPath.row].title
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: dupCatColl)
            
            return cell
            
        }
        
        else if collectionView == dupTagColl {
            
            let cell = dupTagColl.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = dupProdTag[indexPath.row]
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: dupTagColl)
            
            return cell
        }
        
        else {
            
            let cell = dupTaxesColl.dequeueReusableCell(withReuseIdentifier: "taxcell", for: indexPath) as! PlusCollCollectionViewCell
            
            cell.catPlusLbl.text = dupProdTaxes[indexPath.row].title
            cell.borderview.layer.cornerRadius = 5.0
            cell.closeBtn.tag = indexPath.row
            
            setCollHeight(coll: dupTaxesColl)
            
            return cell
        }
    }
}

extension DuplicatePlusViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == dupVariantsTable {
            return dupProdVariants.count
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == dupVariantsTable {
            if dupisSelectedData[section] {
                return 1
            }
            else {
                return 0
            }
        }
        else {
            return dupProdOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dupVariantsTable {
            
            let cell = dupVariantsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductVariantTableViewCell
            
            createCustomTextField(textField: cell.costPerItem)
            createCustomTextField(textField: cell.price)
            createCustomTextField(textField: cell.margin)
            createCustomTextField(textField: cell.profit)
            createCustomTextField(textField: cell.comparePrice)
            createCustomTextField(textField: cell.qty)
            createCustomTextField(textField: cell.customCode)
            createCustomTextField(textField: cell.upcCode)
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
            
            
            cell.price.label.text = "Price"
            cell.comparePrice.label.text = "Compare At Price"
            cell.costPerItem.label.text = "Cost Per Item"
            cell.margin.label.text = "Margin(%)"
            cell.profit.label.text = "Profit($)"
            cell.qty.label.text = "QTY"
            cell.customCode.label.text = "Custom Code"
            cell.upcCode.label.text = "UPC Code"
            cell.reorderQty.label.text = "Reorder Qty"
            cell.reorderLevel.label.text = "Reorder Level"
            
            cell.price.keyboardType = .numberPad
            cell.comparePrice.keyboardType = .numberPad
            cell.costPerItem.keyboardType = .numberPad
            cell.qty.keyboardType = .numberPad
            cell.reorderQty.keyboardType = .numberPad
            cell.reorderLevel.keyboardType = .numberPad
            
            
            cell.costPerItem.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
            cell.price.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
            cell.comparePrice.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
            cell.margin.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
            cell.profit.addTarget(self, action: #selector(dupUpdateTextField), for: .editingChanged)
            
            
            cell.reorderQty.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
            cell.reorderLevel.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
            cell.qty.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
            cell.customCode.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
            cell.upcCode.addTarget(self, action: #selector(dupUpdateText), for: .editingChanged)
            
            cell.costPerItem.tag = indexPath.section
            cell.price.tag = indexPath.section
            cell.comparePrice.tag = indexPath.section
            cell.margin.tag = indexPath.section
            cell.profit.tag = indexPath.section
            cell.qty.tag = indexPath.section
            cell.customCode.tag = indexPath.section
            cell.upcCode.tag = indexPath.section
            cell.reorderQty.tag = indexPath.section
            cell.reorderLevel.tag = indexPath.section
            
            cell.trackQty.tag = indexPath.section
            cell.selling.tag = indexPath.section
            cell.checkID.tag = indexPath.section
            cell.disable.tag = indexPath.section
            cell.foodstampable.tag = indexPath.section
            
            cell.scanBtn.tag = indexPath.section
            
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
            
            let variants = dupProdVariants[indexPath.section]
            
            cell.costPerItem.text = variants.costperItem
            cell.price.text = variants.price
            cell.margin.text = variants.margin
            cell.profit.text = variants.profit
            cell.comparePrice.text = variants.compare_price
            cell.qty.text = variants.quantity
            cell.customCode.text = variants.custom_code
            cell.upcCode.text = variants.upc
            cell.reorderQty.text = variants.reorder_qty
            cell.reorderLevel.text = variants.reorder_level
            
            
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
            
            cell.costItemInner.isHidden = true
            cell.qtyInner.isHidden = true
            return cell
        }
        
        else {
            
            let cell = dupAttTable.dequeueReusableCell(withIdentifier: "attrcell", for: indexPath) as! AddAttrCell
            
            if dupProdOptions[indexPath.row].options1 == "" && dupProdOptions[indexPath.row].options2 == "" {
                cell.attName.text = dupProdOptions[indexPath.row].options3
            }
            else if dupProdOptions[indexPath.row].options2 == "" && dupProdOptions[indexPath.row].options3 == "" {
                cell.attName.text = dupProdOptions[indexPath.row].options1
            }
            else {
                cell.attName.text = dupProdOptions[indexPath.row].options2
            }
            
            cell.delete_btn.setImage(UIImage(named: "red_delete"), for: .normal)
            cell.delete_btn.layer.cornerRadius = 5
            cell.delete_btn.tag = indexPath.row
            cell.borderview.dropAttShadow()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == dupAttTable {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "addVariantAtt") as! AddVariantAttributeViewController
            
            dupVariantMode = "edit"
            vc.subMode = dupVariantMode
            vc.mode = "add"
            vc.goMode = dupVariantGoMode
            
            vc.delegateDuplicate = self
            vc.selectedAtt = dupProdOptions
            let index = indexPath.row
            dupattIndex = index
            vc.options = dupProdOptions[index]
            
            if dupProdOptions.count == 3 {
                
                if index == 0 {
                    let opt1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                    duparrOptVl2 = opt1
                    let opt2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                    duparrOptVl3 = opt2
                }
                else if index == 1 {
                    let opt1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                    duparrOptVl1 = opt1
                    let opt2 = dupProdOptions[2].optionsvl3.components(separatedBy: ",")
                    duparrOptVl3 = opt2
                }
                else {
                    let opt1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                    duparrOptVl1 = opt1
                    let opt2 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                    duparrOptVl2 = opt2
                }
            }
            else if dupProdOptions.count == 2 {
                if index == 0 {
                    let opt1 = dupProdOptions[1].optionsvl2.components(separatedBy: ",")
                    duparrOptVl2 = opt1
                }
                else {
                    let opt1 = dupProdOptions[0].optionsvl1.components(separatedBy: ",")
                    duparrOptVl1 = opt1
                }
            }
            
            present(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == dupVariantsTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 50))
            headerView.backgroundColor = UIColor(hexString: "#F9F9F9")
            headerView.tag = section
            
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRect(x: 10, y: headerView.frame.size.height - 1, width: (headerView.frame.size.width - 20), height: 1)
            
            if dupisSelectedData[section] {
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
            
            if dupProdVariants.count == 1 && dupresult.count == 0 {
                variantLabel.text = ""
            }
            else if dupresult.count > 0 {
                variantLabel.text = dupresult[section]
            }
            else {
                variantLabel.text = dupProdVariants[section].variant
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
        if tableView == dupVariantsTable {
            return 50
        }
        
        else {
            return 0
        }
    }
    
    func sayAct(tag: Int) {
        
        if dupisSelectedData[tag] {
            
        }
        else {
            
            for select in 0..<dupisSelectedData.count {
                
                if select == tag {
                    dupisSelectedData[select] = true
                }
                else {
                    dupisSelectedData[select] = false
                }
            }
            setCollHeight(coll: dupVariantsTable)
            dupVariantsTable.reloadData()
        }
    }
    
    @objc func sayAction(_ gesture: UITapGestureRecognizer) {
        
        let tagView = gesture.view?.tag ?? 0
        
        if dupProdVariants.count == 1 {
            
            let cat = dupcatcollHeight.constant
            let tag = duptagCollHeight.constant
            let tax = duptaxCollHeight.constant
            
            if dupisSelectedData[tagView] {
                //                dupisSelectedData[tagView].toggle()
                //
                //                if dupProdOptions.count == 3 {
                //                    dupScrollHeight.constant = 648 + cat + tax + dupattHeight.constant + 150
                //                    dupAddVarBtn.isHidden = true
                //                    dupAddBtnHeight.constant = 0
                //                    dupAddBtnTop.constant = 0
                //                }
                //                else {
                //                    dupScrollHeight.constant = 648 + cat + tax + dupattHeight.constant + 220
                //                    dupAddVarBtn.isHidden = false
                //                    dupAddBtnHeight.constant = 50
                //                    dupAddBtnTop.constant = 20
                //                }
            }
            
            else {
                dupisSelectedData[tagView].toggle()
                
                if dupProdOptions.count == 3 {
                    dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 656
                    dupAddVarBtn.isHidden = true
                    dupAddBtnHeight.constant = 0
                    dupAddBtnTop.constant = 0
                }
                else {
                    dupScrollHeight.constant = 648 + cat + tag + tax + dupattHeight.constant + 726
                    dupAddVarBtn.isHidden = false
                    dupAddBtnHeight.constant = 50
                    dupAddBtnTop.constant = 20
                }
            }
        }
        
        else {
            
            if dupisSelectedData[tagView] {
                
                let var_count = dupProdVariants.count
                let cat = dupcatcollHeight.constant
                let tag = duptagCollHeight.constant
                let tax = duptaxCollHeight.constant
                
                dupisSelectedData[tagView].toggle()
                
                if dupProdOptions.count == 3 {
                    dupScrollHeight.constant = 668 + cat + tag + tax + dupattHeight.constant + CGFloat(50 * var_count)
                    dupAddVarBtn.isHidden = true
                    dupAddBtnHeight.constant = 0
                    dupAddBtnTop.constant = 0
                }
                else {
                    dupScrollHeight.constant = 668 + cat + tag + tax + dupattHeight.constant + CGFloat(50 * var_count)
                    dupAddVarBtn.isHidden = false
                    dupAddBtnHeight.constant = 50
                    dupAddBtnTop.constant = 20
                }
            }
            
            else {
                for select in 0..<dupisSelectedData.count {
                    
                    if dupisSelectedData[select] {
                        dupisSelectedData[select].toggle()
                    }
                    else if select == tagView {
                        dupisSelectedData[select].toggle()
                    }
                }
                
                setCollHeight(coll: dupVariantsTable)
            }
            dupVariantsTable.reloadData()
        }
    }
}

extension DuplicatePlusViewController {
    
    
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
        dupSaveBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: dupSaveBtn.centerXAnchor, constant: CGFloat(30)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: dupSaveBtn.centerYAnchor),
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
