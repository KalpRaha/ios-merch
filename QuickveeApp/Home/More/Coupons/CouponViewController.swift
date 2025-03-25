//
//  CouponViewController.swift
//
//
//  Created by Jamaluddin Syed on 01/03/23.
//

import UIKit
import Alamofire

class CouponViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var floatButton: UIButton!
    
    @IBOutlet weak var noCouponView: UIView!
    @IBOutlet weak var clicktoAdd: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var couponLabel: UILabel!
    
    var mode = 0
    var editCoupon: CouponEdit?
    var coupon_id: String?
    
    var couponArray = [Coupon]()
    
    let refresh = UIRefreshControl()
    var category_Id = ""
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var merchant_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableview.showsVerticalScrollIndicator = false
        topView.addBottomShadow()
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noCouponView.isHidden = true
        tableview.isHidden = true
        floatButton.isHidden = true
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            couponLabel.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            couponLabel.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        
        loadingIndicator.isAnimating = true
        
        setupApi()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "toAddCoupon" {
            let vc = segue.destination as! AddCouponViewController
            
            if mode == 1 {
                vc.editCoupondetails = editCoupon
                vc.setmode = mode
                vc.id = coupon_id
                vc.merchant_id = merchant_id
                vc.couponNameArray = couponArray
            }
            
            else {
                vc.merchant_id = merchant_id
                vc.couponNameArray = couponArray
            }
        }
    }
    
    @objc func pullToRefresh() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
    }
    
    func setupApi() {
        
        let url = AppURLs.GET_COUPON_DETAILS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    self.responseValues(responseValue: json["result"]!)
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                    if self.refresh.isRefreshing {
                        self.refresh.endRefreshing()
                    }
                }
                
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func setupOnlineApi() {
        
        let url = AppURLs.COUPON_SHOW_ONLINE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id!,
            "coupon_id": coupon_id!
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                }
                catch {
                    
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func responseValues(responseValue: Any) {
        
        var couponArr = [Coupon]()
        
        if AppURLs.GET_COUPON_DETAILS.contains("sandbox") {
            
            let response = responseValue as? [String: Any] ?? [:]
            
            if response.count == 0 {
                tableview.isHidden = true
                
                noCouponView.isHidden = false
                floatButton.isHidden = true
                loadingIndicator.isAnimating = false
            }
            
            else {
                
                for (_, value) in response {
                    
                    let val = value as! [String:Any]
                    
                    
                    let coupon = Coupon(id: "\(val["id"] ?? "")", list_online: "\(val["list_online"] ?? "")", m_id: "\(val["m_id"] ?? "")",
                                        admin_id: "\(val["admin_id"] ?? "")", name: "\(val["name"] ?? "")",
                                        min_amount: "\(val["min_amount"] ?? "")", flag: "\(val["flag"] ?? "")",
                                        discount: "\(val["discount"] ?? "")",
                                        date_valid: "\(val["date_valid"] ?? "")", date_expire: "\(val["date_expire"] ?? "")",
                                        time_valid: "\(val["time_valid"] ?? "")", time_expire: "\(val["time_expire"] ?? "")",
                                        enable_limit: "\(val["enable_limit"] ?? "")", count_limit: "\(val["count_limit"] ?? "")",
                                        show_online: "\(val["show_online"] ?? "")", create_at: "\(val["create_at"] ?? "")",
                                        update_at: "\(val["update_at"] ?? "")", maximum_discount: "\(val["maximum_discount"] ?? "")",
                                        description: "\(val["description"] ?? "")", category_id: "\(val["category_id"] ?? "")",
                                        coupon_type: "\(val["coupon_type"] ?? "")")
                    
                    couponArr.append(coupon)
                }
                couponArray = couponArr
                
                tableview.isHidden = false
                
                floatButton.isHidden = false
                noCouponView.isHidden = true
                loadingIndicator.isAnimating = false
                
            }
        }
        
        //live
        
        else {
            
            let response = responseValue as? [[String: Any]] ?? [[:]]
            
            if response.count == 0 {
                tableview.isHidden = true
                loadingIndicator.isAnimating = false
                
                noCouponView.isHidden = false
                floatButton.isHidden = true
                
            }
            
            else {
                
                for res in response {
                    
                    let coupon = Coupon(id: "\(res["id"] ?? "")", list_online: "\(res["list_online"] ?? "")",
                                        m_id: "\(res["m_id"] ?? "")",
                                        admin_id: "\(res["admin_id"] ?? "")", name: "\(res["name"] ?? "")",
                                        min_amount: "\(res["min_amount"] ?? "")", flag: "\(res["flag"] ?? "")",
                                        discount: "\(res["discount"] ?? "")",
                                        date_valid: "\(res["date_valid"] ?? "")", date_expire: "\(res["date_expire"] ?? "")",
                                        time_valid: "\(res["time_valid"] ?? "")", time_expire: "\(res["time_expire"] ?? "")",
                                        enable_limit: "\(res["enable_limit"] ?? "")", count_limit: "\(res["count_limit"] ?? "")",
                                        show_online: "\(res["show_online"] ?? "")", create_at: "\(res["create_at"] ?? "")",
                                        update_at: "\(res["update_at"] ?? "")", maximum_discount: "\(res["maximum_discount"] ?? "")",
                                        description: "\(res["description"] ?? "")", category_id: "\(res["category_id"] ?? "")",
                                        coupon_type: "\(res["coupon_type"] ?? "")")
                    couponArr.append(coupon)
                }
                
                couponArray = couponArr
                
                loadingIndicator.isAnimating = false
                tableview.isHidden = false
                
                floatButton.isHidden = false
                noCouponView.isHidden = true
                
            }
        }
    }
    
 
    @IBAction func backBtnClck(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func clickAddClick(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "lock_add_coupon") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            mode = 0
            performSegue(withIdentifier: "toAddCoupon", sender: nil)
        }
    }
    
    @IBAction func floatBtnClick(_ sender: UIButton) {
       
        if UserDefaults.standard.bool(forKey: "lock_add_coupon") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            
            mode = 0
            performSegue(withIdentifier: "toAddCoupon", sender: nil)
        }
    }
    
    
    @IBAction func homeButtonClick(_ sender: UIButton) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            var destiny = 0
            let viewcontrollerArray = navigationController?.viewControllers
            
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
        else {
            dismiss(animated: true)
        }
    }
    
    
    func validateEditParameters(tag: Int) {
        
        let coupon = CouponEdit(online: couponArray[tag].show_online, list_online: couponArray[tag].list_online,
                                cc: couponArray[tag].name, desc: couponArray[tag].description,
                                min: couponArray[tag].min_amount, redem: couponArray[tag].enable_limit,
                                redem_text: couponArray[tag].count_limit, flag: couponArray[tag].flag,
                                dis_amount: couponArray[tag].discount, max_dis: couponArray[tag].maximum_discount,
                                start_date: couponArray[tag].date_valid, end_date: couponArray[tag].date_expire,
                                start_time: couponArray[tag].time_valid, end_time: couponArray[tag].time_expire,
                                category: "", coupon_type: couponArray[tag].coupon_type, product_data: "")
        mode = 1
        editCoupon = coupon
    }
    
    
    
    @objc func changeShadow(sender : UISwitch) {
        
        coupon_id = couponArray[sender.tag].id
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableview.cellForRow(at: index) as! CouponTableViewCell
        
        if cell.discountValue.text == "100.00%" {
            cell.onlineSwitch.isOn = false
            ToastClass.sharedToast.showToast(message: "Show Online is Disabled for 100% Coupon", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        
        else {
            setupOnlineApi()
            loadingIndicator.isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.loadingIndicator.isAnimating = false
                self.setupApi()
            }
        }
    }
    
    func startEndDateFormat(date: String) -> String {
        
        let dateFormat1 = DateFormatter()
        dateFormat1.dateFormat = "yyyy-MM-dd"
        
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "MM/dd/yyyy"
        
        if date == "0000-00-00" {
           return date
        }
        else {
            let dateold = dateFormat1.date(from: date)
            let dateNew = dateFormat2.string(from: dateold!)
            return dateNew
        }
    }
    
    func checkMaxDiscount(max: String) -> Bool {
        
        let max_doub = Double(max) ?? 0.00
        
        if max_doub < 100.00 {
            return true
        }
        return false
    }
}

extension CouponViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CouponTableViewCell
        
        let coupon = couponArray[indexPath.row]
        
        cell.couponCode.text = "Coupon Code"
        cell.codeName.text = coupon.name
        cell.discount.text = "Discount"
        
        if coupon.flag == "0" {
            
            if checkMaxDiscount(max: coupon.discount) {
                cell.maxOrderAmt.text = coupon.maximum_discount
                cell.maxOrder.text = "Maximum Discount"
                cell.maxDiscountBottom.constant = 10
            }
            else {
                cell.maxOrderAmt.text = ""
                cell.maxOrder.text = ""
                cell.maxDiscountBottom.constant = 0
            }
            cell.discountValue.text = "\(coupon.discount)\u{0025}"
        }
        else {
            cell.discountValue.text = "\u{0024}\(coupon.discount)"
            cell.maxOrderAmt.text = ""
            cell.maxOrder.text = ""
            cell.maxDiscountBottom.constant = 0
        }
        
        cell.validity.text = "Validity"
        cell.minOrder.text = "Min Order Amt"
        
        cell.validityDate.text =
        "\(startEndDateFormat(date: coupon.date_valid)) - \(startEndDateFormat(date: coupon.date_expire))"
        
        cell.minOrderAmt.text = "\u{0024}\(coupon.min_amount)"
        
        cell.borderView.layer.cornerRadius = 10
        cell.borderView.layer.borderColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0).cgColor
        cell.borderView.layer.borderWidth = 1.0
        
        cell.online.text = "Show Online"
        
        
        cell.onlineSwitch.isEnabled = true
        cell.onlineSwitch.tag = indexPath.row
        cell.onlineSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        cell.onlineSwitch.addTarget(self, action: #selector(changeShadow), for: .valueChanged)
        
        
        if coupon.show_online == "1" {
            cell.onlineSwitch.isOn = true
        }
        else {
            cell.onlineSwitch.isOn = false
        }
        
        if cell.onlineSwitch.isOn {
            cell.borderView.layer.shadowColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1).cgColor
            cell.borderView.layer.shadowOpacity = 1
            cell.borderView.layer.shadowOffset = CGSize.zero
            cell.borderView.layer.shadowRadius = 10
        }
        else {
            cell.borderView.layer.shadowOpacity = 0
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_coupon") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            mode = 1
            coupon_id = couponArray[indexPath.row].id
            validateEditParameters(tag: indexPath.row)
            performSegue(withIdentifier: "toAddCoupon", sender: nil)
        }
    }
}

extension CouponViewController {
    
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


struct CouponEdit {
    
    let online: String
    let list_online: String
    let cc: String
    let desc: String
    let min: String
    let redem: String
    let redem_text: String
    let flag: String
    let dis_amount: String
    let max_dis: String
    let start_date: String
    let end_date: String
    let start_time: String
    let end_time: String
    let category: String
    let coupon_type: String
    let product_data: String
}

struct Coupon {
    
    let id: String
    let list_online: String
    let m_id: String
    let admin_id: String
    let name: String
    let min_amount: String
    let flag: String
    let discount: String
    let date_valid: String
    let date_expire: String
    let time_valid: String
    let time_expire: String
    let enable_limit: String
    let count_limit: String
    let show_online: String
    let create_at: String
    let update_at: String
    let maximum_discount: String
    let description: String
    let category_id: String
    let coupon_type: String
}
