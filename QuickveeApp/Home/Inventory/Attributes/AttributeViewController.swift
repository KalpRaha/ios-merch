//
//  AttributeViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/7/23.
//

import UIKit

class AttributeViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    var attributeList = [InventoryAttribute]()
    var addtitle = ""
    var titletext = ""
    var v_id = ""
    var old = ""
    
    var subAttArray = [InventoryAttribute]()
    var searchAttArray = [InventoryAttribute]()
    var searching = false
    
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
        
        tableview.isHidden = true
        addBtn.isHidden = true
        subAttArray = []
        searching = false
        
        if UserDefaults.standard.bool(forKey: "lock_manage_attributes") {
            noDataView.isHidden = false
            
        }
        else {
            setupUI()
            noDataView.isHidden = true
            loadingIndicator.isAnimating = true
            
            setupAttributeApi()
        }
        
        tableview.showsVerticalScrollIndicator = false
        
    }
    
    
    func setupAttributeApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.attributeListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                
                
                self.getResponseValues(list: list)
                
                DispatchQueue.main.async {
                    self.tableview.isHidden = false
                    self.addBtn.isHidden = false
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
        var smallres = [InventoryAttribute]()
        
        for res in response {
            
            let attribute = InventoryAttribute(id: "\(res["id"] ?? "")", title: "\(res["title"] ?? "")",
                                               show_status: "\(res["show_status"] ?? "")",
                                               alternateName: "\(res["alternateName"] ?? "")",
                                               merchant_id: "\(res["merchant_id"] ?? "")",
                                               admin_id: "\(res["merchant_id"] ?? "")")
            
            smallres.append(attribute)
            
        }
        
        attributeList = smallres
        subAttArray = smallres
    }
    
    func performSearch(searchText: String) {
        print(searchText)
        if searchText == "" {
            searching = false
        }
        
        else {
            searching = true
            print(subAttArray)
            searchAttArray = subAttArray.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}
        }
        tableview.reloadData()
    }
    
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        addtitle = "Add"
        titletext = "Add Attribute"
        v_id = ""
        old = ""
        performSegue(withIdentifier: "toAddAttribute", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! AddAttributeViewController
        vc.addtitle = addtitle
        vc.titletext = titletext
        
        vc.merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        vc.att_id = v_id
        vc.old_title = old
        
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


extension AttributeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchAttArray.count
        }
        
        else {
            return attributeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttributeTableViewCell
            
            cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            cell.borderView.layer.cornerRadius = 7.0
            cell.borderView.layer.borderWidth = 1.0
            cell.attributeName.text = searchAttArray[indexPath.row].title
            
            return cell
        }
        
        else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttributeTableViewCell
            
            cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            cell.borderView.layer.cornerRadius = 7.0
            cell.borderView.layer.borderWidth = 1.0
            cell.attributeName.text = attributeList[indexPath.row].title
            
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
        
        if searching {
            
            let att_title = searchAttArray[indexPath.row].title
            
            let att_id = searchAttArray[indexPath.row].id
            
            addtitle = "Update"
            titletext = "Edit Attribute"
            v_id = att_id
            old = att_title
        }
        
        else {
            
            let att_title = attributeList[indexPath.row].title
            
            let att_id = attributeList[indexPath.row].id
            
            addtitle = "Update"
            titletext = "Edit Attribute"
            v_id = att_id
            old = att_title
        }
        
        performSegue(withIdentifier: "toAddAttribute", sender: nil)
    }
}




struct InventoryAttribute {
    
    let id: String
    let title: String
    let show_status: String
    let alternateName: String
    let merchant_id: String
    let admin_id: String
}
