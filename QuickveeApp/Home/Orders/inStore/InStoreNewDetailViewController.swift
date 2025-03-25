//
//  InStoreNewDetailViewController.swift
//  
//
//  Created by Jamaluddin Syed on 22/11/24.
//

import UIKit

class InStoreNewDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var payRefundItemsTable: UITableView!
    @IBOutlet weak var orderDetailTable: UITableView!
    @IBOutlet weak var loyalTableview: UITableView!
    
    @IBOutlet weak var loyalTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var taxTableView: UITableView!
    @IBOutlet weak var feeTable: UITableView!
    @IBOutlet weak var tenderTable: UITableView!
    
    @IBOutlet weak var grossTable: UITableView!
    @IBOutlet weak var payRefundTable: UITableView!
    @IBOutlet weak var identityTable: UITableView!
    
    @IBOutlet weak var idTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var payRefundTableHeight: NSLayoutConstraint!
    @IBOutlet weak var taxTableHeight: NSLayoutConstraint!
    @IBOutlet weak var itemTableHeight: NSLayoutConstraint!
    @IBOutlet weak var payRefundItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var orderDetTableHeight: NSLayoutConstraint!
    @IBOutlet weak var feeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tenderTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var grossTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var instoreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instoreRefundViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dotViewHeight: NSLayoutConstraint!
    @IBOutlet weak var grossViewHeight: NSLayoutConstraint!
    @IBOutlet weak var netViewHeight: NSLayoutConstraint!
    @IBOutlet weak var taxesHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var totalTaxViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalTenderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var instoreLbl: UILabel!
    @IBOutlet weak var refundedLbl: UILabel!
    
    
    @IBOutlet weak var grossAmt: UILabel!
    @IBOutlet weak var netAmt: UILabel!
    @IBOutlet weak var payAmt: UILabel!
    
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var feeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalFeeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tenderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalLoyalPoints: UILabel!
    
    @IBOutlet weak var totalLoyalView: UIView!
    
    @IBOutlet weak var totalRefundLbl: UILabel!
    
    @IBOutlet weak var totalRefundedLbl: UILabel!
    
    
    @IBOutlet weak var refundHeadLbl: UILabel!
    
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var feeTotal: UILabel!
    @IBOutlet weak var refundPriceTotal: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var grossView: UIView!
    @IBOutlet weak var netView: UIView!
    
    @IBOutlet weak var totalTaxView: UIView!
    
    @IBOutlet weak var refundHeaderView: UIView!
    @IBOutlet weak var refundTotalView: UIView!
    @IBOutlet weak var afterRefundView: UIView!
    
    
    @IBOutlet weak var refundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var refundHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var refundTotalHeight: NSLayoutConstraint!
    @IBOutlet weak var afterRefundVieweight: NSLayoutConstraint!
    
    @IBOutlet weak var loyaltyPointsLbl: UILabel!
    
    @IBOutlet weak var afterRefundPrice: UILabel!
    
    @IBOutlet weak var totalTaxRefund: UILabel!
    
    @IBOutlet weak var refundTotalTop: NSLayoutConstraint!
    @IBOutlet weak var refundTotalBottom: NSLayoutConstraint!
    
    @IBOutlet weak var underBlueRefundHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalFeeView: UIView!
    
    @IBOutlet weak var taxTotalLbl: UILabel!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scroll: UIView!
    
    @IBOutlet weak var loyaltyHeadView: UIView!
    
    @IBOutlet weak var blueLoyalty: UIView!
    @IBOutlet weak var totalLoyalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loyaltyHeadHeight: NSLayoutConstraint!
    
    @IBOutlet weak var blueLoyalHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var totalLoyaltyLbl: UILabel!
    
    @IBOutlet weak var custDetails: UILabel!
    @IBOutlet weak var blueidentity: UIView!
    
    @IBOutlet weak var underidentity: UIView!

    @IBOutlet weak var changeDue: UILabel!
    
    @IBOutlet weak var afterRefundLbl: UILabel!
    
    var tax_table_array = [Tax_Order_Summary]()
    
    var tenderHeight = [String]()
    
    var feeSum = [String]()
    var feeSumValue = [String]()
    
    var paySum = [String]()
    var paySumValue = [String]()
    
    var grossLabel = [String]()
    var grossValue = [String]()
    
    var loyalArray = [Loyalty]()
    
    var orderDetailLabel = [String]()
    var orderDetailValue = [String]()
    
    var tenderCashBack = [String]()
    var tenderPax = [String]()
    var tenderDigits = [String]()
    var refundPaxAuth = [[String]]()
    var refundPaxDigits = [[String]]()
    
    var order_id = ""
    // var paxArray = [String]()
    
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
    var payRefundTax = [[String]]()
    
    var payRefNcaTip = [[TipNca]]()
    var payRefundHeight = [[String]]()
    
    var idRefundName = [String]()
    var idRefundValue = [String]()
    
    var custName = ""
    var custAddr = ""
    var custNumber = ""
    var custMail = ""
    
    var id_exist = false
    var refund_exist = false
    var cust_exist = false
    //  var pax_details = ""
    
    var isLottery = "0"
    var isScratcher = "0"
    
    var isCartLottery = "0"
    var isCartScratcher = "0"
    
    var isNoItem = false
    
    var loyalPresent = false
    
    var other_tax = [String:Any]()
    
    var refundTableArray = [RefundTableDetails]()
    
    
    
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
        payRefundItemsTable.estimatedSectionHeaderHeight = 0
        payRefundItemsTable.estimatedSectionFooterHeight = 0
        orderDetailTable.estimatedSectionHeaderHeight = 0
        orderDetailTable.estimatedSectionFooterHeight = 0
        taxTableView.estimatedSectionHeaderHeight = 0
        taxTableView.estimatedSectionFooterHeight = 0
        feeTable.estimatedSectionHeaderHeight = 0
        feeTable.estimatedSectionFooterHeight = 0
        payRefundTable.estimatedSectionHeaderHeight = 0
        payRefundTable.estimatedSectionFooterHeight = 0
        
        afterRefundLbl.text =  "Grand Total After Refund\nGrand Total - Total Refunded"
         
        setupApi()
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
        
        print(responsevalues)
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
        
        //        if responsevalues["id_card_detail"] == nil {
        //            id_exist = false
        //            custDetails.isHidden = true
        //            blueidentity.isHidden = true
        //            underidentity.isHidden = true
        //        }
        //        else {
        //            id_exist = true
        //            setIdData(id: responsevalues["id_card_detail"])
        //        }
        
        // setCustData()
        
        if orderDetail?.is_refunded == "1" {
            refund_exist = true
            setRefundData(refund_data: responsevalues["refund_data"])
            
        }
        else {
            refund_exist = false
            
            refundHeaderHeight.constant = 0
            refundViewHeight.constant = 0
            refundTotalHeight.constant = 0
            
            
            refundPriceTotal.text = ""
            totalRefundLbl.text = ""
            totalRefundedLbl.text = ""
            refundHeadLbl.text = ""
            
            afterRefundVieweight.constant = 0
            afterRefundLbl.text = ""
            underBlueRefundHeight.constant = 0
            
            refundTotalTop.constant = 0
            refundTotalBottom.constant = 0
        }
        
        DispatchQueue.main.async {
            
            self.tableview.reloadData()
            self.payRefundItemsTable.reloadData()
            self.orderDetailTable.reloadData()
            self.grossTable.reloadData()
            self.taxTableView.reloadData()
            self.feeTable.reloadData()
            self.tenderTable.reloadData()
            self.payRefundTable.reloadData()
            self.loyalTableview.reloadData()
            self.identityTable.reloadData()
            
            if self.isNoItem {
                self.itemTableHeight.constant = 41 * CGFloat(self.cartItems.count)
            }
            else {
                self.itemTableHeight.constant = 130 * CGFloat(self.cartItems.count)
            }
            if self.cartRefundItems.count == 0 {
                self.payRefundItemsHeight.constant = 0
            }
            else {
                self.payRefundItemsHeight.constant = 130 * CGFloat(self.cartRefundItems.count)
            }
            
            self.orderDetTableHeight.constant = 41.67 * CGFloat(self.orderDetailLabel.count)
            self.grossTableHeight.constant = 42 * CGFloat(self.grossLabel.count)
            self.taxTableHeight.constant = 75.67 * CGFloat(self.tax_table_array.count)
            self.feeTableHeight.constant = 42 * CGFloat(self.feeSum.count)
            self.tenderTableHeight.constant = self.getTenderHeight()
            self.payRefundTableHeight.constant = self.getCountForHeight()
            self.loyalTableHeight.constant = 75.67 * CGFloat(self.loyalArray.count)
            
            if self.id_exist {
                //let height = self.identityTable.contentSize.height
                print(self.idRefundName.count)
                self.idTableHeight.constant = 39.33 * CGFloat(self.idRefundName.count) + 64
            }
            else {
                self.idTableHeight.constant = 0
            }
            
            let cartHeight = 130 * CGFloat(self.cartItems.count)
            let refcartHeight = 130 * CGFloat(self.cartRefundItems.count)
            let orderHeight = self.orderDetTableHeight.constant
            let grossHeight = self.grossTableHeight.constant
            let taxHeight = self.taxTableHeight.constant
            let feeHeight = self.feeTableHeight.constant
            let tenderHeight = self.getTenderHeight()
            let payRefundHeight = self.payRefundTableHeight.constant
            let loyalHeight = self.loyalTableHeight.constant
            let idHeight = self.idTableHeight.constant
            
            
            let instoreview = self.instoreViewHeight.constant
            let instoreRefundview = self.instoreRefundViewHeight.constant
            let dotviewheight = self.dotViewHeight.constant
            let grossViewHeight = self.grossViewHeight.constant
            let netViewheight = self.netViewHeight.constant
            let totalTaxViewHeight = self.totalTaxViewHeight.constant
            let taxHeaderHeight = self.taxesHeaderHeight.constant
            let feeViewHeight = self.feeViewHeight.constant
            let totalFeeViewHeight = self.totalFeeHeight.constant
            let tenderViewHeight = self.tenderViewHeight.constant
            let totalTenderViewHeight = self.totalTenderViewHeight.constant
            let refundHeaderHeight = self.refundHeaderHeight.constant
            let refundviewHeight = self.refundViewHeight.constant
            let refundtotalHeight =  self.refundTotalHeight.constant
            let loyalheadHieght = self.loyaltyHeadHeight.constant
            let loyalTotalHeight = self.totalLoyalViewHeight.constant
            
            let calHeight = cartHeight + refcartHeight + orderHeight + grossHeight +
            taxHeight + feeHeight + tenderHeight + payRefundHeight + loyalHeight +
            idHeight + instoreview + instoreRefundview + dotviewheight + grossViewHeight + netViewheight + totalTaxViewHeight +
            taxHeaderHeight + feeViewHeight + totalFeeViewHeight + tenderViewHeight + totalTenderViewHeight + refundHeaderHeight + refundviewHeight + refundtotalHeight + loyalheadHieght + loyalTotalHeight + 404
            
            self.scrollHeight.constant = calHeight
            
            self.dashedLine()
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
                                 other_taxes_desc: "\(res["other_taxes_desc"] ?? "")",
                                 other_taxes_rate_desc: "\(res["other_taxes_rate_desc"] ?? "")",
                                 change_due: "\(res["change_due"] ?? "")", con_fee: "\(res["con_fee"] ?? "")",
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
        
        let order_id = orderDetail?.order_id ?? ""
        let order_number = orderDetail?.order_number ?? ""
        
        orderDetailLabel.append("Order Id")
        orderDetailValue.append(order_id)
        
        if UserDefaults.standard.bool(forKey: "order_number_enable") {
            orderDetailLabel.append("Order Number")
            orderDetailValue.append(order_number)
        }
        
        
        let formattedDate = ToastClass.sharedToast.setDateFormat(dateStr:orderDetail?.date_time ?? "")
        
        
        print(formattedDate)
        let dateTime = formattedDate
        
        let dateComponents = dateTime.split(separator: " ")
        print(dateComponents)
        
        let date = String(dateComponents[0])
        let time = String(dateComponents[1])
        let timeaa = String(dateComponents[2])
        
        
        let order_num = orderDetail?.order_number
        
        //        let order_date = orderDetail?.date_time ?? ""
        //        let date = order_date.components(separatedBy: " ")[0]
        //        let time = order_date.components(separatedBy: " ")[1]
        //
        orderDetailLabel.append("Date")
        orderDetailValue.append(date)
        
        orderDetailLabel.append("Time")
        orderDetailValue.append("\(time) \(timeaa)")
        
        let tax = orderDetail?.tax ?? "0.00"
        
        let tax_rate = orderDetail?.tax_rate ?? "0.00"
        
        let other_taxes = orderDetail?.other_taxes_desc ?? ""
        
        other_tax = convertStringToDictionary(text: other_taxes)
        
        let other_taxes_rate = orderDetail?.other_taxes_rate_desc ?? ""
        
        let other_tax_rate = convertStringToDictionary(text: other_taxes_rate)
        
        var add = 0.00
        
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
        
        
        //       customerOweValue.text = "$0.00"
        
        let split = orderDetail?.is_split_payment ?? ""
        let payment_id = orderDetail?.payment_id ?? ""
        let card_type = orderDetail?.card_type ?? ""
        
        
        //        if split == "1" {
        //            paymodeLbl.text = "Payment Mode"
        //            payMode.text = "Split Payment"
        //            paymode_info.isHidden = false
        //        }
        //        else if payment_id == "Cash" {
        //            paymodeLbl.text = "Payment Mode"
        //            payMode.text = payment_id
        //            paymode_info.isHidden = true
        //        }
        //        else {
        //            paymodeLbl.text = "Payment Id"
        //            payMode.text = payment_id
        //            paymode_info.isHidden = true
        //        }
        
        // couponcode
        let coupon_code = couponCode?.coupon_code ?? ""
        let coupon_code_amt = couponCode?.coupon_code_amt ?? "0.00"
        
        var points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let points_amt_earned = couponCode?.loyalty_point_amt_earned ?? "0.00"
        
        let points_amt_spent = couponCode?.loyalty_point_amt_spent ?? "0.00"
        let points_applied = couponCode?.loyalty_point_spent ?? "0.00"
        
        let store_credit = couponCode?.store_credit_amt_spent ?? "0.00"
        let gift_card_amount = couponCode?.gift_card_amount ?? "0.00"
        
        let nca_title = couponCode?.surcharge_label ?? ""
        
        let lottery_order_pay = couponCode?.lottery_order_pay ?? "0.00"
        
        if lottery_order_pay != "0.0" && lottery_order_pay != "0.00" && lottery_order_pay != "-0.0" &&
            lottery_order_pay != "-0.00" && lottery_order_pay != "0" && lottery_order_pay != "" &&
            handleZero(value: lottery_order_pay) {
            
            isLottery = "1"
        }
        else {
            isLottery = "0"
        }
        
        let total_lottery_payout = couponCode?.total_lottery_payout ?? "0.00"
        
        if total_lottery_payout != "0.0" && total_lottery_payout != "0.00" && total_lottery_payout != "-0.0" &&
            total_lottery_payout != "-0.00" && total_lottery_payout != "0" && total_lottery_payout != "" &&
            handleZero(value: total_lottery_payout) {
            
            isCartLottery = "1"
        }
        else {
            isCartLottery = "0"
        }
        
        
        let total_scratcher_payout = couponCode?.total_scratcher_payout ?? "0.00"
        
        if total_scratcher_payout != "0.0" && total_scratcher_payout != "0.00" && total_scratcher_payout != "-0.0" &&
            total_scratcher_payout != "-0.00" && total_scratcher_payout != "0" && total_scratcher_payout != "" &&
            handleZero(value: total_scratcher_payout) {
            
            isCartScratcher = "1"
        }
        else {
            isCartScratcher = "0"
        }
        
        
        let scratch_order_pay = couponCode?.scratch_order_pay ?? "0.00"
        
        if scratch_order_pay != "0.0" && scratch_order_pay != "0.00" && scratch_order_pay != "-0.0" &&
            scratch_order_pay != "-0.00" && scratch_order_pay != "0" && scratch_order_pay != "" &&
            handleZero(value: scratch_order_pay) {
            
            isScratcher = "1"
        }
        else {
            isScratcher = "0"
        }
        
        let scratch_cash_pay = couponCode?.scratch_cash_pay ?? "0.00"
        
        var cash_value = ""
        
        orderDetailLabel.append("Employee Name")
        let name = couponCode?.employee_name ?? ""
        orderDetailValue.append(name)
        
        if orderDetail?.is_refunded == "1" {
            
            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                let sub = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
                //  grossAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                cash_value = "\(sub)"
            }
            else {
                let amt_sub = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee)
                
                let amt_price = calculateRefPayAmt(amt: "\(sub_back)", ref_amt: ref_amt)
                //   grossAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                cash_value = "\(amt_sub)"
            }
        }
        
        else {
            
            if amt == "0.0" && amt == "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                let amt_price = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                let sub_back = roundOf(item: subtotal) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee) + roundOf(item: coupon_code_amt)
                
                //   grossAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
                
            }
            else {
                let amt_price = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount)
                
                // added coupon_code_amt
                let sub_back = roundOf(item: amt) + roundOf(item: points_amt_spent) + roundOf(item: gift_card_amount) +
                roundOf(item: cash_back_amt) + roundOf(item: cash_back_fee) + roundOf(item: coupon_code_amt)
                
                //  grossAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(sub_back)")))"
                
                cash_value = "\(String(format: "%.02f", roundOf(item: "\(amt_price)")))"
            }
        }
        
        grossAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(subtotal)")))"
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent)  {
            grossLabel.append("Loyalty Points Redeemed(\(points_applied))")
            grossValue.append(String(format: "%.02f", roundOf(item: points_amt_spent)))
        }
        
        else {
            grossLabel.append("Loyalty Points Redeemed(\(points_applied))")
            grossValue.append("0.00")
        }
        
        if coupon_code_amt != "0.0" && coupon_code_amt != "0.00" && coupon_code_amt != "-0.00"
            && coupon_code_amt != "-0.0" && coupon_code_amt != "0" && coupon_code_amt != ""  {
            
            if coupon_code != "Discount" && coupon_code != "" && coupon_code != "0.0"
                && coupon_code != "0.00" && coupon_code != "-0.00" && coupon_code != "-0.0" && coupon_code != "0" {
                grossLabel.append(coupon_code)
                grossValue.append(coupon_code_amt)
            }
            
            else if coupon_code_amt == points_amt_spent || coupon_code_amt == store_credit {
                
            }
            
            else {
                grossLabel.append("Discounts")
                grossValue.append(coupon_code_amt)
            }
        }
        
        else {
            grossLabel.append("Discounts")
            grossValue.append("0.00")
        }
        
        
        netAmt.text = "$\(String(format: "%.02f", roundOf(item: "\(calculateTotalNetSales(values: grossValue))")))"
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00"
            && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
            if points_earned.hasPrefix("-") {
                points_earned.removeFirst()
            }
            loyalArray.append(Loyalty(loyalty_points: points_earned, loyalty_date: order.date_time))
            
            if order.is_refunded == "0" {
                totalLoyalPoints.text = points_earned
            }
        }
        else {
            totalLoyalPoints.text = ""
            totalLoyalViewHeight.constant = 0
            loyaltyHeadHeight.constant = 0
            blueLoyalty.isHidden = true
            loyaltyPointsLbl.text = ""
            
        }
        
        //fee table
        
        var smallFeeSum = [String]()
        var smallFeeSumValue = [String]()
        
        let cash_discount = orderDetail?.cash_discounting ?? ""
        let cash_per = orderDetail?.cash_discounting_percentage ?? ""
        let cash_dis_ref_amt = orderDetail?.cashdiscount_refund_amount ?? ""
        
        
        
        
        if cash_discount != "0.0" && cash_discount != "0.00" && cash_discount != "-0.00" && cash_discount != "-0.0"
            && cash_discount != "0" && cash_discount != "" {
            
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
                                smallFeeSum.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                small_debit.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                debit_count = 1
                            }
                            
                        }
                        
                        else if split_pay.pay_type == "credit" {
                            if credit_count != 1 {
                                smallFeeSum.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
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
                    smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                }
                
                else if small_credit.count == 0 {
                    smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                }
                
                else {
                    
                    if mode_first == 1 {
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                    }
                    
                    else {
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                    }
                }
            }
            
            //            else {
            //
            //                if card_type.contains("Debit") || card_type.contains("debit") {
            //                    smallFeeSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
            //                    smallFeeSumValue.append("\(cash_discount)")
            //                }
            //
            //                else if card_type.contains("Credit") || card_type.contains("credit"){
            //                    smallFeeSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
            //                    smallFeeSumValue.append("\(cash_discount)")
            //                }
            //
            //                else {
            //
            //                }
            //            }
        }
        
        if cash_dis_ref_amt != "0.0" && cash_dis_ref_amt != "0.00" && cash_dis_ref_amt != "-0.00" && cash_dis_ref_amt != "-0.0"
            && cash_dis_ref_amt != "0" && cash_dis_ref_amt != "" {
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
                                smallFeeSum.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                small_debit.append("\(nca_title) for DEBIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
                                debit_count = 1
                            }
                        }
                        else if split_pay.pay_type == "credit" {
                            if credit_count != 1 {
                                smallFeeSum.append("\(nca_title) for CREDIT(\(String(format: "%.02f", roundOf(item: split_pay.cash_discounting_percentage)))%)")
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
                    smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                }
                else if small_credit.count == 0 {
                    smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                }
                else {
                    if mode_first == 1 {
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                    }
                    else {
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(debit_card)")))")
                        smallFeeSumValue.append("\(String(format: "%.02f", roundOf(item: "\(credit_card)")))")
                    }
                }
            }
            //            else {
            //                if card_type.contains("Debit") || card_type.contains("debit") {
            //                    smallFeeSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
            //                    smallFeeSumValue.append("\(cash_discount)")
            //                }
            //                else if card_type.contains("Credit") || card_type.contains("credit"){
            //                    smallFeeSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
            //                    smallFeeSumValue.append("\(cash_discount)")
            //                }
            //                else {
            //                }
            //            }
        }
        
        
        if split != "1" {
            let cash_dis_doub = Double(cash_discount) ?? 0.00
            let cash_dis_ref_amt_doub = Double(cash_dis_ref_amt) ?? 0.00
            if card_type.contains("Debit") || card_type.contains("debit") {
                let total = cash_dis_doub + cash_dis_ref_amt_doub
                smallFeeSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
                smallFeeSumValue.append("\(total)")
            }
            else if card_type.contains("Credit") || card_type.contains("credit") {
                let total = cash_dis_doub + cash_dis_ref_amt_doub
                smallFeeSum.append("Non Cash Adjustment for CREDIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
                smallFeeSumValue.append("\(total)")
            }
            else {
            }
        }
        
        if cash_back_fee != "0.0" && cash_back_fee != "0.00" && cash_back_fee != "-0.0" && cash_back_fee != "-0.00" && cash_back_fee != "0" && cash_back_fee != "" && handleZero(value: cash_back_fee) {
            smallFeeSum.append("Cashback Fee")
            smallFeeSumValue.append(cash_back_fee)
        }
        
        var tip = orderDetail?.tip ?? ""
        
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
            smallFeeSum.append("Tip")
            smallFeeSumValue.append("\(tip)")
        }
        else {
            tip = orderDetail?.tip_refund_amount ?? ""
            if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
                smallFeeSum.append("Tip")
                smallFeeSumValue.append("\(tip)")
            }
        }
        
        if smallFeeSumValue.count == 0 {
            
            feeView.isHidden = true
            totalFeeView.isHidden = true
            feeViewHeight.constant = 0
            totalFeeHeight.constant = 0
        }
        else {
            
            feeView.isHidden = false
            totalFeeView.isHidden = false
            feeViewHeight.constant = 40.67
            totalFeeHeight.constant = 44.67
            
            let value = calculateTotalTender(amt: smallFeeSumValue)
            feeTotal.text = "$\(String(format: "%.2f", roundOf(item: value)))"
     
        }
        // grandTotal.text = "$\(calculateGrandTotal())"
        
        feeSum = smallFeeSum
        feeSumValue = smallFeeSumValue
        
        // tender Table
        
        var smallPaySum = [String]()
        var smallPaySumValue = [String]()
        var smallPax = [String]()
        var smallDigits = [String]()
        var smallcashback = [String]()
        
        //        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
        //            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent)  {
        //            smallPaySum.append("Points Applied")
        //            smallPaySumValue.append("(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))")
        //        }
        
        if gift_card_amount != "0.0" && gift_card_amount != "0.00" && gift_card_amount != "-0.0" &&
            gift_card_amount != "-0.00" && gift_card_amount != "0" && gift_card_amount != "" && handleZero(value: gift_card_amount) {
            smallPaySum.append("Gift Card Applied")
            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: gift_card_amount)))")
            smallcashback.append("")
            smallPax.append("")
            smallDigits.append("")
            
        }
        
        if lottery_order_pay != "0.0" && lottery_order_pay != "0.00" && lottery_order_pay != "-0.0" &&
            lottery_order_pay != "-0.00" && lottery_order_pay != "0" && lottery_order_pay != "" && handleZero(value: lottery_order_pay) {
            smallPaySum.append("Lottery")
            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: lottery_order_pay)))")
            smallcashback.append("")
            smallPax.append("")
            smallDigits.append("")
        }
        
        if scratch_order_pay != "0.0" && scratch_order_pay != "0.00" && scratch_order_pay != "-0.0" &&
            scratch_order_pay != "-0.00" && scratch_order_pay != "0" && scratch_order_pay != "" && handleZero(value: scratch_order_pay) {
            smallPaySum.append("Lottery Scratcher")
            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: scratch_order_pay)))")
            smallcashback.append("")
            smallPax.append("")
            smallDigits.append("")
        }
        
        let isloyal = orderDetail?.is_loyality ?? "0"
        let iscredit = orderDetail?.is_store_credit ?? "0"
        let isgift = orderDetail?.is_gift_card ?? "0"
        
        
        if split == "1"  {
            
            for split_way in splitDetail {
                
                if split_way.pay_type == "credit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        //if food_count != 1 {
                        //      small_card_cash.append("Food EBT")
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(split_way.pay_amount)
                        smallcashback.append("")
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        
                        //  food_count = 1
                        //}
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        //if ecash_count != 1 {
                        //    small_card_cash.append("Cash EBT")
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(split_way.pay_amount)
                        smallcashback.append("")
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        //  ecash_count = 1
                        //}
                    }
                    
                    else {
                        //if card_count != 1 {
                        //  small_card_cash.append("Credit Card")
                        smallPaySum.append("Credit Card")
                        smallPaySumValue.append(split_way.pay_amount)
                        smallcashback.append("")
                        
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
                
                else if split_way.pay_type == "debit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        //if food_count != 1 {
                        //   small_card_cash.append("Food EBT")
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(split_way.pay_amount)
                        smallcashback.append("")
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        
                        //  food_count = 1
                        //}
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        // if ecash_count != 1 {
                        //  small_card_cash.append("Cash EBT")
                        smallPaySum.append("Cash EBT")
                        smallFeeSumValue.append(split_way.pay_amount)
                        smallcashback.append("")
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        //   ecash_count = 1
                        //}
                    }
                    
                    else {
                        //  if card_count != 1 {
                        //   small_card_cash.append("Debit Card")
                        smallPaySum.append("Debit Card")
                        let pay = split_way.pay_amount
                        let cashback = split_way.cash_back_amt
                        let cashback_fee = split_way.cash_back_fee
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append("\(sum)")
                        //                        smallPaySumValue.append(split_way.pay_amount)
                        smallcashback.append(split_way.cash_back_amt)
                        let det = split_way.pax_details
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        //     card_count = 1
                        //  }
                    }
                }
                else {
                    // if cash_count != 1 {
                    //  small_card_cash.append("Cash")
                    smallPaySum.append("Cash")
                    smallPaySumValue.append(split_way.pay_amount)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    //    cash_count = 1
                    // }
                }
            }
            
            //            var small_card = [String]()
            //            var small_cash = [String]()
            //            var small_food = [String]()
            //            var small_ecash = [String]()
            
            //            for split_way_info in splitDetail {
            //
            //                if split_way_info.pay_type == "credit" {
            //
            //                    if split_way_info.card_type.contains("FoodEbt") {
            //                     //   small_food.append(split_way_info.pay_amount)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //
            //                    else if split_way_info.card_type.contains("CashEbt") {
            //                    //    small_ecash.append(split_way_info.pay_amount)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //
            //                    else {
            //                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
            //                     //   small_card.append(cred_tip)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //                }
            //                else if split_way_info.pay_type == "debit" {
            //
            //                    if split_way_info.card_type.contains("FoodEbt") {
            //                      //  small_food.append(split_way_info.pay_amount)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //
            //                    else if split_way_info.card_type.contains("CashEbt") {
            //                       // small_ecash.append(split_way_info.pay_amount)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //
            //                    else {
            //                        let cred_tip = calSplitTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
            //                      //  small_card.append(cred_tip)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //                }
            //                else  {
            //                   // small_cash.append(split_way_info.pay_amount)
            //                }
            //            }
            //            var card = Double()
            //            var cash = Double()
            //            var food = Double()
            //            var ecash = Double()
            
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
            
            //            for small in small_card_cash {
            //
            //                if small == "Cash" {
            //                    //    let cal_amt = calculateCashLottery(amt: "\(cash)")
            //                    smallPaySumValue.append(String(format: "%.02f", cash))
            //                }
            //                else if small == "Food EBT" {
            //                    //    let cal_amt = calculateCashLottery(amt: "\(food)")
            //                    smallPaySumValue.append(String(format: "%.02f", food))
            //                }
            //                else if small == "Cash EBT" {
            //                    //    let cal_amt = calculateCashLottery(amt: "\(ecash)")
            //                    smallPaySumValue.append(String(format: "%.02f", ecash))
            //                }
            //                else {
            //                    //   let cal_amt = calculateCashLottery(amt: "\(card)")
            //                    smallPaySumValue.append(String(format: "%.02f", card))
            //                }
            //            }
        }
        
        else if isloyal == "2" || iscredit == "2" || isgift == "2"
                    || isloyal == "1" || iscredit == "1" || isgift == "1" || isLottery == "1" || isScratcher == "1" {
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" && isLottery == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                          - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            
                            smallPaySum.append("Debit Card")
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                            
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                          - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let pax = orderDetail?.pax_details ?? ""
                            let split_details = pax.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                        }
                    }
                }
            }
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                          - roundOf(item: lottery_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            let det = orderDetail?.pax_details ?? ""
                          
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount)
                                              - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && iscredit == "1" && isgift == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let pax = orderDetail?.pax_details ?? ""
                            let split_details = pax.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let pax = orderDetail?.pax_details ?? ""
                            let split_details = pax.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && iscredit == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let pax = orderDetail?.pax_details ?? ""
                            let split_details = pax.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && iscredit == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isgift == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isgift == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isLottery == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                           - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isgift == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                           - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isgift == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                           - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isLottery == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                           - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: store_credit))
                                               - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
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
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
                                              - roundOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
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
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: lottery_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isloyal == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
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
                        smallcashback.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if iscredit == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isgift == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: lottery_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isgift == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: gift_card_amount)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                }
            }
            
            else if isLottery == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String((roundOf(item: cash_value) - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetail?.cash_back_amt ?? ""
                            let cashback_fee = orderDetail?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                            smallPaySum.append("Debit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            //                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
                        }
                    }
                    
                    else {
                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: lottery_order_pay)) - roundOf(item: scratch_order_pay))
                        let pax = orderDetail?.pax_details ?? ""
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
                            smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                            smallcashback.append("")
                            
                            let det = orderDetail?.pax_details ?? ""
                            
                            if det != "" {
                                let split_details = det.split(separator: "\n")
                                let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                                let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                                smallPax.append(auth)
                                
                                let split_detail = det.split(separator: "\n")
                                let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                                let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                                smallDigits.append(aut)
                            }
                            else {
                                smallPax.append("")
                                smallDigits.append("")
                            }
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
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        smallPaySum.append("Debit Card")
                        let pay = amt
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                        //let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        //smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
                        
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append("")
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
            }
            
            else if iscredit == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                    //                    let cal_amt = calculateCashLottery(amt: cred_amt)
                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        let pay = cash_value
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                        smallPaySum.append("Debit Card")
                        let cred_amt = calculateDiscount(amt: "\(sum)", discount: store_credit)
                        
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                        
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
                        
                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
            }
            
            else if isgift == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                    smallPaySumValue.append(cred_amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        smallPaySum.append("Debit Card")
                        let pay = cash_value
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                        let cred_amt = calculateDiscount(amt: "\(sum)", discount: gift_card_amount)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: gift_card_amount)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
            }
            
            else if isLottery == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: lottery_order_pay)
                    smallPaySumValue.append(cred_amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: lottery_order_pay)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: lottery_order_pay)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        let pay = cash_value
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        
                        smallPaySum.append("Debit Card")
                        let cred_amt = calculateDiscount(amt: "\(sum)", discount: lottery_order_pay)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: lottery_order_pay)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
            }
            
            else if isScratcher == "1" {
                
                if payment_id == "Cash" {
                    
                    smallPaySum.append("Cash")
                    let cred_amt = calculateDiscount(amt: cash_value, discount: scratch_order_pay)
                    smallPaySumValue.append(cred_amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: scratch_order_pay)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("FoodEbt") {
                        let cred_amt = calculateDiscount(amt: cash_value, discount: scratch_order_pay)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else if card_type.contains("Debit") {
                        smallPaySum.append("Debit Card")
                        let pay = cash_value
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        let cred_amt = calculateDiscount(amt: "\(sum)", discount: scratch_order_pay)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let pax = orderDetail?.pax_details ?? ""
                        let split_details = pax.split(separator: "\n")
                        let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                        let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                    
                    else {
                        smallPaySum.append("Credit Card")
                        let cred_amt = calculateDiscount(amt: cash_value, discount: scratch_order_pay)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        
                        let pax = orderDetail?.pax_details ?? ""
                        let split_details = pax.split(separator: "\n")
                        let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                        let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
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
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                }
            }
            else {
                
                if card_type.contains("CashEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Cash EBT")
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
                
                else if card_type.contains("FoodEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Food EBT")
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append("")
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
                
                else if card_type.contains("Debit") {
                    
                    
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Debit Card")
                        
                        let pay = amt
                        let cashback = orderDetail?.cash_back_amt ?? ""
                        let cashback_fee = orderDetail?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: "\(sum)")))
                        
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
                
                else {
                    
                    
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" && !amt.contains("null") {
                        smallPaySum.append("Credit Card")
                        
                        //                        let cal_amt = calculateCashLottery(amt: amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
                        smallcashback.append("")
                        
                        let det = orderDetail?.pax_details ?? ""
                        
                        if det != "" {
                            let split_details = det.split(separator: "\n")
                            let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                            let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                            smallPax.append(auth)
                            
                            let split_detail = det.split(separator: "\n")
                            let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                            let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                            smallDigits.append(aut)
                        }
                        else {
                            smallPax.append("")
                            smallDigits.append("")
                        }
                    }
                }
            }
        }
        
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" && store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(value: store_credit) {
            smallPaySum.append("Store Credit")
            smallPaySumValue.append(store_credit)
            smallcashback.append("")
            
            smallPax.append("")
            smallDigits.append("")
        }
        
        calculateHeightForTender(pay: smallPaySum)
        paySum = smallPaySum
        paySumValue = smallPaySumValue
        tenderCashBack = smallcashback
        tenderPax = smallPax
        tenderDigits = smallDigits
        
        let value = calculateTotalTender(amt: smallPaySumValue)
        payAmt.text = "$\(String(format: "%.2f", roundOf(item: value)))"
        
        let change = orderDetail?.change_due ?? "0.00"
        changeDue.text = "$\(String(format: "%.2f", roundOf(item: change)))"
        
        var smallName = [String]()
        var smallValue = [String]()
        
        let delivery_name = orderDetail?.deliver_name ?? ""
        let billing_name = orderDetail?.billing_name ?? ""
        
        let cust_id = orderDetail?.customer_id ?? ""
        
        let email = orderDetail?.email ?? ""
        let cust_email = orderDetail?.customer_email ?? ""

        let delivery_phn = orderDetail?.delivery_phn ?? ""
        let cust_phone = orderDetail?.customer_phone ?? ""
        
        if delivery_name == "" && billing_name == ""  {
            
        }
        
        else if delivery_name.contains("null") && billing_name.contains("null") {
            
        }
        else if delivery_name == "" || delivery_name.contains("null") {
            if billing_name == "" || billing_name.contains("null") {
            }
            else {
                smallName.append("Name")
                smallValue.append(billing_name)
            }
        }
        else {
            smallName.append("Name")
            smallValue.append(delivery_name)
        }
        
        if cust_id == "" || cust_id.contains("null") {
        }
        else {
            smallName.append("Customer Id")
            smallValue.append(cust_id)
        }
        
        if email == "" && cust_email == "" {
            
        }
        
        else if email.contains("null") && cust_email.contains("null") {
            
        }
        
        else if email == "" || email.contains("null") {
            if cust_email == "" || cust_email.contains("null") {
            }
            else {
                smallName.append("Email")
                smallValue.append(cust_email)
            }
        }
        else if cust_email == "" || cust_email.contains("null") {
            if email == "" || email.contains("null") {
            }
            else {
                smallName.append("Email")
                smallValue.append(email)
            }
        }
        
        else {
            smallName.append("Email")
            smallValue.append(email)
        }
        
        if delivery_phn == "" && cust_phone == "" {
            
        }
        
        else if delivery_phn.contains("null") && cust_phone.contains("null") {
            
        }
        
        else if delivery_phn == "" || delivery_phn.contains("null") {
            if cust_phone == "" || cust_phone.contains("null") {
            }
            else {
                smallName.append("Mobile")
                smallValue.append(cust_phone)
            }
        }
        else if cust_phone == "" || cust_phone.contains("null") {
            if delivery_phn == "" || delivery_phn.contains("null") {
            }
            else {
                smallName.append("Mobile")
                smallValue.append(delivery_phn)
            }
        }
        
        else {
            smallName.append("Mobile")
            smallValue.append(delivery_phn)
        }
        
        if smallName.count == 0 {
            id_exist = false
            custDetails.isHidden = true
            blueidentity.isHidden = true
            underidentity.isHidden = true
        }
        else {
            id_exist = true
        }
        
        print(smallName)
        print(smallValue)
        
        idRefundName = smallName
        idRefundValue = smallValue
        
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
        
        //
        //        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00"
        //            && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
        //            smallPaySum.append("Points Awarded")
        //            smallPaySumValue.append(points_earned)
        //        }
        
        //        paySum = smallPaySum
        //        paySumValue = smallPaySumValue
        
        //ordersumtable
        
        //        let discount = orderDetail?.discount ?? ""
        
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
        
        //        let tip = orderDetail?.tip ?? ""
        //
        //        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
        //            smallOrderSum.append("Tip")
        //            smallOrderSumValue.append("\(tip)")
        //        }
        
        
        //        let cash_discount = orderDetail?.cash_discounting ?? ""
        //        let cash_per = orderDetail?.cash_discounting_percentage ?? ""
        
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
        
        //let tax = orderDetail?.tax ?? ""
        
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
        
        
        //        feeSum = smallOrderSum
        //        feeSumValue = smallOrderSumValue
        
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
        
        //        if lottery_order_pay != "0.0" && lottery_order_pay != "0.00" && lottery_order_pay != "-0.0" &&
        //            lottery_order_pay != "-0.00" && lottery_order_pay != "0" && lottery_order_pay != "" && handleZero(value: lottery_order_pay) {
        //            smallPaySum.append("Lottery Payout")
        //            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: lottery_order_pay)))")
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
        
        
        
        //        let isloyal = orderDetail?.is_loyality ?? "0"
        //        let iscredit = orderDetail?.is_store_credit ?? "0"
        //        let isgift = orderDetail?.is_gift_card ?? "0"
        
        
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
        //                    //    let cal_amt = calculateCashLottery(amt: "\(cash)")
        //                    smallPaySumValue.append(String(format: "%.02f", cash))
        //                }
        //                else if small == "Food EBT" {
        //                    //    let cal_amt = calculateCashLottery(amt: "\(food)")
        //                    smallPaySumValue.append(String(format: "%.02f", food))
        //                }
        //                else if small == "Cash EBT" {
        //                    //    let cal_amt = calculateCashLottery(amt: "\(ecash)")
        //                    smallPaySumValue.append(String(format: "%.02f", ecash))
        //                }
        //                else {
        //                    //   let cal_amt = calculateCashLottery(amt: "\(card)")
        //                    smallPaySumValue.append(String(format: "%.02f", card))
        //                }
        //            }
        //        }
        
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
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
        //                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = String(((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
        //                                               - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
        //                                              - roundOf(item: store_credit))
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent))
        //                                              - roundOf(item: store_credit))
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: store_credit)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = String((roundOf(item: cash_value) - roundOf(item: points_amt_spent)) - roundOf(item: gift_card_amount))
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                            //                            let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                    //                    let cal_amt = calculateCashLottery(amt: cred_amt)
        //                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = calculateDiscount(amt: cash_value, discount: points_amt_spent)
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: amt)
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
        //                    //                    let cal_amt = calculateCashLottery(amt: cred_amt)
        //                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
        //                }
        //                else {
        //
        //                    if card_type.contains("CashEbt") {
        //                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
        //                        smallPaySumValue.append(cred_amt)
        //                    }
        //
        //                    else if card_type.contains("FoodEbt") {
        //                        let cred_amt = calculateDiscount(amt: cash_value, discount: store_credit)
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: cred_amt)
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
        
        //        else {
        //            if payment_id == "Cash" {
        //
        //                if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != ""  {
        //                    smallPaySum.append("Cash")
        //                    //                    let cal_amt = calculateCashLottery(amt: amt)
        //                    smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
        //                }
        //            }
        //            else {
        //
        //                if card_type.contains("CashEbt") {
        //                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
        //                        smallPaySum.append("Cash EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
        //                    }
        //                }
        //
        //                else if card_type.contains("FoodEbt") {
        //                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
        //                        smallPaySum.append("Food EBT")
        //                        //                        let cal_amt = calculateCashLottery(amt: amt)
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
        //                        //                        let cal_amt = calculateCashLottery(amt: amt)
        //                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: amt)))
        //                    }
        //                }
        //            }
        //        }
        
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
        
        //        paySum = smallPaySum
        //        paySumValue = smallPaySumValue
        
        
        
    }
    
    func setCartData(cart: Any) {
        
        let smallres = cart as! [[String:Any]]
        var smallcart = [Cart_Data]()
        var smallrefcart = [Cart_Data]()
        
        var taxcart = [Cart_Data]()
        
        var countItems = 0
        
        if smallres.count == 0 {
            
            isNoItem = true
            
            if isCartLottery == "1" {
                
                let total_lottery = couponCode?.total_lottery_payout ?? "0.00"
                
                smallcart.append(Cart_Data(line_item_id: "", variant_id: "", category_id: "",
                                           cost_price: "", name: "", is_bulk_price: "", bulk_price_id: "",
                                           qty: "", note: "Lottery", userData: "", taxRates: "", default_tax_amount: "",
                                           other_taxes_amount: "", other_taxes_desc: "", is_refunded: "",
                                           refund_amount: "", refund_qty: "", id: "", img: "", price: "",
                                           discount_amt: "0.00", coupon_code_amt: "", is_lottery: "", discount_rate: "",
                                           adjust_price: "", use_point: "", earn_point: "", lp_discount_amt: "",
                                           other_taxes_rate_desc: "", other_taxes_refund_desc: "",
                                           default_tax_refund_amount: "", other_taxes_refund_amount: "",
                                           inventory_price: total_lottery, vendor_id: "", vendor_name: "", brand_name: "", brand_id: ""))
            }
            
            if isCartScratcher == "1" {
                
                let total_lottery = couponCode?.total_scratcher_payout ?? "0.00"
                
                smallcart.append(Cart_Data(line_item_id: "", variant_id: "", category_id: "",
                                           cost_price: "", name: "", is_bulk_price: "", bulk_price_id: "",
                                           qty: "", note: "Lottery Scratcher", userData: "", taxRates: "",
                                           default_tax_amount: "",
                                           other_taxes_amount: "", other_taxes_desc: "", is_refunded: "",
                                           refund_amount: "", refund_qty: "", id: "", img: "", price: "",
                                           discount_amt: "0.00", coupon_code_amt: "", is_lottery: "", discount_rate: "",
                                           adjust_price: "", use_point: "", earn_point: "", lp_discount_amt: "",
                                           other_taxes_rate_desc: "", other_taxes_refund_desc: "",
                                           default_tax_refund_amount: "", other_taxes_refund_amount: "",
                                           inventory_price: total_lottery, vendor_id: "", vendor_name: "", brand_name: "", brand_id: ""))
            }
            
            countItems = smallcart.count
        }
        
        else {
            
            isNoItem = false
            
            countItems = smallres.count
            
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
                
                taxcart.append(cart)
                
                
                //                if cart.is_refunded == "1" {
                //                    if smallrefcart.count != 0 {
                //                        if smallrefcart.contains(where: { $0.note == cart.note }) {
                //                            let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                //                            let quantity = smallrefcart[index].refund_qty
                //                            print(quantity)
                //                            let newQty = (Int(quantity) ?? 0) + 1
                //                            smallrefcart[index].refund_qty = String(newQty)
                //
                //                            let discount = smallrefcart[index].discount_amt
                //                            let newDis = cart.discount_amt
                //
                //                            var int_dis = Double(discount) ?? 0.00
                //                            let int_newDis = Double(newDis) ?? 0.00
                //                            int_dis += int_newDis
                //                            smallrefcart[index].discount_amt = String(int_dis)
                //                        }
                //                        else {
                //                            smallrefcart.append(cart)
                //                        }
                //                    }
                //                    else {
                //                        smallrefcart.append(cart)
                //                    }
                //                }
                
                //                else if cart.is_refunded == "2" {
                //                    if smallrefcart.count != 0 {
                //                        if smallrefcart.contains(where: { $0.note == cart.note }) {
                //                            let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                //                            let quantity = smallrefcart[index].refund_qty
                //
                //                            let newQty = (Int(quantity) ?? 0) + 1
                //                            smallrefcart[index].refund_qty = String(newQty)
                //
                //                            let discount = smallrefcart[index].discount_amt
                //                            let newDis = cart.discount_amt
                //
                //                            var int_dis = Double(discount) ?? 0.00
                //                            let int_newDis = Double(newDis) ?? 0.00
                //                            int_dis += int_newDis
                //                            smallrefcart[index].discount_amt = String(int_dis)
                //                        }
                //                        else {
                //                            smallrefcart.append(cart)
                //                        }
                //                    }
                //                    else {
                //                        smallrefcart.append(cart)
                //                    }
                //
                //                    if smallcart.count != 0 {
                //                        if smallcart.contains(where: { $0.note == cart.note }) {
                //                            let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                //                            let quantity = smallcart[index].qty
                //                            print(quantity)
                //                            let newQty = (Int(quantity) ?? 0) + 1
                //                            smallcart[index].qty = String(newQty)
                //
                //                            let discount = smallcart[index].discount_amt
                //                            let newDis = cart.discount_amt
                //
                //                            var int_dis = Double(discount) ?? 0.00
                //                            let int_newDis = Double(newDis) ?? 0.00
                //                            int_dis += int_newDis
                //                            smallcart[index].discount_amt = String(int_dis)
                //                        }
                //                        else {
                //                            smallcart.append(cart)
                //                        }
                //                    }
                //                    else {
                //                        smallcart.append(cart)
                //                    }
                //                }
                
                //                else {
                //                    if smallcart.count != 0 {
                //                        if smallcart.contains(where: { $0.note == cart.note }) {
                //                            let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
                //                            let quantity = smallcart[index].qty
                //                            print(quantity)
                //                            let newQty = (Int(quantity) ?? 0) + 1
                //                            smallcart[index].qty = String(newQty)
                //
                //                            let discount = smallcart[index].discount_amt
                //                            let newDis = cart.discount_amt
                //
                //                            var int_dis = Double(discount) ?? 0.00
                //                            let int_newDis = Double(newDis) ?? 0.00
                //                            int_dis += int_newDis
                //                            smallcart[index].discount_amt = String(int_dis)
                //                        }
                //                        else {
                //                            smallcart.append(cart)
                //                        }
                //                    }
                //                    else {
                //                        smallcart.append(cart)
                //                    }
                //                }
                
                if cart.is_refunded == "1" {
                    smallrefcart.append(cart)
                }
                else if cart.is_refunded == "2" {
                    smallrefcart.append(cart)
                    smallcart.append(cart)
                }
                else {
                    smallcart.append(cart)
                }
            }
        }
        
        let tax = orderDetail?.tax ?? "0.00"
        
        let tax_rate = orderDetail?.tax_rate ?? "0.00"
        
        
        let other_taxes = orderDetail?.other_taxes_desc ?? ""
        
        let other_tax = convertStringToDictionary(text: other_taxes)
        
        let other_taxes_rate = orderDetail?.other_taxes_rate_desc ?? ""
        
        let other_tax_rate = convertStringToDictionary(text: other_taxes_rate)
        
        var tax_order_sum_array = [Tax_Order_Summary]()
        
        tax_order_sum_array.append(Tax_Order_Summary(tax_name: "DefaultTax", tax_rate: tax_rate,
                                                     tax_amount: "", sale_due: String(format: "%.2f", roundOf(item: tax))))
        
        
        for (key, value) in other_tax {
            
            tax_order_sum_array.append(Tax_Order_Summary(tax_name: key, tax_rate: "",
                                                         tax_amount: "", sale_due: "\(value)"))
        }
        
        print(tax_order_sum_array)
        
        for (key, value) in other_tax_rate {
            
            if tax_order_sum_array.contains(where: {$0.tax_name == key}) {
                
                let index = tax_order_sum_array.firstIndex(where: {$0.tax_name == key}) ?? 0
                tax_order_sum_array[index].tax_rate = "\(value)"
            }
        }
        
        print(tax_order_sum_array)
        
        
        for item_cart in taxcart {
            
            let tax_def_pay = item_cart.default_tax_amount
            
            let tax_other_pay = item_cart.other_taxes_desc
            
            let price_pay = item_cart.price
            
            let lottery_pay = item_cart.is_lottery
            
            let price_pay_doub = Double(price_pay) ?? 0.00 //23.79
            
            if tax_def_pay != "" && tax_def_pay != "0.00" && tax_def_pay != "0.0" {
                
                let index = tax_order_sum_array.firstIndex(where: { $0.tax_name == "DefaultTax"}) ?? 0
                let amt = tax_order_sum_array[index].tax_amount
                var amt_doub = Double(amt) ?? 0.00
                amt_doub += price_pay_doub
                tax_order_sum_array[index].tax_amount = String(format: "%.2f", amt_doub)
            }
            
            let pay = convertStringToDictionary(text: tax_other_pay)
            
            
            if pay.count != 0 {
                
                for (key, value) in pay {
                    
                    let index = tax_order_sum_array.firstIndex(where: { $0.tax_name == key}) ?? 0
                    let amt = tax_order_sum_array[index].tax_amount
                    var amt_doub = Double(amt) ?? 0.00
                    amt_doub += price_pay_doub
                    tax_order_sum_array[index].tax_amount = String(format: "%.2f", amt_doub)
                }
            }
        }
        
        var add = 0.00
        
        for price in tax_order_sum_array {
            
            let price_double = Double(price.sale_due) ?? 0.00
            add += price_double
        }
        
        taxTotalLbl.text = "$\(String(format: "%.2f", add))"
        
        tax_table_array = tax_order_sum_array
        
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
        
        let itemCounts = countItems
        
        orderDetailLabel.append("Total Items")
        orderDetailValue.append("\(itemCounts)")
        
        grandTotal.text = "$\(String(format: "%.2f", roundOf(item: calculateGrandTotal())))"
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
        
        print(splitDetail)
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
    
    func setRefundData(refund_data: Any) {
        
        let refund = refund_data as! [[String:Any]]
        refundDetail = refund
        
        var smallRefund = [[String]]()
        var smallRefundVal = [[String]]()
        var smallDate = [String]()
        var smallRefundTip = [[TipNca]]()
        var smallRefundHeight = [[String]]()
        var smallRefPax = [[String]]()
        var smallRefDigits = [[String]]()
        
        var removeLoyal = [Loyalty]()
        
        var taxesRefund = [[String]]()
        
        var smallRefundTableArray = [RefundTableDetails]()
        
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
            
            _ = refund_pay.amount
            let c_card_pay = refund_pay.credit_amt
            let d_card_pay = refund_pay.debit_amt
            let cash_pay = refund_pay.cash_amt
            
            
            _ = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
            let gift_card = refund_pay.giftcard_amt
            
            
            _ = refund_pay.reason
            
            
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
            _ = refund_pay.giftcard_amt
            let nca_amt = refund_pay.nca_amt
            
            
            let reward_loyalty_refund_point = refund_pay.reward_loyalty_refund_point
            
            let credit_refund_tax = refund_pay.credit_refund_tax
            let debit_refund_tax = refund_pay.debit_refund_tax
            let cash_refund_tax = refund_pay.cash_refund_tax
            
            
            let store_credit_refund_tax = refund_pay.store_credit_refund_tax
            _ = refund_pay.loyality_refund_tax
            let gift_card_refund_tax = refund_pay.gift_card_refund_tax
            
            _ = refund_pay.default_tax_rate
            _ = refund_pay.other_tax_rate_desc
            
            _ = refund_pay.default_tax_refund_amount
            _ = refund_pay.other_taxes_refund_amount
            _ = refund_pay.other_taxes_refund_desc
            
            let pax = refund_pay.refund_pax_details
            
            var smallRef = [String]()
            var smallRefValues = [String]()
            var smallTaxes = [String]()
            var smalltip = [TipNca]()
            var smallHeight = [String]()
            var smallPax = [String]()
            var smallDigits = [String]()
            
            //            smallRef.append("Reason Of Refund")
            //            smallRefValues.append(refund_reason)
            
            if c_card_pay != "0.0" && c_card_pay != "0.00" && c_card_pay != "0.000"  {
                smallRef.append("Credit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: c_card_pay)))")
                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: credit_refund_tax)))")
                smalltip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
                smallHeight.append("98.33")
                
                
                if pax != "" {
                    let split_details = pax.split(separator: "\n")
                    let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                    let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                    smallPax.append(auth)
                    
                    let split_detail = pax.split(separator: "\n")
                    let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                    let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                    smallDigits.append(aut)
                }
                else {
                    smallPax.append("")
                    smallDigits.append("")
                }
            }
            
            if d_card_pay != "0.0" && d_card_pay != "0.00" && d_card_pay != "0.000"{
                smallRef.append("Debit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: d_card_pay)))")
                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: debit_refund_tax)))")
                smalltip.append(TipNca(tipAmt: tip_amt, ncaAmt: nca_amt))
                smallHeight.append("98.33")
                
                if pax != "" {
                    let split_details = pax.split(separator: "\n")
                    let ele = split_details.first(where: {$0.contains("AuthCode")}) ?? ""
                    let auth = ele.replacingOccurrences(of: "AuthCode:", with: "")
                    smallPax.append(auth)
                    
                    let split_detail = pax.split(separator: "\n")
                    let ell = split_detail.first(where: {$0.contains("Last4Digit")}) ?? ""
                    let aut = ell.replacingOccurrences(of: "Last4Digit:", with: "")
                    smallDigits.append(aut)
                }
                else {
                    smallPax.append("")
                    smallDigits.append("")
                }
            }
            
            if cash_pay != "0.0" && cash_pay != "0.00" && cash_pay != "0.000" {
                smallRef.append("Cash")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: cash_pay)))")
                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: cash_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "", ncaAmt: ""))
                smallHeight.append("80.33")
                smallPax.append("")
                smallDigits.append("")
            }
            
            //            if loyalty_amt != "0.0" && loyalty_amt != "0.00" && loyalty_amt != "0.000" {
            //                smallRef.append("Loyalty Points")
            //                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: loyalty_amt)))")
            //                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: loyality_refund_tax)))")
            //                smalltip.append(TipNca(tip_amt: tip_amt, nca_amt: nca_amt))
            //            }
            
            if store_cred != "0.0" && store_cred != "0.00" && store_cred != "0.000" {
                smallRef.append("Store Credits")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: store_cred)))")
                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: store_credit_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "0.00", ncaAmt: "0.00"))
                smallHeight.append("98.33")
                smallPax.append("")
                smallDigits.append("")
            }
            
            //            if tip_amt != "0.0" && tip_amt != "0.00" && tip_amt != "0.000" {
            //                smallRef.append("Tip")
            //                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: tip_amt)))")
            //                smallTaxes.append("0.00")
            //            }
            
            if gift_card != "0.0" && gift_card != "0.00" && gift_card != "0.000" {
                smallRef.append("Gift Card")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: gift_card)))")
                smallTaxes.append("$\(String(format: "%.02f", roundOf(item: gift_card_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "0.00", ncaAmt: "0.00"))
                smallHeight.append("98.33")
                smallPax.append("")
                smallDigits.append("")
                
            }
            
            //            if nca_amt != "0.0" && nca_amt != "0.00" && nca_amt != "0.000" {
            //
            //                smallRef.append("Non Cash Adjustment")
            //                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: nca_amt)))")
            //                smallTaxes.append("0.00")
            //            }
            
            if reward_loyalty_refund_point != "0.0"
                && reward_loyalty_refund_point != "0.00"
                && reward_loyalty_refund_point != "0.000"
                && reward_loyalty_refund_point != "-0.0"
                && reward_loyalty_refund_point != "-0.00"
                && reward_loyalty_refund_point != "0"
                && reward_loyalty_refund_point != ""
                && handleZero(value: reward_loyalty_refund_point) {
                
                removeLoyal.append(Loyalty(loyalty_points: reward_loyalty_refund_point, loyalty_date: create_date))
            }
            
            smallRefund.append(smallRef)
            smallRefundVal.append(smallRefValues)
            smallDate.append(create_date)
            taxesRefund.append(smallTaxes)
            smallRefundTip.append(smalltip)
            smallRefundHeight.append(smallHeight)
            smallRefPax.append(smallPax)
            smallRefDigits.append(smallDigits)
            
            let smallobj = RefundTableDetails(refund: smallRef,
                                              refundValues: smallRefValues,
                                              refundDate: create_date,
                                              refundTax: smallTaxes,
                                              refNcaTip: smalltip,
                                              refundHeight: smallHeight,
                                              refundPax: smallPax,
                                              refundPaxDigit: smallDigits)
            
            smallRefundTableArray.append(smallobj)
            
            print(smallRefundTableArray)
        }
        
        payRefund = smallRefund
        payRefundValues = smallRefundVal
        payRefundDate = smallDate
        payRefundTax = taxesRefund
        payRefNcaTip = smallRefundTip
        payRefundHeight = smallRefundHeight
        refundPaxAuth = smallRefPax
        refundPaxDigits = smallRefDigits
    
        refundTableArray = smallRefundTableArray
        
        let totalRefund = calculateTotalRefund(payValues: smallRefundVal)
        refundPriceTotal.text = "$\(String(format: "%.2f", roundOf(item: totalRefund)))"
        
        let totaltaxRefund = calculateTotalRefundTax(payValues: taxesRefund)
        totalTaxRefund.text = "$\(String(format: "%.2f", roundOf(item: totaltaxRefund)))"
        
        var grand = grandTotal.text ?? ""
        grand.removeFirst()
        let grand_doub = Double(grand) ?? 0.00
        let after_doub = Double(totalRefund) ?? 0.00
        
        let grands =  grand_doub - after_doub
        afterRefundPrice.text = "$\(String(format: "%.2f", roundOf(item: "\(grands)")))"
        
        let points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let remove = calculateLoyal(points: removeLoyal)
        
        let remove_doub = Double(remove) ?? 0.00
        let earned_doub = Double(points_earned) ?? 0.00
        
        var award = 0.00
        
        if earned_doub < 0.00 {
            award = remove_doub - earned_doub
        }
        else {
            award = remove_doub + earned_doub
        }
        
        var refund_loyal = [Loyalty]()
        
        if award != 0.0 && award != 0.00 && award != -0.0 && award != -0.00 && award != 0 {
            refund_loyal.append(Loyalty(loyalty_points: "\(award)", loyalty_date: orderDetail?.date_time ?? ""))
        }
        
        refund_loyal.append(contentsOf: removeLoyal)
        
        
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        refund_loyal.sort { (loyal1, loyal2) -> Bool in
            let date1 = dateFormatter.date(from: loyal1.loyalty_date) ?? Date()
            let date2 = dateFormatter.date(from: loyal2.loyalty_date) ?? Date()
            
            return date1 < date2
        }
        
        
        loyalArray = refund_loyal
        
        if loyalArray.count == 0 {
            totalLoyalPoints.text = ""
            totalLoyalViewHeight.constant = 0
            loyaltyHeadHeight.constant = 0
            blueLoyalty.isHidden = true
            loyaltyPointsLbl.text = ""
            totalLoyaltyLbl.text = ""
        }
        else {
            
            var total = 0.00
            if loyalArray.count != 0 {
                total = Double(loyalArray[0].loyalty_points) ?? 0.00
                totalLoyalPoints.text = String(total)
            }
            
            if loyalArray.count > 1 {
                for loyal in 1..<loyalArray.count {
                    
                    let award = Double(loyalArray[loyal].loyalty_points) ?? 0.00
                    
                    total -= award
                }
                if total < 0.00 {
                    var value = String(total)
                    if value.hasPrefix("-") {
                        value.removeFirst()
                    }
                    totalLoyalPoints.text = String(format: "%.2f", roundOf(item: value))
                }
                else {
                    totalLoyalPoints.text = String(format: "%.2f", roundOf(item: String(total)))
                }
            }
        }
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
    
    func calTotalPrice(onePrice: String, qty: String, discount: String) -> Double {
        
        let price = Double(onePrice) ?? 0.00
        let quant = Double(qty) ?? 0.00
        let dis = Double(discount) ?? 0.00
        
        let total = price * quant
        
        let dis_price = total - dis
        
        
        return roundOf(item: String(dis_price))
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
    
    func calculateTotalRefundTax(payValues: [[String]]) -> String {
        
        var total = 0.00
        
        for pay in payValues {
            
            for item in pay {
                var itemDollar = String(item)
                if itemDollar.starts(with: "$") {
                    itemDollar.removeFirst()
                }
                total += Double(itemDollar) ?? 0.00
            }
        }
        print(total)
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
    
    func calculateTotalTender(amt: [String]) -> String {
        
        var total = 0.00
        for add in amt {
            
            let add_doub = Double(add) ?? 0.00
            total += add_doub
        }
        return String(total)
    }
    
    func calculateTotalNetSales(values: [String]) -> String {
        
        _ = 0.00
        
        let loyal = values[0]
        let dis = values[1]
        
        let loyal_doub = Double(loyal) ?? 0.00
        let dis_doub = Double(dis) ?? 0.00
        
        if loyal_doub == 0.00 && dis_doub == 0.00 {
            var gross = grossAmt.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            return String(gross)
        }
        
        else if loyal_doub == 0.00 {
            
            var gross = grossAmt.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = gross_doub - dis_doub
            return String(net)
        }
        
        else if dis_doub == 0.00 {
            
            var gross = grossAmt.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = gross_doub - loyal_doub
            return String(net)
        }
        
        else {
            
            var gross = grossAmt.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = (gross_doub - (loyal_doub + dis_doub))
            return String(net)
        }
    }
    
    func calculateGrandTotal() -> String {
        
        var net = netAmt.text ?? "0.00"
        if net.count != 0 {
            net.removeFirst()
        }
        let net_doub = Double(net) ?? 0.00
        
        var tax = taxTotalLbl.text ?? "0.00"
        if tax.count != 0 {
            tax.removeFirst()
        }
        let tax_doub = Double(tax) ?? 0.00
        
        var fees = feeTotal.text ?? "0.00"
        if fees.count != 0 {
            fees.removeFirst()
        }
        let fees_doub = Double(fees) ?? 0.00
        
        let total = net_doub + tax_doub + fees_doub
        return String(format: "%.2f", total)
        
    }
    
    func calculateTotalRefund(payValues: [[String]]) -> String {
        
        var total = 0.00
        
        for pay in payValues {
            
            for item in pay {
                var itemDollar = String(item)
                if itemDollar.starts(with: "$") {
                    itemDollar.removeFirst()
                }
                total += Double(itemDollar) ?? 0.00
            }
        }
        
        var totaltip = 0.00
        
        print(payRefNcaTip.count)
        for tip in payRefNcaTip {
            print(tip.count)
            for nca in tip {
                
                let val1 = nca.ncaAmt
                let val2 = nca.tipAmt
                
                let val3 = Double(val1) ?? 0.00
                let val4 = Double(val2) ?? 0.00
                
                totaltip += val3
                totaltip += val4
            }
        }
        
        let totalRefund = total + totaltip
        return String(totalRefund)
    }
    
    func calculateLoyal(points: [Loyalty]) -> String {
        
        var total = 0.00
        
        for point in points {
            
            total += Double(point.loyalty_points) ?? 0.00
        }
        
        return String(total)
    }
    
    func getPaxDetails() {
        
        
        
    }
    
    func dashedLine() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(hexString: "#707070").cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        
        let path1 = CGMutablePath()
        path1.addLines(between: [CGPoint(x: 0, y: dotView.frame.maxY), CGPoint(x: dotView.frame.maxX, y: dotView.frame.maxY)])
        shapeLayer.path = path1
        scroll.layer.addSublayer(shapeLayer)
    }
    
    func getCountForHeight() -> Double {
        var counter = 0.00
        
        if payRefund.count == 0 {
            return 0
        }
        else {
            
            for pay in payRefundHeight {
                
                for num in pay {
                    counter = counter + (Double(num) ?? 0.00)
                }
            }
            return counter
        }
    }
    
    func calculateHeightForTender(pay: [String]) {
        
        var smalltenderHeight = [String]()
        
        for height in pay {
            
            if height == "Debit Card" {
                smalltenderHeight.append("98.33")
            }
            
            else if height == "Credit Card" || height == "Food EBT" || height == "Cash EBT" {
                smalltenderHeight.append("80.33")
            }
            
            else {
                smalltenderHeight.append("62.33")
            }
        }
        tenderHeight = smalltenderHeight
    }
    
    func getTenderHeight() -> Double {
        
        var height = 0.00
        
        for val in tenderHeight {
            
            height += Double(val) ?? 0.00
        }
        
        return height
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


extension InStoreNewDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == payRefundTable {
            if orderDetail?.is_refunded == "1" {
                return payRefund.count
            }
            else {
                return 0
            }
        }
        
        
        else if tableView == identityTable {
            
            if id_exist {
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
        
        else if tableView == payRefundItemsTable {
            return cartRefundItems.count
        }
        
        else if tableView == orderDetailTable {
            return orderDetailLabel.count
        }
        
        else if tableView == grossTable {
            return grossLabel.count
        }
        
        else if tableView == taxTableView {
            return tax_table_array.count
        }
        
        else if tableView == loyalTableview {
            return loyalArray.count
        }
        
        else if tableView == feeTable {
            return feeSum.count
        }
        
        else if tableView == tenderTable {
            return paySum.count
        }
        
        else if tableView == payRefundTable {
            return payRefund[section].count
//            return refundTableArray[section].refund.count
        }
        else if tableView == identityTable {
            return idRefundName.count
        }
        //
        //
        //        else if tableView == orderSumTable {
        //            return orderSum.count
        //        }
        //
        //        else if tableView == payTableView {
        //            return paySum.count
        //        }
        //
        //        else if tableView == identityTable {
        //            return idRefundName.count
        //        }
        //
        //        else if tableView == custTable {
        //            if cust_exist {
        //                return 1
        //            }
        //            else {
        //                return 0
        //            }
        //        }
        
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableview {
            
            if isNoItem {
                
                let cell = tableview.dequeueReusableCell(withIdentifier: "itemLotteryCell", for: indexPath) as! InStoreProductLotteryCell
                
                let cart = cartItems[indexPath.row]
                
                cell.lotteryName.text = cart.note
                
                cell.lotteryPrice.text = "$\(String(format: "%.02f", roundOf(item: cart.inventory_price)))"
                
                return cell
            }
            
            else {
                
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
                
                
                cell.onePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.inventory_price)))"
                cell.itemQty.text = "\(cart.qty)x"
                
                if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" ||
                    cart.discount_amt == "-0.00" || cart.discount_amt == "-0.0" ||
                    cart.discount_amt == "0" || cart.discount_amt == "-0" ||
                    cart.discount_amt == "" || cart.discount_amt.contains("null") {
                    
                    cell.itemDiscount.text = ""
                    cell.itemDisPrice.text = ""
                }
                else {
                    
                    cell.itemDiscount.text = "Item Discount"
                    cell.itemDisPrice.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
                }
                
                if cart.adjust_price != "0.0" && cart.adjust_price != "0.00" &&
                    cart.adjust_price != "-0.0" && cart.adjust_price != "-0.00" &&
                    cart.adjust_price != "0" && cart.adjust_price != "-0"
                    && cart.adjust_price != "" && !cart.adjust_price.contains("null") {
                    var adj_price = cart.adjust_price
                    
                    if adj_price.hasPrefix("-") {
                        adj_price.removeFirst()
                        cell.itemDiscount.text = "Price Override (+$\(String(format: "%.02f", roundOf(item: adj_price))))"
                        cell.itemDisPrice.text = ""
                    }
                    else if adj_price.hasPrefix("+") {
                        adj_price.removeFirst()
                        cell.itemDiscount.text = "Price Override (-$\(String(format: "%.02f", roundOf(item: adj_price))))"
                        cell.itemDisPrice.text = ""
                    }
                    else {
                        cell.itemDiscount.text = "Price Override (+$\(String(format: "%.02f", roundOf(item: adj_price))))"
                        cell.itemDisPrice.text = ""
                    }
                }
                
                cell.totalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.inventory_price, qty: cart.qty, discount: cart.discount_amt)))"
                
                return cell
            }
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
            
            cell.payRefOnePrice.text = "$\(String(format: "%.02f", roundOf(item: cart.inventory_price)))"
            cell.payRefQty.text = "\(cart.refund_qty)x"
            
            if cart.discount_amt == "0.00" || cart.discount_amt == "0.0" ||
                cart.discount_amt == "-0.00" || cart.discount_amt == "-0.0" ||
                cart.discount_amt == "0" || cart.discount_amt == "-0" ||
                cart.discount_amt == "" || cart.discount_amt.contains("null") {
                
                cell.itemRefDiscountLbl.text = ""
                cell.itemRefDisValue.text = ""
            }
            else {
                
                cell.itemRefDiscountLbl.text = "Item Discount"
                cell.itemRefDisValue.text = "-$\(String(format: "%.02f", roundOf(item: cart.discount_amt)))"
            }
            
            cell.payRefTotalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.inventory_price, qty: cart.refund_qty, discount: cart.discount_amt)))"
            
            if cart.adjust_price != "0.0" && cart.adjust_price != "0.00" &&
                cart.adjust_price != "-0.0" && cart.adjust_price != "-0.00" &&
                cart.adjust_price != "0" && cart.adjust_price != "-0"
                && cart.adjust_price != "" && !cart.adjust_price.contains("null") {
                
                var adj_price = cart.adjust_price
                
                if adj_price.hasPrefix("-") {
                    adj_price.removeFirst()
                    cell.itemRefDiscountLbl.text = "Price Override (+$\(String(format: "%.02f", roundOf(item: adj_price))))"
                    cell.itemRefDisValue.text = ""
                }
                else if adj_price.hasPrefix("+") {
                    adj_price.removeFirst()
                    cell.itemRefDiscountLbl.text = "Price Override (-$\(String(format: "%.02f", roundOf(item: adj_price))))"
                    cell.itemRefDisValue.text = ""
                }
                else {
                    cell.itemRefDiscountLbl.text = "Price Override (+$\(String(format: "%.02f", roundOf(item: adj_price))))"
                    cell.itemRefDisValue.text = ""
                }
            }
            return cell
            
        }
        
        else if tableView == orderDetailTable {
            
            let cell = orderDetailTable.dequeueReusableCell(withIdentifier: "orderdetcell", for: indexPath) as! InStoreOrderSumCell
            
            cell.orderLbl.text = orderDetailLabel[indexPath.row]
            cell.orderLblValue.text = orderDetailValue[indexPath.row]
            
            return cell
            
        }
        
        else if tableView == grossTable {
            
            let cell = grossTable.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! InStoreOrderSumCell
            
            cell.orderLbl.text = "\(grossLabel[indexPath.row])"
            cell.orderLblValue.text = "-$\(String(format: "%.2f", roundOf(item: grossValue[indexPath.row])))"
            cell.orderLblValue.textColor = UIColor(hexString: "#E61F1F")
            
            if indexPath.row == 0 {
                
                let shapeLayer1 = CAShapeLayer()
                shapeLayer1.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer1.lineWidth = 1
                shapeLayer1.lineDashPattern = [4, 4]
                
                let path2 = CGMutablePath()
                path2.addLines(between: [CGPoint(x: 0, y: grossView.frame.maxY), CGPoint(x: grossView.frame.maxX, y: grossView.frame.maxY)])
                shapeLayer1.path = path2
                scroll.layer.addSublayer(shapeLayer1)
            }
            
            else if indexPath.row == grossLabel.count - 1 {
                
                let shapeLayer2 = CAShapeLayer()
                shapeLayer2.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer2.lineWidth = 1
                shapeLayer2.lineDashPattern = [4, 4]
                
                let path3 = CGMutablePath()
                path3.addLines(between: [CGPoint(x: 0, y: netView.frame.minY),
                                         CGPoint(x: netView.frame.maxX, y: netView.frame.minY)])
                shapeLayer2.path = path3
                scroll.layer.addSublayer(shapeLayer2)
            }
            
            return cell
        }
        
        else if tableView == taxTableView {
            
            let cell = taxTableView.dequeueReusableCell(withIdentifier: "taxcell", for: indexPath) as! InStoreTaxTableViewCell
            
            let tax = tax_table_array[indexPath.row]
            
            cell.taxName.text = tax.tax_name
            cell.taxpercent.text = "\(String(format: "%.3f", roundOf(item: "\(tax.tax_rate)")))%"
            cell.taxAmt.text = "$\(String(format: "%.2f", roundOf(item: "\(tax.tax_amount)")))"
            cell.salesTax.text = "$\(String(format: "%.2f", roundOf(item: "\(tax.sale_due)")))"
            
            if indexPath.row == tax_table_array.count - 1 {
                
                let shapeLayer3 = CAShapeLayer()
                shapeLayer3.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer3.lineWidth = 1
                shapeLayer3.lineDashPattern = [4, 4]
                
                let path4 = CGMutablePath()
                path4.addLines(between: [CGPoint(x: 0, y: totalTaxView.frame.minY),
                                         CGPoint(x: totalTaxView.bounds.maxX, y: totalTaxView.frame.minY)])
                shapeLayer3.path = path4
                scroll.layer.addSublayer(shapeLayer3)
                
                let shapeLayer4 = CAShapeLayer()
                shapeLayer4.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer4.lineWidth = 1
                shapeLayer4.lineDashPattern = [4, 4]
                
                let path5 = CGMutablePath()
                path5.addLines(between: [CGPoint(x: 0, y: totalTaxView.frame.maxY),
                                         CGPoint(x: totalTaxView.frame.maxX, y: totalTaxView.frame.maxY)])
                shapeLayer4.path = path5
                scroll.layer.addSublayer(shapeLayer4)
            }
            return cell
            
        }
        
        else if tableView == feeTable {
            
            let cell = feeTable.dequeueReusableCell(withIdentifier: "feecell", for: indexPath) as! InStorePayTableCell
            
            if feeSum[indexPath.row] == "Discounts" || feeSum[indexPath.row] == couponCode?.coupon_code {
                cell.payName.text = feeSum[indexPath.row]
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: (feeSumValue[indexPath.row]))))"
            }
            
            else {
                cell.payName.text = feeSum[indexPath.row]
                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: (feeSumValue[indexPath.row]))))"
            }
            
            if indexPath.row == feeSum.count - 1 {
                let shapeLayer5 = CAShapeLayer()
                shapeLayer5.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer5.lineWidth = 1
                shapeLayer5.lineDashPattern = [4, 4]
                
                let path6 = CGMutablePath()
                path6.addLines(between: [CGPoint(x: 0, y: totalFeeView.frame.minY),
                                         CGPoint(x: totalFeeView.frame.maxX, y: totalFeeView.frame.minY)])
                shapeLayer5.path = path6
                scroll.layer.addSublayer(shapeLayer5)
                
                let shapeLayer6 = CAShapeLayer()
                shapeLayer6.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer6.lineWidth = 1
                shapeLayer6.lineDashPattern = [4, 4]
                
                let path7 = CGMutablePath()
                path7.addLines(between: [CGPoint(x: 0, y: totalFeeView.frame.maxY),
                                         CGPoint(x: totalFeeView.frame.maxX, y: totalFeeView.frame.maxY)])
                shapeLayer6.path = path7
                scroll.layer.addSublayer(shapeLayer6)
            }
            
            return cell
        }
        
        else if tableView == tenderTable {
            
            let cell = tenderTable.dequeueReusableCell(withIdentifier: "paycell", for: indexPath) as! InStorePayTableCell
            
            let digit = tenderDigits[indexPath.row]
            
            if digit == "" {
                cell.payName.text = paySum[indexPath.row]
            }
            else {
                cell.payName.text = "\(paySum[indexPath.row]): \(digit)"
            }
            
            cell.payName.textColor = UIColor(hexString: "#707070")
            
            if paySum[indexPath.row] == "Points Applied" {
                cell.payValue.text = paySumValue[indexPath.row]
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if paySum[indexPath.row] == "Points Awarded" {
                cell.payValue.textColor = UIColor(red: 76.0/255.0, green: 188.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                cell.payValue.text = "\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
            }
            else if paySum[indexPath.row] == "Gift Card Applied" {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if paySum[indexPath.row] == "Lottery" || paySum[indexPath.row] == "Lottery Scratcher" {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
                //                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
            }
            
            let cb = tenderCashBack[indexPath.row]
            
            if cb != "" {
                cell.debitCashback.text = "+$\(cb) Cash Back"
            }
            else {
                cell.debitCashback.text = cb
            }
            
            let pax = tenderPax[indexPath.row]
            
            if pax != "" {
                cell.authCode.text = "Auth Code: \(pax)"
            }
            else {
                cell.authCode.text = ""
            }
            
            return cell
        }
        
        else if tableView == payRefundTable {
            
            let cell = payRefundTable.dequeueReusableCell(withIdentifier: "payrefundcell", for: indexPath) as! InStorePayTableCell
            
            let digit = refundPaxDigits[indexPath.section][indexPath.row]
            
            if digit == "" {
                cell.payName.text = payRefund[indexPath.section][indexPath.row]
            }
            else {
                cell.payName.text = "\(payRefund[indexPath.section][indexPath.row]): \(digit)"
            }
            
            cell.payValue.text = payRefundValues[indexPath.section][indexPath.row]
            cell.payTax.text = payRefundTax[indexPath.section][indexPath.row]
            
            let ordate  = ToastClass.sharedToast.setDateFormat(dateStr: payRefundDate[indexPath.section])
            cell.refundDate.text = ordate
            
            let pax = refundPaxAuth[indexPath.section][indexPath.row]
            
            if pax != "" {
                cell.authCode.text = "Auth Code: \(pax)"
            }
            else {
                cell.authCode.text = ""
            }
            
            if cell.payName.text == "Cash" {
                cell.tipNcaLbl.text = ""
                //                cell.aid.text = ""
            }
            else if cell.payName.text == "Credit Card" || cell.payName.text == "Debit Card" {
                cell.tipNcaLbl.text = "(Tip:- $\(payRefNcaTip[indexPath.section][indexPath.row].tipAmt) NCA:- $\(payRefNcaTip[indexPath.section][indexPath.row].ncaAmt))"
                //                cell.aid.text = "AID: 7878787878"
            }
            else {
                cell.tipNcaLbl.text = "(Tip:- $\(payRefNcaTip[indexPath.section][indexPath.row].tipAmt) NCA:- $\(payRefNcaTip[indexPath.section][indexPath.row].ncaAmt))"
                //                cell.aid.text = ""
            }
            
            
            
            let shapeLayer3 = CAShapeLayer()
            shapeLayer3.strokeColor = UIColor(hexString: "#707070").cgColor
            shapeLayer3.lineWidth = 1
            shapeLayer3.lineDashPattern = [4, 4]
            
            let path4 = CGMutablePath()
            path4.addLines(between: [CGPoint(x: 0, y: refundTotalView.frame.minY),
                                     CGPoint(x: refundTotalView.bounds.maxX, y: refundTotalView.frame.minY)])
            shapeLayer3.path = path4
            scroll.layer.addSublayer(shapeLayer3)
            
            let shapeLayer4 = CAShapeLayer()
            shapeLayer4.strokeColor = UIColor(hexString: "#707070").cgColor
            shapeLayer4.lineWidth = 1
            shapeLayer4.lineDashPattern = [4, 4]
            
            let path5 = CGMutablePath()
            path5.addLines(between: [CGPoint(x: 0, y: refundTotalView.frame.maxY),
                                     CGPoint(x: refundTotalView.bounds.maxX, y: refundTotalView.frame.maxY)])
            shapeLayer4.path = path5
            scroll.layer.addSublayer(shapeLayer4)
            
            
            return cell
            
        }
        
        else if tableView == loyalTableview {
            
            let cell = loyalTableview.dequeueReusableCell(withIdentifier: "loyalcell", for: indexPath) as! LoyaltyOrderTableViewCell
            
            if indexPath.row == loyalArray.count - 1 {
                let shapeLayer5 = CAShapeLayer()
                shapeLayer5.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer5.lineWidth = 1
                shapeLayer5.lineDashPattern = [4, 4]
                
                let path6 = CGMutablePath()
                path6.addLines(between: [CGPoint(x: loyaltyHeadView.frame.minX, y: loyaltyHeadView.frame.maxY),
                                         CGPoint(x: loyaltyHeadView.frame.maxX, y: loyaltyHeadView.frame.maxY)])
                shapeLayer5.path = path6
                scroll.layer.addSublayer(shapeLayer5)
            }
            
            if indexPath.row == 0 {
                cell.loyalLbael.text = "Awarded"
                cell.loyalPrice.textColor = UIColor(hexString: "#11C53B")
                cell.loyalPrice.text = "\(String(format: "%.2f", roundOf(item: loyalArray[indexPath.row].loyalty_points)))"
                
            }
            
            else {
                cell.loyalLbael.text = "Removed (Due to Refund \(indexPath.row))"
                cell.loyalPrice.textColor = UIColor(hexString: "#E61F1F")
                cell.loyalPrice.text = "-\(String(format: "%.2f", roundOf(item: loyalArray[indexPath.row].loyalty_points)))"
                
            }
            
            let ordDate = ToastClass.sharedToast.setDateFormat(dateStr:  loyalArray[indexPath.row].loyalty_date)
            print(ordDate)
            cell.loyalDate.text = ordDate
            // cell.loyalDate.text = loyalArray[indexPath.row].loyalty_date
            return cell
        }
        
        else if tableView == identityTable {
            let cell = identityTable.dequeueReusableCell(withIdentifier: "identitycell", for: indexPath) as! InStoreIdentityCell
            
            cell.payIdLbl.text = idRefundName[indexPath.row]
            cell.payIdValue.text = idRefundValue[indexPath.row]
            
            
            return cell
        }
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
        //            else if paySum[indexPath.row] == "Lottery Payout" || paySum[indexPath.row] == "Scratcher Payout" {
        //                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
        //                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        //            }
        //            else {
        //                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: paySumValue[indexPath.row])))"
        //            }
        //
        //            if paySum[indexPath.row] == "Credit Card" {
        //                cell.cardInfoBtn.isHidden = false
        //            }
        //            else {
        //                cell.cardInfoBtn.isHidden = true
        //            }
        //            return cell
        //        }
        //
        //        else if tableView == identityTable {
        //            let cell = identityTable.dequeueReusableCell(withIdentifier: "identitycell", for: indexPath) as! InStoreIdentityCell
        //
        //            cell.payIdLbl.text = idRefundName[indexPath.row]
        //            cell.payIdValue.text = idRefundValue[indexPath.row]
        //
        //            return cell
        //        }
        //
        //        else if tableView == custTable {
        //
        //            let cell = custTable.dequeueReusableCell(withIdentifier: "custdetail", for: indexPath) as! CustomerDetailsCell
        //
        //            cell.custName.text = custName
        //            cell.custAddr.text = custAddr
        //            cell.custphone.text = custNumber
        //            cell.custMail.text = custMail
        //
        //            if custAddr == "" {
        //                cell.custAddrBtnHeight.constant = 0
        //            }
        //            else {
        //                cell.custAddrBtnHeight.constant = 14
        //            }
        //
        //            cell.addrView.layer.cornerRadius = 10
        //            cell.addrView.layer.borderWidth = 1
        //            cell.addrView.layer.borderColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        //
        //
        //            return cell
        //
        //        }
        
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! InStoreOrderSumCell
            
            //            if orderSum[indexPath.row] == "Discounts" || orderSum[indexPath.row] == couponCode?.coupon_code {
            //                cell.orderLbl.text = orderSum[indexPath.row]
            //                cell.orderLblValue.text = "-$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
            //            }
            //            else {
            //                cell.orderLbl.text = orderSum[indexPath.row]
            //                cell.orderLblValue.text = "$\(String(format: "%.02f", roundOf(item: (orderSumValue[indexPath.row]))))"
            //            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        //
    //        //            if tableView == payRefundTable {
    //        //
    //        //                let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
    //        //                let label1 = UILabel(frame: CGRect(x: tableView.frame.size.width - 170, y: 0, width: tableView.frame.size.width - 65, height: 19))
    //        //                label1.text = payRefundDate[section]
    //        //                label1.font = UIFont(name: "Manrope-SemiBold", size: 15.0)
    //        //                label1.textColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    //        //                headerView.addSubview(label1)
    //        //
    //        //                let label = UILabel(frame: CGRect(x: 20, y: label1.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
    //        //                label.text = "Refund"
    //        //                label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
    //        //                headerView.addSubview(label)
    //        //
    //        //                let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
    //        //                grayview.backgroundColor = .black
    //        //                headerView.addSubview(grayview)
    //        //
    //        //                let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 60, height: 3))
    //        //                blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    //        //                headerView.addSubview(blueview)
    //        //
    //        //                return headerView
    //        //            }
    //
    ////        if tableView == identityTable {
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
    ////
    ////        else {
    ////            return nil
    ////        }
    //    }
    //    //
    //    //        else if tableView == custTable {
    //    //
    //    //            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
    //    //            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
    //    //
    //    //            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
    //    //            label.text = "Customer Details"
    //    //            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
    //    //            headerView.addSubview(label)
    //    //
    //    //            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
    //    //            grayview.backgroundColor = .black
    //    //            headerView.addSubview(grayview)
    //    //
    //    //            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 120, height: 3))
    //    //            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    //    //            headerView.addSubview(blueview)
    //    //
    //    //            return headerView
    //    //        }
    //    //
    //    //        else if tableView == identityTable {
    //    //
    //    //            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
    //    //            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
    //    //
    //    //            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
    //    //            label.text = "Identification Details"
    //    //            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
    //    //            headerView.addSubview(label)
    //    //
    //    //            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
    //    //            grayview.backgroundColor = .black
    //    //            headerView.addSubview(grayview)
    //    //
    //    //            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 120, height: 3))
    //    //            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    //    //            headerView.addSubview(blueview)
    //    //
    //    //            return headerView
    //    //        }
    //    //
    ////            else {
    ////
    ////                return nil
    ////            }
    //       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableview || tableView == payRefundItemsTable {
            
            if tableView == tableview {
                
                if isNoItem {
                    return UITableView.automaticDimension
                }
                else {
                    return 130
                }
            }
            else {
                return 130
            }
        }
        
        else if tableView == payRefundTable {
            let doub = roundOf(item: payRefundHeight[indexPath.section][indexPath.row])
            return CGFloat(doub)
        }
        
        else if tableView == tenderTable {
            let doub = roundOf(item: tenderHeight[indexPath.row])
            return CGFloat(doub)
        }
        
        
        
        else {
            return UITableView.automaticDimension
        }
    }
}
