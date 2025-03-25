//
//  StockSaveViewController.swift
//  
//
//  Created by Jamaluddin Syed on 12/11/24.
//

import UIKit

protocol StockDelegate: AnyObject {
    
    func stockCheck(variants: [InventoryVariant], addNew: [String], discrepancy: [String], item_id: [String])
}

class StockSaveViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveDraftLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    @IBOutlet weak var stockName: UILabel!
    
    var stockItemsList = [InventoryVariant]()
    var subStockItemsList = [InventoryVariant]()
    var searchStockItemsList = [InventoryVariant]()
    
    var addNewQty = [String]()
    var discrepancyAdd = [String]()
    var stockItemId = [String]()
    
    var stockDraftList = [StockItem]()
    var subStockDraftList = [StockItem]()
    var searchStockDraftList = [StockItem]()
    
    var variantList = [InventoryVariant]()
    var stockVarList = [InventoryVariant]()
    
    var fullAddedStockList = [InventoryVariant]()
    var fullAddedNewQty = [String]()
    var fullAddedDiscrp = [String]()
    var fullAddedStockId = [String]()
    
    
    var activeTextField = UITextField()
    var searching = false
    var mode = ""
    var stockId = ""
    
    weak var delegate: StockAddDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveTap))
        saveDraftLbl.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        saveDraftLbl.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        tableview.showsVerticalScrollIndicator = false
        
        if mode == "add" {
            searchBtn.isHidden = true
            stockName.text = "Create Stocktake"
        }
        else {
            
            setUpApi()
        }
    }
    
    
    func setUpApi() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getStockById(merchant_id: id, id: stockId) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(list: list)
            }
            
            else {
                
            }
        }
    }
    
    func getResponseValues(list: Any) {
        
        let res = list as! [String: Any]
        
        let stock = Stock(id: "\(res["id"] ?? "")", st_id: "\(res["st_id"] ?? "")",
                          total_qty: "\(res["total_qty"] ?? "")", total_discrepancy_cost: "\(res["total_discrepancy_cost"] ?? "")",
                          total_discrepancy: "\(res["total_discrepancy"] ?? "")",
                          status: "\(res["status"] ?? "")", send_email: "\(res["send_email"] ?? "")",
                          merchant_id: "\(res["merchant_id"] ?? "")", employee_id: "\(res["employee_id"] ?? "")",
                          created_at: "\(res["created_at"] ?? "")", updated_at: "\(res["updated_at"] ?? "")",
                          stocktake_item: res["stocktake_item"])
        
        stockName.text = "Stocktake -\(stock.st_id)"
        
        
        getStockItems(item: stock.stocktake_item)
    }
    
    func getStockItems(item: Any) {
        
        let stock = item as! [[String:Any]]
        
        var small = [StockItem]()
        
        for res in stock {
            
            let stockItem = StockItem(id: "\(res["id"] ?? "")", stock_id: "\(res["stock_id"] ?? "")",
                                      upc: "\(res["upc"] ?? "")", category_id: "\(res["category_id"] ?? "")",
                                      product_id: "\(res["product_id"] ?? "")", variant_id: "\(res["variant_id"] ?? "")",
                                      product_name: "\(res["product_name"] ?? "")", variant: "\(res["variant"] ?? "")",
                                      current_qty: "\(res["current_qty"] ?? "")", new_qty: "\(res["new_qty"] ?? "")",
                                      discrepancy: "\(res["discrepancy"] ?? "")", discrepancy_cost: "\(res["discrepancy_cost"] ?? "")",
                                      merchant_id: "\(res["merchant_id"] ?? "")", employee_id: "\(res["employee_id"] ?? "")",
                                      created_at: "\(res["created_at"] ?? "")", updated_at: "\(res["updated_at"] ?? "")")
            small.append(stockItem)
            
            addNewQty.append(stockItem.new_qty)
            print(addNewQty)
            discrepancyAdd.append(stockItem.discrepancy)
            stockItemId.append(stockItem.id)
        }
        
        stockDraftList = small
        subStockDraftList = small
        
        variantListApi()
    }
    
    func variantListApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any){
        
        let response = varient as! [[String: Any]]
        var small = [InventoryVariant]()
        
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")",
                                           title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            small.append(variant)
        }
        
        variantList = small
        
        getStockVariants()
    }
    
    func getStockVariants() {
        
        var smallVarList = [InventoryVariant]()
        
        for variant in variantList {
            
            if variant.isvarient == "1" {
                
                if stockDraftList.contains(where: {$0.variant_id == variant.var_id}) {
                    smallVarList.append(variant)
                }
            }
            else {
                if stockDraftList.contains(where: {$0.product_id == variant.id}) {
                    smallVarList.append(variant)
                }
            }
        }
        
        stockVarList = smallVarList
        
        stockVarList.append(contentsOf: fullAddedStockList)
        addNewQty.append(contentsOf: fullAddedNewQty)
        discrepancyAdd.append(contentsOf: fullAddedDiscrp)
        stockItemId.append(contentsOf: fullAddedStockId)
        
        DispatchQueue.main.async {
            self.loadingIndicator.isAnimating = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    
    @objc func saveTap() {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_stocktake") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
            
            let date = Date()
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormat = format.string(from: date)
            
            var items = [SaveStock]()
            var final_json = ""
            
            var total_dis_cost = [String]()
            var total_dis = [String]()
            
            if mode == "add" {
                
                if stockItemsList.count == 0 {
                    
                    ToastClass.sharedToast.showToast(message: "No Variants Added to StockTake",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                else {
                
                
                
                var total_new_Qty = 0
                
                for new in addNewQty {
                    
                    guard new != "" else {
                        ToastClass.sharedToast.showToast(message: "Add New Quantity for all variants",
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        return
                    }
                    print(new)
                    total_new_Qty += Int(new) ?? 0
                }
                
                for fill in 0..<stockItemsList.count {
                    
                    var upc = ""
                    var var_id = ""
                    var costperItem = ""
                    
                    if stockItemsList[fill].isvarient == "1" {
                        upc = stockItemsList[fill].var_upc
                        var_id = stockItemsList[fill].var_id
                        costperItem = stockItemsList[fill].var_costperItem
                    }
                    
                    else {
                        upc = stockItemsList[fill].upc
                        var_id = ""
                        costperItem = stockItemsList[fill].costperItem
                    }
                    
                    
                    let cpi_doub = Double(costperItem) ?? 0.00
                    let newQty = Int(addNewQty[fill]) ?? 0
                    
                    let discrepancy_per = Int(discrepancyAdd[fill]) ?? 0
                    
                    print(discrepancy_per)
                    let cost = cpi_doub * Double(discrepancy_per)
                    var cost_str = String(cost)
                    let dis_str = String(discrepancy_per)
                    
                    if cost_str.contains("-") {
                        cost_str.removeFirst()
                    }
                    total_dis_cost.append(cost_str)
                    total_dis.append(dis_str)
                    
                    let save = SaveStock(upc: upc, category_id: stockItemsList[fill].cotegory,
                                         product_id: stockItemsList[fill].id, variant_id: var_id,
                                         product_name: stockItemsList[fill].title,
                                         current_qty: stockItemsList[fill].quantity,
                                         new_qty: "\(newQty)", discrepancy: "\(discrepancy_per)",
                                         discrepancy_cost: cost_str, stocktake_item_id: "")
                    
                    items.append(save)
                }
                
                // Encoding the data into JSON
                do {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                    let jsonData = try encoder.encode(items) // Wrap the object in an array for consistency with the provided JSON structure
                    
                    // Convert the encoded JSON into a string for display or further processing
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        final_json = jsonString
                    }
                } catch {
                    print("Error encoding JSON: \(error)")
                }
                
                var final_dis_cost = 0.00
                var final_dis = 0.00
                
                for cost_total in total_dis_cost {
                    
                    final_dis_cost += Double(cost_total) ?? 0.00
                }
                
                for dis_total in total_dis {
                    
                    final_dis += Double(dis_total) ?? 0.00
                }
                
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                
                ApiCalls.sharedCall.saveStockTake(merchant_id: id,
                                                  employee_id: emp_id,
                                                  total_qty: "\(total_new_Qty)",
                                                  total_discrepancy: "\(final_dis)",
                                                  total_discrepancy_cost: "\(final_dis_cost)",
                                                  status: "1",
                                                  datetime: dateFormat,
                                                  stocktake_items: final_json, stocktake_id: "") { isSuccess, response in
                    
                    if isSuccess {
                        
                        guard let msg = response["message"] else {
                            return
                        }
                        
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = false
                        
                        ToastClass.sharedToast.showToast(message: msg as! String,
                                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                        
                        var destiny = 0
                        
                        let viewcontrollerArray = self.navigationController?.viewControllers
                        
                        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                            destiny = destinationIndex
                        }
                        
                        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                    }
                    else {
                    }
                }
            }
        }
            else {
                
                if stockVarList.count == 0 {
                    
                    ToastClass.sharedToast.showToast(message: "No Variants Added to StockTake",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                    
                }
                else {
                    
                    
                    var total_new_Qty = 0
                    
                    for new in addNewQty {
                        
                        guard new != "" else {
                            ToastClass.sharedToast.showToast(message: "Add New Quantity for all variants",
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            return
                        }
                        
                        total_new_Qty += Int(new) ?? 0
                    }
                    
                    for fill in 0..<stockVarList.count {
                        
                        var upc = ""
                        var var_id = ""
                        var prod_name = ""
                        
                        var costperItem = ""
                        
                        if stockVarList[fill].isvarient == "1" {
                            costperItem = stockVarList[fill].var_costperItem
                            upc = stockVarList[fill].var_upc
                            var_id = stockVarList[fill].var_id
                        }
                        else {
                            costperItem = stockVarList[fill].costperItem
                            upc = stockVarList[fill].upc
                            var_id = ""
                        }
                        
                        prod_name = stockVarList[fill].title
                        
                        let cpi_doub = Double(costperItem) ?? 0.00
                        
                        let newQty = Int(addNewQty[fill]) ?? 0
                        let discrepancy_per = Int(discrepancyAdd[fill]) ?? 0
                        let item_id = stockItemId[fill]
                        
                        let cost = cpi_doub * Double(discrepancy_per)
                        var cost_str = String(cost)
                        let dis_str = String(discrepancy_per)
                        
                        if cost_str.contains("-") {
                            cost_str.removeFirst()
                        }
                        total_dis_cost.append(cost_str)
                        total_dis.append(dis_str)
                        
                        
                        let save = SaveStock(upc: upc, category_id: stockVarList[fill].cotegory,
                                             product_id: stockVarList[fill].id, variant_id: var_id,
                                             product_name: prod_name,
                                             current_qty: stockVarList[fill].quantity,
                                             new_qty: "\(newQty)", discrepancy: "\(discrepancy_per)",
                                             discrepancy_cost: cost_str, stocktake_item_id: item_id)
                        
                        items.append(save)
                    }
                    // Encoding the data into JSON
                    do {
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                        let jsonData = try encoder.encode(items)
                        
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            final_json = jsonString
                        }
                    } catch {
                        print("Error encoding JSON: \(error)")
                    }
                    
                    
                    var final_dis_cost = 0.00
                    var final_dis = 0.00
                    
                    for cost_total in total_dis_cost {
                        
                        final_dis_cost += Double(cost_total) ?? 0.00
                    }
                    
                    for dis_total in total_dis {
                        
                        final_dis += Double(dis_total) ?? 0.00
                    }
                   
                    
                    tableview.isHidden = true
                    loadingIndicator.isAnimating = true
                    
                    ApiCalls.sharedCall.saveStockTake(merchant_id: id,
                                                      employee_id: emp_id,
                                                      total_qty: "\(total_new_Qty)",
                                                      total_discrepancy: "\(final_dis)",
                                                      total_discrepancy_cost: "\(final_dis_cost)",
                                                      status: "1",
                                                      datetime: dateFormat,
                                                      stocktake_items: final_json, stocktake_id: stockId) { isSuccess, response in
                        
                        if isSuccess {
                            
                            guard let msg = response["message"] else {
                                return
                            }
                            
                            self.loadingIndicator.isAnimating = false
                            self.tableview.isHidden = false
                            
                            ToastClass.sharedToast.showToast(message: msg as! String,
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            
                            var destiny = 0
                            
                            let viewcontrollerArray = self.navigationController?.viewControllers
                            
                            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                                destiny = destinationIndex
                            }
                            
                            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                            
                        }
                        else {
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            delegate?.stockAddCheck(variants: stockItemsList, addNewQty: addNewQty, disAdd: discrepancyAdd)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        showAlert(title: "Alert", message: "Are you sure you want to delete this item?", tag: sender.tag)
    }
    
    func showAlert(title: String, message: String, tag: Int) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            if self.mode == "add" {
                
                self.stockItemsList.remove(at: tag)
                self.addNewQty.remove(at: tag)
                self.discrepancyAdd.remove(at: tag)
                self.tableview.reloadData()
            }
            else {
                
                let pos = self.stockItemId[tag]
                                
                if pos == "" {
                    
                    self.addNewQty.remove(at: tag)
                    self.discrepancyAdd.remove(at: tag)
                    self.stockItemId.remove(at: tag)
                    self.stockVarList.remove(at: tag)
                    
                    self.tableview.reloadData()
                }
                else {
                    
                    var addedStock = [InventoryVariant]()
                    var addedNewQty = [String]()
                    var addedDiscrp = [String]()
                    var addedStockId = [String]()
                    
                    for i in 0..<self.stockItemId.count {
                        
                        if self.stockItemId[i] == "" {
                            addedStock.append(self.stockVarList[i])
                            addedNewQty.append(self.addNewQty[i])
                            addedDiscrp.append(self.discrepancyAdd[i])
                            addedStockId.append(self.stockItemId[i])
                        }
                    }
                    self.fullAddedStockList = addedStock
                    self.fullAddedNewQty = addedNewQty
                    self.fullAddedDiscrp = addedDiscrp
                    self.fullAddedStockId = addedStockId
                    
                    self.callDeleteApi(item_id: pos)
                }
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    func callDeleteApi(item_id: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let st_id = stockId
        
        ApiCalls.sharedCall.deleteStockTake(merchant_id: id,
                                            stocktake_id: st_id,
                                            stocktake_item_id: item_id) { isSuccess, response in
            
            if isSuccess {
                
                self.addNewQty = []
                self.discrepancyAdd = []
                self.stockItemId = []
                self.stockDraftList = []
                
                self.setUpApi()
                
            }
            else {}
        }
    }
    
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_stocktake") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let emp_id = UserDefaults.standard.string(forKey: "emp_po_id") ?? ""
            
            let date = Date()
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormat = format.string(from: date)
            
            var items = [SaveStock]()
            var final_json = ""
            
            var total_dis_cost = [String]()
            var total_dis = [String]()
            
            if mode == "add" {
                
                if stockItemsList.count == 0 {
                    
                    ToastClass.sharedToast.showToast(message: "No Variants Added to StockTake",
                                                     font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else {
                                        
                    var total_new_Qty = 0
                    
                    for new in addNewQty {
                        
                        guard new != "" else {
                            ToastClass.sharedToast.showToast(message: "Add New Quantity for all variants",
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            return
                        }
                        
                        total_new_Qty += Int(new) ?? 0
                    }
                    
                    for fill in 0..<stockItemsList.count {
                        
                        var upc = ""
                        var var_id = ""
                        var costperItem = ""
                        
                        if stockItemsList[fill].isvarient == "1" {
                            upc = stockItemsList[fill].var_upc
                            var_id = stockItemsList[fill].var_id
                            costperItem = stockItemsList[fill].var_costperItem
                        }
                        
                        else {
                            upc = stockItemsList[fill].upc
                            var_id = ""
                            costperItem = stockItemsList[fill].costperItem
                        }
                        
                        
                        let cpi_doub = Double(costperItem) ?? 0.00
                        let newQty = Int(addNewQty[fill]) ?? 0
                        
                        let discrepancy_per = Int(discrepancyAdd[fill]) ?? 0
                        
                        let cost = cpi_doub * Double(discrepancy_per)
                        var cost_str = String(cost)
                        let dis_str = String(discrepancy_per)
                        
                        if cost_str.contains("-") {
                            cost_str.removeFirst()
                        }
                        total_dis_cost.append(cost_str)
                        total_dis.append(dis_str)
                        
                        let save = SaveStock(upc: upc, category_id: stockItemsList[fill].cotegory,
                                             product_id: stockItemsList[fill].id, variant_id: var_id,
                                             product_name: stockItemsList[fill].title,
                                             current_qty: stockItemsList[fill].quantity,
                                             new_qty: "\(newQty)", discrepancy: "\(discrepancy_per)",
                                             discrepancy_cost: cost_str, stocktake_item_id: "")
                        
                        items.append(save)
                    }
                    
                    // Encoding the data into JSON
                    do {
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                        let jsonData = try encoder.encode(items) // Wrap the object in an array for consistency with the provided JSON structure
                        
                        // Convert the encoded JSON into a string for display or further processing
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            final_json = jsonString
                        }
                    } catch {
                        print("Error encoding JSON: \(error)")
                    }
                    
                    var final_dis_cost = 0.00
                    var final_dis = 0.00
                    
                    for cost_total in total_dis_cost {
                        
                        final_dis_cost += Double(cost_total) ?? 0.00
                    }
                    
                    for dis_total in total_dis {
                        
                        final_dis += Double(dis_total) ?? 0.00
                    }
                    
                    tableview.isHidden = true
                    loadingIndicator.isAnimating = true
                    
                    ApiCalls.sharedCall.saveStockTake(merchant_id: id,
                                                      employee_id: emp_id,
                                                      total_qty: "\(total_new_Qty)",
                                                      total_discrepancy: "\(final_dis)",
                                                      total_discrepancy_cost: "\(final_dis_cost)",
                                                      status: "0",
                                                      datetime: dateFormat,
                                                      stocktake_items: final_json, stocktake_id: "") { isSuccess, response in
                        
                        if isSuccess {
                            
                            guard let msg = response["message"] else {
                                return
                            }
                            
                            self.loadingIndicator.isAnimating = false
                            self.tableview.isHidden = false
                            
                            ToastClass.sharedToast.showToast(message: msg as! String,
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            
                            var destiny = 0
                            
                            let viewcontrollerArray = self.navigationController?.viewControllers
                            
                            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                                destiny = destinationIndex
                            }
                            
                            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                            
                        }
                        else {
                        }
                    }
                }
            }
            
            //edit
            else {
                
                if stockVarList.count == 0 {
                    
                    ToastClass.sharedToast.showToast(message: "No Variants Added to StockTake", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else {
                    
                    var total_new_Qty = 0
                    
                    for new in addNewQty {
                        
                        guard new != "" else {
                            ToastClass.sharedToast.showToast(message: "Add New Quantity for all variants",
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            return
                        }
                        
                        total_new_Qty += Int(new) ?? 0
                    }
                    
                    for fill in 0..<stockVarList.count {
                        
                        var upc = ""
                        var var_id = ""
                        var costperItem = ""
                        
                        if stockVarList[fill].isvarient == "1" {
                            upc = stockVarList[fill].var_upc
                            var_id = stockVarList[fill].var_id
                            costperItem = stockVarList[fill].var_costperItem
                        }
                        
                        else {
                            upc = stockVarList[fill].upc
                            var_id = ""
                            costperItem = stockVarList[fill].costperItem
                        }
                        
                        let cpi_doub = Double(costperItem) ?? 0.00
                        
                        
                        let newQty = Int(addNewQty[fill]) ?? 0
                        let discrepancy_per = Int(discrepancyAdd[fill]) ?? 0
                        let item_id = stockItemId[fill]
                        
                        let cost = cpi_doub * Double(discrepancy_per)
                        var cost_str = String(cost)
                        let dis_str = String(discrepancy_per)
                        
                        if cost_str.contains("-") {
                            cost_str.removeFirst()
                        }
                        total_dis_cost.append(cost_str)
                        total_dis.append(dis_str)
                        
                        
                        let save = SaveStock(upc: upc, category_id: stockVarList[fill].cotegory,
                                             product_id: stockVarList[fill].id, variant_id: var_id,
                                             product_name: stockVarList[fill].title,
                                             current_qty: stockVarList[fill].quantity,
                                             new_qty: "\(newQty)", discrepancy: "\(discrepancy_per)",
                                             discrepancy_cost: cost_str, stocktake_item_id: item_id)
                        
                        items.append(save)
                    }
                    
                    // Encoding the data into JSON
                    do {
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted  // Makes the output readable
                        let jsonData = try encoder.encode(items)
                        
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            final_json = jsonString
                        }
                    } catch {
                        print("Error encoding JSON: \(error)")
                    }
                    
                    
                    var final_dis_cost = 0.00
                    var final_dis = 0.00
                    
                    for cost_total in total_dis_cost {
                        
                        final_dis_cost += Double(cost_total) ?? 0.00
                    }
                    
                    for dis_total in total_dis {
                        
                        final_dis += Double(dis_total) ?? 0.00
                    }
                    
                    tableview.isHidden = true
                    loadingIndicator.isAnimating = true
                    
                    ApiCalls.sharedCall.saveStockTake(merchant_id: id,
                                                      employee_id: emp_id,
                                                      total_qty: "\(total_new_Qty)",
                                                      total_discrepancy: "\(final_dis)",
                                                      total_discrepancy_cost: "\(final_dis_cost)",
                                                      status: "0",
                                                      datetime: dateFormat,
                                                      stocktake_items: final_json, stocktake_id: stockId) { isSuccess, response in
                        
                        if isSuccess {
                            
                            guard let msg = response["message"] else {
                                return
                            }
                            
                            self.loadingIndicator.isAnimating = false
                            self.tableview.isHidden = false
                            
                            ToastClass.sharedToast.showToast(message: msg as! String,
                                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            
                            var destiny = 0
                            
                            let viewcontrollerArray = self.navigationController?.viewControllers
                            
                            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is InventoryViewController }) {
                                destiny = destinationIndex
                            }
                            
                            self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                        }
                        else {
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        if mode == "add" {
            
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "stockadd") as! StockAddViewController
            
            vc.delegate = self
            vc.selectAddStock = stockVarList
            vc.newAddQty = addNewQty
            vc.discrepancyAdd = discrepancyAdd
            vc.stock_Item_Id = stockItemId
            vc.selectMode = "select"
            present(vc, animated: true)
        }
    }
}

extension StockSaveViewController: StockDelegate {
    
    func stockCheck(variants: [InventoryVariant], addNew: [String], discrepancy: [String], item_id: [String]) {
        
        stockVarList = variants
        
        addNewQty = addNew
        discrepancyAdd = discrepancy
        stockItemId = item_id
        
        tableview.reloadData()
    }
}

extension StockSaveViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! StockSaveTableViewCell
        
        activeTextField = cell.newQtyText
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        let cell = tableview.cellForRow(at: index) as! StockSaveTableViewCell
        
        let current = cell.qtyValue.text ?? ""
        let new = cell.newQtyText.text ?? ""
        
        let currentDouble = Int(current) ?? 0
        let newDouble = Int(new) ?? 0
        
        addNewQty[textField.tag] = new
        
        if newDouble != 0 {
            
            if currentDouble < 0 {
                
                let discrepancy = newDouble - currentDouble
                print(discrepancy)
                let total = String(discrepancy)
                
                if total.hasPrefix("-") {
                    cell.disValue.text = total
                }
                else {
                    cell.disValue.text = "+\(total)"
                }
            }
            
            else {
                let discrepancy = newDouble - currentDouble
                let total = String(discrepancy)
                
                if total.hasPrefix("-") {
                    cell.disValue.text = total
                }
                else {
                    cell.disValue.text = "+\(total)"
                }
            }
        }
        
        else {
            let discrepancy = newDouble - currentDouble
            let total = String(discrepancy)
            
            if total.hasPrefix("-") {
                cell.disValue.text = total
            }
            else {
                cell.disValue.text = "+\(total)"
            }
        }
        discrepancyAdd[textField.tag] = cell.disValue.text ?? ""
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

extension StockSaveViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searching = false
            tableview.reloadData()
        }
        else {
            searching = true
            searchStockItemsList = subStockItemsList.filter {
                
                let searchTextLowercased = searchText.lowercased()
                let isName = $0.title.lowercased().contains(searchTextLowercased)
                let isUPC = $0.upc.lowercased().contains(searchTextLowercased)
                let isVUPC = $0.var_upc.lowercased().contains(searchTextLowercased)
                
                return isName || isUPC || isVUPC
            }
            
            if searchStockItemsList.count == 0 {
                
            }
            else {
                tableview.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        tableview.reloadData()
    }
}

extension StockSaveViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mode == "add" {
            return stockItemsList.count
        }
        else {
            return stockVarList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockSaveTableViewCell
        
        if mode == "add" {
            
            let stock = stockItemsList[indexPath.row]
            
            cell.stockName.text = stock.title
            
            if stock.isvarient == "1" {
                cell.upcLbl.text = "UPC: \(stock.var_upc)"
            }
            else {
                cell.upcLbl.text = "UPC: \(stock.upc)"
            }
            
            cell.qtyValue.text = "\(stock.quantity)"
            
        }
        
        else {
            
            let stock = stockVarList[indexPath.row]
            
            cell.stockName.text = stock.title
            
            if stock.isvarient == "1" {
                cell.upcLbl.text = "UPC: \(stock.var_upc)"
            }
            else {
                cell.upcLbl.text = "UPC: \(stock.upc)"
            }
            
            cell.qtyValue.text = "\(stock.quantity)"
        }
        
        cell.newQtyText.text = addNewQty[indexPath.row]
        
        let value = discrepancyAdd[indexPath.row]
        
        if value != "" {
            if value.hasPrefix("-") {
                cell.disValue.text = value
            }
            else {
                if value.hasPrefix("+") {
                    cell.disValue.text = value
                }
                else {
                    cell.disValue.text = "+\(value)"
                }
            }
        }
        else {
            cell.disValue.text = ""
        }
        
        cell.deleteBtn.tag = indexPath.row
        
        cell.newQtyText.borderStyle = .none
        cell.newQtyText.delegate = self
        cell.newQtyText.keyboardType = .numberPad
        
        cell.newQtyView.layer.borderColor = UIColor(hexString: "#D0D0D0").cgColor
        cell.newQtyView.layer.borderWidth = 1
        cell.newQtyView.layer.cornerRadius = 10
        
        cell.newQtyText.delegate = self
        cell.newQtyText.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
    }
}

struct SaveStock: Encodable {
    
    let upc: String
    let category_id: String
    let product_id: String
    let variant_id: String
    let product_name: String
    let current_qty: String
    let new_qty: String
    let discrepancy: String
    let discrepancy_cost: String
    let stocktake_item_id: String
}
