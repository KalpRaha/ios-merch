//
//  GiftCardViewController.swift
//
//
//  Created by Pallavi on 31/07/24.
//

import UIKit
import BarcodeScanner

protocol giftCardDelegate: AnyObject {
    func setnavigation()
}

class GiftCardViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var giftCardTitle: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var noDataImg: UIImageView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var giftCardList = [giftCardModel]()
    var searchGiftCardArray = [giftCardModel]()
    var subGiftCardArray = [giftCardModel]()
    
    
    var price = ""
    var number = ""
    var emp_id = ""
    var created_at = ""
    var user_Id = ""
    var searching = false
    var staticImage = [String]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        topView.addBottomShadow()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBtn.alpha = 1
        searchBar.alpha = 0
        backBtn.alpha = 1
        giftCardTitle.alpha = 1
        searchBar.showsCancelButton = true
        searchBar.placeholder = "scan or enter gift card"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        staticImage = ["giftCardimage","giftGreen","giftRed","giftBlue"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingIndicator.isAnimating = true
        noDataImg.isHidden = true
        tableView.isHidden = true
        noDataLbl.isHidden = true
        
        noDataImg.image = UIImage(named: "No Data")
        noDataLbl.text = "No Gift Card Found"
        
        giftCardListApi()
        
    }
    
    func giftCardListApi(){
        
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getGiftCardList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    
                    self.tableView.isHidden = true
                    self.noDataImg.isHidden = false
                    self.noDataLbl.isHidden = false
                    
                    self.loadingIndicator.isAnimating = false
                    return
                }
                self.getResponseValues(gift: list)
                
                
                if self.giftCardList.count == 0 {
                    self.tableView.isHidden = true
                    self.noDataImg.isHidden = false
                    self.noDataLbl.isHidden = false
                    
                    self.loadingIndicator.isAnimating = false
                }
                else {
                    self.tableView.isHidden = false
                    self.noDataImg.isHidden = true
                    self.noDataLbl.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    
                }
                self.tableView.reloadData()
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(gift: Any) {
        
        let response = gift as! [[String: Any]]
        var small = [giftCardModel]()
        
        for res in response {
            
            let card = giftCardModel(id: "\(res["id"] ?? "")", number: "\(res["number"] ?? "")",
                                     user_id: "\(res["user_id"] ?? "")", amount: "\(res["amount"] ?? "")",
                                     emp_id: "\(res["emp_id"] ?? "")", merchant_id: "\(res["merchant_id"] ?? "")",
                                     created_at: "\(res["created_at"] ?? "")", order_id: "\(res["order_id"] ?? "")")
            
            small.append(card)
        }
        
        giftCardList = small
        subGiftCardArray = small
    }
    
    
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        else {
            searching = true
            searchGiftCardArray = subGiftCardArray.filter{ $0.number.lowercased().prefix(searchText.count) == searchText.lowercased()}
            
            if searchGiftCardArray.count == 0 {
                noDataLbl.isHidden = false
                noDataImg.isHidden = false
                tableView.isHidden = true
            }
            else {
                noDataLbl.isHidden = true
                noDataImg.isHidden = true
                tableView.isHidden = false
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
     
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        backBtn.alpha = 0
        giftCardTitle.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        homeBtn.alpha = 0
        scanBtn.alpha = 0
        searchBar.searchTextField.becomeFirstResponder()
        
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

extension GiftCardViewController : giftCardDelegate {
    
    func setnavigation() {
        let modal = UserDefaults.standard.integer(forKey: "modal_screen")
        
        if modal == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AddGiftCardViewController") as! AddGiftCardViewController
            
            vc.mode = "Add"
            vc.number = number
            vc.emp_id = emp_id
            vc.amount = price
            vc.created = created_at
            vc.user_Id = user_Id
            vc.delegate = self
            self.present(vc, animated: true)
        }
        else if modal == 2 {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AddGiftCardViewController") as! AddGiftCardViewController
            
            vc.mode = "Remove"
            vc.amount = price
            vc.created = created_at
            vc.emp_id = emp_id
            vc.number = number
            vc.user_Id = user_Id
            vc.delegate = self
            self.present(vc, animated: true)
        }
        
        
    }
}

extension GiftCardViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        backBtn.alpha = 1
        giftCardTitle.alpha = 1
        searchBtn.alpha = 1
        searchBar.alpha = 0
        homeBtn.alpha = 1
        scanBtn.alpha = 1
        searching = false
        view.endEditing(true)
        performSearch(searchText: "")
        giftCardListApi()
        tableView.reloadData()
    }
}

extension GiftCardViewController : BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
        backBtn.alpha = 0
        giftCardTitle.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        scanBtn.alpha = 0
        
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        controller.dismiss(animated: true)
        
        performSearch(searchText: code)
        
    }
}


extension GiftCardViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchGiftCardArray.count
        }
        else {
            return  giftCardList.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCardTableViewCell", for: indexPath) as! GiftCardTableViewCell
        
        if searching {
            
            cell.selectionStyle = .none
            cell.number.text = searchGiftCardArray[indexPath.row].number
            cell.amt.text = "$\(searchGiftCardArray[indexPath.row].amount)"
        }
        else {
            
            cell.selectionStyle = .none
            cell.number.text = giftCardList[indexPath.row].number
            cell.amt.text = "$\(giftCardList[indexPath.row].amount)"
        }
        
        let imageIndex = indexPath.row % staticImage.count
        let imageView = cell.giftImage!
        imageView.image = UIImage(named: staticImage[imageIndex])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            price = searchGiftCardArray[indexPath.row].amount
            number = searchGiftCardArray[indexPath.row].number
            emp_id = searchGiftCardArray[indexPath.row].emp_id
            created_at = searchGiftCardArray[indexPath.row].created_at
            user_Id = searchGiftCardArray[indexPath.row].user_id
            
        }
        else {
            
            price = giftCardList[indexPath.row].amount
            number = giftCardList[indexPath.row].number
            emp_id = giftCardList[indexPath.row].emp_id
            created_at = giftCardList[indexPath.row].created_at
            user_Id = giftCardList[indexPath.row].user_id
            
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GiftCardDetailViewController") as! GiftCardDetailViewController
        vc.nav = self
        vc.price = price
        self.present(vc, animated: true)
    }
}

extension GiftCardViewController: AddGiftcardprotocol {
    
    func setGIftCard() {
        giftCardListApi()
        
        ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
    }
}

struct giftCardModel {
    
    let id: String
    let number: String
    let user_id: String
    let amount: String
    let emp_id: String
    let merchant_id: String
    let created_at: String
    let order_id: String
    
}
