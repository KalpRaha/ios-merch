//
//  EmployeesViewController.swift
//  
//
//  Created by Jamaluddin Syed on 6/12/24.
//

import UIKit

class EmployeesViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var addBtn: UIButton!

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var empLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var merchant_id: String?
    var mode = ""
    var emp_id = ""
    var searching = false
    
    var subEmpArray = [Employee]()
    var searchEmpArray = [Employee]()
    var employees = [Employee]()
    var pinArray = [String]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupUI()
        addBtn.isHidden = true
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        subEmpArray = []
        
        searchBar.searchBarStyle = .minimal
        backBtn.alpha = 1
        empLabel.alpha = 1
        searchBtn.alpha = 1
        searchBar.alpha = 0
        searchBar.showsCancelButton = true
        searching = false
        
        setupApi()
    }
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getEmpList(merchant_id: id) { isSuccess, responseData in
            
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
            }
            
            else {
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let res = response as! [[String:Any]]
        var smallemp = [Employee]()
        var smallpin = [String]()
        
        for emp in res {
            
            let employee = Employee(id: "\(emp["id"] ?? "")", f_name: "\(emp["f_name"] ?? "")",
                                    l_name: "\(emp["l_name"] ?? "")", phone: "\(emp["phone"] ?? "")",
                                    email: "\(emp["email"] ?? "")", pin: "\(emp["pin"] ?? "")",
                                    wages_per_hr: "\(emp["wages_per_hr"] ?? "")", role: "\(emp["role"] ?? "")",
                                    merchant_id: "\(emp["merchant_id"] ?? "")", admin_id: "\(emp["admin_id"] ?? "")",
                                    address: "\(emp["address"] ?? "")", city: "\(emp["city"] ?? "")",
                                    state: "\(emp["state"] ?? "")", zipcode: "\(emp["zipcode"] ?? "")",
                                    is_employee: "\(emp["is_employee"] ?? "")", permissions: "\(emp["permissions"] ?? "")",
                                    paid_breaks: "\(emp["paid_breaks"] ?? "")", break_time: "\(emp["break_time"] ?? "")",
                                    break_allowed: "\(emp["break_allowed"] ?? "")", is_login: "\(emp["is_login"] ?? "")",
                                    login_time: "\(emp["login_time"] ?? "")", status: "\(emp["status"] ?? "")",
                                    created_from: "\(emp["created_from"] ?? "")", created_at: "\(emp["created_at"] ?? "")",
                                    updated_from: "\(emp["updated_from"] ?? "")", updated_at: "\(emp["updated_at"] ?? "")",
                                    menu_list: "\(emp["menu_list"] ?? "")")
            
            smallemp.append(employee)
            smallpin.append(employee.pin)
        }
        
        employees = smallemp
        subEmpArray = smallemp
        pinArray = smallpin
        
        if employees.count == 0 {
            
            loadingIndicator.isAnimating = false
            addBtn.isHidden = false
            tableview.isHidden = true
       
        }
        else {
            
            loadingIndicator.isAnimating = false
            addBtn.isHidden = false
            tableview.isHidden = false
        }
        
        tableview.reloadData()
        
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        backBtn.alpha = 0
        empLabel.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        
        searchBar.text = ""
        
        searchBar.becomeFirstResponder()
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "lock_add_user") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            mode = "add"
            emp_id = ""
            performSegue(withIdentifier: "toSetupEmp", sender: nil)
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSetupEmp" {
            
            let vc = segue.destination as! EmpSetupViewController
            vc.mode = mode
            vc.emp_id = emp_id
            vc.pinCheck = pinArray
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

extension EmployeesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        
        else {
            
            searching = true
            
            searchEmpArray = subEmpArray.filter { employee in
                
                let searchTextLowercased = searchText.lowercased()
                let isFName = employee.f_name.lowercased().contains(searchTextLowercased)
                let isLName = employee.l_name.lowercased().contains(searchTextLowercased)
                
                return isFName || isLName
            }
        }
        tableview.reloadData()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        backBtn.alpha = 1
        empLabel.alpha = 1
        searchBtn.alpha = 1
        searchBar.alpha = 0
        
        searching = false
        
        view.endEditing(true)
        
        tableview.reloadData()
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchEmpArray.count
        }
        
        else {
            return employees.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if searching {
          
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
            
            let emp = searchEmpArray[indexPath.row]
            
            cell.empName.text = "\(emp.f_name) \(emp.l_name)"
            cell.empImage.image = UIImage(named: "emp_black")
            
            if emp.is_login == "1" {
                cell.empImage.isHidden = false
            }
            
            else {
                cell.empImage.isHidden = true
            }
            
            
            return cell
        }
        
        else {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
            
            let emp = employees[indexPath.row]
            
            cell.empName.text = "\(emp.f_name) \(emp.l_name)"
            cell.empImage.image = UIImage(named: "emp_black")
            
            if emp.is_login == "1" {
                cell.empImage.isHidden = false
            }
            
            else {
                cell.empImage.isHidden = true
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if UserDefaults.standard.bool(forKey: "lock_edit_user"){
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            
        }
        else {
            if searching {
                emp_id = searchEmpArray[indexPath.row].id
            }
            
            else {
                emp_id = employees[indexPath.row].id
            }
            
            mode = "edit"
            performSegue(withIdentifier: "toSetupEmp", sender: nil)
        }
    }
}


struct Employee {
    
    let id: String
    let f_name: String
    let l_name: String
    let phone: String
    let email: String
    let pin: String
    let wages_per_hr: String
    let role: String
    let merchant_id: String
    let admin_id: String
    let address: String
    let city: String
    let state: String
    let zipcode: String
    let is_employee: String
    let permissions: String
    let paid_breaks: String
    let break_time: String
    let break_allowed: String
    let is_login: String
    let login_time: String
    let status: String
    let created_from: String
    let created_at: String
    let updated_from: String
    let updated_at: String
    let menu_list: String
}


//searchProdArray = subProdArray.filter { product in
//    let searchTextLowercased = searchText.lowercased()
//    let isTitleMatch = product.title.lowercased().contains(searchTextLowercased)
//    let isUPCMatch = product.upc.lowercased().contains(searchTextLowercased)
//    let isVariantUPCMatch = product.vupc.split(separator: ",").contains { variant in
//        variant.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(searchTextLowercased)
//    }
//    return isTitleMatch || isUPCMatch || isVariantUPCMatch
//}
