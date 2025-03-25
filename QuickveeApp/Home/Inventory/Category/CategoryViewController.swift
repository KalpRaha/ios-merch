//
//  CategoryViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/5/23.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addBtnData: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var addCatLbl: UILabel!
    @IBOutlet weak var addLblView: UIView!
    
    
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var noDataImg: UIImageView!
    
    @IBOutlet weak var nodataLbl: UILabel!
    
    
    var titletext = ""
    var addtitle = ""
    var cat_id = ""
    
    var categoryList = [InventoryCategory]()
    var subCatArray = [InventoryCategory]()
    var searchCatArray = [InventoryCategory]()
    var searching = false
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
        addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
        
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(addCat))
        //        noDataView.addGestureRecognizer(tap)
        //        tap.numberOfTapsRequired = 1
        //        noDataView.isUserInteractionEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subCatArray = []
        searching = false
        
        tableview.showsVerticalScrollIndicator = false
        
        tableview.isHidden = true
        noDataView.isHidden = true
        
        addLblView.isHidden = true
        noDataLbl.isHidden = true
        addBtnData.isHidden = true
        addCatLbl.isHidden = true
        addBtn.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "lock_manage_categories") {
            
            noDataView.isHidden = false
            noDataLbl.isHidden = false
            noDataImg.isHidden = false
        }
        else {
            setupUI()
            setupApi()
        }
    }
    
//    @objc func addCat() {
//        
//        if UserDefaults.standard.bool(forKey: "lock_manage_categories") {
//            ToastClass.sharedToast.showToast(message: "Access Denied",
//                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//        }
//        else {
//            setupUI()
//            setupApi()
//            UserDefaults.standard.set(true, forKey: "showData")
//        }
//    }
    
    func setupApi() {
        
        addLblView.isHidden = true
        noDataLbl.isHidden = true
        addBtnData.isHidden = true
        addCatLbl.isHidden = true
        
        noDataView.isHidden = true

        addBtn.isHidden = true
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.categoryListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    self.addLblView.isHidden = false
                    self.noDataLbl.isHidden = false
                    self.addBtnData.isHidden = false
                    self.addCatLbl.isHidden = false
                    self.addBtn.isHidden = false
                    
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    return
                }
                self.getResponseValues(list: list)
                
                if self.categoryList.count == 0 {
                    
                    self.addLblView.isHidden = false
                    self.addBtnData.isHidden = false
                    self.addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
                    self.noDataLbl.text = "No Categories Added"
                    self.addBtn.isHidden = true
                    
                    
                    self.loadingIndicator.isAnimating = false
                    self.tableview.isHidden = true
                }
                
                else {
                    
                    
                    self.noDataLbl.text = "No Categories Added"
                    self.noDataLbl.isHidden = true
                    self.addBtn.isHidden = false
                    self.addBtnData.setImage(UIImage(named: "add_blue"), for: .normal)
                    self.addBtnData.isHidden = true
                    self.addLblView.isHidden = true
                    
                    
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.tableview.reloadData()
                }
            }else{
                print("Api Error")
            }
        }
    }
    

    func getResponseValues(list: Any) {
        
        let response = list as! [[String:Any]]
        var smallres = [InventoryCategory]()
        
        for res in response {
            
            let category = InventoryCategory(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                             description: "\(res["description"] ?? "")", categoryBanner: "\(res["categoryBanner"] ?? "")",
                                             show_online: "\(res["show_online"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                             cat_show_status: "\(res["cat_show_status"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                             alternateName: "\(res["alternateName"] ?? "")",
                                             merchant_id: "\(res["merchant_id"] ?? "")", is_deleted: "\(res["is_deleted"] ?? "")",
                                             user_id: "\(res["user_id"] ?? "")", created_on: "\(res["created_on"] ?? "")",
                                             updated_on: "\(res["updated_on"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                                             use_point: "\(res["use_point"] ?? "")", earn_point: "\(res["earn_point"] ?? "")")
            
            smallres.append(category)
        }
        
        categoryList = smallres
        subCatArray = smallres
    }
    
    func setupDeleteCategory(id: String) {
        
        ApiCalls.sharedCall.categoryDelete(id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                self.setupApi()
                ToastClass.sharedToast.showToast(message: "Category Deleted successfully",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else{
                print("Api Error")
            }
            
        }
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        
        else {
            searching = true
            searchCatArray = subCatArray.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() }
        }
        tableview.reloadData()
        
        if tableview.visibleCells.isEmpty {
            
            noDataLbl.isHidden = false
            addBtnData.isHidden = false
            addLblView.isHidden = false
            tableview.isHidden = true
            addBtnData.setImage(UIImage(named: "No Data"), for: .normal)
            noDataLbl.text = "No Categories Found"
        }
        else {
            
            noDataLbl.isHidden = true
            addBtnData.isHidden = true
            addLblView.isHidden = true
            tableview.isHidden = false
        }
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_category") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            if sender.currentImage == UIImage(named: "add_blue") {
                
                titletext = "Add Category"
                addtitle = "Add"
                performSegue(withIdentifier: "toAddFromCategory", sender: nil)
            }
        }
    }
    
    
    
    @IBAction func deleteClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_category") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let id = String(sender.tag)
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                print("Ok button tapped")
                
                self.tableview.isHidden = true
                self.loadingIndicator.isAnimating = true
                self.setupDeleteCategory(id: id)
                
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toAddFromCategory" {
            
            let vc = segue.destination as! AddViewController
            vc.titleText =  titletext
            vc.addTitleText = addtitle
            vc.cat_id = cat_id
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

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchCatArray.count
        }
        
        else {
            return categoryList.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
            
            let name = searchCatArray[indexPath.row].title
            cell.inventCategoryName.text = name
            
            cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            
            cell.borderView.layer.borderWidth = 1.0
            cell.borderView.layer.cornerRadius = 10
            
            if name == "Quickadd" {
                cell.highlight.isHidden = true
            }
            else {
                cell.highlight.isHidden = false
            }
            
            cell.highlight.tag = Int(searchCatArray[indexPath.row].id) ?? 0
            
            return cell
        }
        
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
            
            let name = categoryList[indexPath.row].title
            cell.inventCategoryName.text = name
            
            cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            
            cell.borderView.layer.borderWidth = 1.0
            cell.borderView.layer.cornerRadius = 10
            
            if name == "Quickadd" {
                cell.highlight.isHidden = true
            }
            else {
                cell.highlight.isHidden = false
            }
            
            cell.highlight.tag = Int(categoryList[indexPath.row].id) ?? 0

            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if UserDefaults.standard.bool(forKey: "lock_edit_category") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
         
            if searching {
                
                cat_id = searchCatArray[indexPath.row].id
            }
            
            else {
                
                cat_id = categoryList[indexPath.row].id
            }
            titletext = "Edit Category"
            addtitle = "Update"
            
            performSegue(withIdentifier: "toAddFromCategory", sender: nil)
        }
    }
}

struct InventoryCategory {
    
    let id: String
    let title: String
    let description: String
    let categoryBanner: String
    let show_online: String
    let show_status: String
    let cat_show_status: String //3 = all uncheck, 0 = all check, 2 = reg, 1 = online
    let is_lottery: String
    let alternateName: String
    let merchant_id: String
    let is_deleted: String
    let user_id: String
    let created_on: String
    let updated_on: String
    let admin_id: String
    let use_point: String
    let earn_point: String
}


