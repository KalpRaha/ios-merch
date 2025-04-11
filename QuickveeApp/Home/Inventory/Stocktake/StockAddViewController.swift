//
//  StockAddViewController.swift
//  
//
//  Created by Jamaluddin Syed on 11/11/24.
//

import UIKit
import BarcodeScanner


protocol StockAddDelegate: AnyObject {
    
    func stockAddCheck(variants: [InventoryVariant], addNewQty: [String],
                       disAdd: [String], noteAdd: [String])
}

class StockAddViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tablview: UITableView!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBOutlet weak var noVariantView: UIView!
    
    @IBOutlet weak var noVarLbl: UILabel!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    var variantList = [InventoryVariant]()
    var subVariantList = [InventoryVariant]()
    var searchVariantList = [InventoryVariant]()
    
    var selectAddStock = [InventoryVariant]()
    var newAddQty = [String]()
    var discrepancyAdd = [String]()
    var stock_Item_Id = [String]()
    var note = [String]()
    
    var stockList = [StockItem]()
    var substockList = [StockItem]()
    var searchStockList = [StockItem]()
    
    var searching = false
    var mode = ""
    
    var selectMode = ""
        
    weak var delegate: StockDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Start Typing UPC or Item Name"
        
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        subVariantList = []
        variantListApi()
    }
    
    
    func variantListApi() {
        
        loadingIndicator.isAnimating = true
        tablview.isHidden = true
        noVarLbl.isHidden = true
        noVariantView.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.variantListCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                self.getResponseValues(varient: list)
                
                DispatchQueue.main.async {
                    
                    self.loadingIndicator.isAnimating = false
                    self.tablview.isHidden = false
                    self.tablview.reloadData()
                }
            }
            else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(varient: Any){
        
        let response = varient as! [[String: Any]]
        var small = [InventoryVariant]()
        
        for res in response {
            
            let variant = InventoryVariant(id: "\(res["id"] ?? "")", costperItem: "\(res["costperItem"] ?? "")", title: "\(res["title"] ?? "")",
                                           isvarient: "\(res["isvarient"] ?? "")", upc: "\(res["upc"] ?? "")",
                                           cotegory: "\(res["cotegory"] ?? "")",
                                           var_id: "\(res["var_id"] ?? "")",
                                           var_upc: "\(res["var_upc"] ?? "")",
                                           quantity: "\(res["quantity"] ?? "")", price: "\(res["price"] ?? "")",
                                           custom_code: "\(res["custom_code"] ?? "")", variant: "\(res["variant"] ?? "")",
                                           var_price: "\(res["var_price"] ?? "")", is_lottery: "\(res["is_lottery"] ?? "")",
                                           var_costperItem: "\(res["var_costperItem"] ?? "")")
            
            small.append(variant)
        }
        
        variantList = small
        subVariantList = small
    }
    
    func removeVariant(variant: InventoryVariant) {
        
        if variant.isvarient == "1" {
            let pos = selectAddStock.firstIndex(where: {$0.var_id == variant.var_id})
            selectAddStock.remove(at: pos ?? 0)
            newAddQty.remove(at: pos ?? 0)
            discrepancyAdd.remove(at: pos ?? 0)
            note.remove(at: pos ?? 0)
            stock_Item_Id.remove(at: pos ?? 0)
        }
        else {
            let pos = selectAddStock.firstIndex(where: {$0.id == variant.id})
            selectAddStock.remove(at: pos ?? 0)
            newAddQty.remove(at: pos ?? 0)
            discrepancyAdd.remove(at: pos ?? 0)
            note.remove(at: pos ?? 0)
            stock_Item_Id.remove(at: pos ?? 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStockSave" {
            let vc = segue.destination as! StockSaveViewController
            vc.stockItemsList = selectAddStock
            vc.addNewQty = newAddQty
            vc.discrepancyAdd = discrepancyAdd
            vc.note = note
            vc.mode = "add"
            vc.delegate = self
        }
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        if selectMode == "select" {
            if selectAddStock.count == 0 {
                ToastClass.sharedToast.showToast(message: "No Variants Selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                delegate?.stockCheck(variants: selectAddStock, addNew: newAddQty,
                                     discrepancy: discrepancyAdd, item_id: stock_Item_Id, notes: note)
                dismiss(animated: true)
            }
        }
        else {
            if selectAddStock.count == 0 {
                ToastClass.sharedToast.showToast(message: "No Variants Selected", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            else {
                mode = "add"
                performSegue(withIdentifier: "toStockSave", sender: nil)
            }
        }
    }
    

    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if selectMode == "select" {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        
        if selectMode == "select" {
            dismiss(animated: true)
        }
        else {
            var destiny = 0
            
            let viewcontrollerArray = navigationController?.viewControllers
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
        
    }
    
    
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
}


extension StockAddViewController: BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate {
    
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        controller.dismiss(animated: true)
        
        performSearch(searchText: code)

    }
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("dismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: any Error) {
        print(error.localizedDescription)
    }
}




extension StockAddViewController: StockAddDelegate {
    
    func stockAddCheck(variants: [InventoryVariant], addNewQty: [String], disAdd: [String], noteAdd: [String]) {
        
        selectAddStock = variants
        newAddQty = addNewQty
        discrepancyAdd = disAdd
        note = noteAdd
        
        tablview.reloadData()
        
    }
}

extension StockAddViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(searchText: searchText)
    }
    
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
            tablview.isHidden = false
            noVarLbl.isHidden = true
            noVariantView.isHidden = true
        }
        else {
            searching = true
            searchVariantList = subVariantList.filter {
                
                let searchTextLowercased = searchText.lowercased()
                let isName = $0.title.lowercased().contains(searchTextLowercased)
                let isUPC = $0.upc.lowercased().contains(searchTextLowercased)
                let isVUPC = $0.var_upc.lowercased().contains(searchTextLowercased)
                
                return isName || isUPC || isVUPC
            }
            
            if searchVariantList.count == 0 {
                tablview.isHidden = true
                noVarLbl.isHidden = false
                noVariantView.isHidden = false
            }
            else {
                tablview.isHidden = false
                noVarLbl.isHidden = true
                noVariantView.isHidden = true
            }
        }
        tablview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        tablview.reloadData()
    }
}

extension StockAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchVariantList.count

        }
        else {
            return variantList.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tablview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockAddTableViewCell
            
            let variant = searchVariantList[indexPath.row]
            cell.nameLbl.text = variant.title
            
            if variant.isvarient == "1" {
                cell.upcLbl.text = "UPC: \(variant.var_upc)"
                
                if selectAddStock.contains(where: {$0.var_id == variant.var_id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                cell.upcLbl.text = "UPC: \(variant.upc)"
                
                if selectAddStock.contains(where: {$0.id == variant.id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            
            return cell
        }
        
        else {
            
            let cell = tablview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockAddTableViewCell
            
            let variant = variantList[indexPath.row]
            cell.nameLbl.text = variant.title
            
            if variant.isvarient == "1" {
                cell.upcLbl.text = "UPC: \(variant.var_upc)"
                
                if selectAddStock.contains(where: {$0.var_id == variant.var_id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            else {
                cell.upcLbl.text = "UPC: \(variant.upc)"
                
                if selectAddStock.contains(where: {$0.id == variant.id}) {
                    cell.check.image = UIImage(named: "check inventory")
                }
                else {
                    cell.check.image = UIImage(named: "uncheck inventory")
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tablview.deselectRow(at: indexPath, animated: true)
        
        let cell = tablview.cellForRow(at: indexPath) as! StockAddTableViewCell
        
        if searching {
            
            if cell.check.image == UIImage(named: "uncheck inventory") {
                cell.check.image = UIImage(named: "check inventory")
                selectAddStock.append(searchVariantList[indexPath.row])
                newAddQty.append("")
                discrepancyAdd.append("")
                note.append("")
                stock_Item_Id.append("")
            }
            else {
                cell.check.image = UIImage(named: "uncheck inventory")
                removeVariant(variant: searchVariantList[indexPath.row])
            }
        }
        
        else {
            
            if cell.check.image == UIImage(named: "uncheck inventory") {
                cell.check.image = UIImage(named: "check inventory")
                selectAddStock.append(variantList[indexPath.row])
                newAddQty.append("")
                discrepancyAdd.append("")
                note.append("")
                stock_Item_Id.append("")
            }
            else {
                cell.check.image = UIImage(named: "uncheck inventory")
                removeVariant(variant: variantList[indexPath.row])
            }
        }
    }
}
