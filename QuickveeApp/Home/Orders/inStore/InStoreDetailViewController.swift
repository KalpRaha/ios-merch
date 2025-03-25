//
//  InStoreDetailViewController.swift
//
//
//  Created by Kalpesh Rahate on 01/04/24.
//

import UIKit

class InStoreDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var orderSumTable: UITableView!
    @IBOutlet weak var payTableView: UITableView!
    @IBOutlet weak var identityTable: UITableView!
    @IBOutlet weak var custTable: UITableView!
    @IBOutlet weak var payRefundItemsTable: UITableView!
    @IBOutlet weak var payRefundTable: UITableView!
    
    @IBOutlet weak var itemTableHeight: NSLayoutConstraint!
    @IBOutlet weak var orderSumHeight: NSLayoutConstraint!
    @IBOutlet weak var payTableHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var payRefundItemsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var payRefundTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var idTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var custHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderIdValue: UILabel!
    @IBOutlet weak var orderNumValue: UILabel!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    
    @IBOutlet weak var paymodeLbl: UILabel!
    @IBOutlet weak var payMode: UILabel!
    @IBOutlet weak var amtValue: UILabel!
    @IBOutlet weak var grandTotalValue: UILabel!
    
    @IBOutlet weak var customerOweValue: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var paymode_info: UIButton!
    
    
    @IBOutlet weak var instoreLbl: UILabel!
    @IBOutlet weak var instoreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instoreRefundViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundedLbl: UILabel!
    
    @IBOutlet weak var scroll: UIView!
    
    
    var orderSum = [String]()
    var orderSumValue = [String]()
    
    var paySum = [String]()
    var paySumValue = [String]()
    
    var order_id = ""
    
    var cartItems = [Cart_Data]()
    var cartRefundItems = [Cart_Data]()
    var splitDetail = [Split_Data]()
    var refundDetail = [[String:Any]]()
    var orderDetail: OrderDetails?
    var couponCode: CouponCode?
    var idDetail: IdentificationDetails?
    
    var payRefund = [[String]]()
    var payRefundValues = [[String]]()
    var payRefundDate = [String]()
    
    var idRefundName = [String]()
    var idRefundValue = [String]()
    
    var custName = ""
    var custAddr = ""
    var custNumber = ""
    var custMail = ""
    
    var id_exist = false
    var refund_exist = false
    var cust_exist = false
    var pax_details = ""
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        tableview.estimatedSectionHeaderHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        orderSumTable.estimatedSectionHeaderHeight = 0
        orderSumTable.estimatedSectionFooterHeight = 0
        payTableView.estimatedSectionHeaderHeight = 0
        payTableView.estimatedSectionFooterHeight = 0
        payRefundItemsTable.estimatedSectionHeaderHeight = 0
        payRefundItemsTable.estimatedSectionFooterHeight = 0
        payRefundTable.estimatedSectionFooterHeight = 0
        custTable.estimatedSectionFooterHeight = 0
        identityTable.estimatedSectionFooterHeight = 0
        
        loadingIndicator.isAnimating = true
        scroll.isHidden = true
        setupApi()
    }
    
    func calTotalPrice(onePrice: String, qty: String, discount: String) -> Double {
        
        let price = Double(onePrice) ?? 0.00
        let quant = Double(qty) ?? 0.00
        let dis = Double(discount) ?? 0.00
        
        let total = price * quant
        
        let dis_price = total - dis
        
        
        return roundOf(item: String(dis_price))
    }
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getOrderDetails(merchant_id: id, order_id: order_id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["result"] else {
                    return
                }
                
                self.getOrderResponse(response: list)
            }else{
                print("Api Error")
            }
        }
    }
    
    
    func getOrderResponse(response: Any) {
        
        let responsevalues = response as! [String:Any]
        
        //        guard let merch_list = responsevalues["merchant_details"] else {
        //            return
        //        }
        
        guard let order_list = responsevalues["order_detail"] else {
            return
        }
        
        guard let cart_list = responsevalues["cart_data"] else {
            return
        }
        
        if responsevalues["split_payments"] != nil {
            setSplitData(split: responsevalues["split_payments"])
        }
        
        setOrderData(order: order_list)
        setCartData(cart: cart_list)
        
        if responsevalues["id_card_detail"] == nil {
            id_exist = false
        }
        else {
          
            setIdData(id: responsevalues["id_card_detail"])
        }
        
        setCustData()
        
        if orderDetail?.is_refunded == "1" {
            refund_exist = true
            setRefundData(refund_data: responsevalues["refund_data"])
        }
        else {
            refund_exist = false
        }
        
        DispatchQueue.main.async {
            
            self.tableview.reloadData()
            self.orderSumTable.reloadData()
            self.payTableView.reloadData()
            self.identityTable.reloadData()
            self.payRefundTable.reloadData()
            self.custTable.reloadData()
            self.payRefundItemsTable.reloadData()
            
            self.itemTableHeight.constant = 130 * CGFloat(self.cartItems.count)
            self.orderSumHeight.constant = 39 * CGFloat(self.orderSum.count)
            self.payTableHeight.constant = 39 * CGFloat(self.paySum.count)
            self.payRefundTableHeight.constant = (54 * CGFloat(self.refundDetail.count)) + CGFloat(39 * self.getCountForHeight())
            
            if self.cartRefundItems.count == 0 {
                self.payRefundItemsHeight.constant = 0
            }
            else {
                self.payRefundItemsHeight.constant = 130 * CGFloat(self.cartRefundItems.count)
            }
            
            if self.cust_exist {
                let height = self.custTable.contentSize.height
                self.custHeight.constant = height + 64
            }
            else {
                self.custHeight.constant = 0
            }
            
            if self.id_exist {
                let height = self.identityTable.contentSize.height
                self.idTableHeight.constant = height + 64
            }
            else {
                self.idTableHeight.constant = 0
            }
            
            let cartHeight = 130 * CGFloat(self.cartItems.count)
            let refcartHeight = 130 * CGFloat(self.cartRefundItems.count)
            let orderHeight = 39 * CGFloat(self.orderSum.count)
            let payHeight = 39 * CGFloat(self.paySum.count)
            let payRefundHeight = self.payRefundTableHeight.constant
            
            let calHeight = cartHeight + refcartHeight + orderHeight + payHeight + payRefundHeight + self.custHeight.constant + self.idTableHeight.constant + self.instoreViewHeight.constant + self.instoreRefundViewHeight.constant + 400
            print(calHeight)
            self.scrollHeight.constant = calHeight
            
            self.loadingIndicator.isAnimating = false
            self.scroll.isHidden = false
        }
    }
    
    func setOrderData(order: Any) {
        
        let res = order as! [String:Any]
        
        let order = OrderDetails(id: "\(res["id"] ?? "")", order_id: "\(res["order_id"] ?? "")",
                                 order_number: "\(res["order_number"] ?? "")", customer_id: "\(res["customer_id"] ?? "")",
                                 merchant_id: "\(res["merchant_id"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
                                 order_status: "\(res["order_status"] ?? "")", date_time: "\(res["date_time"] ?? "")",
                                 payment_id: "\(res["payment_id"] ?? "")", pax_details: "\(res["pax_details"] ?? "")",
                                 card_num: "\(res["card_num"] ?? "")", payment_result: "\(res["payment_result"] ?? "")",
                                 cvvResult: "\(res["cvvResult"] ?? "")", failResult: "\(res["failResult"] ?? "")",
                                 card_type: "\(res["card_type"] ?? "")", customer_app_id: "\(res["customer_app_id"] ?? "")",
                                 discount: "\(res["discount"] ?? "")", tip: "\(res["tip"] ?? "")",
                                 tax: "\(res["tax"] ?? "")", other_taxes: "\(res["other_taxes"] ?? "")",
                                 other_taxes_desc: "\(res["other_taxes_desc"] ?? "")", other_taxes_rate_desc: "\(res["other_taxes_rate_desc"] ?? "")", change_due: "\(res["change_due"] ?? "")", con_fee: "\(res["con_fee"] ?? "")",
                                 del_fee: "\(res["del_fee"] ?? "")", subtotal: "\(res["subtotal"] ?? "")",
                                 tax_rate: "\(res["tax_rate"] ?? "")", coupon_code: "\(res["coupon_code"] ?? "")",
                                 amt: "\(res["amt"] ?? "")", billing_name: "\(res["billing_name"] ?? "")",
                                 billing_add: "\(res["billing_add"] ?? "")", deliver_name: "\(res["deliver_name"] ?? "")",
                                 delivery_addr: "\(res["delivery_addr"] ?? "")", delivery_phn: "\(res["delivery_phn"] ?? "")",
                                 email: "\(res["email"] ?? "")", m_status: "\(res["m_status"] ?? "")",
                                 mailtriggered: "\(res["mailtriggered"] ?? "")", smstriggerd: "\(res["smstriggerd"] ?? "")",
                                 order_method: "\(res["order_method"] ?? "")", is_online: "\(res["is_online"] ?? "")",
                                 merchant_time: "\(res["merchant_time"] ?? "")", customer_time: "\(res["customer_time"] ?? "")",
                                 order_time: "\(res["order_time"] ?? "")", mail_status: "\(res["mail_status"] ?? "")",
                                 is_tried: "\(res["is_tried"] ?? "")", kitchen_receipt: "\(res["kitchen_receipt"] ?? "")",
                                 print: "\(res["print"] ?? "")", cash_collected: "\(res["cash_collected"] ?? "")",
                                 driver_assigned: "\(res["driver_assigned"] ?? "")", show_status: "\(res["show_status"] ?? "")",
                                 is_future: "\(res["is_future"] ?? "")", is_refunded: "\(res["is_refunded"] ?? "")",
                                 is_partial_refund: "\(res["is_partial_refund"] ?? "")",
                                 refund_amount: "\(res["refund_amount"] ?? "")",
                                 is_split_payment: "\(res["is_split_payment"] ?? "")",
                                 tip_refund_amount: "\(res["tip_refund_amount"] ?? "")",
                                 cash_discounting: "\(res["cash_discounting"] ?? "")",
                                 cash_discounting_percentage: "\(res["cash_discounting_percentage"] ?? "")",
                                 cashdiscount_refund_amount: "\(res["cashdiscount_refund_amount"] ?? "")",
                                 is_outdoor: "\(res["is_outdoor"] ?? "")", employee_id: "\(res["employee_id"] ?? "")",
                                 dob: "\(res["dob"] ?? "")", adv_id: "\(res["adv_id"] ?? "")",
                                 shift_setting: "\(res["shift_setting"] ?? "")", is_loyality: "\(res["is_loyality"] ?? "")",
                                 is_store_credit: "\(res["is_store_credit"] ?? "")", is_gift_card: "\(res["is_gift_card"] ?? "")", sms_notify: "\(res["sms_notify"] ?? "")",
                                 live_status: "\(res["live_status"] ?? "")", customer_email: "\(res["customer_email"] ?? "")",
                                 customer_phone: "\(res["customer_phone"] ?? "")",
                                 total_loyalty_pts: "\(res["total_loyalty_pts"] ?? "")",
                                 total_store_credit: "\(res["total_store_credit"] ?? "")",
                                 cash_back_amt: "\(res["cash_back_amt"] ?? "")",
                                 cash_back_fee: "\(res["cash_back_fee"] ?? "")")
        
        orderDetail = order
        
        orderIdValue.text = orderDetail?.order_id
        
        let order_num = orderDetail?.order_number
        orderNumValue.text = order_num
        
        let cash_back_amt = orderDetail?.cash_back_amt ?? "0.00"
        let cash_back_fee = orderDetail?.cash_back_fee ?? "0.00"
        
        let coupon = orderDetail?.coupon_code ?? ""
        let coupon_dict = convertStringToDictionary(text: coupon)
        
        couponCode = CouponCode(coupon_code: "\(coupon_dict["coupon_code"] ?? "")",
                                coupon_code_amt: "\(coupon_dict["coupon_code_amt"] ?? "")",
                                loyalty_point_earned: "\(coupon_dict["loyalty_point_earned"] ?? "")",
                                loyalty_point_amt_earned: "\(coupon_dict["loyalty_point_amt_earned"] ?? "")",
                                loyalty_point_amt_spent: "\(coupon_dict["loyalty_point_amt_spent"] ?? "")",
                                loyalty_point_spent: "\(coupon_dict["loyalty_point_spent"] ?? "")",
                                store_credit_amt_spent: "\(coupon_dict["store_credit_amt_spent"] ?? "")",
                                gift_card_number: "\(coupon_dict["gift_card_number"] ?? "")",
                                gift_card_amount: "\(coupon_dict["gift_card_amount"] ?? "")",
                                gift_card_balance: "\(coupon_dict["gift_card_balance"] ?? "")",
                                surcharge_label: "\(coupon_dict["surcharge_label"] ?? "")",
                                total_lottery_payout: "\(coupon_dict["total_lottery_payout"] ?? "")",
                                total_scratcher_payout: "\(coupon_dict["total_scratcher_payout"] ?? "")",
                                lottery_order_pay: "\(coupon_dict["lottery_order_pay"] ?? "")",
                                lottery_cash_pay: "\(coupon_dict["lottery_cash_pay"] ?? "")",
                                scratch_order_pay: "\(coupon_dict["scratch_order_pay"] ?? "")",
                                scratch_cash_pay: "\(coupon_dict["scratch_cash_pay"] ?? "")",
                                employee_name: "\(coupon_dict["employee_name"] ?? "")")
        
        
        let amt = orderDetail?.amt ?? "0.00"
        let subtotal = orderDetail?.subtotal ?? "0.00"
        let ref_amt = orderDetail?.refund_amount ?? "0.00"
        
        
        customerOweValue.text = "$0.00"
        
        let split = orderDetail?.is_split_payment ?? ""
        let payment_id = orderDetail?.payment_id ?? ""
        let card_type = orderDetail?.card_type ?? ""
        
        
        if split == "1" {
            paymodeLbl.text = "Payment Mode"
            payMode.text = "Split Payment"
            paymode_info.isHidden = false
        }
        else if payment_id == "Cash" {
            paymodeLbl.text = "Payment Mode"
            payMode.text = payment_id
            paymode_info.isHidden = true
        }
        else {
            paymodeLbl.text = "Payment Id"
            payMode.text = payment_id
            paymode_info.isHidden = true
        }
        
        // couponcode
        let coupon_code = couponCode?.coupon_code ?? ""
        let coupon_code_amt = couponCode?.coupon_code_amt ?? "0.00"
        
        let points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let points_amt_earned = couponCode?.loyalty_point_amt_earned ?? "0.00"
        
        let points_amt_spent = couponCode?.loyalty_point_amt_spent ?? "0.00"
        let points_applied = couponCode?.loyalty_point_spent ?? "0.00"
        
        let store_credit = couponCode?.store_credit_amt_spent ?? "0.00"
        let gift_card_amount = couponCode?.gift_card_amount ?? "0.00"
        
        let nca_title = couponCode?.surcharge_label ?? ""
        
        let total_lottery_pay = couponCode?.total_lottery_payout ?? "0.00"
        
        let total_scratcher_payout = couponCode?.total_scratcher_payout ?? "0.00"
        
        let scratch_cash_pay = couponCode?.scratch_cash_pay ?? "0.00"
        
        var cash_value = ""
        
        if orderDetail?.is_refunded == "1" {
            
            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                let sub = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                cash_value = "\(sub)"
            }
            else {
                let amt_sub = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                cash_value = "\(amt_sub)"
            }
        }
        
        else {
            
            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                let amt_price = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                
            }
            else {
                let amt_price = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
                
                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
            }
        }
        
        //ordersumtable
        
        var smallOrderSum = ["Subtotal"]
        
        let sub = orderDetail?.subtotal ?? ""
        var smallOrderSumValue = ["\(sub)"]
        
        let discount = orderDetail?.discount ?? ""
        
        //        if discount != "0.0" && discount != "0.00" {
        //
        //            if coupon_code_amt != "" && coupon_code_amt != "0.00" && coupon_code_amt != "0.0" && coupon_code_amt != "0"  {
        //
        //                if coupon_code == "" {
        //                    smallOrderSum.append("Discount")
        //                }
        //                else {
        //                    smallOrderSum.append(coupon_code)
        //                }
        //                smallOrderSumValue.append("\(coupon_code_amt)")
        //            }
        //        }
        
        if coupon_code_amt != "0.0" && coupon_code_amt != "0.00" && coupon_code_amt != "-0.00"
            && coupon_code_amt != "-0.0" && coupon_code_amt != "0" && coupon_code_amt != ""  {
            
            if coupon_code != "Discount" && coupon_code != "" && coupon_code != "0.0"
                && coupon_code != "0.00" && coupon_code != "-0.00" && coupon_code != "-0.0" && coupon_code != "0" {
                smallOrderSum.append(coupon_code)
                smallOrderSumValue.append(coupon_code_amt)
            }
            
            else if coupon_code_amt == points_amt_spent || coupon_code_amt == store_credit {
                
            }
            
            else {
                smallOrderSum.append("Discounts")
                smallOrderSumValue.append(coupon_code_amt)
            }
        }
        
        let tip = orderDetail?.tip ?? ""
        
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
            smallOrderSum.append("Tip")
            smallOrderSumValue.append("\(tip)")
        }
        
        
        let cash_discount = orderDetail?.cash_discounting ?? ""
        let cash_per = orderDetail?.cash_discounting_percentage ?? ""
        
        if cash_discount != "0.0" && cash_discount != "0.00" && cash_discount != "-0.00" && cash_discount != "-0.0"
            && cash_discount != "0" && cash_discount != ""  {
            
            if split == "1" {
                
                var debit_count = 0
                var credit_count = 0
                var small_debit = [String]()
                var small_credit = [String]()
                
                for split_pay in splitDetail {
                    
                    if split_pay.cash_discounting_amount != "0" && split_pay.cash_discounting_amount != "0.0"
                        && split_pay.cash_discounting_amount != "0.00" {
                        
                        if split_pay.pay_type == "debit" {
                            if debit_count != 1 {
                                smallOrderSum.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                small_debit.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                debit_count = 1
                            }
                            
                        }
                        
                        else if split_pay.pay_type == "credit" {
                            if credit_count != 1 {
                                smallOrderSum.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                small_credit.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                credit_count = 1
                            }
                        }
                        else {
                        }
                    }
                }
                
                var debit_amt = [String]()
                var credit_amt = [String]()
                
                var mode_first = 0
                
                for split_pay in splitDetail {
                    
                    if split_pay.cash_discounting_amount != "0" && split_pay.cash_discounting_amount != "0.0"
                        && split_pay.cash_discounting_amount != "0.00" {
                        
                        if split_pay.pay_type == "credit" {
                            if mode_first == 0 {
                                mode_first = 1
                            }
                            credit_amt.append(split_pay.cash_discounting_amount)
                        }
                        
                        else if split_pay.pay_type == "debit" {
                            if mode_first == 0 {
                                mode_first = 2
                            }
                            debit_amt.append(split_pay.cash_discounting_amount)
                        }
                    }
                }
                
                var credit_card = Double()
                var debit_card = Double()
                
                if small_debit.count != 0 {
                    debit_card = calculateSplitCard(card: debit_amt)
                }
                
                if small_credit.count != 0 {
                    credit_card = calculateSplitCash(cash: credit_amt)
                }
                
                if small_debit.count == 0 {
                    smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                }
                
                else if small_credit.count == 0 {
                    smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                }
                
                else {
                    
                    if mode_first == 1 {
                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                    }
                    
                    else {
                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                    }
                }
            }
            
            else {
                
                if card_type.contains("Debit") || card_type.contains("debit") {
                    smallOrderSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
                    smallOrderSumValue.append("\(cash_discount)")
                }
                
                else if card_type.contains("Credit") || card_type.contains("credit"){
                    smallOrderSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
                    smallOrderSumValue.append("\(cash_discount)")
                }
                
                else {
                    
                }
            }
        }
        
        let tax = orderDetail?.tax ?? ""
        
        if tax != "0.0" && tax != "0.00" && tax != "-0.00" && tax != "-0.0" && tax != "0" && tax != "" {
            smallOrderSum.append("DefaultTax")
            smallOrderSumValue.append("\(tax)")
        }
        
        let other_taxes = orderDetail?.other_taxes_desc ?? ""
        
        if other_taxes != "0.0" && other_taxes != "0.00" && other_taxes != "-0.00" && other_taxes != "-0.0"
            && other_taxes != "0" && other_taxes != "" {
            let tax_desc = convertStringToDictionary(text: other_taxes)
            
            for (key, value) in tax_desc {
                smallOrderSum.append(key)
                smallOrderSumValue.append("\(value)")
            }
        }
        
        
        orderSum = smallOrderSum
        orderSumValue = smallOrderSumValue
        
        if orderDetail?.is_refunded == "1" {
            let amt = amtValue.text ?? "0.00"
            grandTotalValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt)")))"
        }
        else {
            calculateGrandTotal(pay: orderSumValue)
        }
        
        //paytable
        
        var smallPaySum = [String]()
        var smallPaySumValue = [String]()
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent)  {
            smallPaySum.append("Points Applied")
            smallPaySumValue.append("(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))")
        }
        
        if gift_card_amount != "0.0" && gift_card_amount != "0.00" && gift_card_amount != "-0.0" &&
            gift_card_amount != "-0.00" && gift_card_amount != "0" && gift_card_amount != "" && handleZero(value: gift_card_amount) {
            smallPaySum.append("Gift Card Applied")
            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: gift_card_amount)))")
        }
        
//        if total_lottery_pay != "0.0" && total_lottery_pay != "0.00" && total_lottery_pay != "-0.0" &&
//            total_lottery_pay != "-0.00" && total_lottery_pay != "0" && total_lottery_pay != "" && handleZero(value: total_lottery_pay) {
//            smallPaySum.append("Lottery Payout")
//            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: total_lottery_pay)))")
//        }
//
//        if total_scratcher_payout != "0.0" && total_scratcher_payout != "0.00" && total_scratcher_payout != "-0.0" &&
//            total_scratcher_payout != "-0.00" && total_scratcher_payout != "0" && total_scratcher_payout != "" && handleZero(value: total_scratcher_payout) {
//            smallPaySum.append("Scratcher Payout")
//            let scratcher_payout_doub = Double(total_scratcher_payout) ?? 0.00
//            let order_pay_doub = Double(scratch_cash_pay) ?? 0.00
//            if order_pay_doub < scratcher_payout_doub {
//                let amt_scratch = scratcher_payout_doub - order_pay_doub
//                smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: "\(amt_scratch)")))")
//            }
//            else {
//                smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: total_scratcher_payout)))")
//            }
//        }
        
        
        
        let isloyal = orderDetail?.is_loyality ?? "0"
        let iscredit = orderDetail?.is_store_credit ?? "0"
        let isgift = orderDetail?.is_gift_card ?? "0"
        
        
        if split == "1"  {
            
            var card_count = 0
            var cash_count = 0
            var food_count = 0
            var ecash_count = 0
            
            var small_card_cash = [String]()
            
            for split_way in splitDetail {
                
                if split_way.pay_type == "credit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        if food_count != 1 {
                            small_card_cash.append("Food EBT")
                            smallPaySum.append("Food EBT")
                            food_count = 1
                        }
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        if ecash_count != 1 {
                            small_card_cash.append("Cash EBT")
                            smallPaySum.append("Cash EBT")
                            ecash_count = 1
                        }
                    }
                    
                    else {
                        if card_count != 1 {
                            small_card_cash.append("Credit Card")
                            smallPaySum.append("Credit Card")
                            card_count = 1
                        }
                    }
                }
                
                else if split_way.pay_type == "debit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        if food_count != 1 {
                            small_card_cash.append("Food EBT")
                            smallPaySum.append("Food EBT")
                            food_count = 1
                        }
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        if ecash_count != 1 {
                            small_card_cash.append("Cash EBT")
                            smallPaySum.append("Cash EBT")
                            ecash_count = 1
                        }
                    }
                    
                    else {
                        if card_count != 1 {
                            small_card_cash.append("Credit Card")
                            smallPaySum.append("Credit Card")
                            card_count = 1
                        }
                    }
                }
                else {
                    if cash_count != 1 {
                        small_card_cash.append("Cash")
                        smallPaySum.append("Cash")
                        cash_count = 1
                    }
                }
            }
            
            var small_card = [String]()
            var small_cash = [String]()
            var small_food = [String]()
            var small_ecash = [String]()
            
            for split_way_info in splitDetail {
                
                if split_way_info.pay_type == "credit" {
                    
                    if split_way_info.card_type.contains("FoodEbt") {
                        small_food.append(split_way_info.pay_amount)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                    
                    else if split_way_info.card_type.contains("CashEbt") {
                        small_ecash.append(split_way_info.pay_amount)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                    
                    else {
                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
                        small_card.append(cred_tip)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                }
                else if split_way_info.pay_type == "debit" {
                    
                    if split_way_info.card_type.contains("FoodEbt") {
                        small_food.append(split_way_info.pay_amount)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                    
                    else if split_way_info.card_type.contains("CashEbt") {
                        small_ecash.append(split_way_info.pay_amount)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                    
                    else {
                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
                        small_card.append(cred_tip)
                        let pax = split_way_info.pax_details
                        if pax != "" {
                            pax_details += "\n\n\(pax)"
                        }
                    }
                }
                else  {
                    small_cash.append(split_way_info.pay_amount)
                }
            }
            
            var card = Double()
            var cash = Double()
            var food = Double()
            var ecash = Double()
            
            if small_card.count != 0 {
                card = calculateSplitCard(card: small_card)
            }
            
            if small_cash.count != 0 {
                cash = calculateSplitCash(cash: small_cash)
            }
            
            if small_food.count != 0 {
                food = calculateSplitEbt(cash: small_food)
            }
            
            if small_ecash.count != 0 {
                ecash = calculateSplitEbt(cash: small_ecash)
            }

            for small in small_card_cash {
                
                if small == "Cash" {
                    //    let cal_amt = calculateCashLottery(amt: "\(cash)")
                    smallPaySumValue.append(String(format: "%.02f", cash))
                }
                else if small == "Food EBT" {
                    //    let cal_amt = calculateCashLottery(amt: "\(food)")
                    smallPaySumValue.append(String(format: "%.02f", food))
                }
                else if small == "Cash EBT" {
                    //    let cal_amt = calculateCashLottery(amt: "\(ecash)")
                    smallPaySumValue.append(String(format: "%.02f", ecash))
                }
                else {
                    //   let cal_amt = calculateCashLottery(amt: "\(card)")
                    smallPaySumValue.append(String(format: "%.02f", card))
                }
                
            }
        }
        
        else if isloyal == "2" || iscredit == "2" || isgift == "2"
                    || isloyal == "1" || iscredit == "1" || isgift == "1" {
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        }
                    }
                }
            }
            
            else if isloyal == "1" && iscredit == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                          - roundOf(item: store_credit))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        }
                    }
                }
            }
            
            else if isloyal == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                    //                    let cal_amt = calculateCashLottery(amt: cred_amt)
                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                    }
                }
            }
            
            else if iscredit == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                    //                    let cal_amt = calculateCashLottery(amt: cred_amt)
                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    }
                }
            }
            
            else if isgift == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                    smallPaySumValue.append(cred_amt)
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        smallPaySumValue.append(cred_amt)
                    }
                }
            }
            
            else {
                
            }
        }
        
        else {
            if payment_id == "Cash" {
                
                if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != ""  {
                    smallPaySum.append("Cash")
                    //                    let cal_amt = calculateCashLottery(amt: amt)
                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                }
            }
            else {
                
                if card_type.contains("CashEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                    }
                }
                
                else if card_type.contains("FoodEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                    }
                }
                
                else {
                    
                    
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Credit Card")
                        let pax = orderDetail?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                    }
                }
            }
        }
        
        if cash_back_amt != "0.0" && cash_back_amt != "0.00" && cash_back_amt != "-0.0" && cash_back_amt != "-0.00" && cash_back_amt != "0" && cash_back_amt != "" && handleZero(value: cash_back_amt) {
            smallPaySum.append("Cashback Amount")
            smallPaySumValue.append(cash_back_amt)
        }
        
        if cash_back_fee != "0.0" && cash_back_fee != "0.00" && cash_back_fee != "-0.0" && cash_back_fee != "-0.00" && cash_back_fee != "0" && cash_back_fee != "" && handleZero(value: cash_back_fee) {
            smallPaySum.append("Cashback Fee")
            smallPaySumValue.append(cash_back_fee)
        }
        
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" && store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(value: store_credit) {
            smallPaySum.append("Store Credit")
            smallPaySumValue.append(store_credit)
        }
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00"
            && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
            smallPaySum.append("Points Awarded")
            smallPaySumValue.append(points_earned)
        }
        
        paySum = smallPaySum
        paySumValue = smallPaySumValue
        
    }
    
    
    func setCartData(cart: Any) {
        
        let smallres = cart as! [[String:Any]]
        var smallcart = [Cart_Data]()
        var smallrefcart = [Cart_Data]()
        
        for res in smallres {
            
            let cart = Cart_Data(line_item_id: "\(res["line_item_id"] ?? "")",
                                 variant_id: "\(res["variant_id"] ?? "")",
                                 category_id: "\(res["category_id"] ?? "")",
                                 cost_price: "\(res["cost_price"] ?? "")",
                                 name: "\(res["name"] ?? "")",
                                 is_bulk_price: "\(res["is_bulk_price"] ?? "")",
                                 bulk_price_id: "\(res["bulk_price_id"] ?? "")",
                                 qty: "\(res["qty"] ?? "")", note: "\(res["note"] ?? "")",
                                 userData: "\(res["userData"] ?? "")", taxRates: "\(res["taxRates"] ?? "")",
                                 default_tax_amount: "\(res["default_tax_amount"] ?? "")",
                                 other_taxes_amount: "\(res["other_taxes_amount"] ?? "")",
                                 other_taxes_desc: "\(res["other_taxes_desc"] ?? "")",
                                 is_refunded: "\(res["is_refunded"] ?? "")",
                                 refund_amount: "\(res["refund_amount"] ?? "")",
                                 refund_qty: "\(res["refund_qty"] ?? "")",
                                 id: "\(res["id"] ?? "")",
                                 img: "\(res["img"] ?? "")",
                                 price: "\(res["price"] ?? "")",
                                 discount_amt: "\(res["discount_amt"] ?? "")",
                                 coupon_code_amt: "\(res["coupon_code_amt"] ?? "")",
                                 is_lottery: "\(res["is_lottery"] ?? "")",
                                 discount_rate: "\(res["discount_rate"] ?? "")",
                                 adjust_price: "\(res["adjust_price"] ?? "")",
                                 use_point: "\(res["use_point"] ?? "")",
                                 earn_point: "\(res["earn_point"] ?? "")",
                                 lp_discount_amt: "\(res["lp_discount_amt"] ?? "")",
                                 other_taxes_rate_desc: "\(res["other_taxes_rate_desc"] ?? "")",
                                 other_taxes_refund_desc: "\(res["other_taxes_refund_desc"] ?? "")",
                                 default_tax_refund_amount: "\(res["default_tax_refund_amount"] ?? "")",
                                 other_taxes_refund_amount: "\(res["other_taxes_refund_amount"] ?? "")",
                                 inventory_price: "\(res["inventory_price"] ?? "")",
                                 vendor_id: "\(res["vendor_id"] ?? "")",
                                 vendor_name: "\(res["vendor_name"] ?? "")",
                                 brand_name: "\(res["brand_name"] ?? "")",
                                 brand_id: "\(res["brand_id"] ?? "")")
            
            if cart.is_refunded == "1" {
                if smallrefcart.count != 0 {
                    if smallrefcart.contains(where: { $0.note == cart.note }) {
                        let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                        let quantity = smallrefcart[index].refund_qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallrefcart[index].refund_qty = String(newQty)
                    }
                    else {
                        smallrefcart.append(cart)
                    }
                }
                else {
                    smallrefcart.append(cart)
                }
            }
            
            else if cart.is_refunded == "2" {
                if smallrefcart.count != 0 {
                    if smallrefcart.contains(where: { $0.note == cart.note }) {
                        let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                        let quantity = smallrefcart[index].refund_qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallrefcart[index].refund_qty = String(newQty)
                    }
                    else {
                        smallrefcart.append(cart)
                    }
                }
                else {
                    smallrefcart.append(cart)
                }
                
                if smallcart.count != 0 {
                    if smallcart.contains(where: { $0.note == cart.note }) {
                        let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                        let quantity = smallcart[index].qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcart[index].qty = String(newQty)
                    }
                    else {
                        smallcart.append(cart)
                    }
                }
                else {
                    smallcart.append(cart)
                }
            }
            
            else {
                if smallcart.count != 0 {
                    if smallcart.contains(where: { $0.note == cart.note }) {
                        let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                        let quantity = smallcart[index].qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcart[index].qty = String(newQty)
                    }
                    else {
                        smallcart.append(cart)
                    }
                }
                else {
                    smallcart.append(cart)
                }
            }
        }
        print(smallcart.count)
        print(smallrefcart.count)
        cartItems = smallcart
        cartRefundItems = smallrefcart
        
        if cartRefundItems.count == 0 {
            instoreRefundViewHeight.constant = 0
            refundedLbl.text = ""
            instoreViewHeight.constant = 50
            instoreLbl.text = "In-Store Order"
        }
        
        else if cartItems.count == 0 {
            instoreViewHeight.constant = 0
            instoreLbl.text = ""
            instoreRefundViewHeight.constant = 50
            refundedLbl.text = "Refunded Items"
        }
        else {
            instoreRefundViewHeight.constant = 50
            refundedLbl.text = "Refunded Items"
            instoreViewHeight.constant = 50
            instoreLbl.text = "In-Store Order"
        }
        
        
        
        let itemCounts = cartItems.count + cartRefundItems.count
        
        if itemCounts == 1 {
            itemCount.text = "(\(itemCounts) item)"
        }
        else {
            itemCount.text = "(\(itemCounts) items)"
        }
    }
    
    
    func setSplitData(split: Any) {
        
        let split_data = split as! [[String:Any]]
        var smallSplit = [Split_Data]()
        
        for pay in split_data {
            
            let split_pay = Split_Data(id: "\(pay["id"] ?? "")", order_id: "\(pay["order_id"] ?? "")",
                                       merchant_id: "\(pay["merchant_id"] ?? "")", pay_count: "\(pay["pay_count"] ?? "")",
                                       pay_type: "\(pay["pay_type"] ?? "")", pay_amount: "\(pay["pay_amount"] ?? "")",
                                       remaining_amount: "\(pay["remaining_amount"] ?? "")",
                                       cash_discounting_amount: "\(pay["cash_discounting_amount"] ?? "")",
                                       cash_discounting_percentage: "\(pay["cash_discounting_percentage"] ?? "")",
                                       cash_back_amt: "\(pay["cash_back_amt"] ?? "")",
                                       cash_back_fee: "\(pay["cash_back_fee"] ?? "")",
                                       payment_id: "\(pay["payment_id"] ?? "")", tip: "\(pay["tip"] ?? "")",
                                       pax_details: "\(pay["pax_details"] ?? "")",
                                       card_type: "\(pay["card_type"] ?? "")", last_four_digit: "\(pay["last_four_digit"] ?? "")",
                                       created_date_time: "\(pay["created_date_time"] ?? "")", adv_id: "\(pay["adv_id"] ?? "")",
                                       split_by_emp: "\(pay["split_by_emp"] ?? "")", shift_setting: "\(pay["shift_setting"] ?? "")")
            
            smallSplit.append(split_pay)
        }
        splitDetail = smallSplit
    }
    
    func setCustData() {
        
        if orderDetail?.billing_name == "" && orderDetail?.deliver_name == ""  {
            custName = "Walk-In Customer"
        }
        else if orderDetail?.billing_name == "<null>" && orderDetail?.deliver_name == "<null>" {
            custName = "Walk-In Customer"
        }
        
        else if orderDetail?.billing_name == "" && orderDetail?.deliver_name == "<null>" {
            custName = "Walk-In Customer"
        }
        
        else if orderDetail?.billing_name == "<null>" && orderDetail?.deliver_name == "" {
            custName = "Walk-In Customer"
        }
        else if orderDetail?.billing_name == "" {
            custName = orderDetail?.deliver_name ?? ""
        }
        else if orderDetail?.deliver_name == "" {
            custName = orderDetail?.billing_name ?? ""
        }
        else {
            custName = orderDetail?.billing_name ?? ""
        }
        
        custAddr = orderDetail?.delivery_addr ?? ""
        
        if orderDetail?.delivery_phn == "" && orderDetail?.customer_phone == "" {
            cust_exist = false
            custNumber = ""
            custMail = ""
        }
        
        else if orderDetail?.delivery_phn == "" && orderDetail?.customer_phone == "<null>" {
            cust_exist = false
            custNumber = ""
            custMail = ""
        }
        
        else if orderDetail?.delivery_phn == "<null>" && orderDetail?.customer_phone == "" {
            cust_exist = false
            custNumber = ""
            custMail = ""
        }
        
        else if orderDetail?.delivery_phn == "<null>" && orderDetail?.customer_phone == "<null>" {
            cust_exist = false
            custNumber = ""
            custMail = ""
        }
        
        else {
            
            if orderDetail?.delivery_phn == "" {
                custNumber = orderDetail?.customer_phone ?? ""
                cust_exist = true
                
                if orderDetail?.email == "" {
                    custMail = orderDetail?.customer_email ?? ""
                }
                else {
                    custMail = orderDetail?.email ?? ""
                }
            }
            else {
                custNumber = orderDetail?.delivery_phn ?? ""
                cust_exist = true
                
                if orderDetail?.email == "" {
                    custMail = orderDetail?.customer_email ?? ""
                }
                else {
                    custMail = orderDetail?.email ?? ""
                }
            }
        }
    }
    
    func setRefundData(refund_data: Any) {
        
        let refund = refund_data as! [[String:Any]]
        refundDetail = refund
        
        var smallRefund = [[String]]()
        var smallRefundVal = [[String]]()
        var smallDate = [String]()
        
        for ref in refund {
            
            let refund_pay = Refund_Data(refund_id: "\(ref["refund_id"] ?? "")",
                                         refunded_by_emp: "\(ref["refunded_by_emp"] ?? "")",
                                         amount: "\(ref["amount"] ?? "")",
                                         credit_amt: "\(ref["credit_amt"] ?? "")",
                                         debit_amt: "\(ref["debit_amt"] ?? "")",
                                         cash_amt: "\(ref["cash_amt"] ?? "")",
                                         loyalty_point_amt: "\(ref["loyalty_point_amt"] ?? "")",
                                         store_credit_amt: "\(ref["store_credit_amt"] ?? "")",
                                         giftcard_amt: "\(ref["giftcard_amt"] ?? "")",
                                         reason: "\(ref["reason"] ?? "")",
                                         created_at: "\(ref["created_at"] ?? "")",
                                         nca_amt: "\(ref["nca_amt"] ?? "")",
                                         tip_amt: "\(ref["tip_amt"] ?? "")",
                                         credit_refund_tax: "\(ref["credit_refund_tax"] ?? "")",
                                         debit_refund_tax: "\(ref["debit_refund_tax"] ?? "")",
                                         cash_refund_tax: "\(ref["cash_refund_tax"] ?? "")",
                                         store_credit_refund_tax: "\(ref["store_credit_refund_tax"] ?? "")",
                                         loyality_refund_tax: "\(ref["loyality_refund_tax"] ?? "")",
                                         gift_card_refund_tax: "\(ref["gift_card_refund_tax"] ?? "")",
                                         default_tax_rate: "\(ref["default_tax_rate"] ?? "")",
                                         other_tax_rate_desc: "\(ref["other_tax_rate_desc"] ?? "")",
                                         default_tax_refund_amount: "\(ref["default_tax_refund_amount"] ?? "")",
                                         other_taxes_refund_amount: "\(ref["other_taxes_refund_amount"] ?? "")",
                                         other_taxes_refund_desc: "\(ref["other_taxes_refund_desc"] ?? "")",
                                         reward_loyalty_refund_amt: "\(ref["reward_loyalty_refund_amt"] ?? "")",
                                         reward_loyalty_refund_point: "\(ref["reward_loyalty_refund_point"] ?? "")",
                                         refund_pax_details: "\(ref["refund_pax_details"] ?? "")",
                                         card_type: "\(ref["card_type"] ?? "")")
            
            let amt = refund_pay.amount
            let card_pay = refund_pay.debit_amt
            let cash_pay = refund_pay.cash_amt
            let loyalty_amt = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
            let refund_reason = refund_pay.reason
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
            let gift_card = refund_pay.giftcard_amt
            let nca_amt = refund_pay.nca_amt
            
            var smallRef = [String]()
            var smallRefValues = [String]()
            
            smallRef.append("Reason Of Refund")
            smallRefValues.append(refund_reason)
            
            if card_pay != "0.00" {
                smallRef.append("Credit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: card_pay)))")
                
            }
            
            if cash_pay != "0.00" {
                smallRef.append("Cash")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: cash_pay)))")
                
            }
            
            if loyalty_amt != "0.00" {
                smallRef.append("Loyalty Points")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: loyalty_amt)))")
                
            }
            
            if store_cred != "0.00" {
                smallRef.append("Store Credits")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: store_cred)))")
                
            }
            
            if tip_amt != "0.00" {
                smallRef.append("Tip")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: tip_amt)))")
                
            }
            
            if gift_card != "0.00" {
                smallRef.append("Gift Card")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: gift_card)))")
                
            }
            
            if nca_amt != "0.00" {
                
                smallRef.append("Non Cash Adjustment")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: nca_amt)))")
            }
            smallRefund.append(smallRef)
            smallRefundVal.append(smallRefValues)
            smallDate.append(create_date)
        }
        
        payRefund = smallRefund
        payRefundValues = smallRefundVal
        payRefundDate = smallDate
    }
    
    
    func setIdData(id: Any) {
        
        let identity = id as! [String:Any]
        let id_detail = IdentificationDetails(i_card_type: "\(identity["i_card_type"] ?? "")",
                                              i_card_number: "\(identity["i_card_number"] ?? "")",
                                              i_card_ex_date: "\(identity["i_card_ex_date"] ?? "")",
                                              i_card_dob: "\(identity["i_card_dob"] ?? "")",
                                              i_card_front_img: "\(identity["i_card_front_img"] ?? "")",
                                              i_card_back_img: "\(identity["i_card_back_img"] ?? "")")
        
        idDetail = id_detail
        
        let card_type = idDetail?.i_card_type ?? ""
        let card_number = idDetail?.i_card_number ?? ""
        let card_ex = idDetail?.i_card_ex_date ?? ""
        let card_dob = idDetail?.i_card_dob ?? ""
        let date = orderDetail?.date_time ?? ""
        
        var smallIdNames = [String]()
        var smallIdValues = [String]()
        
        if card_type == "Verify Non Id Person" {
            id_exist = false
        }
        else {
            id_exist = true
            
            
            if card_type != "" {
                smallIdNames.append("Identification Card Type")
                smallIdValues.append(card_type)
            }
            
            if card_number != "" {
                smallIdNames.append("Identification Number")
                smallIdValues.append(card_number)
            }
            
            if date != "" {
                smallIdNames.append("Date & Time")
                smallIdValues.append(date)
            }
            
            if card_ex != "" && card_ex != "0000-00-00"  {
                smallIdNames.append("Expiry Date")
                smallIdValues.append(card_ex)
            }
            
            if card_dob != "" {
                smallIdNames.append("Date of Birth")
                smallIdValues.append(card_dob)
            }
            idRefundName = smallIdNames
            idRefundValue = smallIdValues
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
    
    func handleZero(value: String) -> Bool {
        
        let doub = roundOf(item: value)
        let doub_value = Double(doub)
        
        if doub_value < 0.0 {
            
            return false
        }
        else {
            return true
            
        }
    }
    
    func calculateRefPayAmt(amt: String, ref_amt: String) -> String {
        
        
        let amt1 = roundOf(item: amt)
        let amt2 = roundOf(item: ref_amt)
        
        let amt_doub = amt1
        let ref_amt_doub = amt2
        
        print(amt_doub)
        print(ref_amt_doub)
        
        let total = amt_doub - ref_amt_doub
        return String(total)
        
    }
    
    func calculateDiscount(amt: String, discount: String) -> String {
        
        let amt1 = roundOf(item: amt)
        let amt2 = roundOf(item: discount)
        
        let amt_doub = amt1
        let ref_amt_doub = amt2
        
        print(amt_doub)
        print(ref_amt_doub)
        
        let total = amt_doub - ref_amt_doub
        return String(total)
        
    }
    
    func calculateSplitCard(card: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in card {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calculateSplitCash(cash: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in cash {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calculateSplitEbt(cash: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in cash {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calSplitTipCard(amt: String, tip: String) -> String {
        
        let cred = roundOf(item: amt)
        print(tip)
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" {
            let tip_pay = roundOf(item: tip)
            let cred_pay = cred - tip_pay
            print(cred)
            print(tip_pay)
            print(cred_pay)
            return String(cred_pay)
        }
        else {
            return String(cred)
        }
    }
    
    //    func calculateCashLottery(amt: String) -> String {
    //
    //        let amt_doub = Double(amt) ?? 0.00
    //        let lottery_doub = Double(couponCode?.total_lottery_payout ?? "") ?? 0.00
    //        let scratch_doub = Double(couponCode?.total_scratcher_payout ?? "") ?? 0.00
    //        let scratch_order_doub = Double(couponCode?.scratch_cash_pay ?? "") ?? 0.00
    //
    //        if scratch_order_doub < scratch_doub {
    //
    //            if lottery_doub < scratch_doub {
    //                return String(amt_doub - (scratch_doub - scratch_order_doub) - lottery_doub)
    //            }
    //            else {
    //                return String(amt_doub - (lottery_doub - (scratch_doub - scratch_order_doub)))
    //            }
    //        }
    //        else {
    //            if lottery_doub < scratch_doub {
    //                return String(amt_doub - scratch_doub - lottery_doub)
    //            }
    //            else {
    //                return String(amt_doub - lottery_doub - scratch_doub)
    //            }
    //        }
    //    }
    
    func getCountForSection(section: Int) -> Int {
        
        if payRefund.count == 0 {
            return 0
        }
        else {
            return payRefund[section].count
        }
    }
    
    func getCountForHeight() -> Int {
        var counter = 0
        if payRefund.count == 0 {
            return 0
        }
        else {
            
            for pay in payRefund {
                counter = counter + pay.count
            }
            return counter
        }
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
    
    func calculateGrandTotal(pay: [String]) {
        var grand = 0.00
        
        if amtValue.text == "$0.00" {
            grand = 0.00
        }
        
        else {
            for add in 0..<pay.count {
                
                let doub = Double(pay[add]) ?? 0.00
                
                if pay[add] == couponCode?.coupon_code_amt {
                    grand -= doub
                }
                else {
                    grand += doub
                }
            }
        }
        
        let cash_back_amt = orderDetail?.cash_back_amt ?? "0.00"
        let cash_back_fee = orderDetail?.cash_back_fee ?? "0.00"
        
        let granCal = roundOf(item: "\(grand)") + roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
        print("$\(String(format: "%.02f", roundOf(item: "\(granCal)")))")
        grandTotalValue.text = "$\(String(format: "%.02f", roundOf(item: "\(granCal)")))"
    }
    
    
    @IBAction func payInfoClick(_ sender: UIButton) {
        
        var amt_arr = [String]()
        var pay_arr = [String]()
        var pay_mode = [String]()
        var pay_per = [String]()
        
        for split in splitDetail {
            
            var amt = roundOf(item: split.pay_amount)
            var pay = roundOf(item: split.cash_discounting_amount)
            var per = roundOf(item: split.cash_discounting_percentage)
            let mode = split.pay_type.capitalized
            
            let amt1 = amt - pay
            print(amt1)
            amt_arr.append(String(format: "%.02f", amt1))
            if split.pay_type == "cash" || split.pay_type == "Cash" {
                pay_arr.append("")
                pay_per.append("")
            }
            else {
                pay_arr.append(String(format: "%.02f", pay))
                pay_per.append(String(format: "%.02f", per))
            }
            pay_mode.append(mode)
        }
        
        showAlert(amt: amt_arr, pay: pay_arr, mode: pay_mode, cash: pay_per)
    }
    
    func showAlert(amt: [String], pay: [String], mode: [String], cash: [String]) {
        
        var msgArray = [NSMutableAttributedString]()
        
        for payments in 0..<amt.count {
            
            var split_info = ""
            if pay[payments] == "" {
                split_info = "\n\n\(mode[payments]): $\(amt[payments])\n"
            }
            else {
                split_info = "\n\n\(mode[payments]): $\(amt[payments])\n(\(cash[payments])%): +$\(pay[payments])"
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            
            let messageText = NSMutableAttributedString(
                string: split_info,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont(name: "Manrope-Medium", size: 13.0)!
                ])
            
            if pay[payments] != "" {
                let loc = messageText.length - 6
                let range = NSRange(location: loc, length: 6)
                messageText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
            }
            
            msgArray.append(messageText)
        }
        let alertController = UIAlertController(title: "Split Payment", message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        alertController.addAction(OKAction)
        
        let msgText = NSMutableAttributedString()
        
        for msg in msgArray {
            
            msgText.append(msg)
        }
        
        alertController.setValue(msgText, forKey: "attributedMessage")
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertPax(title: String, pax: String) {
        
        
        let alertController = UIAlertController(title: title, message: pax, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped")
            
        }
        
        alertController.addAction(OKAction)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: pax,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont(name: "Manrope-Medium", size: 13.0)!])
        
        alertController.setValue(messageText, forKey: "attributedMessage")
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cardInfoClick(_ sender: UIButton) {
        
        showAlertPax(title: "Card Details", pax: pax_details)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
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

extension InStoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == tableview {
            return 1
        }
        
        else if tableView == payRefundTable {
            return payRefund.count
        }
        
        else if tableView == payRefundItemsTable {
            return 1
        }
        
        else if tableView == orderSumTable {
            return 1
        }
        
        else if tableView == payTableView {
            return 1
        }
        
        else if tableView == identityTable {
            
            if id_exist {
                return 1
            }
            else {
                return 0
            }
        }
        
        else if tableView == custTable {
            
            if cust_exist {
                return 1
            }
            else {
                return 0
            }
        }
        
        else {
            return 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tableview {
            return cartItems.count
        }
        
        else if tableView == payRefundTable {
            return payRefund[section].count
        }
        
        else if tableView == payRefundItemsTable {
            return cartRefundItems.count
        }
        
        else if tableView == orderSumTable {
            return orderSum.count
        }
        
        else if tableView == payTableView {
            return paySum.count
        }
        
        else if tableView == identityTable {
            return idRefundName.count
        }
        
        else if tableView == custTable {
            if cust_exist {
                return 1
            }
            else {
                return 0
            }
        }
        
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableview {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as! InStoreProductTableViewCell
            
            let cart = cartItems[indexPath.row]
            
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            let name_note = note.replacingOccurrences(of: "Name-", with: "")
            if let range = name_note.range(of: "null") {
                let itemName = name_note.prefix(upTo: range.lowerBound)
                cell.itemName.text = String(itemName)
            }
            else {
                cell.itemName.text = name_note
            }
            
            
            cell.onePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.price)))"
            cell.itemQty.text = "\(cart.qty)x"
            
            if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" {
                
                cell.itemDiscount.text = ""
                cell.itemDisPrice.text = ""
            }
            else {
                
                cell.itemDiscount.text = "Item Discount"
                cell.itemDisPrice.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
            }
            
            cell.totalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.price, qty: cart.qty, discount: cart.discount_amt)))"
            
            return cell
        }
        
        else if tableView == payRefundTable {
            
            let cell = payRefundTable.dequeueReusableCell(withIdentifier: "payrefundcell", for: indexPath) as! PayRefundCell
            
            cell.payRefundLbl.text = payRefund[indexPath.section][indexPath.row]
            cell.payRefundValues.text = payRefundValues[indexPath.section][indexPath.row]
            
            return cell
            
        }
        
        else if tableView == payRefundItemsTable {
            
            let cell = payRefundItemsTable.dequeueReusableCell(withIdentifier: "payrefunditemscell", for: indexPath) as! PayRefundItemsCell
            
            let cart = cartRefundItems[indexPath.row]
            
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            let name_note = note.replacingOccurrences(of: "Name-", with: "")
            if let range = name_note.range(of: "null") {
                let itemName = name_note.prefix(upTo: range.lowerBound)
                cell.payRefName.text = String(itemName)
            }
            else {
                cell.payRefName.text = name_note
            }
            
            cell.payRefOnePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.price)))"
            cell.payRefQty.text = "\(cart.refund_qty)x"
            
            if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" {
                
                cell.itemRefDiscountLbl.text = ""
                cell.itemRefDisValue.text = ""
            }
            else {
                
                cell.itemRefDiscountLbl.text = "Item Discount"
                cell.itemRefDisValue.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
            }
            
            cell.payRefTotalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.price, qty: cart.refund_qty, discount: cart.discount_amt)))"
            
            
            return cell
            
        }
        
        else if tableView == payTableView {
            
            let cell = payTableView.dequeueReusableCell(withIdentifier: "paycell", for: indexPath) as! InStorePayTableCell
            
            cell.payName.text = paySum[indexPath.row]
            if paySum[indexPath.row] == "Points Applied" {
                cell.payValue.text = paySumValue[indexPath.row]
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if paySum[indexPath.row] == "Points Awarded" {
                cell.payValue.textColor = UIColor(red: 76.0/255.0, green: 188.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                cell.payValue.text = "\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
            }
            else if paySum[indexPath.row] == "Gift Card Applied" {
                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if paySum[indexPath.row] == "Lottery Payout" || paySum[indexPath.row] == "Scratcher Payout" {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else {
                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
            }
            
            if paySum[indexPath.row] == "Credit Card" {
                cell.cardInfoBtn.isHidden = false
            }
            else {
                cell.cardInfoBtn.isHidden = true
            }
            return cell
        }
        
        else if tableView == identityTable {
            let cell = identityTable.dequeueReusableCell(withIdentifier: "identitycell", for: indexPath) as! InStoreIdentityCell
            
            cell.payIdLbl.text = idRefundName[indexPath.row]
            cell.payIdValue.text = idRefundValue[indexPath.row]
            
            return cell
        }
        
        else if tableView == custTable {
            
            let cell = custTable.dequeueReusableCell(withIdentifier: "custdetail", for: indexPath) as! CustomerDetailsCell
            
            cell.custName.text = custName
            cell.custAddr.text = custAddr
            cell.custphone.text = custNumber
            cell.custMail.text = custMail
            
            if custAddr == "" {
                cell.custAddrBtnHeight.constant = 0
            }
            else {
                cell.custAddrBtnHeight.constant = 14
            }
            
            cell.addrView.layer.cornerRadius = 10
            cell.addrView.layer.borderWidth = 1
            cell.addrView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            
            
            return cell
            
        }
        
        else {
            
            let cell = orderSumTable.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! InStoreOrderSumCell
            
            if orderSum[indexPath.row] == "Discounts" || orderSum[indexPath.row] == couponCode?.coupon_code {
                cell.orderLbl.text = orderSum[indexPath.row]
                cell.orderLblValue.text = "-$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
            }
            else {
                cell.orderLbl.text = orderSum[indexPath.row]
                cell.orderLblValue.text = "$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == payRefundTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
            let label1 = UILabel(frame: CGRect(x: tableView.frame.size.width - 170, y: 0, width: tableView.frame.size.width - 65, height: 19))
            label1.text = payRefundDate[section]
            label1.font = UIFont(name: "Manrope-SemiBold", size: 15.0)
            label1.textColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            headerView.addSubview(label1)
            
            let label = UILabel(frame: CGRect(x: 20, y: label1.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
            label.text = "Refund"
            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
            headerView.addSubview(label)
            
            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
            grayview.backgroundColor = .black
            headerView.addSubview(grayview)
            
            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 60, height: 3))
            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            headerView.addSubview(blueview)
            
            return headerView
        }
        
        else if tableView == identityTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
            
            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
            label.text = "Identification Details"
            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
            headerView.addSubview(label)
            
            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
            grayview.backgroundColor = .black
            headerView.addSubview(grayview)
            
            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 180, height: 3))
            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            headerView.addSubview(blueview)
            
            return headerView
        }
        
        else if tableView == custTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
            
            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
            label.text = "Customer Details"
            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
            headerView.addSubview(label)
            
            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
            grayview.backgroundColor = .black
            headerView.addSubview(grayview)
            
            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 120, height: 3))
            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            headerView.addSubview(blueview)
            
            return headerView
        }
        
        else if tableView == identityTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
            
            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
            label.text = "Identification Details"
            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
            headerView.addSubview(label)
            
            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
            grayview.backgroundColor = .black
            headerView.addSubview(grayview)
            
            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 120, height: 3))
            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            headerView.addSubview(blueview)
            
            return headerView
        }
        
        else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableview || tableView == payRefundItemsTable {
            return 130
        }
        
        else {
            return UITableView.automaticDimension
        }
    }
}
//class InStoreDetailViewController: UIViewController {
//    
//    
//    @IBOutlet weak var tableview: UITableView!
//    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var orderSumTable: UITableView!
//    @IBOutlet weak var payTableView: UITableView!
//   // @IBOutlet weak var identityTable: UITableView!
//    @IBOutlet weak var custTable: UITableView!
//    @IBOutlet weak var payRefundItemsTable: UITableView!
//    @IBOutlet weak var payRefundTable: UITableView!
//    @IBOutlet weak var orderDetailTable: UITableView!
//    @IBOutlet weak var feeTable: UITableView!
//    @IBOutlet weak var refundTable: UITableView!
//    @IBOutlet weak var taxTableView: UITableView!
//    
//    @IBOutlet weak var taxTableHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var itemTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var orderSumHeight: NSLayoutConstraint!
//    @IBOutlet weak var payTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var feeTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var refundTableHeight: NSLayoutConstraint!
//    
//    
//    @IBOutlet weak var totalTaxView: UIView!
//    @IBOutlet weak var orderDetTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var payRefundItemsHeight: NSLayoutConstraint!
//    @IBOutlet weak var payRefundTableHeight: NSLayoutConstraint!
//    
//   // @IBOutlet weak var idTableHeight: NSLayoutConstraint!
//    
//    @IBOutlet weak var custHeight: NSLayoutConstraint!
//    @IBOutlet weak var grandTotalValue: UILabel!
//    
//    //@IBOutlet weak var customerOweValue: UILabel!
//    @IBOutlet weak var itemCount: UILabel!
//    @IBOutlet weak var instoreLbl: UILabel!
//    @IBOutlet weak var instoreViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var instoreRefundViewHeight: NSLayoutConstraint!
//    
//    
//    @IBOutlet weak var totalFeeView: UIView!
//    
//    @IBOutlet weak var totalRefundView: UIView!
//    
//    @IBOutlet weak var refundhead: UIView!
//    
//    @IBOutlet weak var dotView: UIView!
//    @IBOutlet weak var refundedLbl: UILabel!
//    
//    @IBOutlet weak var awardView: UIView!
//    @IBOutlet weak var removeView: UIView!
//    
//    @IBOutlet weak var awardLbl: UILabel!
//    @IBOutlet weak var awardDate: UILabel!
//    
//    @IBOutlet weak var awardCost: UILabel!
//    
//    @IBOutlet weak var removeLbl: UILabel!
//    @IBOutlet weak var removeDate: UILabel!
//    
//    @IBOutlet weak var removeCost: UILabel!
//    
//    @IBOutlet weak var totalLoyalCost: UILabel!
//    
//    @IBOutlet weak var scroll: UIView!
//    
//    var amtValue = UITextField()
//    
//    
//    var orderSum = [String]()
//    var orderSumValue = [String]()
//    
//    var paySum = [String]()
//    var paySumValue = [String]()
//    
//    var order_id = ""
//    
//    var orderDetailLabel = [String]()
//    var orderDetailValue = [String]()
//    
//    var cartItems = [Cart_Data]()
//    var cartRefundItems = [Cart_Data]()
//    var splitDetail = [Split_Data]()
//    var refundDetail = [[String:Any]]()
//    var orderDetail: OrderDetails?
//    var couponCode: CouponCode?
//    var idDetail: IdentificationDetails?
//    
//    var payRefund = [[String]]()
//    var payRefundValues = [[String]]()
//    var payRefundDate = [String]()
//    
//    var idRefundName = [String]()
//    var idRefundValue = [String]()
//    
//    var custName = ""
//    var custAddr = ""
//    var custNumber = ""
//    var custMail = ""
//    
//    var id_exist = false
//    var refund_exist = false
//    var cust_exist = false
//    var pax_details = ""
//    
//    let loadingIndicator: ProgressView = {
//        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
//        progress.translatesAutoresizingMaskIntoConstraints = false
//        return progress
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        topView.addBottomShadow()
//        
//        awardView.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
//        awardView.layer.borderWidth = 1.0
//        
//        removeView.layer.borderColor = UIColor(hexString: "#E9E9E9").cgColor
//        removeView.layer.borderWidth = 1.0
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        setupUI()
//        tableview.estimatedSectionHeaderHeight = 0
//        tableview.estimatedSectionFooterHeight = 0
//        taxTableView.estimatedSectionHeaderHeight = 0
//        taxTableView.estimatedSectionFooterHeight = 0
//        orderDetailTable.estimatedSectionHeaderHeight = 0
//        orderDetailTable.estimatedSectionFooterHeight = 0
//        feeTable.estimatedSectionHeaderHeight = 0
//        feeTable.estimatedSectionFooterHeight = 0
//        refundTable.estimatedSectionHeaderHeight = 0
//        refundTable.estimatedSectionFooterHeight = 0
//        orderSumTable.estimatedSectionHeaderHeight = 0
//        orderSumTable.estimatedSectionFooterHeight = 0
//        payTableView.estimatedSectionHeaderHeight = 0
//        payTableView.estimatedSectionFooterHeight = 0
//        payRefundItemsTable.estimatedSectionHeaderHeight = 0
//        payRefundItemsTable.estimatedSectionFooterHeight = 0
//        payRefundTable.estimatedSectionFooterHeight = 0
//        custTable.estimatedSectionFooterHeight = 0
//      //  identityTable.estimatedSectionFooterHeight = 0
//        
//        loadingIndicator.isAnimating = true
//        scroll.isHidden = true
//        
//        setupApi()
//        
//    }
//    
//    func dashedLine() {
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer.lineWidth = 1
//        shapeLayer.lineDashPattern = [4, 4]
//        
//        let path1 = CGMutablePath()
//        path1.addLines(between: [CGPoint(x: 0, y: 45), CGPoint(x: view.bounds.maxX, y: 45)])
//        shapeLayer.path = path1
//        dotView.layer.addSublayer(shapeLayer)
//        
//        let shapeLayer1 = CAShapeLayer()
//        shapeLayer1.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer1.lineWidth = 1
//        shapeLayer1.lineDashPattern = [4, 4]
//        
//        let path2 = CGMutablePath()
//        path2.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: view.bounds.maxX, y: 0)])
//        shapeLayer1.path = path2
//        orderSumTable.layer.addSublayer(shapeLayer1)
//        
//        let shapeLayer2 = CAShapeLayer()
//        shapeLayer2.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer2.lineWidth = 1
//        shapeLayer2.lineDashPattern = [4, 4]
//        
//        let path3 = CGMutablePath()
//        path3.addLines(between: [CGPoint(x: 0, y: 39 * CGFloat(self.orderSum.count)),
//                                 CGPoint(x: view.bounds.maxX, y: 39 * CGFloat(self.orderSum.count))])
//        shapeLayer2.path = path3
//        orderSumTable.layer.addSublayer(shapeLayer2)
//        
//        let shapeLayer3 = CAShapeLayer()
//        shapeLayer3.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer3.lineWidth = 1
//        shapeLayer3.lineDashPattern = [4, 4]
//        
//        let path4 = CGMutablePath()
//        path4.addLines(between: [CGPoint(x: 0, y: 0),
//                                 CGPoint(x: view.bounds.maxX, y: 0)])
//        shapeLayer3.path = path4
//        totalTaxView.layer.addSublayer(shapeLayer3)
//        
//        let shapeLayer4 = CAShapeLayer()
//        shapeLayer4.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer4.lineWidth = 1
//        shapeLayer4.lineDashPattern = [4, 4]
//        
//        let path5 = CGMutablePath()
//        path5.addLines(between: [CGPoint(x: 0, y: totalTaxView.bounds.size.height),
//                                 CGPoint(x: view.bounds.maxX, y: totalTaxView.bounds.size.height)])
//        shapeLayer4.path = path5
//        totalTaxView.layer.addSublayer(shapeLayer4)
//        
//        let shapeLayer5 = CAShapeLayer()
//        shapeLayer5.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer5.lineWidth = 1
//        shapeLayer5.lineDashPattern = [4, 4]
//        
//        let path6 = CGMutablePath()
//        path6.addLines(between: [CGPoint(x: 0, y: 0),
//                                 CGPoint(x: view.bounds.maxX, y: 0)])
//        shapeLayer5.path = path6
//        totalFeeView.layer.addSublayer(shapeLayer5)
//        
//        let shapeLayer6 = CAShapeLayer()
//        shapeLayer6.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer6.lineWidth = 1
//        shapeLayer6.lineDashPattern = [4, 4]
//        
//        let path7 = CGMutablePath()
//        path7.addLines(between: [CGPoint(x: 0, y: totalFeeView.bounds.size.height),
//                                 CGPoint(x: view.bounds.maxX, y: totalFeeView.bounds.size.height)])
//        shapeLayer6.path = path7
//        totalFeeView.layer.addSublayer(shapeLayer6)
//        
//        let shapeLayer7 = CAShapeLayer()
//        shapeLayer7.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer7.lineWidth = 1
//        shapeLayer7.lineDashPattern = [4, 4]
//        
//        let path8 = CGMutablePath()
//        path8.addLines(between: [CGPoint(x: 0, y: 0),
//                                 CGPoint(x: view.bounds.maxX, y: 0)])
//        shapeLayer7.path = path8
//        totalRefundView.layer.addSublayer(shapeLayer7)
//        
//        let shapeLayer8 = CAShapeLayer()
//        shapeLayer8.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer8.lineWidth = 1
//        shapeLayer8.lineDashPattern = [4, 4]
//        
//        let path9 = CGMutablePath()
//        path9.addLines(between: [CGPoint(x: 0, y: totalRefundView.bounds.size.height),
//                                 CGPoint(x: view.bounds.maxX, y: totalRefundView.bounds.size.height)])
//        shapeLayer8.path = path9
//        totalRefundView.layer.addSublayer(shapeLayer8)
//        
//        let shapeLayer9 = CAShapeLayer()
//        shapeLayer9.strokeColor = UIColor(hexString: "#707070").cgColor
//        shapeLayer9.lineWidth = 1
//        shapeLayer9.lineDashPattern = [4, 4]
//        
//        let path10 = CGMutablePath()
//        path10.addLines(between: [CGPoint(x: 0, y: 0),
//                                 CGPoint(x: view.bounds.maxX, y: 0)])
//        shapeLayer9.path = path10
//        refundhead.layer.addSublayer(shapeLayer9)
//    }
//    
//    func calTotalPrice(onePrice: String, qty: String, discount: String) -> Double {
//        
//        let price = Double(onePrice) ?? 0.00
//        let quant = Double(qty) ?? 0.00
//        let dis = Double(discount) ?? 0.00
//        
//        let total = price * quant
//        
//        let dis_price = total - dis
//        
//        
//        return roundOf(item: String(dis_price))
//    }
//    
//    func setupApi() {
//        
//        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
//        
//        ApiCalls.sharedCall.getOrderDetails(merchant_id: id, order_id: order_id) { isSuccess, responseData in
//            
//            if isSuccess {
//                
//                guard let list = responseData["result"] else {
//                    return
//                }
//                
//                self.getOrderResponse(response: list)
//            }else{
//                print("Api Error")
//            }
//        }
//    }
//    
//    func getOrderResponse(response: Any) {
//        
//        let responsevalues = response as! [String:Any]
//        
//        //        guard let merch_list = responsevalues["merchant_details"] else {
//        //            return
//        //        }
//        
//        guard let order_list = responsevalues["order_detail"] else {
//            return
//        }
//        
//        guard let cart_list = responsevalues["cart_data"] else {
//            return
//        }
//        
//        if responsevalues["split_payments"] != nil {
//            setSplitData(split: responsevalues["split_payments"])
//        }
//        
//        setOrderData(order: order_list)
//        setCartData(cart: cart_list)
//        
//        if responsevalues["id_card_detail"] == nil {
//            id_exist = false
//        }
//        else {
//            id_exist = true
//            setIdData(id: responsevalues["id_card_detail"])
//        }
//        
//        setCustData()
//        
//        if orderDetail?.is_refunded == "1" {
//            refund_exist = true
//            setRefundData(refund_data: responsevalues["refund_data"])
//        }
//        else {
//            refund_exist = false
//        }
//        
//        DispatchQueue.main.async {
//            
//            self.tableview.reloadData()
//            self.orderDetailTable.reloadData()
//            self.taxTableView.reloadData()
//            self.orderSumTable.reloadData()
//            self.payTableView.reloadData()
//            self.feeTable.reloadData()
//            self.refundTable.reloadData()
////            self.identityTable.reloadData()
//            self.payRefundTable.reloadData()
//            self.custTable.reloadData()
//            self.payRefundItemsTable.reloadData()
//            
//            self.itemTableHeight.constant = 130 * CGFloat(self.cartItems.count)
//            self.orderDetTableHeight.constant = 41.67 * CGFloat(self.orderDetailLabel.count)
//            self.taxTableHeight.constant = 133.34
//            self.orderSumHeight.constant = 42 * CGFloat(self.orderSum.count)
//            self.payTableHeight.constant = 42 * CGFloat(self.paySum.count)
//            self.payRefundTableHeight.constant = (54 * CGFloat(self.refundDetail.count)) + CGFloat(39 * self.getCountForHeight())
//            self.feeTableHeight.constant = 84
//            self.refundTableHeight.constant = 84
//            
//            if self.cartRefundItems.count == 0 {
//                self.payRefundItemsHeight.constant = 0
//            }
//            else {
//                self.payRefundItemsHeight.constant = 130 * CGFloat(self.cartRefundItems.count)
//            }
//            
//            if self.cust_exist {
//                let height = self.custTable.contentSize.height
//                self.custHeight.constant = height + 64
//            }
//            else {
//                self.custHeight.constant = 0
//            }
//            
////            if self.id_exist {
////                let height = self.identityTable.contentSize.height
////                self.idTableHeight.constant = height + 64
////            }
////            else {
////                self.idTableHeight.constant = 0
////            }
//            
//            let cartHeight = 130 * CGFloat(self.cartItems.count)
//            let detailHeight = 41.67 * CGFloat(self.orderDetailLabel.count)
//            let refcartHeight = 130 * CGFloat(self.cartRefundItems.count)
//            //let taxHeight = 132.66
////            let feeHeight = 84
////            let refundHeight = 84
//            let orderHeight = 42 * CGFloat(self.orderSum.count)
//            let payHeight = 42 * CGFloat(self.paySum.count)
//            let payRefundHeight = self.payRefundTableHeight.constant
//            
//            let calHeight = cartHeight + detailHeight + refcartHeight
//            //+ feeHeight + refundHeight
//            + orderHeight + payHeight + payRefundHeight
//            + self.custHeight.constant + self.instoreViewHeight.constant
//            + self.instoreRefundViewHeight.constant + 1516.66
//            self.scrollHeight.constant = calHeight
//            
//            self.loadingIndicator.isAnimating = false
//            self.scroll.isHidden = false
//        }
//        dashedLine()
//    }
//    
//    func setOrderData(order: Any) {
//        
//        let res = order as! [String:Any]
//        
//        let order = OrderDetails(id: "\(res["id"] ?? "")", order_id: "\(res["order_id"] ?? "")",
//                                 order_number: "\(res["order_number"] ?? "")", customer_id: "\(res["customer_id"] ?? "")",
//                                 merchant_id: "\(res["merchant_id"] ?? "")", admin_id: "\(res["admin_id"] ?? "")",
//                                 order_status: "\(res["order_status"] ?? "")", date_time: "\(res["date_time"] ?? "")",
//                                 payment_id: "\(res["payment_id"] ?? "")", pax_details: "\(res["pax_details"] ?? "")",
//                                 card_num: "\(res["card_num"] ?? "")", payment_result: "\(res["payment_result"] ?? "")",
//                                 cvvResult: "\(res["cvvResult"] ?? "")", failResult: "\(res["failResult"] ?? "")",
//                                 card_type: "\(res["card_type"] ?? "")", customer_app_id: "\(res["customer_app_id"] ?? "")",
//                                 discount: "\(res["discount"] ?? "")", tip: "\(res["tip"] ?? "")",
//                                 tax: "\(res["tax"] ?? "")", other_taxes: "\(res["other_taxes"] ?? "")",
//                                 other_taxes_desc: "\(res["other_taxes_desc"] ?? "")", con_fee: "\(res["con_fee"] ?? "")",
//                                 del_fee: "\(res["del_fee"] ?? "")", subtotal: "\(res["subtotal"] ?? "")",
//                                 tax_rate: "\(res["tax_rate"] ?? "")", coupon_code: "\(res["coupon_code"] ?? "")",
//                                 amt: "\(res["amt"] ?? "")", billing_name: "\(res["billing_name"] ?? "")",
//                                 billing_add: "\(res["billing_add"] ?? "")", deliver_name: "\(res["deliver_name"] ?? "")",
//                                 delivery_addr: "\(res["delivery_addr"] ?? "")", delivery_phn: "\(res["delivery_phn"] ?? "")",
//                                 email: "\(res["email"] ?? "")", m_status: "\(res["m_status"] ?? "")",
//                                 mailtriggered: "\(res["mailtriggered"] ?? "")", smstriggerd: "\(res["smstriggerd"] ?? "")",
//                                 order_method: "\(res["order_method"] ?? "")", is_online: "\(res["is_online"] ?? "")",
//                                 merchant_time: "\(res["merchant_time"] ?? "")", customer_time: "\(res["customer_time"] ?? "")",
//                                 order_time: "\(res["order_time"] ?? "")", mail_status: "\(res["mail_status"] ?? "")",
//                                 is_tried: "\(res["is_tried"] ?? "")", kitchen_receipt: "\(res["kitchen_receipt"] ?? "")",
//                                 print: "\(res["print"] ?? "")", cash_collected: "\(res["cash_collected"] ?? "")",
//                                 driver_assigned: "\(res["driver_assigned"] ?? "")", show_status: "\(res["show_status"] ?? "")",
//                                 is_future: "\(res["is_future"] ?? "")", is_refunded: "\(res["is_refunded"] ?? "")",
//                                 is_partial_refund: "\(res["is_partial_refund"] ?? "")",
//                                 refund_amount: "\(res["refund_amount"] ?? "")",
//                                 is_split_payment: "\(res["is_split_payment"] ?? "")",
//                                 tip_refund_amount: "\(res["tip_refund_amount"] ?? "")",
//                                 cash_discounting: "\(res["cash_discounting"] ?? "")",
//                                 cash_discounting_percentage: "\(res["cash_discounting_percentage"] ?? "")",
//                                 cashdiscount_refund_amount: "\(res["cashdiscount_refund_amount"] ?? "")",
//                                 is_outdoor: "\(res["is_outdoor"] ?? "")", employee_id: "\(res["employee_id"] ?? "")",
//                                 dob: "\(res["dob"] ?? "")", adv_id: "\(res["adv_id"] ?? "")",
//                                 shift_setting: "\(res["shift_setting"] ?? "")", is_loyality: "\(res["is_loyality"] ?? "")",
//                                 is_store_credit: "\(res["is_store_credit"] ?? "")", is_gift_card: "\(res["is_gift_card"] ?? "")", sms_notify: "\(res["sms_notify"] ?? "")",
//                                 live_status: "\(res["live_status"] ?? "")", customer_email: "\(res["customer_email"] ?? "")",
//                                 customer_phone: "\(res["customer_phone"] ?? "")",
//                                 total_loyalty_pts: "\(res["total_loyalty_pts"] ?? "")",
//                                 total_store_credit: "\(res["total_store_credit"] ?? "")",
//                                 cash_back_amt: "\(res["cash_back_amt"] ?? "")",
//                                 cash_back_fee: "\(res["cash_back_fee"] ?? "")")
//        
//        orderDetail = order
//        
//        let order_id = orderDetail?.order_id ?? ""
//        
//        orderDetailLabel.append("Order Id")
//        orderDetailValue.append(order_id)
//        
//        let order_num = orderDetail?.order_number
//        
//        let order_date = orderDetail?.date_time ?? ""
//        let date = order_date.components(separatedBy: " ")[0]
//        let time = order_date.components(separatedBy: " ")[1]
//        
//        orderDetailLabel.append("Date")
//        orderDetailValue.append(date)
//        
//        orderDetailLabel.append("Time")
//        orderDetailValue.append(time)
//        
//        orderDetailLabel.append("Employee Name")
//        orderDetailValue.append("James")
//        
//        
//        let cash_back_amt = orderDetail?.cash_back_amt ?? "0.00"
//        let cash_back_fee = orderDetail?.cash_back_fee ?? "0.00"
//        
//        let coupon = orderDetail?.coupon_code ?? ""
//        let coupon_dict = convertStringToDictionary(text: coupon)
//        
//        couponCode = CouponCode(coupon_code: "\(coupon_dict["coupon_code"] ?? "")",
//                                coupon_code_amt: "\(coupon_dict["coupon_code_amt"] ?? "")",
//                                loyalty_point_earned: "\(coupon_dict["loyalty_point_earned"] ?? "")",
//                                loyalty_point_amt_earned: "\(coupon_dict["loyalty_point_amt_earned"] ?? "")",
//                                loyalty_point_amt_spent: "\(coupon_dict["loyalty_point_amt_spent"] ?? "")",
//                                loyalty_point_spent: "\(coupon_dict["loyalty_point_spent"] ?? "")",
//                                store_credit_amt_spent: "\(coupon_dict["store_credit_amt_spent"] ?? "")",
//                                gift_card_number: "\(coupon_dict["gift_card_number"] ?? "")",
//                                gift_card_amount: "\(coupon_dict["gift_card_amount"] ?? "")",
//                                gift_card_balance: "\(coupon_dict["gift_card_balance"] ?? "")",
//                                surcharge_label: "\(coupon_dict["surcharge_label"] ?? "")",
//                                total_lottery_payout: "\(coupon_dict["total_lottery_payout"] ?? "")",
//                                total_scratcher_payout: "\(coupon_dict["total_scratcher_payout"] ?? "")",
//                                lottery_order_pay: "\(coupon_dict["lottery_order_pay"] ?? "")",
//                                lottery_cash_pay: "\(coupon_dict["lottery_cash_pay"] ?? "")",
//                                scratch_cash_pay: "\(coupon_dict["scratch_cash_pay"] ?? "")")
//        
//        
//        let amt = orderDetail?.amt ?? "0.00"
//        let subtotal = orderDetail?.subtotal ?? "0.00"
//        let ref_amt = orderDetail?.refund_amount ?? "0.00"
//        
//            
//        let split = orderDetail?.is_split_payment ?? ""
//        let payment_id = orderDetail?.payment_id ?? ""
//        let card_type = orderDetail?.card_type ?? ""
//        
//        
//        //        if split == "1" {
//        //            paymodeLbl.text = "Payment Mode"
//        //            payMode.text = "Split Payment"
//        //            paymode_info.isHidden = false
//        //        }
//        //        else if payment_id == "Cash" {
//        //            paymodeLbl.text = "Payment Mode"
//        //            payMode.text = payment_id
//        //            paymode_info.isHidden = true
//        //        }
//        //        else {
//        //            paymodeLbl.text = "Payment Id"
//        //            payMode.text = payment_id
//        //            paymode_info.isHidden = true
//        //        }
//        
//        // couponcode
//        let coupon_code = couponCode?.coupon_code ?? ""
//        let coupon_code_amt = couponCode?.coupon_code_amt ?? "0.00"
//        
//        let points_earned = couponCode?.loyalty_point_earned ?? "0.00"
//        let points_amt_earned = couponCode?.loyalty_point_amt_earned ?? "0.00"
//        
//        let points_amt_spent = couponCode?.loyalty_point_amt_spent ?? "0.00"
//        let points_applied = couponCode?.loyalty_point_spent ?? "0.00"
//        
//        let store_credit = couponCode?.store_credit_amt_spent ?? "0.00"
//        let gift_card_amount = couponCode?.gift_card_amount ?? "0.00"
//        
//        let nca_title = couponCode?.surcharge_label ?? ""
//        
//        _ = couponCode?.total_lottery_payout ?? "0.00"
//        
//        _ = couponCode?.total_scratcher_payout ?? "0.00"
//        
//        _ = couponCode?.scratch_cash_pay ?? "0.00"
//        
//        var cash_value = ""
//        
//        if orderDetail?.is_refunded == "1" {
//            
//            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
//                let sub = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
//                
//                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
//                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
//                
//                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
//                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
//                cash_value = "\(sub)"
//            }
//            else {
//                let amt_sub = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
//                
//                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
//                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
//                
//                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
//                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
//                cash_value = "\(amt_sub)"
//            }
//        }
//        
//        else {
//            
//            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
//                let amt_price = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
//                
//                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
//                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
//                
//                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
//                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
//                
//            }
//            else {
//                let amt_price = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
//                
//                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
//                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
//                
//                amtValue.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
//                
//                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
//            }
//        }
//        
//        //ordersumtable
//        
//        var smallOrderSum = ["Subtotal"]
//        
//        let sub = orderDetail?.subtotal ?? ""
//        var smallOrderSumValue = ["\(sub)"]
//        
//        let discount = orderDetail?.discount ?? ""
//        
//        //        if discount != "0.0" && discount != "0.00" {
//        //
//        //            if coupon_code_amt != "" && coupon_code_amt != "0.00" && coupon_code_amt != "0.0" && coupon_code_amt != "0"  {
//        //
//        //                if coupon_code == "" {
//        //                    smallOrderSum.append("Discount")
//        //                }
//        //                else {
//        //                    smallOrderSum.append(coupon_code)
//        //                }
//        //                smallOrderSumValue.append("\(coupon_code_amt)")
//        //            }
//        //        }
//        
//        if coupon_code_amt != "0.0" && coupon_code_amt != "0.00" && coupon_code_amt != "-0.00"
//            && coupon_code_amt != "-0.0" && coupon_code_amt != "0" && coupon_code_amt != ""  {
//            
//            if coupon_code != "Discount" && coupon_code != "" && coupon_code != "0.0"
//                && coupon_code != "0.00" && coupon_code != "-0.00" && coupon_code != "-0.0" && coupon_code != "0" {
//                smallOrderSum.append(coupon_code)
//                smallOrderSumValue.append(coupon_code_amt)
//            }
//            
//            else if coupon_code_amt == points_amt_spent || coupon_code_amt == store_credit {
//                
//            }
//            
//            else {
//                smallOrderSum.append("Discounts")
//                smallOrderSumValue.append(coupon_code_amt)
//            }
//        }
//        
//        let tip = orderDetail?.tip ?? ""
//        
//        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
//            smallOrderSum.append("Tip")
//            smallOrderSumValue.append("\(tip)")
//        }
//        
//        
//        let cash_discount = orderDetail?.cash_discounting ?? ""
//        let cash_per = orderDetail?.cash_discounting_percentage ?? ""
//        
//        if cash_discount != "0.0" && cash_discount != "0.00" && cash_discount != "-0.00" && cash_discount != "-0.0"
//            && cash_discount != "0" && cash_discount != ""  {
//            
//            if split == "1" {
//                
//                var debit_count = 0
//                var credit_count = 0
//                var small_debit = [String]()
//                var small_credit = [String]()
//                
//                for split_pay in splitDetail {
//                    
//                    if split_pay.cash_discounting_amount != "0" && split_pay.cash_discounting_amount != "0.0"
//                        && split_pay.cash_discounting_amount != "0.00" {
//                        
//                        if split_pay.pay_type == "debit" {
//                            if debit_count != 1 {
//                                smallOrderSum.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
//                                small_debit.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
//                                debit_count = 1
//                            }
//                            
//                        }
//                        
//                        else if split_pay.pay_type == "credit" {
//                            if credit_count != 1 {
//                                smallOrderSum.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
//                                small_credit.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
//                                credit_count = 1
//                            }
//                        }
//                        else {
//                        }
//                    }
//                }
//                
//                var debit_amt = [String]()
//                var credit_amt = [String]()
//                
//                var mode_first = 0
//                
//                for split_pay in splitDetail {
//                    
//                    if split_pay.cash_discounting_amount != "0" && split_pay.cash_discounting_amount != "0.0"
//                        && split_pay.cash_discounting_amount != "0.00" {
//                        
//                        if split_pay.pay_type == "credit" {
//                            if mode_first == 0 {
//                                mode_first = 1
//                            }
//                            credit_amt.append(split_pay.cash_discounting_amount)
//                        }
//                        
//                        else if split_pay.pay_type == "debit" {
//                            if mode_first == 0 {
//                                mode_first = 2
//                            }
//                            debit_amt.append(split_pay.cash_discounting_amount)
//                        }
//                    }
//                }
//                
//                var credit_card = Double()
//                var debit_card = Double()
//                
//                if small_debit.count != 0 {
//                    debit_card = calculateSplitCard(card: debit_amt)
//                }
//                
//                if small_credit.count != 0 {
//                    credit_card = calculateSplitCash(cash: credit_amt)
//                }
//                
//                if small_debit.count == 0 {
//                    smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
//                }
//                
//                else if small_credit.count == 0 {
//                    smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
//                }
//                
//                else {
//                    
//                    if mode_first == 1 {
//                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
//                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
//                    }
//                    
//                    else {
//                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
//                        smallOrderSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
//                    }
//                }
//            }
//            
//            else {
//                
//                if card_type.contains("Debit") || card_type.contains("debit") {
//                    smallOrderSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
//                    smallOrderSumValue.append("\(cash_discount)")
//                }
//                
//                else if card_type.contains("Credit") || card_type.contains("credit"){
//                    smallOrderSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
//                    smallOrderSumValue.append("\(cash_discount)")
//                }
//                
//                else {
//                    
//                }
//            }
//        }
//        
//        let tax = orderDetail?.tax ?? ""
//        
//        if tax != "0.0" && tax != "0.00" && tax != "-0.00" && tax != "-0.0" && tax != "0" && tax != "" {
//            smallOrderSum.append("DefaultTax")
//            smallOrderSumValue.append("\(tax)")
//        }
//        
//        let other_taxes = orderDetail?.other_taxes_desc ?? ""
//        
//        if other_taxes != "0.0" && other_taxes != "0.00" && other_taxes != "-0.00" && other_taxes != "-0.0"
//            && other_taxes != "0" && other_taxes != "" {
//            let tax_desc = convertStringToDictionary(text: other_taxes)
//            
//            for (key, value) in tax_desc {
//                smallOrderSum.append(key)
//                smallOrderSumValue.append("\(value)")
//            }
//        }
//        
//        
//        orderSum = smallOrderSum
//        orderSumValue = smallOrderSumValue
//        
//        if orderDetail?.is_refunded == "1" {
//            let amt = amtValue.text ?? "0.00"
//            grandTotalValue.text = "$\(String(format: "%.02f", roundOf(item: "\(amt)")))"
//        }
//        else {
//            calculateGrandTotal(pay: orderSumValue)
//        }
//        
//        //paytable
//        
//        var smallPaySum = [String]()
//        var smallPaySumValue = [String]()
//        
//        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
//            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent)  {
//            smallPaySum.append("Points Applied")
//            smallPaySumValue.append("(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))")
//        }
//        
//        if gift_card_amount != "0.0" && gift_card_amount != "0.00" && gift_card_amount != "-0.0" &&
//            gift_card_amount != "-0.00" && gift_card_amount != "0" && gift_card_amount != "" && handleZero(value: gift_card_amount) {
//            smallPaySum.append("Gift Card Applied")
//            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: gift_card_amount)))")
//        }
//        
////        if total_lottery_pay != "0.0" && total_lottery_pay != "0.00" && total_lottery_pay != "-0.0" &&
////            total_lottery_pay != "-0.00" && total_lottery_pay != "0" && total_lottery_pay != "" && handleZero(value: total_lottery_pay) {
////            smallPaySum.append("Lottery Payout")
////            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: total_lottery_pay)))")
////        }
////        
////        if total_scratcher_payout != "0.0" && total_scratcher_payout != "0.00" && total_scratcher_payout != "-0.0" &&
////            total_scratcher_payout != "-0.00" && total_scratcher_payout != "0" && total_scratcher_payout != "" && handleZero(value: total_scratcher_payout) {
////            smallPaySum.append("Scratcher Payout")
////            let scratcher_payout_doub = Double(total_scratcher_payout) ?? 0.00
////            let order_pay_doub = Double(scratch_cash_pay) ?? 0.00
////            if order_pay_doub < scratcher_payout_doub {
////                let amt_scratch = scratcher_payout_doub - order_pay_doub
////                smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: "\(amt_scratch)")))")
////            }
////            else {
////                smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: total_scratcher_payout)))")
////            }
////        }
//        
//        
//        
//        let isloyal = orderDetail?.is_loyality ?? "0"
//        let iscredit = orderDetail?.is_store_credit ?? "0"
//        let isgift = orderDetail?.is_gift_card ?? "0"
//        
//        
//        if split == "1"  {
//            
//            var card_count = 0
//            var cash_count = 0
//            var food_count = 0
//            var ecash_count = 0
//            
//            var small_card_cash = [String]()
//            
//            for split_way in splitDetail {
//                
//                if split_way.pay_type == "credit" {
//                    
//                    if split_way.card_type.contains("FoodEbt") {
//                        if food_count != 1 {
//                            small_card_cash.append("Food EBT")
//                            smallPaySum.append("Food EBT")
//                            food_count = 1
//                        }
//                    }
//                    
//                    else if split_way.card_type.contains("CashEbt") {
//                        if ecash_count != 1 {
//                            small_card_cash.append("Cash EBT")
//                            smallPaySum.append("Cash EBT")
//                            ecash_count = 1
//                        }
//                    }
//                    
//                    else {
//                        if card_count != 1 {
//                            small_card_cash.append("Credit Card")
//                            smallPaySum.append("Credit Card")
//                            card_count = 1
//                        }
//                    }
//                }
//                
//                else if split_way.pay_type == "debit" {
//                    
//                    if split_way.card_type.contains("FoodEbt") {
//                        if food_count != 1 {
//                            small_card_cash.append("Food EBT")
//                            smallPaySum.append("Food EBT")
//                            food_count = 1
//                        }
//                    }
//                    
//                    else if split_way.card_type.contains("CashEbt") {
//                        if ecash_count != 1 {
//                            small_card_cash.append("Cash EBT")
//                            smallPaySum.append("Cash EBT")
//                            ecash_count = 1
//                        }
//                    }
//                    
//                    else {
//                        if card_count != 1 {
//                            small_card_cash.append("Credit Card")
//                            smallPaySum.append("Credit Card")
//                            card_count = 1
//                        }
//                    }
//                }
//                else {
//                    if cash_count != 1 {
//                        small_card_cash.append("Cash")
//                        smallPaySum.append("Cash")
//                        cash_count = 1
//                    }
//                }
//            }
//            
//            var small_card = [String]()
//            var small_cash = [String]()
//            var small_food = [String]()
//            var small_ecash = [String]()
//            
//            for split_way_info in splitDetail {
//                
//                if split_way_info.pay_type == "credit" {
//                    
//                    if split_way_info.card_type.contains("FoodEbt") {
//                        small_food.append(split_way_info.pay_amount)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                    
//                    else if split_way_info.card_type.contains("CashEbt") {
//                        small_ecash.append(split_way_info.pay_amount)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                    
//                    else {
//                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
//                        small_card.append(cred_tip)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                }
//                else if split_way_info.pay_type == "debit" {
//                    
//                    if split_way_info.card_type.contains("FoodEbt") {
//                        small_food.append(split_way_info.pay_amount)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                    
//                    else if split_way_info.card_type.contains("CashEbt") {
//                        small_ecash.append(split_way_info.pay_amount)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                    
//                    else {
//                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
//                        small_card.append(cred_tip)
//                        let pax = split_way_info.pax_details
//                        if pax != "" {
//                            pax_details += "\n\n\(pax)"
//                        }
//                    }
//                }
//                else  {
//                    small_cash.append(split_way_info.pay_amount)
//                }
//            }
//            
//            var card = Double()
//            var cash = Double()
//            var food = Double()
//            var ecash = Double()
//            
//            if small_card.count != 0 {
//                card = calculateSplitCard(card: small_card)
//            }
//            
//            if small_cash.count != 0 {
//                cash = calculateSplitCash(cash: small_cash)
//            }
//            
//            if small_food.count != 0 {
//                food = calculateSplitEbt(cash: small_food)
//            }
//            
//            if small_ecash.count != 0 {
//                ecash = calculateSplitEbt(cash: small_ecash)
//            }
//            
//            for small in small_card_cash {
//                
//                if small == "Cash" {
////                    let cal_amt = calculateCashLottery(amt: "\(cash)")
//                    smallPaySumValue.append(String(format: "%.02f", cash))
//                }
//                else if small == "Food EBT" {
////                    let cal_amt = calculateCashLottery(amt: "\(food)")
//                    smallPaySumValue.append(String(format: "%.02f", food))
//                }
//                else if small == "Cash EBT" {
////                    let cal_amt = calculateCashLottery(amt: "\(ecash)")
//                    smallPaySumValue.append(String(format: "%.02f", ecash))
//                }
//                else {
////                    let cal_amt = calculateCashLottery(amt: "\(card)")
//                    smallPaySumValue.append(String(format: "%.02f", card))
//                }
//            }
//        }
//        
//        else if isloyal == "2" || iscredit == "2" || isgift == "2"
//                    || isloyal == "1" || iscredit == "1" || isgift == "1" {
//            
//            if isloyal == "1" && iscredit == "1" && isgift == "1" {
//                
//                if payment_id == "Cash" {
//                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                    
//                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                        smallPaySum.append("Cash")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
//                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                            smallPaySum.append("Credit Card")
////                            let cal_amt = calculateCashLottery(amt: cred_amt)
//                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                        }
//                    }
//                }
//            }
//            
//            else if isloyal == "1" && iscredit == "1" {
//                
//                if payment_id == "Cash" {
//                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                          - roundOf(item: store_credit))
//                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                        smallPaySum.append("Cash")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                              - roundOf(item: store_credit))
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                              - roundOf(item: store_credit))
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
//                                              - roundOf(item: store_credit))
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
//                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                            smallPaySum.append("Credit Card")
////                            let cal_amt = calculateCashLottery(amt: cred_amt)
//                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                        }
//                    }
//                }
//            }
//            
//            else if iscredit == "1" && isgift == "1" {
//                
//                if payment_id == "Cash" {
//                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                        smallPaySum.append("Cash")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
//                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                            smallPaySum.append("Credit Card")
////                            let cal_amt = calculateCashLottery(amt: cred_amt)
//                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                        }
//                    }
//                }
//            }
//            
//            else if isloyal == "1" && isgift == "1" {
//                
//                if payment_id == "Cash" {
//                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
//                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                        smallPaySum.append("Cash")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
//                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
//                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
//                            smallPaySum.append("Credit Card")
////                            let cal_amt = calculateCashLottery(amt: cred_amt)
//                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                        }
//                    }
//                }
//            }
//            
//            else if isloyal == "1" {
//                
//                if payment_id == "Cash" {
//                    
//                    smallPaySum.append("Cash")
//                    let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
////                    let cal_amt = calculateCashLottery(amt: cred_amt)
//                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        smallPaySum.append("Credit Card")
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
////                        let cal_amt = calculateCashLottery(amt: amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
//                    }
//                }
//            }
//            
//            else if iscredit == "1" {
//                
//                if payment_id == "Cash" {
//                    
//                    smallPaySum.append("Cash")
//                    let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
////                    let cal_amt = calculateCashLottery(amt: cred_amt)
//                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(cred_amt)
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                    
//                    else {
//                        smallPaySum.append("Credit Card")
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
////                        let cal_amt = calculateCashLottery(amt: cred_amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
//                    }
//                }
//            }
//            
//            else if isgift == "1" {
//                
//                if payment_id == "Cash" {
//                    
//                    smallPaySum.append("Cash")
//                    let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
//                    smallPaySumValue.append(cred_amt)
//                }
//                else {
//                    
//                    if card_type.contains("CashEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
//                        smallPaySum.append("Cash EBT")
//                        smallPaySumValue.append(amt)
//                    }
//                    
//                    else if card_type.contains("FoodEbt") {
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
//                        smallPaySum.append("Food EBT")
//                        smallPaySumValue.append(amt)
//                    }
//                    
//                    else {
//                        smallPaySum.append("Credit Card")
//                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
//                        smallPaySumValue.append(cred_amt)
//                    }
//                }
//            }
//            
//            else {
//                
//            }
//        }
//        
//        else {
//            if payment_id == "Cash" {
//                
//                if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != ""  {
//                    smallPaySum.append("Cash")
////                    let cal_amt = calculateCashLottery(amt: amt)
//                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
//                }
//            }
//            else {
//                
//                if card_type.contains("CashEbt") {
//                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
//                        smallPaySum.append("Cash EBT")
////                        let cal_amt = calculateCashLottery(amt: amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
//                    }
//                }
//                
//                else if card_type.contains("FoodEbt") {
//                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
//                        smallPaySum.append("Food EBT")
////                        let cal_amt = calculateCashLottery(amt: amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
//                    }
//                }
//                
//                else {
//                    
//                    
//                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
//                        smallPaySum.append("Credit Card")
//                        let pax = orderDetail?.pax_details ?? ""
//                        if pax != "" {
//                            pax_details = "\n\n\(pax)"
//                        }
////                        let cal_amt = calculateCashLottery(amt: amt)
//                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
//                    }
//                }
//            }
//        }
//        
//        if cash_back_amt != "0.0" && cash_back_amt != "0.00" && cash_back_amt != "-0.0" && cash_back_amt != "-0.00" && cash_back_amt != "0" && cash_back_amt != "" && handleZero(value: cash_back_amt) {
//            smallPaySum.append("Cashback Amount")
//            smallPaySumValue.append(cash_back_amt)
//        }
//        
//        if cash_back_fee != "0.0" && cash_back_fee != "0.00" && cash_back_fee != "-0.0" && cash_back_fee != "-0.00" && cash_back_fee != "0" && cash_back_fee != "" && handleZero(value: cash_back_fee) {
//            smallPaySum.append("Cashback Fee")
//            smallPaySumValue.append(cash_back_fee)
//        }
//        
//        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" && store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(value: store_credit) {
//            smallPaySum.append("Store Credit")
//            smallPaySumValue.append(store_credit)
//        }
//        
//        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00"
//            && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
//            smallPaySum.append("Points Awarded")
//            smallPaySumValue.append(points_earned)
//        }
//        
//        paySum = smallPaySum
//        paySumValue = smallPaySumValue
//        
//    }
//    
//    func setCartData(cart: Any) {
//        
//        let smallres = cart as! [[String:Any]]
//        var smallcart = [Cart_Data]()
//        var smallrefcart = [Cart_Data]()
//        
//        for res in smallres {
//            
//            let cart = Cart_Data(line_item_id: "\(res["line_item_id"] ?? "")", name: "\(res["name"] ?? "")",
//                                 is_bulk_price: "\(res["is_bulk_price"] ?? "")",
//                                 bulk_price_id: "\(res["bulk_price_id"] ?? "")",
//                                 qty: "\(res["qty"] ?? "")", note: "\(res["note"] ?? "")",
//                                 userData: "\(res["userData"] ?? "")",
//                                 taxRates: "\(res["taxRates"] ?? "")",
//                                 default_tax_amount: "\(res["default_tax_amount"] ?? "")",
//                                 other_taxes_amount: "\(res["other_taxes_amount"] ?? "")",
//                                 other_taxes_desc: "\(res["other_taxes_desc"] ?? "")",
//                                 is_refunded: "\(res["is_refunded"] ?? "")",
//                                 refund_amount: "\(res["refund_amount"] ?? "")",
//                                 refund_qty: "\(res["refund_qty"] ?? "")", id: "\(res["id"] ?? "")",
//                                 img: "\(res["img"] ?? "")", price: "\(res["price"] ?? "")",
//                                 discount_amt: "\(res["discount_amt"] ?? "")",
//                                 discount_rate: "\(res["discount_rate"] ?? "")",
//                                 adjust_price: "\(res["adjust_price"] ?? "")",
//                                 use_point: "\(res["use_point"] ?? "")",
//                                 earn_point: "\(res["earn_point"] ?? "")")
//            
//            if cart.is_refunded == "1" {
//                smallrefcart.append(cart)
//            }
//            else if cart.is_refunded == "2" {
//                smallrefcart.append(cart)
//                smallcart.append(cart)
//            }
//            else {
//                smallcart.append(cart)
//            }
//        }
//        print(smallcart.count)
//        print(smallrefcart.count)
//        cartItems = smallcart
//        cartRefundItems = smallrefcart
//        
//        if cartRefundItems.count == 0 {
//            instoreRefundViewHeight.constant = 0
//            refundedLbl.text = ""
//            instoreViewHeight.constant = 50
//            instoreLbl.text = "In-Store Order"
//        }
//        
//        else if cartItems.count == 0 {
//            instoreViewHeight.constant = 0
//            instoreLbl.text = ""
//            instoreRefundViewHeight.constant = 50
//            refundedLbl.text = "Refunded Items"
//        }
//        else {
//            instoreRefundViewHeight.constant = 50
//            refundedLbl.text = "Refunded Items"
//            instoreViewHeight.constant = 50
//            instoreLbl.text = "In-Store Order"
//        }
//        
//        let itemCounts = cartItems.count + cartRefundItems.count
//        
//        if itemCounts == 1 {
//            itemCount.text = "(\(itemCounts) item)"
//        }
//        else {
//            itemCount.text = "(\(itemCounts) items)"
//        }
//        
//        orderDetailLabel.append("Total Items")
//        orderDetailValue.append("\(itemCounts)")
//    }
//    
//    
//    func setSplitData(split: Any) {
//        
//        let split_data = split as! [[String:Any]]
//        var smallSplit = [Split_Data]()
//        
//        for pay in split_data {
//            
//            let split_pay = Split_Data(id: "\(pay["id"] ?? "")", order_id: "\(pay["order_id"] ?? "")",
//                                       merchant_id: "\(pay["merchant_id"] ?? "")", pay_count: "\(pay["pay_count"] ?? "")",
//                                       pay_type: "\(pay["pay_type"] ?? "")", pay_amount: "\(pay["pay_amount"] ?? "")",
//                                       remaining_amount: "\(pay["remaining_amount"] ?? "")",
//                                       cash_discounting_amount: "\(pay["cash_discounting_amount"] ?? "")",
//                                       cash_discounting_percentage: "\(pay["cash_discounting_percentage"] ?? "")",
//                                       payment_id: "\(pay["payment_id"] ?? "")", tip: "\(pay["tip"] ?? "")",
//                                       pax_details: "\(pay["pax_details"] ?? "")",
//                                       card_type: "\(pay["card_type"] ?? "")", last_four_digit: "\(pay["last_four_digit"] ?? "")",
//                                       created_date_time: "\(pay["created_date_time"] ?? "")", adv_id: "\(pay["adv_id"] ?? "")",
//                                       split_by_emp: "\(pay["split_by_emp"] ?? "")", shift_setting: "\(pay["shift_setting"] ?? "")")
//            
//            smallSplit.append(split_pay)
//        }
//        splitDetail = smallSplit
//    }
//    
//    func setCustData() {
//        
//        if orderDetail?.billing_name == "" && orderDetail?.deliver_name == ""  {
//            custName = "untitled"
//        }
//        else if orderDetail?.billing_name == "<null>" && orderDetail?.deliver_name == "<null>" {
//            custName = "untitled"
//        }
//        
//        else if orderDetail?.billing_name == "" && orderDetail?.deliver_name == "<null>" {
//            custName = "untitled"
//        }
//        
//        else if orderDetail?.billing_name == "<null>" && orderDetail?.deliver_name == "" {
//            custName = "untitled"
//        }
//        else if orderDetail?.billing_name == "" {
//            custName = orderDetail?.deliver_name ?? ""
//        }
//        else if orderDetail?.deliver_name == "" {
//            custName = orderDetail?.billing_name ?? ""
//        }
//        else {
//            custName = orderDetail?.billing_name ?? ""
//        }
//        
//        custAddr = orderDetail?.delivery_addr ?? ""
//        
//        if orderDetail?.delivery_phn == "" && orderDetail?.customer_phone == "" {
//            cust_exist = false
//            custNumber = ""
//            custMail = ""
//        }
//        
//        else if orderDetail?.delivery_phn == "" && orderDetail?.customer_phone == "<null>" {
//            cust_exist = false
//            custNumber = ""
//            custMail = ""
//        }
//        
//        else if orderDetail?.delivery_phn == "<null>" && orderDetail?.customer_phone == "" {
//            cust_exist = false
//            custNumber = ""
//            custMail = ""
//        }
//        
//        else if orderDetail?.delivery_phn == "<null>" && orderDetail?.customer_phone == "<null>" {
//            cust_exist = false
//            custNumber = ""
//            custMail = ""
//        }
//        
//        else {
//            
//            if orderDetail?.delivery_phn == "" {
//                custNumber = orderDetail?.customer_phone ?? ""
//                cust_exist = true
//                
//                if orderDetail?.email == "" {
//                    custMail = orderDetail?.customer_email ?? ""
//                }
//                else {
//                    custMail = orderDetail?.email ?? ""
//                }
//            }
//            else {
//                custNumber = orderDetail?.delivery_phn ?? ""
//                cust_exist = true
//                
//                if orderDetail?.email == "" {
//                    custMail = orderDetail?.customer_email ?? ""
//                }
//                else {
//                    custMail = orderDetail?.email ?? ""
//                }
//            }
//        }
//    }
//    
//    func setRefundData(refund_data: Any) {
//        
//        let refund = refund_data as! [[String:Any]]
//        refundDetail = refund
//        
//        var smallRefund = [[String]]()
//        var smallRefundVal = [[String]]()
//        var smallDate = [String]()
//        
//        for ref in refund {
//            
//            let refund_pay = Refund_Data(refund_id: "\(ref["refund_id"] ?? "")", refunded_by_emp: "\(ref["refunded_by_emp"] ?? "")",
//                                         amount: "\(ref["amount"] ?? "")", debit_amt: "\(ref["debit_amt"] ?? "")",
//                                         cash_amt: "\(ref["cash_amt"] ?? "")", loyalty_point_amt: "\(ref["loyalty_point_amt"] ?? "")",
//                                         store_credit_amt: "\(ref["store_credit_amt"] ?? "")", reason: "\(ref["reason"] ?? "")",
//                                         created_at: "\(ref["created_at"] ?? "")", nca_amt: "\(ref["nca_amt"] ?? "")",
//                                         tip_amt: "\(ref["tip_amt"] ?? "")", giftcard_amt: "\(ref["giftcard_amt"] ?? "")")
//            
//            let amt = refund_pay.amount
//            let card_pay = refund_pay.debit_amt
//            let cash_pay = refund_pay.cash_amt
//            let loyalty_amt = refund_pay.loyalty_point_amt
//            let store_cred = refund_pay.store_credit_amt
//            let refund_reason = refund_pay.reason
//            let create_date = refund_pay.created_at
//            let tip_amt = refund_pay.tip_amt
//            let gift_card = refund_pay.giftcard_amt
//            let nca_amt = refund_pay.nca_amt
//            
//            var smallRef = [String]()
//            var smallRefValues = [String]()
//            
//            smallRef.append("Reason Of Refund")
//            smallRefValues.append(refund_reason)
//            
//            if card_pay != "0.00" {
//                smallRef.append("Credit Card")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: card_pay)))")
//                
//            }
//            
//            if cash_pay != "0.00" {
//                smallRef.append("Cash")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: cash_pay)))")
//                
//            }
//            
//            if loyalty_amt != "0.00" {
//                smallRef.append("Loyalty Points")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: loyalty_amt)))")
//                
//            }
//            
//            if store_cred != "0.00" {
//                smallRef.append("Store Credits")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: store_cred)))")
//                
//            }
//            
//            if tip_amt != "0.00" {
//                smallRef.append("Tip")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: tip_amt)))")
//                
//            }
//            
//            if gift_card != "0.00" {
//                smallRef.append("Gift Card")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: gift_card)))")
//                
//            }
//            
//            if nca_amt != "0.00" {
//                
//                smallRef.append("Non Cash Adjustment")
//                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: nca_amt)))")
//            }
//            smallRefund.append(smallRef)
//            smallRefundVal.append(smallRefValues)
//            smallDate.append(create_date)
//        }
//        
//        payRefund = smallRefund
//        payRefundValues = smallRefundVal
//        payRefundDate = smallDate
//    }
//    
//    
//    func setIdData(id: Any) {
//        
//        let identity = id as! [String:Any]
//        let id_detail = IdentificationDetails(i_card_type: "\(identity["i_card_type"] ?? "")",
//                                              i_card_number: "\(identity["i_card_number"] ?? "")",
//                                              i_card_ex_date: "\(identity["i_card_ex_date"] ?? "")",
//                                              i_card_dob: "\(identity["i_card_dob"] ?? "")",
//                                              i_card_front_img: "\(identity["i_card_front_img"] ?? "")",
//                                              i_card_back_img: "\(identity["i_card_back_img"] ?? "")")
//        
//        idDetail = id_detail
//        
//        let card_type = idDetail?.i_card_type ?? ""
//        let card_number = idDetail?.i_card_number ?? ""
//        let card_ex = idDetail?.i_card_ex_date ?? ""
//        let card_dob = idDetail?.i_card_dob ?? ""
//        let date = orderDetail?.date_time ?? ""
//        
//        var smallIdNames = [String]()
//        var smallIdValues = [String]()
//        
//        if card_type != "" {
//            smallIdNames.append("Identification Card Type")
//            smallIdValues.append(card_type)
//        }
//        
//        if card_number != "" {
//            smallIdNames.append("Identification Number")
//            smallIdValues.append(card_number)
//        }
//        
//        if date != "" {
//            smallIdNames.append("Date & Time")
//            smallIdValues.append(date)
//        }
//        
//        if card_ex != "" && card_ex != "0000-00-00"  {
//            smallIdNames.append("Expiry Date")
//            smallIdValues.append(card_ex)
//        }
//        
//        if card_dob != "" {
//            smallIdNames.append("Date of Birth")
//            smallIdValues.append(card_dob)
//        }
//        idRefundName = smallIdNames
//        idRefundValue = smallIdValues
//    }
//    
//    func convertStringToDictionary(text: String) -> [String:Any] {
//        if let data = text.data(using: .utf8) {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
//                return json
//            } catch {
//                print("Something went wrong")
//            }
//        }
//        return [:]
//    }
//    
//    func handleZero(value: String) -> Bool {
//        
//        let doub = roundOf(item: value)
//        let doub_value = Double(doub)
//        
//        if doub_value < 0.0 {
//            
//            return false
//        }
//        else {
//            return true
//            
//        }
//    }
//    
//    func calculateRefPayAmt(amt: String, ref_amt: String) -> String {
//        
//        
//        let amt1 = roundOf(item: amt)
//        let amt2 = roundOf(item: ref_amt)
//        
//        let amt_doub = amt1
//        let ref_amt_doub = amt2
//        
//        print(amt_doub)
//        print(ref_amt_doub)
//        
//        let total = amt_doub - ref_amt_doub
//        return String(total)
//        
//    }
//    
//    func calculateDiscount(amt: String, discount: String) -> String {
//        
//        let amt1 = roundOf(item: amt)
//        let amt2 = roundOf(item: discount)
//        
//        let amt_doub = amt1
//        let ref_amt_doub = amt2
//        
//        print(amt_doub)
//        print(ref_amt_doub)
//        
//        let total = amt_doub - ref_amt_doub
//        return String(total)
//        
//    }
//    
//    func calculateSplitCard(card: [String]) -> Double {
//        
//        var doub_amt = Double()
//        
//        for pay in card {
//            let doub = Double(pay) ?? 0.00
//            doub_amt += doub
//        }
//        print(doub_amt)
//        return doub_amt
//    }
//    
//    func calculateSplitCash(cash: [String]) -> Double {
//        
//        var doub_amt = Double()
//        
//        for pay in cash {
//            let doub = Double(pay) ?? 0.00
//            doub_amt += doub
//        }
//        print(doub_amt)
//        return doub_amt
//    }
//    
//    func calculateSplitEbt(cash: [String]) -> Double {
//        
//        var doub_amt = Double()
//        
//        for pay in cash {
//            let doub = Double(pay) ?? 0.00
//            doub_amt += doub
//        }
//        print(doub_amt)
//        return doub_amt
//    }
//    
//    func calSplitTipCard(amt: String, tip: String) -> String {
//        
//        let cred = roundOf(item: amt)
//        print(tip)
//        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" {
//            let tip_pay = roundOf(item: tip)
//            let cred_pay = cred - tip_pay
//            print(cred)
//            print(tip_pay)
//            print(cred_pay)
//            return String(cred_pay)
//        }
//        else {
//            return String(cred)
//        }
//    }
//    
////    func calculateCashLottery(amt: String) -> String {
////        
////        let amt_doub = Double(amt) ?? 0.00
////        let lottery_doub = Double(couponCode?.total_lottery_payout ?? "") ?? 0.00
////        let scratch_doub = Double(couponCode?.total_scratcher_payout ?? "") ?? 0.00
////        let scratch_order_doub = Double(couponCode?.scratch_cash_pay ?? "") ?? 0.00
////        
////        if scratch_order_doub < scratch_doub {
////            
////            if lottery_doub < scratch_doub {
////                return String(amt_doub - (scratch_doub - scratch_order_doub) - lottery_doub)
////            }
////            else {
////                return String(amt_doub - (lottery_doub - (scratch_doub - scratch_order_doub)))
////            }
////        }
////        else {
////            if lottery_doub < scratch_doub {
////                return String(amt_doub - scratch_doub - lottery_doub)
////            }
////            else {
////                return String(amt_doub - lottery_doub - scratch_doub)
////            }
////        }
////    }
//    
//    func getCountForSection(section: Int) -> Int {
//        
//        if payRefund.count == 0 {
//            return 0
//        }
//        else {
//            return payRefund[section].count
//        }
//    }
//    
//    func getCountForHeight() -> Int {
//        var counter = 0
//        if payRefund.count == 0 {
//            return 0
//        }
//        else {
//            
//            for pay in payRefund {
//                counter = counter + pay.count
//            }
//            return counter
//        }
//    }
//    
//    
//    func roundOf(item : String) -> Double {
//        
//        var itemDollar = ""
//        
//        if item.starts(with: "$") || item.starts(with: "-") {
//            itemDollar = String(item.dropFirst())
//            let doub = Double(itemDollar) ?? 0.00
//            let div = (100 * doub) / 100
//            return div
//        }
//        else {
//            let doub = Double(item) ?? 0.00
//            let div = (100 * doub) / 100
//            print(div)
//            return div
//        }
//    }
//    
//    func calculateGrandTotal(pay: [String]) {
//        var grand = 0.00
//        
//        if amtValue.text == "$0.00" {
//            grand = 0.00
//        }
//        
//        else {
//            for add in 0..<pay.count {
//                
//                let doub = Double(pay[add]) ?? 0.00
//                
//                if pay[add] == couponCode?.coupon_code_amt {
//                    grand -= doub
//                }
//                else {
//                    grand += doub
//                }
//            }
//        }
//        
//        let cash_back_amt = orderDetail?.cash_back_amt ?? "0.00"
//        let cash_back_fee = orderDetail?.cash_back_fee ?? "0.00"
//        
//        let granCal = roundOf(item: "\(grand)") + roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
//        print("$\(String(format: "%.02f", roundOf(item: "\(granCal)")))")
//        grandTotalValue.text = "$\(String(format: "%.02f", roundOf(item: "\(granCal)")))"
//    }
//    
//    
//    @IBAction func payInfoClick(_ sender: UIButton) {
//        
//        var amt_arr = [String]()
//        var pay_arr = [String]()
//        var pay_mode = [String]()
//        var pay_per = [String]()
//        
//        for split in splitDetail {
//            
//            var amt = roundOf(item: split.pay_amount)
//            var pay = roundOf(item: split.cash_discounting_amount)
//            var per = roundOf(item: split.cash_discounting_percentage)
//            let mode = split.pay_type.capitalized
//            
//            let amt1 = amt - pay
//            print(amt1)
//            amt_arr.append(String(format: "%.02f", amt1))
//            if split.pay_type == "cash" || split.pay_type == "Cash" {
//                pay_arr.append("")
//                pay_per.append("")
//            }
//            else {
//                pay_arr.append(String(format: "%.02f", pay))
//                pay_per.append(String(format: "%.02f", per))
//            }
//            pay_mode.append(mode)
//        }
//        
//        showAlert(amt: amt_arr, pay: pay_arr, mode: pay_mode, cash: pay_per)
//    }
//    
//    func showAlert(amt: [String], pay: [String], mode: [String], cash: [String]) {
//        
//        var msgArray = [NSMutableAttributedString]()
//        
//        for payments in 0..<amt.count {
//            
//            var split_info = ""
//            if pay[payments] == "" {
//                split_info = "\n\n\(mode[payments]): $\(amt[payments])\n"
//            }
//            else {
//                split_info = "\n\n\(mode[payments]): $\(amt[payments])\n(\(cash[payments])%): +$\(pay[payments])"
//            }
//            
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = NSTextAlignment.left
//            
//            let messageText = NSMutableAttributedString(
//                string: split_info,
//                attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
//                    NSAttributedString.Key.font: UIFont(name: "Manrope-Medium", size: 13.0)!
//                ])
//            
//            if pay[payments] != "" {
//                let loc = messageText.length - 6
//                let range = NSRange(location: loc, length: 6)
//                messageText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
//            }
//            
//            msgArray.append(messageText)
//        }
//        let alertController = UIAlertController(title: "Split Payment", message: "", preferredStyle: .alert)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//            
//            print("Ok button tapped")
//            
//        }
//        
//        alertController.addAction(OKAction)
//        
//        let msgText = NSMutableAttributedString()
//        
//        for msg in msgArray {
//            
//            msgText.append(msg)
//        }
//        
//        alertController.setValue(msgText, forKey: "attributedMessage")
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    func showAlertPax(title: String, pax: String) {
//        
//        
//        let alertController = UIAlertController(title: title, message: pax, preferredStyle: .alert)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//            
//            print("Ok button tapped")
//            
//        }
//        
//        alertController.addAction(OKAction)
//        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.left
//        
//        let messageText = NSMutableAttributedString(
//            string: pax,
//            attributes: [
//                NSAttributedString.Key.paragraphStyle: paragraphStyle,
//                NSAttributedString.Key.font: UIFont(name: "Manrope-Medium", size: 13.0)!])
//        
//        alertController.setValue(messageText, forKey: "attributedMessage")
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func cardInfoClick(_ sender: UIButton) {
//        
//        showAlertPax(title: "Card Details", pax: pax_details)
//    }
//    
//    
//    @IBAction func homeBtnClick(_ sender: UIButton) {
//        
//        var destiny = 0
//        
//        let viewcontrollerArray = navigationController?.viewControllers
//        
//        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
//            destiny = destinationIndex
//        }
//        
//        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
//    }
//    
//    
//    
//    @IBAction func backBtnClick(_ sender: UIButton) {
//        
//        navigationController?.popViewController(animated: true)
//    }
//    
//    private func setupUI() {
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .light
//        }
//        
//        
//        view.addSubview(loadingIndicator)
//        
//        NSLayoutConstraint.activate([
//            loadingIndicator.centerXAnchor
//                .constraint(equalTo: view.centerXAnchor, constant: 0),
//            loadingIndicator.centerYAnchor
//                .constraint(equalTo: view.centerYAnchor),
//            loadingIndicator.widthAnchor
//                .constraint(equalToConstant: 40),
//            loadingIndicator.heightAnchor
//                .constraint(equalTo: self.loadingIndicator.widthAnchor)
//        ])
//    }
//}

//extension InStoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        if tableView == tableview {
//            return 1
//        }
//        
//        else if tableView == orderDetailTable {
//            return 1
//        }
//        
//        else if tableView == taxTableView {
//            return 1
//        }
//        
//        else if tableView == feeTable {
//            return 1
//        }
//        
//        else if tableView == refundTable {
//            return 1
//        }
//        
//        else if tableView == payRefundTable {
//            return payRefund.count
//        }
//        
//        else if tableView == payRefundItemsTable {
//            return 1
//        }
//        
//        else if tableView == orderSumTable {
//            return 1
//        }
//        
//        else if tableView == payTableView {
//            return 1
//        }
//        
////        else if tableView == identityTable {
////            
////            if id_exist {
////                return 1
////            }
////            else {
////                return 0
////            }
////        }
//        
//        else if tableView == custTable {
//            
//            if cust_exist {
//                return 1
//            }
//            else {
//                return 0
//            }
//        }
//        
//        else {
//            return 1
//        }
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if tableView == tableview {
//            return cartItems.count
//        }
//        
//        else if tableView == orderDetailTable {
//            return orderDetailLabel.count
//        }
//        
//        else if tableView == taxTableView {
//            return 2
//        }
//        
//        else if tableView == feeTable {
//            return 2
//        }
//        
//        else if tableView == refundTable {
//            return 2
//        }
//        
//        else if tableView == payRefundTable {
//            return payRefund[section].count
//        }
//        
//        else if tableView == payRefundItemsTable {
//            return cartRefundItems.count
//        }
//        
//        else if tableView == orderSumTable {
//            return orderSum.count
//        }
//        
//        else if tableView == payTableView {
//            return paySum.count
//        }
//        
////        else if tableView == identityTable {
////            return idRefundName.count
////        }
//        
//        else if tableView == custTable {
//            if cust_exist {
//                return 2
//            }
//            else {
//                return 0
//            }
//        }
//        
//        else {
//            return 1
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == tableview {
//            
//            let cell = tableview.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as! InStoreProductTableViewCell
//            
//            let cart = cartItems[indexPath.row]
//            
//            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
//            let name_note = note.replacingOccurrences(of: "Name-", with: "")
//            if let range = name_note.range(of: "null") {
//                let itemName = name_note.prefix(upTo: range.lowerBound)
//                cell.itemName.text = String(itemName)
//            }
//            else {
//                cell.itemName.text = name_note
//            }
//            
//            
//            cell.onePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.price)))"
//            cell.itemQty.text = "\(cart.qty)x"
//            
//            if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" {
//                
//                cell.itemDiscount.text = ""
//                cell.itemDisPrice.text = ""
//            }
//            else {
//                
//                cell.itemDiscount.text = "Item Discount"
//                cell.itemDisPrice.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
//            }
//            
//            cell.totalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.price, qty: cart.qty, discount: cart.discount_amt)))"
//            
//            return cell
//        }
//        
//        else if tableView == orderDetailTable {
//            
//            let cell = orderDetailTable.dequeueReusableCell(withIdentifier: "orderdetcell", for: indexPath) as! InStoreOrderSumCell
//            
//            cell.orderLbl.text = orderDetailLabel[indexPath.row]
//            cell.orderLblValue.text = orderDetailValue[indexPath.row]
//            
//            return cell
//            
//        }
//        
//        else if tableView == taxTableView {
//            
//            let cell = taxTableView.dequeueReusableCell(withIdentifier: "taxcell", for: indexPath) as! InStoreTaxTableViewCell
//            
//            cell.taxName.text = "Sales Tax"
//            cell.taxpercent.text = "8.25%"
//            cell.taxAmt.text = "$150.00"
//            cell.salesTax.text = "$12.38"
//            
//            return cell
//            
//        }
//        
//        else if tableView == feeTable {
//            
//            let cell = feeTable.dequeueReusableCell(withIdentifier: "feecell", for: indexPath) as! InStorePayTableCell
//            
//            cell.payName.text = "Fee Names"
//            cell.payValue.text = "Fee Values"
//            
//            return cell
//        }
//        
//        else if tableView == refundTable {
//            
//            let cell = refundTable.dequeueReusableCell(withIdentifier: "afterrefundcell", for: indexPath) as! InStorePayTableCell
//            
//            cell.payName.text = "Refund Name"
//            cell.payValue.text = "Refund Value"
//            
//            return cell
//        }
//        
//        else if tableView == payRefundTable {
//            
//            let cell = payRefundTable.dequeueReusableCell(withIdentifier: "payrefundcell", for: indexPath) as! PayRefundCell
//            
//            cell.payRefundLbl.text = payRefund[indexPath.section][indexPath.row]
//            cell.payRefundValues.text = payRefundValues[indexPath.section][indexPath.row]
//            
//            return cell
//            
//        }
//        
//        else if tableView == payRefundItemsTable {
//            
//            let cell = payRefundItemsTable.dequeueReusableCell(withIdentifier: "payrefunditemscell", for: indexPath) as! PayRefundItemsCell
//            
//            let cart = cartRefundItems[indexPath.row]
//            
//            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
//            let name_note = note.replacingOccurrences(of: "Name-", with: "")
//            if let range = name_note.range(of: "null") {
//                let itemName = name_note.prefix(upTo: range.lowerBound)
//                cell.payRefName.text = String(itemName)
//            }
//            else {
//                cell.payRefName.text = name_note
//            }
//            
//            cell.payRefOnePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.price)))"
//            cell.payRefQty.text = "\(cart.refund_qty)x"
//            
//            if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" {
//                
//                cell.itemRefDiscountLbl.text = ""
//                cell.itemRefDisValue.text = ""
//            }
//            else {
//                
//                cell.itemRefDiscountLbl.text = "Item Discount"
//                cell.itemRefDisValue.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
//            }
//            
//            cell.payRefTotalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.price, qty: cart.refund_qty, discount: cart.discount_amt)))"
//            
//            
//            return cell
//            
//        }
//        
//        else if tableView == payTableView {
//            
//            let cell = payTableView.dequeueReusableCell(withIdentifier: "paycell", for: indexPath) as! InStorePayTableCell
//            
//            cell.payName.text = paySum[indexPath.row]
//            if paySum[indexPath.row] == "Points Applied" {
//                cell.payValue.text = paySumValue[indexPath.row]
//                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
//            }
//            else if paySum[indexPath.row] == "Points Awarded" {
//                cell.payValue.textColor = UIColor(red: 76.0/255.0, green: 188.0/255.0, blue: 12.0/255.0, alpha: 1.0)
//                cell.payValue.text = "\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
//            }
//            else if paySum[indexPath.row] == "Gift Card Applied" {
//                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
//                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
//            }
////            else if paySum[indexPath.row] == "Lottery Payout" || paySum[indexPath.row] == "Scratcher Payout" {
////                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
////                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
////            }
//            else {
//                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
//            }
//            
//            return cell
//        }
//        
////        else if tableView == identityTable {
////            let cell = identityTable.dequeueReusableCell(withIdentifier: "identitycell", for: indexPath) as! InStoreIdentityCell
////            
////            cell.payIdLbl.text = idRefundName[indexPath.row]
////            cell.payIdValue.text = idRefundValue[indexPath.row]
////            
////            return cell
////        }
//        
//        else if tableView == custTable {
//            
//            let cell = custTable.dequeueReusableCell(withIdentifier: "custdetail", for: indexPath) as! InStorePayTableCell
//            
//            cell.payName.text = "Customer Name"
//            cell.payValue.text = "Customer Value"
//            
//            return cell
//            
//        }
//        
//        else {
//            
//            let cell = orderSumTable.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! InStoreOrderSumCell
//            
//            if orderSum[indexPath.row] == "Discounts" || orderSum[indexPath.row] == couponCode?.coupon_code {
//                cell.orderLbl.text = orderSum[indexPath.row]
//                cell.orderLblValue.text = "-$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
//            }
//            else {
//                cell.orderLbl.text = orderSum[indexPath.row]
//                cell.orderLblValue.text = "$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
//            }
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        if tableView == payRefundTable {
//            
//            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
//            let label1 = UILabel(frame: CGRect(x: tableView.frame.size.width - 170, y: 0, width: tableView.frame.size.width - 65, height: 19))
//            label1.text = payRefundDate[section]
//            label1.font = UIFont(name: "Manrope-SemiBold", size: 15.0)
//            label1.textColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
//            headerView.addSubview(label1)
//            
//            let label = UILabel(frame: CGRect(x: 20, y: label1.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
//            label.text = "Refund"
//            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
//            headerView.addSubview(label)
//            
//            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
//            grayview.backgroundColor = .black
//            headerView.addSubview(grayview)
//            
//            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 60, height: 3))
//            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
//            headerView.addSubview(blueview)
//            
//            return headerView
//        }
//        
////        else if tableView == identityTable {
////            
////            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
////            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
////            
////            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
////            label.text = "Identification Details"
////            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
////            headerView.addSubview(label)
////            
////            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
////            grayview.backgroundColor = .black
////            headerView.addSubview(grayview)
////            
////            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 180, height: 3))
////            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
////            headerView.addSubview(blueview)
////            
////            return headerView
////        }
//        
//        else if tableView == custTable {
//            
//            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
//            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
//            
//            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
//            label.text = "Customer Details"
//            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
//            headerView.addSubview(label)
//            
//            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
//            grayview.backgroundColor = .black
//            headerView.addSubview(grayview)
//            
//            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 120, height: 3))
//            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
//            headerView.addSubview(blueview)
//            
//            return headerView
//        }
//        
//        else {
//            
//            return nil
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if tableView == tableview || tableView == payRefundItemsTable {
//            return 130
//        }
//        
//        else {
//            return UITableView.automaticDimension
//        }
//    }
//}
