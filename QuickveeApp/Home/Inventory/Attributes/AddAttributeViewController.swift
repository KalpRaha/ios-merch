//
//  AddAttributeViewController.swift
//
//
//  Created by Jamaluddin Syed on 10/3/23.
//

import UIKit
import MaterialComponents

class AddAttributeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var attTitle: MDCOutlinedTextField!
    @IBOutlet weak var hoverview: UIView!
    @IBOutlet weak var addTitle: UILabel!
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var activeTextField = UITextField()
    
    var addtitle = ""
    var titletext = ""
    var merchant_id: String?
    var att_id: String?
    var old_title = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoverview.layer.cornerRadius = 10
        hoverview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        attTitle.label.text = "Title"
        attTitle.autocapitalizationType = .words
        
        addTitle.text = titletext
        addBtn.setTitle(addtitle, for: .normal)
        
        createCustomTextField(textField: attTitle)
        
        addBtn.layer.cornerRadius = 10.0
        cancelBtn.layer.cornerRadius = 10.0
        
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        attTitle.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        attTitle.delegate = self
        
        attTitle.text = old_title
        
        
        hoverview.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if updatetext.count > 50 {
            updatetext = String(updatetext.dropLast())
        }
        
        //            else if updatetext.count > 0 {
        //                attTitle.trailingView?.isHidden = true
        //                createCustomTextField(textField: attTitle)
        //            }
        
        
        activeTextField.text = updatetext
        
        
        
    }
    
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        goBack()
    }
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        validateParams()
        
    }
    
    func validateParams() {
        
        guard let title = attTitle.text, title != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Attribute title", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            attTitle.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        //  loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addAttributeCall(merchant_id: merchant_id ?? "", varient_id: att_id ?? "",
                                             title: title, old_title: old_title, admin_id: merchant_id ?? "") { [self] isSuccess, responseData in
            self.loadingIndicator.isAnimating = true
            if isSuccess {
                if let list = responseData["response_message"] as? String {
                    print(list)
                    if titletext == "Add Attribute" {
                        if  list == "variant Created" {
                            ToastClass.sharedToast.showToast(message: "Attribute Created", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.goBack()
                            
                        }
                        else if list == "Varient title already exist." {
                            ToastClass.sharedToast.showToast(message: "Category already exists", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            print("Unknown response message")
                        }
                    }else {
                        if  list == "variant updated" {
                            ToastClass.sharedToast.showToast(message: "Attribute updated", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            self.goBack()
                        }
                        else if list == "Varient title already exist." {
                            ToastClass.sharedToast.showToast(message: "Category already exists", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                            print("Unknown response message")
                        }
                    }
                    
                }
                
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
        var centre = 25
        if addBtn.currentTitle == "Save" {
            centre = 35
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
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 16.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(.black, for: .normal)
        textField.setFloatingLabelColor(.black, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
    
}
