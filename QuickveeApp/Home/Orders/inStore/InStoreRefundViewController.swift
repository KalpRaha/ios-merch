//
//  InStoreRefundViewController.swift
//
//
//  Created by Kalpesh Rahate on 01/04/24.
//

import UIKit

class InStoreRefundViewController: UIViewController {
    
    
    @IBOutlet weak var refundItemTable: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var refundTable: UITableView!
    @IBOutlet weak var refundOrderSumTable: UITableView!
    
    @IBOutlet weak var refundIdTable: UITableView!
    @IBOutlet weak var refundPayTable: UITableView!
    
    @IBOutlet weak var custrefheigh: NSLayoutConstraint!
    
    @IBOutlet weak var custRefundTable: UITableView!
    
    @IBOutlet weak var refundItemHeight: NSLayoutConstraint!
    @IBOutlet weak var refundTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundOrderTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundPayTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundParItemHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundIdTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundOrderId: UILabel!
    @IBOutlet weak var refundOrderNo: UILabel!
    @IBOutlet weak var refundPayMode: UILabel!
    @IBOutlet weak var refAmt: UILabel!
    
    @IBOutlet weak var refundOrderLbl: UILabel!
    
    @IBOutlet weak var paymode_info: UIButton!
    @IBOutlet weak var payModeLbl: UILabel!
    
    @IBOutlet weak var refGrandTotal: UILabel!
    
    @IBOutlet weak var refCustomOwes: UILabel!
    @IBOutlet weak var scrollRefHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemRefundCount: UILabel!
    
    
    @IBOutlet weak var storeLbl: UILabel!
    
    @IBOutlet weak var aboveRefundView: UIView!
    @IBOutlet weak var refundView: UIView!
    
    @IBOutlet weak var refundPartialTable: UITableView!
    @IBOutlet weak var refundPartialLbl: UILabel!
    
    @IBOutlet weak var aboveRefHeight: NSLayoutConstraint!
    @IBOutlet weak var refViewHeight: NSLayoutConstraint!
    
    
    var refund_order_id = ""
    
    var cartItemsRefund = [Cart_Data]()
    var cartrefItemsRefund = [Cart_Data]()
    var merchDetailRefund = [MerchantDetail]()
    var orderDetailRefund: OrderDetails?
    var idDetailRefund: IdentificationDetails?
    var splitDetailRefund = [Split_Data]()
    var detailRefund = [[String:Any]]()
    var couponCodeRefund: CouponCode?
    
    var refund_id_exist = false
    
    var orderRefundSum = [String]()
    var orderRefundSumValue = [String]()
    
    var paySum = [String]()
    var paySumValue = [String]()
    
    var pax_details = ""
    
    var payRefund = [[String]]()
    var payRefundValues = [[String]]()
    var payRefDate = [String]()
    
    var idRefundName = [String]()
    var idRefundValue = [String]()
    
    var custRefName = ""
    var custRefAddr = ""
    var custRefNumber = ""
    var custRefMail = ""
    var refcust_exists = false
    
    
    @IBOutlet weak var scroll: UIView!
    
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

        refundItemTable.estimatedSectionHeaderHeight = 0
        refundItemTable.estimatedSectionFooterHeight = 0
        refundPartialTable.estimatedSectionHeaderHeight = 0
        refundPartialTable.estimatedSectionFooterHeight = 0
        refundTable.estimatedSectionFooterHeight = 0
        refundOrderSumTable.estimatedSectionHeaderHeight = 0
        refundOrderSumTable.estimatedSectionFooterHeight = 0
        refundIdTable.estimatedSectionFooterHeight = 0
        refundPayTable.estimatedSectionHeaderHeight = 0
        refundPayTable.estimatedSectionFooterHeight = 0
        
        loadingIndicator.isAnimating = true
        scroll.isHidden = true
        setupApi()
    }
    
    
    func setupApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.getOrderDetails(merchant_id: id, order_id: refund_order_id) { isSuccess, responseData in
            
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
        
        guard let refund_list = responsevalues["refund_data"] else {
            return
        }
        
        if responsevalues["split_payments"] != nil {
            setRefSplitData(split: responsevalues["split_payments"])
        }
        
        // setRefMerchData(merch: merch_list)
        setRefOrderData(order: order_list)
        setRefCartData(cart: cart_list)
        setRefundData(refund: refund_list)
        
        setRefCustData()
        
        if self.refcust_exists {
            let height = custRefundTable.contentSize.height
            custrefheigh.constant = height + 64
        }
        else {
            self.custrefheigh.constant = 0
        }
        
        if responsevalues["id_card_detail"] == nil {
            refund_id_exist = false
        }
        else {
            
            setRefIdData(id: responsevalues["id_card_detail"])
        }
        
        
        DispatchQueue.main.async {
            
            self.refundItemTable.reloadData()
            self.refundTable.reloadData()
            self.refundPartialTable.reloadData()
            self.refundOrderSumTable.reloadData()
            self.refundPayTable.reloadData()
            self.custRefundTable.reloadData()
            self.refundIdTable.reloadData()
            
            self.refundItemHeight.constant = 130 * CGFloat(self.cartItemsRefund.count)
            self.refundParItemHeight.constant = 130 * CGFloat(self.cartrefItemsRefund.count)
            self.refundOrderTableHeight.constant = 39 * CGFloat(self.orderRefundSum.count)
            self.refundPayTableHeight.constant = 39 * CGFloat(self.paySum.count)
            self.refundTableHeight.constant = (54 * CGFloat(self.detailRefund.count)) + CGFloat(39 * self.getRefCountForHeight())
            
            if self.refcust_exists {
                let height = self.custRefundTable.contentSize.height
                self.custrefheigh.constant = height + 64
            }
            else {
                self.custrefheigh.constant = 0
            }
            
            if self.refund_id_exist {
                let height = self.refundIdTable.contentSize.height
                self.refundIdTableHeight.constant = height + 64
            }
            else {
                self.refundIdTableHeight.constant = 0
            }
            
            let refCartHeight = self.refundItemHeight.constant
            let orderHeight = self.refundOrderTableHeight.constant
            let refparHeight = self.refundParItemHeight.constant
            let payHeight = self.refundPayTableHeight.constant
            let refundHeight = self.refundTableHeight.constant
            let custHeight = self.custrefheigh.constant
            let ref_id = self.refundIdTableHeight.constant
            
            
            let ref_cal = refCartHeight + orderHeight + payHeight + refundHeight
            + custHeight + ref_id + refparHeight + 450
            self.scrollRefHeight.constant = ref_cal
            
            self.loadingIndicator.isAnimating = false
            self.scroll.isHidden = false
        }
    }
    
    func setRefMerchData(merch: Any) {
        
        let small = merch as! [[String:Any]]
        var merchsmall = [MerchantDetail]()
        
        for res in small {
            
            let details = MerchantDetail(a_address_line_1: "\(res["a_address_line_1"] ?? "")",
                                         a_address_line_2: "\(res["a_address_line_2"] ?? "")",
                                         a_address_line_3: "\(res["a_address_line_3"] ?? "")",
                                         a_city: "\(res["a_city"] ?? "")", a_country: "\(res["a_country"] ?? "")",
                                         a_phone: "\(res["a_phone"] ?? "")", a_state: "\(res["a_state"] ?? "")",
                                         a_zip: "\(res["a_zip"] ?? "")", banner_img: "\(res["banner_img"] ?? "")",
                                         email: "\(res["email"] ?? "")", fb_url: "\(res["fb_url"] ?? "")",
                                         img: "\(res["img"] ?? "")", insta_url: "\(res["insta_url"] ?? "")",
                                         lat: "\(res["lat"] ?? "")", lng: "\(res["lng"] ?? "")",
                                         name: "\(res["name"] ?? "")", phone: "\(res["phone"] ?? "")",
                                         timeZone: "\(res["timeZone"] ?? "")")
            merchsmall.append(details)
        }
        
        merchDetailRefund = merchsmall
    }
    
    func setRefOrderData(order: Any) {
        
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
        
        orderDetailRefund = order
        
        refundOrderId.text = orderDetailRefund?.order_id
        
        let order_num = orderDetailRefund?.order_number
        refundOrderNo.text = order_num
        
        if orderDetailRefund?.delivery_addr != "" {
            
        }
        else {
            
        }
        
        let coupon = orderDetailRefund?.coupon_code ?? ""
        let coupon_dict = convertRefStringToDictionary(text: coupon)
        
        couponCodeRefund = CouponCode(coupon_code: "\(coupon_dict["coupon_code"] ?? "")",
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
        
        let amt = orderDetailRefund?.amt ?? "0.00"
        let ref_amt = orderDetailRefund?.refund_amount ?? "0.00"
        
        let cash_back_amt = orderDetailRefund?.cash_back_amt ?? "0.00"
        let cash_back_fee = orderDetailRefund?.cash_back_fee ?? "0.00"
        
        refCustomOwes.text = "$0.00"
        
        let split = orderDetailRefund?.is_split_payment ?? ""
        let payment_id = orderDetailRefund?.payment_id ?? ""
        let card_type = orderDetailRefund?.card_type ?? ""
        
        if split == "1" {
            payModeLbl.text = "Payment Mode"
            refundPayMode.text = "Split Payment"
            paymode_info.isHidden = false
        }
        else if payment_id == "Cash" {
            payModeLbl.text = "Payment Mode"
            refundPayMode.text = payment_id
            paymode_info.isHidden = true
        }
        else {
            payModeLbl.text = "Payment Id"
            refundPayMode.text = payment_id
            paymode_info.isHidden = true
        }
        
        let ref_amtgrand = calculateRefAmt(amt: amt, ref_amt: ref_amt)
        print(ref_amtgrand)
        let total_ref = roundRefOf(item: ref_amtgrand) + roundRefOf(item: cash_back_amt) + roundRefOf(item: cash_back_fee)
        refAmt.text = "$\(String(format: "%.02f", roundRefOf(item: "\(total_ref)")))"
        refGrandTotal.text = "$\(String(format: "%.02f", roundRefOf(item: "\(total_ref)")))"
        
        // couponcode
        let coupon_code = couponCodeRefund?.coupon_code ?? ""
        let coupon_code_amt = couponCodeRefund?.coupon_code_amt ?? "0.00"
        
        let points_earned = couponCodeRefund?.loyalty_point_earned ?? "0.00"
        _ = couponCodeRefund?.loyalty_point_amt_earned ?? "0.00"
        
        let points_amt_spent = couponCodeRefund?.loyalty_point_amt_spent ?? "0.00"
        let points_applied = couponCodeRefund?.loyalty_point_spent ?? "0.00"
        
        let store_credit = couponCodeRefund?.store_credit_amt_spent ?? "0.00"
        
        let gift_card_amount = couponCodeRefund?.gift_card_amount ?? "0.00"
        
        let nca_title = couponCodeRefund?.surcharge_label ?? ""
        
        
        
        //ordersumtable
        
        var smallOrderSum = ["Subtotal"]
        
        let sub = orderDetailRefund?.subtotal ?? "0.00"
        var smallOrderSumValue = [sub]
        
        let discount = orderDetailRefund?.discount ?? "0.00"
        
        if coupon_code_amt != "0.0" && coupon_code_amt != "0.00" && coupon_code_amt != "-0.00"
            && coupon_code_amt != "-0.0" && coupon_code_amt != "0" && coupon_code_amt != "" {
            
            if coupon_code != "Discount" && coupon_code != "" && coupon_code != "0.0"
                && coupon_code != "0.00" && coupon_code != "-0.00" && coupon_code != "-0.0" && coupon_code != "0" {
                
                smallOrderSum.append(coupon_code)
                smallOrderSumValue.append(coupon_code_amt)
            }
            
            else if discount == points_amt_spent || discount == store_credit {
                
            }
            else {
                smallOrderSum.append("Discounts")
                smallOrderSumValue.append(coupon_code_amt)
            }
        }
        
        let tip = orderDetailRefund?.tip ?? ""
        
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip)  {
            smallOrderSum.append("Tip")
            smallOrderSumValue.append(tip)
        }
        
        let cash_discount = orderDetailRefund?.cashdiscount_refund_amount ?? ""
        let cash_per = orderDetailRefund?.cash_discounting_percentage ?? ""
        
        
        if cash_discount != "0.0" && cash_discount != "0.00" && cash_discount != "-0.00" && cash_discount != "-0.0"
            && cash_discount != "0" && cash_discount != "" {
            
            if split == "1" {
                
                var debit_count = 0
                var credit_count = 0
                var small_debit = [String]()
                var small_credit = [String]()
                
                for split_pay in splitDetailRefund {
                    
                    if split_pay.pay_type == "debit" {
                        if debit_count != 1 {
                            smallOrderSum.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundRefOf(item: split_pay.cash_discounting_percentage)))%)")
                            small_debit.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundRefOf(item: split_pay.cash_discounting_percentage)))%)")
                            debit_count = 1
                        }
                        
                    }
                    
                    else if split_pay.pay_type == "credit" {
                        if credit_count != 1 {
                            smallOrderSum.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundRefOf(item: split_pay.cash_discounting_percentage)))%)")
                            small_credit.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundRefOf(item: split_pay.cash_discounting_percentage)))%)")
                            credit_count = 1
                        }
                    }
                    else {
                    }
                }
                
                var debit_amt = [String]()
                var credit_amt = [String]()
                
                var mode_first = 0
                
                for split_pay in splitDetailRefund {
                    
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
                
                var credit_card = Double()
                var debit_card = Double()
                
                if small_debit.count != 0 {
                    debit_card = calculateRefSplitCard(card: debit_amt)
                }
                
                if small_credit.count != 0 {
                    credit_card = calculateRefSplitCash(cash: credit_amt)
                }
                
                if small_debit.count == 0 {
                    smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(credit_card)")))")
                }
                
                else if small_credit.count == 0 {
                    smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(debit_card)")))")
                }
                else {
                    if mode_first == 1 {
                        smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(credit_card)")))")
                        smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(debit_card)")))")
                    }
                    
                    else {
                        smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(debit_card)")))")
                        smallOrderSumValue.append("\(String(format: "%.02f", roundRefOf(item: "\(credit_card)")))")
                    }
                }
            }
            
            else {
                
                if card_type.contains("Debit") || card_type.contains("debit") {
                    smallOrderSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundRefOf(item: cash_per)))%)")
                    smallOrderSumValue.append("\(cash_discount)")
                }
                
                else if card_type.contains("Credit") || card_type.contains("credit"){
                    smallOrderSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundRefOf(item: cash_per)))%)")
                    smallOrderSumValue.append("\(cash_discount)")
                }
                
                else {
                    
                }
            }
        }
        
        let tax = orderDetailRefund?.tax ?? ""
        
        if tax != "0.0" && tax != "0.00" && tax != "-0.00" && tax != "-0.0" && tax != "0" && tax != "" {
            smallOrderSum.append("DefaultTax")
            smallOrderSumValue.append(tax)
        }
        
        let other_taxes = orderDetailRefund?.other_taxes_desc ?? ""
        
        if other_taxes != "0.0" && other_taxes != "0.00" && other_taxes != "-0.00" && other_taxes != "-0.0"
            && other_taxes != "0" && other_taxes != "" {
            
            let tax_desc = convertRefStringToDictionary(text: other_taxes)
            
            for (key, value) in tax_desc {
                smallOrderSum.append(key)
                smallOrderSumValue.append("\(value)")
            }
        }
        
        
        orderRefundSum = smallOrderSum
        orderRefundSumValue = smallOrderSumValue
        
        //paytable
        
        var smallPaySum = [String]()
        var smallPaySumValue = [String]()
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" && points_amt_spent != "-0.00"
            && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent) {
            smallPaySum.append("Points Applied")
            smallPaySumValue.append("(-\(points_applied))-$\(roundRefOf(item: points_amt_spent))")
        }
        
        if gift_card_amount != "0.0" && gift_card_amount != "0.00" && gift_card_amount != "-0.0" &&
            gift_card_amount != "-0.00" && gift_card_amount != "0" && gift_card_amount != "" && handleZero(value: gift_card_amount)  {
            smallPaySum.append("Gift Card Applied")
            smallPaySumValue.append("\(String(format: "%.02f", roundRefOf(item: gift_card_amount)))")
        }
        
        let isloyal = orderDetailRefund?.is_loyality ?? "0"
        let iscredit = orderDetailRefund?.is_store_credit ?? "0"
        let isgift = orderDetailRefund?.is_gift_card ?? "0"
        
        if split == "1"  {
            
            var card_count = 0
            var cash_count = 0
            var food_count = 0
            var ecash_count = 0
            
            var small_card_cash = [String]()
            for split_way in splitDetailRefund {
                
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
            
            for split_way_info in splitDetailRefund {
                
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
                        let pay = calSplitRefTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
                        small_card.append(pay)
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
                        let pay = calSplitRefTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
                        small_card.append(pay)
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
                card = calculateRefSplitCard(card: small_card)
            }
            
            if small_cash.count != 0 {
                cash = calculateRefSplitCash(cash: small_cash)
            }
            
            if small_food.count != 0 {
                food = calculateSplitRefEbt(cash: small_food)
            }
            
            if small_ecash.count != 0 {
                ecash = calculateSplitRefEbt(cash: small_ecash)
            }
            
            for small in small_card_cash {
                
                if small == "Cash" {
                    smallPaySumValue.append(String(format: "%.02f", cash))
                }
                else if small == "Food EBT" {
                    smallPaySumValue.append(String(format: "%.02f", food))
                }
                else if small == "Cash EBT" {
                    smallPaySumValue.append(String(format: "%.02f", ecash))
                }
                else {
                    smallPaySumValue.append(String(format: "%.02f", card))
                }
            }
        }
        
        else if isloyal == "2" || iscredit == "2" || isgift == "2"
                    ||  isloyal == "1" || iscredit == "1" || isgift == "1" {
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt) -
                                          roundRefOf(item: store_credit))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    let pax = orderDetailRefund?.pax_details ?? ""
                    if pax != "" {
                        pax_details = "\n\n\(pax)"
                    }
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Credit Card")
                        smallPaySumValue.append(cred_amt)
                    }
                }
            }
            
            else if isloyal == "1" && iscredit == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else {
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    else {
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(roundRefOf(item: amt))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    let cred_amt = String(roundRefOf(item: amt))
                    let pax = orderDetailRefund?.pax_details ?? ""
                    if pax != "" {
                        pax_details = "\n\n\(pax)"
                    }
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Credit Card")
                        smallPaySumValue.append(cred_amt)
                    }
                }
            }
            
            else if isloyal == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                    let cred_amt = calculateRefDiscount(amt: "\(amt_price)" , discount: points_amt_spent)
                    smallPaySumValue.append(cred_amt)
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    else {
                        smallPaySum.append("Credit Card")
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        smallPaySumValue.append(cred_amt)
                    }
                }
            }
            
            else if iscredit == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                    smallPaySumValue.append(cred_amt)
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        smallPaySumValue.append(cred_amt)
                    }
                }
            }
            
            else if isgift == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    smallPaySumValue.append(amt)
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        smallPaySumValue.append(amt)
                    }
                }
            }
            
            else {
                
            }
        }
        
        else {
            if payment_id == "Cash" {
                if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                    smallPaySum.append("Cash")
                    smallPaySumValue.append(amt)
                }
            }
            else {
                
                if card_type.contains("CashEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                    }
                }
                
                else if card_type.contains("FoodEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                    }
                }
                
                else {
                    
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Credit Card")
                        let pax = orderDetailRefund?.pax_details ?? ""
                        if pax != "" {
                            pax_details = "\n\n\(pax)"
                        }
                        smallPaySumValue.append(amt)
                    }
                }
            }
        }
        
        
        if cash_back_amt != "0.0" && cash_back_amt != "0.00" && cash_back_amt != "-0.0" && cash_back_amt != "-0.00" && cash_back_amt != "0"
            && cash_back_amt != "" && handleZero(value: cash_back_amt) {
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
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00" && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
            smallPaySum.append("Points Awarded")
            smallPaySumValue.append(points_earned)
        }
        
        paySum = smallPaySum
        paySumValue = smallPaySumValue
        print(paySum)
        print(paySumValue)
        
    }
    
    func setRefCartData(cart: Any) {
        
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
        cartItemsRefund = smallcart
        cartrefItemsRefund = smallrefcart
        
        
        let itemsCount = cartItemsRefund.count + cartrefItemsRefund.count
        
        
        if itemsCount == 1 {
            itemRefundCount.text = "(\(itemsCount) item)"
        }
        else {
            itemRefundCount.text = "(\(itemsCount) items)"
        }
        
        if cartItemsRefund.count == 0 {
            aboveRefHeight.constant = 0
            storeLbl.text = ""
        }
        else {
            aboveRefHeight.constant = 50
            storeLbl.text = "In-Store Order"
        }
    }
    
    func setRefundData(refund: Any) {
        
        let refund_data = refund as! [[String:Any]]
        detailRefund = refund_data
        
        var smallRefund = [[String]]()
        var smallRefundVal = [[String]]()
        var smallRefDate = [String]()
        
        for ref in refund_data {
            
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
            let giftcard_amt = refund_pay.giftcard_amt
            let nca_amt = refund_pay.nca_amt
            
            
            var smallRef = [String]()
            var smallRefValues = [String]()
            
            smallRef.append("Reason Of Refund")
            smallRefValues.append(refund_reason)
            
            if card_pay != "0.00" {
                smallRef.append("Credit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: card_pay)))")
                
            }
            
            if cash_pay != "0.00" {
                smallRef.append("Cash")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: cash_pay)))")
                
            }
            
            if loyalty_amt != "0.00" {
                smallRef.append("Loyalty Points")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: loyalty_amt)))")
                
            }
            
            if store_cred != "0.00" {
                smallRef.append("Store Credits")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: store_cred)))")
                
            }
            
            if tip_amt != "0.00" {
                smallRef.append("Tip")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: tip_amt)))")
                
            }
            
            if giftcard_amt != "0.00" {
                smallRef.append("Gift Card")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: giftcard_amt)))")
                
            }
            
            if nca_amt != "0.00" {
                
                smallRef.append("Non Cash Adjustment")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: nca_amt)))")
            }
            smallRefDate.append(create_date)
            smallRefund.append(smallRef)
            smallRefundVal.append(smallRefValues)
        }
        
        payRefund = smallRefund
        payRefundValues = smallRefundVal
        payRefDate = smallRefDate
    }
    
    func setRefSplitData(split: Any) {
        
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
        splitDetailRefund = smallSplit
    }
    
    func setRefCustData() {
        
        if orderDetailRefund?.billing_name == "" && orderDetailRefund?.deliver_name == ""  {
            custRefName = "Walk-In Customer"
        }
        else if orderDetailRefund?.billing_name == "<null>" && orderDetailRefund?.deliver_name == "<null>" {
            custRefName = "Walk-In Customer"
        }
        
        else if orderDetailRefund?.billing_name == "" && orderDetailRefund?.deliver_name == "<null>" {
            custRefName = "Walk-In Customer"
        }
        
        else if orderDetailRefund?.billing_name == "<null>" && orderDetailRefund?.deliver_name == "" {
            custRefName = "Walk-In Customer"
        }
        else if orderDetailRefund?.billing_name == "" {
            custRefName = orderDetailRefund?.deliver_name ?? ""
        }
        else if orderDetailRefund?.deliver_name == "" {
            custRefName = orderDetailRefund?.billing_name ?? ""
        }
        
        custRefAddr = orderDetailRefund?.delivery_addr ?? ""
        
        if orderDetailRefund?.delivery_phn == "" && orderDetailRefund?.customer_phone == "" {
            refcust_exists = false
            custRefNumber = ""
            custRefMail = ""
        }
        
        else if orderDetailRefund?.delivery_phn == "" && orderDetailRefund?.customer_phone == "<null>" {
            refcust_exists = false
            custRefNumber = ""
            custRefMail = ""
        }
        
        else if orderDetailRefund?.delivery_phn == "<null>" && orderDetailRefund?.customer_phone == "" {
            refcust_exists = false
            custRefNumber = ""
            custRefMail = ""
        }
        
        else if orderDetailRefund?.delivery_phn == "<null>" && orderDetailRefund?.customer_phone == "<null>" {
            refcust_exists = false
            custRefNumber = ""
            custRefMail = ""
        }
        
        else {
            
            if orderDetailRefund?.delivery_phn == "" {
                custRefNumber = orderDetailRefund?.customer_phone ?? ""
                refcust_exists = true
                
                if orderDetailRefund?.email == "" {
                    custRefMail = orderDetailRefund?.customer_email ?? ""
                }
                else {
                    custRefMail = orderDetailRefund?.email ?? ""
                }
            }
            else {
                custRefNumber = orderDetailRefund?.delivery_phn ?? ""
                refcust_exists = true
                
                if orderDetailRefund?.email == "" {
                    custRefMail = orderDetailRefund?.customer_email ?? ""
                }
                else {
                    custRefMail = orderDetailRefund?.email ?? ""
                }
            }
        }
    }
    
    func setRefIdData(id: Any) {
        
        let identity = id as! [String:Any]
        let id_detail = IdentificationDetails(i_card_type: "\(identity["i_card_type"] ?? "")",
                                              i_card_number: "\(identity["i_card_number"] ?? "")",
                                              i_card_ex_date: "\(identity["i_card_ex_date"] ?? "")",
                                              i_card_dob: "\(identity["i_card_dob"] ?? "")",
                                              i_card_front_img: "\(identity["i_card_front_img"] ?? "")",
                                              i_card_back_img: "\(identity["i_card_back_img"] ?? "")")
        
        idDetailRefund = id_detail
        
        let card_type = idDetailRefund?.i_card_type ?? ""
        let card_number = idDetailRefund?.i_card_number ?? ""
        let card_ex = idDetailRefund?.i_card_ex_date ?? ""
        let card_dob = idDetailRefund?.i_card_dob ?? ""
        let date = orderDetailRefund?.date_time ?? ""
        
        var smallIdNames = [String]()
        var smallIdValues = [String]()
        
        if card_type == "Verify Non Id Person" {
            refund_id_exist = false
        }
        else {
            refund_id_exist = true
            
            if card_type != "" {
                smallIdNames.append("Identification Card Type")
                smallIdValues.append(card_type)
            }
            
            if idDetailRefund?.i_card_number != "" {
                smallIdNames.append("Identification Number")
                smallIdValues.append(card_number)
            }
            
            if date != "" {
                smallIdNames.append("Date & Time")
                smallIdValues.append(date)
            }
            
            if idDetailRefund?.i_card_ex_date != "" && idDetailRefund?.i_card_ex_date != "0000-00-00"  {
                smallIdNames.append("Expiry Date")
                smallIdValues.append(card_ex)
            }
            
            if idDetailRefund?.i_card_dob != "" {
                smallIdNames.append("Date of Birth")
                smallIdValues.append(card_dob)
            }
            idRefundName = smallIdNames
            idRefundValue = smallIdValues
            
        }
    }
    
    func handleZero(value: String) -> Bool {
        
        let doub_value = Double(value) ?? 0.00
        
        if doub_value < 0.0 {
            
            return false
        }
        else {
            return true
            
        }
    }
    
    func calRefTotalPrice(onePrice: String, qty: String, discount: String) -> Double {
        
        let price = Double(onePrice) ?? 0.00
        let quant = Double(qty) ?? 0.00
        let dis = Double(discount) ?? 0.00
        
        let total = price * quant
        let dis_price = total - dis
        
        return roundRefOf(item: String(dis_price))
    }
    
    func convertRefStringToDictionary(text: String) -> [String:Any] {
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
    
    func calculateRefDiscount(amt: String, discount: String) -> String {
        
        let amt1 = roundRefOf(item: amt)
        let amt2 = roundRefOf(item: discount)
        
        let calc_amt = amt1 - amt2
        return String(calc_amt)
        
    }
    
    func calculateRefAmt(amt: String, ref_amt: String) -> String {
        
        
        let amt1 = roundRefOf(item: amt)
        let amt2 = roundRefOf(item: ref_amt)
        
        let amt_doub = amt1
        let ref_amt_doub = amt2
        
        print(amt_doub)
        print(ref_amt_doub)
        
        let total = amt_doub - ref_amt_doub
        print(total)
        if total < 0.00 || total < 0.0 {
            return String(0.00)
        }
        else {
            return String(total)
        }
        
    }
    
    func calculateRefSplitCard(card: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in card {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calculateRefSplitCash(cash: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in cash {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calculateSplitRefEbt(cash: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in cash {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calSplitRefTipCard(amt: String, tip: String) -> String {
        
        let cred = roundRefOf(item: amt)
        print(tip)
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" {
            let tip_pay = roundRefOf(item: tip)
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
    
    func roundRefOf(item : String) -> Double {
        var itemDollar = ""
        print(item)
        if item.starts(with: "$") {
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
    
    func getRefCountForHeight() -> Int {
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
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func creditInfoBtn(_ sender: UIButton) {
        
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
    
    
    
    @IBAction func payModeClick(_ sender: UIButton) {
        
        var amt_arr = [String]()
        var pay_arr = [String]()
        var pay_per = [String]()
        var pay_mode = [String]()
        
        for split in splitDetailRefund {
            
            var amt = roundRefOf(item: split.pay_amount)
            let pay = roundRefOf(item: split.cash_discounting_amount)
            let per = roundRefOf(item: split.cash_discounting_percentage)
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

extension InStoreRefundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == refundItemTable {
            return 1
        }
        
        else if tableView == refundTable {
            return payRefund.count
        }
        
        else if tableView == refundPartialTable {
            
            return 1
        }
        
        else if tableView == refundOrderSumTable {
            return 1
        }
        
        else if tableView == refundPayTable {
            return 1
        }
        
        else if tableView == refundIdTable {
            if refund_id_exist {
                return 1
            }
            else {
                return 0
            }
        }
        
        else if tableView == custRefundTable {
            if refcust_exists {
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
        
        if tableView == refundItemTable {
            return cartItemsRefund.count
        }
        
        else if tableView == refundTable {
            return payRefund[section].count
        }
        
        else if tableView == refundPartialTable {
            return cartrefItemsRefund.count
        }
        
        else if tableView == refundOrderSumTable {
            return orderRefundSum.count
        }
        
        else if tableView == refundPayTable {
            return paySum.count
        }
        
        else if tableView == refundIdTable {
            return idRefundName.count
        }
        
        else if tableView == custRefundTable {
            if refcust_exists {
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
        
        if tableView == refundItemTable {
            
            let cell = refundItemTable.dequeueReusableCell(withIdentifier: "refunditemcell", for: indexPath) as! InStoreItemRefundCell
            
            let refund_cart = cartItemsRefund[indexPath.row]
            
            let note = refund_cart.note.replacingOccurrences(of: "~", with: "\n")
            let name_note = note.replacingOccurrences(of: "Name-", with: "")
            
            if let range = name_note.range(of: "null") {
                let itemName = name_note.prefix(upTo: range.lowerBound)
                cell.refundItemName.text = String(itemName)
            }
            else {
                cell.refundItemName.text = name_note
            }
            
            cell.refOnePrice.text = "$\(String(format: "%.02f", roundRefOf(item: refund_cart.price)))"
            
            cell.refQty.text = "\(refund_cart.qty)x"
            
            if refund_cart.discount_amt == "0.00" || refund_cart.discount_amt == "0.0" {
                
                cell.itemDiscount.text = ""
                cell.itemDisValue.text = ""
            }
            else {
                
                cell.itemDiscount.text = "Item Discount"
                cell.itemDisValue.text = "-$\(String(format: "%.02f", roundRefOf(item: refund_cart.discount_amt)))"
            }
            
            cell.refTotalPrice.text = "$\(String(format: "%.02f", calRefTotalPrice(onePrice: refund_cart.price, qty: refund_cart.qty, discount: refund_cart.discount_amt)))"
            
            return cell
        }
        
        else if tableView == refundPartialTable {
            
            let cell = refundPartialTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RefundPartialCell
            
            let refund_cart = cartrefItemsRefund[indexPath.row]
            
            let note = refund_cart.note.replacingOccurrences(of: "~", with: "\n")
            let name_note = note.replacingOccurrences(of: "Name-", with: "")
            
            if let range = name_note.range(of: "null") {
                let itemName = name_note.prefix(upTo: range.lowerBound)
                cell.refundParItemName.text = String(itemName)
            }
            else {
                cell.refundParItemName.text = name_note
            }
            
            cell.refParOnePrice.text = "$\(String(format: "%.02f", roundRefOf(item: refund_cart.price)))"
            cell.refParQty.text = "\(refund_cart.refund_qty)x"
            
            if refund_cart.discount_amt == "0.00" || refund_cart.discount_amt == "0.0" {
                
                cell.itemRefDiscount.text = ""
                cell.itemRefDisValue.text = ""
            }
            else {
                
                cell.itemRefDiscount.text = "Item Discount"
                cell.itemRefDisValue.text = "-$\(String(format: "%.02f", roundRefOf(item: refund_cart.discount_amt)))"
            }
            
            
            
            cell.refParTotalPrice.text = "$\(String(format: "%.02f", calRefTotalPrice(onePrice: refund_cart.price, qty: refund_cart.refund_qty, discount: refund_cart.discount_amt)))"
            
            
            
            return cell
            
        }
        
        else if tableView == refundTable {
            
            let cell = refundTable.dequeueReusableCell(withIdentifier: "refundcell", for: indexPath) as! InStoreRefundCell
            
            cell.refundLbl.text = payRefund[indexPath.section][indexPath.row]
            cell.refundValues.text = payRefundValues[indexPath.section][indexPath.row]
            
            return cell
        }
        
        
        else if tableView == refundOrderSumTable {
            
            let cell = refundOrderSumTable.dequeueReusableCell(withIdentifier: "refundordercell", for: indexPath) as! InStoreRefundOrderSumCell
            
            
            if orderRefundSum[indexPath.row] == "Discounts" || orderRefundSum[indexPath.row] == couponCodeRefund?.coupon_code {
                cell.orderRefSum.text = orderRefundSum[indexPath.row]
                cell.orderRefValue.text = "-$\(String(format: "%.02f", roundRefOf(item: orderRefundSumValue[indexPath.row])))"
            }
            else {
                cell.orderRefSum.text = orderRefundSum[indexPath.row]
                cell.orderRefValue.text = "$\(String(format: "%.02f", roundRefOf(item: orderRefundSumValue[indexPath.row])))"
            }
            
            return cell
        }
        
        else if tableView == refundPayTable {
            
            let cell = refundPayTable.dequeueReusableCell(withIdentifier: "refpaycell", for: indexPath) as! InStoreRefundPayCell
            
            cell.refpayLbl.text = paySum[indexPath.row]
            
            if paySum[indexPath.row] == "Points Applied" {
                cell.refpayValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
                cell.refpayValue.text = paySumValue[indexPath.row]
            }
            else if paySum[indexPath.row] == "Points Awarded" {
                cell.refpayValue.textColor = UIColor(red: 76.0/255.0, green: 188.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                print(paySumValue[indexPath.row])
                cell.refpayValue.text = "\(String(format: "%.02f", roundRefOf(item: paySumValue[indexPath.row])))"
            }
            else if paySum[indexPath.row] == "Gift Card Applied" {
                cell.refpayValue.text = "$\(String(format: "%.02f", roundRefOf(item: paySumValue[indexPath.row])))"
                cell.refpayValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else {
                cell.refpayValue.text = "$\(String(format: "%.02f", roundRefOf(item: paySumValue[indexPath.row])))"
            }
            
            if paySum[indexPath.row] == "Credit Card" {
                cell.refinfoBtn.isHidden = false
            }
            
            else {
                cell.refinfoBtn.isHidden = true
            }
            
            return cell
        }
        
        
        else if tableView == custRefundTable {
            
            let cell = custRefundTable.dequeueReusableCell(withIdentifier: "refundcustcell", for: indexPath) as! InStoreRefundCustCell
            
            cell.refcustname.text = custRefName
            cell.refundcustaddr.text = custRefAddr
            cell.refundcustphone.text = custRefNumber
            cell.refundcustmail.text = custRefMail
            
            if custRefAddr == "" {
                cell.custRefAddrHeight.constant = 0
            }
            else {
                cell.custRefAddrHeight.constant = 14
            }
            
            cell.refundaddrview.layer.cornerRadius = 10
            cell.refundaddrview.layer.borderWidth = 1
            cell.refundaddrview.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
            
            return cell
        }
        
        else {
            
            let cell = refundIdTable.dequeueReusableCell(withIdentifier: "idcell", for: indexPath) as! InStoreRefundIdCell
            
            cell.idRefundLbl.text = idRefundName[indexPath.row]
            cell.idRefValue.text = idRefundValue[indexPath.row]
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == refundTable {
            
            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
            let label1 = UILabel(frame: CGRect(x: tableView.frame.size.width - 170, y: 0, width: tableView.frame.size.width - 65, height: 19))
            
            label1.text = payRefDate[section]
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
        
        else if tableView == refundIdTable {
            
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
        
        else if tableView == custRefundTable {
            
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
        
        else {
            
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == refundItemTable || tableView == refundPartialTable {
            return 130
        }
        
        else {
            return UITableView.automaticDimension
        }
    }
}
