//
//  ProductsViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/5/23.
//

import UIKit

protocol SelectedCategoryProductsDelegate: AnyObject {
    
    func getProductsCategory(categoryArray: [InventoryCategory])
}

class ProductsViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var lblSelCat: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var addBtnData: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var addProdLbl: UILabel!
    
    @IBOutlet weak var addLblView: UIView!
    
    
    
    @IBOutlet weak var noDataView: UIView!
    
    var productList = [InventoryProductModel]()
    var searchProdArray = [InventoryProductModel]()
    var subProdArray = [InventoryProductModel]()
    var filterProdArray = [InventoryProductModel]()
    var searchVupc = ""
    var prod_id = ""
    var mode = ""
    var merchant_id = ""
    var upcList = [String]()
    
    var selectArray = [InventoryCategory]()
    
    var searching = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openCat))
        filterLbl.addGestureRecognizer(tap)
        filterLbl.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        
        tableview.showsVerticalScrollIndicator = false
        
        addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
        addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        noDataLbl.isHidden = true
        addBtn.isHidden = true
        addBtnData.isHidden = true
        tableview.isHidden = true
        addProdLbl.isHidden = true
        addLblView.isHidden = true
        subProdArray = []
        searching = false
        
        lblSelCat.layer.cornerRadius = 6.0
        lblSelCat.layer.masksToBounds = true
        
        if UserDefaults.standard.bool(forKey: "lock_manage_products") {
            noDataView.isHidden = false
            filterView.isHidden = true
        }
        else {
            setupUI()
            noDataView.isHidden = true
            filterView.isHidden = false
            loadingIndicator.isAnimating = true
            setupProductApi()
        }
  
        lblSelCat.text = ""
    }
    
    @objc func openCat() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "ProductsVc"
        vc.delegateProducts = self
        vc.selectCategory = selectArray
        vc.productsList = productList
        vc.apiMode = "category"
        
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    
    func setupProductApi() {
       

        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        ApiCalls.sharedCall.productListCall(id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    print("no results")
                    return
                }
                
                self.getResponseValues(products: list)
                
                DispatchQueue.main.async {
                    
                    if self.productList.count == 0 {
                        
                        
                        self.noDataLbl.isHidden = false
                        self.addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
                        self.noDataLbl.text = "No Products Added"
                        self.addBtn.isHidden = true
                        self.addBtnData.isHidden = false
                        
                        self.loadingIndicator.isAnimating = false
                        self.filterView.isHidden = true
                        self.tableview.isHidden = true
                        self.addProdLbl.isHidden = false
                        self.addLblView.isHidden = false
                        self.loadingIndicator.removeFromSuperview()
                    }
                    
                    else {
                        
                        
                        self.addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
                        self.noDataLbl.text = "No Products Added"
                        self.noDataLbl.isHidden = true
                        self.addBtn.isHidden = false
                        self.addBtnData.isHidden = true
                        
                        
                        self.tableview.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.addProdLbl.isHidden = true
                        self.filterView.isHidden = false
                        self.addLblView.isHidden = true
                        self.tableview.reloadData()
                    }
                }
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(products: Any) {
        
        let response = products as! [[String:Any]]
        var smallres = [InventoryProductModel]()
        var subvupc = [String]()
        
        for res in response {
            
            let product = InventoryProductModel(HS_code: "\(res["HS_code"] ?? "")",
                                                admin_id: "\(res["admin_id"] ?? "")",
                                                alternateName: "\(res["alternateName"] ?? "")",
                                                assigned_vendors: "\(res["assigned_vendors"] ?? "")",
                                                barcode: "\(res["barcode"] ?? "")", bp_id: "\(res["bp_id"] ?? "")",
                                                bulk_is_percentage: "\(res["bulk_is_percentage"] ?? "")",
                                                bulk_price: "\(res["bulk_price"] ?? "")",
                                                bulk_price_tittle: "\(res["bulk_price_tittle"] ?? "")",
                                                bulk_pricing_variant_ids: "\(res["bulk_pricing_variant_ids"] ?? "")",
                                                bulk_qty: "\(res["bulk_qty"] ?? "")",
                                                buy_with_product: "\(res["buy_with_product"] ?? "")",
                                                compare_price: "\(res["compare_price"] ?? "")",
                                                costperItem: "\(res["costperItem"] ?? "")", cotegory: "\(res["cotegory"] ?? "")",
                                                country_region: "\(res["country_region"] ?? "")", created_on: "\(res["created_on"] ?? "")",
                                                custom_code: "\(res["custom_code"] ?? "")", description: "\(res["description"] ?? "")",
                                                disable: "\(res["disable"] ?? "")", env: "\(res["env"] ?? "")",
                                                featured_product: "\(res["featured_product"] ?? "")", id: "\(res["id"] ?? "")",
                                                is_tobacco: "\(res["is_tobacco"] ?? "")", ischargeTax: "\(res["ischargeTax"] ?? "")",
                                                ispysical_product: "\(res["ispysical_product"] ?? "")",
                                                isstockcontinue: "\(res["isstockcontinue"] ?? "")",
                                                isvarient: "\(res["isvarient"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")", loyalty_product_id: "\(res["loyalty_product_id"] ?? "")",
                                                margin: "\(res["margin"] ?? "")", media: "\(res["media"] ?? "")",
                                                merchant_id: "\(res["merchant_id"] ?? "")", options1: "\(res["options1"] ?? "")",
                                                options2: "\(res["options2"] ?? "")", options3: "\(res["options3"] ?? "")",
                                                other_taxes: "\(res["other_taxes"] ?? "")", prefferd_vendor: "\(res["prefferd_vendor"] ?? "")",
                                                price: "\(res["price"] ?? "")", product_doc: "\(res["product_doc"] ?? "")",
                                                profit: "\(res["profit"] ?? "")", quantity: "\(res["quantity"] ?? "")",
                                                reorder_cost: "\(res["reorder_cost"] ?? "")", reorder_level: "\(res["reorder_level"] ?? "")",
                                                reorder_qty: "\(res["reorder_qty"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                                show_type: "\(res["show_type"] ?? "")", sku: "\(res["sku"] ?? "")",
                                                starting_quantity: "\(res["starting_quantity"] ?? "")", title: "\(res["title"] ?? "")",
                                                trackqnty: "\(res["trackqnty"] ?? "")", upc: "\(res["upc"] ?? "")",
                                                updated_on: "\(res["updated_on"] ?? "")", user_id: "\(res["user_id"] ?? "")",
                                                vcost_price: "\(res["vcost_price"] ?? "")", vdisable: "\(res["vdisable"] ?? "")",
                                                vis_tobacco: "\(res["vis_tobacco"] ?? "")", visstockcontinue: "\(res["visstockcontinue"] ?? "")",
                                                vprice: "\(res["vprice"] ?? "")", vquantity: "\(res["vquantity"] ?? "")",
                                                vtrackqnty: "\(res["vtrackqnty"] ?? "")", vupc: "\(res["vupc"] ?? "")",
                                                vvariant: "\(res["vvariant"] ?? "")", vvariant_id: "\(res["vvariant_id"] ?? "")")
            
            
            if product.is_lottery == "0" {
                smallres.append(product)
                
                subvupc.append(product.upc)
                
                if product.vupc.contains(",") {
                    let commasub = product.vupc.components(separatedBy: ",")
                    subvupc.append(contentsOf: commasub)
                }
                else {
                    subvupc.append(product.vupc)
                }
            }
        }
        
        var id_prod = [Int]()
        for res in smallres {
            id_prod.append(Int(res.id) ?? 0)
        }
        id_prod.sort(by: {$0 > $1})
        var smallarrange = [InventoryProductModel]()
        for small in id_prod {
            smallarrange.append(smallres.first(where: {$0.id == String(small)})!)
        }
        productList = smallarrange
        subProdArray = productList
        filterProdArray = productList
        
        print(productList)
        upcList = subvupc
        
        UserDefaults.standard.set(upcList, forKey: "upcs_list")
    }
    
    func setupFilterApi() {
        
        var semi_products = [InventoryProductModel]()
        
        for product in productList {
            
            if product.cotegory.contains(",") {
                
                let comma_cat = product.cotegory.components(separatedBy: ",")
                for comma in comma_cat {
                    if selectArray.contains(where: {$0.id == comma}) {
                        semi_products.append(product)
                        break
                    }
                }
            }
            else {
                if selectArray.contains(where: {$0.id == product.cotegory}) {
                    semi_products.append(product)
                }
            }
        }
        
        filterProdArray = semi_products
        subProdArray = semi_products
        
        tableview.isHidden = false
        loadingIndicator.isAnimating = false
        tableview.reloadData()
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            
            if selectArray.count == 0 {
                setupProductApi()
            }
            else {
                setupFilterApi()
            }
        }
        
        else {
            searching = true
            
            if selectArray.count == 0 {
                searchProdArray = subProdArray.filter { product in
                    let searchTextLowercased = searchText.lowercased()
                    let isTitleMatch = product.title.lowercased().contains(searchTextLowercased)
                    let isUPCMatch = product.upc.lowercased().contains(searchTextLowercased)
                    let iscustomMatch = product.custom_code.lowercased().contains(searchTextLowercased)
                    let isVariantTitle = product.vvariant.split(separator: ",").contains { variant in
                        variant.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(searchTextLowercased)
                    }
                    let isVariantUPCMatch = product.vupc.split(separator: ",").contains { variant in
                        variant.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(searchTextLowercased)
                    }
                    return isTitleMatch || isUPCMatch || isVariantTitle || isVariantUPCMatch || iscustomMatch
                }
            }
            
            else {
                filterProdArray = subProdArray.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()
                    || $0.upc.lowercased().prefix(searchText.count) == searchText.lowercased()
                    || $0.vupc.lowercased().prefix(searchText.count) == searchText.lowercased()
                    || $0.custom_code.lowercased().prefix(searchText.count) == searchText.lowercased()}
            }
        }
        tableview.reloadData()
        
        if tableview.visibleCells.isEmpty {
            noDataLbl.isHidden = false
            addBtnData.isHidden = false
            addProdLbl.isHidden = true
            addLblView.isHidden = false
            tableview.isHidden = true
            addBtnData.setImage(UIImage(named: "No Data"), for: .normal)
            noDataLbl.text = "No Products Found"
        }
        else {
            noDataLbl.isHidden = true
            addBtnData.isHidden = true
            addProdLbl.isHidden = true
            addLblView.isHidden = true
            tableview.isHidden = false
        }
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_product") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this product?",
                                                    preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                
                self.setupDeleteApi(tag: sender.tag)
                
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    func setupDeleteApi(tag: Int) {
        
        var product_id = ""
        
        if searching {
            product_id = searchProdArray[tag].id
        }
        else {
            product_id = productList[tag].id
        }
        let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productDeleteCall(product_id: product_id, id: merchant_id) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: "Product deleted successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
            }
            else{
                print("Api Error")
            }
        }
    }
    
    @IBAction func deliveryBtnClick(_ sender: UIButton) {
        
        checkProductStatus(productTag: sender.tag, btn: "Delivery")
    }
    
    
    @IBAction func pickupBtnClick(_ sender: UIButton) {
        
        checkProductStatus(productTag: sender.tag, btn: "Pickup")
        
    }
    
    func checkProductStatus(productTag: Int, btn: String) {
        
        self.loadingIndicator.isAnimating = true
        
        let product_id = productList[productTag].id
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var status = ""
        let mode = productList[productTag].show_type
        
        if btn == "Delivery" {
            
            if mode == "0" {
                status = "1"                              //0 = Both Checked, 1 = pickup checked, 2 = delivery Checked, 3 = both uncheck
            }
            else if mode == "1" {
                status = "0"
            }
            else if mode == "2" {
                status = "3"
            }
            else {
                status = "2"
            }
        }
        
        else {
            
            if mode == "0" {
                status = "2"
            }
            else if mode == "1" {
                status = "3"
            }
            else if mode == "2" {
                status = "0"
            }
            else {
                status = "1"
            }
        }
        
        setupProductStatusApi(product_id: product_id, status: status, id: id)
    }
    
    func setupProductStatusApi(product_id: String, status: String, id: String) {
        loadingIndicator.isAnimating = true
        ApiCalls.sharedCall.productUpdateStatus(product_id: product_id, status: status, merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.setupProductApi()
            }else{
                print("Api Error")
            }
        }
    }
    
    @IBAction func addProductBtn(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_product") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            if sender.currentImage == UIImage(named: "add_blue") {
                
                mode = "add"
                
                merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                performSegue(withIdentifier: "toPlusProduct", sender: nil)
            }
        }
    }
    
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "filtercategory") as! FilterCategoryViewController
        vc.catMode = "ProductsVc"
        vc.delegateProducts = self
        vc.selectCategory = selectArray
        vc.productsList = productList
        vc.apiMode = "category"
        present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! PlusViewController
        vc.p_id = prod_id
        vc.mode = mode
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
}

extension ProductsViewController: SelectedCategoryProductsDelegate {
    
    func getProductsCategory(categoryArray: [InventoryCategory]) {
        
        selectArray = categoryArray
        
        if selectArray.count == 0 {
            setupProductApi()
            lblSelCat.text = ""
        }
        else {
            setupFilterApi()
            lblSelCat.text = "   \(selectArray.count)   "
        }
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            
            if selectArray.count == 0 {
                
                return searchProdArray.count
            }
            
            else {
                return filterProdArray.count
            }
        }
        
        else {
            
            if selectArray.count == 0 {
                
                return productList.count
            }
            
            else {
                return filterProdArray.count
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductsTableViewCell
        
        if searching {
            
            if selectArray.count == 0 {
                cell.productLabel.text = searchProdArray[indexPath.row].title
                
                let stat = searchProdArray[indexPath.row].show_type
                
                if stat == "0" {
                    
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "1" {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "2" {
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                else {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                cell.pickupBtn.tag = indexPath.row
                cell.deliveryBtn.tag = indexPath.row
                cell.productDelete.tag = indexPath.row
                
                cell.borderView.layer.cornerRadius = 10
                cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                cell.borderView.layer.shadowOpacity = 1
                cell.borderView.layer.shadowOffset = CGSize.zero
                cell.borderView.layer.shadowRadius = 3
                
            }
            
            else {
                
                cell.productLabel.text = filterProdArray[indexPath.row].title
                
                let stat = filterProdArray[indexPath.row].show_type
                
                if stat == "0" {
                    
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "1" {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "2" {
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                else {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                cell.pickupBtn.tag = indexPath.row
                cell.deliveryBtn.tag = indexPath.row
                cell.productDelete.tag = indexPath.row
                
                cell.borderView.layer.cornerRadius = 10
                cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                cell.borderView.layer.shadowOpacity = 1
                cell.borderView.layer.shadowOffset = CGSize.zero
                cell.borderView.layer.shadowRadius = 3
                
            }
        }
        //searching = false
        else {
            
            if selectArray.count == 0 {
                cell.productLabel.text = productList[indexPath.row].title
                
                let stat = productList[indexPath .row].show_type
                
                if stat == "0" {
                    
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "1" {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "2" {
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                else {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                cell.pickupBtn.tag = indexPath.row
                cell.deliveryBtn.tag = indexPath.row
                cell.productDelete.tag = indexPath.row
                
                cell.borderView.layer.cornerRadius = 10
                cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                cell.borderView.layer.shadowOpacity = 1
                cell.borderView.layer.shadowOffset = CGSize.zero
                cell.borderView.layer.shadowRadius = 3
                
            }
            
            else {
                
                cell.productLabel.text = filterProdArray[indexPath.row].title
                
                let stat = filterProdArray[indexPath.row].show_type
                
                if stat == "0" {
                    
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "1" {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                else if stat == "2" {
                    cell.deliveryBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                else {
                    cell.deliveryBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                    cell.pickupBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                
                cell.pickupBtn.tag = indexPath.row
                cell.deliveryBtn.tag = indexPath.row
                cell.productDelete.tag = indexPath.row
                
                cell.borderView.layer.cornerRadius = 10
                cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                cell.borderView.layer.shadowOpacity = 1
                cell.borderView.layer.shadowOffset = CGSize.zero
                cell.borderView.layer.shadowRadius = 3
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_product") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            
            if searching {
                
                if selectArray.count == 0 {
                    
                    tableview.deselectRow(at: indexPath, animated: true)
                    
                    prod_id = searchProdArray[indexPath.row].id
                    merchant_id = searchProdArray[indexPath.row].merchant_id
                    mode = "edit"
                }
                
                else {
                    
                    tableview.deselectRow(at: indexPath, animated: true)
                    
                    prod_id = filterProdArray[indexPath.row].id
                    merchant_id = filterProdArray[indexPath.row].merchant_id
                    mode = "edit"
                }
            }
            // searching = false
            else {
                tableview.deselectRow(at: indexPath, animated: true)
                
                if selectArray.count == 0 {
                    
                    prod_id = productList[indexPath.row].id
                    merchant_id = productList[indexPath.row].merchant_id
                    mode = "edit"
                }
                
                else {
                    
                    prod_id = filterProdArray[indexPath.row].id
                    merchant_id = filterProdArray[indexPath.row].merchant_id
                    mode = "edit"
                    
                }
            }
            UserDefaults.standard.set("toprod", forKey: "toInstantPO")
            performSegue(withIdentifier: "toPlusProduct", sender: nil)
        }
    }
}


