//
//  CustomerViewController.swift
//
//
//  Created by Jamaluddin Syed on 01/08/24.
//

import UIKit

class CustomerViewController: UIViewController {
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var customLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noCustomerImage: UIImageView!
    @IBOutlet weak var noCustomerLbl: UILabel!
    
    @IBOutlet weak var homeBtn: UIButton!
    
    let colorbg = ["#AECCFF", "#C4F1AB", "#FFD5D5"]
    let colorletters = ["#0A64F9", "#1FA25C", "#F55353"]
    var customerList = [CustomersModel]()
    
    var initialText = ""
    var customerId = ""
    
    var searching = false
    
    var c_email = ""
    var c_phone = ""
    var custbgcolor: UIColor?
    var initialColor: UIColor?
    
    
    let initial = ["##", "#", "##"]
    
    var index = 0
    var page = 0
    
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search Customer"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBtn.alpha = 1
        searchBar.alpha = 0
        backBtn.alpha = 1
        customLbl.alpha = 1
        homeBtn.alpha = 1
        
        tableview.showsVerticalScrollIndicator = false
        
        topview.addBottomShadow()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customerslistAPI()
        
    }
    
    
    func customerslistAPI() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        tableview.isHidden = true
        loadIndicator.isAnimating = true
        noCustomerLbl.isHidden = true
        noCustomerImage.isHidden = true
        
        page = 1
        
        ApiCalls.sharedCall.getCustomers(merchant_id: id, page_no: page, limit: 10) { isSuccess, responseData in
            
            if isSuccess {
                
                
                guard let list = responseData["result"] else {
                    print("no results")
                    self.loadIndicator.isAnimating = false
                    self.noCustomerLbl.isHidden = false
                    self.noCustomerImage.isHidden = false
                    return
                }
                self.getResponseValues(list: list)
                self.loadIndicator.isAnimating = false
            }
            else {
                
            }
        }
    }
    
    func getResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [CustomersModel]()
        
        for res in response {
            
            let customer = CustomersModel(customer_id: "\(res["customer_id"] ?? "")",
                                          name: "\(res["name"] ?? "")",
                                          email: "\(res["email"] ?? "")",
                                          phone: "\(res["phone"] ?? "")",
                                          a_address_line_1: "\(res["a_address_line_1"] ?? "")",
                                          suite: "\(res["suite"] ?? "")",
                                          pincode: "\(res["pincode"] ?? "")",
                                          state: "\(res["state"] ?? "")",
                                          city: "\(res["city"] ?? "")",
                                          dob: "\(res["dob"] ?? "")",
                                          note: "\(res["note"] ?? "")",
                                          is_disabled: "\(res["is_disabled"] ?? "")",
                                          total_bonus_points: "\(res["total_bonus_points"] ?? "")",
                                          total_store_credit: "\(res["total_store_credit"] ?? "")")
            
            
            small.append(customer)
        }
        if small.count == 0 {
            tableview.isHidden = true
            noCustomerImage.isHidden = false
            noCustomerLbl.isHidden = false
        }
        else {
            tableview.isHidden = false
            noCustomerImage.isHidden = true
            noCustomerLbl.isHidden = true
        }
        customerList = small
        tableview.reloadData()
    }
    
    
    func getResponsePageValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [CustomersModel]()
        
        for res in response {
            
            let customer = CustomersModel(customer_id: "\(res["customer_id"] ?? "")",
                                          name: "\(res["name"] ?? "")",
                                          email: "\(res["email"] ?? "")",
                                          phone: "\(res["phone"] ?? "")",
                                          a_address_line_1: "\(res["a_address_line_1"] ?? "")",
                                          suite: "\(res["suite"] ?? "")",
                                          pincode: "\(res["pincode"] ?? "")",
                                          state: "\(res["state"] ?? "")",
                                          city: "\(res["city"] ?? "")",
                                          dob: "\(res["dob"] ?? "")",
                                          note: "\(res["note"] ?? "")",
                                          is_disabled: "\(res["is_disabled"] ?? "")",
                                          total_bonus_points: "\(res["total_bonus_points"] ?? "")",
                                          total_store_credit: "\(res["total_store_credit"] ?? "")")
            
            
            small.append(customer)
        }
        
        if small.count == 0 {
            page -= 1
        }
        else {
            customerList.append(contentsOf: small)
        }
        tableview.reloadData()
    }
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            
            searching = false
            customerslistAPI()
            
        }
        else {
            
            searching = true
            var name = ""
            var phone = ""
            
            if searchText.isNumber {
                phone = searchText
            }
            else {
                name = searchText
            }
            
            searchApi(name: name, phone: phone)
        }
    }
    
    func getInitials(from name: String) -> String {
        let nameComponents = name.split(separator: " ")
        let firstInitial = nameComponents.first?.prefix(1) ?? ""
        
        var middleInitial = ""
        if nameComponents.count > 2 {
            middleInitial = String(nameComponents[1].prefix(1))
        }
        
        let lastInitial = nameComponents.count > 1 ? nameComponents.last?.prefix(1) ?? "" : ""
        return "\(firstInitial)\(middleInitial)\(lastInitial)"
    }
    
    func formatPhoneNumber(_ number: String) -> String {
        let formattedNumber = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        return formattedNumber
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            performSegue(withIdentifier: "toAddCustomer", sender: nil)
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        searching = true
        
        backBtn.alpha = 0
        customLbl.alpha = 0
        searchBtn.alpha = 0
        homeBtn.alpha = 0
        searchBar.alpha = 1
        searchBar.becomeFirstResponder()
        
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddCustomer" {
            
            let vc = segue.destination as! CustomerAddEditViewController
            vc.mode = "add"
        }
        
        else if segue.identifier == "tocustInfo" {
            let vc = segue.destination as! CustomerInfoVC
            
            vc.initial = initialText
            vc.custId = customerId
            vc.email = c_email
            vc.phone = c_phone
            vc.custViewbg = custbgcolor
            vc.inicolor = initialColor
        }
    }
    
    
    
    func searchApi(name: String, phone: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        tableview.isHidden = true
        loadIndicator.isAnimating = true
        noCustomerLbl.isHidden = true
        noCustomerImage.isHidden = true
        
        ApiCalls.sharedCall.searchCustomers(merchant_id: id, name: name, phone: phone){ isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    self.noCustomerLbl.isHidden = false
                    self.noCustomerImage.isHidden = false
                    self.loadIndicator.isAnimating = false
                    self.tableview.isHidden = true
                    
                    return
                }
                self.getResponseValues(list: list)
                self.loadIndicator.isAnimating = false
            }
            else{
                print("Api Error")
            }
        }
    }
    
    
    
    
    
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
        }
        
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if searching {
            
        }
        
        else {
            
            let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            
            if let visiblePaths = tableview.indexPathsForVisibleRows,
               visiblePaths.contains([0, customerList.count - 1]) {
                
                
                page += 1
                
                ApiCalls.sharedCall.getCustomers(merchant_id: id, page_no: page, limit: 10) {isSuccess, responseData in
                    
                    if isSuccess {
                         
                        guard let list = responseData["result"] else {
                            return
                        }
                        
                        self.getResponsePageValues(list: list)
                    }
                    else {
                        print("APi Error")
                    }
                    
                }
            }
        }
    }
}


extension CustomerViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        backBtn.alpha = 1
        customLbl.alpha = 1
        searchBtn.alpha = 1
        homeBtn.alpha = 1
        searchBar.alpha = 0
        
        view.endEditing(true)
        
        searching = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text ?? ""
        
        if searchText == "" {
            performSearch(searchText: "")
        }
        else {
            performSearch(searchText: searchText)
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



extension CustomerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return customerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "customercell", for: indexPath) as! CustomerTableViewCell
        
        if index == 2 {
            index = 0
        }
        else {
            index += 1
        }
        
        let width = cell.customerView.bounds.size.width
        cell.customerView.layer.cornerRadius = width/2
        
        cell.customName.text = customerList[indexPath.row].name.capitalized
        
        let mobileNumber = customerList[indexPath.row].phone
        let formattedNumber = formatPhoneNumber(mobileNumber)
        cell.customNumber.text = formattedNumber
        
        
        if customerList[indexPath.row].is_disabled == "1" {
            cell.customName.textColor = .lightGray
            cell.customNumber.textColor = .lightGray
            cell.disabledBtn.isHidden = false
            
        }
        else {
            cell.customName.textColor = .black
            cell.customNumber.textColor = UIColor(named: "#646464")
            cell.disabledBtn.isHidden = true
        }
        
        let initials = getInitials(from: customerList[indexPath.row].name)
        cell.initialLabel.text = initials.uppercased()
        cell.initialLabel.textColor = UIColor(hexString: colorletters[index])
        
        cell.customerView.backgroundColor = UIColor(hexString: colorbg[index])
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        let cell = tableview.cellForRow(at: indexPath) as! CustomerTableViewCell
        
        initialText = getInitials(from: customerList[indexPath.row].name)
        customerId = customerList[indexPath.row].customer_id
        c_email = customerList[indexPath.row].email
        c_phone = customerList[indexPath.row].phone
        custbgcolor = cell.customerView.backgroundColor
        initialColor = cell.initialLabel.textColor
                                                                                              
        performSegue(withIdentifier: "tocustInfo", sender: nil)
    }
    
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

struct CustomersModel {
    
    var customer_id: String
    var name: String
    var email: String
    var phone: String
    var a_address_line_1: String
    var suite: String
    var pincode: String
    var state: String
    var city: String
    var dob: String
    var note: String
    var is_disabled: String
    var total_bonus_points: String
    var total_store_credit: String
    
}
