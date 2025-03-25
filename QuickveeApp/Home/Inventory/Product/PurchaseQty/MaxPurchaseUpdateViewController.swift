//
//  MaxPurchaseUpdateViewController.swift
//
//
//  Created by Pallavi on 24/05/24.
//

import UIKit
import MaterialComponents

class MaxPurchaseUpdateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var PurchaseDealTextfield: MDCOutlinedTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var qtyTextFeld: MDCOutlinedTextField!
    
    @IBOutlet weak var scrollHeightConstant: NSLayoutConstraint!
    
    var arrofVarient = [ProductById]()
    var single_prod_title = ""
    var arrPurchaseQty = [Purchase]()
    var dealText = ""
    var selected_qty = ""
    var is_Varient = ""
    var product_id = ""
    // var purchase_qty = ""
    var prodSelect = true
    var isProd = false
    
    
    var selectEmpty = [String]()
    var activeTextField = UITextField()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
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
        
        
        createCustomTextField(textField: PurchaseDealTextfield)
        PurchaseDealTextfield.label.text = "Name"
        
        createCustomTextField(textField: qtyTextFeld)
        qtyTextFeld.label.text = "Quantity"
        qtyTextFeld.delegate = self
        
        
        deletBtn.layer.borderWidth = 1
        deletBtn.layer.borderColor =  UIColor(named: "deletBorder")?.cgColor
        deletBtn.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        PurchaseDealTextfield.delegate = self
        qtyTextFeld.keyboardType = .numberPad
        
        setupUI()
        qtyTextFeld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        qtyTextFeld.addTarget(self, action: #selector(updateTextField), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PurchaseDealTextfield.text = "Max Quantity per transaction \(selected_qty)"  //dealText
        qtyTextFeld.text = selected_qty
        
        
        if arrofVarient.count == 0 {
            scrollHeightConstant.constant = 310
        }
        else
        {
            getSelectePQtyid()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        PurchaseDealTextfield.text = "Max Quantity per transaction \(textField.text ?? "")"
    }
    
    func getSelectePQtyid(){
        
        var smallEmpty = [String]()
        
        for qty in arrofVarient {
            
            let pur = Purchase(id: qty.id, name: qty.variant, qty: qty.purchase_qty)
            
            if qty.purchase_qty == selected_qty {
                smallEmpty.append(pur.id)
            }
        }
        print(smallEmpty)
        selectEmpty = smallEmpty
        
        var smallPurchase = [Purchase]()
        
        for qty in arrofVarient {
            
            let pur = Purchase(id: qty.id, name: qty.variant, qty: qty.purchase_qty)
            
            if qty.purchase_qty == "<null>" || qty.purchase_qty == selected_qty {
                smallPurchase.append(pur)
            }
            
        }
        print(smallPurchase)
        
        arrPurchaseQty = smallPurchase
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollHeightConstant.constant = 290 + CGFloat(60 * self.arrPurchaseQty.count)
        }
    }
    
    
    func removeVarientId(id: String) {
        
        for i in  0..<selectEmpty.count {
            if selectEmpty[i] == id {
                selectEmpty.remove(at: i)
                break
            }
            
        }
    }
    
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
        textField.font = UIFont(name: "Manrope-Bold", size: 12.0)
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.lightGray, for: .editing)
        textField.setNormalLabelColor(.lightGray, for: .normal)
        textField.setNormalLabelColor(.lightGray, for: .editing)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .normal)
        textField.setOutlineColor(UIColor(named: "borderColor")!, for: .editing)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .normal)
        textField.setFloatingLabelColor(UIColor(named: "Attributeclr")!, for: .editing)
    }
    
    
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeClick(_ sender: Any) {
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 4
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    @IBAction func deletBtnClick(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this deal?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
            // self.backBtn.isEnabled = false
            self.loadingIndicator.isAnimating = true
            self.deletApiCall()
            
        }
        
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func updateBtnClick(_ sender: UIButton) {
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        guard let name = PurchaseDealTextfield.text, name != "" else {
            ToastClass.sharedToast.showToast(message: "Enter Deal name", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            PurchaseDealTextfield.isError(numberOfShakes: 3, revert: true)
            return
        }
        
        var empty = ""
        var qty = ""
        if qtyTextFeld.text != "" {
            qty = qtyTextFeld.text ?? ""
        }
        else{
            qty = selected_qty
        }
        
        if arrofVarient.count == 0 {
            if prodSelect {
                empty = product_id
                updateApiCall(id: id, product_id: product_id, empty: empty, is_variant: is_Varient, purchase_qty: qty)
            }else {
                ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
        }
        else {
            
            if selectEmpty.count == 0{
                ToastClass.sharedToast.showToast(message: "Select Varient", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                empty = selectEmpty.joined(separator: ",")
                updateApiCall(id: id, product_id: product_id, empty: empty, is_variant: is_Varient, purchase_qty: qty)
            }
        }
        
    }
    
    func updateApiCall(id: String, product_id: String, empty: String, is_variant: String, purchase_qty: String) {
        
        
        self.loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.addPurchaseQtyApiCall(merchant_id: id, product_id: product_id, variant_id: empty, is_variant: is_Varient, purchase_qty: purchase_qty) { isSuccess, responseData in
            
            if isSuccess {
                ToastClass.sharedToast.showToast(message: "Max Purchase Qty Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                    self.loadIndicator.isAnimating = false
                    
                    let viewcontrollerArray = self.navigationController?.viewControllers
                    var destiny = 0
                    
                    if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                        destiny = destinationIndex
                    }
                    // self.backBtn.isEnabled = true
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            }
            else{
                print("Api Error")
                self.loadIndicator.isAnimating = false
                
            }
        }
        
    }
    
    
    
    func deletApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        var purQty = ""
        var empty = ""
        
        if arrofVarient.count == 0 {
            purQty = "0"
        }
        else {
            purQty = selected_qty
            
        }
        
        
        ApiCalls.sharedCall.addPurchaseQtyApiCall(merchant_id: id, product_id: product_id, variant_id: "" , is_variant: is_Varient, purchase_qty: purQty ) { isSuccess, responseData in
            
            if isSuccess {
                
                ToastClass.sharedToast.showToast(message: "Max Purchase Qty deleted Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
                    self.loadingIndicator.isAnimating = false
                    
                    let viewcontrollerArray = self.navigationController?.viewControllers
                    var destiny = 0
                    
                    if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is PlusViewController }) {
                        destiny = destinationIndex
                    }
                    // self.backBtn.isEnabled = true
                    self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
            }
            else{
                print("Api Error")
                //self.loadIndicator.isAnimating = false
                
            }
        }
    }
}

extension MaxPurchaseUpdateViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == qtyTextFeld {
            activeTextField = qtyTextFeld
        }
    }
    
    
    @objc func updateTextField(textField: MDCOutlinedTextField) {
        
        var updatetext = textField.text ?? ""
        
        if updatetext.count > 6 {
            updatetext = String(updatetext.dropLast())
        }
        activeTextField.text = updatetext
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        deletBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: deletBtn.centerXAnchor, constant: 40),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: deletBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        updateBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: updateBtn.centerXAnchor, constant: 40),
            loadIndicator.centerYAnchor
                .constraint(equalTo: updateBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
    }
}


extension MaxPurchaseUpdateViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrofVarient.count == 0 {
            return 1
        }
        else {
            return arrPurchaseQty.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulkEditTableViewCell", for: indexPath) as!BulkEditTableViewCell
        cell.imageWidth.constant = 0
        cell.selectionStyle = .none
        
        cell.imageCheck.image = UIImage(named: "greencheck")
        cell.variLbl.textColor = UIColor(named: "varLbl")
        
        if arrPurchaseQty.count == 0 {
            isProd = true
            cell.variLbl.text = single_prod_title
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLbl.textColor = UIColor.black
        }
        else {
            isProd = false
            cell.variLbl.text = arrPurchaseQty[indexPath.row].name
            
            if arrPurchaseQty[indexPath.row].qty != "<null>" {
                cell.imageCheck.isHidden = false
                cell.imageWidth.constant = 26
                cell.variLbl.textColor = UIColor.black
            }
            else
            {
                cell.imageCheck.isHidden = true
                cell.imageWidth.constant = 0
                cell.variLbl.textColor = UIColor(named: "varLbl")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BulkEditTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        cell.imageCheck.image = UIImage(named: "greencheck")
        
        if cell.imageCheck.isHidden  {
            cell.imageCheck.isHidden = false
            cell.imageWidth.constant = 26
            cell.variLbl.textColor = UIColor.black
            if arrofVarient.count == 0 {
                prodSelect = true
            }
            else {
                selectEmpty.append(arrPurchaseQty[indexPath.row].id)
                print(selectEmpty)
            }
        }
        else {
            cell.imageCheck.isHidden = true
            cell.imageWidth.constant = 0
            cell.variLbl.textColor = UIColor(named: "varLbl")
            
            if arrofVarient.count == 0 {
                prodSelect = false
                
            }
            else {
                let ids = arrPurchaseQty[indexPath.row].id
                removeVarientId(id: ids)
                print(ids)
            }
        }
        
    }
}
