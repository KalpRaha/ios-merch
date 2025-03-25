//
//  SelectCouponTypeViewController.swift
//  
//
//  Created by Jamaluddin Syed on 30/07/24.
//

import UIKit

class SelectCouponTypeViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var orderlevelBtn: UIButton!
    @IBOutlet weak var catlevelBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUI()
    }
    

    func setUI() {
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        orderlevelBtn.layer.cornerRadius = 10
        orderlevelBtn.layer.borderWidth = 1
        orderlevelBtn.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
        
        catlevelBtn.layer.cornerRadius = 10
        catlevelBtn.layer.borderWidth = 1
        catlevelBtn.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
        
        
        nextBtn.layer.cornerRadius = 10
        bgView.layer.cornerRadius = 10
        
    }
 
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
      
//        if orderlevelBtn.titleLabel?.textColor == UIColor(named: "SelectCat") {
//            navMode?.selectNavigation(mode: "order")
//            dismiss(animated: true)
//        }
//        else  if catlevelBtn.titleLabel?.textColor == UIColor(named: "SelectCat") {
//            navMode?.selectNavigation(mode: "category")
//            dismiss(animated: true)
//        }else {
//            showToastMedium(message: "Select Coupon Level", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
//        }
    }
   
    
    
    @IBAction func orderClick(_ sender: UIButton) {
        orderlevelBtn.layer.cornerRadius = 10
        orderlevelBtn.layer.borderWidth = 1
        orderlevelBtn.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
        orderlevelBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
        catlevelBtn.layer.cornerRadius = 10
        catlevelBtn.layer.borderWidth = 1
        catlevelBtn.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
        catlevelBtn.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    
    @IBAction func catClick(_ sender: UIButton) {
        catlevelBtn.layer.cornerRadius = 10
        catlevelBtn.layer.borderWidth = 1
        catlevelBtn.layer.borderColor = UIColor(named: "SelectCat")?.cgColor
        catlevelBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
        orderlevelBtn.layer.cornerRadius = 10
        orderlevelBtn.layer.borderWidth = 1
        orderlevelBtn.layer.borderColor = UIColor(named: "CategoryBorder")?.cgColor
        orderlevelBtn.setTitleColor(UIColor.black, for: .normal)
    }
}

