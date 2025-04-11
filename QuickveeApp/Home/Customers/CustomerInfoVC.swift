//
//  CustomerInfoVC.swift
//  
//
//  Created by Pallavi on 08/11/24.
//

import UIKit

protocol CustomerDelegate: AnyObject {
    func setNavigation(model: Int)
}

class CustomerInfoVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var disableBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var orderId = ""
    var initial = ""
    var custId = ""
    var email = ""
    var phone = ""
    var isrefunded = ""
    var refundSelected = false
    var searching = false
    var bdate = ""
    var isbirth = false
    var custObj: FindCustModel?
    
    var custViewbg : UIColor?
    var inicolor : UIColor?
    
    var custOrderArr = [PaidRefundModel]()
    var subcustOrderArray = [PaidRefundModel]()
    var searchCustOrderArray = [PaidRefundModel]()
    
   // var couponCustArr = [CustCouponCode]()
    var cust_page_arr = [PaidRefundModel]()
    
    var loyaltyPoint: LoyaltyProgramList?
    var custInfoArr = [FindCustModel]()
    var p_Value = ""
    var page = 1
    
    
    let loadIndicator: ProgressView = {
        let progress = ProgressView(colors: [.blue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let indicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "profileCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "profileCell")
        
        let nib1 = UINib(nibName: "HeaderViewCell", bundle: nil)
        tableView.register(nib1, forHeaderFooterViewReuseIdentifier: "HeaderViewCell")
        
        let nib2 = UINib(nibName: "OrderCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "OrderCell")
        
        let nib3 = UINib(nibName: "NoOrderFoundCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "NoOrderFoundCell")
 
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBtn.alpha = 1
        searchBar.alpha = 0
        backBtn.alpha = 1
        customerLbl.alpha = 1
        homeBtn.alpha = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        indicator.isAnimating = true
        setUI()
        isrefunded = "0"
        refundSelected = false
        
        subcustOrderArray = []
      
        
        
        setupUI()
        findCustAPICall()
        searchBar.placeholder = "Search Paid Order"
    }
  
    func findCustAPICall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        
        ApiCalls.sharedCall.findCustomers(merchant_id: id, email: email, phone_no: phone) { isSuccess, response in
            
            if isSuccess {
                
                guard let list = response["result"] else {
                    return
                }
                self.getfindCustResponse(list: list)
                
                
            }
            else {
                print("Error")
            }
        }
    }
    
    func getfindCustResponse(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [FindCustModel]()
        
        // for item in response[0] {
        
        let item =  response[0]
        
        let customer =  FindCustModel(customer_id: "\(item["customer_id"] ?? "")",
                                      f_name: "\(item["f_name"] ?? "")",
                                      l_name: "\(item["l_name"] ?? "")",
                                      name: "\(item["name"] ?? "")",
                                      email: "\(item["email"] ?? "")",
                                      phone: "\(item["phone"] ?? "")",
                                      address_line_1: "\(item["address_line_1"] ?? "")",
                                      address_line_2: "\(item["address_line_2"] ?? "")",
                                      pincode: "\(item["pincode"] ?? "")",
                                      state: "\(item["state"] ?? "")",
                                      city: "\(item["city"] ?? "")",
                                      dob: "\(item["dob"] ?? "")",
                                      note: "\(item["note"] ?? "")",
                                      is_disabled: "\(item["is_disabled"] ?? "")",
                                      total_loyalty_pts: "\(item["total_loyalty_pts"] ?? "")",
                                      total_store_credit: "\(item["total_store_credit"] ?? "")")
        
        
        small.append(customer)
        print(small)
        //  }
        
        custInfoArr = small
        print(custInfoArr)
        custObj = custInfoArr.first
        print(custObj?.f_name)
        
        
        if  custObj?.is_disabled == "1" {
            disableBtn.setTitle("Enable", for: .normal)
            disableBtn.setTitleColor(UIColor(named: "Compeletetext"), for: .normal)
            disableBtn.layer.borderColor = UIColor(named: "Compeletetext")?.cgColor
        }
        else {
            disableBtn.setTitle("Disable", for: .normal)
            disableBtn.setTitleColor(UIColor.black, for: .normal)
        }
        
        
        p_Value = custObj?.total_loyalty_pts ?? "0.00"
        
        let dob = custObj?.dob
        
        if dob != "<null>" && dob != "0000-00-00 00:00:00" {
            
            let bday = ToastClass.sharedToast.setStockDateFormat(dateStr: dob ?? "")
            
            
            bdate = bday
            //String(date?.first ?? "")
            isbirth = true
        }
        else {
            print("Failed to parse DOB string")
            isbirth = false
        }
        
        loyaltyPointApi()
    }
 
    func setUI() {
        
        disableBtn.layer.borderWidth = 1
        disableBtn.layer.borderColor = UIColor.black.cgColor
        deleteBtn.layer.cornerRadius = 5
        disableBtn.layer.cornerRadius  = 5
    }
  
   
    func formatPhoneNumber(_ number: String) -> String {
        let formattedNumber = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{4})", with: "$1-$2-$3", options: .regularExpression, range: nil)
        return formattedNumber
    }
    
    
 
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = (100 * doub) / 100
        print(div)
        return div
    }
    
    
    @objc func pointBalanceClick() {
    
        if p_Value == "0.00" {
            
            if UserDefaults.standard.bool(forKey: "lock_add_points_customer") {
                ToastClass.sharedToast.showToast(message: "Access Denied",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
            }
            else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AddRemoveCustViewController") as! AddRemoveCustViewController
                vc.mode = "Add"
                vc.customerId = custId
                vc.custdelegate = self
                self.present(vc, animated: true)
            }
        }
        else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PointBalanceDetailVC") as! PointBalanceDetailVC
            vc.pointDelegate = self
            vc.pointValue = p_Value
           

            self.present(vc, animated: true)
        }
    }
    
    
    @objc func paidOrderBtnClick() {
        
        isrefunded = "0"
        
        refundSelected = false
        indicator.isAnimating = true
        searchBar.placeholder = "Search Refunded Order"
        searchBar.text = ""
        searching = false
        paidRefundOrderCustAPI()
    }
    
    @objc func refundOrderBtnClick() {
        
        isrefunded = "1"
        
        refundSelected = true
        indicator.isAnimating = true
        searchBar.placeholder = "Search Refunded Order"
        searchBar.text = ""
        searching = false
        paidRefundOrderCustAPI()
    }
    
  
    func customerDeleteAPi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.deleteCustomers(merchant_id: id, customer_id: custId ){ isSuccess,responseData in
            
            if isSuccess {
                // let list = responseData as? [String:Any]
                
                
                ToastClass.sharedToast.showToast(message: "Customer Record Deleted Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                self.navigationController?.popViewController(animated: true)
                
            }
            else {
                print("API Error")
            }
        }
    }
    
    
    func disableCustomerAPi(isdisable: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadIndicator.isAnimating = true
        
        ApiCalls.sharedCall.disableCustomers(merchant_id: id, customer_id: custId, is_disabled: isdisable){ isSuccess, responseData in
            
            if isSuccess {
                if isdisable == "0" {
                    self.disableBtn.setTitle("Disable", for: .normal)
                }
                else {
                    self.disableBtn.setTitle("Enable", for: .normal)
                }
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("APi Error")
            }
        }
    }

    
    func loyaltyPointApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getLoyaltyProgramList(merchant_id: id){ isSuccess, responseData in
            
            if isSuccess {
                
                
                guard let list = responseData["loyalty_program_data"] else {
                    self.paidRefundOrderCustAPI()
                    self.indicator.isAnimating = false
                    
                    self.tableView.isHidden = false
                    
                    return
                }
                self.getLoyaltyResponse(List: list)
            }
            else {
                print("Api Error")
            }
        }
    }
    
    func getLoyaltyResponse(List: Any) {
        
        let loyaltyData = List as! [String: Any]
        
        
        
        let res = LoyaltyProgramList(merchant_id: "\(loyaltyData["merchant_id"] ?? "")",
                                     admin_id: "\(loyaltyData["admin_id"] ?? "")",
                                     enable_loyalty: "\(loyaltyData["enable_loyalty"] ?? "")",
                                     current_points: "\(loyaltyData["current_points"] ?? "")",
                                     points_per_dollar: "\(loyaltyData["points_per_dollar"] ?? "")",
                                     redemption_value: "\(loyaltyData["redemption_value"] ?? "")",
                                     min_points_redemption: "\(loyaltyData["min_points_redemption"] ?? "")")
        
        loyaltyPoint = res
        
        paidRefundOrderCustAPI()
        self.indicator.isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.isHidden = false
        }
        
    }
    
    func paidRefundOrderCustAPI() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getCustomerPaidRefundOrderList(merchant_id: id, customer_id: custId,
                                                           order_id: "", order_status: "paid",
                                                           is_refunded: isrefunded, page_no: 1, limit: 10){ isSuccess, responseData in
            
            if isSuccess {
                
                guard  let list = responseData["result"] else {
                    self.tableView.isHidden = false
                    self.indicator.isAnimating = false
                    //                      self.orderDetailView.isHidden = true
                    //                      self.noOrderimage.isHidden = false
                    //                      self.noOrderLbl.isHidden = false
                    //                      self.indicator.isAnimating = false
                    self.custOrderArr = []
                    //self.couponCustArr = []
                    self.tableView.reloadData()
                    
                    return
                }
                self.getResponseValue(list: list)
                self.indicator.isAnimating = false
                self.tableView.reloadData()
                
                
            }
            else {
                print("API Error")
            }
        }
    }
    
    func getResponseValue (list: Any) {
        
        let response = list as! [[String: Any]]
        var small = [PaidRefundModel]()
        
        
        for res in response {
            
            let order = PaidRefundModel(order_id: "\(res["order_id"] ?? "")",
                                        customer_id: "\(res["customer_id"] ?? "")",
                                        merchant_id:"\(res["merchant_id"] ?? "")",
                                        order_date: "\(res["order_date"] ?? "")",
                                        order_time: "\(res["order_time"] ?? "")",
                                        amt: "\(res["amt"] ?? "")",
                                        cash_back_amt: "\(res["cash_back_amt"] ?? "")",
                                        cash_back_fee: "\(res["cash_back_fee"] ?? "")",
                                        refund_amount: "\(res["refund_amount"] ?? "")",
                                        is_online: "\(res["is_online"] ?? "")",
                                        orders_details: res["orders_details"],
                                        loyalty_point_earned: "",
                                        loyalty_point_spent: "")
            small.append(order)
        }
        print(response.count)
        if response.count == 0 {
            tableView.isHidden = false
            //      noOrderimage.isHidden = false
            //     noOrderLbl.isHidden = false
            //     orderDetailView.isHidden = true
            //     self.orderDetailHeight.constant = 0
        }
        else {
            tableView.isHidden = false
            //   orderDetailView.isHidden = false
            //   noOrderimage.isHidden = true
            //   noOrderLbl.isHidden = true
            //  self.orderDetailHeight.constant = 58
        }
      
        custOrderArr = small
        subcustOrderArray = small
        getOrderDetails(list: small)

    }
    
    func getOrderDetails(list: [PaidRefundModel]) {
        
        var small = [CustOrderDetails]()
        
        for order in list {
            
            let order_details = order.orders_details as? [[String: Any]] ?? [[:]]
            
            if order_details.count > 0 {
                let order_det = order_details[0]
                let order_details = CustOrderDetails(category_id: "\(order_det["category_id"] ?? "")",
                                                     name: "\(order_det["name"] ?? "")",
                                                     qty: "\(order_det["qty"] ?? "")",
                                                     price: "\(order_det["price"] ?? "")",
                                                     coupon_code: order_det["coupon_code"])
                small.append(order_details)
            }
            else {
                small.append(CustOrderDetails(category_id: "",
                                              name: "", qty: "",
                                              price: "", coupon_code: [:]))
            }
        }
        
        getCouponCode(list: small)
    }
    
    func getCouponCode(list: [CustOrderDetails]) {
        
        var small = [CustCouponCode]()
        
        for cupon in list {
            
            let res =  cupon.coupon_code as? [String: Any] ?? [:]
            
            
            let code =  CustCouponCode(coupon_code: "\(res["coupon_code"] ?? "")",
                                       coupon_code_amt: "\(res["coupon_code_amt"] ?? "")",
                                       loyalty_point_earned: "\(res["loyalty_point_earned"] ?? "")",
                                       loyalty_point_amt_earned: "\(res["loyalty_point_amt_earned"] ?? "")",
                                       loyalty_point_amt_spent: "\(res["loyalty_point_amt_spent"] ?? "")",
                                       loyalty_point_spent: "\(res["loyalty_point_spent"] ?? "")",
                                       store_credit_amt_spent: "\(res["store_credit_amt_spent"] ?? "")")
            
            small.append(code)
            
        }
      
       print(small)
        
        for co in 0..<small.count {
            
            custOrderArr[co].loyalty_point_earned = small[co].loyalty_point_earned
            custOrderArr[co].loyalty_point_spent = small[co].loyalty_point_spent
            subcustOrderArray[co].loyalty_point_earned = small[co].loyalty_point_earned
            subcustOrderArray[co].loyalty_point_spent = small[co].loyalty_point_spent
        }
        
       // couponCustArr = small
       
    }
    
    
    func getResponsepageValue(list: Any) {
        
        let response = list as! [[String: Any]]
        var small = [PaidRefundModel]()
       
        cust_page_arr = []
        
        for res in response {
            
            let order = PaidRefundModel(order_id: "\(res["order_id"] ?? "")",
                                        customer_id: "\(res["customer_id"] ?? "")",
                                        merchant_id:"\(res["merchant_id"] ?? "")",
                                        order_date: "\(res["order_date"] ?? "")",
                                        order_time: "\(res["order_time"] ?? "")",
                                        amt: "\(res["amt"] ?? "")",
                                        cash_back_amt: "\(res["cash_back_amt"] ?? "")",
                                        cash_back_fee: "\(res["cash_back_fee"] ?? "")",
                                        refund_amount: "\(res["refund_amount"] ?? "")",
                                        is_online: "\(res["is_online"] ?? "")",
                                        orders_details: res["orders_details"],
                                        loyalty_point_earned: "",
                                        loyalty_point_spent: "")
          
            
            if small.contains(where: {$0.order_id == order.order_id}) {
            }
            else {
                small.append(order)
            }
            
        }
        
        if small.count == 0 {
            page -= 1
        }
        else {
            cust_page_arr = small
            getOrderPageDetails(list: small)
            tableView.reloadData()

        }
        
    }
    
    func getOrderPageDetails(list: [PaidRefundModel]) {
        
        var small = [CustOrderDetails]()
        
        for order in list {
            
            let order_details = order.orders_details as? [[String: Any]] ?? [[:]]
            
            if order_details.count > 0 {
                let order_det = order_details[0]
                let order_details = CustOrderDetails(category_id: "\(order_det["category_id"] ?? "")",
                                                     name: "\(order_det["name"] ?? "")", qty: "\(order_det["qty"] ?? "")",
                                                     price: "\(order_det["price"] ?? "")", coupon_code: order_det["coupon_code"])
                small.append(order_details)
            }
            else {
                small.append(CustOrderDetails(category_id: "",
                                              name: "", qty: "",
                                              price: "", coupon_code: [:]))
            }
        }
        getCouponPageCode(list: small)
    }
    
    func getCouponPageCode(list: [CustOrderDetails]) {
        
        var small = [CustCouponCode]()
        
        for cupon in list {
            
            let res =  cupon.coupon_code as? [String: Any] ?? [:]
            
            
            let code =  CustCouponCode(coupon_code: "\(res["coupon_code"] ?? "")",
                                       coupon_code_amt: "\(res["coupon_code_amt"] ?? "")",
                                       loyalty_point_earned: "\(res["loyalty_point_earned"] ?? "")",
                                       loyalty_point_amt_earned: "\(res["loyalty_point_amt_earned"] ?? "")",
                                       loyalty_point_amt_spent: "\(res["loyalty_point_amt_spent"] ?? "")",
                                       loyalty_point_spent: "\(res["loyalty_point_spent"] ?? "")",
                                       store_credit_amt_spent: "\(res["store_credit_amt_spent"] ?? "")")
            
            small.append(code)
        }
    
        
        for co in 0..<small.count {
            
            cust_page_arr[co].loyalty_point_earned = small[co].loyalty_point_earned
            cust_page_arr[co].loyalty_point_spent = small[co].loyalty_point_spent
        }
        
        custOrderArr.append(contentsOf: cust_page_arr)
        subcustOrderArray.append(contentsOf: cust_page_arr)
    }
    
   
    @objc func addressViewClick() {
        if UserDefaults.standard.bool(forKey: "lock_edit_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            navigateToEditScreen(withFocus: .address)
        }
    }
    
    @objc func bdateViewClick() {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            navigateToEditScreen(withFocus: .dob)
        }
    }
    
    @objc func notesViewClick() {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            navigateToEditScreen(withFocus: .note)
        }
       
        
    }
    
    private func navigateToEditScreen(withFocus focus: FocusType) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomerAddEditViewController") as! CustomerAddEditViewController
        vc.focusType = focus
        vc.custObj = custObj
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    @objc func editBtnClick() {
        
        if UserDefaults.standard.bool(forKey: "lock_edit_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            performSegue(withIdentifier: "custInfoToEdit", sender: nil)
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(custObj?.name)
        
        if segue.identifier == "custInfoToEdit" {
            let vc = segue.destination as! CustomerAddEditViewController
            vc.custObj = custObj
        }
        else if segue.identifier == "toPaidOrder" {
            let vc = segue.destination as! InStoreNewDetailViewController
            vc.order_id = orderId
        }
        else if segue.identifier == "toRefundOrder" {
            let vc = segue.destination as! InStoreNewRefundViewController
            vc.refund_order_id = orderId
        }
        else if segue.identifier == "toNewOrder" {
            let vc = segue.destination as! NewOrderDetailVC
            vc.order_id = orderId
        }
        else if segue.identifier == "toCloseOrder" {
            let vc = segue.destination as! NewOrderRefundDetailVC
            vc.order_id = orderId
        }
    }
   
    @IBAction func searchBtnClick(_ sender: UIButton) {
        backBtn.alpha = 0
        customerLbl.alpha = 0
        searchBtn.alpha = 0
        homeBtn.alpha = 0
        searchBar.alpha = 1
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    
    @IBAction func blackBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func disableBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_disable_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            
            if sender.currentTitle == "Disable" {
                
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Disabled Customer ?",
                                                        preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped")
                }
                
                let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    
                    print("Ok button tapped")
                    self.disableCustomerAPi(isdisable: "1")
                    self.loadIndicator.isAnimating = false
                 
                }
                
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
            else {
                
                let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to Enabled Customer ?",
                                                        preferredStyle: .alert)
                
                
                let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped")
                }
                
                let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped")
                    self.disableCustomerAPi(isdisable: "0")
                    self.loadIndicator.isAnimating = false
                    
                }
                
                alertController.addAction(cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_delete_customer") {
            ToastClass.sharedToast.showToast(message: "Access Denied", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)

        }
        else {
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this Customer ?",
                                                    preferredStyle: .alert)
            let cancel = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped")
            }
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped")
                self.customerDeleteAPi()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.loadingIndicator.isAnimating = false
                }
            }
            
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
 
    func performSearch(searchText: String) {
        
        if searchText == "" {
            searching = false
        }
        else {
            searching = true
            searchCustOrderArray = subcustOrderArray.filter{ $0.order_id.lowercased().contains(searchText.lowercased())
                
            }
        }
        tableView.reloadData()
    }

    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableView.contentInset.bottom = contentInset.bottom
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        
    }
    
    private func setupUI() {
        
        if #available(iOS 13.0, *) {
            
            overrideUserInterfaceStyle = .light
        }
        
        disableBtn.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor
                .constraint(equalTo: disableBtn.centerXAnchor, constant: 65),
            loadIndicator.centerYAnchor
                .constraint(equalTo: disableBtn.centerYAnchor),
            loadIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadIndicator.heightAnchor
                .constraint(equalTo: self.loadIndicator.widthAnchor)
        ])
        
        
        deleteBtn.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: deleteBtn.centerXAnchor, constant: 65),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: deleteBtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor, constant: 0),
            indicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            indicator.widthAnchor
                .constraint(equalToConstant: 40),
            indicator.heightAnchor
                .constraint(equalTo: self.indicator.widthAnchor)
        ])
    }
    
//   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     
        if custOrderArr.count == 0 {
            
        }
        else {
            
            if searching {
                
            }
            else {
                
                if let visiblePaths = tableView.indexPathsForVisibleRows,
                   visiblePaths.contains([0, custOrderArr.count - 1]) {
                }
                else {
                    print(custOrderArr.count)
                    let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                    
                    page += 1
                    print(page)
                    
                    ApiCalls.sharedCall.getCustomerPaidRefundOrderList(merchant_id: id, customer_id: custId, order_id: "", order_status: "paid", is_refunded:isrefunded, page_no: page, limit: 10) { isSuccess, responseData in
                        
                        
                        if isSuccess {
                            
                            guard let order_list = responseData["result"] else {
                                return
                            }
                            
                            self.getResponsepageValue(list: order_list)
                        }
                        else {
                            print("Erorr")
                        }
                        
                    }
                }
            }
        }
    }
}

extension CustomerInfoVC : CustomerDelegate {
    
    func setNavigation(model: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddRemoveCustViewController") as! AddRemoveCustViewController
        vc.customerId = custId
        
        if model == 1 {
            vc.mode = "Add"
        }
        else {
            vc.mode = "Remove"
        }
        vc.custdelegate = self
        vc.addRemovePoints = p_Value
        self.present(vc, animated: true)
    }
}


extension CustomerInfoVC: AddRemoveCustDelegate {
    
    func setPointValue(totalPoint: String) {
        p_Value = totalPoint
        tableView.reloadData()
    }
}


extension CustomerInfoVC : UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.text = ""
        backBtn.alpha = 1
        customerLbl.alpha = 1
        searchBtn.alpha = 1
        homeBtn.alpha = 1
        searchBar.alpha = 0
        searching = false
        view.endEditing(true)
        performSearch(searchText: "")
        
    }
}

extension CustomerInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return custInfoArr.count
            
        } else {
            if custOrderArr.count == 0 {
                return 1
            }else {
                if searching {
                    return searchCustOrderArray.count
                }
                else {
                    return custOrderArr.count
                }
            }
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as!  profileCell
            
            cell.OrangeView.layer.cornerRadius = 10
            cell.OrangeView.backgroundColor = UIColor(hexString: "#FFF1D9")
            cell.storeCreditView.layer.cornerRadius = 10
            cell.storeCreditView.backgroundColor = UIColor(hexString: "#F2F2F2")
            cell.profileView.layer.cornerRadius = 76/2
            cell.profileView.backgroundColor = custViewbg
            cell.profileInitialsLbl.textColor = inicolor
            
            
            cell.profileInitialsLbl.text = initial.uppercased()
            
            let cust = custInfoArr[indexPath.row]
            
            cell.profileName.text = cust.name.capitalized
            
            cell.pontBalanceValueLbl.text = p_Value
            cell.storeCreditValueLbl.text = cust.total_store_credit
            cell.EmailVaslueLbl.text = cust.email
            
            if loyaltyPoint?.enable_loyalty == "0" {
                cell.OrangeView.isHidden = true
                cell.pointBalanceLbl.isHidden = true
                cell.pontBalanceValueLbl.isHidden = true
                cell.pointArrowBtn.isHidden = true
                cell.orangeViewHeight.constant = 0
            }
            else {
                cell.OrangeView.isHidden = false
                cell.pointBalanceLbl.isHidden = false
                cell.pontBalanceValueLbl.isHidden = false
                cell.pointArrowBtn.isHidden = false
                cell.orangeViewHeight.constant = 50
            }
            
            if isbirth {
                cell.DobValueLbl.text = bdate
                cell.DobValueLbl.textColor = .black
                
            }
            else {
                cell.DobValueLbl.text = "Add Birth Date"
                cell.DobValueLbl.textColor = .lightGray
                
            }
            let mobileNumber = cust.phone
            let formattedNumber = formatPhoneNumber(mobileNumber)
            cell.mobileValueLbl.text = formattedNumber
            
            
            if cust.address_line_1 != "<null>" && cust.address_line_1 != "" {
                var addressLine1 = cust.address_line_1
                
              
                if cust.city != "<null>" && cust.city != "" {
                    addressLine1 += ", \(cust.city)"
                }
              
                if cust.state != "<null>" && cust.state != "" {
                    addressLine1 += ", \(cust.state)"
                }
                
                cell.AddressValue.text = addressLine1
                cell.AddressValue.textColor = .black
            } else {
                cell.AddressValue.text = "Add Address"
                cell.AddressValue.textColor = .lightGray
            }
            
            let note = cust.note
            if  note != "" && note != "<null>" {
               
                cell.noteValueLbl.text = note
                cell.noteValueLbl.textColor = .black
                
            } else {
                cell.noteValueLbl.text = "Add Notes"
                cell.noteValueLbl.textColor = .lightGray
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(pointBalanceClick))
            tap.numberOfTapsRequired = 1
            cell.OrangeView.addGestureRecognizer(tap)
            cell.OrangeView.isUserInteractionEnabled = true
            
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(addressViewClick))
            tap1.numberOfTapsRequired = 1
            cell.addressView.addGestureRecognizer(tap1)
            cell.addressView.isUserInteractionEnabled = true
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(bdateViewClick))
            tap2.numberOfTapsRequired = 1
            cell.bdateView.addGestureRecognizer(tap2)
            cell.bdateView.isUserInteractionEnabled = true
            
            
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(notesViewClick))
            tap3.numberOfTapsRequired = 1
            cell.noteView.addGestureRecognizer(tap3)
            cell.noteView.isUserInteractionEnabled = true
            
            let tap4 = UITapGestureRecognizer(target: self, action: #selector(editBtnClick))
            tap4.numberOfTapsRequired = 1
            cell.editBtn.addGestureRecognizer(tap4)
            cell.editBtn.isUserInteractionEnabled = true
            
            
            return cell
        }
        else {
            
            if custOrderArr.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoOrderFoundCell") as! NoOrderFoundCell
                cell.noOrderlbl.text = "No Order Found"
                cell.noorderImage.image = UIImage(named: "no_order")
                return cell
            }
            else {
                
                if searching {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
                    
                    let custData = searchCustOrderArray[indexPath.row]
                    
                    cell.loyaltyPointEarnLbl.isHidden = false
                    cell.loyaltypointspentLbl.isHidden = false
                    cell.totalValueLbl.isHidden = false
                    
                    if refundSelected {
                        
                        if searchCustOrderArray[indexPath.row].refund_amount == "0.00" || searchCustOrderArray[indexPath.row].refund_amount == "0" || searchCustOrderArray[indexPath.row].refund_amount == "0.0" || searchCustOrderArray[indexPath.row].refund_amount == "-0.0" {
                            cell.loyaltyPointEarnLbl.isHidden = false
                            cell.loyaltyPointEarnLbl.text = ""
                        }
                        else {
                            let refundAmount = roundOf(item: searchCustOrderArray[indexPath.row].refund_amount)
                            cell.loyaltyPointEarnLbl.isHidden = false
                            cell.loyaltyPointEarnLbl.text = "-$\(String(format: "%.2f", refundAmount))"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#F55353")
                        }
                        cell.loyaltypointspentLbl.isHidden = true
                        cell.totalValueLbl.isHidden = true
                        cell.orderIdLbl.text = custData.order_id
                        
                        
                        let custD = ToastClass.sharedToast.setcustomerDateFormat(dateStr: custData.order_date)
                        cell.DatentimeLbl.text = "\(custD) - \(custData.order_time)"
                        
                    }
                    else {
                        
                        cell.totalValueLbl.text = "$\(searchCustOrderArray[indexPath.row].amt)"
                        
                        if searchCustOrderArray[indexPath.row].loyalty_point_earned == "0.00" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_earned == "-0.0" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_earned == "0" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_earned == "0.0" {
                            
                            cell.loyaltyPointEarnLbl.text = "-"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                            
                        }
                        else if searchCustOrderArray[indexPath.row].loyalty_point_earned.contains("E") {
                            cell.loyaltyPointEarnLbl.text = "-"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                        }
                        else {
                            let loyaltyPointsEarned = searchCustOrderArray[indexPath.row].loyalty_point_earned
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                            cell.loyaltyPointEarnLbl.text = "+\(String(format: "%.2f", roundOf(item: loyaltyPointsEarned)))"
                        }
                        
                        if searchCustOrderArray[indexPath.row].loyalty_point_spent == "0.00" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_spent == "- 0.00" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_spent == "0" ||
                            searchCustOrderArray[indexPath.row].loyalty_point_spent == "0.0"  {
                            
                            cell.loyaltypointspentLbl.text = ""
                        } else if searchCustOrderArray[indexPath.row].loyalty_point_spent.contains("E") {
                            cell.loyaltypointspentLbl.text = ""
                        }
                        else
                        {
                            let loyaltyspent = searchCustOrderArray[indexPath.row].loyalty_point_spent
                            cell.loyaltypointspentLbl.text = "-\(String(format: "%.2f", roundOf(item:loyaltyspent)))"
                        }
                        cell.orderIdLbl.text = custData.order_id
                        
                        let custD = ToastClass.sharedToast.setcustomerDateFormat(dateStr: custData.order_date)
                        cell.DatentimeLbl.text = "\(custD) - \(custData.order_time)"
                    }
                    cell.backgroundColor = UIColor.white
                    cell.selectionStyle = .none
                    return cell
                }
                
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
                    
                    let custData = custOrderArr[indexPath.row]
                    
                    cell.loyaltyPointEarnLbl.isHidden = false
                    cell.loyaltypointspentLbl.isHidden = false
                    cell.totalValueLbl.isHidden = false
                    
                    if refundSelected {
                        if custOrderArr[indexPath.row].refund_amount == "0.00" || custOrderArr[indexPath.row].refund_amount == "0" || custOrderArr[indexPath.row].refund_amount == "0.0" || custOrderArr[indexPath.row].refund_amount == "-0.0" {
                            cell.loyaltyPointEarnLbl.isHidden = false
                            cell.loyaltyPointEarnLbl.text = ""
                        }
                        else {
                            
                            let refundAmount = roundOf(item: custOrderArr[indexPath.row].refund_amount)
                            cell.loyaltyPointEarnLbl.isHidden = false
                            cell.loyaltyPointEarnLbl.text = "-$\(String(format: "%.2f", refundAmount))"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#F55353")
                        }
                        cell.loyaltypointspentLbl.isHidden = true
                        cell.totalValueLbl.isHidden = true
                        cell.orderIdLbl.text = custData.order_id
                        
                        let custD = ToastClass.sharedToast.setcustomerDateFormat(dateStr: custData.order_date)
                        cell.DatentimeLbl.text = "\(custD) - \(custData.order_time)"
                    }
                    else {
                        
                        cell.totalValueLbl.text = "$\(custOrderArr[indexPath.row].amt)"
                        
                        if custOrderArr[indexPath.row].loyalty_point_earned == "0.0" || custOrderArr[indexPath.row].loyalty_point_earned == "-0.0" || custOrderArr[indexPath.row].loyalty_point_earned == "0" || custOrderArr[indexPath.row].loyalty_point_earned == "0.00" {
                            cell.loyaltyPointEarnLbl.text = "-"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                            
                        }
                        else if custOrderArr[indexPath.row].loyalty_point_earned.contains("E") {
                            cell.loyaltyPointEarnLbl.text = "-"
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                        }
                        else {
                            let loyaltyPointsEarned = roundOf(item: custOrderArr[indexPath.row].loyalty_point_earned)
                            cell.loyaltyPointEarnLbl.textColor = UIColor(hexString: "#4CBC0C")
                            cell.loyaltyPointEarnLbl.text = "+\(String(format: "%.2f", loyaltyPointsEarned))"
                        }
                        
                        if custOrderArr[indexPath.row].loyalty_point_spent == "0.00" || custOrderArr[indexPath.row].loyalty_point_spent == "-0.00" || custOrderArr[indexPath.row].loyalty_point_spent == "0" || custOrderArr[indexPath.row].loyalty_point_spent == "0.0"  {
                            cell.loyaltypointspentLbl.text = ""
                        } else if custOrderArr[indexPath.row].loyalty_point_spent.contains("E") {
                            cell.loyaltypointspentLbl.text = ""
                        }
                        else
                        {
                            let loyaltyspent = roundOf(item: custOrderArr[indexPath.row].loyalty_point_spent)
                            cell.loyaltypointspentLbl.text = "-\(String(format: "%.2f", loyaltyspent))"
                        }
                        
                        cell.orderIdLbl.text = custData.order_id
                        print(custData.order_date)
                        let custD = ToastClass.sharedToast.setcustomerDateFormat(dateStr: custData.order_date)
                        cell.DatentimeLbl.text = "\(custD) - \(custData.order_time)"
                       
                    }
                    cell.backgroundColor = UIColor.white
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }
    }
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderViewCell")as? HeaderViewCell
            let headerTap1 = UITapGestureRecognizer(target: self, action: #selector(paidOrderBtnClick))
            headerTap1.numberOfTapsRequired = 1
            headerView?.paidOrderBtn.addGestureRecognizer(headerTap1)
            headerView?.paidOrderBtn.isUserInteractionEnabled = true
            
            let headerTap2 = UITapGestureRecognizer(target: self, action: #selector(refundOrderBtnClick))
            headerTap2.numberOfTapsRequired = 1
            headerView?.refundOrderBtn.addGestureRecognizer(headerTap2)
            headerView?.refundOrderBtn.isUserInteractionEnabled = true
            
            if refundSelected {
                
                headerView?.totalLbl.isHidden = true
                headerView?.refundView.backgroundColor =  UIColor(named: "SelectCat")
                headerView?.paidView.backgroundColor = UIColor.systemGray6
                headerView?.paidOrderBtn.setTitleColor(UIColor.black, for: .normal)
                headerView?.refundOrderBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
                headerView?.bonusPointLbl.text = "Total"
            }
            else {
                headerView?.paidView.backgroundColor =  UIColor(named: "SelectCat")
                headerView?.refundView.backgroundColor =  UIColor.systemGray6
                headerView?.refundOrderBtn.setTitleColor(UIColor.black, for: .normal)
                headerView?.paidOrderBtn.setTitleColor(UIColor(named: "SelectCat"), for: .normal)
                headerView?.bonusPointLbl.text = "Bonus Points"
                headerView?.totalLbl.isHidden = false
            }
            
            if custOrderArr.count == 0 {
                headerView?.orderDetailView.isHidden = true
                headerView?.orderDetailViewHeight.constant = 0
            }
            else {
                headerView?.orderDetailView.isHidden = false
                headerView?.orderDetailViewHeight.constant = 56
                
            }
            
            return headerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else if  section == 1 {
            return 100
        }
        else {
            
            return 0
        }
    }
    
    //didSelect
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        }
        
        else {
            orderId = custOrderArr[indexPath.row].order_id
            
            if refundSelected {
                
                if custOrderArr[indexPath.row].is_online == "1" {
                    
                    performSegue(withIdentifier: "toCloseOrder", sender: nil)
                }
                else  {
                    performSegue(withIdentifier: "toRefundOrder", sender: nil)
                }
                
            }
            else {
                if custOrderArr[indexPath.row].is_online == "1" {
                    performSegue(withIdentifier: "toNewOrder", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "toPaidOrder", sender: nil)
                }
            }
        }
    }
}

struct FindCustModel {
    
    let customer_id: String
    let f_name: String
    let l_name: String
    let name: String
    let email: String
    let phone: String
    let address_line_1: String
    let address_line_2: String
    let pincode: String
    let state: String
    let city: String
    let dob: String
    let note: String
    let is_disabled: String
    let total_loyalty_pts: String
    let total_store_credit: String
}

struct PaidRefundModel {
    
    var order_id: String
    var customer_id: String
    var merchant_id: String
    var order_date: String
    var order_time: String
    var amt: String
    var cash_back_amt: String
    var cash_back_fee: String
    var refund_amount: String
    var is_online: String
    var orders_details: Any
    var loyalty_point_earned: String
    var loyalty_point_spent: String
}

struct CustOrderDetails {
    
    var category_id: String
    var name: String
    var qty: String
    var price: String
    var coupon_code: Any
}

struct CustCouponCode {
    
    var coupon_code: String
    var coupon_code_amt: String
    var loyalty_point_earned: String
    var loyalty_point_amt_earned: String
    var loyalty_point_amt_spent: String
    var loyalty_point_spent: String
    var store_credit_amt_spent: String
}

struct LoyaltyProgramList {
    
    var merchant_id: String
    var admin_id: String
    var enable_loyalty: String
    var current_points: String
    var points_per_dollar: String
    var redemption_value: String
    var min_points_redemption: String
    
}

enum FocusType {
    case address
    case dob
    case note
}
