//
//  OrderOnlineViewController.swift
//  
//
//  Created by Jamaluddin Syed on 06/06/23.
//

import UIKit
import Alamofire
    
class OrderOnlineViewController: UIViewController {
  
    @IBOutlet weak var newOrders: UIButton!
    @IBOutlet weak var closedOrders: UIButton!
    @IBOutlet weak var incompleteOrders: UIButton!
    @IBOutlet weak var tableview: UITableView!

    @IBOutlet weak var underView: UIView!
    
    @IBOutlet weak var onlineStack: UIStackView!
    
    @IBOutlet weak var onlineStackHeight: NSLayoutConstraint!
    
    var responseValues = [String:Any]()
    var orderArray = [OnlineOrdersModel]()
    var ref_amt = [String]()
    var online_amt = [String]()
    var status_amt = [String]()
    
    let refresh = UIRefreshControl()
    
    var searching = false
    var subOnlineOrder = [OnlineOrdersModel]()
    var searchOnlineOrder = [OnlineOrdersModel]()
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var order_id: String?
    var refundOrder_id: String?
    var searchMode = false

    var name = ""
    var Refund_name = ""
    var live_status = ""
    var order_method = ""
    var coupon_code = ""
    var order_name = ""
   var page = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.showsVerticalScrollIndicator = false
        
        tableview.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print(orderArray.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        setupUI()
        tableview.isHidden = true
        underView.isHidden = true
        loadingIndicator.isAnimating = true
        subOnlineOrder = []
        searchOnlineOrder = []
        searching = false
      
        if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
            buttonShadow(tag: 1)
      
        }
        else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
            buttonShadow(tag: 2)
        }
        else {
            buttonShadow(tag: 3)
        }
    }
    
    func getApiCall(orderListType: String) {
        
       
        let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""

        var start_date = ""
        var end_date = ""
        var min_amt = ""
        var max_amt = ""
        var order_type = ""
        
        
        if orderListType == "new" {
            
            let start = UserDefaults.standard.string(forKey: "valid_order_new_start_date") ?? ""
            let end = UserDefaults.standard.string(forKey: "valid_order_new_end_date") ?? ""
            
            let min = UserDefaults.standard.string(forKey: "valid_order_new_min_amt") ?? ""
            let max = UserDefaults.standard.string(forKey: "valid_order_new_max_amt") ?? ""
            
            if UserDefaults.standard.string(forKey: "new_per_day") == "1" {
                start_date = start
                end_date = start
            }
            
            else {
                start_date = start
                end_date = end
            }
            
            min_amt = min
            max_amt = max
            
            order_type = UserDefaults.standard.string(forKey: "valid_order_new_order_type") ?? ""
        }
        
        else if orderListType == "closed" {
            
            let start = UserDefaults.standard.string(forKey: "valid_order_closed_start_date") ?? ""
            let end = UserDefaults.standard.string(forKey: "valid_order_closed_end_date") ?? ""
            
            let min = UserDefaults.standard.string(forKey: "valid_order_closed_min_amt") ?? ""
            let max = UserDefaults.standard.string(forKey: "valid_order_closed_max_amt") ?? ""
            
            if UserDefaults.standard.string(forKey: "closed_per_day") == "1" {
                start_date = start
                end_date = start
            }
            
            else {
                start_date = start
                end_date = end
            }
            
            min_amt = min
            max_amt = max
            
            order_type = UserDefaults.standard.string(forKey: "valid_order_closed_order_type") ?? ""

        }
        else {
            
            let start = UserDefaults.standard.string(forKey: "valid_order_failed_start_date") ?? ""
            let end = UserDefaults.standard.string(forKey: "valid_order_failed_end_date") ?? ""
            
            let min = UserDefaults.standard.string(forKey: "valid_order_failed_min_amt") ?? ""
            let max = UserDefaults.standard.string(forKey: "valid_order_failed_max_amt") ?? ""
            
            if UserDefaults.standard.string(forKey: "failed_per_day") == "1" {
                start_date = start
                end_date = start
            }
            
            else {
                start_date = start
                end_date = end
            }
            
            min_amt = min
            max_amt = max
            
            order_type = UserDefaults.standard.string(forKey: "valid_order_failed_order_type") ?? ""

        }
        
        var deli = ""
        var pick = ""
        
        if order_type == "" {
            deli = ""
            pick = ""
        }
        else if order_type == "pickup" {
            deli = ""
            pick = "pickup"
        }
        else {
            deli = "delivery"
            pick = ""
        }
        
        ApiCalls.sharedCall.getOrderList(merchant_id: merchant_id, order_list_type: orderListType,
                                         order_status: "", order_0: deli, order_1: pick,
                                         start_date: start_date, end_date: end_date, min_amt: min_amt,
                                         max_amt: max_amt, search_value: "", paid: 1,
                                         page_no: 1, limit: 10) { isSuccess, responseData in
            
           
            
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
                self.tableview.reloadData()
                if self.refresh.isRefreshing {
                    self.refresh.endRefreshing()
                }
            }
            else {
                
            }
        }
    }
   
    func getResponseValues(response: Any) {
        
        let responsevalues = response as! [[String:Any]]
        
        var orderArr = [OnlineOrdersModel]()
        
        for res in responsevalues {
            
            let order = OnlineOrdersModel(employee_id: "\(res["employee_id"] ?? "")",
                                          deliver_name: "\(res["deliver_name"] ?? "")",
                                          order_number: "\(res["order_number"] ?? "")",
                                          cvvResult: "\(res["cvvResult"] ?? "")",
                                          customer_type: "\(res["customer_type"] ?? "")",
                                          coupon_code:  "\(res["coupon_code"] ?? "")",
                                          tip: "\(res["tip"] ?? "")",
                                          delivery_phn: "\(res["delivery_phn"] ?? "")",
                                          payment_id: "\(res["payment_id"] ?? "")",
                                          live_status: "\(res["live_status"] ?? "")",
                                          order_status: "\(res["order_status"] ?? "")",
                                          refund_amount: "\(res["refund_amount"] ?? "")",
                                          show_status: "\(res["show_status"] ?? "")",
                                          order_method: "\(res["order_method"] ?? "")",
                                          amt: "\(res["amt"] ?? "")",
                                          customer_id: "\(res["customer_id"] ?? "")",
                                          cash_collected: "\(res["cash_collected"] ?? "")",
                                          print: "\(res["print"] ?? "")", name: "\(res["name"] ?? "")",
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
            
        }
        subOnlineOrder = orderArr
        searchOnlineOrder = orderArr
        orderArray = orderArr
        
        if orderArray.count == 0 {
        }
        else {
            
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                calNewAmt(order: orderArray)
                
            }
            else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                calCloseAmt(order: orderArray)
            }
            else {
                calNewAmt(order: orderArray)
            }
        }
    }
    
    func getResponseOnlinePageValues(response: Any) {
        
        let responsevalues = response as! [[String:Any]]
        
        var orderArr = [OnlineOrdersModel]()
        
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
            
            orderArr.append(order)
        }
        
        if orderArr.count == 0 {
            page -= 1
        }
        
        else {
            orderArray.append(contentsOf: orderArr)
            subOnlineOrder.append(contentsOf: orderArr)
            
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                calNewAmt(order: orderArray)
            }
            else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                calCloseAmt(order: orderArray)
            }
            else {
                calNewAmt(order: orderArray)
            }
            tableview.reloadData()

        }
    }
 
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.00
        let div = (100 * doub) / 100
        print(div)
        return div
    }

//    func calRefCloseAmt(order: [OnlineOrdersModel]) {
//        var smallClose = [String]()
//
//        for order_per in order {
//
//            let jsonString = order_per.coupon_code
//
//            guard let jsonData = jsonString.data(using: .utf8) else {
//                print("Failed to convert JSON string to data")
//                exit(0)
//            }
//
//
//            guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
//                print("Failed to parse JSON data into dictionary")
//                exit(0)
//            }
//
//            print(dictionary)
//
//            let c_code = Couponcode(coupon_code: "\(dictionary["coupon_code"] ?? "")",
//                                    coupon_code_amt: "\(dictionary["coupon_code_amt"] ?? "")",
//                                    loyalty_point_earned: "\(dictionary["loyalty_point_earned"] ?? "")",
//                                    loyalty_point_amt_earned: "\(dictionary["loyalty_point_amt_earned"] ?? "")",
//                                    loyalty_point_amt_spent: "\(dictionary["loyalty_point_amt_spent"] ?? "")",
//                                    loyalty_point_spent: "\(dictionary["loyalty_point_spent"] ?? "")",
//                                    store_credit_amt_spent: "\(dictionary["store_credit_amt_spent"] ?? "")")
//
//
//
//
//
//            let lp = roundOf(item: c_code.loyalty_point_amt_spent)
//            let am = roundOf(item: order_per.amt)
//            let refund_amt = roundOf(item: order_per.refund_amount)
//
//            let amt = am + lp
//            let refunded = amt - refund_amt
//            var newRefunded = String(format: "%.2f", refunded)
//
//            print(refunded)
//            if newRefunded == "0.01" || newRefunded == "0.02" || newRefunded == "-0.01" || newRefunded == "-0.02" {
//                smallClose.append(String(format: "%.2f", "0.00"))
//
//            }else {
//                smallClose.append(String(format: "%.2f", newRefunded))
//
//            }
//
//        }
//        ref_amt = smallClose
//    }
  
    func calCloseAmt(order: [OnlineOrdersModel]) {

        var smallClose = [String]()
        
        for order_per in order {
            
            let jsonString = order_per.coupon_code
            
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("Failed to convert JSON string to data")
                return
            }
            
           // let dictionary =  convertStringToDictionary(text: "\(jsonData)")
            
            guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Failed to parse JSON data into dictionary")
                return
            }
            
            print(dictionary)
            
            let c_code = Couponcode(coupon_code: "\(dictionary["coupon_code"] ?? "")",
                                    coupon_code_amt: "\(dictionary["coupon_code_amt"] ?? "")",
                                    loyalty_point_earned: "\(dictionary["loyalty_point_earned"] ?? "")",
                                    loyalty_point_amt_earned: "\(dictionary["loyalty_point_amt_earned"] ?? "")",
                                    loyalty_point_amt_spent: "\(dictionary["loyalty_point_amt_spent"] ?? "")",
                                    loyalty_point_spent: "\(dictionary["loyalty_point_spent"] ?? "")",
                                    store_credit_amt_spent: "\(dictionary["store_credit_amt_spent"] ?? "")")
            
            var refund_price = Double()
            
            if order_per.live_status == "Refunded" {
               
                let am = roundOf(item: order_per.amt)
                let ra = roundOf(item: order_per.refund_amount)
                
               // let refunded_loyalty  = roundOf(item: order_per.refunded_loyalty_amt)
          
                 refund_price =  am
                
                print("RR\(refund_price)")
            }
            else {
              
                let am = roundOf(item: order_per.amt)
                let ra = roundOf(item: order_per.refund_amount)
                let refunded_loyalty  = roundOf(item: order_per.refunded_loyalty_amt)
          
                let  price = am + refunded_loyalty
               
                refund_price = am - ra
                
                print("paid\(refund_price)")
            }
      
            let newRefunded = String(format: "%.2f", refund_price)
            if newRefunded == "0.01" || newRefunded == "0.02" || newRefunded == "-0.01"
                || newRefunded == "-0.02" || newRefunded == "-0.00" || newRefunded == "-0.00"   {
                smallClose.append("0.00")
                
            }
            else if newRefunded.contains(where: {$0 == "-"}) {
                let newref = newRefunded.dropFirst()
                print(newref)
                smallClose.append("\(newref)")
            }
            else {
                smallClose.append(newRefunded)
            }
    
//            if  handleZero(newRefunded: newRefunded) {
//                print(newRefunded)
//                smallClose.append(newRefunded)
//            }
//            else {
//                print(newRefunded)
//                smallClose.append("0.00")
//            }
            
           
        }
        ref_amt = smallClose
       
        print("online: \(ref_amt.count)")
        print("order: \(orderArray.count)")
//        print(ref_amt)
//        print(ref_amt)
        
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
    
    func handleZero(newRefunded : String) -> Bool   {
        print(newRefunded)
         let amtValue = Double(newRefunded) ?? 0.00
        print(amtValue)
        if  amtValue > 1.0{
            return true
            
        }
        else{
            return false
        }
    }
    
    func calNewAmt(order: [OnlineOrdersModel]) {
       
        var smallNew = [String]()
        
        for order_per in order {
            
            let jsonString = order_per.coupon_code
            
            if jsonString ==  "<null>"{
                
                let amt = roundOf(item: order_per.amt)
                let ra = roundOf(item: order_per.refund_amount)
                
                let final_amt = amt - ra
                print(final_amt)
                smallNew.append(String(format: "%.2f", final_amt))
                
            }
            else {
                
                guard let jsonData = jsonString.data(using: .utf8) else {
                    print("Failed to convert JSON string to data")
                    return
                }
                
                print(jsonData)
                
                guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    print("Failed to parse JSON data into dictionary")
                    return
                }
                
                print(dictionary)
                
                let c_code = Couponcode(coupon_code: "\(dictionary["coupon_code"] ?? "")",
                                        coupon_code_amt: "\(dictionary["coupon_code_amt"] ?? "")",
                                        loyalty_point_earned: "\(dictionary["loyalty_point_earned"] ?? "")",
                                        loyalty_point_amt_earned: "\(dictionary["loyalty_point_amt_earned"] ?? "")",
                                        loyalty_point_amt_spent: "\(dictionary["loyalty_point_amt_spent"] ?? "")",
                                        loyalty_point_spent: "\(dictionary["loyalty_point_spent"] ?? "")",
                                        store_credit_amt_spent: "\(dictionary["store_credit_amt_spent"] ?? "")")
        
                let amt = roundOf(item: order_per.amt)
                let refunded_loyalty =  roundOf(item:order_per.refunded_loyalty_amt)
                let ra = roundOf(item: order_per.refund_amount)
               
                
                
                let price = amt + refunded_loyalty
                let final_amt = price - ra
                
                smallNew.append(String(format: "%.2f", final_amt))
                
                
                
                // status_amt = smallNew
            }
            online_amt = smallNew
//            print("online: \(online_amt.count)")
//            print("order: \(orderArray.count)")
        }
        print("online: \(online_amt.count)")
        print("order: \(orderArray.count)")
    }
 
    
    func addViewShadow(view: UIView) {

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 4.0
        
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }

    
    @IBAction func orderTypeBtnClick(_ sender: UIButton) {
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        buttonShadow(tag: sender.tag)
        
    }
    
    @IBAction func AcceptedbtnClick(_ sender: UIButton) {
        
    }
   
    @objc func pullToRefresh() {
        
        tableview.isHidden = true
        loadingIndicator.isAnimating = true
        
        if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
            
            buttonShadow(tag: 1)
        }
        else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
            buttonShadow(tag: 2)
        }
        else {
            buttonShadow(tag: 3)
        }
    }
    
    @IBAction func statusBtn(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "OrderStatusViewController") as! OrderStatusViewController
            
            vc.live_status = orderArray[sender.tag].live_status
            vc.order_method = orderArray[sender.tag].order_method
            vc.order_id = orderArray[sender.tag].order_id
            vc.statusName = orderArray[sender.tag].name
            vc.number = orderArray[sender.tag].delivery_phn
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func buttonShadow(tag: Int) {
        
        for i in 1...3 {
            
            if i == tag {
                let button = view.viewWithTag(i) as! UIButton
                button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
                button.backgroundColor = UIColor.white
                button.layer.shadowOffset = .zero
                button.layer.shadowOpacity = 1.0
                button.layer.shadowRadius = 5.0
                button.layer.masksToBounds = false
                button.layer.cornerRadius = 4.0
                button.titleLabel?.textColor = .black
               
            }
            else {
                let button = view.viewWithTag(i) as! UIButton
                button.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
                button.layer.shadowOpacity = 0.0
                button.titleLabel?.textColor = .gray
                button.backgroundColor = UIColor.clear
            }
        }
        
        
        if tag == 1 {

            UserDefaults.standard.set("new", forKey: "modeOnlineSelected")
            
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_closed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_closed_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_failed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_failed_max_amt")
            
            
            
            page = 1
            getApiCall(orderListType: "new")
        }
        
        else if tag == 2 {
            
            UserDefaults.standard.set("closed", forKey: "modeOnlineSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_failed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_failed_max_amt")
            
            page = 1
            getApiCall(orderListType: "closed")
        }
        
        else {
            
            UserDefaults.standard.set("failed", forKey: "modeOnlineSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_closed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_closed_max_amt")
            
            page = 1
            getApiCall(orderListType: "failed")
            
        }
    }
       
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
            
//            let vc = segue.destination as! OrderRefundDetailViewController
//            vc.order_id = refundOrder_id
//            vc.modetail = "Delivery"
//            vc.merchName = Refund_name
//            vc.live_status = live_status
//            vc.order_method = order_method
            
            let vc = segue.destination as! NewOrderRefundDetailVC
            vc.order_id = refundOrder_id
        }
        
        else   {
            
//            let vc = segue.destination as! OrdersDetailViewController
//            vc.order_id = order_id
//            vc.modetail = "Delivery"
//            vc.merchName = name
//            vc.live_status = live_status
//            vc.order_method = order_method
//            vc.mode = "onlinevc"
            let vc = segue.destination as! NewOrderDetailVC
            vc.order_id = order_id
            
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
  
    func performSearch(searchText: String) {
        
        if searchMode {
            
            if searchText == "" {
                tableview.isHidden = true
                loadingIndicator.isAnimating = false
            }
            else {
                tableview.isHidden = true
                loadingIndicator.isAnimating = true
                
                if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                    searchApi(list_type: "new", order_status: "", search: searchText)
                }
                else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                    searchApi(list_type: "closed", order_status: "", search: searchText)
                }
                else {
                    searchApi(list_type: "failed", order_status: "", search: searchText)
                }
            }
        }
        
        else {
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                buttonShadow(tag: 1)
            }
            else if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                buttonShadow(tag: 2)
            }
            else {
                buttonShadow(tag: 3)
            }
        }
        tableview.reloadData()
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if searching {
        }
        
        else {
            
            if let visiblePaths = tableview.indexPathsForVisibleRows,
               visiblePaths.contains([0, orderArray.count - 1]) {
                
                let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                
                var start_date = ""
                var end_date = ""
                var min_amt = ""
                var max_amt = ""
                var order_type = ""
                var listType = ""
                
                
                if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                    
                    listType = "new"
                    
                    let start = UserDefaults.standard.string(forKey: "valid_order_new_start_date") ?? ""
                    let end = UserDefaults.standard.string(forKey: "valid_order_new_end_date") ?? ""
                    
                    let min = UserDefaults.standard.string(forKey: "valid_order_new_min_amt") ?? ""
                    let max = UserDefaults.standard.string(forKey: "valid_order_new_max_amt") ?? ""
                    
                    if UserDefaults.standard.string(forKey: "new_per_day") == "1" {
                        start_date = start
                        end_date = start
                    }
                    
                    else {
                        start_date = start
                        end_date = end
                    }
                    
                    min_amt = min
                    max_amt = max
                    
                    order_type = UserDefaults.standard.string(forKey: "valid_order_new_order_type") ?? ""
                }
                
                else if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                    
                    listType = "closed"
                    
                    let start = UserDefaults.standard.string(forKey: "valid_order_closed_start_date") ?? ""
                    let end = UserDefaults.standard.string(forKey: "valid_order_closed_end_date") ?? ""
                    
                    let min = UserDefaults.standard.string(forKey: "valid_order_closed_min_amt") ?? ""
                    let max = UserDefaults.standard.string(forKey: "valid_order_closed_max_amt") ?? ""
                    
                    if UserDefaults.standard.string(forKey: "closed_per_day") == "1" {
                        start_date = start
                        end_date = start
                    }
                    
                    else {
                        start_date = start
                        end_date = end
                    }
                    
                    min_amt = min
                    max_amt = max
                    
                    order_type = UserDefaults.standard.string(forKey: "valid_order_closed_order_type") ?? ""
                    
                }
                else {
                    
                    listType = "failed"
                    
                    
                    let start = UserDefaults.standard.string(forKey: "valid_order_failed_start_date") ?? ""
                    let end = UserDefaults.standard.string(forKey: "valid_order_failed_end_date") ?? ""
                    
                    let min = UserDefaults.standard.string(forKey: "valid_order_failed_min_amt") ?? ""
                    let max = UserDefaults.standard.string(forKey: "valid_order_failed_max_amt") ?? ""
                    
                    if UserDefaults.standard.string(forKey: "failed_per_day") == "1" {
                        start_date = start
                        end_date = start
                    }
                    
                    else {
                        start_date = start
                        end_date = end
                    }
                    
                    min_amt = min
                    max_amt = max
                    
                    order_type = UserDefaults.standard.string(forKey: "valid_order_failed_order_type") ?? ""
                    
                }
                
                var deli = ""
                var pick = ""
                
                if order_type == "" {
                    deli = ""
                    pick = ""
                }
                else if order_type == "pickup" {
                    deli = ""
                    pick = "pickup"
                }
                else {
                    deli = "delivery"
                    pick = ""
                }
                
                page += 1
                
                ApiCalls.sharedCall.getOrderList(merchant_id: merchant_id, order_list_type: listType,
                                                 order_status: "", order_0: deli, order_1: pick,
                                                 start_date: start_date, end_date: end_date, min_amt: min_amt,
                                                 max_amt: max_amt, search_value: "", paid: 1,
                                                 page_no: page, limit: 10) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        self.getResponseOnlinePageValues(response: responseData["result"])
                       
                    }else{
                        print("Api Error")
                    }
                }
            }
        }
    }

}

extension OrderOnlineViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchOnlineOrder.count
        }
        else
        {
            return orderArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searching {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderOnlineTableViewCell
            
            let order = searchOnlineOrder[indexPath.row]
            
            if order.deliver_name == "<null>" {
                cell.orderName.text = "Walk-In Customer"
            }
            else {
                cell.orderName.text = order.deliver_name
            }
            
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                
                cell.statusLbl.isHidden = false
                cell.ststusViewHeight.constant = 30
                cell.statusBtn.isHidden = false
                cell.statusPrice.isHidden = false
                cell.statusTopConstraint.constant = 10
                cell.statusBottomConstraint.constant = 10
                cell.statusView.layer.cornerRadius = 5
                cell.statusLbl.text = order.live_status
             
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
             
                cell.refundPriceLbl.isHidden = true
                
                if order.live_status == "Packed" {
                    cell.statusBtn.setImage(UIImage(named: "packing"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "packing")
                    
                }else if order.live_status == "Accepted" {
                    cell.statusBtn.setImage(UIImage(named: "verified"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "Accepted")
                    
                }else if order.live_status == "Ready" {
                    cell.statusBtn.setImage(UIImage(named: "Ready"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "Ready")
                }
                else if order.live_status == "Shipped" {
                    cell.statusBtn.setImage(UIImage(named: "shiped"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "shippedcolor")
                }
                print(online_amt)
                if orderArray.count == online_amt.count {
                    cell.statusPrice.text = "$\(online_amt[indexPath.row])"
                }
         
                if order.show_status == "0" {
                    cell.newOrderLbl.text = "New Order"
                    cell.newOrderLbl.textColor = UIColor.init(hexString: "#10C558")
                    
                    cell.shadowView.layer.cornerRadius = 8
                    cell.shadowView.layer.borderWidth = 1
                    cell.shadowView.layer.borderColor = UIColor.green.cgColor
                }
                
                else {
                    cell.newOrderLbl.text = "Open"
                    cell.newOrderLbl.textColor = .black
                    cell.shadowView.layer.cornerRadius = 8
                    cell.shadowView.layer.borderWidth = 1
                    cell.shadowView.layer.borderColor = UIColor(named: "orderonlineBorder")?.cgColor
                }
                
                if order.order_method == "pickup" ||  order.order_method == "Pickup"{
                    cell.deliveryLbl.textColor = UIColor(named: "deletBorder")
                }else {
                    cell.deliveryLbl.textColor = UIColor(named: "SelectCat")
                    
                }
                
                let orderMethod = order.order_method
                let firstChar = orderMethod.prefix(1).uppercased()
                let restOfString = orderMethod.dropFirst()
                cell.deliveryLbl.text = firstChar + restOfString
            }
            
            else if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                
                cell.statusLbl.isHidden = true
                cell.ststusViewHeight.constant = 0
                cell.statusBtn.isHidden = true
                cell.statusPrice.isHidden = true
                cell.statusTopConstraint.constant = 0
                cell.statusBottomConstraint.constant = 0
                cell.statusView.layer.cornerRadius = 0
                // cell.orderDateTime.text = order.merchant_time
                
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
                
                
                cell.refundPriceLbl.isHidden = false
                
                if orderArray.count == ref_amt.count {
                    cell.refundPriceLbl.text = "$\(ref_amt[indexPath.row])"
                }
                
                
                if order.live_status == "Refunded" {
                    cell.newOrderLbl.text = "Refunded"
                    cell.newOrderLbl.textColor = UIColor(named: "shippedcolor")
                }
                else if order.live_status == "Cancelled" {
                    cell.newOrderLbl.text = "Cancelled"
                    cell.newOrderLbl.textColor = UIColor(named: "deletBorder")
                }
                else if order.live_status == "Completed" {
                   
                    if order.payment_id == "Cash" {
                        cell.newOrderLbl.text = "Paid"
                        cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
                    }
                    else {
                        cell.newOrderLbl.text = "Completed"
                        cell.newOrderLbl.textColor = UIColor(named: "packing")
                    }
                }
                else {
                    
                }
                
//                if order.live_status == "Refunded" ||  order.live_status == "Cancelled" {
//                    cell.newOrderLbl.textColor = UIColor(named: "deletBorder")
//                }
//                else if order.live_status == "Completed" {
//                   
//                }
//                else {
//                    cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
//                }
                
                
                if order.order_method == "pickup" || order.order_method == "Pickup" {
                    cell.deliveryLbl.textColor = UIColor(named: "deletBorder")
                }else {
                    cell.deliveryLbl.textColor = UIColor(named: "SelectCat")
                    
                }
                
                let orderMethod = order.order_method
                let firstChar = orderMethod.prefix(1).uppercased()
                let restOfString = orderMethod.dropFirst()
                cell.deliveryLbl.text = firstChar + restOfString
                cell.shadowView.layer.borderColor = UIColor(named: "orderonlineBorder")?.cgColor
            }
            
            else {
                
                cell.statusLbl.isHidden = true
                cell.ststusViewHeight.constant = 0
                cell.statusBtn.isHidden = true
                cell.statusPrice.isHidden = true
                cell.statusTopConstraint.constant = 0
                cell.statusBottomConstraint.constant = 0
                cell.statusView.layer.cornerRadius = 0
                cell.orderDateTime.text = order.date_time
                cell.refundPriceLbl.isHidden = false
                print(online_amt)
                
                if orderArray.count == online_amt.count {
                    cell.refundPriceLbl.text = "$\(online_amt[indexPath.row])"
                }
                cell.newOrderLbl.text = order.live_status

                
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
                
                
//                if order.customer_type == "0" {
//                    cell.existCustLbl.text = "New "
//                    cell.existCustLbl.textColor = UIColor(named: "deletBorder")
//
//                }
//                else if order.customer_type == "1" {
//                    cell.existCustLbl.text = "Existing"
//                    cell.existCustLbl.textColor = .black
//                }
//                else {
//                    cell.existCustLbl.text = "New Guest"
//                    cell.existCustLbl.textColor =  UIColor(named: "deletBorder")
//                }
                
                
                if order.is_tried == "1"{
                    cell.newOrderLbl.text = "Failed payment"
                    cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
                }else{

                }
            }
            
            cell.mobileLbl.text = "Mobile:"
            cell.mobNumber.text = order.delivery_phn
            
            cell.orderIdLbl.text = "Order ID:"
            cell.orderIdValue.text = order.order_id
            cell.FirstDotView.layer.cornerRadius = 1.5
            cell.secondDotView.isHidden = true
            cell.statusViewBtn.tag = indexPath.row
            
            let orderMethod = order.order_method
            let firstChar = orderMethod.prefix(1).uppercased()
            let restOfString = orderMethod.dropFirst()
            cell.deliveryLbl.text = firstChar + restOfString
            
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
           
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderOnlineTableViewCell
            print(orderArray.count)
            let order = orderArray[indexPath.row]
            
            if order.deliver_name == "<null>" {
                cell.orderName.text = "Walk-In Customer"
            }
            else {
                cell.orderName.text = order.deliver_name
            }
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                
                
                cell.statusLbl.isHidden = false
                cell.ststusViewHeight.constant = 30
                cell.statusBtn.isHidden = false
                cell.statusPrice.isHidden = false
                cell.statusTopConstraint.constant = 10
                cell.statusBottomConstraint.constant = 10
                cell.statusView.layer.cornerRadius = 5
                cell.statusLbl.text = order.live_status
                
                
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
         
                cell.refundPriceLbl.isHidden = true
                
                if order.live_status == "Packed"{
                    
                    cell.statusBtn.setImage(UIImage(named: "packing"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "packing")
                    
                }else if order.live_status == "Accepted" {
                    
                    cell.statusBtn.setImage(UIImage(named: "verified"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "Accepted")
                    
                }else if order.live_status == "Ready" {
                    
                    cell.statusBtn.setImage(UIImage(named: "Ready"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "Ready")
                }
                else if order.live_status == "Shipped" {
                    
                    cell.statusBtn.setImage(UIImage(named: "shiped"), for: .normal)
                    cell.statusLbl.textColor = UIColor(named: "shippedcolor")
                }
                
                // cell.statusPrice.text = "$\(orderArray[indexPath.row].amt)"
               
                if orderArray.count == online_amt.count {
                    cell.statusPrice.text = "$\(online_amt[indexPath.row])"
                }
                
                //                if order.customer_type == "0" {
                //                    cell.existCustLbl.text = "New "
                //                    cell.existCustLbl.textColor = UIColor(named: "deletBorder")
                //
                //                }
                //                else if order.customer_type == "1" {
                //                    cell.existCustLbl.text = "Existing"
                //                    cell.existCustLbl.textColor = .black
                //                }
                //                else {
                //                    cell.existCustLbl.text = "New Guest"
                //                    cell.existCustLbl.textColor =  UIColor(named: "deletBorder")
                //                }
                
                if order.show_status == "0" {
                    cell.newOrderLbl.text = "New Order"
                    cell.newOrderLbl.textColor = UIColor.init(hexString: "#10C558")
                    
                    cell.shadowView.layer.cornerRadius = 8
                    cell.shadowView.layer.borderWidth = 1
                    cell.shadowView.layer.borderColor = UIColor.green.cgColor
                }
                else {
                    cell.newOrderLbl.text = "Open"
                    cell.newOrderLbl.textColor = .black
                    cell.shadowView.layer.cornerRadius = 8
                    cell.shadowView.layer.borderWidth = 1
                    cell.shadowView.layer.borderColor = UIColor(named: "orderonlineBorder")?.cgColor
                }
             
                if order.order_method == "pickup" || order.order_method == "Pickup" {
                    cell.deliveryLbl.textColor = UIColor(named: "deletBorder")
                }else {
                    cell.deliveryLbl.textColor = UIColor(named: "SelectCat")
                    
                }
                
                let orderMethod = order.order_method
                let firstChar = orderMethod.prefix(1).uppercased()
                let restOfString = orderMethod.dropFirst()
                cell.deliveryLbl.text = firstChar + restOfString
                
            }
            else if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                
                cell.statusLbl.isHidden = true
                cell.ststusViewHeight.constant = 0
                cell.statusBtn.isHidden = true
                cell.statusPrice.isHidden = true
                cell.statusTopConstraint.constant = 0
                cell.statusBottomConstraint.constant = 0
                cell.statusView.layer.cornerRadius = 0
                
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
                
                cell.refundPriceLbl.isHidden = false
                
                if orderArray.count == ref_amt.count {
                    cell.refundPriceLbl.text = "$\(ref_amt[indexPath.row])"
                }
                
               // cell.newOrderLbl.text = order.live_status
                
                //                if order.customer_type == "0" {
                //                    cell.existCustLbl.text = "New "
                //                    cell.existCustLbl.textColor = UIColor(named: "deletBorder")
                //                }
                //                else if order.customer_type == "1" {
                //                    cell.existCustLbl.text = "Existing"
                //                    cell.existCustLbl.textColor = .black
                //                }
                //                else {
                //                    cell.existCustLbl.text = "New Guest"
                //                    cell.existCustLbl.textColor =  UIColor(named: "deletBorder")
                //                }
    
                if order.live_status == "Refunded" {
                    cell.newOrderLbl.text = "Refunded"
                    cell.newOrderLbl.textColor = UIColor(named: "shippedcolor")
                }
                else if order.live_status == "Cancelled" {
                    cell.newOrderLbl.text = "Cancelled"
                    cell.newOrderLbl.textColor = UIColor(named: "deletBorder")
                }
                else if order.live_status == "Completed" ||  order.live_status == "Delivered" {
                    if order.order_method == "pickup" ||  order.order_method == "Pickup" {
                        if order.payment_id == "Cash" {
                            cell.newOrderLbl.text = "Paid"
                            cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
                        }
                        else {
                            cell.newOrderLbl.text = "Completed"
                            cell.newOrderLbl.textColor = UIColor(named: "packing")
                        }
                    }
                    else {
                        if order.payment_id == "Cash" {
                            cell.newOrderLbl.text = "Paid"
                            cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
                        }
                        else {
                            cell.newOrderLbl.text = "Delivered"
                            cell.newOrderLbl.textColor = UIColor(named: "packing")
                        }
                    }
                    
                }
     
                if order.order_method == "pickup" ||  order.order_method == "Pickup" {
                    cell.deliveryLbl.textColor = UIColor(named: "deletBorder")
                }else {
                    cell.deliveryLbl.textColor = UIColor(named: "SelectCat")
                }
       
                let orderMethod = order.order_method
                let firstChar = orderMethod.prefix(1).uppercased()
                let restOfString = orderMethod.dropFirst()
                cell.deliveryLbl.text = firstChar + restOfString
                cell.shadowView.layer.borderColor = UIColor(named: "orderonlineBorder")?.cgColor
            }
            
            else {
                
                cell.statusLbl.isHidden = true
                cell.ststusViewHeight.constant = 0
                cell.statusBtn.isHidden = true
                cell.statusPrice.isHidden = true
                cell.statusTopConstraint.constant = 0
                cell.statusBottomConstraint.constant = 0
                cell.statusView.layer.cornerRadius = 0
                cell.orderDateTime.text = order.date_time
                cell.refundPriceLbl.isHidden = false
                print(online_amt)
                
                if orderArray.count == online_amt.count {
                    cell.refundPriceLbl.text = "$\(online_amt[indexPath.row])"
                }
                cell.newOrderLbl.text = order.live_status
               
                let ordDate = ToastClass.sharedToast.setDateFormat(dateStr: order.date_time)
                cell.orderDateTime.text = ordDate
    
//                if order.customer_type == "0" {
//                    cell.existCustLbl.text = "New "
//                    cell.existCustLbl.textColor = UIColor(named: "deletBorder")
//
//                }
//                else if order.customer_type == "1" {
//                    cell.existCustLbl.text = "Existing"
//                    cell.existCustLbl.textColor = .black
//                }
//                else {
//                    cell.existCustLbl.text = "New Guest"
//                    cell.existCustLbl.textColor =  UIColor(named: "deletBorder")
//                }
                
                if order.is_tried == "1"{
                    cell.newOrderLbl.text = "Failed payment"
                    cell.newOrderLbl.textColor = UIColor(named: "Compeletetext")
                }else{
                    
                }
            }
            
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
            
            cell.mobileLbl.text = "Mobile:"
            cell.mobNumber.text = order.delivery_phn
            
            cell.orderIdLbl.text = "Order ID:"
            cell.orderIdValue.text = order.order_id
            cell.FirstDotView.layer.cornerRadius = 1.5
            cell.secondDotView.isHidden = true
            
            cell.statusViewBtn.tag = indexPath.row
            
            let orderMethod = order.order_method
            let firstChar = orderMethod.prefix(1).uppercased()
            let restOfString = orderMethod.dropFirst()
            cell.deliveryLbl.text = firstChar + restOfString
          
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
            
            let cell = tableview.cellForRow(at: indexPath) as! OrderOnlineTableViewCell
            
            refundOrder_id = cell.orderIdValue.text
            Refund_name =  cell.orderName.text ?? ""
            live_status =  cell.newOrderLbl.text ?? ""
            order_method = cell.deliveryLbl.text ?? ""
           
//            performSegue(withIdentifier: "toRefundDetail", sender: nil)
            performSegue(withIdentifier: "toNewRefundDetail", sender: nil)

        }
        
        else if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
            
            let cell = tableview.cellForRow(at: indexPath) as! OrderOnlineTableViewCell
            
            order_id = cell.orderIdValue.text
            name =  cell.orderName.text ?? ""
           
            print(name)
            live_status =  cell.statusLbl.text ?? ""
            order_method = cell.deliveryLbl.text ?? ""

//            performSegue(withIdentifier: "toStatus", sender: nil)
            
            performSegue(withIdentifier: "toNewOrderDetails", sender: nil)
        }
        
        else {
     
        }
    }
}


extension OrderOnlineViewController {
    
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


extension OrderOnlineViewController: OrderStatusViewControllerProtocol {
    func reloadTableView() {
        
        tableview.isHidden = false
        loadingIndicator.isAnimating = true
        
        if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
            
            buttonShadow(tag: 1)
        }
        tableview.reloadData()
       

    }
    

}
