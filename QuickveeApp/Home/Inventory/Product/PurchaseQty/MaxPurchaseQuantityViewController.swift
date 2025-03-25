//
//  MaxPurchaseQuantityViewController.swift
//
//
//  Created by Pallavi on 22/05/24.
//

import UIKit
import MaterialComponents

class MaxPurchaseQuantityViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var purchaseTextFL: MDCOutlinedTextField!
    @IBOutlet weak var selectAllBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    
    
    var maxpurVarientArr = [ProductById]()
    var varient_Select_PurQty = [Purchase]()
    var varient_UnSelect_PurQty = [Purchase]()
    var p_qty = ""
    var single_product = ""
    var varientempty = [String]()
    var varient_purQty = [String]()
    var prod_id = ""
    var product_purchaseQty = ""
    var is_Varient = ""
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseTextFL.label.text = "Name of Deal"
        topView.addBottomShadow()
        createCustomTextField(textField: purchaseTextFL)
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
        doneBtn.layer.cornerRadius = 10
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.reloadData()
        
        purchaseTextFL.text = "Max Quantity per transaction \(p_qty)"
        setupUI()
        
        print("$$\(p_qty)")
        print("%%\(product_purchaseQty)")
        print(varient_Select_PurQty)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if maxpurVarientArr.count == 0 {
            selectAllBtn.isHidden = true
            scrollHeight.constant = 290
        }
        else {
            getQty()
            getSelectePQty()
            selectAllBtn.isHidden = false
            scrollHeight.constant = 230 + CGFloat(60 * varient_UnSelect_PurQty.count)
        }
        
        
    }
    
    func getSelectePQty(){
        var smallPurchase = [Purchase]()
        var selectedP_qty = [String]()
        
        for qty in maxpurVarientArr {
            
            let pur = Purchase(id: qty.id, name: qty.variant, qty: qty.purchase_qty)
            
            if qty.purchase_qty == "<null>" {
                
                smallPurchase.append(pur)
            }
            
        }
        
        //print(smallPurchase)
        varient_UnSelect_PurQty = smallPurchase
    }
    
    
    func getQty(){
        var small = [String]()
        for i in 0..<varient_Select_PurQty.count {
            small.append(varient_Select_PurQty[i].qty)
        }
        varient_purQty = small
        print(varient_purQty)
    }
    
    
    func removeVarientId(id: String) {
        
        for i in  0..<varientempty.count {
            if varientempty[i] == id {
                varientempty.remove(at: i)
                break
            }
        }
    }
    
    @IBAction func selectAllBtnClick(_ sender: UIButton) {
        
        if maxpurVarientArr.count == 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
            
            if selectAllBtn.currentTitle == "Select All" {
                cell.imageCheck.isHidden = false
                cell.imageWidth.constant = 26
                cell.variLable.textColor = UIColor.black
                selectAllBtn.setTitle("Unselect All", for: .normal)
            }else  {
                cell.imageCheck.isHidden = true
                cell.imageWidth.constant = 0
                cell.variLable.textColor = UIColor(named: "varLable")
                selectAllBtn.setTitle("Select All", for: .normal)
            }
        }
        else {
            for i in 0..<varient_UnSelect_PurQty.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
                
                if selectAllBtn.currentTitle == "Select All" {
                    
                    if cell.imageCheck.isHidden == true {
                        cell.imageCheck.isHidden = false
                        cell.imageWidth.constant = 26
                        cell.variLable.textColor = UIColor.black
                        varientempty.append(varient_UnSelect_PurQty[indexPath.row].id)
                        print(varientempty)
                    }
                    else {
                    }
                }
                else {
                    if cell.imageCheck.isHidden{
                        
                    }
                    else {
                        cell.imageCheck.isHidden = true
                        cell.imageWidth.constant = 0
                        cell.variLable.textColor = UIColor(named: "varLbl")
                        let ids = varient_UnSelect_PurQty[indexPath.row].id
                        removeVarientId(id: ids)
                        print(varientempty)
                    }
                }
            }
            if selectAllBtn.currentTitle == "Select All" {
                selectAllBtn.setTitle("Unselect All", for: .normal)
            }
            
            else {
                selectAllBtn.setTitle("Select All", for: .normal)
            }
        }
    }
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        var exe_add = false
        if maxpurVarientArr.count == 0 {
            
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
            if cell.imageCheck.isHidden {
                exe_add = false
                
            }else {
                exe_add = true
            }
        }
        else {
            for i in 0..<varient_UnSelect_PurQty.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
                if cell.imageCheck.isHidden == true {
                    exe_add = false
                }
                else {
                    exe_add = true
                    break
                }
            }
        }
        if exe_add {
            
            if varient_purQty.contains(where: { $0 == p_qty}) {
                ToastClass.sharedToast.showToast(message: "Same Purchase Quantity Exist", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                ApiCall()
            }
        }
        else {
            ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
    }
    
    
    
    func ApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        var empty = ""
        
        if maxpurVarientArr.count == 0 {
            empty = prod_id
        }
        else {
            empty = varientempty.joined(separator: ",")
        }
        
        ApiCalls.sharedCall.addPurchaseQtyApiCall(merchant_id: id, product_id: prod_id, variant_id: empty, is_variant: is_Varient, purchase_qty: p_qty){  isSuccess, responseData in
            
            if isSuccess {
                
                self.loadingIndicator.isAnimating = true
                ToastClass.sharedToast.showToast(message: "Max Purchase Quantity Added Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                let viewcontrollerArray = self.navigationController?.viewControllers
                var destiny = 0
                if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                    destiny = destinationIndex
                }
                self.backBtn.isEnabled = true
                self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
                
            }
            else{
                print("Api Error")
                self.loadIndicator.isAnimating = false
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MaxPurchaseUpdateViewController
        vc.arrofVarient = maxpurVarientArr
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
        
    }
    
    @IBAction func homebtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
        
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 14.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        doneBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: doneBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: doneBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        
        
        tableview.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: tableview.centerXAnchor, constant: 0),
            loadIndicator.centerYAnchor
                .constraint(equalTo: tableview.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
    
    
}
extension MaxPurchaseQuantityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if maxpurVarientArr.count == 0 {
            return 1
        }
        else {
            return varient_UnSelect_PurQty.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "BulkTableViewCell", for: indexPath)as! BulkTableViewCell
        cell.imageWidth.constant = 0
        cell.selectionStyle = .none
        
        if maxpurVarientArr.count == 0 {
            cell.variLable.text = single_product
        }
        else {
            cell.variLable.text = varient_UnSelect_PurQty[indexPath.row].name
            
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableview.cellForRow(at: indexPath) as! BulkTableViewCell
        tableview.deselectRow(at: indexPath, animated: true)
        
        if cell.imageCheck.isHidden  {
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLable.textColor = UIColor.black
            if maxpurVarientArr.count > 0 {
                varientempty.append(varient_UnSelect_PurQty[indexPath.row].id)
            }
            
        }
        else {
            cell.imageCheck.isHidden = true
            cell.imageWidth.constant = 0
            cell.variLable.textColor = UIColor(named: "varLbl")
            
            if maxpurVarientArr.count > 0 {
                let id = varient_UnSelect_PurQty[indexPath.row].id
                removeVarientId(id: id)
            }
            print(varientempty)
        }
    }
}
