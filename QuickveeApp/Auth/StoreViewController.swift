//
//  StoreViewController.swift
//
//
//  Created by Jamaluddin Syed on 13/01/23.
//

import UIKit
import Nuke
import Alamofire
import WebKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var selectStoreText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectStoreBtn: UIButton!
    @IBOutlet weak var storeView: UIView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    weak var delegate: SwitchStoreDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let options = ImageLoadingOptions(placeholder: UIImage(named: "merchant"), transition: .fadeIn(duration: 0.5))
    
    var mode = ""
    
    var current_Password: String?
    var current_email: String?
    var storeArray = [Store]()
    
    var passwordArray = [String]()
    var merchant_id_Array = [String]()
    var merchant_name_Array = [String]()
    var store_logo = [String]()
    
    var adv_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bgImage.image = UIImage(named: "White")
        selectStoreText.text = "Select Store"
        selectStoreBtn.setTitle("Select Stores", for: .normal)
        selectStoreBtn.backgroundColor = UIColor.black
        selectStoreBtn.setTitleColor(UIColor.white, for: .normal)
        storeView.layer.cornerRadius = 20
        selectStoreBtn.layer.cornerRadius = 10
        
        setupArrays()
        
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    
    func setupArrays() {
        
        var passArr = [String]()
        var merch_id_Arr = [String]()
        var merch_name_Arr = [String]()
        var logo = [String]()
        
        for password in storeArray {
            passArr.append(password.password)
            merch_id_Arr.append(password.merchant_id)
            merch_name_Arr.append(password.merchant_name)
            logo.append(password.logo)
        }
        
        passwordArray = passArr
        merchant_id_Array = merch_id_Arr
        merchant_name_Array = merch_name_Arr
        store_logo = logo
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        if mode == "login" {
            navigationController?.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func selectButtonClick(_ sender: UIButton) {
        
        selectStoreBtn.setTitle("Please Wait!", for: .normal)
        loadingIndicator.isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingIndicator.isAnimating = false
        }
        
        let deselect = UserDefaults.standard.integer(forKey: "select_store")
        
        if mode == "login" {
            
            if verifyStoreLogin(index: deselect) {
                
                selectStoreBtn.setTitle("Select Stores", for: .normal)
                UserDefaults.standard.set(storeArray[deselect].store_name, forKey: "store_name")
                UserDefaults.standard.set(merchant_id_Array[deselect], forKey: "merchant_id")
                UserDefaults.standard.set(merchant_name_Array[deselect], forKey: "merchant_name")
                
                let email = current_email ?? ""
                let password = current_Password ?? ""
                
                UserDefaults.standard.set(email, forKey: "merchant_email")
                UserDefaults.standard.set(password, forKey: "merchant_password")
                UserDefaults.standard.set(false, forKey: "home_return")
                
                performSegue(withIdentifier: "storetoPassCode", sender: nil)
            }
            
            else {
                selectStoreBtn.setTitle("Select Stores", for: .normal)
                showAlert(title: "Alert", message: "Cannot login. Passwords do not match")
                
            }
        }
        
        else {
            
            let websiteDataTypes: Set<String> = [
                WKWebsiteDataTypeCookies,
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeMemoryCache,
                WKWebsiteDataTypeLocalStorage,
                WKWebsiteDataTypeSessionStorage,
                WKWebsiteDataTypeIndexedDBDatabases,
                WKWebsiteDataTypeWebSQLDatabases,
            ]
            
            let dateFrom = Date(timeIntervalSince1970: 0) // To remove all data
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
                print("Website data cleared.")
            }
            
            dismiss(animated: true) {
                
                UserDefaults.standard.set(self.storeArray[deselect].store_name, forKey: "store_name")
                UserDefaults.standard.set(self.storeArray[deselect].login_store_name, forKey: "store_name_webview")
                
                let email = self.current_email ?? ""
                let password = self.current_Password ?? ""
                UserDefaults.standard.set(email, forKey: "merchant_email")
                UserDefaults.standard.set(password, forKey: "merchant_password")
                UserDefaults.standard.set(false, forKey: "home_return")
                let id = self.merchant_id_Array[deselect]
                self.delegate?.setPresent(id: id)
            }
        }
    }
    
    
    func verifyStoreLogin(index: Int) -> Bool {
        
        if passwordArray[index] == current_Password!.md5 {
            return true
        }
        else {
            return false
        }
    }
    
    func toggleStoreSelect(deselect: Int) {
        
        if !(UserDefaults.standard.integer(forKey: "select_store") == deselect) {
            let indexPath = IndexPath(item: deselect, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "storetoPassCode" {
            
            let vc = segue.destination as! PassCodeViewController
        }
    }
    
    func setLogo(image: String) -> String {
        
        return "\(AppURLs.STORE_LOGO)\(image)"
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreTableViewCell
        
        Nuke.loadImage(with: setLogo(image: store_logo[indexPath.row]) , options: options, into: cell.storeImage)
        
        cell.storeName.text = storeArray[indexPath.row].store_name
        cell.storeAddress.text = "\(storeArray[indexPath.row].a_address_line_1), \(storeArray[indexPath.row].a_city), \(storeArray[indexPath.row].a_state) \(storeArray[indexPath.row].a_zip)"
        cell.storeCheck.image = UIImage(named: "Check")
        cell.content.layer.cornerRadius = 20
        
        if mode == "login" {
            
            cell.storeCheck.isHidden = true
        }
        
        else {
            
            let deselect = UserDefaults.standard.integer(forKey: "select_store")
            
            if indexPath.row == deselect {
                cell.storeCheck.isHidden = false
            }
            else {
                cell.storeCheck.isHidden = true
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath) as! StoreTableViewCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let deselect = UserDefaults.standard.integer(forKey: "select_store")
        UserDefaults.standard.set(indexPath.row, forKey: "select_store")
        cell.storeCheck.isHidden = false
        toggleStoreSelect(deselect: deselect)
        selectStoreBtn.setTitle("Done", for: .normal)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StoreViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        selectStoreBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: selectStoreBtn.centerXAnchor, constant: 55),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: selectStoreBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
}

struct Store {
    let a_city : String
    let a_country : String
    let a_phone : String
    let a_state : String
    let a_zip : String
    let email : String
    let logo : String;
    let merchant_id : String
    let merchant_name : String
    var password : String
    let store_name : String
    let login_store_name:String
    let a_address_line_1:String
    let a_address_line_2:String
    
}
