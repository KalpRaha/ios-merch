//
//  SalesHistoryViewController.swift
//  
//
//  Created by Jamaluddin Syed on 1/5/24.
//

import UIKit

class SalesHistoryViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var noSalesImage: UIImageView!
    @IBOutlet weak var noSalesLabel: UILabel!
    
    var salesVar_id = ""
    var salesProd_id = ""
    var salesVar_name = ""
    
    var salesArr = [SalesHistoryModel]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addBottomShadow()
        tableview.dataSource = self
        tableview.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        noSalesImage.isHidden = true
        noSalesLabel.isHidden = true
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        setupSalesHistoryApi()
    }
    
    func setupSalesHistoryApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.salesHistoryCall(merchant_id: id, product_id: salesProd_id, variant_id: salesVar_id, admin_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["sales_history"] else {
                    self.noSalesImage.isHidden = false
                    self.noSalesLabel.isHidden = false
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    return
                }
                
                self.getSalesResponse(sales: list)
                
                DispatchQueue.main.async {
                    self.noSalesImage.isHidden = true
                    self.noSalesLabel.isHidden = true
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.tableview.reloadData()
                }
            }else{
                print("Api Error")
            }
        }
    }
    
    func getSalesResponse(sales: Any) {
        
        let res = sales as! [[String: Any]]
        
        var smallsales = [SalesHistoryModel]()
        
        
        for sale in res {
            let  salesvalue = SalesHistoryModel(cost_price: "\(sale["cost_price"] ?? "")", create_date: "\(sale["create_date"] ?? "")",
                                                is_refunded: "\(sale["is_refunded"] ?? "")", order_id:"\(sale["order_id"] ?? "")",
                                                price: "\(sale["price"] ?? "")", qty: "\(sale["qty"] ?? "")")
            smallsales.append(salesvalue)
            
        }
        salesArr = smallsales
     
        tableview.reloadData()
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeButtonClick(_ sender: UIButton) {
        
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }

        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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



extension SalesHistoryViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if salesArr.count == 0{
            return 0
        }
        else {
            return salesArr.count + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "salesHead", for: indexPath) as! SalesHeadTableViewCell
            cell.productName.text = salesVar_name
            return cell
        }
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "salesRecord", for: indexPath) as! SalesRecordTableViewCell
            let index = (indexPath.row - 1)
            let value = salesArr[index].price
            let doub_value = Double(value)
            let value1 = salesArr[index].cost_price
            let doub_value1 = Double(value1)
            
            //cell.dateLabel.text = salesArr[index].create_date
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: salesArr[index].create_date) {
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let formattedDate = dateFormatter.string(from: date)
                cell.dateLabel.text = formattedDate
            }
            
            
            let convert = String(format: " %.2f", doub_value ?? 0.00)
            let convertcost = String(format: " %.2f", doub_value1 ?? 0.00)
            cell.salesPriceValue.text = "$\(convert)"
            cell.salesQtyValue.text = salesArr[index].qty
            cell.costValue.text = "$\(convertcost)"
            cell.salesId.text = salesArr[index].order_id
            
            cell.recordBorderView.layer.cornerRadius = 10
            cell.costView.layer.cornerRadius = 5
            cell.recordBorderView.dropShadow2()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
    }
}

struct SalesHistoryModel {
    
    var cost_price: String
    var create_date: String
    var is_refunded : String
    var order_id : String
    var price : String
    var qty : String
    
}
    
    
    
    
    
    
    

