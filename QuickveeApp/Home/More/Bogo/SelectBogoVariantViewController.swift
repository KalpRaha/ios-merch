//
//  SelectBogoVariantViewController.swift
//  QuickveeApp
//
//  Created by Pallavi on 31/01/25.
//

import UIKit
import BarcodeScanner

protocol SelectBogoDelegate: AnyObject {
    
    func addSelectedBogoVariants(arr: [VariantBogoModel])
}


class SelectBogoVariantViewController: UIViewController  {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var imageCheckBtn: UIButton!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var bogotitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var novariantView: UIView!
    @IBOutlet weak var noDataImg: UIImageView!
    @IBOutlet weak var nodataLbl: UILabel!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var itemNameView: UIView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itempriceLbl: UILabel!
    
    @IBOutlet weak var itemNameViewHeight: NSLayoutConstraint!
    
    
    var variantList = [BogoVariantModel]()
    
    var sort_by_price = [BogoVariantModel] ()
    
    var searchvariantBoGoList = [VariantBogoModel]()
    var variantBoGoList = [VariantBogoModel]()
    var subVariantBoGoList = [VariantBogoModel]()
    
    var categoryVariantList = [VariantBogoModel]()
    
    var bogoSelectedVariants = [VariantBogoModel]()
    
    var bogoCategory = [InventoryCategory]()
    
    var bogo_mix_exist_ids = [String]()
    
    var mode = ""
    var disc_amt = ""
    
    
    var selectAllMode = false
    
    var searching = false
    var discount_type = ""
 
    weak var adddelegate: SelectBogoDelegate?
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableview.dataSource = self
        tableview.delegate = self
        
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
        bogotitle.alpha = 1
        scanBtn.alpha = 1
        
        searchBar.showsCancelButton = true
        searchBar.iq.resignOnTouchOutsideMode = .enabled
        
        variantListApi()
        
        filterLbl.text = ""
        filterView.backgroundColor = .clear
        
        nextBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        print(bogoSelectedVariants.count)
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        novariantView.isHidden = true
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                
                self.getResponseValues(variant: list)
                
                
                DispatchQueue.main.async {
                    self.tableview.isHidden = false
                    self.novariantView.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    self.tableview.reloadData()
                }
            }
            else {
                print("Api Error")
            }
            
        }
    }
    
    func getResponseValues(variant: Any) {
        
        let responce = variant as! [[String:Any]]
        
        var small = [BogoVariantModel]()
        var smallWidth = [String]()
        var smallupcwidth = [String]()
        
        for res in responce {
            
            
            let variant =  BogoVariantModel(id: "\(res["id"] ?? "")",
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
            
            small.append(variant)
        }
        
        variantList = small
        setDisabledVariants()
    }
    
    func setDisabledVariants() {
        
        let amount = disc_amt
        
        for variant in variantList {
            
            if variant.isvarient == "1" {
                
                if bogo_mix_exist_ids.contains(where:{ $0 == variant.var_id}) {
                    
                }
                else {
                    
                    let checkless = checkPrice(varamt: variant.var_price, textAmt: String(amount))
                    
                    if checkless {
                        
                    }
                    else {
                        
                        sort_by_price.append(variant)
                    }
                    
                }
            }
            else {
                
                if bogo_mix_exist_ids.contains(where:{ $0 == variant.product_id}) {
                    
                }
                else {
                    
                    let checkless = checkPrice(varamt: variant.price, textAmt: String(amount))
                    
                    if checkless {
                        
                    }
                    else {
                        
                        sort_by_price.append(variant)
                    }
                    
                }
            }
        }
        setCheckVariants()
    }
 
    func setCheckVariants() {
        
        if mode == "add" {
            
            var fillList = [VariantBogoModel]()
            
            for addvar in sort_by_price {
                
                fillList.append(VariantBogoModel(bogo: addvar, isSelect:  false))
            }
            
            variantBoGoList = fillList
            subVariantBoGoList = fillList
            categoryVariantList = fillList
        }
        
        else {
            
            var miniSelect = bogoSelectedVariants
            
            for editvar in sort_by_price {
                
                if editvar.isvarient == "1" {
                    
                    if bogoSelectedVariants.contains(where: {$0.bogo.var_id == editvar.var_id}) {
                    }
                    else {
                        miniSelect.append(VariantBogoModel(bogo: editvar, isSelect: false))
                    }
                }
                else {
                    
                    if bogoSelectedVariants.contains(where: {$0.bogo.product_id == editvar.product_id}) {
                    }
                    else {
                        miniSelect.append(VariantBogoModel(bogo: editvar, isSelect: false))
                    }
                }
            }
            
            variantBoGoList = miniSelect
            subVariantBoGoList = miniSelect
            categoryVariantList = miniSelect
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
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if bogoSelectedVariants.count == 0 {
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
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        present(vc, animated: true)
        
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        backBtn.alpha = 0
        bogotitle.alpha = 0
        searchBtn.alpha = 0
        filterBtn.alpha = 0
        scanBtn.alpha = 0
        searchBar.alpha = 1
        
        searchBar.searchTextField.becomeFirstResponder()
        filterView.backgroundColor = .clear
        filterLbl.text = ""
    }
    
    
    @IBAction func cancleBtnClick(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    @IBAction func selectAllBtnClick(_ sender: UIButton) {
        
        if searching {
            if searchvariantBoGoList.count == 0 {
                
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            else {
                
                if sender.currentImage == UIImage(named: "check inventory")  {
                    
                    sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    
                    selectAllMode = false
                    bogoSelectedVariants = []
                    
                    for varindex in 0..<searchvariantBoGoList.count {
                        
                        if searchvariantBoGoList[varindex].bogo.isvarient == "1" {
                            
                            searchvariantBoGoList[varindex].isSelect = false
                            subVariantBoGoList[varindex].isSelect = false
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: false)
                        }
                        else {
                            
                            searchvariantBoGoList[varindex].isSelect = false
                            subVariantBoGoList[varindex].isSelect = false
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: false)
                        }
                        
                    }
                }
                else {
                    
                    
                    for varindex  in 0..<searchvariantBoGoList.count {
                        
                        if searchvariantBoGoList[varindex].bogo.isvarient == "1" {
                            
                            searchvariantBoGoList[varindex].isSelect = true
                            subVariantBoGoList[varindex].isSelect = true
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: true)
                            bogoSelectedVariants.append(searchvariantBoGoList[varindex])
                        }
                        else {
                            
                            searchvariantBoGoList[varindex].isSelect = true
                            subVariantBoGoList[varindex].isSelect = true
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: true)
                            bogoSelectedVariants.append(searchvariantBoGoList[varindex])
                        }
                        
                    }
                    
                    
                    if bogoSelectedVariants.count == 0 {
                        sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                        selectAllMode = false
                    }
                    else {
                        sender.setImage(UIImage(named: "check inventory"), for: .normal)
                        selectAllMode = true
                    }
                }
                
            }
            tableview.reloadData()
        }
        else {
            
            if variantBoGoList.count == 0 {
                
                sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            else {
                
                if sender.currentImage == UIImage(named: "check inventory")  {
                    
                    sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    
                    selectAllMode = false
                    bogoSelectedVariants = []
                    
                    for varindex in 0..<variantBoGoList.count {
                        
                        if variantBoGoList[varindex].bogo.isvarient == "1" {
                            
                            variantBoGoList[varindex].isSelect = false
                            subVariantBoGoList[varindex].isSelect = false
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: false)
                        }
                        else {
                            
                            variantBoGoList[varindex].isSelect = false
                            subVariantBoGoList[varindex].isSelect = false
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: false)
                        }
                        
                    }
                }
                else {
                    
                    
                    for varindex  in 0..<variantBoGoList.count {
                        
                        if variantBoGoList[varindex].bogo.isvarient == "1" {
                            
                            variantBoGoList[varindex].isSelect = true
                            subVariantBoGoList[varindex].isSelect = true
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: true)
                            bogoSelectedVariants.append(variantBoGoList[varindex])
                        }
                        else {
                            
                            variantBoGoList[varindex].isSelect = true
                            subVariantBoGoList[varindex].isSelect = true
                            selectCategoryVariant(match: variantBoGoList[varindex], offset: true)
                            bogoSelectedVariants.append(variantBoGoList[varindex])
                        }
                        
                    }
                    
                    
                    if bogoSelectedVariants.count == 0 {
                        sender.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                        selectAllMode = false
                    }
                    else {
                        sender.setImage(UIImage(named: "check inventory"), for: .normal)
                        selectAllMode = true
                    }
                }
                
            }
            tableview.reloadData()
        }
        
    }
    
    
    
    
    func getCategorySelect() {
        
        
        var category_variants = [VariantBogoModel]()
        
        for variant in categoryVariantList {
            
            if variant.bogo.cotegory.contains(",") {
                
                let comma_cat = variant.bogo.cotegory.components(separatedBy: ",")
                
                for comma in comma_cat {
                    
                    if bogoCategory.contains(where: { String($0.id) == comma }){
                        category_variants.append(variant)
                    }
                    
                }
            }
            else {
                if bogoCategory.contains(where: {$0.id == variant.bogo.cotegory}) {
                    category_variants.append(variant)
                }
            }
        }
        
        variantBoGoList = category_variants
        subVariantBoGoList = category_variants
    }
    
    func unSelectVarient(match: VariantBogoModel) {
        
        if match.bogo.isvarient == "1" {
            bogoSelectedVariants.removeAll(where: {$0.bogo.var_id == match.bogo.var_id})
        }
        else {
            bogoSelectedVariants.removeAll(where: {$0.bogo.product_id == match.bogo.product_id})
        }
    }
    
    
    func selectSubVariant(match: VariantBogoModel, offset: Bool) {
        
        
        if match.bogo.isvarient == "1" {
            
            let index = subVariantBoGoList.firstIndex(where: {$0.bogo.var_id == match.bogo.var_id}) ?? 0
            subVariantBoGoList[index].isSelect = offset
            
        }
        else {
            let index = subVariantBoGoList.firstIndex(where: {$0.bogo.product_id == match.bogo.product_id}) ?? 0
            subVariantBoGoList[index].isSelect = offset
        }
    }
    
    func selectCategoryVariant(match: VariantBogoModel, offset: Bool) {
        
        if match.bogo.isvarient == "1" {
            
            let index = categoryVariantList.firstIndex(where: {$0.bogo.var_id == match.bogo.var_id}) ?? 0
            categoryVariantList[index].isSelect = offset
            
        }
        else {
            let index = categoryVariantList.firstIndex(where: {$0.bogo.product_id == match.bogo.product_id}) ?? 0
            categoryVariantList[index].isSelect = offset
        }
    }
    
    func performSearch(searchText: String) {
        
        var arr = variantBoGoList
        
        if searchText == "" {
            searching = false
        }
        else {
            searching = true
            
            searchvariantBoGoList = subVariantBoGoList.filter {
                $0.bogo.title.lowercased().contains(searchText.lowercased())
                || $0.bogo.var_upc.lowercased().contains(searchText.lowercased())
                ||  $0.bogo.upc.lowercased().contains(searchText.lowercased())
            }
            arr = searchvariantBoGoList
            
        }
        if arr.count == 0 {
            itemNameViewHeight.constant = 0
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
            
            itemNameViewHeight.constant = 52
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
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        
        vc.delegateBogoSelected = self
        vc.catMode = "BogoVc"
        vc.apiMode = "category"
        vc.selectCategory = bogoCategory
        vc.bogoVarientList = variantList
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
        
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        adddelegate?.addSelectedBogoVariants(arr: bogoSelectedVariants)
        dismiss(animated: true)
        
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



extension SelectBogoVariantViewController : SelectedCategoryProductsDelegate  {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        
        bogoCategory = categoryArray
        
        let catCount = bogoCategory.count
        
        
        if catCount > 0 {
            
            getCategorySelect()
            filterLbl.text = "   \(catCount)   "
            filterView.backgroundColor = .systemBlue
        }
        else {
            
            var subList = bogoSelectedVariants
            
            if bogoSelectedVariants.count > 0 {
                
                for variant in categoryVariantList {
                    
                    if variant.bogo.isvarient == "1" {
                        
                        if bogoSelectedVariants.contains(where: {$0.bogo.var_id == variant.bogo.var_id}) {}
                        else {
                            subList.append(variant)
                        }
                    }
                    else {
                        
                        if bogoSelectedVariants.contains(where: {$0.bogo.product_id == variant.bogo.product_id}) {}
                        else {
                            subList.append(variant)
                        }
                    }
                }
            }
            else {
                subList = categoryVariantList
            }
            variantBoGoList = subList
            subVariantBoGoList = subList
            imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            filterLbl.text = ""
            filterView.backgroundColor = .clear
            
        }
        tableview.reloadData()
    }
    
}

extension SelectBogoVariantViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        backBtn.alpha = 1
        bogotitle.alpha = 1
        searchBtn.alpha = 1
        filterBtn.alpha = 1
        scanBtn.alpha = 1
        searchBar.alpha = 0
        
        view.endEditing(true)
        performSearch(searchText: "")
        
    }
}

extension SelectBogoVariantViewController:  BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
        backBtn.alpha = 0
        bogotitle.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        scanBtn.alpha = 0
        filterBtn.alpha = 0
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        
        controller.dismiss(animated: true)
        
        performSearch(searchText: code)
        
    }
}

extension SelectBogoVariantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchvariantBoGoList.count
        }
        else {
            return variantBoGoList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBogoVariantCell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = searchvariantBoGoList[indexPath.row]
            
            if variant.bogo.isvarient == "1" {
                
                
                cell.varientLbl.isHidden = false
                let title = variant.bogo.title
                let variantName = variant.bogo.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                
                cell.priceLbl.text = variant.bogo.var_price
                cell.upcLabel.text = variant.bogo.var_upc
                cell.varientLbl.text =  variant.bogo.variant
                
                let currentVarId = variant.bogo.var_id
                
                if selectAllMode {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    if variant.isSelect {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if bogoSelectedVariants.contains(where: {$0.bogo.var_id == currentVarId}) {
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            else {
                cell.varientLbl.isHidden = true
                cell.titleLbl.text = variant.bogo.title
                cell.priceLbl.text = variant.bogo.price
                cell.upcLabel.text = variant.bogo.upc
                
                let currentProdId = variant.bogo.product_id
                
                if selectAllMode {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    if variant.isSelect {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if bogoSelectedVariants.contains(where: {$0.bogo.var_id == currentProdId})  {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else {
                        
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            
            cell.contentView.backgroundColor = UIColor.white
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBogoVariantCell", for: indexPath) as! SelectBogoVariantCell
            
            let variant = variantBoGoList[indexPath.row]
            
            if variant.bogo.isvarient == "1" {
                
                cell.varientLbl.isHidden = false
                
                let title = variant.bogo.title
                let variantName = variant.bogo.variant
                
                if let range = title.range(of: variantName) {
                    
                    let separatedTitle = title.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    cell.titleLbl.text = separatedTitle
                }
                
                cell.priceLbl.text = variant.bogo.var_price
                cell.upcLabel.text = variant.bogo.var_upc
                cell.varientLbl.text =  variant.bogo.variant
                
                let currentVarId = variant.bogo.var_id
                
                if selectAllMode {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    if subVariantBoGoList[indexPath.row].isSelect {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if bogoSelectedVariants.contains(where: {$0.bogo.var_id == currentVarId}) {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else {
                        
                        cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                    }
                }
            }
            else {
                
                cell.titleLbl.text = variant.bogo.title
                cell.priceLbl.text = variant.bogo.price
                cell.upcLabel.text = variant.bogo.upc
                cell.varientLbl.isHidden = true
                
                let currentProdId = variant.bogo.product_id
              
                if selectAllMode {
                    
                    cell.checkMarkImage.image = UIImage(named: "check inventory")
                }
                else {
                    
                    if subVariantBoGoList[indexPath.row].isSelect  {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else if bogoSelectedVariants.contains(where: {$0.bogo.product_id == currentProdId}) {
                        
                        cell.checkMarkImage.image = UIImage(named: "check inventory")
                    }
                    else {
                        
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
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = searchvariantBoGoList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                subVariantBoGoList[indexPath.row].isSelect = true
                selectCategoryVariant(match: variant, offset: true)
                bogoSelectedVariants.append(variant)
                
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                
                
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                
                subVariantBoGoList[indexPath.row].isSelect = false
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
                
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
        else {
            
            let cell = tableview.cellForRow(at: indexPath) as! SelectBogoVariantCell
            tableview.deselectRow(at: indexPath, animated: true)
            
            var variant = variantBoGoList[indexPath.row]
            
            if  cell.checkMarkImage.image == UIImage(named: "uncheck inventory") {
                
                cell.checkMarkImage.image = UIImage(named: "check inventory")
                
                variant.isSelect = true
                selectSubVariant(match: variant, offset: true)
                subVariantBoGoList[indexPath.row].isSelect = true
                selectCategoryVariant(match: variant, offset: true)
                bogoSelectedVariants.append(variant)
                
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            else {
                
                cell.checkMarkImage.image = UIImage(named: "uncheck inventory")
                
                variant.isSelect = false
                selectSubVariant(match: variant, offset: false)
                
                subVariantBoGoList[indexPath.row].isSelect = false
                selectCategoryVariant(match: variant, offset: false)
                unSelectVarient(match: variant)
                
                imageCheckBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
        }
    }
}

struct BogoVariantModel {
    
    let id: String
    let title: String
    let isvarient: String
    let upc: String
    let cotegory: String
    let var_id: String
    let var_upc: String
    let quantity: String
    let price: String
    let custom_code:   String
    let variant: String
    let var_price: String
    let product_id: String
    let costperItem: String
    let is_lottery: String
    let var_costperItem: String
}
