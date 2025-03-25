//
//  StockTakeViewController.swift
//  
//
//  Created by Jamaluddin Syed on 06/11/24.
//

import UIKit

class StockTakeViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var nostockLabel: UILabel!
    
    @IBOutlet weak var noStockImg: UIImageView!
    
    
    @IBOutlet weak var addBtn: UIButton!
    
    var stockList = [StockTake]()
    var subStockList = [StockTake]()
    var searchStockList = [StockTake]()
    
    var searching = false

    var stock_id = ""
    var stock_status = ""
    var mode = ""

    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableview.showsVerticalScrollIndicator = false
        
        
        
        if UserDefaults.standard.bool(forKey: "lock_access_stocktake") {
            
            tableview.isHidden = true
            nostockLabel.isHidden = false
            noStockImg.isHidden = false
            nostockLabel.text = "Access Denied"
            addBtn.isHidden = true
        }
        
        else {
            setupUI()
            setupStockApi()
            subStockList = []
        }
    }
    
    func setupStockApi() {
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        nostockLabel.isHidden = true
        noStockImg.isHidden = true
        nostockLabel.text = "No StockTake Found"
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getStocktakeList(merchant_id: id) { isSuccess, responseData in
            
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
        
        let response = list as! [[String: Any]]
        var small = [StockTake]()
        
        for res in response {
            
            let stock = StockTake(id: "\(res["id"] ?? "")", st_id: "\(res["st_id"] ?? "")",
                                  total_qty: "\(res["total_qty"] ?? "")", total_discrepancy_cost: "\(res["total_discrepancy_cost"] ?? "")",
                                  total_discrepancy: "\(res["total_discrepancy"] ?? "")", status: "\(res["status"] ?? "")",
                                  send_email: "\(res["send_email"] ?? "")", merchant_id: "\(res["merchant_id"] ?? "")",
                                  employee_id: "\(res["employee_id"] ?? "")", created_at: "\(res["created_at"] ?? "")",
                                  updated_at: "\(res["updated_at"] ?? "")")
            small.append(stock)
        }
        stockList = small
        subStockList = small
        
        if stockList.count == 0 {
           
            
        }
        else {
            
        }
        
        
        loadingIndicator.isAnimating = false
        tableview.isHidden = false
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStockAdd" {
            _ = segue.destination as! StockAddViewController
        }
        else if segue.identifier == "toDraftSave" {
            let vc = segue.destination as! StockSaveViewController
            vc.stockId = stock_id
            vc.mode = mode
        }
        else {
            let vc = segue.destination as! StockItemsViewController
            vc.stock_id = stock_id
            vc.stock_status = stock_status
        }
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_stocktake") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            UserDefaults.standard.set(true, forKey: "isStockAdd")
            performSegue(withIdentifier: "toStockAdd", sender: nil)
        }
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

extension StockTakeViewController: UISearchBarDelegate {
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            tableview.isHidden = false
            nostockLabel.isHidden = true
            noStockImg.isHidden = true
        }
        
        else {
            searching = true
            searchStockList = subStockList.filter { $0.st_id.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
            if searchStockList.count == 0 {
                
                tableview.isHidden = true
                nostockLabel.isHidden = false
                noStockImg.isHidden = false
            }
            else {
                tableview.isHidden = false
                nostockLabel.isHidden = true
                noStockImg.isHidden = true
            }
        }
        tableview.reloadData()
    }
}

extension StockTakeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchStockList.count
        }
        else {
            return stockList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "stock", for: indexPath) as! StockTableViewCell
            
            let stock = searchStockList[indexPath.row]
            
            cell.stockName.text = stock.st_id
            let ordDate = ToastClass.sharedToast.setStockDateFormat(dateStr:  stock.created_at)
            print(ordDate)
            cell.stockDate.text = ordDate
            
            //cell.stockDate.text = stock.created_at
            cell.stockQty.text = "Total Qty:"
            cell.stockDis.text = "Total Discrepancy Cost"
            
            let stock_status = stock.status
            
            if stock_status == "0" {
                cell.stockStatus.text = "Completed"
                cell.stockStatus.textColor = UIColor(hexString: "#2EC278")
            }
            else if stock_status == "1" {
                cell.stockStatus.text = "Draft"
                cell.stockStatus.textColor = UIColor(hexString: "#7B7B7B")
            }
            else {
                cell.stockStatus.text = "Void"
                cell.stockStatus.textColor = UIColor(hexString: "#F55353")

            }
            
            cell.stockQtyValue.text = stock.total_qty
            
            let cost = stock.total_discrepancy_cost
            
            if cost == "0.00" {
                cell.stockDisValue.text = "$0.00"
            }
            else {
                cell.stockDisValue.text = "+$\(cost)"
            }
            
            cell.uppperview.layer.cornerRadius = 10
            cell.uppperview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            cell.borderView.layer.cornerRadius = 10
            cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
            cell.borderView.layer.shadowOpacity = 1
            cell.borderView.layer.shadowOffset = CGSize.zero
            cell.borderView.layer.shadowRadius = 3
            
            return cell
        }
        
        else {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "stock", for: indexPath) as! StockTableViewCell
            
            let stock = stockList[indexPath.row]
            
            cell.stockName.text = stock.st_id
            cell.stockDate.text = stock.created_at
          
           
            let ordDate = ToastClass.sharedToast.setStockDateFormat(dateStr:  stock.created_at)
            print(ordDate)
            cell.stockDate.text = ordDate
           
            
            cell.stockQty.text = "Total Qty:"
            cell.stockDis.text = "Total Discrepancy Cost"
            
            let stock_status = stock.status
            
            if stock_status == "0" {
                cell.stockStatus.text = "Completed"
                cell.stockStatus.textColor = UIColor(hexString: "#2EC278")
            }
            else if stock_status == "1" {
                cell.stockStatus.text = "Draft"
                cell.stockStatus.textColor = UIColor(hexString: "#7B7B7B")
            }
            else {
                cell.stockStatus.text = "Void"
                cell.stockStatus.textColor = UIColor(hexString: "#F55353")

            }
            
            cell.stockQtyValue.text = stock.total_qty
                        
            var cost = stock.total_discrepancy_cost
            
            if cost == "0.00" {
                cell.stockDisValue.text = "$0.00"
            }
            else {
                cell.stockDisValue.text = "+$\(cost)"
            }
            
            cell.uppperview.layer.cornerRadius = 10
            cell.uppperview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            cell.borderView.layer.cornerRadius = 10
            cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
            cell.borderView.layer.shadowOpacity = 1
            cell.borderView.layer.shadowOffset = CGSize.zero
            cell.borderView.layer.shadowRadius = 3
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if UserDefaults.standard.bool(forKey: "lock_view_stocktake") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            
            stock_id = stockList[indexPath.row].id
            
            stock_status = stockList[indexPath.row].status
            
            if stock_status == "1" {
                mode = "draft"
                performSegue(withIdentifier: "toDraftSave", sender: nil)
            }
            else {
                performSegue(withIdentifier: "toStockItem", sender: nil)
            }
        }
    }
}

struct StockTake {
    
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
}
//        0 = completed
//        1 = draft
//        2 = void
        
        //completed can be made void
        //void has nothing
