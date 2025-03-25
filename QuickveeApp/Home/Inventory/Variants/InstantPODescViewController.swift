//
//  InstantPODescViewController.swift
//  
//
//  Created by Jamaluddin Syed on 10/4/23.
//

import UIKit
import MaterialComponents

class InstantPODescViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var descField: UITextField!
    
    var ipoVari_id = ""
    var ipoProd_id = ""
    var ipoIsV = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descField.placeholder = "Description"
        descField.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
        descField.layer.cornerRadius = 10.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        cancelBtn.layer.cornerRadius = 8.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
        nextBtn.layer.cornerRadius = 8.0
        
        hoverView.layer.cornerRadius = 10
        hoverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
      
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
        
        guard let title = descField.text, title != "" else {
            ToastClass.sharedToast.showToast(message: " Enter description", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            return
        }
        performSegue(withIdentifier: "quantityPO", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! POQuantityViewController
        vc.desc = descField.text ?? ""
        vc.descVari_id  = ipoVari_id
        vc.descprod_id = ipoProd_id
        vc.descIsV = ipoIsV
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setFloatingLabelColor(.black, for: .normal)
        textField.setFloatingLabelColor(.black, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
    }
}
