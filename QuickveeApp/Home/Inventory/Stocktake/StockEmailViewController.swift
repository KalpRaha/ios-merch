//
//  StockEmailViewController.swift
//  
//
//  Created by Jamaluddin Syed on 10/01/25.
//

import UIKit

class StockEmailViewController: UIViewController {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailBtn: UIButton!
    
    
    var email_body = ""
    var email_subject = ""
    var email_to = ""
    var email_name = ""
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelBtn.layer.cornerRadius = 10
        sendBtn.layer.cornerRadius = 10
        
        emailView.layer.cornerRadius = 10
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.borderWidth = 1.0
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        
        loadIndicator.isAnimating = true
        
        guard let mail = emailText.text, mail != "" else {
            emailText.isErrorView(numberOfShakes: 1, revert: true)
            loadIndicator.isAnimating = false
            return
        }
        
        
        
        
        ApiCalls.sharedCall.stockEmail(email_subject: email_subject,
                                       email_body: email_body, email_to: mail,
                                       name: email_name) { isSuccess, responseData in
            
            if isSuccess {
                
                self.loadIndicator.isAnimating = false
                self.dismiss(animated: true)
                ToastClass.sharedToast.showToast(message: "Email Sent", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                self.loadIndicator.isAnimating = false
                self.dismiss(animated: true)
                ToastClass.sharedToast.showToast(message: "Email Sending Failed", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
        }
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        emailBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: emailBtn.centerXAnchor, constant: 30),
            loadIndicator.centerYAnchor
                .constraint(equalTo: emailBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}
