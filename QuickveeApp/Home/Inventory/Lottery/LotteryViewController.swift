//
//  LotteryViewController.swift
//  
//
//  Created by Jamaluddin Syed on 03/09/24.
//

import UIKit

class LotteryViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var floatBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noLotteryLbl: UILabel!    
    @IBOutlet weak var clickLbl: UILabel!
    
    var lotteryList = [InventoryProductModel]()
    var subLotteryList = [InventoryProductModel]()
    var searchLotteryList = [InventoryProductModel]()
    
    var upcList = [String]()

    
    var searching = false

    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var mode = ""
    var lottery_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        floatBtn.setImage(UIImage(named: "add_blue"), for: .normal)
        addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "lock_manage_lottery") {
            
            tableview.isHidden = true
            loadingIndicator.isAnimating = false
            
            floatBtn.isHidden = true
            addView.isHidden = false
            addBtn.isHidden = false
            addBtn.setImage(UIImage(named: "No Data"), for: .normal)
            noLotteryLbl.isHidden = false
            noLotteryLbl.text = "Access Denied"
            clickLbl.isHidden = true
        }
        
        else {
            setupApi()
        }

        subLotteryList = []
        tableview.showsVerticalScrollIndicator = false
    }
    
    func setupApi() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        floatBtn.isHidden = true
        addView.isHidden = true
        addBtn.isHidden = true
        noLotteryLbl.isHidden = true
        noLotteryLbl.text = "No Lottery Found"
        clickLbl.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.productListCall(id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    self.floatBtn.isHidden = true
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    
                    self.addView.isHidden = false
                    self.addBtn.isHidden = false
                    self.noLotteryLbl.isHidden = false
                    self.clickLbl.isHidden = false
                    
                    return
                }
                
                self.getResponseValues(products: list)
            }
            else {
                print("API failed")
            }
        }
    }
    
    func getResponseValues(products: Any) {
        
        let response = products as! [[String:Any]]
        var smallres = [InventoryProductModel]()
        var sublupc = [String]()
        
        for res in response {
            
            let lottery = InventoryProductModel(HS_code: "\(res["HS_code"] ?? "")",
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
            
            if lottery.is_lottery == "1" {
                smallres.append(lottery)
                
                sublupc.append(lottery.upc)
                
                if lottery.vupc.contains(",") {
                    let commasub = lottery.vupc.components(separatedBy: ",")
                    sublupc.append(contentsOf: commasub)
                }
                else {
                    sublupc.append(lottery.vupc)
                }
            }
        }
        
        if smallres.count == 0 {
            
            self.tableview.isHidden = true
            self.floatBtn.isHidden = true
            self.loadingIndicator.isAnimating = false
            
            self.addView.isHidden = false
            self.addBtn.isHidden = false
            self.noLotteryLbl.isHidden = false
            self.clickLbl.isHidden = false
        }
        
        else {
            
            lotteryList = smallres.sorted(by: {$0.id > $1.id})
            subLotteryList = lotteryList
            
            self.tableview.isHidden = false
            self.loadingIndicator.isAnimating = false
            self.floatBtn.isHidden = false
            
            self.addView.isHidden = true
            self.addBtn.isHidden = true
            self.noLotteryLbl.isHidden = true
            self.clickLbl.isHidden = true
            
        }
        
        upcList = sublupc
        
        UserDefaults.standard.set(upcList, forKey: "lottery_upcs_list")
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_lottery") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            if sender.currentImage == UIImage(named: "add_blue") {
                mode = "add"
                performSegue(withIdentifier: "toAddLottery", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! AddEditLotteryViewController
        
        if mode == "update" {
            vc.lottery_id = lottery_id
        }
        vc.mode = mode
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        
        else {
            searching = true
            
            searchLotteryList = subLotteryList.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
        }
        tableview.reloadData()
        
        if tableview.visibleCells.isEmpty {
            
            tableview.isHidden = true
            addView.isHidden = false
            addBtn.isHidden = false
            noLotteryLbl.isHidden = false
            clickLbl.isHidden = false
            
            addBtn.setImage(UIImage(named: "No Data"), for: .normal)
            noLotteryLbl.text = "No Lottery Found"
            clickLbl.text = ""
        }
        else {
            tableview.isHidden = false
            addView.isHidden = true
            addBtn.isHidden = true
            noLotteryLbl.isHidden = true
            clickLbl.isHidden = true
            
            addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
            noLotteryLbl.text = "No Lottery Found"
            clickLbl.text = "Click On + To Add Lottery"
        }
    }
}

extension LotteryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchLotteryList.count
        }
        else {
            return lotteryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LotteryTableViewCell
        
        if searching {
            
            let lottery = searchLotteryList[indexPath.row]
            
            cell.lotteryNameValue.text = lottery.title
            cell.priceValue.text = "$\(lottery.price)"
            cell.upcValue.text = lottery.upc
            cell.QTYvALUE.text = lottery.quantity
        }
        
        else {
            
            let lottery = lotteryList[indexPath.row]
            
            cell.lotteryNameValue.text = lottery.title
            cell.priceValue.text = "$\(lottery.price)"
            cell.upcValue.text = lottery.upc
            cell.QTYvALUE.text = lottery.quantity
        }
        
        cell.borderView.layer.cornerRadius = 10
        cell.blueview.layer.cornerRadius = 10
        cell.borderView.layer.shadowColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        cell.borderView.layer.shadowOpacity = 1
        cell.borderView.layer.shadowOffset = CGSize.zero
        cell.borderView.layer.shadowRadius = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_lottery") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            mode = "update"
            
            if searching {
                lottery_id = searchLotteryList[indexPath.row].id
            }
            else {
                lottery_id = lotteryList[indexPath.row].id
            }
            performSegue(withIdentifier: "toAddLottery", sender: nil)
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
