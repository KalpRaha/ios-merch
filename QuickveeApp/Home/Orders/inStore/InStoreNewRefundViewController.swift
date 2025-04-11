//
//  InStoreNewRefundViewController.swift
//
//
//  Created by Jamaluddin Syed on 03/12/24.
//

import UIKit

class InStoreNewRefundViewController: UIViewController {
    
    @IBOutlet weak var refundItemsTable: UITableView!
    @IBOutlet weak var refundOrderDetailTable: UITableView!
    @IBOutlet weak var refundGrossTable: UITableView!
    @IBOutlet weak var refundTaxesTable: UITableView!
    @IBOutlet weak var refundPartialTable: UITableView!
    @IBOutlet weak var refundFeeTable: UITableView!
    @IBOutlet weak var refundTenderTable: UITableView!
    @IBOutlet weak var refundTable: UITableView!
    @IBOutlet weak var refundLoyalTable: UITableView!
    @IBOutlet weak var refundLoyalTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundCustTable: UITableView!
    
    @IBOutlet weak var custDetails: UILabel!
    @IBOutlet weak var blueidentity: UIView!
    @IBOutlet weak var underidentity: UIView!
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var dotView: UIView!
    
    @IBOutlet weak var grossView: UIView!
    @IBOutlet weak var netView: UIView!
    
    @IBOutlet weak var grossValue: UILabel!
    
    @IBOutlet weak var refundTotalValue: UILabel!
    @IBOutlet weak var refTaxTotalValue: UILabel!
    
    @IBOutlet weak var refundTotalTaxView: UIView!
    
    @IBOutlet weak var totalPayAmt: UILabel!
    
    @IBOutlet weak var netValue: UILabel!
    
    @IBOutlet weak var refundTotalView: UIView!
    
    @IBOutlet weak var grandTotalValue: UILabel!
    @IBOutlet weak var afterRefundPrice: UILabel!
    
    @IBOutlet weak var refTotalTax: UILabel!
    
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var feeTotalView: UIView!
    @IBOutlet weak var totalFeeValue: UILabel!
    
    @IBOutlet weak var feeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalFeeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundItemHeight: NSLayoutConstraint!
    @IBOutlet weak var refundOrderTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundTaxTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundGrossTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundTenerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundFeeTableHeight: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var refundPartialTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var refundIdentityTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollRefHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loyalHeaderView: UIView!
    
    @IBOutlet weak var loyalHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loyalTotalView: UIView!
    @IBOutlet weak var totalLoyalLbl: UILabel!
    @IBOutlet weak var totalLoyalValue: UILabel!
    
    @IBOutlet weak var totalLoyalHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var scroll: UIView!
    
    @IBOutlet weak var refchangeDue: UILabel!
    
    
    @IBOutlet weak var instoreView: UIView!
    @IBOutlet weak var instoreLbl: UILabel!
    
    @IBOutlet weak var instoreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instoreRefundViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dotViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var grossViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var netviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var taxesHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totatTaxViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tenderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totaltenderviewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var refundHeaderHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var refundTotalHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var blueLoyalty: UIView!
    
    @IBOutlet weak var loyaltyPointsLbl: UILabel!
    var detailRefund = [[String:Any]]()
    
    var splitDetailRefund = [Split_Data]()
    
    //    var pax_details = ""
    var tenderHeight = [String]()
    
    var refund_order_id = ""
    
    var cartrefItemsRefund = [Cart_Data]()
    var cartparrefItemsRefund = [Cart_Data]()
    var loyalArray = [Loyalty]()
    
    var orderDetailRefund: OrderDetails?
    
    var refund_id_exist = false
    
    var isLottery = "0"
    var isScratcher = "0"
    
    //    var refundTableArray = [RefundTableDetails]()
    
    var refund_tax_table_array = [Tax_Order_Summary]()
    
    var orderDetailRefundLabel = [String]()
    var orderDetailRefundValue = [String]()
    
    var grossRefundLabel = [String]()
    var grossRefundValue = [String]()
    
    var feeRefundSum = [String]()
    var feeRefundSumValue = [String]()
    
    var payRefundSum = [String]()
    var payRefundSumValue = [String]()
    
    var payRefund = [[String]]()
    var payRefundValues = [[String]]()
    var payRefundDate = [String]()
    var payRefundTax = [[String]]()
    
    var payRefNcaTip = [[TipNca]]()
    var payRefundHeight = [[String]]()
    
    var idRefundName = [String]()
    var idRefundValue = [String]()
    
    var tenderCashBack = [String]()
    var tenderPax = [String]()
    var tenderDigits = [String]()
    var refundPaxAuth = [[String]]()
    var refundPaxDigits = [[String]]()
    var couponCode: CouponCode?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var idDetailRefund: IdentificationDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        topview.addBottomShadow()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        refundItemsTable.estimatedSectionHeaderHeight = 0
        refundItemsTable.estimatedSectionFooterHeight = 0
        refundOrderDetailTable.estimatedSectionHeaderHeight = 0
        refundOrderDetailTable.estimatedSectionFooterHeight = 0
        refundTaxesTable.estimatedSectionHeaderHeight = 0
        refundTaxesTable.estimatedSectionFooterHeight = 0
        refundFeeTable.estimatedSectionHeaderHeight = 0
        refundFeeTable.estimatedSectionFooterHeight = 0
        refundTable.estimatedSectionHeaderHeight = 0
        refundTable.estimatedSectionFooterHeight = 0
        
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
        
        //      setRefCustData()
        
        //        if self.refcust_exists {
        //            let height = custRefundTable.contentSize.height
        //            custrefheigh.constant = height + 64
        //        }
        //        else {
        //            self.custrefheigh.constant = 0
        //        }
        //
        //        if responsevalues["id_card_detail"] == nil {
        //            refund_id_exist = false
        //        }
        //        else {
        //
        //            setRefIdData(id: responsevalues["id_card_detail"])
        //        }
        
        
        DispatchQueue.main.async {
            
            self.refundItemsTable.reloadData()
            self.refundPartialTable.reloadData()
            self.refundOrderDetailTable.reloadData()
            self.refundGrossTable.reloadData()
            self.refundTaxesTable.reloadData()
            self.refundFeeTable.reloadData()
            self.refundTenderTable.reloadData()
            self.refundTable.reloadData()
            self.refundLoyalTable.reloadData()
            self.refundCustTable.reloadData()
            //
            self.refundItemHeight.constant = 130 * CGFloat(self.cartrefItemsRefund.count)
            self.refundPartialTableHeight.constant = 130 * CGFloat(self.cartparrefItemsRefund.count)
            self.refundOrderTableHeight.constant = 41.67 * CGFloat(self.orderDetailRefundLabel.count)
            self.refundTaxTableHeight.constant = 75.67 * CGFloat(self.refund_tax_table_array.count)
            self.refundFeeTableHeight.constant = 42 * CGFloat(self.feeRefundSum.count)
            self.refundGrossTableHeight.constant = 42 * CGFloat(self.grossRefundLabel.count)
            self.refundTenerTableHeight.constant = self.getTenderHeight()
            self.refundTableHeight.constant = self.getRefCountForHeight()
            self.refundLoyalTableHeight.constant = 75.67 * CGFloat(self.loyalArray.count)
            //
            //            if self.refcust_exists {
            //                let height = self.custRefundTable.contentSize.height
            //                self.custrefheigh.constant = height + 64
            //            }
            //            else {
            //                self.custrefheigh.constant = 0
            //            }
            //
            if self.refund_id_exist {
                self.refundIdentityTableHeight.constant = 39.33 * CGFloat(self.idRefundName.count) + 64
            }
            else {
                self.refundIdentityTableHeight.constant = 0
                self.custDetails.isHidden = true
                self.blueidentity.isHidden = true
                self.underidentity.isHidden = true
            }
            
            let refCartHeight = self.refundItemHeight.constant
            let parrefCartHeight = self.refundPartialTableHeight.constant
            let orderHeight = self.refundOrderTableHeight.constant
            let taxHeight = self.refundTaxTableHeight.constant
            let feeHeight = self.refundFeeTableHeight.constant
            let grossHeight = self.refundGrossTableHeight.constant
            let tenderHeight = self.refundTenerTableHeight.constant
            let refundHeight = self.refundTableHeight.constant
            let idHeight = self.refundIdentityTableHeight.constant
            let loyalHeight = self.refundLoyalTableHeight.constant
            
            let instoreview = self.instoreViewHeight.constant
            let instoreRefundview = self.instoreRefundViewHeight.constant
            let dotviewheight = self.dotViewHeight.constant
            let grossviewheight = self.grossViewHeight.constant
            let netviewHeight = self.netviewheight.constant
            let totalTaxViewHeight = self.totatTaxViewHeight.constant
            let taxheaderheight = self.taxesHeaderHeight.constant
            let feeViewHeight = self.feeViewHeight.constant
            let totalFeeViewHeight = self.totalFeeHeight.constant
            let tenderViewHeight = self.tenderViewHeight.constant
            let totalTenderViewHeight = self.totaltenderviewHeight.constant
            let refundHeaderViewHeight = self.refundHeaderHeight.constant
            let refundtotalheight =  self.refundTotalHeight.constant
            
            
            let ref_cal = refCartHeight + parrefCartHeight + orderHeight + taxHeight
            + grossHeight + feeHeight + refundHeight + tenderHeight + idHeight + loyalHeight +
            instoreview + instoreRefundview + dotviewheight + grossviewheight + netviewHeight +
            totalTaxViewHeight + taxheaderheight + feeViewHeight + totalFeeViewHeight +
            tenderViewHeight + totalTenderViewHeight + refundHeaderViewHeight + refundtotalheight + 404
            
            self.scrollRefHeight.constant = ref_cal
            
            self.loadingIndicator.isAnimating = false
            self.scroll.isHidden = false
            
            self.dashedLine()
        }
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
        
        orderDetailRefund = order
        
        let order_id = orderDetailRefund?.order_id ?? ""
        let order_number = orderDetailRefund?.order_number ?? ""
        
        orderDetailRefundLabel.append("Order Id")
        orderDetailRefundValue.append(order_id)
        
        if UserDefaults.standard.bool(forKey: "order_number_enable") {
            orderDetailRefundLabel.append("Order Number")
            orderDetailRefundValue.append(order_number)
        }
        
        let formattedDate = ToastClass.sharedToast.setDateFormat(dateStr: orderDetailRefund?.date_time ?? "")
        
        
        print(formattedDate)
        let dateTime = formattedDate
        
        let dateComponents = dateTime.split(separator: " ")
        print(dateComponents)
        
        let date = String(dateComponents[0])
        let time = String(dateComponents[1])
        let timeaa = String(dateComponents[2])
        
        
        
        //        let order_date = orderDetailRefund?.date_time ?? ""
        //        let date = order_date.components(separatedBy: " ")[0]
        //        let time = order_date.components(separatedBy: " ")[1]
        //       // let timeaaa = order_date.components(separatedBy: " ")[2]
        
        
        
        orderDetailRefundLabel.append("Date")
        orderDetailRefundValue.append(date)
        
        orderDetailRefundLabel.append("Time")
        orderDetailRefundValue.append("\(time) \(timeaa)")
        
        let tax = orderDetailRefund?.tax ?? "0.00"
        
        let tax_rate = orderDetailRefund?.tax_rate ?? "0.00"
        
        let other_taxes = orderDetailRefund?.other_taxes_desc ?? ""
        
        let other_tax = convertStringToDictionary(text: other_taxes)
        
        let other_taxes_rate = orderDetailRefund?.other_taxes_rate_desc ?? ""
        
        let other_tax_rate = convertStringToDictionary(text: other_taxes_rate)
        
        
        print(other_tax)
        
        var tname = [String]()
        var tprice = [String]()
        var trate = [String]()
        
        tname.append("DefaultTax")
        tprice.append(tax)
        
        for (key, value) in other_tax {
            
            tname.append(key)
            tprice.append("\(value)")
        }
        trate.append(tax_rate)
        
        for name in tname {
            
            if other_tax_rate.keys.contains(name) {
                
                if name == "DefaultTax" {
                }
                else {
                    trate.append(other_tax_rate[name] as! String)
                }
            }
            else {
                
            }
        }
        
        for (_,val) in other_tax_rate {
            print(val)
            trate.append("\(val)")
        }
        
        var add = 0.00
        
        for price in tprice {
            
            let price_double = Double(price) ?? 0.00
            add += price_double
        }
        
        refTaxTotalValue.text = "$\(String(format: "%.2f", roundOf(item: "\(add)")))"
        
        let cash_back_amt = orderDetailRefund?.cash_back_amt ?? "0.00"
        let cash_back_fee = orderDetailRefund?.cash_back_fee ?? "0.00"
        
        let coupon = orderDetailRefund?.coupon_code ?? ""
        let coupon_dict = convertStringToDictionary(text: coupon)
        
        couponCode = CouponCode(coupon_code: "\(coupon_dict["coupon_code"] ?? "")",
                                coupon_code_amt: "\(coupon_dict["coupon_code_amt"] ?? "")",
                                bogo_discount: "\(coupon_dict["bogo_discount"] ?? "")",
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
        let subtotal = orderDetailRefund?.subtotal ?? "0.00"
        let ref_amt = orderDetailRefund?.refund_amount ?? "0.00"
        
        
        //       customerOweValue.text = "$0.00"
        
        let split = orderDetailRefund?.is_split_payment ?? ""
        let payment_id = orderDetailRefund?.payment_id ?? ""
        let card_type = orderDetailRefund?.card_type ?? ""
        
        
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
        
        let bogo_discount = couponCode?.bogo_discount ?? "0.00"
        
        var points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let points_amt_earned = couponCode?.loyalty_point_amt_earned ?? "0.00"
        
        let points_amt_spent = couponCode?.loyalty_point_amt_spent ?? "0.00"
        let points_applied = couponCode?.loyalty_point_spent ?? "0.00"
        
        let store_credit = couponCode?.store_credit_amt_spent ?? "0.00"
        let gift_card_amount = couponCode?.gift_card_amount ?? "0.00"
        
        let nca_title = couponCode?.surcharge_label ?? ""
        
        let total_lottery_pay = couponCode?.lottery_order_pay ?? "0.00"
        
        if total_lottery_pay != "0.0" && total_lottery_pay != "0.00" && total_lottery_pay != "-0.0" &&
            total_lottery_pay != "-0.00" && total_lottery_pay != "0" && total_lottery_pay != "" &&
            handleZero(value: total_lottery_pay) {
            
            isLottery = "1"
        }
        else {
            isLottery = "0"
        }
        
        let total_scratcher_payout = couponCode?.total_scratcher_payout ?? "0.00"
        
        
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
        
        orderDetailRefundLabel.append("Employee Name")
        let name = couponCode?.employee_name ?? ""
        orderDetailRefundValue.append(name)
        
        //        let ref_amtgrand = calculateRefAmt(amt: amt, ref_amt: ref_amt)
        //        let total_ref = roundRefOf(item: ref_amtgrand) + roundRefOf(item: cash_back_amt) + roundRefOf(item: cash_back_fee)
        //        grossValue.text = "$\(String(format: "%.02f", roundRefOf(item: "\(total_ref)")))"
        //        let total_ref = roundRefOf(item: ref_amt)
        let total_ref = subtotal
        grossValue.text = "$\(String(format: "%.02f", roundRefOf(item: "\(subtotal)")))"
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent)  {
            grossRefundLabel.append("Loyalty Points Redeemed(\(String(format: "%.02f", roundOf(item: points_applied))))")
            grossRefundValue.append(String(format: "%.02f", roundOf(item: points_amt_spent)))
        }
        
        else {
            grossRefundLabel.append("Loyalty Points Redeemed(\(points_applied))")
            grossRefundValue.append("0.00")
        }
        
        if coupon_code_amt != "0.0" && coupon_code_amt != "0.00" && coupon_code_amt != "-0.00"
            && coupon_code_amt != "-0.0" && coupon_code_amt != "0" && coupon_code_amt != ""  {
            
            if bogo_discount != "0.0" && bogo_discount != "0.00" && bogo_discount != "-0.00"
                && bogo_discount != "-0.0" && bogo_discount != "0" && bogo_discount != ""  {
                
                let doub_coupon_amt = Double(coupon_code_amt) ?? 0.00
                let doub_bogo_discount = Double(bogo_discount) ?? 0.00
                
                let total = doub_coupon_amt + doub_bogo_discount
                
                grossRefundLabel.append("Discounts")
                grossRefundValue.append("\(total)")
            }
            
            else {
                grossRefundLabel.append("Discounts")
                grossRefundValue.append(coupon_code_amt)
            }
        }
        else {
            
            if bogo_discount != "0.0" && bogo_discount != "0.00" && bogo_discount != "-0.00"
                && bogo_discount != "-0.0" && bogo_discount != "0" && bogo_discount != ""  {
                
                grossRefundLabel.append("Discounts")
                grossRefundValue.append(bogo_discount)
            }
            
            else {
                grossRefundLabel.append("Discounts")
                grossRefundValue.append("0.00")
            }
        }
        
        
        if total_ref == "0.00" {
            netValue.text = "$\(String(format: "%.02f", roundRefOf(item: "\(total_ref)")))"
        }
        else {
            netValue.text = "$\(String(format: "%.02f", roundOf(item: "\(calculateTotalNetSales(values: grossRefundValue))")))"
        }
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00"
            && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
            if points_earned.hasPrefix("-") {
                points_earned.removeFirst()
            }
            print(points_earned)
            
            
            loyalArray.append(Loyalty(loyalty_points: points_earned, loyalty_date: order.date_time))
            
            if order.is_refunded == "0" {
                totalLoyalValue.text = points_earned
            }
        }
        else {
            
            
            
        }
        
        //fee table
        
        var smallFeeSum = [String]()
        var smallFeeSumValue = [String]()
        
        var cash_discount = ""
        
        if orderDetailRefund?.is_refunded == "1" {
            cash_discount = orderDetailRefund?.cashdiscount_refund_amount ?? ""
        }
        else {
            cash_discount = orderDetailRefund?.cash_discounting ?? ""
        }
        
        let cash_per = orderDetailRefund?.cash_discounting_percentage ?? ""
        let cash_dis_ref_amt = orderDetailRefund?.cashdiscount_refund_amount ?? ""
        
        
        if cash_discount != "0.0" && cash_discount != "0.00" && cash_discount != "-0.00" && cash_discount != "-0.0"
            && cash_discount != "0" && cash_discount != "" {
            
            if split == "1" {
                
                var debit_count = 0
                var credit_count = 0
                var small_debit = [String]()
                var small_credit = [String]()
                
                for split_pay in splitDetailRefund {
                    
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
                
                for split_pay in splitDetailRefund {
                    
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
                    
                    debit_card = calculateRefSplitCard(card: debit_amt)
                }
                
                if small_credit.count != 0 {
                    
                    credit_card = calculateRefSplitCash(cash: credit_amt)
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
                for split_pay in splitDetailRefund {
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
                for split_pay in splitDetailRefund {
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
                    debit_card = calculateRefSplitCard(card: debit_amt)
                }
                if small_credit.count != 0 {
                    credit_card = calculateRefSplitCash(cash: credit_amt)
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
                let total = cash_dis_ref_amt_doub
                smallFeeSum.append("Non Cash Adjustment for DEBIT(\(String(format: "%.02f", roundOf(item: cash_per)))%)")
                smallFeeSumValue.append("\(total)")
            }
            else if card_type.contains("Credit") || card_type.contains("credit") {
                let total = cash_dis_ref_amt_doub
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
        
        var tip = orderDetailRefund?.tip ?? ""
        
        if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
            smallFeeSum.append("Tip")
            smallFeeSumValue.append("\(tip)")
        }
        else {
            tip = orderDetailRefund?.tip_refund_amount ?? ""
            if tip != "0.0" && tip != "0.00" && tip != "-0.00" && tip != "-0.0" && tip != "0" && tip != "" && handleZero(value: tip) {
                smallFeeSum.append("Tip")
                smallFeeSumValue.append("\(tip)")
            }
        }
        
        if smallFeeSumValue.count == 0 {
            
            feeView.isHidden = true
            feeTotalView.isHidden = true
            feeViewHeight.constant = 0
            totalFeeHeight.constant = 0
        }
        else {
            
            feeView.isHidden = false
            feeTotalView.isHidden = false
            feeViewHeight.constant = 40.67
            totalFeeHeight.constant = 44.67
            
            let value = calculateTotalTender(amt: smallFeeSumValue)
            totalFeeValue.text = "$\(String(format: "%.2f", roundOf(item: value)))"
        }
        //        grandTotalValue.text = "$\(calculateGrandTotal())"
        //
        feeRefundSum = smallFeeSum
        feeRefundSumValue = smallFeeSumValue
        
        // tender table
        
        var smallPaySum = [String]()
        var smallPaySumValue = [String]()
        var smallPax = [String]()
        var smallcashback = [String]()
        var smallDigits = [String]()
        
        //        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" && points_amt_spent != "-0.00"
        //            && points_amt_spent != "0" && points_amt_spent != "" && handleZero(value: points_amt_spent) {
        //            smallPaySum.append("Points Applied")
        //            smallPaySumValue.append("(-\(points_applied))-$\(roundRefOf(item: points_amt_spent))")
        //        }
        
        if gift_card_amount != "0.0" && gift_card_amount != "0.00" && gift_card_amount != "-0.0" &&
            gift_card_amount != "-0.00" && gift_card_amount != "0" && gift_card_amount != "" && handleZero(value: gift_card_amount)  {
            smallPaySum.append("Gift Card Applied")
            smallPaySumValue.append("\(String(format: "%.02f", roundRefOf(item: gift_card_amount)))")
            smallcashback.append("")
            smallPax.append("")
            smallDigits.append("")
        }
        
        if total_lottery_pay != "0.0" && total_lottery_pay != "0.00" && total_lottery_pay != "-0.0" &&
            total_lottery_pay != "-0.00" && total_lottery_pay != "0" && total_lottery_pay != "" && handleZero(value: total_lottery_pay) {
            smallPaySum.append("Lottery")
            smallPaySumValue.append("\(String(format: "%.02f", roundOf(item: total_lottery_pay)))")
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
        
        let isloyal = orderDetailRefund?.is_loyality ?? "0"
        let iscredit = orderDetailRefund?.is_store_credit ?? "0"
        let isgift = orderDetailRefund?.is_gift_card ?? "0"
        
        if split == "1"  {
            
            
            //            var card_count = 0
            //            var cash_count = 0
            //            var food_count = 0
            //            var ecash_count = 0
            
            //  var small_card_cash = [String]()
            for split_way in splitDetailRefund {
                
                if split_way.pay_type == "credit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        //  if food_count != 1 {
                        //       small_card_cash.append("Food EBT")
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
                        
                        //     food_count = 1
                        //   }
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        //  if ecash_count != 1 {
                        //      small_card_cash.append("Cash EBT")
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
                        //       ecash_count = 1
                        //  }
                    }
                    
                    else {
                        //  if card_count != 1 {
                        //    small_card_cash.append("Credit Card")
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
                        //    card_count = 1
                        //  }
                    }
                }
                else if split_way.pay_type == "debit" {
                    
                    if split_way.card_type.contains("FoodEbt") {
                        //  if food_count != 1 {
                        //     small_card_cash.append("Food EBT")
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
                        //     food_count = 1
                        //  }
                    }
                    
                    else if split_way.card_type.contains("CashEbt") {
                        //  if ecash_count != 1 {
                        //      small_card_cash.append("Cash EBT")
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
                        //      ecash_count = 1
                        //  }
                    }
                    
                    else {
                        //  if card_count != 1 {
                        //      small_card_cash.append("Credit Card")
                        smallPaySum.append("Debit Card")
                        let pay = split_way.pay_amount
                        let cashback = split_way.cash_back_amt
                        let cashback_fee = split_way.cash_back_fee
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append("\(sum)")
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
                        //      card_count = 1
                        //  }
                    }
                }
                else {
                    // if cash_count != 1 {
                    //     small_card_cash.append("Cash")
                    smallPaySum.append("Cash")
                    smallPaySumValue.append(split_way.pay_amount)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    //     cash_count = 1
                    //  }
                }
            }
            
            //            var small_card = [String]()
            //            var small_cash = [String]()
            //            var small_food = [String]()
            //            var small_ecash = [String]()
            
            //            for split_way_info in splitDetailRefund {
            //
            //                if split_way_info.pay_type == "credit" {
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
            //                      //  small_ecash.append(split_way_info.pay_amount)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //
            //                    else {
            //                        let pay = calSplitRefTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
            //                       // small_card.append(pay)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //                }
            //
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
            //                        let pay = calSplitRefTipCard(amt: split_way_info.pay_amount, tip: split_way_info.tip)
            //                       // small_card.append(pay)
            //                        let pax = split_way_info.pax_details
            //                        if pax != "" {
            //                            pax_details += "\n\n\(pax)"
            //                        }
            //                    }
            //                }
            //
            //                else  {
            //                   // small_cash.append(split_way_info.pay_amount)
            //                }
            //            }
            
            //            var card = Double()
            //            var cash = Double()
            //            var food = Double()
            //            var ecash = Double()
            //
            //            if small_card.count != 0 {
            //                card = calculateRefSplitCard(card: small_card)
            //            }
            //
            //            if small_cash.count != 0 {
            //                cash = calculateRefSplitCash(cash: small_cash)
            //            }
            //
            //            if small_food.count != 0 {
            //                food = calculateSplitRefEbt(cash: small_food)
            //            }
            //
            //            if small_ecash.count != 0 {
            //                ecash = calculateSplitRefEbt(cash: small_ecash)
            //            }
            //
            //            for small in small_card_cash {
            //
            //                if small == "Cash" {
            //                    smallPaySumValue.append(String(format: "%.02f", cash))
            //                }
            //                else if small == "Food EBT" {
            //                    smallPaySumValue.append(String(format: "%.02f", food))
            //                }
            //                else if small == "Cash EBT" {
            //                    smallPaySumValue.append(String(format: "%.02f", ecash))
            //                }
            //                else {
            //                    smallPaySumValue.append(String(format: "%.02f", card))
            //                }
            //            }
        }
        
        else if isloyal == "2" || iscredit == "2" || isgift == "2"
                    ||  isloyal == "1" || iscredit == "1" || isgift == "1" || isLottery == "1" || isScratcher == "1" {
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" && isLottery == "1" && isScratcher == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt) -
                                          roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay)
                                          - roundRefOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay)
                                              - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay)
                                              - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay)
                                              - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay)
                                              - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
            
            if isloyal == "1" && iscredit == "1" && isgift == "1" && isLottery == "1" {
                
                if payment_id == "Cash" {
                    let cred_amt = String(roundRefOf(item: amt) -
                                          roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) -
                                          roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallPaySumValue.append(String(format: "%.02f", roundOf(item: cred_amt)))
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                    }
                    
                    else if card_type.contains("Debit") {
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: iscredit) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                    
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: iscredit) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: iscredit) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: iscredit) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: iscredit) - roundRefOf(item: total_lottery_pay) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                        
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                        
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) - roundRefOf(item: total_lottery_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                        
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: total_lottery_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: total_lottery_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit) -  roundRefOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                        
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: store_credit)  - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay) -  roundRefOf(item: scratch_order_pay))
                    if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                        cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                        smallPaySum.append("Cash")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        smallPax.append("")
                        smallDigits.append("")
                        
                    }
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay)  - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay)  - roundRefOf(item: scratch_order_pay))
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay)  - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            let pay = cred_amt
                            let cashback = orderDetailRefund?.cash_back_amt ?? ""
                            let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                            
                            let pay_doub = Double(pay) ?? 0.00
                            let cashback_doub = Double(cashback) ?? 0.00
                            let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                            let sum = pay_doub + cashback_doub + cashback_fee_doub
                            smallPaySumValue.append("\(sum)")
                            smallPaySum.append("Debit Card")
                            //                            smallPaySumValue.append(cred_amt)
                            smallcashback.append(cash_back_amt)
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                        
                        let cred_amt = String(roundRefOf(item: amt) - roundRefOf(item: total_lottery_pay)  - roundRefOf(item: scratch_order_pay))
                        
                        if cred_amt != "0.0" && cred_amt != "0.00" && cred_amt != "-0.0" &&
                            cred_amt != "-0.00" && cred_amt != "0" && cred_amt != "" {
                            smallPaySum.append("Credit Card")
                            smallPaySumValue.append(cred_amt)
                            smallcashback.append("")
                            
                            let det = orderDetailRefund?.pax_details ?? ""
                            
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
                    let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                    let cred_amt = calculateRefDiscount(amt: "\(amt_price)" , discount: points_amt_spent)
                    smallPaySumValue.append(cred_amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let amt_price = roundRefOf(item: amt) + roundRefOf(item: points_amt_spent)
                        let cred_amt = calculateRefDiscount(amt: "\(amt_price)", discount: points_amt_spent)
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                    let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                    smallPaySumValue.append(cred_amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: store_credit)
                        
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append("")
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                    smallPaySumValue.append(amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cashback = orderDetailRefund?.cash_back_amt ?? ""
                        let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append("\(sum)")
                        //let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        //smallPaySumValue.append(amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: gift_card_amount)
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                    smallPaySumValue.append(calculateRefDiscount(amt: amt, discount: total_lottery_pay))
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: total_lottery_pay)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: total_lottery_pay)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cashback = orderDetailRefund?.cash_back_amt ?? ""
                        let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        
                        let cred_amt = calculateRefDiscount(amt: "\(sum)", discount: total_lottery_pay)
                        smallPaySumValue.append(cred_amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: total_lottery_pay)
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                    smallPaySumValue.append(calculateRefDiscount(amt: amt, discount: scratch_order_pay))
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                }
                else {
                    
                    if card_type.contains("CashEbt") {
                        let cred_amt = calculateRefDiscount(amt: amt, discount: scratch_order_pay)
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: scratch_order_pay)
                        smallPaySum.append("Food EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cashback = orderDetailRefund?.cash_back_amt ?? ""
                        let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append("\(sum)")
                        //let cred_amt = calculateRefDiscount(amt: amt, discount: scratch_order_pay)
                        //                        smallPaySumValue.append(amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let cred_amt = calculateRefDiscount(amt: amt, discount: scratch_order_pay)
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                    smallPaySum.append("Cash")
                    smallPaySumValue.append(amt)
                    smallcashback.append("")
                    smallPax.append("")
                    smallDigits.append("")
                    
                }
            }
            else {
                
                if card_type.contains("CashEbt") {
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Cash EBT")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                        let pay = amt
                        let cashback = orderDetailRefund?.cash_back_amt ?? ""
                        let cashback_fee = orderDetailRefund?.cash_back_fee ?? ""
                        
                        let pay_doub = Double(pay) ?? 0.00
                        let cashback_doub = Double(cashback) ?? 0.00
                        let cashback_fee_doub = Double(cashback_fee) ?? 0.00
                        let sum = pay_doub + cashback_doub + cashback_fee_doub
                        smallPaySumValue.append("\(sum)")
                        smallPaySum.append("Debit Card")
                        //                        smallPaySumValue.append(amt)
                        smallcashback.append(cash_back_amt)
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
                    
                    if amt != "0.0" && amt != "0.00" && amt != "-0.00" && amt != "-0.0" && amt != "0" && amt != "" {
                        smallPaySum.append("Credit Card")
                        smallPaySumValue.append(amt)
                        smallcashback.append("")
                        
                        let det = orderDetailRefund?.pax_details ?? ""
                        
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
        
        
        //        if cash_back_amt != "0.0" && cash_back_amt != "0.00" && cash_back_amt != "-0.0" && cash_back_amt != "-0.00" && cash_back_amt != "0"
        //            && cash_back_amt != "" && handleZero(value: cash_back_amt) {
        //            smallPaySum.append("Cashback Amount")
        //            smallPaySumValue.append(cash_back_amt)
        //        }
        //
        //
        //        if cash_back_fee != "0.0" && cash_back_fee != "0.00" && cash_back_fee != "-0.0" && cash_back_fee != "-0.00" && cash_back_fee != "0" && cash_back_fee != "" && handleZero(value: cash_back_fee) {
        //            smallPaySum.append("Cashback Fee")
        //            smallPaySumValue.append(cash_back_fee)
        //        }
        
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" && store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(value: store_credit) {
            smallPaySum.append("Store Credit")
            smallPaySumValue.append(store_credit)
            smallcashback.append("")
            smallPax.append("")
            smallDigits.append("")
        }
        
        //        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" && points_earned != "-0.00" && points_earned != "0" && points_earned != "" && handleZero(value: points_earned) {
        //            smallPaySum.append("Points Awarded")
        //            smallPaySumValue.append(points_earned)
        //        }
        
        calculateHeightForTender(pay: smallPaySum)
        payRefundSum = smallPaySum
        payRefundSumValue = smallPaySumValue
        tenderCashBack = smallcashback
        tenderPax = smallPax
        tenderDigits = smallDigits
        let value = calculateTotalTender(amt: smallPaySumValue)
        totalPayAmt.text = "$\(String(format: "%.2f", roundOf(item: value)))"
        
        let change = orderDetailRefund?.change_due ?? "0.00"
        refchangeDue.text = "$\(String(format: "%.2f", roundOf(item: change)))"
        
        var smallName = [String]()
        var smallValue = [String]()
        
        let delivery_name = orderDetailRefund?.deliver_name ?? ""
        let billing_name = orderDetailRefund?.billing_name ?? ""
        
        let cust_id = orderDetailRefund?.customer_id ?? ""
        
        let cust_email = orderDetailRefund?.customer_email ?? ""
        let email = orderDetailRefund?.email ?? ""
        
        let delivery_phn = orderDetailRefund?.delivery_phn ?? ""
        let cust_phone = orderDetailRefund?.customer_phone ?? ""
        
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
        else if billing_name == "" || billing_name.contains("null") {
            if delivery_name == "" || delivery_name.contains("null") {
            }
            else {
                smallName.append("Name")
                smallValue.append(delivery_name)
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
            refund_id_exist = false
            custDetails.isHidden = true
            blueidentity.isHidden = true
            underidentity.isHidden = true
        }
        else {
            refund_id_exist = true
        }
        
        print(smallName)
        print(smallValue)
        
        idRefundName = smallName
        idRefundValue = smallValue
        
    }
    
    func setRefCartData(cart: Any) {
        
        let smallres = cart as! [[String:Any]]
        var smallcart = [Cart_Data]()
        var smallrefcart = [Cart_Data]()
        
        var taxcart = [Cart_Data]()
        
        let countItems = smallres.count
        
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
                                 bogo_discount: "\(res["bogo_discount"] ?? "")",
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
            
            if cart.is_lottery == "1" {
                isLottery = "1"
            }
            
            //            if cart.is_refunded == "1" {
            //                if smallrefcart.count != 0 {
            //                    if smallrefcart.contains(where: { $0.note == cart.note }) {
            //                        let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
            //                        let quantity = smallrefcart[index].refund_qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallrefcart[index].refund_qty = String(newQty)
            //
            //                        let discount = smallrefcart[index].discount_amt
            //                        let newDis = cart.discount_amt
            //
            //                        var int_dis = Double(discount) ?? 0.00
            //                        let int_newDis = Double(newDis) ?? 0.00
            //                        int_dis += int_newDis
            //                        smallrefcart[index].discount_amt = String(int_dis)
            //                    }
            //                    else {
            //                        smallrefcart.append(cart)
            //                    }
            //                }
            //                else {
            //                    smallrefcart.append(cart)
            //                }
            //            }
            
            //            else if cart.is_refunded == "2" {
            //                if smallrefcart.count != 0 {
            //                    if smallrefcart.contains(where: { $0.note == cart.note }) {
            //                        let index = smallrefcart.firstIndex(where: { $0.note == cart.note }) ?? 0
            //                        let quantity = smallrefcart[index].refund_qty
            //
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallrefcart[index].refund_qty = String(newQty)
            //
            //                        let discount = smallrefcart[index].discount_amt
            //                        let newDis = cart.discount_amt
            //
            //                        var int_dis = Double(discount) ?? 0.00
            //                        let int_newDis = Double(newDis) ?? 0.00
            //                        int_dis += int_newDis
            //                        smallrefcart[index].discount_amt = String(int_dis)
            //                    }
            //                    else {
            //                        smallrefcart.append(cart)
            //                    }
            //                }
            //                else {
            //                    smallrefcart.append(cart)
            //                }
            //
            //                if smallcart.count != 0 {
            //                    if smallcart.contains(where: { $0.note == cart.note }) {
            //                        let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
            //                        let quantity = smallcart[index].qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcart[index].qty = String(newQty)
            //
            //                        let discount = smallcart[index].discount_amt
            //                        let newDis = cart.discount_amt
            //
            //                        var int_dis = Double(discount) ?? 0.00
            //                        let int_newDis = Double(newDis) ?? 0.00
            //                        int_dis += int_newDis
            //                        smallcart[index].discount_amt = String(int_dis)
            //                    }
            //                    else {
            //                        smallcart.append(cart)
            //                    }
            //                }
            //                else {
            //                    smallcart.append(cart)
            //                }
            //            }
            
            //            else {
            //                if smallcart.count != 0 {
            //                    if smallcart.contains(where: { $0.note == cart.note }) {
            //                        let index = smallcart.firstIndex(where: { $0.note == cart.note }) ?? 0
            //                        let quantity = smallcart[index].qty
            //                        print(quantity)
            //                        let newQty = (Int(quantity) ?? 0) + 1
            //                        smallcart[index].qty = String(newQty)
            //
            //                        let discount = smallcart[index].discount_amt
            //                        let newDis = cart.discount_amt
            //
            //                        var int_dis = Double(discount) ?? 0.00
            //                        let int_newDis = Double(newDis) ?? 0.00
            //                        int_dis += int_newDis
            //                        smallcart[index].discount_amt = String(int_dis)
            //                    }
            //                    else {
            //                        smallcart.append(cart)
            //                    }
            //                }
            //                else {
            //                    smallcart.append(cart)
            //                }
            //            }
            
            if cart.is_refunded == "1" {
                smallrefcart.append(cart)
            }
            else if cart.is_refunded == "2" {
                smallrefcart.append(cart)
                smallcart.append(cart)
            }
            else {
                smallrefcart.append(cart)
            }
        }
        
        let tax = orderDetailRefund?.tax ?? "0.00"
        
        let tax_rate = orderDetailRefund?.tax_rate ?? "0.00"
        
        let other_taxes = orderDetailRefund?.other_taxes_desc ?? ""
        
        let other_tax = convertStringToDictionary(text: other_taxes)
        
        let other_taxes_rate = orderDetailRefund?.other_taxes_rate_desc ?? ""
        
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
        
        refTaxTotalValue.text = "$\(String(format: "%.2f", add))"
        
        refund_tax_table_array = tax_order_sum_array
        
        
        cartrefItemsRefund = smallrefcart
        cartparrefItemsRefund = smallcart
        print(smallrefcart.count)
        print(smallcart.count)
        
        if cartparrefItemsRefund.count == 0 {
            instoreViewHeight.constant = 0
            instoreLbl.text = ""
        }
        else {
            instoreViewHeight.constant = 50
            instoreLbl.text = "In-Store Order"
        }
        
        let itemsCount = countItems
        
        orderDetailRefundLabel.append("Total Items")
        orderDetailRefundValue.append("\(itemsCount)")
        
        grandTotalValue.text = "$\(calculateGrandTotal())"
        
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
    
    func calculateSplitRefEbt(cash: [String]) -> Double {
        
        var doub_amt = Double()
        
        for pay in cash {
            let doub = Double(pay) ?? 0.00
            doub_amt += doub
        }
        print(doub_amt)
        return doub_amt
    }
    
    func calculateRefDiscount(amt: String, discount: String) -> String {
        
        let amt1 = roundRefOf(item: amt)
        let amt2 = roundRefOf(item: discount)
        
        let calc_amt = amt1 - amt2
        return String(calc_amt)
        
    }
    
    func calculateGrandTotal() -> String {
        
        var net = netValue.text ?? "0.00"
        if net.count != 0 {
            net.removeFirst()
        }
        let net_doub = Double(net) ?? 0.00
        
        var tax = refTaxTotalValue.text ?? "0.00"
        if tax.count != 0 {
            tax.removeFirst()
        }
        let tax_doub = Double(tax) ?? 0.00
        
        var fees = totalFeeValue.text ?? "0.00"
        if fees.count != 0 {
            fees.removeFirst()
        }
        let fees_doub = Double(fees) ?? 0.00
        
        let total = net_doub + tax_doub + fees_doub
        return String(format: "%.2f", total)
        
    }
    
    func setRefundData(refund: Any) {
        
        let refund_data = refund as! [[String:Any]]
        detailRefund = refund_data
        
        var smallRefund = [[String]]()
        var smallRefundVal = [[String]]()
        var smallRefundTax = [[String]]()
        var smallRefDate = [String]()
        var smallRefundTip = [[TipNca]]()
        var smallRefundHeight = [[String]]()
        var smallRefPax = [[String]]()
        var smallRefDigits = [[String]]()
        
        var amtArray = [String]()
        
        var removeLoyal = [Loyalty]()
        
        var taxesRefund = [String]()
        
        //        var smallRefundTable = [RefundTableDetails]()
        
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
            let c_card_pay = refund_pay.credit_amt
            let d_card_pay = refund_pay.debit_amt
            let cash_pay = refund_pay.cash_amt
            
            
            let loyalty_amt = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
            
            
            let refund_reason = refund_pay.reason
            
            
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
            let giftcard_amt = refund_pay.giftcard_amt
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
            var smallreftax = [String]()
            var smalltip = [TipNca]()
            var smallHeight = [String]()
            var smallPax = [String]()
            var smallDigits = [String]()
            //            if refund_reason != "" {
            //
            //                smallRef.append("Reason Of Refund")
            //                smallRefValues.append(refund_reason)
            //
            //            }
            
            if amt != "0.0" && amt != "0.00" && amt != "0.000"  {
                amtArray.append(amt)
            }
            
            
            if c_card_pay != "0.0" && c_card_pay != "0.00" && c_card_pay != "0.000"  {
                smallRef.append("Credit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: c_card_pay)))")
                smallreftax.append("$\(String(format: "%.02f", roundRefOf(item: credit_refund_tax)))")
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
            
            if d_card_pay != "0.0" && d_card_pay != "0.00" && d_card_pay != "0.000" {
                smallRef.append("Debit Card")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: d_card_pay)))")
                smallreftax.append("$\(String(format: "%.02f", roundRefOf(item: debit_refund_tax)))")
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
            
            if cash_pay != "0.0" && cash_pay != "0.00" && cash_pay != "0.000"  {
                smallRef.append("Cash")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: cash_pay)))")
                smallreftax.append("$\(String(format: "%.02f", roundRefOf(item: cash_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "", ncaAmt: ""))
                smallHeight.append("80.33")
                smallPax.append("")
                smallDigits.append("")
            }
            
            //            if loyalty_amt != "0.0" && loyalty_amt != "0.00" && loyalty_amt != "0.000" {
            //                smallRef.append("Loyalty Points")
            //                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: loyalty_amt)))")
            //                taxesRefund.append("$\(String(format: "%.02f", roundRefOf(item: loyality_refund_tax)))")
            //            }
            
            if store_cred != "0.0" && store_cred != "0.00" && store_cred != "0.000" {
                smallRef.append("Store Credits")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: store_cred)))")
                smallreftax.append("$\(String(format: "%.02f", roundRefOf(item: store_credit_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "0.00", ncaAmt: "0.00"))
                smallHeight.append("98.33")
                smallPax.append("")
                smallDigits.append("")
                
            }
            
            //            if tip_amt != "0.0" && tip_amt != "0.00" && tip_amt != "0.000"  {
            //                smallRef.append("Tip")
            //                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: tip_amt)))")
            //                smallreftax.append("0.00")
            //            }
            //
            if giftcard_amt != "0.0" && giftcard_amt != "0.00" && giftcard_amt != "0.000" {
                smallRef.append("Gift Card")
                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: giftcard_amt)))")
                smallreftax.append("$\(String(format: "%.02f", roundRefOf(item: gift_card_refund_tax)))")
                smalltip.append(TipNca(tipAmt: "0.00", ncaAmt: "0.00"))
                smallHeight.append("98.33")
                smallPax.append("")
                smallDigits.append("")
            }
            
            //            if nca_amt != "0.0" && nca_amt != "0.00" && nca_amt != "0.000" {
            //
            //                smallRef.append("Non Cash Adjustment")
            //                smallRefValues.append("$\(String(format: "%.02f", roundRefOf(item: nca_amt)))")
            //                smallreftax.append("0.00")
            //            }
            
            if reward_loyalty_refund_point != "0.0" && reward_loyalty_refund_point != "0.00"
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
            smallRefundTax.append(smallreftax)
            smallRefDate.append(create_date)
            smallRefundTip.append(smalltip)
            smallRefundHeight.append(smallHeight)
            smallRefPax.append(smallPax)
            smallRefDigits.append(smallDigits)
            
        }
        
        payRefund = smallRefund
        payRefundValues = smallRefundVal
        payRefundDate = smallRefDate
        payRefundTax = smallRefundTax
        payRefNcaTip = smallRefundTip
        payRefundHeight = smallRefundHeight
        refundPaxAuth = smallRefPax
        refundPaxDigits = smallRefDigits
        
        
        
        
        //        refundTableArray = smallRefundTable
        
        //        print(refundTableArray)
        
        
        
        let totalRefund = calculateTotalRefund(payValues: smallRefundVal)
        refundTotalValue.text = "$\(String(format: "%.2f", roundRefOf(item: totalRefund)))"
        
        let totaltaxRefund = calculateTotalRefundTax(payValues: payRefundTax)
        refTotalTax.text = "$\(String(format: "%.2f", roundRefOf(item: totaltaxRefund)))"
        
        var grand = grandTotalValue.text ?? ""
        grand.removeFirst()
        
        if grand != "0.0" && grand != "0.00" && grand != "0.000" && grand != "-0.0"
            && grand != "-0.00" && grand != "0" && grand != "" && handleZero(value: grand) {
            
            let grand_doub = Double(grand) ?? 0.00
            let after_doub = Double(totalRefund) ?? 0.00
            
            let grands =  grand_doub - after_doub
            afterRefundPrice.text = "$\(String(format: "%.2f", roundOf(item: "\(grands)")))"
        }
        else {
            let after_doub = Double(totalRefund) ?? 0.00
            afterRefundPrice.text = "$\(String(format: "%.2f", roundOf(item: "\(after_doub)")))"
        }
        
        
        let points_earned = couponCode?.loyalty_point_earned ?? "0.00"
        let remove = calculateLoyal(points: removeLoyal)
        
        let remove_doub = Double(remove) ?? 0.00
        let earned_doub = Double(points_earned) ?? 0.00
        
        var award = 0.00
        
        if earned_doub < 0.00 {
            award = remove_doub + earned_doub
        }
        else {
            award = remove_doub + earned_doub
        }
        
        var refund_loyal = [Loyalty]()
        
        
        var award_str = String(award)
        if award_str.hasPrefix("-")
        {
            award_str.removeFirst()
        }
        if award != 0.0 && award != 0.00 && award != -0.0 && award != -0.00 && award != 0 {
            
            refund_loyal.append(Loyalty(loyalty_points: "\(award)", loyalty_date: orderDetailRefund?.date_time ?? ""))
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
            
            totalLoyalValue.text = ""
            totalLoyalHeight.constant = 0
            loyalHeaderHeight.constant = 0
            blueLoyalty.isHidden = true
            loyaltyPointsLbl.text = ""
            totalLoyalLbl.text = ""
        }
        else {
            
            var total = 0.00
            if loyalArray.count != 0 {
                total = Double(loyalArray[0].loyalty_points) ?? 0.00
                totalLoyalValue.text = String(total)
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
                    totalLoyalValue.text = String(format: "%.2f", roundRefOf(item: value))
                }
                else {
                    totalLoyalValue.text = String(format: "%.2f", roundRefOf(item: String(total)))
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
        
        for tip in payRefNcaTip {
            
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
    
    func calculateTotalNetSales(values: [String]) -> String {
        
        var total = 0.00
        
        let loyal = values[0]
        let dis = values[1]
        
        let loyal_doub = Double(loyal) ?? 0.00
        let dis_doub = Double(dis) ?? 0.00
        
        if loyal_doub == 0.00 && dis_doub == 0.00 {
            var gross = grossValue.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            return String(gross)
        }
        
        else if loyal_doub == 0.00 {
            
            var gross = grossValue.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = gross_doub - dis_doub
            return String(net)
        }
        
        else if dis_doub == 0.00 {
            
            var gross = grossValue.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = gross_doub - loyal_doub
            return String(net)
        }
        
        else {
            
            var gross = grossValue.text ?? "0.00"
            if gross.starts(with: "$") {
                gross.removeFirst()
            }
            let gross_doub = Double(gross) ?? 0.00
            
            let net = (gross_doub - (loyal_doub + dis_doub))
            return String(net)
        }
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
    
    func calculateTotalTender(amt: [String]) -> String {
        
        var total = 0.00
        for add in amt {
            
            let add_doub = Double(add) ?? 0.00
            total += add_doub
        }
        return String(total)
    }
    
    func getTenderHeight() -> Double {
        
        var height = 0.00
        
        for val in tenderHeight {
            
            height += Double(val) ?? 0.00
        }
        
        return height
    }
    
    func calculateLoyal(points: [Loyalty]) -> String {
        
        var total = 0.00
        
        for point in points {
            
            total += Double(point.loyalty_points) ?? 0.00
        }
        
        return String(total)
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
    
    func getRefCountForHeight() -> Double {
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
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        var destiny = 0
        
        let viewcontrollerArray = navigationController?.viewControllers
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
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
    
    func calTotalPrice(onePrice: String, qty: String,
                       discount: String, bogo_dis: String,
                       overide: String) -> Double {
        
        let price = Double(onePrice) ?? 0.00
        let quant = Double(qty) ?? 0.00
        let dis = Double(discount) ?? 0.00
        let b_dis = Double(bogo_dis) ?? 0.00
        let over = Double(overide) ?? 0.00
        
        let total = price * quant
        
        let dis_price = total - dis - b_dis - over
        
        return roundOf(item: String(dis_price))
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


extension InStoreNewRefundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == refundTable {
            if orderDetailRefund?.is_refunded == "1" {
                return payRefund.count
            }
            else {
                return 0
            }
        }
        
        
        else if tableView == refundCustTable {
            
            if refund_id_exist {
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
        
        if tableView == refundItemsTable {
            return cartrefItemsRefund.count
        }
        
        else if tableView == refundPartialTable {
            return cartparrefItemsRefund.count
        }
        
        else if tableView == refundOrderDetailTable {
            return orderDetailRefundLabel.count
        }
        
        else if tableView == refundTaxesTable {
            return refund_tax_table_array.count
        }
        
        else if tableView == refundGrossTable {
            return grossRefundLabel.count
        }
        
        else if tableView == refundTable {
            return payRefund[section].count
        }
        
        else if tableView == refundLoyalTable {
            return loyalArray.count
        }
        
        else if tableView == refundFeeTable {
            return feeRefundSum.count
        }
        
        else if tableView == refundTenderTable {
            return payRefundSum.count
        }
        
        else {
            return idRefundName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == refundItemsTable {
            
            let cell = refundItemsTable.dequeueReusableCell(withIdentifier: "payrefcell", for: indexPath) as! PayRefundItemsCell
            
            let cart = cartrefItemsRefund[indexPath.row]
            
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
            
            if cart.discount_amt != "0.0" && cart.discount_amt != "0.00" &&
                cart.discount_amt != "-0.00" && cart.discount_amt != "-0.0" &&
                cart.discount_amt != "0" && cart.discount_amt != "" {
                
                cell.itemRefDiscountLbl.text = "Item Discount(-$\(String(format: "%.02f", roundOf(item: cart.discount_amt))))"
                cell.itemRefDisValue.text = ""
            }
            else if cart.bogo_discount != "0.0" && cart.bogo_discount != "0.00" &&
                        cart.bogo_discount != "-0.00" && cart.bogo_discount != "-0.0" &&
                        cart.bogo_discount != "0" && cart.bogo_discount != "" {
                
                cell.itemRefDiscountLbl.text = "Bogo Deal(-$\(String(format: "%.02f", roundOf(item: cart.bogo_discount))))"
                cell.itemRefDisValue.text = ""
            }
            else {
                
                cell.itemRefDiscountLbl.text = ""
                cell.itemRefDisValue.text = ""
            }
            
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
            
            cell.payRefTotalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.inventory_price, qty: cart.refund_qty, discount: cart.discount_amt, bogo_dis: cart.bogo_discount, overide: cart.adjust_price))))"
            
            
            return cell
        }
        
        else if tableView == refundPartialTable {
            
            let cell = refundPartialTable.dequeueReusableCell(withIdentifier: "payrefundpartialcell", for: indexPath) as! PayRefundItemsCell
            
            let cart = cartparrefItemsRefund[indexPath.row]
            
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
            cell.payRefQty.text = "\(cart.qty)x"
            
            if cart.discount_amt != "0.0" && cart.discount_amt != "0.00" &&
                cart.discount_amt != "-0.00" && cart.discount_amt != "-0.0" &&
                cart.discount_amt != "0" && cart.discount_amt != "" {
                
                cell.itemRefDiscountLbl.text = "Item Discount(-$\(String(format: "%.02f", roundOf(item: cart.discount_amt))))"
                cell.itemRefDisValue.text = ""
            }
            
            else if cart.bogo_discount != "0.0" && cart.bogo_discount != "0.00" &&
                        cart.bogo_discount != "-0.00" && cart.bogo_discount != "-0.0" &&
                        cart.bogo_discount != "0" && cart.bogo_discount != "" {
                
                cell.itemRefDiscountLbl.text = "Bogo Deal(-$\(String(format: "%.02f", roundOf(item: cart.bogo_discount))))"
                cell.itemRefDisValue.text = ""
            }
            
            else {
                
                cell.itemRefDiscountLbl.text = ""
                cell.itemRefDisValue.text = ""
            }
            
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
            
            cell.payRefTotalPrice.text = "$\(String(format: "%.02f", calTotalPrice(onePrice: cart.inventory_price, qty: cart.qty, discount: cart.discount_amt, bogo_dis: cart.bogo_discount, overide: cart.adjust_price)))"
            
            
            return cell
        }
        
        else if tableView == refundOrderDetailTable {
            
            let cell = refundOrderDetailTable.dequeueReusableCell(withIdentifier: "refordercell", for: indexPath) as! InStoreOrderSumCell
            
            cell.orderLbl.text = orderDetailRefundLabel[indexPath.row]
            cell.orderLblValue.text = orderDetailRefundValue[indexPath.row]
            
            return cell
            
        }
        
        else if tableView == refundGrossTable {
            
            let cell = refundGrossTable.dequeueReusableCell(withIdentifier: "refgrosscell", for: indexPath) as! InStoreOrderSumCell
            
            cell.orderLbl.text = "\(grossRefundLabel[indexPath.row])"
            cell.orderLblValue.text = "-$\(String(format: "%.2f", roundOf(item: grossRefundValue[indexPath.row])))"
            cell.orderLblValue.textColor = UIColor(hexString: "#E61F1F")
            
            if indexPath.row == 0 {
                
                let shapeLayer1 = CAShapeLayer()
                shapeLayer1.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer1.lineWidth = 1
                shapeLayer1.lineDashPattern = [4, 4]
                
                let path2 = CGMutablePath()
                path2.addLines(between: [CGPoint(x: 0, y: grossView.frame.maxY),
                                         CGPoint(x: grossView.frame.maxX, y: grossView.frame.maxY)])
                shapeLayer1.path = path2
                scroll.layer.addSublayer(shapeLayer1)
            }
            
            else if indexPath.row == grossRefundLabel.count - 1 {
                
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
        
        else if tableView == refundTaxesTable {
            
            let cell = refundTaxesTable.dequeueReusableCell(withIdentifier: "reftaxcell", for: indexPath) as! InStoreTaxTableViewCell
            
            let tax = refund_tax_table_array[indexPath.row]
            cell.taxName.text = tax.tax_name
            cell.taxpercent.text = "\(String(format: "%.3f", roundOf(item: "\(tax.tax_rate)")))%"
            cell.taxAmt.text = "$\(String(format: "%.2f", roundOf(item: "\(tax.tax_amount)")))"
            cell.salesTax.text = "$\(String(format: "%.2f", roundOf(item: "\(tax.sale_due)")))"
            
            if indexPath.row == refund_tax_table_array.count - 1 {
                
                let shapeLayer3 = CAShapeLayer()
                shapeLayer3.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer3.lineWidth = 1
                shapeLayer3.lineDashPattern = [4, 4]
                
                let path4 = CGMutablePath()
                path4.addLines(between: [CGPoint(x: 0, y: refundTotalTaxView.frame.minY),
                                         CGPoint(x: refundTotalTaxView.bounds.maxX, y: refundTotalTaxView.frame.minY)])
                shapeLayer3.path = path4
                scroll.layer.addSublayer(shapeLayer3)
                
                let shapeLayer4 = CAShapeLayer()
                shapeLayer4.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer4.lineWidth = 1
                shapeLayer4.lineDashPattern = [4, 4]
                
                let path5 = CGMutablePath()
                path5.addLines(between: [CGPoint(x: 0, y: refundTotalTaxView.frame.maxY),
                                         CGPoint(x: refundTotalTaxView.frame.maxX, y: refundTotalTaxView.frame.maxY)])
                shapeLayer4.path = path5
                scroll.layer.addSublayer(shapeLayer4)
            }
            return cell
            
        }
        
        else if tableView == refundFeeTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reffeecell", for: indexPath) as! InStorePayTableCell
            
            if feeRefundSum[indexPath.row] == "Discounts" || feeRefundSum[indexPath.row] == couponCode?.coupon_code {
                cell.payName.text = feeRefundSum[indexPath.row]
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: (feeRefundSumValue[indexPath.row]))))"
            }
            else {
                cell.payName.text = feeRefundSum[indexPath.row]
                cell.payValue.text = "$\(String(format: "%.02f", roundOf(item: (feeRefundSumValue[indexPath.row]))))"
            }
            
            if indexPath.row == feeRefundSum.count - 1 {
                let shapeLayer5 = CAShapeLayer()
                shapeLayer5.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer5.lineWidth = 1
                shapeLayer5.lineDashPattern = [4, 4]
                
                let path6 = CGMutablePath()
                path6.addLines(between: [CGPoint(x: 0, y: feeTotalView.frame.minY),
                                         CGPoint(x: feeTotalView.frame.maxX, y: feeTotalView.frame.minY)])
                shapeLayer5.path = path6
                scroll.layer.addSublayer(shapeLayer5)
                
                let shapeLayer6 = CAShapeLayer()
                shapeLayer6.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer6.lineWidth = 1
                shapeLayer6.lineDashPattern = [4, 4]
                
                let path7 = CGMutablePath()
                path7.addLines(between: [CGPoint(x: 0, y: feeTotalView.frame.maxY),
                                         CGPoint(x: feeTotalView.frame.maxX, y: feeTotalView.frame.maxY)])
                shapeLayer6.path = path7
                scroll.layer.addSublayer(shapeLayer6)
            }
            
            
            return cell
        }
        
        
        else if tableView == refundTenderTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reftendercell", for: indexPath) as! InStorePayTableCell
            
            let digit = tenderDigits[indexPath.row]
            
            if digit == "" {
                cell.payName.text = payRefundSum[indexPath.row]
            }
            else {
                cell.payName.text = "\(payRefundSum[indexPath.row]): \(digit)"
            }
            cell.payName.textColor = UIColor(hexString: "#707070")
            
            if payRefundSum[indexPath.row] == "Points Applied" {
                cell.payValue.text = payRefundSumValue[indexPath.row]
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if payRefundSum[indexPath.row] == "Points Awarded" {
                cell.payValue.textColor = UIColor(red: 76.0/255.0, green: 188.0/255.0, blue: 12.0/255.0, alpha: 1.0)
                cell.payValue.text = "\(String(format: "%.02f", roundOf(item: payRefundSumValue[indexPath.row])))"
            }
            else if payRefundSum[indexPath.row] == "Gift Card Applied" {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: payRefundSumValue[indexPath.row])))"
                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else if payRefundSum[indexPath.row] == "Lottery Payout" || payRefundSum[indexPath.row] == "Scratcher Payout" {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: payRefundSumValue[indexPath.row])))"
                //                cell.payValue.textColor = UIColor(red: 254.0/255.0, green: 83.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            }
            else {
                cell.payValue.text = "-$\(String(format: "%.02f", roundOf(item: payRefundSumValue[indexPath.row])))"
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
        
        else if tableView == refundTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "refcell", for: indexPath) as! InStorePayTableCell
            
            let digit = refundPaxDigits[indexPath.section][indexPath.row]
            
            if digit == "" {
                cell.payName.text = payRefund[indexPath.section][indexPath.row]
            }
            else {
                cell.payName.text = "\(payRefund[indexPath.section][indexPath.row]): \(digit)"
            }
            
            cell.payValue.text = payRefundValues[indexPath.section][indexPath.row]
            cell.payTax.text = payRefundTax[indexPath.section][indexPath.row]
            
            let ordate = ToastClass.sharedToast.setDateFormat(dateStr: payRefundDate[indexPath.section])
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
                //        cell.aid.text = ""
            }
            else if cell.payName.text == "Credit Card" || cell.payName.text == "Debit Card" {
                cell.tipNcaLbl.text = "(Tip:- $\(payRefNcaTip[indexPath.section][indexPath.row].tipAmt) NCA:- $\(payRefNcaTip[indexPath.section][indexPath.row].ncaAmt))"
                //        cell.aid.text = "AID: 7878787878"
            }
            else {
                cell.tipNcaLbl.text = "(Tip:- $\(payRefNcaTip[indexPath.section][indexPath.row].tipAmt) NCA:- $\(payRefNcaTip[indexPath.section][indexPath.row].ncaAmt))"
                //        cell.aid.text = ""
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
                                     CGPoint(x: refundTotalView.frame.maxX, y: refundTotalView.frame.maxY)])
            shapeLayer4.path = path5
            scroll.layer.addSublayer(shapeLayer4)
            return cell
        }
        
        
        else if tableView == refundLoyalTable {
            
            let cell = refundLoyalTable.dequeueReusableCell(withIdentifier: "loyalcell", for: indexPath) as! LoyaltyOrderTableViewCell
            
            if indexPath.row == loyalArray.count - 1 {
                let shapeLayer5 = CAShapeLayer()
                shapeLayer5.strokeColor = UIColor(hexString: "#707070").cgColor
                shapeLayer5.lineWidth = 1
                shapeLayer5.lineDashPattern = [4, 4]
                
                let path6 = CGMutablePath()
                path6.addLines(between: [CGPoint(x: loyalHeaderView.frame.minX, y: loyalHeaderView.frame.maxY),
                                         CGPoint(x: loyalHeaderView.frame.maxX, y: loyalHeaderView.frame.maxY)])
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
        
        else  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "refcustcell", for: indexPath) as! InStoreIdentityCell
            
            cell.payIdLbl.text = idRefundName[indexPath.row]
            cell.payIdValue.text = idRefundValue[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == refundItemsTable || tableView == refundPartialTable {
            return 130
        }
        
        else if tableView == refundTable {
            let doub = roundRefOf(item: payRefundHeight[indexPath.section][indexPath.row])
            return CGFloat(doub)
        }
        
        else if tableView == refundTenderTable {
            let doub = roundOf(item: tenderHeight[indexPath.row])
            return CGFloat(doub)
        }
        
        else {
            return UITableView.automaticDimension
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //            if tableView == payRefundTable {
    //
    //                let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
    //                let label1 = UILabel(frame: CGRect(x: tableView.frame.size.width - 170, y: 0, width: tableView.frame.size.width - 65, height: 19))
    //                label1.text = payRefundDate[section]
    //                label1.font = UIFont(name: "Manrope-SemiBold", size: 15.0)
    //                label1.textColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    //                headerView.addSubview(label1)
    //
    //                let label = UILabel(frame: CGRect(x: 20, y: label1.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
    //                label.text = "Refund"
    //                label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
    //                headerView.addSubview(label)
    //
    //                let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
    //                grayview.backgroundColor = .black
    //                headerView.addSubview(grayview)
    //
    //                let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 60, height: 3))
    //                blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    //                headerView.addSubview(blueview)
    //
    //                return headerView
    //            }
    
    //        if tableView == refundCustTable {
    //
    //            let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 54))
    //            let btn2 = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 0, width: 20, height: 20))
    //
    //            let label = UILabel(frame: CGRect(x: 20, y: btn2.frame.midY - 25, width: tableView.frame.size.width - 40, height: 23))
    //            label.text = "Identification Details"
    //            label.font = UIFont(name: "Manrope-SemiBold", size: 18.0)
    //            headerView.addSubview(label)
    //
    //            let grayview = UIView(frame: CGRect(x: 20, y: label.frame.maxY + 10, width: tableView.frame.size.width - 40, height: 1))
    //            grayview.backgroundColor = .black
    //            headerView.addSubview(grayview)
    //
    //            let blueview = UIView(frame: CGRect(x: 20, y: grayview.frame.minY - 1, width: 180, height: 3))
    //            blueview.backgroundColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    //            headerView.addSubview(blueview)
    //
    //            return headerView
    //        }
    //
    //        else {
    //            return nil
    //        }
    //    }
}
