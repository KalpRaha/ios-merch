//
//  OrderInStoreViewController.swift
//
//
//  Created by Kalpesh Rahate on 01/04/24.
//

import UIKit

class OrderInStoreViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var storeStack: UIStackView!
    
    @IBOutlet weak var instoreStackHeight: NSLayoutConstraint!
    
    var couponCodeArray = [CouponCode]()
    
    var responseValues = [String:Any]()
    var orderArray = [OnlineOrdersModel]()
    
    var order_id = ""
    
    var page = 0
    
    var searching = false
    var subInStoreOrder = [OnlineOrdersModel]()
    var searchInStoreOrder = [OnlineOrdersModel]()
    
    var searchMode = false
    
    let refresh = UIRefreshControl()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.showsVerticalScrollIndicator = false
        tableview.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        underView.isHidden = true
        subInStoreOrder = []
        searchInStoreOrder = []
        searching = false
        
        if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
            buttonShadow(tag: 1)
        }
        else {
            buttonShadow(tag: 2)
        }
    }
    
    
    @objc func pullToRefresh() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
            buttonShadow(tag: 1)
        }
        else {
            buttonShadow(tag: 2)
        }
    }
    
    func setupApi(order_status: String) {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        underView.isHidden = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        var start_date = ""
        var end_date = ""
        var min_amt = ""
        var max_amt = ""
        
        if order_status == "paid" {
            
            let start = UserDefaults.standard.string(forKey: "valid_order_paid_start_date") ?? ""
            let end = UserDefaults.standard.string(forKey: "valid_order_paid_end_date") ?? ""
            
            let min = UserDefaults.standard.string(forKey: "valid_order_paid_min_amt") ?? ""
            let max = UserDefaults.standard.string(forKey: "valid_order_paid_max_amt") ?? ""
            
            if UserDefaults.standard.string(forKey: "paid_per_day") == "1" {
                start_date = start
                end_date = start
            }
            
            else {
                start_date = start
                end_date = end
            }
            
            min_amt = min
            max_amt = max
        }
        else {
            
            let start = UserDefaults.standard.string(forKey: "valid_order_refund_start_date") ?? ""
            let end = UserDefaults.standard.string(forKey: "valid_order_refund_end_date") ?? ""
            
            let min = UserDefaults.standard.string(forKey: "valid_order_refund_min_amt") ?? ""
            let max = UserDefaults.standard.string(forKey: "valid_order_refund_max_amt") ?? ""
            
            if UserDefaults.standard.string(forKey: "refund_per_day") == "1" {
                start_date = start
                end_date = start
            }
            
            else {
                start_date = start
                end_date = end
            }
            
            min_amt = min
            max_amt = max
        }
        
        ApiCalls.sharedCall.getOrderList(merchant_id: id, order_list_type: "instore", order_status: order_status,
                                         order_0: "", order_1: "", start_date: start_date, end_date: end_date,
                                         min_amt: min_amt, max_amt: max_amt, search_value: "", paid: 1, page_no: 1,
                                         limit: 10) { isSuccess, responseData in
            
            
            
            if isSuccess {
                
                
                self.getResponseValues(response: responseData["result"])
                if self.orderArray.count == 0 {
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    self.underView.isHidden = false
                }
                else {
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.underView.isHidden = true
                    
                    self.tableview.reloadData()
                    if self.refresh.isRefreshing {
                        self.refresh.endRefreshing()
                    }
                }
                
            }else{
                print("Api Error")
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let responsevalues = response as! [[String:Any]]
        
        var orderArr = [OnlineOrdersModel]()
        var coupon_code = [[String:Any]]()
        
        for res in responsevalues {
            
            let order = OnlineOrdersModel(employee_id: "\(res["employee_id"] ?? "")", deliver_name: "\(res["deliver_name"] ?? "")",
                                          order_number: "\(res["order_number"] ?? "")", cvvResult: "\(res["cvvResult"] ?? "")",
                                          customer_type: "\(res["customer_type"] ?? "")", coupon_code: "\(res["coupon_code"] ?? "")", tip: "\(res["tip"] ?? "")",
                                          delivery_phn: "\(res["delivery_phn"] ?? "")", payment_id: "\(res["payment_id"] ?? "")",
                                          live_status: "\(res["live_status"] ?? "")", order_status: "\(res["order_status"] ?? "")",
                                          refund_amount: "\(res["refund_amount"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                          order_method: "\(res["order_method"] ?? "")", amt: "\(res["amt"] ?? "")",
                                          customer_id: "\(res["customer_id"] ?? "")",
                                          cash_collected: "\(res["cash_collected"] ?? "")",
                                          print: "\(res["print"] ?? "")",  name: "\(res["name"] ?? "")", customer_phone: "\(res["customer_phone"] ?? "")",
                                          admin_id: "\(res["admin_id"] ?? "")", merchant_id: "\(res["merchant_id"] ?? "")",
                                          merchant_time: "\(res["merchant_time"] ?? "")",
                                          cash_discounting: "\(res["cash_discounting"] ?? "")",
                                          kitchen_receipt: "\(res["kitchen_receipt"] ?? "")",
                                          is_tried: "\(res["is_tried"] ?? "")",
                                          date_time: "\(res["date_time"] ?? "")",
                                          id: "\(res["id"] ?? "")",
                                          order_id: "\(res["order_id"] ?? "")",
                                          m_status: "\(res["m_status"] ?? "")",
                                          cash_back_amt: "\(res["cash_back_amt"] ?? "")",
                                          cash_back_fee: "\(res["cash_back_fee"] ?? "")",
                                          refunded_loyalty_amt: "\(res["refunded_loyalty_amt"] ?? "")")
            
            if orderArr.contains(where: {$0.order_id == order.order_id}) {
            }
            else {
                orderArr.append(order)
                let dict = convertStringToDictionary(text: order.coupon_code)
                coupon_code.append(dict)
            }
        }
        
        orderArray = orderArr
        subInStoreOrder = orderArr
        searchInStoreOrder = orderArr
        
        var small_code = [CouponCode]()
        
        for coupon in coupon_code {
            
            let code = CouponCode(coupon_code: "\(coupon["coupon_code"] ?? "")",
                                  coupon_code_amt: "\(coupon["coupon_code_amt"] ?? "")",
                                  bogo_discount: "\(coupon["bogo_discount"] ?? "")",
                                  loyalty_point_earned: "\(coupon["loyalty_point_earned"] ?? "")",
                                  loyalty_point_amt_earned: "\(coupon["loyalty_point_amt_earned"] ?? "")",
                                  loyalty_point_amt_spent: "\(coupon["loyalty_point_amt_spent"] ?? "")",
                                  loyalty_point_spent: "\(coupon["loyalty_point_spent"] ?? "")",
                                  store_credit_amt_spent: "\(coupon["store_credit_amt_spent"] ?? "")",
                                  gift_card_number: "\(coupon["gift_card_number"] ?? "")",
                                  gift_card_amount: "\(coupon["gift_card_amount"] ?? "")",
                                  gift_card_balance: "\(coupon["gift_card_balance"] ?? "")",
                                  surcharge_label: "\(coupon["surcharge_label"] ?? "")",
                                  total_lottery_payout: "\(coupon["total_lottery_payout"] ?? "")",
                                  total_scratcher_payout: "\(coupon["total_scratcher_payout"] ?? "")",
                                  lottery_order_pay: "\(coupon["lottery_order_pay"] ?? "")",
                                  lottery_cash_pay: "\(coupon["lottery_cash_pay"] ?? "")",
                                  scratch_order_pay: "\(coupon["scratch_order_pay"] ?? "")",
                                  scratch_cash_pay: "\(coupon["scratch_cash_pay"] ?? "")",
                                  employee_name: "\(coupon["employee_name"] ?? "")")
            
            small_code.append(code)
            
        }
        couponCodeArray = small_code
    }
    
    func getResponsePageValues(response: Any) {
        
        let responsevalues = response as! [[String:Any]]
        
        var orderArr = [OnlineOrdersModel]()
        var smallcode = [[String:Any]]()
        
        for res in responsevalues {
            
            let order = OnlineOrdersModel(employee_id: "\(res["employee_id"] ?? "")", deliver_name: "\(res["deliver_name"] ?? "")",
                                          order_number: "\(res["order_number"] ?? "")", cvvResult: "\(res["cvvResult"] ?? "")",
                                          customer_type: "\(res["customer_type"] ?? "")", coupon_code: "\(res["coupon_code"] ?? "")", tip: "\(res["tip"] ?? "")",
                                          delivery_phn: "\(res["delivery_phn"] ?? "")", payment_id: "\(res["payment_id"] ?? "")",
                                          live_status: "\(res["live_status"] ?? "")", order_status: "\(res["order_status"] ?? "")",
                                          refund_amount: "\(res["refund_amount"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                          order_method: "\(res["order_method"] ?? "")", amt: "\(res["amt"] ?? "")",
                                          customer_id: "\(res["customer_id"] ?? "")",
                                          cash_collected: "\(res["cash_collected"] ?? "")",
                                          print: "\(res["print"] ?? "")",  name: "\(res["name"] ?? "")",
                                          customer_phone: "\(res["customer_phone"] ?? "")",
                                          admin_id: "\(res["admin_id"] ?? "")", merchant_id: "\(res["merchant_id"] ?? "")",
                                          merchant_time: "\(res["merchant_time"] ?? "")",
                                          cash_discounting: "\(res["cash_discounting"] ?? "")",
                                          kitchen_receipt: "\(res["kitchen_receipt"] ?? "")",
                                          is_tried: "\(res["is_tried"] ?? "")",
                                          date_time: "\(res["date_time"] ?? "")",
                                          id: "\(res["id"] ?? "")",
                                          order_id: "\(res["order_id"] ?? "")",
                                          m_status: "\(res["m_status"] ?? "")",
                                          cash_back_amt: "\(res["cash_back_amt"] ?? "")",
                                          cash_back_fee: "\(res["cash_back_fee"] ?? "")",
                                          refunded_loyalty_amt: "\(res["refunded_loyalty_amt"] ?? "")")
            
            orderArr.append(order)
            
            let dict = convertStringToDictionary(text: order.coupon_code)
            smallcode.append(dict)
        }
        
        if orderArr.count == 0 {
            page -= 1
        }
        
        else {
            orderArray.append(contentsOf: orderArr)
            subInStoreOrder.append(contentsOf: orderArr)
            
            for coupon in smallcode {
                
                let code = CouponCode(coupon_code: "\(coupon["coupon_code"] ?? "")",
                                      coupon_code_amt: "\(coupon["coupon_code_amt"] ?? "")",
                                      bogo_discount: "\(coupon["bogo_discount"] ?? "")",
                                      loyalty_point_earned: "\(coupon["loyalty_point_earned"] ?? "")",
                                      loyalty_point_amt_earned: "\(coupon["loyalty_point_amt_earned"] ?? "")",
                                      loyalty_point_amt_spent: "\(coupon["loyalty_point_amt_spent"] ?? "")",
                                      loyalty_point_spent: "\(coupon["loyalty_point_spent"] ?? "")",
                                      store_credit_amt_spent: "\(coupon["store_credit_amt_spent"] ?? "")",
                                      gift_card_number: "\(coupon["gift_card_number"] ?? "")",
                                      gift_card_amount: "\(coupon["gift_card_amount"] ?? "")",
                                      gift_card_balance: "\(coupon["gift_card_balance"] ?? "")",
                                      surcharge_label: "\(coupon["surcharge_label"] ?? "")",
                                      total_lottery_payout: "\(coupon["total_lottery_payout"] ?? "")",
                                      total_scratcher_payout: "\(coupon["total_scratcher_payout"] ?? "")",
                                      lottery_order_pay: "\(coupon["lottery_order_pay"] ?? "")",
                                      lottery_cash_pay: "\(coupon["lottery_cash_pay"] ?? "")",
                                      scratch_order_pay: "\(coupon["scratch_order_pay"] ?? "")",
                                      scratch_cash_pay: "\(coupon["scratch_cash_pay"] ?? "")",
                                      employee_name: "\(coupon["employee_name"] ?? "")")
                
                couponCodeArray.append(code)
               
            }
            
            tableview.reloadData()
        }
    }
    
    func searchApi(list_type: String, order_status: String, search: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        
        ApiCalls.sharedCall.getOrderListStore(merchant_id: id, order_list_type: list_type, order_status: order_status,
                                              paid: 1, search: search) { isSuccess, responseData in
            
            
            
            if isSuccess {
                
                self.getResponseValues(response: responseData["result"])
                
                if self.orderArray.count == 0 {
                    self.tableview.isHidden = true
                    self.loadingIndicator.isAnimating = false
                    self.underView.isHidden = false
                }
                else {
                    self.tableview.isHidden = false
                    self.loadingIndicator.isAnimating = false
                    self.underView.isHidden = true
                }
                
                if self.searchMode {
                    self.searching = true
                }
                else {
                    self.searching = false
                }
                self.tableview.reloadData()
                if self.refresh.isRefreshing {
                    self.refresh.endRefreshing()
                }
            }
            
            else{
                print("Api Error")
            }
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:Any] {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
    
    
    func addViewShadow(view: UIView) {
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 4.0
    }
    
    func calAmt(amt: String, cash_amt: String, cash_fee: String, gift_card: String) -> String {
        
        let amt_doub = roundOf(item: amt)
        let cash_amt_doub = roundOf(item: cash_amt)
        let cash_fee_doub = roundOf(item: cash_fee)
        let gift_doub = roundOf(item: gift_card)
        
        
        let total = amt_doub + cash_amt_doub + cash_fee_doub + gift_doub
        
        print(total)
        
        return String(total)
    }
    
    
    @IBAction func paidClick(_ sender: UIButton) {
        
        buttonShadow(tag: sender.tag)
        
    }
    
    func roundOf(item : String) -> Double {
        
        var itemDollar = ""
        
        if item.starts(with: "$") || item.starts(with: "-") {
            itemDollar = String(item.dropFirst())
            let doub = Double(itemDollar) ?? 0.00
            let div = (100 * doub) / 100
            return div
        }
        else {
            let doub = Double(item) ?? 0.00
            let div = (100 * doub) / 100
            print(div)
            return div
        }
    }
    
    
    func buttonShadow(tag: Int) {
        
        for i in 1...2 {
            
            if i == tag {
                let button = view.viewWithTag(i) as! UIButton
                button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                button.backgroundColor = UIColor.white
                button.layer.shadowOffset = .zero
                button.layer.shadowOpacity = 1.0
                button.layer.shadowRadius = 5.0
                button.layer.masksToBounds = false
                button.layer.cornerRadius = 4.0
                button.titleLabel?.textColor = UIColor.black
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
                button.titleLabel?.textColor = UIColor(red: 141.0/255.0, green: 141.0/255.0, blue: 141.0/255.0, alpha: 1.0)
                button.layer.shadowOpacity = 0.0
            }
        }
        
        if tag == 1 {
            UserDefaults.standard.set("paid", forKey: "modeSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_refund_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_refund_max_amt")
            
            page = 1
            setupApi(order_status: "paid")
            
        }
        else {
            UserDefaults.standard.set("refunded", forKey: "modeSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_paid_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_paid_max_amt")
            
            page = 1
            setupApi(order_status: "refunded")
        }
    }
    
    func performSearch(searchText: String) {
        
        if searchMode {
            
            if searchText == "" {
                tableview.isHidden = true
                loadingIndicator.isAnimating = false
            }
            else {
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                    searchApi(list_type: "instore", order_status: "paid", search: searchText)
                }
                else {
                    searchApi(list_type: "instore", order_status: "refunded", search: searchText)
                }
                
            }
        }
        else {
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                setupApi(order_status: "paid")
            }
            else {
                setupApi(order_status: "refunded")
            }
        }
        tableview.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStoreStatus" {
            
            let vc = segue.destination as! InStoreNewDetailViewController
            vc.order_id = order_id
        }
        
        else {
            
            let vc = segue.destination as! InStoreNewRefundViewController
            vc.refund_order_id = order_id
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableview.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableview.contentInset.bottom = contentInset.bottom
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableview.contentInset = contentInset
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        
        if searching {
            
        }
        
        else {
            
            
            if let visiblePaths = tableview.indexPathsForVisibleRows,
               visiblePaths.contains([0, orderArray.count - 1]) {
                
                let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                var start_date = ""
                var end_date = ""
                var min_amt = ""
                var max_amt = ""
                var status = ""
                
                if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                    
                    status = "paid"
                    
                    let start = UserDefaults.standard.string(forKey: "valid_order_paid_start_date") ?? ""
                    let end = UserDefaults.standard.string(forKey: "valid_order_paid_end_date") ?? ""
                    
                    let min = UserDefaults.standard.string(forKey: "valid_order_paid_min_amt") ?? ""
                    let max = UserDefaults.standard.string(forKey: "valid_order_paid_max_amt") ?? ""
                    
                    if UserDefaults.standard.string(forKey: "paid_per_day") == "1" {
                        start_date = start
                        end_date = start
                    }
                    
                    else {
                        start_date = start
                        end_date = end
                    }
                    
                    min_amt = min
                    max_amt = max
                }
                else {
                    
                    status = "refunded"
                    
                    let start = UserDefaults.standard.string(forKey: "valid_order_refund_start_date") ?? ""
                    let end = UserDefaults.standard.string(forKey: "valid_order_refund_end_date") ?? ""
                    
                    let min = UserDefaults.standard.string(forKey: "valid_order_refund_min_amt") ?? ""
                    let max = UserDefaults.standard.string(forKey: "valid_order_refund_max_amt") ?? ""
                    
                    if UserDefaults.standard.string(forKey: "refund_per_day") == "1" {
                        start_date = start
                        end_date = start
                    }
                    
                    else {
                        start_date = start
                        end_date = end
                    }
                    
                    min_amt = min
                    max_amt = max
                }
                
                page += 1
                
                ApiCalls.sharedCall.getOrderList(merchant_id: id, order_list_type: "instore",
                                                 order_status: status, order_0: "", order_1: "",
                                                 start_date: start_date, end_date: end_date,
                                                 min_amt: min_amt, max_amt: max_amt, search_value: "",
                                                 paid: 1, page_no: page,
                                                 limit: 10) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        self.getResponsePageValues(response: responseData["result"])
                    }else{
                        print("Api Error")
                    }
                }
            }
        }
    }
}

extension OrderInStoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchInStoreOrder.count
        }
        
        else {
            return orderArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "storecell", for: indexPath) as! OrderInStoreTableViewCell
            
            let order = searchInStoreOrder[indexPath.row]
            
            if order.deliver_name == "" && order.name == "" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "" && order.name == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "<null>" && order.name == "" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "<null>" && order.name == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else {
                
                if order.deliver_name == "" {
                    cell.inStoreName.text = order.name
                }
                else {
                    cell.inStoreName.text = order.deliver_name
                }
            }
            
            
            if order.delivery_phn == "" && order.customer_phone == "" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "" && order.customer_phone == "<null>" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "<null>" && order.customer_phone == "" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "<null>" && order.customer_phone == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else {
                
                if order.delivery_phn == "" {
                    cell.inStoreMobileValue.text = order.customer_phone
                }
                else {
                    cell.inStoreMobileValue.text = order.delivery_phn
                }
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: order.merchant_time) {
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
                let formattedDate = dateFormatter.string(from: date)
                cell.inStoreDate.text = formattedDate
            }
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                
                if order.refund_amount != "0.0" && order.refund_amount != "0.00" && order.refund_amount != "-0.0" &&
                    order.refund_amount != "-0.00" && order.refund_amount != "0" && order.refund_amount != "" {
                    
                    var total = 0.00
                    
                    let amt = order.amt
                    let ref_amt = order.refund_amount
                    let loyal_ref_amt = order.refunded_loyalty_amt
                    
                    let amt_doub = Double(amt) ?? 0.00
                    let ref_amt_doub = Double(ref_amt) ?? 0.00
                    let loyal_ref_amt_doub = Double(loyal_ref_amt) ?? 0.00
                    
                    let total_ref = amt_doub + loyal_ref_amt_doub
                    
                    if total_ref < ref_amt_doub {
                        total = ref_amt_doub - total_ref
                    }
                    else if total_ref >= ref_amt_doub {
                        total = total_ref - ref_amt_doub
                    }
                    
                    cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: "\(total)")))"
                    
                }
                else {
                    let points = couponCodeArray[indexPath.row]
                    
                    let amount = calAmt(amt: order.amt, cash_amt: order.cash_back_amt,
                                        cash_fee: order.cash_back_fee, gift_card: points.gift_card_amount)
                    
                    cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: amount)))"
                    //cell.empNameValueLbl.text = couponCodeArray[indexPath.row].employee_name
                }
            }
            else {
                let amount = calAmt(amt: order.amt, cash_amt: order.cash_back_amt,
                                    cash_fee: order.cash_back_fee, gift_card: "")
                
                cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: amount)))"
            }
            
            cell.inStoreMobileLbl.text = "Mobile No:"
            
            cell.inStoreOrderIdLbl.text = "Order ID:"
            cell.inStoreOrderIdValue.text = order.order_id
            cell.empLbl.text = "Emp Name:"
            cell.empNameValueLbl.text = couponCodeArray[indexPath.row].employee_name
            
            print(couponCodeArray[indexPath.row].employee_name)
            addViewShadow(view: cell.shadowView)
            cell.inStoreive.text = order.live_status.capitalized
            
            if order.payment_id == "Cash" {
                cell.inStorePayment.text = "Paid - Cash"
            }
            else if order.payment_id == "" {
                cell.inStorePayment.text = "Paid - Split Payment"
            }
            else {
                cell.inStorePayment.text = "Paid - Card Payment"
            }
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                
                cell.inStoreive.isHidden = true
                cell.dotView.isHidden = true
            }
            else {
                cell.inStoreive.isHidden = false
                cell.dotView.isHidden = false
            }
            
            cell.dotView.layer.cornerRadius = 1.5
            cell.shadowView.layer.cornerRadius = 8
            
            if UserDefaults.standard.bool(forKey: "order_number_enable") {
                
                cell.orderNumberLbl.isHidden = false
                cell.orderNumberValue.isHidden = false
                cell.orderNumberValue.text = order.order_number
            }
            else {
                
                cell.orderNumberLbl.isHidden = true
                cell.orderNumberValue.isHidden = true
                cell.orderNumberValue.text = ""
            }
            
            return cell
        }
        
        else {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "storecell", for: indexPath) as! OrderInStoreTableViewCell
            
            let order = orderArray[indexPath.row]
            
            if order.deliver_name == "" && order.name == "" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "" && order.name == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "<null>" && order.name == "" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else if order.deliver_name == "<null>" && order.name == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else {
                
                if order.deliver_name == "" {
                    cell.inStoreName.text = order.name
                }
                else {
                    cell.inStoreName.text = order.deliver_name
                }
            }
            
            
            if order.delivery_phn == "" && order.customer_phone == "" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "" && order.customer_phone == "<null>" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "<null>" && order.customer_phone == "" {
                cell.inStoreMobileValue.text = "xxxxxxxxxx"
            }
            
            else if order.delivery_phn == "<null>" && order.customer_phone == "<null>" {
                cell.inStoreName.text = "Walk-In Customer"
            }
            
            else {
                
                if order.delivery_phn == "" {
                    cell.inStoreMobileValue.text = order.customer_phone
                }
                else {
                    cell.inStoreMobileValue.text = order.delivery_phn
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: order.merchant_time) {
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
                let formattedDate = dateFormatter.string(from: date)
                cell.inStoreDate.text = formattedDate
            }
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                
                if order.refund_amount != "0.0" && order.refund_amount != "0.00" && order.refund_amount != "-0.0" &&
                    order.refund_amount != "-0.00" && order.refund_amount != "0" && order.refund_amount != "" {
                    
                    var total = 0.00
                    
                    let amt = order.amt
                    let ref_amt = order.refund_amount
                    let loyal_ref_amt = order.refunded_loyalty_amt
                    
                    let amt_doub = Double(amt) ?? 0.00
                    let ref_amt_doub = Double(ref_amt) ?? 0.00
                    let loyal_ref_amt_doub = Double(loyal_ref_amt) ?? 0.00
                    
                    let total_ref = amt_doub + loyal_ref_amt_doub
                    
                    if total_ref < ref_amt_doub {
                        total = ref_amt_doub - total_ref
                    }
                    else if total_ref >= ref_amt_doub {
                        total = total_ref - ref_amt_doub
                    }
                    
                    cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: "\(total)")))"
                    
                }
                else {
                    let points = couponCodeArray[indexPath.row]
                    
                    let amount = calAmt(amt: order.amt, cash_amt: order.cash_back_amt,
                                        cash_fee: order.cash_back_fee, gift_card: points.gift_card_amount)
                    
                    cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: amount)))"
                  
                }
            }
            else {
                let amount = calAmt(amt: order.amt, cash_amt: "",
                                    cash_fee: "", gift_card: "")
                
                cell.inStoreAmount.text = "$\(String(format: "%.02f", roundOf(item: amount)))"
            }
            
            cell.inStoreive.text = order.live_status
            
            if order.payment_id == "Cash" {
                cell.inStorePayment.text = "Paid - Cash"
            }
            else if order.payment_id == "" {
                cell.inStorePayment.text = "Paid - Split Payment"
            }
            else {
                cell.inStorePayment.text = "Paid - Card Payment"
            }
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                cell.inStoreive.isHidden = true
                cell.dotView.isHidden = true
            }
            else {
                cell.inStoreive.isHidden = false
                cell.dotView.isHidden = false
            }
            
            cell.inStoreMobileLbl.text = "Mobile No:"
            
            cell.inStoreOrderIdLbl.text = "Order ID:"
            cell.inStoreOrderIdValue.text = order.order_id
            cell.empNameValueLbl.text = couponCodeArray[indexPath.row].employee_name
           
            
            addViewShadow(view: cell.shadowView)
            cell.dotView.layer.cornerRadius = 1.5
            
            cell.shadowView.layer.cornerRadius = 8
            
            if UserDefaults.standard.bool(forKey: "order_number_enable") {
                
                cell.orderNumberLbl.isHidden = false
                cell.orderNumberValue.isHidden = false
                cell.orderNumberValue.text = order.order_number
                
            }
            else {
                
                cell.orderNumberLbl.isHidden = true
                cell.orderNumberValue.isHidden = true
                cell.orderNumberValue.text = ""
            }
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableview.cellForRow(at: indexPath) as! OrderInStoreTableViewCell
        
        order_id = cell.inStoreOrderIdValue.text ?? ""
        
        let modeSelected = UserDefaults.standard.string(forKey: "modeSelected") ?? ""
        
        if modeSelected == "paid" {
            performSegue(withIdentifier: "toStoreStatus", sender: nil)
        }
        
        else {
            performSegue(withIdentifier: "toRefundStatus", sender: nil)
        }
    }
}

extension OrderInStoreViewController {
    
    
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


//        var start_date = ""
//        var end_date = ""
//        var min_amt = ""
//        var max_amt = ""
//
//        if order_status == "paid" {
//
//            let start = UserDefaults.standard.string(forKey: "valid_order_paid_start_date") ?? ""
//            let end = UserDefaults.standard.string(forKey: "valid_order_paid_end_date") ?? ""
//
//            let min = UserDefaults.standard.string(forKey: "valid_order_paid_min_amt") ?? ""
//            let max = UserDefaults.standard.string(forKey: "valid_order_paid_max_amt") ?? ""
//
//            if UserDefaults.standard.string(forKey: "paid_per_day") == "1" {
//                start_date = start
//                end_date = start
//            }
//
//            else {
//                start_date = start
//                end_date = end
//            }
//
//            min_amt = min
//            max_amt = max
//        }
//        else {
//
//            let start = UserDefaults.standard.string(forKey: "valid_order_refund_start_date") ?? ""
//            let end = UserDefaults.standard.string(forKey: "valid_order_refund_end_date") ?? ""
//
//            let min = UserDefaults.standard.string(forKey: "valid_order_refund_min_amt") ?? ""
//            let max = UserDefaults.standard.string(forKey: "valid_order_refund_max_amt") ?? ""
//
//            if UserDefaults.standard.string(forKey: "refund_per_day") == "1" {
//                start_date = start
//                end_date = start
//            }
//
//            else {
//                start_date = start
//                end_date = end
//            }
//
//            min_amt = min
//            max_amt = max
//        }
