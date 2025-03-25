//
//  ShowVendorViewController.swift
//  
//
//  Created by Jamaluddin Syed on 27/03/23.
//

import UIKit
import Alamofire

class ShowVendorViewController: UIViewController {

    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var noTransactionView: UIView!
    
    var vendor_enable: String?
    var vendorId: String?
    var vendorName: String?
    var vendorNumber: String?
    var merchant_id: String?
    
    var vendor_Pay = [Vendor_Payment]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        blackView.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        loadingIndicator.isAnimating = true
        tableview.isHidden = true
        noTransactionView.isHidden = true
        setupApi()
        
        if UserDefaults.standard.integer(forKey: "vendorDateMode") == 10 {
            if UserDefaults.standard.integer(forKey: "vendorDate") == 1 {
                setDateTime()
            }
        }
        setupVendorPayApi()
    }
    
    func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupApi() {
        
        let url = AppURLs.VENDOR_BY_ID

        let parameters: [String:Any] = [
            "id": vendorId!
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.responseValues(responseValues: json["vendor_data"])
                    break
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func setupVendorPayApi() {
        
        
        let url = AppURLs.VENDOR_PAYMENT_DETAILS

        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? "",
            "vendor_id": vendorId!,
            "start_date_time": UserDefaults.standard.string(forKey: "vendor_start_date")!,
            "end_date_time": UserDefaults.standard.string(forKey: "vendor_end_date")!
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    guard let pay = json["result"] else {
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = true
                        self.noTransactionView.isHidden = false
                        return
                    }
                    print(json)
                    self.responseValuesPay(responseValues: pay)
                    self.tableview.reloadData()
                    self.noTransactionView.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    self.tableview.isHidden = false
                    break
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    
    }
    
    func responseValuesPay(responseValues: Any) {
        
        let response = responseValues as! [[String:Any]]
        var vp = [Vendor_Payment]()
        for res in response {
            let vendor_pay = Vendor_Payment(id: "\(res["id"] ?? "")",
                                            is_deleted: "\(res["is_deleted"] ?? "")",
                                            merchant_id: "\(res["merchant_id"] ?? "")",
                                            pay_amount: "\(res["pay_amount"] ?? "")",
                                            pay_by: "\(res["pay_by"] ?? "")",
                                            payment_datetime: "\(res["payment_datetime"] ?? "")",
                                            remark: "\(res["remark"] ?? "")",
                                            updated_datetime: "\(res["updated_datetime"] ?? "")",
                                            vendor_id: "\(res["vendor_id"] ?? "")")
            vp.append(vendor_pay)
        }
        vendor_Pay = vp
        print(vendor_Pay)
        print(vendor_Pay)
    }
    
    
    func responseValues(responseValues: Any) {
        
        let response = responseValues as! [String: Any]
        vendorName = (response["name"]! as! String)
        vendorNumber = (response["phone"]! as! String)
        merchantName.text = "\(vendorName!) - \(vendorNumber!)"
        vendor_enable = (response["enabled"] as! String)
    }
    
    func setDateTime() {
        let date = Date()
        let _ = Calendar.current
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        
        df.dateFormat = "yyyy-MM-dd"
        let startDate = "\(df.string(from: date)) 00:00:00"
        df.dateFormat = "yyyy-MM-dd"
        let endDate = "\(df.string(from: date)) 23:59:59"
        UserDefaults.standard.set(startDate, forKey: "vendor_start_date")
        UserDefaults.standard.set(endDate, forKey: "vendor_end_date")
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        let viewcontrollerArray = navigationController?.viewControllers

        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toVendorFilter", sender: nil)
    }
    
    @IBAction func editVendorClick(_ sender: UIButton) {
        
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(red: 14.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 0.7)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addVendor") as! AddVendorViewController
        vc.showviewcontrol = self
        vc.mode = "update"
        vc.updateVendorName = vendorName
        vc.updateVendorNumber = vendorNumber
        vc.merchant_id = merchant_id
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true)
    }
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func vendorInfoClick(_ sender: UIButton) {
        
        showAlert(title: "Remark", message: vendor_Pay[sender.tag].remark ?? "")
    }
}

extension ShowVendorViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendor_Pay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowVendorTableViewCell
        
    
        cell.vendorAmt.text = vendor_Pay[indexPath.row].pay_amount
        cell.vendorDetails.text = vendor_Pay[indexPath.row].payment_datetime
        cell.vendorInfo.tag = indexPath.row
        
        if vendor_Pay[indexPath.row].remark == "" {
            cell.vendorInfo.isHidden = true
        }
        
        else {
            cell.vendorInfo.isHidden = false
        }
        return cell
            
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
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}

struct Vendor {
    
    let created_at: String?
    let enabled: String?
    let id: String?
    let is_deleted: String?
    let merchant_id: String?
    let name: String?
    let phone: String?
    let updated_at: String?
    
    
    
    
}

struct Vendor_Payment {
    
    let id: String?
    let is_deleted: String?
    let merchant_id: String?
    let pay_amount: String?
    let pay_by: String?
    let payment_datetime: String?
    let remark: String?
    let updated_datetime: String?
    let vendor_id: String?
}
