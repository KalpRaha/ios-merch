//
//  BrandsTagsViewController.swift
//
//
//  Created by Jamaluddin Syed on 15/07/24.
//

import UIKit

protocol BrandTagDelegate: AnyObject {
    func callBrandTagApi()
}

class BrandsTagsViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var noBrand: UILabel!
    @IBOutlet weak var clickBrand: UILabel!
    
    @IBOutlet weak var floatAddBtn: UIButton!
    
    @IBOutlet weak var noDataView: UIView!
    
    
    var brands = [BrandsTags]()
    var subBrands = [BrandsTags]()
    var searchBrands = [BrandsTags]()
    
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
        
        subBrands = []
        tableview.showsVerticalScrollIndicator = false
        tableview.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "lock_manage_brands") {
            noDataView.isHidden = false
            addView.isHidden = true
            floatAddBtn.isHidden = true
            addBtn.isHidden = true
            noBrand.isHidden = true
            clickBrand.isHidden = true
        }
        else {
            setupUI()
            noDataView.isHidden = true
            setupApi()
        }
    }
    
    func setupApi() {
        
        addView.isHidden = true
        floatAddBtn.isHidden = true
        addBtn.isHidden = true
        noBrand.isHidden = true
        clickBrand.isHidden = true
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let type = "1"
        
        ApiCalls.sharedCall.getBrandsTags(merchant_id: id, type: type) { isSuccess, responseData in
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["data"])
            }
            else {
                self.loadingIndicator.isAnimating = false
                self.tableview.isHidden = false
            }
        }
    }
    
    
    func getResponseValues(response: Any) {
        
        let res = response as! [[String:Any]]
        
        var smallbrand = [BrandsTags]()
        
        for brands in res {
            
            let brandTag = BrandsTags(id: "\(brands["id"] ?? "")", title: "\(brands["title"] ?? "")",
                                      type: "\(brands["type"] ?? "")",
                                      merchant_id: "\(brands["merchant_id"] ?? "")",
                                      updated_on: "\(brands["updated_on"] ?? "")")
            
            smallbrand.append(brandTag)
        }
        
        brands = smallbrand
        subBrands = smallbrand
        
        if brands.count == 0 {
            addView.isHidden = false
            floatAddBtn.isHidden = true
            addBtn.isHidden = false
            noBrand.isHidden = false
            clickBrand.isHidden = false
            tableview.isHidden = true
        }
        else {
            addView.isHidden = true
            floatAddBtn.isHidden = false
            addBtn.isHidden = true
            noBrand.isHidden = true
            clickBrand.isHidden = true
            tableview.isHidden = false
        }
        
        addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
        clickBrand.text = "Click On + To Add Brand"
        noBrand.text = "No Brands Added"
        
        loadingIndicator.isAnimating = false
        tableview.reloadData()
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addbrandtag") as! AddBrandTagViewController
        
        vc.clickMode = "brandsScreen"
        vc.brand = self
        vc.type = "1"
        vc.mode = "add"
        
        present(vc, animated: true)
        
    }
    
    
    
    @IBAction func deleteBtnCick(_ sender: UIButton) {
        
        let b_id = brands[sender.tag].id
        let b_title = brands[sender.tag].title
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this brand?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
        }
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            self.loadingIndicator.isAnimating = true
            self.tableview.isHidden = true
            self.setupDeleteBrand(b_id: b_id, title: b_title)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func setupDeleteBrand(b_id: String, title: String) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.brandsTagsDelete(merchant_id: m_id, type: "1", id: b_id, title: title) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: "Brand Deleted successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.setupApi()
            }
            
            else {
                self.loadingIndicator.isAnimating = false
                self.tableview.isHidden = false
            }
        }
    }
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        else {
            searching = true
            searchBrands = subBrands.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}
        }
        
        tableview.reloadData()
        
        if tableview.visibleCells.isEmpty {
            
            tableview.isHidden = true
            addView.isHidden = false
            noBrand.isHidden = false
            clickBrand.isHidden = false
            addBtn.isHidden = false
            
            addBtn.setImage(UIImage(named: "No Data"), for: .normal)
            noBrand.text = "No Brands Found"
            clickBrand.text = ""
        }
        else {
            tableview.isHidden = false
            addView.isHidden = true
            noBrand.isHidden = true
            addBtn.isHidden = true
            clickBrand.isHidden = true
            
            addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
            noBrand.text = "No Brands Found"
            clickBrand.text = "Click On + To Add Brand"
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

extension BrandsTagsViewController: BrandTagDelegate {
    
    func callBrandTagApi() {
        setupApi()
    }
}



extension BrandsTagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchBrands.count
        }
        else {
            return brands.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        
        if searching {
            cell.inventCategoryName.text = searchBrands[indexPath.row].title
            
        }
        
        else {
            cell.inventCategoryName.text = brands[indexPath.row].title
            
        }
        
        
        cell.borderView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        
        cell.borderView.layer.borderWidth = 1.0
        cell.borderView.layer.cornerRadius = 10
        
        cell.highlight.tag = indexPath.row
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addbrandtag") as! AddBrandTagViewController
        
        if searching {
            
            let brand_id = searchBrands[indexPath.row].id
            vc.id = brand_id
            let brand_old = searchBrands[indexPath.row].title
            vc.old = brand_old
            
        }
        else {
            
            let brand_id = brands[indexPath.row].id
            vc.id = brand_id
            let brand_old = brands[indexPath.row].title
            vc.old = brand_old
        }
        vc.clickMode = "brandsScreen"
        vc.brand = self
        vc.type = "1"
        vc.mode = "edit"
        
        present(vc, animated: true)
    }
}


struct BrandsTags {
    
    let id: String
    let title: String
    let type: String
    let merchant_id: String
    let updated_on: String
}
