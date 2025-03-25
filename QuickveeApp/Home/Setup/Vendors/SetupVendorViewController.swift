//
//  SetupVendorViewController.swift
//  
//
//  Created by Jamaluddin Syed on 27/03/23.
//

import UIKit
import Alamofire
import MaterialComponents

class SetupVendorViewController: UIViewController {
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var noVendorView: UIView!
    @IBOutlet weak var clickToAdd: UIButton!
    @IBOutlet weak var noVendorLabel: UILabel!
    
    @IBOutlet weak var clickLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var vendorTile: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var floatAddBtn: UIButton!
    
    var vendorsArray = [Vendors]()
    var subVendorArray = [Vendors]()
    var searchVendorArray = [Vendors]()

    var vendor_id: String?
    var merchant_id: String?
    var searching = false

    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let refresh = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        tableview.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
//        searchBar.showsCancelButton = true
        blackView.isHidden = true
        floatAddBtn.isHidden = true
        
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backBtn.isHidden = false
            vendorTile.textAlignment = .left
        }
        
        else {
            backBtn.isHidden = true
            vendorTile.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        
        loadingIndicator.isAnimating = true
        searching = false
        subVendorArray = []
        setupApi()
        tableview.isHidden = true
        noVendorView.isHidden = true
        backBtn.alpha = 1
        vendorTile.alpha = 1
        searchBtn.alpha = 1
        searchBar.alpha = 0
        
        
        }
    
    
    func setupApi() {
        
        
        let url = AppURLs.VENDOR_PAYMENT_LIST

        let parameters: [String:Any] = [
            "merchant_id": merchant_id!
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    
                    guard let _ = json["result"] else {
                        print("No records found")
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = true
                        self.noVendorView.isHidden = false
                        self.floatAddBtn.isHidden = true
                        return
                    }
                    self.responseValues(responseValues: json["result"]!)
                    self.tableview.reloadData()
                    self.loadingIndicator.isAnimating = false
                    self.tableview.isHidden = false
                    self.noVendorView.isHidden = true
                    self.floatAddBtn.isHidden = false
                    
                    if self.refresh.isRefreshing {
                        self.refresh.endRefreshing()
                    }
                }
                catch {
                    
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func responseValues(responseValues: Any) {
        
        
        let response = responseValues as! [[String:Any]]
        print(response)
        
        var first = 0
        var vendorArray = [Vendors]()
        for res in response {
            let vendor = Vendors(name: "\(res["name"] ?? "")",
                                 enabled: "\(res["enabled"] ?? "")",
                                 phone: "\(res["phone"] ?? "")",
                                 recent_pay_amount: "\(res["recent_pay_amount"] ?? "")",
                                 recent_payment_datetime: "\(res["recent_payment_datetime"] ?? "")",
                                 vendor_id: "\(res["vendor_id"] ?? "")",
                                 total_pay: "\(res["total_pay"] ?? "")",
                                 pay_count: "\(res["pay_count"] ?? "")")
            if first != 0 {
                vendorArray.append(vendor)
                subVendorArray.append(vendor)
            }
            first += 1
        }
        vendorsArray = vendorArray
        
        
        print(vendorArray)
    }
    
    @objc func pullToRefresh() {
        
        setupApi()
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        let cleanedAmount = ""
        
        
        let amount = Double(cleanedAmount) ?? 0.0
        let amountAsDouble = (amount / 100.0)
        var amountAsString = String(amountAsDouble)
        if cleanedAmount.last == "0" {
            amountAsString.append("0")
        }
        textField.text = amountAsString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toShowVendor" {
            
            let vc = segue.destination as! ShowVendorViewController
            vc.vendorId = vendor_id
            vc.merchant_id = merchant_id!
        }
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addVendorBtnClick(_ sender: UIButton) {
        
        presentAddVendor()
    }
    
    @IBAction func addVendorClick(_ sender: UIButton) {
        
        presentAddVendor()
    }
    
    func presentAddVendor() {
        
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(red: 14.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 0.7)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addVendor") as! AddVendorViewController
        vc.viewcontrol = self
        vc.mode = "add"
        vc.merchant_id = merchant_id
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true)
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        backBtn.alpha = 0
        vendorTile.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            var destiny = 0
            let viewcontrollerArray = navigationController?.viewControllers

            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
        else {
           dismiss(animated: true)
        }
    }
}

extension SetupVendorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
           searching = false
        }
        
        else {
            searchVendorArray = subVendorArray.filter { $0.name!.lowercased().prefix(searchText.count) == searchText.lowercased() }
            searching = true
        }
        
        
        tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        backBtn.alpha = 1
        vendorTile.alpha = 1
        searchBtn.alpha = 1
        searchBar.alpha = 0
        
        searching = false
        
        view.endEditing(true)
        
        tableview.reloadData()
    }
    
    func roundOf(item : String) -> Double {
        
        let doub = Double(item) ?? 0.00
        let div = Double(round(100 * doub) / 100)
        print(div)
        return div
    }
}

extension SetupVendorViewController: UITableViewDelegate, UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVendorArray.count
        }
        
        else {
            return vendorsArray.count
        }
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchVendorTableViewCell
            
            cell.searchVendorName.text = searchVendorArray[indexPath.row].name
            
            return cell
        }
        
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetupVendorTableViewCell
            
            cell.vendorLabel.text = "Vendor:"
            cell.vendorLabelValue.text = vendorsArray[indexPath.row].name
            
            cell.recentLabel.text = "Most Recent:"
            cell.recentValue.text = "\(vendorsArray[indexPath.row].recent_payment_datetime!)"
            
            let recent_pay = "\(vendorsArray[indexPath.row].recent_pay_amount!)"
            
            if recent_pay == "" {
                cell.costLabel.text = "-"
            }
            else {
                cell.costLabel.text = "$\(recent_pay)"
            }
            
            cell.totalLabel.text = "Total:"
            
            let total_pay = "\(vendorsArray[indexPath.row].total_pay!)"
                
            if total_pay == "" {
                cell.totalValue.text = "-"
            }
            else {
                let pay_double = roundOf(item: total_pay)
                let pay_round_Of = String(format:"%.02f", pay_double)
                cell.totalValue.text = "$\(pay_round_Of)"
            }
            
            cell.vendorUnit.text = "#\(vendorsArray[indexPath.row].pay_count!)"
            
            if vendorsArray[indexPath.row].enabled == "1" {
                
                cell.vendorLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.vendorLabelValue.textColor = UIColor.black
                
                cell.recentLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.recentValue.textColor = UIColor.black
                cell.costLabel.textColor = UIColor.black
                
                cell.totalLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.totalValue.textColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
                
                cell.vendorUnit.textColor = UIColor.black
            }
            else {
                
                cell.vendorLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.vendorLabelValue.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                
                cell.recentLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.recentValue.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.costLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                
                cell.totalLabel.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                cell.totalValue.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
                
                cell.vendorUnit.textColor = UIColor(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if searching {
            print(indexPath.row)
            vendor_id = searchVendorArray[indexPath.row].vendor_id
        }
        
        else {
            print(indexPath.row)
            vendor_id = vendorsArray[indexPath.row].vendor_id
        }
        
        print(vendor_id!)
        self.searchBar.searchTextField.endEditing(true)

        performSegue(withIdentifier: "toShowVendor", sender: nil)
    }
}

extension SetupVendorViewController {
    
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


struct Vendors {
    
    let name: String?
    let enabled: String?
    let phone: String?
    let recent_pay_amount: String?
    let recent_payment_datetime: String?
    let vendor_id: String?
    let total_pay: String?
    let pay_count: String?
}

