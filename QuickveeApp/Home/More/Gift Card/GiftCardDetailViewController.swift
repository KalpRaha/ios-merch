//
//  GiftCardDetailViewController.swift
//
//
//  Created by Pallavi on 31/07/24.
//

import UIKit

class GiftCardDetailViewController: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    
    weak var nav: giftCardDelegate?
    var price = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    func setUI() {
        
        bgImage.layer.cornerRadius = 10
        bgView.layer.cornerRadius = 10
        
        addBtn.layer.cornerRadius = 10
        removeBtn.layer.cornerRadius = 10
        priceLbl.text = "$\(price)"
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_gift") {
            addBtn.isUserInteractionEnabled = false
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            UserDefaults.standard.set(1, forKey: "modal_screen")
            dismiss(animated: true) {
                self.nav?.setnavigation()
            }
        }
    }
    
    @IBAction func removeBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_remove_gift") {
            removeBtn.isUserInteractionEnabled = false
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            UserDefaults.standard.set(2, forKey: "modal_screen")
            dismiss(animated: true) {
                self.nav?.setnavigation()
            }
        }
    }
}
