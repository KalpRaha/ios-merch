//
//  StockItemsViewController.swift
//  
//
//  Created by Jamaluddin Syed on 08/11/24.
//

import UIKit
import MessageUI

class StockItemsViewController: UIViewController {
    
    @IBOutlet weak var totalDiscrepancy: UILabel!
    @IBOutlet weak var totalDisCost: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalDCView: UIView!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockType: UILabel!
    
    @IBOutlet weak var voidBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    @IBOutlet weak var stackItems: UIStackView!
    @IBOutlet weak var stackItemHeight: NSLayoutConstraint!
    
    
    var stock_id = ""
    var stock_status = ""
    var stockItemList = [StockItem]()
    
    var addNewQty = [String]()
    var discrepancyAdd = [String]()
    var noteAdd = [String]()
    
    var variantList = [InventoryVariant]()
    var stockVarList = [InventoryVariant]()
    
    var stockEmailJson = [StockItemEmail]()
    
    var itemHeaderEmail = ["ITEM NAME", "CURRENT QTY", "NEW QTY", "DISCREPANCY", "UPC", "DISCREPANCY COST"]
    
    var costEmail = ""
    var discrepancyEmail = ""
    
    var stockTakeNumber = ""
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stackItems.isHidden = true
        stackItemHeight.constant = 0
        tableview.showsVerticalScrollIndicator = false
        
        setupUI()
        setUpApi()
        
        totalView.layer.cornerRadius = 10
        totalDCView.layer.cornerRadius = 10
        
        voidBtn.layer.cornerRadius = 10
        voidBtn.layer.borderColor = UIColor(hexString: "#F55353").cgColor
        voidBtn.layer.borderWidth = 1
        
        emailBtn.layer.cornerRadius = 10
        emailBtn.layer.borderColor = UIColor.black.cgColor
        emailBtn.layer.borderWidth = 1
        
    }
    
    
    func setUpApi() {
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getStockById(merchant_id: id, id: stock_id) { isSuccess, responseData in
            
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
        
        let status = stock.status
        
        if status == "0" {
            stockType.text = "Completed"
            stockType.textColor = UIColor(hexString: "#2EC278")
            stackItems.isHidden = false
            stackItemHeight.constant = 45
        }
        else {
            stockType.text = "Void"
            stockType.textColor = UIColor(hexString: "#F55353")
            stackItems.isHidden = true
            stackItemHeight.constant = 0
        }
        
        var smalldisemail = stock.total_discrepancy
        
        if smalldisemail.hasPrefix("-") {
            
        }
        else {
            if smalldisemail.hasPrefix("+") {
                    
            }
            else {
                smalldisemail = "+\(smalldisemail)"
            }
            
        }
        var smallcostemail = stock.total_discrepancy_cost
        
        if smallcostemail.hasPrefix("-") {
            smallcostemail = "$\(smallcostemail)"
        }
        else {
            if smallcostemail.hasPrefix("+") {
                smallcostemail = "$\(smallcostemail)"
            }
            else {
                smallcostemail = "+$\(smallcostemail)"
            }
        }
        
        
        discrepancyEmail = smalldisemail
        costEmail = smallcostemail
        
        totalDiscrepancy.text = discrepancyEmail
        totalDisCost.text = costEmail
        
        getStockItems(item: stock.stocktake_item)
    }
    
    
    
    func getStockItems(item: Any) {
        
        let stock = item as! [[String:Any]]
        
        var small = [StockItem]()
        var smallEmail = [StockItemEmail]()
        
        for res in stock {
            
            let stockItem = StockItem(id: "\(res["id"] ?? "")", stock_id: "\(res["stock_id"] ?? "")",
                                      upc: "\(res["upc"] ?? "")", category_id: "\(res["category_id"] ?? "")",
                                      product_id: "\(res["product_id"] ?? "")", variant_id: "\(res["variant_id"] ?? "")",
                                      product_name: "\(res["product_name"] ?? "")", variant: "\(res["variant"] ?? "")",
                                      current_qty: "\(res["current_qty"] ?? "")", new_qty: "\(res["new_qty"] ?? "")",
                                      discrepancy: "\(res["discrepancy"] ?? "")", discrepancy_cost: "\(res["discrepancy_cost"] ?? "")",
                                      merchant_id: "\(res["merchant_id"] ?? "")", employee_id: "\(res["employee_id"] ?? "")",
                                      created_at: "\(res["created_at"] ?? "")", updated_at: "\(res["updated_at"] ?? "")",
                                      note: "\(res["note"] ?? "")")
            small.append(stockItem)
            
            let stockEmail = StockItemEmail(product_name: "\(res["product_name"] ?? "")",
                                            current_qty: "\(res["current_qty"] ?? "")",
                                            new_qty: "\(res["new_qty"] ?? "")",
                                            discrepancy: "\(res["discrepancy"] ?? "")",
                                            discrepancy_cost: "\(res["discrepancy_cost"] ?? "")",
                                            upc: "\(res["upc"] ?? "")")
            
            smallEmail.append(stockEmail)
            
        }
        stockItemList = small
        stockEmailJson = smallEmail
        
        for qty in stockItemList {
            addNewQty.append(qty.new_qty)
            discrepancyAdd.append(qty.discrepancy)
            noteAdd.append(qty.note)
        }
        
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
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
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
                
                if stockItemList.contains(where: {$0.variant_id == variant.var_id}) {
                    smallVarList.append(variant)
                }
            }
            else {
                if stockItemList.contains(where: {$0.product_id == variant.id}) {
                    smallVarList.append(variant)
                }
            }
        }
        
        stockVarList = smallVarList
        
        
        
        DispatchQueue.main.async {
            self.loadingIndicator.isAnimating = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    
    
    @IBAction func emailBtnClick(_ sender: UIButton) {
        
        //        emailSubject = "Stocktake Details: $stockTakeNumber",
        //        emailBody = htmlTable,
        //        emailTo = bindingEmailReceiptDialog?.tietEnterEmail?.text.toString(),
        //        emailName = stockTakeNumber
        
        let dis_doub = discrepancyEmail
        
        let body = generateHTMLTable(from: stockEmailJson, discrepancy: dis_doub, discrepancyCost: costEmail)
        
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "stockemail") as! StockEmailViewController
        
        vc.email_body = body
        vc.email_subject = "Stocktake Details: \(stockTakeNumber)"
        vc.email_name = stockTakeNumber
        
        
        present(vc, animated: true)
        
    }
    
    
    
    @IBAction func voidBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_void_stocktake") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            ApiCalls.sharedCall.stockVoid(merchant_id: id,
                                          stocktake_id: stock_id) { isSuccess, response in
                
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

    @IBAction func backButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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

extension StockItemsViewController: MFMailComposeViewControllerDelegate {
    
    
    func formatValue(_ value: String, isCurrency: Bool) -> String {
        // Implement your formatValue logic here (e.g., for currency formatting)
        if isCurrency {
            if let doubleValue = Double(value) {
                return String(format: "$%.2f", doubleValue)
            }
        } else {
            return value
        }
        return value
    }
    
    func emailContent(tableHtml: String) -> String {
        
        let storeName = UserDefaults.standard.string(forKey: "store_name") ?? ""
        let storeAddress = "230 Sterling dr, Tracy, CA 95391"
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let currentDate = dateFormatter.string(from: date)
        
        stockTakeNumber = stock_id
        
        let htmlTable = """
            <!DOCTYPE html>
            <html>
            
            <head>
                <title>Vape Store</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
            </head>
            
            <body>
                <table border="0" width="100%" cellpadding="20" cellspacing="0" align="center" style="max-width:600px;margin:auto;border-spacing:0;border-collapse:collapse;background:white;border-radius:0px 0px 10px 10px;font-family:sans-serif;">
                    <tbody>
                        <tr>
                            <td style="text-align:center;border-collapse:collapse;background:#fff;border-radius:10px 10px 0px 0px;color:white;height:70px;background-color:#0a64f9;padding:10px">
                                <img src="https://ci6.googleusercontent.com/proxy/KMcbu8zrXoyWKSbPbnxVubGTx7PgYRs0S09MuME0p2pHSnUzhBCauFlLKn8LlYdveuxEOkeZehwgsghRc06WBSAvXg=s0-d-e1-ft#https://sandbox.quickvee.com/images/maillogo.png" width="100" class="CToWUd">
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="background:#fafafa; padding-top: 30px;">
                                <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
                                    <tbody>
                                        <tr>
                                            <td style="margin-right: 30px; ">
                                                <h5 style="font-size:1.25rem; margin: 0px;">\(storeName)</h5>
                                                <b>\(storeAddress)</b>
                                            </td>
                                            <td style="text-align:right; margin-left: 30px;">
                                                <h5 style="font-size:1.25rem;margin: 0px;">Stocktake Details</h5>
                                                <b style="opacity:0">quickvee</b>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
            
                        <tr>
                            <td style="background:#fafafa; padding-top: 10px;">
                                <table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
                                    <tbody>
                                        <tr>
                                            <td></td>
                                            <td style="text-align:right; margin-left: 30px;">
                                                <b>Stocktake Number: \(stockTakeNumber)</b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td style="text-align:right; margin-left: 30px;">
                                                <b>Issue Date: \(currentDate)</b>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
            
                        <tr>
                            <td style="background:#fafafa;">
                                \(tableHtml)
                            </td>
                        </tr>
                    </tbody>
                </table>
            </body>
            
            </html>
            """
        
        return htmlTable
        
    }
    
    func generateHTMLTable(from jsonData: [StockItemEmail], discrepancy: String, discrepancyCost: String) -> String {
        var jsonArray: [StockItemEmail] = []
        
        jsonArray = jsonData
                
        // Parse JSON data
//        do {
//            if let data = jsonData.data(using: .utf8),
//               let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
//                jsonArray = json
//            }
//        } catch {
//            print("Failed to parse JSON: \(error)")
//            return ""
//        }
        
        var htmlString = """
        <table border="1" width="100%" cellpadding="15" cellspacing="0" align="center" style="max-width:560px;border-spacing:0;border-collapse:collapse;margin:20px auto;width:560px;border:0px solid #000;">
        <tbody>
        <tr>
        """
        
        // Headers
//        if let jsonObject = jsonArray.first {
//            for key in jsonObject.keys {
//                htmlString.append("<th style=\"text-align:center;\">\(key)</th>")
//            }
//        }
        
        for key in itemHeaderEmail {
            htmlString.append("<th style=\"text-align:center;\">\(key)</th>")
        }
        
        htmlString.append("</tr>")
        
        // Rows
        for rowObject in jsonArray {
            htmlString.append("<tr>")
            htmlString.append("<td>\(rowObject.product_name)</td>")
            htmlString.append("<td style=\"text-align:center;\">\(rowObject.current_qty)</td>")
            htmlString.append("<td style=\"text-align:center;\">\(rowObject.new_qty)</td>")
            htmlString.append("<td style=\"text-align:center;\">\(rowObject.discrepancy)</td>")
            htmlString.append("<td style=\"text-align:center;\">\(rowObject.upc)</td>")
            htmlString.append("<td style=\"text-align:center;\">\(formatValue(rowObject.discrepancy_cost, isCurrency: false))</td>")
            htmlString.append("</tr>")
        }
        
        // Additional row for Total Discrepancy
        htmlString.append("""
        <tr><th colspan="3" style="text-align:left;">Total Discrepancy</th><th style="text-align:center;">\(formatValue(String(discrepancy), isCurrency: false))</th><th></th><th style="text-align:center;">\(formatValue(discrepancyCost.replacingOccurrences(of: ",", with: ""), isCurrency: false))</th></tr>
        """)
        
        
        htmlString.append("</tbody></table>")
        
        return emailContent(tableHtml: htmlString)
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension StockItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockItemTableViewCell
        
        let item = stockItemList[indexPath.row]
        
        cell.itemName.text = item.product_name
        cell.itemUpc.text = item.upc
        
        cell.oldQtyValue.text = item.current_qty
        cell.newQtyValue.text = item.new_qty
        
        let dis = item.discrepancy
        
        let dis_doub = Double(dis) ?? 0.00
        
        if dis_doub == 0.00 {
            cell.discrepancyValue.text = "0"
        }
        else {
            if dis_doub < 0.00 {
                cell.discrepancyValue.text = "\(dis)"
            }
            else {
                cell.discrepancyValue.text = "\(dis)"
            }
        }
        
        let cost = item.discrepancy_cost
        
        let cost_doub = Double(cost) ?? 0.00
        
        if cost_doub == 0.00 {
            cell.disCostValue.text = "$0.00"
        }
        else {
            if cost.hasPrefix("-") {
                //cost.removeFirst()
                cell.disCostValue.text = "$\(String(format: "%.2f", cost_doub))"
            }
            
            else {
                
                cell.disCostValue.text = "+$\(String(format: "%.2f", cost_doub))"
            }
        }
       
        cell.noteValue.text = item.note
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
}

struct Stock {
    
    let id: String
    let st_id: String
    let total_qty: String
    let total_discrepancy_cost: String
    let total_discrepancy: String
    let status: String
    let send_email: String
    let merchant_id: String
    let employee_id: String
    let created_at: String
    let updated_at: String
    let stocktake_item: Any
}

struct StockItem {
    
    let id: String
    let stock_id: String
    let upc: String
    let category_id: String
    let product_id: String
    let variant_id: String
    let product_name: String
    let variant: String
    let current_qty: String
    var new_qty: String
    var discrepancy: String
    let discrepancy_cost: String
    let merchant_id: String
    let employee_id: String
    let created_at: String
    let updated_at: String
    let note: String
}


struct StockItemEmail {
    
    let product_name: String
    let current_qty: String
    var new_qty: String
    var discrepancy: String
    let discrepancy_cost: String
    let upc: String

}

