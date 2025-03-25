//
//  AddBrandTagViewController.swift
//  
//
//  Created by Jamaluddin Syed on 17/07/24.
//

import UIKit

class AddBrandTagViewController: UIViewController {
    
    
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    weak var brand: BrandTagDelegate?
    weak var tags: BrandTagDelegate?
    
    weak var brandFilter: BrandsTagsAddDelegate?
    weak var tagFilter: BrandsTagsAddDelegate?
    
    var type = ""
    var id = ""
    var old = ""
    var mode = ""
    
    var clickMode = ""
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        saveBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        hoverView.layer.cornerRadius = 10
        hoverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        nameField.layer.borderColor = UIColor(named: "borderColor")!.cgColor
        nameField.layer.borderWidth = 1.0
        nameField.autocapitalizationType = .words
        
        nameField.addTarget(self, action: #selector(updateText), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == "add" {
            saveBtn.setTitle("Add", for: .normal)
            
            if type == "1" {
                addLabel.text = "Add Brand"
                typeLbl.text = "Brand"
            }
            else {
                addLabel.text = "Add Tag"
                typeLbl.text = "Tag"
            }
            
            if clickMode == "filter" {
                nameField.text = old
            }
            else {
                nameField.text = ""
            }
        }
        
        else {
            saveBtn.setTitle("Update", for: .normal)
            
            if type == "1" {
                addLabel.text = "Update Brand"
                typeLbl.text = "Brand"
            }
            else {
                addLabel.text = "Update Tag"
                typeLbl.text = "Tag"
            }
            nameField.text = old
        }
    }
    
    @objc func updateText(textField: UITextField) {
        
        var updatetext = textField.text ?? ""
        
        let update = updatetext.last
        
        if update == "," {
            updatetext = String(updatetext.dropLast())
        }
        
        if updatetext.count > 35 {
            updatetext = String(updatetext.dropLast())
        }
        
        nameField.text = updatetext
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
    
        let m_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        if mode == "add" {
            
            guard let name = nameField.text, name != "" else {
                
                nameField.isErrorView(numberOfShakes: 3, revert: true)
                return
            }
            
            loadIndicator.isAnimating = true
            
            ApiCalls.sharedCall.brandsTagsAdd(merchant_id: m_id, type: type, title: name) { isSuccess, responseData in
                
                if isSuccess {
                    
                    self.loadIndicator.isAnimating = false
                    if self.type == "1" {
                        
                        let msg = responseData["message"] ?? ""
                        
                        if msg as! String == "Name Already Exists" {
                            ToastClass.sharedToast.showToast(message: "Brand \(msg)", 
                                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        }
                        else {
                            ToastClass.sharedToast.showToast(message: "Brand Added Successfully", 
                                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                            
                            if self.clickMode == "filter" {
                                self.brandFilter?.callBrandTagFilter(brandtag: name)
                            }
                            else {
                                self.brand?.callBrandTagApi()
                            }
                            self.dismiss(animated: true)
                        }
                    }
                    else {
                        
                        let msg = responseData["message"] ?? ""
                        
                        if msg as! String == "Name Already Exists" {
                            ToastClass.sharedToast.showToast(message: "Tag \(msg)", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        }
                        else {
                            ToastClass.sharedToast.showToast(message: "Tag Added Successfully", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                            if self.clickMode == "filter" {
                                self.tagFilter?.callBrandTagFilter(brandtag: name)
                            }
                            else {
                                self.tags?.callBrandTagApi()
                            }
                            self.dismiss(animated: true)
                        }
                    }
                }
                
                else {
                    self.loadIndicator.isAnimating = false
                }
            }
        }
        
        else {
            
            guard let name = nameField.text, name != "" else {
                
                nameField.isErrorView(numberOfShakes: 3, revert: true)
                return
            }
            
            loadIndicator.isAnimating = true
            
            ApiCalls.sharedCall.brandsTagsUpdate(merchant_id: m_id, title: name,
                                                 type: type, id: id, old_title: old)
                                                 { isSuccess, responseData in
                
                if isSuccess {
                    
                    self.loadIndicator.isAnimating = false
                    if self.type == "1" {
                        ToastClass.sharedToast.showToast(message: "Brand Updated Successfully",
                                            font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        self.brand?.callBrandTagApi()
                    }
                    else {
                        ToastClass.sharedToast.showToast(message: "Tag Updated Successfully", 
                                            font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
                        self.tags?.callBrandTagApi()
                    }
                    self.dismiss(animated: true)
                }
                
                else {
                    self.loadIndicator.isAnimating = false
                }
            }
        }
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        saveBtn.addSubview(loadIndicator)
        var center = 40
        if mode == "add" {
            center = 30
        }
        
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
}
