//
//  PointBalanceDetailVC.swift
//  
//
//  Created by Pallavi on 04/10/24.
//

import UIKit

class PointBalanceDetailVC: UIViewController  {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var pointValueLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    weak var custdelegate: AddRemoveCustDelegate?
    
    weak var pointDelegate: CustomerDelegate?
    var pointValue = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(pointValue)
        let poiytb = pointValue.replacingOccurrences(of: ",", with: "")
        print(pointValue)

        pointValueLbl.text = pointValue

        bgView.layer.cornerRadius = 10
        addBtn.layer.cornerRadius = 5
        removeBtn.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_add_points_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            dismiss(animated: true) {
                self.pointDelegate?.setNavigation(model: 1)
            }
        }
    }
    
 
    
    @IBAction func removeBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_points_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            dismiss(animated: true) {
                self.pointDelegate?.setNavigation(model: 2)
            }
        }
    }
    
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRemoveCust" {
            let vc = segue.destination as! AddRemoveCustViewController
            vc.addRemovePoints = pointValue
        }
    }
}


