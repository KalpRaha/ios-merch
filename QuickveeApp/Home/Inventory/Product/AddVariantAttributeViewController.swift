//
//  AddVariantAttributeViewController.swift
//
//
//  Created by Jamaluddin Syed on 9/28/23.
//

import UIKit
import MaterialComponents
import DropDown

class CustomClass: UITableViewCell {
    
}

class AddVariantAttributeViewController: UIViewController {
 
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var selectAttribute: MDCOutlinedTextField!
    @IBOutlet weak var selectAttBtn: UIButton!
    
    @IBOutlet weak var addCatField: MDCOutlinedTextField!
    @IBOutlet weak var collection: UICollectionView!
    
    var attributeList = [InventoryAttribute]()
    var valueList = [String]()
    var selectedAtt = [InventoryOptions]()
    var attNamesList = [String]()
    
    var editEleArr = [String]()
    
    weak var delegatePlus: PlusAttributeVariant?
    weak var delegateDuplicate: PlusAttributeVariant?
    
    var options: InventoryOptions?
    
    var mode = ""
    var subMode = ""
    var goMode = ""
    
    let menu = DropDown()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBtn.layer.cornerRadius = 8.0
        saveBtn.layer.cornerRadius = 8.0
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        selectAttribute.label.text  = "Select Attribute"
        
        addCatField.autocapitalizationType = .words
        
        createCustomTextField(textField: selectAttribute)
        addCatField.font = UIFont(name: "Manrope-Medium", size: 18.0)
        addCatField.setOutlineColor(.clear, for: .normal)
        addCatField.setOutlineColor(.clear, for: .editing)
        addCatField.autocorrectionType = .no
        
        addCatField.setNormalLabelColor(.lightGray, for: .normal)
        addCatField.setNormalLabelColor(.lightGray, for: .editing)
        addCatField.addTarget(self, action: #selector(updateText), for: .editingChanged)
        addCatField.smartDashesType = .no
        
        addCatField.placeholder = "Enter Variant Name"
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImage(named: "down"), for: .normal)
        selectAttribute.trailingView = button
        selectAttribute.trailingViewMode = .always
        
        let columnLayout = CustomFlowLayout()
        collection.collectionViewLayout = columnLayout
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        addCatField.iq.toolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setUI()
        
        saveBtn.isEnabled = true
        
        if subMode == "add" {
            loadingIndicator.isAnimating = true
            setupApi()
        }
        else {
            if options?.options1 == "" && options?.options2 == "" {
                selectAttribute.text = options?.options3
            }
            else if options?.options2 == "" && options?.options3 == "" {
                selectAttribute.text = options?.options1
            }
            else {
                selectAttribute.text = options?.options2
            }
            
            if options?.optionsvl1 == "" && options?.optionsvl2 == "" {
                valueList = options?.optionsvl3.components(separatedBy: ",") ?? []
            }
            else if options?.optionsvl2 == "" && options?.optionsvl3 == "" {
                valueList = options?.optionsvl1.components(separatedBy: ",") ?? []
            }
            else {
                valueList = options?.optionsvl2.components(separatedBy: ",") ?? []
            }
        }
    }
    
    
    func setupApi() {
        
        let url = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.attributeListCall(merchant_id: url) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    return
                }
                
                self.getResponseValues(list: list)
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
        
        for att in attributeList {
            attNamesList.append(att.title)
        }
        setupMenu()
    }
    
    func setupMenu() {
        
        menu.dataSource = attNamesList
        menu.backgroundColor = .white
        menu.anchorView = selectAttBtn
        menu.separatorColor = .black
        menu.layer.cornerRadius = 10.0
        menu.selectionAction = { index, title in
            
            if self.selectedAtt.contains(where: {$0.options1 == title || $0.options2 == title || $0.options3 == title}) {
                ToastClass.sharedToast.showToast(message: "Attribute already added", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                self.menu.deselectRow(at: index)
            }
            else {
                self.selectAttribute.text = title
                self.menu.deselectRow(at: index)
            }
        }
        loadingIndicator.isAnimating = false
    }
  
    
    @objc func updateText(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        let update = updatetext.last
        
        if update == "," || update == "~"
            || update == "/" || update == "-"
            || update == "\u{005c}" {
            updatetext = String(updatetext.dropLast())
        }
        
        addCatField.text = updatetext
    }
        
    
    @objc func doneAction() {
        
        var cat_name = addCatField.text ?? ""
        cat_name = cat_name.trimmingCharacters(in: .whitespaces)
        
        guard cat_name != "" else {
            return
        }
        let lower = cat_name.lowercased()
        if valueList.contains(where: {$0.lowercased().contains(lower)}) {
            addCatField.text = ""
            ToastClass.sharedToast.showToast(message: "Variant value already added", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            
            if goMode == "plus" {
                
                if mode == "add" {
                    valueList.append(cat_name)
                    collection.reloadData()
                }
                else {
                    valueList.append(cat_name)
                    if valueList.count != 0 {
                        editEleArr.append(cat_name)
                    }
                    collection.reloadData()
                }
            }
            else {
                valueList.append(cat_name)
                collection.reloadData()
            }
            addCatField.text = ""
        }
    }
    
    @IBAction func selectAttBtnClick(_ sender: UIButton) {
        
        menu.show()
    }
  
    @IBAction func btnSave(_ sender: UIButton) {
        
        var attri = selectAttribute.text ?? ""
        attri = attri.trimmingCharacters(in: .whitespaces)
        guard attri != "" else {
            ToastClass.sharedToast.showToast(message: "Select Attribute", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            return
        }
        
        if valueList.count == 0 {
            ToastClass.sharedToast.showToast(message: "Add variant value", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            loadIndicator.isAnimating = true
            sender.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                let attvalue = self.valueList.joined(separator: ",")
                if self.goMode == "plus" {
                    self.delegatePlus?.getAddedAtttributes(optName: attri, optValue: attvalue, newEdit: self.editEleArr)
                }
                else {
                    self.delegateDuplicate?.getAddedAtttributes(optName: attri, optValue: attvalue, newEdit: [])
                }
                self.loadIndicator.isAnimating = false
                self.dismiss(animated: true)
            }
        }
    }
 
    @IBAction func variantcloseClick(_ sender: UIButton) {
        
        if goMode == "plus" {
            
            if mode == "add" {
                valueList.remove(at: sender.tag)
                collection.reloadData()
            }
            
            else {
                editEleArr.removeAll(where: {$0 == valueList[sender.tag]})
                valueList.remove(at: sender.tag)
                collection.reloadData()
            }
        }
        
        else {
            valueList.remove(at: sender.tag)
            collection.reloadData()
        }
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddVariantAttributeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return valueList.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddVarAttributeCell
        let valueEle = valueList[indexPath.row]
        cell.variantLabel.text = valueEle
        
        if goMode == "plus" {
            
            if mode == "add" {
                
                cell.close_btn.isHidden = false
                cell.close_width.constant = 14
            }
            else {
                
                if editEleArr.contains(valueEle) {
                    cell.close_btn.isHidden = false
                    cell.close_width.constant = 14
                }
                else {
                    
                    cell.close_btn.isHidden = true
                    cell.close_width.constant = 0
                }
            }
        }
        
        else {
            
        }
        cell.close_btn.tag = indexPath.item
        cell.contentView.layer.cornerRadius = 5.0
        return cell
    }
}

extension AddVariantAttributeViewController {
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
    
    private func setUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        saveBtn.addSubview(loadIndicator)
        let center = 35
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: saveBtn.centerXAnchor, constant: CGFloat(center)),
            loadIndicator.centerYAnchor
                .constraint(equalTo: saveBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Medium", size: 18.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor( UIColor(named: "Attributeclr")!, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
    
    func dropAttShadow(scale: Bool = true) {
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
    }
    
    func dropShadow2(scale: Bool = true) {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
    }
}
