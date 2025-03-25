//
//  TagsViewController.swift
//
//
//  Created by Jamaluddin Syed on 12/07/24.
//

import UIKit

class TagsViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noTagLbl: UILabel!
    @IBOutlet weak var clickLbl: UILabel!
    
    @IBOutlet weak var floatAddBtn: UIButton!
    
    
    @IBOutlet weak var noDataVIew: UIView!
    
    var tags = [BrandsTags]()
    var subTags = [BrandsTags]()
    var searchTags = [BrandsTags]()
    
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
        
        tableview.showsVerticalScrollIndicator = false
        
        if UserDefaults.standard.bool(forKey: "lock_manage_tags") {
            noDataVIew.isHidden = false
            addView.isHidden = true
            floatAddBtn.isHidden = true
            addBtn.setImage(UIImage(named: ""), for: .normal)
            addBtn.isHidden = true
            noTagLbl.isHidden = true
            clickLbl.isHidden = true
            tableview.isHidden = true
            
        }
        else {
            setupUI()
            noDataVIew.isHidden = true
            setupApi()
        }
        
    }
    
    func setupApi() {
        
        addView.isHidden = true
        floatAddBtn.isHidden = true
        addBtn.isHidden = true
        noTagLbl.isHidden = true
        clickLbl.isHidden = true
        
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let type = "0"
        
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
        
        var smalltags = [BrandsTags]()
        
        for brands in res {
            
            let brandTag = BrandsTags(id: "\(brands["id"] ?? "")", title: "\(brands["title"] ?? "")",
                                      type: "\(brands["type"] ?? "")",
                                      merchant_id: "\(brands["merchant_id"] ?? "")",
                                      updated_on: "\(brands["updated_on"] ?? "")")
            
            smalltags.append(brandTag)
        }
        
        tags = smalltags
        subTags = smalltags
        
        if tags.count == 0 {
            addView.isHidden = false
            floatAddBtn.isHidden = true
            addBtn.isHidden = false
            noTagLbl.isHidden = false
            clickLbl.isHidden = false
            tableview.isHidden = true
        }
        else {
            addView.isHidden = true
            floatAddBtn.isHidden = false
            addBtn.isHidden = true
            noTagLbl.isHidden = true
            clickLbl.isHidden = true
            tableview.isHidden = false
        }
        
        addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
        clickLbl.text = "Click On + To Add Brand"
        noTagLbl.text = "No Tags Added"
        
        loadingIndicator.isAnimating = false
        tableview.reloadData()
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "addbrandtag") as! AddBrandTagViewController
        
        vc.clickMode = "tagsScreen"
        vc.tags = self
        vc.type = "0"
        vc.mode = "add"
        
        present(vc, animated: true)
    }
    
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        let t_id = tags[sender.tag].id
        let t_title = tags[sender.tag].title
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this tag?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
        }
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            self.loadingIndicator.isAnimating = true
            self.tableview.isHidden = true
            self.setupDeleteTags(t_id: t_id, title: t_title)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func setupDeleteTags(t_id: String, title: String) {
        
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.brandsTagsDelete(merchant_id: m_id, type: "0", id: t_id, title: title) { isSuccess, responseData in
            
            if isSuccess {
                
                ToastClass.sharedToast.showToast(message: "Tag Deleted successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
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
            
            searchTags = subTags.filter { $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
        }
        tableview.reloadData()
        
        if tableview.visibleCells.isEmpty {
            
            tableview.isHidden = true
            addView.isHidden = false
            addBtn.isHidden = false
            noTagLbl.isHidden = false
            clickLbl.isHidden = false
            
            addBtn.setImage(UIImage(named: "No Data"), for: .normal)
            noTagLbl.text = "No Tags Found"
            clickLbl.text = ""
        }
        else {
            tableview.isHidden = false
            addView.isHidden = true
            addBtn.isHidden = true
            noTagLbl.isHidden = true
            clickLbl.isHidden = true
            
            addBtn.setImage(UIImage(named: "add_blue"), for: .normal)
            noTagLbl.text = "No Tags Found"
            clickLbl.text = "Click On + To Add Tag"
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

extension TagsViewController: BrandTagDelegate {
    
    func callBrandTagApi() {
        
        setupApi()
    }
}

extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchTags.count
        }
        else {
            return tags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        
        if searching {
            cell.inventCategoryName.text = searchTags[indexPath.row].title
        }
        else {
            cell.inventCategoryName.text = tags[indexPath.row].title
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
            let tags_id = tags[indexPath.row].id
            vc.id = tags_id
            let tags_old = tags[indexPath.row].title
            vc.old = tags_old
        }
        else {
            let tags_id = tags[indexPath.row].id
            vc.id = tags_id
            let tags_old = tags[indexPath.row].title
            vc.old = tags_old
        }
        
        vc.clickMode = "tagsScreen"
        vc.tags = self
        vc.type = "0"
        vc.mode = "edit"
        
        present(vc, animated: true)
    }
}
