//
//  SelectMixnMatchViewController.swift
//
//
//  Created by Pallavi on 13/06/24.
//

import UIKit
import BarcodeScanner

protocol SelectMixnMatchDelegate: AnyObject {
    
    func addSelectedMixVariants(arr: [VariantMixMatchModel])
}

class SelectMixnMatchViewController: UIViewController {
   
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var imageCheckBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var mixnMatchtitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var novariantView: UIView!
    @IBOutlet weak var noDataImg: UIImageView!
    @IBOutlet weak var nodataLbl: UILabel!
   
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var itemNameView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itempriceLbl: UILabel!
   
   
    
    var searchVariantTableList = [VariantMixMatchModel]()
    var searchSubVariantTableList = [VariantMixMatchModel]()
    
    var variantTableList = [VariantMixMatchModel]()
    var subVariantTableList = [VariantMixMatchModel]()
    var categoryVariantList = [VariantMixMatchModel]()
    
    var variantList = [MixVariantModel]()
    
    var mixSelectedVariants = [VariantMixMatchModel]()
    var submixSelectedVariants = [VariantMixMatchModel]()
    
    
    var mixCategory = [InventoryCategory]()
    var currentCategoryId: String?
    
    var closeClick = String()
    var varientId = [String]()
    
    weak var delegate: SelectMixnMatchDelegate?
    
    
    
    var mix_exist_ids = [String]()
    var price_ids = [String]()
    
    var price = ""
    var qty = ""
    var mode = ""
    var isperc = ""
    var catMode = ""
    var e_price =  ""
    var eprice = ""
    var ispercent = ""
    
    
    var disabledCount = 0
    
    var searching = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
   
    var selectAllMode = false
    var searchSelectAllMode = false
    var allDisabled = false
    var isCategory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableview.delegate = self
        tableview.dataSource = self
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        nextBtn.layer.cornerRadius = 10
        tableview.showsVerticalScrollIndicator = false
        
        filterView.layer.cornerRadius = 12.5
        filterView.backgroundColor =  UIColor(named: "SelectCat")
        filterLbl.font = UIFont(name: "Manrope-Medium", size: 12.0)!
        filterLbl.textColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBtn.alpha = 1
        searchBar.alpha = 0
        filterBtn.alpha = 1
        backBtn.alpha = 1
        mixnMatchtitle.alpha = 1
        scanBtn.alpha = 1
        
        searchBar.showsCancelButton = true
        searchBar.iq.resignOnTouchOutsideMode = .enabled
        
        if UserDefaults.standard.integer(forKey: "modal_screen") == 2 {
            
            subVariantTableList = []
            variantListApi()
        }
        
        filterLbl.text = ""
        filterView.backgroundColor = .clear
    }
  
    
    func variantListApi() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        itemNameView.isHidden = true
        imageCheckBtn.isHidden = true
        
        itemNameLbl.isHidden = true
        itempriceLbl.isHidden = true
        
        noDataImg.isHidden = true
        nodataLbl.isHidden = true
        novariantView.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    
                    
                    self.itemNameView.isHidden = true
                    self.imageCheckBtn.isHidden = true
                    self.itemNameLbl.isHidden = true
                    self.itempriceLbl.isHidden = true
                    
                    self.noDataImg.isHidden = false
                    self.nodataLbl.isHidden = false
                    self.novariantView.isHidden = false
                    
                    return
                }
                
                self.getResponseValues(varient: list)
                
                DispatchQueue.main.async {
                    
                    if self.variantTableList.count == 0 {
                        
                        self.tableview.isHidden = true
                        self.loadingIndicator.isAnimating = false
                        
                        
                        self.itemNameView.isHidden = true
                        self.imageCheckBtn.isHidden = true
                        self.itemNameLbl.isHidden = true
                        self.itempriceLbl.isHidden = true
                        
                        self.noDataImg.isHidden = false
                        self.nodataLbl.isHidden = false
                        self.novariantView.isHidden = false
                    }
                    
                    else {
                        
                        self.tableview.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        
                        
                        self.itemNameView.isHidden = false
                        self.imageCheckBtn.isHidden = false
                        self.itemNameLbl.isHidden = false
                        self.itempriceLbl.isHidden = false
                        
                        self.noDataImg.isHidden = true
                        self.nodataLbl.isHidden = true
                        self.novariantView.isHidden = true
                        
                    }
                    
                    self.tableview.reloadData()
                    
                }
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any) {
        
        let response = varient as! [[String: Any]]
        var small = [MixVariantModel]()
        var smallWidth = [String]()
        var smallupcwidth = [String]()
        
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
        
        variantList = small
        
        
        let amt = price.replacingOccurrences(of: "$", with: "")
        setDisabledVariants(Addprice: amt, isperc: isperc)
    }
    
    func setDisabledVariants(Addprice: String, isperc: String) {
        
        var amount = ""
        
        if mode == "add" {
            price_ids.removeAll()
            
            
            if isperc == "1" {
                
            }else {
                amount = String(Addprice)
            }
            
        } else {
            
            
            if isperc == "1" {
                
            }else {
                amount = String(e_price)
            }
        }
        
        for i in 0..<variantList.count {
            
            if variantList[i].isvarient == "1" {
                
                if mix_exist_ids.contains(where:{ $0 == variantList[i].var_id}) {
                    
                }
                else {
                    
                    let checkless = checkPrice(varamt: variantList[i].var_price, textAmt: amount)
                    
                    if checkless {
                        price_ids.append(variantList[i].var_id)
                    }
                    
                }
            }
            else {
                
                if mix_exist_ids.contains(where:{ $0 == variantList[i].product_id}) {}
                else {
                    
                    let checkless = checkPrice(varamt: variantList[i].price, textAmt: String(amount))
                    
                    if checkless {
                        price_ids.append(variantList[i].id)
                    }
                }
            }
        }
        setCheckVariants()
    }
    
    func setCheckVariants() {
        
        
        
        var miniSelect = mixSelectedVariants
        
        for editvar in variantList {
            
            if editvar.isvarient == "1" {
                
                if mixSelectedVariants.contains(where: {$0.mix.var_id == editvar.var_id}) {
                    
                }
                else {
                    miniSelect.append(VariantMixMatchModel(mix: editvar, isSelect: false))
                }
            }
            else {
                
                if mixSelectedVariants.contains(where: {$0.mix.product_id == editvar.product_id}) {
                }
                else {
                    miniSelect.append(VariantMixMatchModel(mix: editvar, isSelect: false))
                }
            }
        }
        
        variantTableList = miniSelect
        subVariantTableList = miniSelect
        categoryVariantList = miniSelect
        
        if subVariantTableList.allSatisfy({$0.isSelect}) {
            
            imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        else {
            imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        
        
        
    }
    
    func unSelectVarient(match: VariantMixMatchModel) {
        
        if match.mix.isvarient == "1" {
            mixSelectedVariants.removeAll(where: {$0.mix.var_id == match.mix.var_id})
        }
        else {
            mixSelectedVariants.removeAll(where: {$0.mix.product_id == match.mix.product_id})
        }
    }
    
    func selectSubVariant(match: VariantMixMatchModel, offset: Bool) {
        
        if match.mix.isvarient == "1" {
            
            let index = subVariantTableList.firstIndex(where: {$0.mix.var_id == match.mix.var_id}) ?? 0
            subVariantTableList[index].isSelect = offset
            
        }
        else {
            let index = subVariantTableList.firstIndex(where: {$0.mix.product_id == match.mix.product_id}) ?? 0
            subVariantTableList[index].isSelect = offset
        }
    }
    
    
    func selectMixVariant(match: VariantMixMatchModel, offset: Bool) {
        
        if match.mix.isvarient == "1" {
            
            mixSelectedVariants.removeAll(where: {$0.mix.var_id == match.mix.var_id})
            
            
        }
        else {
            mixSelectedVariants.removeAll(where: {$0.mix.product_id == match.mix.product_id})
            
        }
    }
    
    
    func selectCategoryVariant(match: VariantMixMatchModel, offset: Bool) {
        
        if match.mix.isvarient == "1" {
            
            let index = categoryVariantList.firstIndex(where: {$0.mix.var_id == match.mix.var_id}) ?? 0
            categoryVariantList[index].isSelect = offset
            
        }
        else {
            
            let index = categoryVariantList.firstIndex(where: {$0.mix.product_id == match.mix.product_id}) ?? 0
            categoryVariantList[index].isSelect = offset
        }
    }
    
    
    func filterBogoSelectedVariant(match: [VariantMixMatchModel]) {
        
        var smallFilter = [VariantMixMatchModel]()
        
        for i in match {
            if i.mix.isvarient == "1" {
                
                if smallFilter.contains(where: {$0.mix.var_id == i.mix.var_id}) {
                }
                else {
                    smallFilter.append(i)
                }
            }
            else {
                if smallFilter.contains(where: {$0.mix.product_id == i.mix.product_id}) {
                }
                else {
                    smallFilter.append(i)
                }
            }
        }
        mixSelectedVariants = smallFilter
    }
    
    func selectSearchSubVariant(match: VariantMixMatchModel, offset: Bool) {
       
        if match.mix.isvarient == "1" {
          let index = searchSubVariantTableList.firstIndex(where: {$0.mix.var_id == match.mix.var_id}) ?? 0
            searchSubVariantTableList[index].isSelect = offset
        }
        else {
          let index = searchSubVariantTableList.firstIndex(where: {$0.mix.product_id == match.mix.product_id}) ?? 0
            searchSubVariantTableList[index].isSelect = offset
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddMixnMatch" {
            
            let vc = segue.destination as! AddMixnMatchViewController
            
            vc.price = price
            vc.qty = qty
            vc.variantArray = mixSelectedVariants
            vc.mode = mode
            vc.is_percent = isperc
            vc.delegate = self
            
        }
    }
    
    
    func performSearch(searchText: String) {
        var arr = [VariantMixMatchModel]()
        
        if searchText == "" {
            searching = false
            setCheckVariants()
            arr = variantTableList
            
        }
        
        else {
            searching = true
            searchVariantTableList = []
            
            searchVariantTableList = subVariantTableList.filter {
                
                $0.mix.title.lowercased().contains(searchText.lowercased())
                || $0.mix.var_upc.lowercased().contains(searchText.lowercased())
                ||  $0.mix.upc.lowercased().contains(searchText.lowercased())
                ||  $0.mix.custom_code.lowercased().contains(searchText.lowercased())
            }
            arr = searchVariantTableList
            searchSubVariantTableList = arr
            
            if searchSubVariantTableList.allSatisfy({$0.isSelect == true}) {
                imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            else {
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
        
      
      
        if arr.count == 0 {
        
            tableview.isHidden = true
            itemNameView.isHidden = true
            imageCheckBtn.isHidden = true
            itemNameLbl.isHidden = true
            itempriceLbl.isHidden = true
            noDataImg.isHidden = false
            nodataLbl.isHidden = false
            novariantView.isHidden = false
            
        }
        else {
            
            itemNameView.isHidden = false
            imageCheckBtn.isHidden = false
            itemNameLbl.isHidden = false
            itempriceLbl.isHidden = false
            tableview.isHidden = false
            noDataImg.isHidden = true
            nodataLbl.isHidden = true
            novariantView.isHidden = true
        }
        
        tableview.reloadData()
    }
    
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        backBtn.alpha = 0
        mixnMatchtitle.alpha = 0
        searchBtn.alpha = 0
        filterBtn.alpha = 0
        scanBtn.alpha = 0
        searchBar.alpha = 1
        searchBar.searchTextField.becomeFirstResponder()
        filterView.backgroundColor = .clear
        filterLbl.text = ""
     
    }
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateMixSelected = self
        vc.catMode = "mixMatchVc"
        vc.selectCategory = mixCategory
        vc.apiMode = "category"
        vc.variantMixList = variantList
        //getAddVariant()
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        if mode == "add" {
            if mixSelectedVariants.count == 0 {
                
                UserDefaults.standard.set(0, forKey: "modal_screen")
                navigationController?.popViewController(animated: true)
                
            }
            else {
                
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want Exit?", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                }
                let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    
                    UserDefaults.standard.set(0, forKey: "modal_screen")
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
        else {
            
            if mixSelectedVariants.count == 0 {
                
                dismiss(animated: true)
            }
            else {
                
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want Exit?", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                }
                let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    
                    self.dismiss(animated: true)
                }
                
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            UserDefaults.standard.set(0, forKey: "modal_screen")
            navigationController?.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            
            if mixSelectedVariants.count == 0 {
                ToastClass.sharedToast.showToast(message: "Please Select At least 1 Product Varient",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }else {
                performSegue(withIdentifier: "toAddMixnMatch", sender: nil)
            }
            
        }
        else {
            mixCategory = []
            delegate?.addSelectedMixVariants(arr: mixSelectedVariants)
            dismiss(animated: true)
        }
    }
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        present(vc, animated: true)
    }
    
    @IBAction func SelectAllClick(_ sender: UIButton) {
        
        if searching {
            
            if searchVariantTableList.count == 0 {
                
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            else {
                
                if sender.currentImage == UIImage(named: "check inventory")  {
                    
                   
                    sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    
                    selectAllMode = false
                    searchSelectAllMode = false
                    
                    for varindex in 0..<searchVariantTableList.count {
                        
                        if searchVariantTableList[varindex].mix.isvarient == "1" {
                            
                            if mix_exist_ids.contains(searchVariantTableList[varindex].mix.var_id) ||
                                price_ids.contains(searchVariantTableList[varindex].mix.var_id) {
                               
                            }
                            else {
                                searchVariantTableList[varindex].isSelect = false
                                searchSubVariantTableList[varindex].isSelect = false
                                selectSubVariant(match: searchVariantTableList[varindex], offset: false)
                                selectCategoryVariant(match: searchVariantTableList[varindex], offset: false)
                                selectMixVariant(match: searchVariantTableList[varindex], offset: false)
                            }
                        }
                        else {
                            if mix_exist_ids.contains(searchVariantTableList[varindex].mix.product_id) ||
                                price_ids.contains(searchVariantTableList[varindex].mix.product_id) {
                               
                            }
                            else {
                                searchVariantTableList[varindex].isSelect = false
                                searchSubVariantTableList[varindex].isSelect = false
                                selectSubVariant(match: searchVariantTableList[varindex], offset: false)
                                selectCategoryVariant(match: searchVariantTableList[varindex], offset: false)
                                selectMixVariant(match: searchVariantTableList[varindex], offset: false)
                            }
                        }
                    }
                }
                else {
                    // mixSelectedVariants = []
                    
                    for varindex in 0..<searchVariantTableList.count {
                        
                        if searchVariantTableList[varindex].mix.isvarient == "1" {
                            
                            if mix_exist_ids.contains(searchVariantTableList[varindex].mix.var_id) ||
                                price_ids.contains(searchVariantTableList[varindex].mix.var_id){
                                allDisabled = true
                            }
                            else {
                                searchVariantTableList[varindex].isSelect = true
                                searchSubVariantTableList[varindex].isSelect = true
                                selectSubVariant(match: searchVariantTableList[varindex], offset: true)
                                selectCategoryVariant(match: searchVariantTableList[varindex], offset: true)
                                allDisabled = false
                                mixSelectedVariants.append(searchVariantTableList[varindex])
                            }
                        }
                        else {
                            
                            if mix_exist_ids.contains(searchVariantTableList[varindex].mix.product_id) ||
                                price_ids.contains(searchVariantTableList[varindex].mix.product_id){
                                allDisabled = true
                                
                            }
                            else {
                                searchVariantTableList[varindex].isSelect = true
                                searchSubVariantTableList[varindex].isSelect = true
                                selectSubVariant(match: searchVariantTableList[varindex], offset: true)
                                selectCategoryVariant(match: searchVariantTableList[varindex], offset: true)
                               allDisabled = false
                                mixSelectedVariants.append(searchVariantTableList[varindex])
                                }
                        }
                    }
    
                    if mixSelectedVariants.count == 0 {
                        sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                        selectAllMode = false
                        searchSelectAllMode = false
                    }
                    
                    else {
                        sender.setImage(UIImage(named: "check inventory"), for: .normal)
                      //  selectAllMode = true
                        searchSelectAllMode = true
                         
                        if allDisabled {
                            sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)

                        }
                        else {
                            sender.setImage(UIImage(named: "check inventory"), for: .normal)
                        }
                        }
                }
            }
            tableview.reloadData()
        }
        //searching false
        else {
            
            if variantTableList.count == 0 {
                
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            
            else {
                
                if sender.currentImage == UIImage(named: "check inventory")  {
                    
                    sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    
                    selectAllMode = false
                    
                    if !isCategory {
                        mixSelectedVariants = []
                    }
                    
                    for varindex in 0..<variantTableList.count {
                        
                        
                        
                        if variantTableList[varindex].mix.isvarient == "1" {
                            
                            if mix_exist_ids.contains(variantTableList[varindex].mix.var_id) ||
                                price_ids.contains(variantTableList[varindex].mix.var_id) {
                                
                            }
                            else {
                                variantTableList[varindex].isSelect = false
                                subVariantTableList[varindex].isSelect = false
                                selectCategoryVariant(match: variantTableList[varindex], offset: false)
                                if isCategory {
                                    selectMixVariant(match: variantTableList[varindex], offset: false)
                                }
                            }
                        }
                        else {
                            
                            if mix_exist_ids.contains(variantTableList[varindex].mix.product_id) ||
                                price_ids.contains(variantTableList[varindex].mix.product_id) {
                                
                            }
                            else {
                                variantTableList[varindex].isSelect = false
                                subVariantTableList[varindex].isSelect = false
                                selectCategoryVariant(match: variantTableList[varindex], offset: false)
                                if isCategory {
                                    selectMixVariant(match: variantTableList[varindex], offset: false)
                                }
                            }
                        }

                    }
                }
                else {
                    
                    if !isCategory {
                        mixSelectedVariants = []
                    }
  
                    for varindex in 0..<variantTableList.count {
                        
                        if variantTableList[varindex].mix.isvarient == "1" {
                            
                            if mix_exist_ids.contains(variantTableList[varindex].mix.var_id) ||
                                price_ids.contains(variantTableList[varindex].mix.var_id){}
                            else {
                                variantTableList[varindex].isSelect = true
                                subVariantTableList[varindex].isSelect = true
                                selectCategoryVariant(match: variantTableList[varindex], offset: true)
                                
                                mixSelectedVariants.append(variantTableList[varindex])
                            }
                        }
                        else {
                            if mix_exist_ids.contains(variantTableList[varindex].mix.product_id) ||
                                price_ids.contains(variantTableList[varindex].mix.product_id){}
                            else {
                                
                                variantTableList[varindex].isSelect = true
                                subVariantTableList[varindex].isSelect = true
                                selectCategoryVariant(match: variantTableList[varindex], offset: true)
                                
                                mixSelectedVariants.append(variantTableList[varindex])
                            }
                        }
                    }
                    if isCategory {
                        filterBogoSelectedVariant(match: mixSelectedVariants)
                    }
                    if mixSelectedVariants.count == 0 {
                        sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                        selectAllMode = false
                    }
                    else {
                        sender.setImage(UIImage(named: "check inventory"), for: .normal)
                        
                        if isCategory {
                            selectAllMode = false
                        }
                        else {
                            selectAllMode = true
                        }
                    }
                }
            }
            tableview.reloadData()
        }
    }
}

extension SelectMixnMatchViewController: AddMixnMatchDelegate {
    
    func setSelectedMixVariants(mix: [VariantMixMatchModel], price: String,  is_percent: String) {

        self.price = price
        self.isperc = is_percent
        
        
        setDisabledVariants(Addprice: self.price, isperc: isperc)
        mixSelectedVariants = mix
        var subList = mixSelectedVariants
        //        let valid_count = categoryVariantList.count - (mix_exist_ids.count + price_ids.count)
        //
        //        if subList.count < valid_count {
        //            selectAllMode = false
        //            imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        //        }
        //        else {
        //            selectAllMode = true
        //            imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        //        }
        
        if mixSelectedVariants.count > 0 {
            
            for variant in 0..<categoryVariantList.count {
                
                if categoryVariantList[variant].mix.isvarient == "1" {
                    
                    
                    if mixSelectedVariants.contains(where: {$0.mix.var_id == categoryVariantList[variant].mix.var_id}) {
                        
                    }
                    else {
                        subList.append(categoryVariantList[variant])
                        categoryVariantList[variant].isSelect = false
                        let ele = subList.firstIndex(where: {$0.mix.var_id == categoryVariantList[variant].mix.var_id})
                        subList[ele!].isSelect = false
                    }
                }
                else {
                    
                    if mixSelectedVariants.contains(where: {$0.mix.product_id == categoryVariantList[variant].mix.product_id}) {
                        
                    }
                    else {
                        subList.append(categoryVariantList[variant])
                        categoryVariantList[variant].isSelect = false
                        let ele = subList.firstIndex(where: {$0.mix.product_id == categoryVariantList[variant].mix.product_id})
                        subList[ele!].isSelect = false
                    }
                }
            }
        }
        else {
            
            subList = categoryVariantList
            for i in 0..<categoryVariantList.count {
                categoryVariantList[i].isSelect = false
                
                subList[i].isSelect = false
            }
        }
        
        variantTableList = subList
        subVariantTableList = subList
        
        searching = false
        tableview.reloadData()
        
        imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
    }
}


extension SelectMixnMatchViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        mixCategory = categoryArray
        
        let cat_count = mixCategory.count
        
        
        if cat_count > 0 {
            isCategory = true
            
            getCategorySelect()
            filterLbl.text = "   \(cat_count)   "
            filterView.backgroundColor = .systemBlue
            
            if subVariantTableList.allSatisfy({$0.isSelect}) {
                imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            else {
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
        
        else {
            
            isCategory = false
            
            var subList = mixSelectedVariants
            
            if mixSelectedVariants.count > 0 {
                
                for variant in categoryVariantList {
                    
                    if variant.mix.isvarient == "1" {
                        
                        if mixSelectedVariants.contains(where: {$0.mix.var_id == variant.mix.var_id}) {}
                        else {
                            subList.append(variant)
                        }
                    }
                    else {
                        
                        if mixSelectedVariants.contains(where: {$0.mix.product_id == variant.mix.product_id}) {}
                        else {
                            subList.append(variant)
                        }
                    }
                }
            }
            
            else {
                subList = categoryVariantList
            }
            
            variantTableList = subList
            subVariantTableList = subList
            
            imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            
            filterLbl.text = ""
            filterView.backgroundColor = .clear
        }
        
        tableview.reloadData()
    }
    
    func getCategorySelect() {
        
        var category_variants = [VariantMixMatchModel]()
        
        for variant in categoryVariantList {
            
          
            if variant.mix.cotegory.contains(",") {
                
                let comma_cat = variant.mix.cotegory.components(separatedBy: ",")
                
                for comma in comma_cat {
                    
                    if mixCategory.contains(where: {$0.id == comma}) {
                        category_variants.append(variant)
                    }
                }
            }
            else {
                
                if mixCategory.contains(where: {$0.id == variant.mix.cotegory}) {
                    category_variants.append(variant)
                }
            }
        }
        variantTableList = category_variants
        subVariantTableList = category_variants
   
     
        if variantTableList.allSatisfy({$0.isSelect}) {
            imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
        }
        else {
            imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
    }
}


extension SelectMixnMatchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        performSearch(searchText: searchText)
//        searchSelectAllMode = false
//        selectAllMode = false
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        backBtn.alpha = 1
        mixnMatchtitle.alpha = 1
        searchBtn.alpha = 1
        filterBtn.alpha = 1
        scanBtn.alpha = 1
        searchBar.alpha = 0
        
        searchSelectAllMode = false
        selectAllMode = false
        
        view.endEditing(true)
        performSearch(searchText: "")
    }
}


extension SelectMixnMatchViewController : BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
        backBtn.alpha = 0
        mixnMatchtitle.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        scanBtn.alpha = 0
        filterBtn.alpha = 0
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        controller.dismiss(animated: true)
        performSearch(searchText: code)
    }
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: tableview.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: tableview.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

extension SelectMixnMatchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVariantTableList.count
        }
        else {
            return variantTableList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            // search varient
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMixnMatchCell", for: indexPath) as! SelectMixnMatchCell
            
            let variant = searchVariantTableList[indexPath.row]
            
            
            
            if variant.mix.isvarient == "1" {
                
                cell.varientLbl.isHidden = false
                let title = variant.mix.title
                let variantName = variant.mix.variant
                
                if let range = title.range(of: variantName) {
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                cell.priceLbl.text = "$\(variant.mix.var_price)"
                cell.upcLabel.text = variant.mix.var_upc
                cell.varientLbl.text = variant.mix.variant
                
                let currentVarId = variant.mix.var_id
                
                if searchSelectAllMode {
                    
                    if mix_exist_ids.contains(currentVarId) || price_ids.contains(currentVarId)  {
                        
                        cell.titleLbl.textColor = UIColor.init(hexString: "676767")
                        cell.priceLbl.textColor = UIColor.init(hexString: "676767")
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                }
                else {
                    
                    if mix_exist_ids.contains(currentVarId) || price_ids.contains(currentVarId)  {
                        
                        cell.titleLbl.textColor = UIColor.init(hexString: "676767")
                        cell.priceLbl.textColor = UIColor.init(hexString: "676767")
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    
                    else if variant.isSelect {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if mixSelectedVariants.contains(where: {$0.mix.var_id == currentVarId}) {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            else {
                
                cell.titleLbl.text = variant.mix.title
                cell.priceLbl.text = "$\(variant.mix.price)"
                cell.upcLabel.text = variant.mix.upc
                
                let currentProdId = variant.mix.product_id
                
                if searchSelectAllMode {
                    
                    if mix_exist_ids.contains(currentProdId) || price_ids.contains(currentProdId)  {
                        
                        cell.titleLbl.textColor = UIColor.gray
                        cell.priceLbl.textColor = UIColor.gray
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    else {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                }
                
                else {
                    
                    if mix_exist_ids.contains(currentProdId) || price_ids.contains(currentProdId)  {
                        
                        cell.titleLbl.textColor = UIColor.gray
                        cell.priceLbl.textColor = UIColor.gray
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    else if variant.isSelect {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                        
                    }
                    else if mixSelectedVariants.contains(where: {$0.mix.var_id == currentProdId}) {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                        
                    }
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
        // searching = false
        
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMixnMatchCell", for: indexPath) as! SelectMixnMatchCell
            
            let variant = variantTableList[indexPath.row]
            
            cell.varientLbl.text = variant.mix.variant
            
            if variant.mix.isvarient == "1" {
                
                let title = variant.mix.title
                let variantName = variant.mix.variant
                
                if let range = title.range(of: variantName) {
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                
                cell.priceLbl.text = "$\(variant.mix.var_price)"
                cell.upcLabel.text = variant.mix.var_upc
                
                
                let currentVarId = variant.mix.var_id
                
                if selectAllMode {
                    
                    if mix_exist_ids.contains(currentVarId) || price_ids.contains(currentVarId) {
                        
                        cell.titleLbl.textColor = UIColor.init(hexString: "676767")
                        cell.priceLbl.textColor = UIColor.init(hexString: "676767")
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                }
                else {
                    
                    if mix_exist_ids.contains(currentVarId) || price_ids.contains(currentVarId) {
                        
                        cell.titleLbl.textColor = UIColor.init(hexString: "676767")
                        cell.priceLbl.textColor = UIColor.init(hexString: "676767")
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    
                    else if subVariantTableList[indexPath.row].isSelect  {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if mixSelectedVariants.contains(where: {$0.mix.var_id == currentVarId}) {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            else {
                
                cell.titleLbl.text = variant.mix.title
                cell.priceLbl.text = "$\(variant.mix.price)"
                cell.upcLabel.text = variant.mix.upc
                
                let currentProdId = variant.mix.product_id
                
                if selectAllMode {
                    
                    if mix_exist_ids.contains(currentProdId) || price_ids.contains(currentProdId)  {
                        
                        cell.titleLbl.textColor = UIColor.gray
                        cell.priceLbl.textColor = UIColor.gray
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                }
                else {
                    
                    if mix_exist_ids.contains(currentProdId) || price_ids.contains(currentProdId)  {
                        
                        cell.titleLbl.textColor = UIColor.gray
                        cell.priceLbl.textColor = UIColor.gray
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                        
                    }
                    //                    else if variant.isSelect {
                    //
                    //                        cell.titleLbl.textColor = UIColor.black
                    //                        cell.priceLbl.textColor = UIColor.black
                    //                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    //                    }
                    
                    else if subVariantTableList[indexPath.row].isSelect  {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                        
                    }
                    else if mixSelectedVariants.contains(where: {$0.mix.product_id == currentProdId}) {
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                        
                    }
                    else {
                        
                        cell.titleLbl.textColor = UIColor.black
                        cell.priceLbl.textColor = UIColor.black
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            
            
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectMixnMatchCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = searchVariantTableList[indexPath.row]
            
            if cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                var checkless = false
                
                if mode == "add" {
                    
                    if isperc == "0" {
                        
                        if variant.mix.isvarient == "1" {
                            checkless = price_ids.contains(variant.mix.var_id)
                            
                        }
                        else {
                            checkless = price_ids.contains(variant.mix.product_id)
                            
                        }
                    }
                }
                else {
                    
                    if isperc == "0" {
                        
                        if variant.mix.isvarient == "1" {
                            checkless = price_ids.contains(variant.mix.var_id)
                            
                        }
                        else {
                            checkless = price_ids.contains(variant.mix.product_id)
                            
                        }
                    }
                }
                
                var exist = false
                
                if variant.mix.isvarient == "1" {
                    exist = mix_exist_ids.contains(variant.mix.var_id)
                    
                }
                else {
                    exist = mix_exist_ids.contains(variant.mix.product_id)
                }
                
                if checkless && exist {
                    ToastClass.sharedToast.showToast(message: "Varient is already added in another deal", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else if checkless {
                    
                    ToastClass.sharedToast.showToast(message: "Input Discount(\(price)) is greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else if exist {
                    ToastClass.sharedToast.showToast(message: "Varient is already added in another deal", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                    
                    variant.isSelect = true
                    selectSubVariant(match: variant, offset: true)
                    selectSearchSubVariant(match: variant, offset: true)
                    selectCategoryVariant(match: variant, offset: true)
                    
                    mixSelectedVariants.append(variant)
                    
                    if searchSubVariantTableList.allSatisfy({$0.isSelect}) {
                        imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                       imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                       
                        
                    }
                }
            }
            
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                selectSearchSubVariant(match: variant, offset: false)
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
        // searching false
        
        else {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectMixnMatchCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = variantTableList[indexPath.row]
            
            if cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                var checkless = false
                
                if mode == "add" {
                    
                    if isperc == "0" {
                        
                        if variant.mix.isvarient == "1" {
                            checkless = price_ids.contains(variant.mix.var_id)
                            
                        }
                        else {
                            checkless = price_ids.contains(variant.mix.product_id)
                            
                        }
                    }
                }
                else {
                    
                    if isperc == "0" {
                        
                        if variant.mix.isvarient == "1" {
                            checkless = price_ids.contains(variant.mix.var_id)
                            
                        }
                        else {
                            checkless = price_ids.contains(variant.mix.product_id)
                            
                        }
                    }
                }
                var exist = false
                
                if variant.mix.isvarient == "1" {
                    exist = mix_exist_ids.contains(variant.mix.var_id)
                }
                else {
                    exist = mix_exist_ids.contains(variant.mix.product_id)
                }
                
                if checkless && exist {
                    
                    ToastClass.sharedToast.showToast(message: "Varient is already added in another deal", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else if checkless {
                    
                    if mode == "add" {
                        
                        ToastClass.sharedToast.showToast(message: "Input Discount(\(price)) is greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                    else {
                        ToastClass.sharedToast.showToast(message: "Input Discount(\(eprice)) is greater than price", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    }
                }
                
                else if exist {
                    
                    ToastClass.sharedToast.showToast(message: "Varient is already added in another deal", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                    variant.isSelect = true
                    selectSubVariant(match: variant, offset: true)
                   
                    selectCategoryVariant(match: variant, offset: true)
                    
                    mixSelectedVariants.append(variant)
                    
                    if subVariantTableList.allSatisfy({$0.isSelect}) {
                        imageCheckBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    }
                    else {
                        imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    }
                }
            }
            else {
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
               
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
                
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
    }
}
