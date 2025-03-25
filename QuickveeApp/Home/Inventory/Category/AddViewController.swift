//
//  AddViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/6/23.
//

import UIKit
import MaterialComponents

class AddViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var titleField: MDCOutlinedTextField!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var descField: MDCOutlinedTextField!
    
    @IBOutlet weak var addTitle: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var addPanel: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    
    let updateArray = ["Register", "Online", "Use Points", "Earn Points", "Lottery"]
    let addArray = ["Use Points", "Earn Points", "Lottery"]
    
    var inventCategory: InventoryCategory?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var titleText = ""
    var addTitleText = ""
    var cat_id = ""
    
    var coll_id = ""
    var cat_status = ""
    var use = ""
    var earn = ""
    var lottery = ""
    
    var isReg = false
    var isOnline = false
    var isUse = false
    var isEarn = false
    var isLottery = false
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.label.text = "Title"
        descField.label.text = "Description"
        
        titleField.autocapitalizationType = .words
        descField.autocapitalizationType = .sentences
        
        cancelBtn.setTitle("Cancel", for: .normal)
        addBtn.setTitle(addTitleText, for: .normal)
        
        cancelBtn.layer.cornerRadius = 10
        addBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.backgroundColor = .white
        cancelBtn.setTitleColor(.black, for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = UIColor.black
        
        addPanel.addBottomShadow()
        
        createCustomTextField(textField: titleField)
        createCustomTextField(textField: descField)
        titleField.delegate = self
        descField.delegate = self
        
        titleField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        descField.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        addTitle.text = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupUI()
        
        
        if addTitleText == "Update" {
            collHeight.constant = 64 * 3
            
            setupApi()
        }
        else {
            collHeight.constant = 64 * 2
            
            titleField.text = ""
            descField.text = ""
            coll_id = ""
            cat_status = ""
            
            isUse = false
            isEarn = false
            isLottery = false
            
            coverView.isHidden = true
        }
    }
    
    func setupApi() {
        
        ApiCalls.sharedCall.categoryListById(id: cat_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["category_data"] else {
                    return
                }
                
                self.getResponseValuesById(category: list)
                
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValuesById(category: Any) {
        
        let response = category as! [String:Any]
        
        let category = InventoryCategory(id: "\(response["id"] ?? "")", title: "\(response["title"] ?? "")",
                                         description: "\(response["description"] ?? "")", categoryBanner: "\(response["categoryBanner"] ?? "")",
                                         show_online: "\(response["show_online"] ?? "")", show_status: "\(response["show_status"] ?? "")",
                                         cat_show_status: "\(response["cat_show_status"] ?? "")", is_lottery: "\(response["is_lottery"] ?? "")",
                                         alternateName: "\(response["alternateName"] ?? "")",
                                         merchant_id: "\(response["merchant_id"] ?? "")", is_deleted: "\(response["is_deleted"] ?? "")",
                                         user_id: "\(response["user_id"] ?? "")", created_on: "\(response["created_on"] ?? "")",
                                         updated_on: "\(response["updated_on"] ?? "")", admin_id: "\(response["admin_id"] ?? "")",
                                         use_point: "\(response["use_point"] ?? "")", earn_point: "\(response["earn_point"] ?? "")")
        
        inventCategory = category
        
        let name = inventCategory?.title
        
        if name == "Quickadd" {
            coverView.isHidden = false
            collHeight.constant = 64 * 2
        }
        else {
            coverView.isHidden = true
        }
        titleField.text = name
        
        descField.text = inventCategory?.description
        coll_id = inventCategory?.id ?? ""
        
        cat_status = inventCategory?.cat_show_status ?? ""
        use = inventCategory?.use_point ?? ""
        earn = inventCategory?.earn_point ?? ""
        lottery = inventCategory?.is_lottery ?? ""
        
        //3 = all uncheck, 0 = all check, 2 = reg, 1 = online
        
        if cat_status == "0" {
            isReg = true
            isOnline = true
        }
        else if cat_status == "1" {
            isReg = false
            isOnline = true
        }
        else if cat_status == "2" {
            isReg = true
            isOnline = false
        }
        else {
            isReg = false
            isOnline = false
        }
        
        if use == "1" {
            isUse = true
        }
        else {
            isUse = false
        }
        
        if earn == "1" {
            isEarn = true
        }
        else {
            isEarn = false
        }
        
        if lottery == "1" {
            isLottery = true
        }
        else {
            isLottery = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == titleField {
            activeTextField = textField
            
        }else {
            activeTextField = descField
        }
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if updatetext.count > 50 {
            updatetext = String(updatetext.dropLast())
        }
        activeTextField.text = updatetext
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_disable_category") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            
            let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            
            guard let title = titleField.text, title != "" else {
                titleField.isError(numberOfShakes: 3, revert: true)
                ToastClass.sharedToast.showToast(message: "Enter title", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                return
            }
            
            guard let desc = descField.text else {
                descField.isError(numberOfShakes: 3, revert: true)
                return
            }
            
            loadingIndicator.isAnimating = true
            //3 = all uncheck, 0 = all check, 2 = reg, 1 = online
            var cat_send = ""
            var use_send = ""
            var earn_send = ""
            var lottery_send = ""
            
            if addTitleText == "Update" {
                
                if isReg && isOnline {
                    cat_send = "0"
                }
                
                else if isReg {
                    cat_send = "2"
                }
                
                else if isOnline {
                    cat_send = "1"
                }
                
                else {
                    cat_send = "3"
                }
                
                if isLottery {
                    lottery_send = "1"
                }
                else {
                    lottery_send = "0"
                }
            }
            
            //add
            else {
                
                if isLottery {
                    lottery_send = "1"
                    cat_send = "2"
                }
                else {
                    lottery_send = "0"
                    cat_send = "0"
                }
            }
            
            if isUse {
                use_send = "1"
            }
            
            else {
                use_send = "0"
            }
            
            if isEarn {
                earn_send = "1"
            }
            
            else {
                earn_send = "0"
            }
            
            ApiCalls.sharedCall.addCategoryCall(title: title, description: desc, merchant_id: merchant_id,
                                                admin_id: merchant_id, collId: coll_id,
                                                cat_show_status: cat_send, use_point: use_send,
                                                earn_point: earn_send, is_lottery: lottery_send) { isSuccess, responseData in
                
                
                if isSuccess {
                    if let list = responseData["update_message"] as? String {
                        if self.titleText == "Add Category" {
                            if  list == "Category Created" {
                                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                self.loadingIndicator.isAnimating = false
                                self.goBack()
                                
                            }else if list == "Category title already exist." {
                                ToastClass.sharedToast.showToast(message: "Category already exists", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                self.loadingIndicator.isAnimating = false
                            }
                        }
                        
                        else {
                            
                            if  list == "Category updated" {
                                ToastClass.sharedToast.showToast(message: list, font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                                self.loadingIndicator.isAnimating = false
                                self.goBack()
                            }else if list == "Category title already exist." {
                                ToastClass.sharedToast.showToast(message: "Category already exists", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            }
                        }
                    }
                }
                else {
                    print("API Error")
                }
            }
        }
    }
    
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        goBack()
    }
}

extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if addTitleText == "Update" {
            updateArray.count
        }
        
        else {
            addArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmpSetCollectionViewCell
        
        if addTitleText == "Update" {
            
            cell.setEmpLbl.text = updateArray[indexPath.row]
            
            if indexPath.row == 0 {
                
                if isReg {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                cell.setEmpLbl.textColor = .black
            }
            
            else if indexPath.row == 1 {
                
                if isLottery {
                    cell.setEmpLbl.textColor = .white
                    cell.setEmpImg.image = UIImage()
                }
                else {
                    if isOnline {
                        cell.setEmpImg.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    }
                    cell.setEmpLbl.textColor = .black
                }
            }
            
            else if indexPath.row == 2 {
                
                if isUse {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                cell.setEmpLbl.textColor = .black
            }
            
            else if indexPath.row == 3 {
                
                if isLottery {
                    cell.setEmpLbl.textColor = .white
                    cell.setEmpImg.image = UIImage()
                }
                else {
                    if isEarn {
                        cell.setEmpImg.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    }
                    cell.setEmpLbl.textColor = .black
                }
            }
            
            else if indexPath.row == 4 {
                
                if isLottery {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                cell.setEmpLbl.textColor = .black
            }
        }
        
        else {
            
            cell.setEmpLbl.text = addArray[indexPath.row]
            
            if indexPath.row == 0 {
                
                if isUse {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                cell.setEmpLbl.textColor = .black
            }
            
            else if indexPath.row == 1 {
                
                if isLottery {
                    cell.setEmpLbl.textColor = .white
                    cell.setEmpImg.image = UIImage()
                }
                else {
                    if isEarn {
                        cell.setEmpImg.image = UIImage(named: "check inventory")
                    }
                    else {
                        cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    }
                    cell.setEmpLbl.textColor = .black
                }
            }
            
            else if indexPath.row == 2 {
                
                if isLottery {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                }
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                }
                cell.setEmpLbl.textColor = .black
            }
        }
        return cell
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collection.cellForItem(at: indexPath) as! EmpSetCollectionViewCell
        
        if addTitleText == "Update" {
            
            if indexPath.row == 0 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isReg = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isReg = false
                }
            }
            
            else if indexPath.row == 1 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isOnline = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isOnline = false
                }
            }
            
            else if indexPath.row == 2 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isUse = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isUse = false
                }
            }
            
            else if indexPath.row == 3 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isEarn = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isEarn = false
                }
            }
            
            else if indexPath.row == 4 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isLottery = true
                    isEarn = false
                    isOnline = false
                    collection.reloadData()
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isLottery = false
                    collection.reloadData()
                }
            }
        }
        
        else {
            
            if indexPath.row == 0 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isUse = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isUse = false
                }
            }
            
            else if indexPath.row == 1 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isEarn = true
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isEarn = false
                }
            }
            
            else if indexPath.row == 2 {
                
                if cell.setEmpImg.image == UIImage(named: "uncheck inventory") {
                    cell.setEmpImg.image = UIImage(named: "check inventory")
                    isLottery = true
                    isEarn = false
                    collection.reloadData()
                }
                
                else {
                    cell.setEmpImg.image = UIImage(named: "uncheck inventory")
                    isLottery = false
                    collection.reloadData()
                }
            }
        }
    }

}

extension AddViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collection.bounds.size.width
        return CGSize(width: width/2 - 10, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AddViewController {
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        
        textField.font = UIFont(name: "Manrope-Bold", size: 16.0)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setOutlineColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .editing)
        textField.setNormalLabelColor(UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0), for: .editing)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        var centre = 25
        if addBtn.currentTitle == "Update" {
            centre = 45
        }
        
        addBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: addBtn.centerXAnchor, constant: CGFloat(centre)),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: addBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}
