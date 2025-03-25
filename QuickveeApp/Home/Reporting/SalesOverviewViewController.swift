//
//  SalesOverviewViewController.swift
//
//
//  Created by Jamaluddin Syed on 17/01/23.
//

import UIKit
import Alamofire

class SalesOverviewViewController: UIViewController {
    
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let salesArray = ["Gross Sale","Loyalty Point Amount","Gift Card Amount", "Discount", "Refund", "Net Sale", "Taxes & Fees","Tips", "Services Charges","Non Cash Adjustment Fees", "CashBack Fees", "Sales by Tender and Card Type", "Credit Cards + Debit Cards","Cash","Food EBT", "Cash EBT", "Amount Collected"]
    
    var responseValues = [String]()
    var coupon_dis = ""
    var outdoor_dis = ""
    
    var refunds_netSale = ""
    var netsale = ""
    var taxes_and_fees = ""
    var amt_ser_charge = ""
    var loyalty_point = ""
    var discount_amt = ""
    var refunds = ""
    var amount_Collected = ""
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noDataImage.image = UIImage(named: "No Data")
        noDataImage.isHidden = true
        tableView.isHidden = true
        dataLabel.text = "No Data Found"
        dataLabel.isHidden = true
        setupUI()
        
        
        loadingIndicator.isAnimating = true
        
        
        getApiCallData(tag: 1)
    }
    
    func roundOf(item : String) -> Double {
        
        let refund = item
        let doub = Double(refund) ?? 0.0
        let div = Double(round(100 * doub) / 100)
        print(div)
        return div
    }
    
    
    func getApiCallData(tag:Int) {
        
        let url = AppURLs.SALES_OVERVIEW
        
        let manager = APIManager.shared
        let salesValueArray = manager.getApiCallData(tag: tag)
        print(salesValueArray)
        
        let parameters: [String:Any] = [
            "start_date_time": salesValueArray[0],
            "end_date_time": salesValueArray[1],
            "order_env": salesValueArray[2],
            "order_typ": salesValueArray[3],
            "merchant_id": salesValueArray[4],
        ]
        print(parameters)
        
        
        getAPIResponse(url: url, parameters: parameters)
    }
    
    func getAPIResponse(url:String, parameters: [String:Any]) {
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    guard let jsonDict = json["result"] else {
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = true
                        self.noDataImage.isHidden = false
                        self.dataLabel.isHidden = false
                        return
                    }
                    self.getResponseValues(response: jsonDict)
                    self.tableView.reloadData()
                    break
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    @IBAction func infoBtnClick(_ sender: UIButton) {
        
        if sender.tag == 0 {
            showAlert(title: "Info", message: "Gross Sales = Subtotal(Sum of amount without Tax, Tip and Discount)")
        }
        
        else if sender.tag == 3 {
            showAlert(title: "Info", message: "Net Sales = Subtotal - Discount - Refunds")
        }
        else if sender.tag == 4 {
            showAlert(title: "Info", message: "The Total Amount includes all sales tax collected and convenience fees from online ordering.")
        }
        else if sender.tag == 6 {
            showAlert(title: "Info", message: "Service Charges = Convenience fee + Delivery fee")
        }
        else {
            showAlert(title: "Info", message: "Amount Collected = Net Sales + Taxes & Fees  + Tip + Service Charges + Cash Discounting")
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func calculateLoyaltyPoint(loyalty_point_spent: String, loyalty_amt_refunded: String) -> String {
        let tlps = roundOf(item: loyalty_point_spent)
        let lar = roundOf(item: loyalty_amt_refunded)
        
        let t_loyalty = tlps - lar
        print(t_loyalty)
        loyalty_point = String(t_loyalty)
        return String(t_loyalty)
        
    }
    
    func calDiscount(disc: String,gift_card: String, loyalty_point: String) -> String{
        let dis = roundOf(item: disc)
        let gc = roundOf(item: gift_card)
        let tlps = roundOf(item: loyalty_point)
        
        let caldisc = (dis - (gc + tlps))
        print(caldisc)
        discount_amt = String(caldisc)
        return String(caldisc)
        
    }
    
    func calRefunds(net_Refund: String, net_Refund1: String , Refunded_all_tax: String ) -> String{
        let nr = roundOf(item: net_Refund)
        let nr1 = roundOf(item: net_Refund1)
        let rat = roundOf(item: Refunded_all_tax)
        
        let refund = ((nr + nr1) - rat)
        print(refund)
        refunds = String(refund)
        return String(refund)
    }
    
    
    
    func calculateNetSales(gross_sale: String,disc: String, refund :String , gift_card_amt_Collected: String,loyalty_amt_collected: String ) -> String {
        
        let gs = roundOf(item: gross_sale)
        let dis = roundOf(item: disc)
        let ref = roundOf(item: refund)
        let gcac = roundOf(item: gift_card_amt_Collected)
        let lac = roundOf(item: loyalty_amt_collected)
        
        
        
        let net = ((gs - (dis + ref)) - gcac) - lac
        print(net)
        netsale = String(net)
        return String(net)
    }
    
    func calculateTax(remain_default_tax: String, remain_other_tax :String)  -> String{
        let rdt = roundOf(item: remain_default_tax)
        let rot = roundOf(item: remain_other_tax)
        
        let tax = rdt + rot
        taxes_and_fees = String(tax)
        print(String(tax))
        return String(tax)
        
    }
    
    func calculateServices(con_fee: String, d_fee :String)  -> String{
        let cfee = roundOf(item: con_fee)
        let d_fee = roundOf(item: d_fee)
        
        let ser_charge = cfee + d_fee
        amt_ser_charge = String(ser_charge)
        print(String(ser_charge))
        return String(ser_charge)
        
    }
    
    func calculateAmountCollected(card_Collected:String, cash_Collected : String,
                                  cash_ebt_Collected: String, food_ebt_Collected: String,
                                  cash_back_amt: String, cash_back_fee: String)  -> String{
        
        let card_c = roundOf(item: card_Collected)
        let cash_c = roundOf(item: cash_Collected)
        let cec = roundOf(item: cash_ebt_Collected)
        let fec = roundOf(item: food_ebt_Collected)
        let cba = roundOf(item: cash_back_amt)
        let cbf = roundOf(item: cash_back_fee)
        
        let amount = card_c + cash_c + cec + fec + cba + cbf
        
        return String(amount)
        
    }
    
    func calculateCard(card: String, cash_back_amt: String, cash_back_fee: String) -> String{
        
        let card_c = roundOf(item: card)
        let cash_amt = roundOf(item: cash_back_amt)
        let cash_fee = roundOf(item: cash_back_fee)
        
        let amount = card_c + cash_amt + cash_fee
        
        return String(amount)
        
    }
    
    func calculateCash(cash: String, cash_back_amt: String) -> String{
        
        let cash_c = roundOf(item: cash)
        let cash_back = roundOf(item: cash_back_amt)
        
        let amount = cash_c - cash_back
        
        return String(amount)
        
    }
    
    func calculateRefund(netRef: String, netRef1 :String, ref_all_partial:String  )  -> String{
        
        let rf = roundOf(item: netRef)
        let rf1 = roundOf(item: netRef1)
        let ref_all_partl = roundOf(item: ref_all_partial)
        
        let refunds = rf + rf1 - ref_all_partl
        print(String(refunds))
        refunds_netSale = String(refunds)
        return String(refunds)
        
    }
    
    func getResponseValues(response: Any) {
        
        let res = response as? [String:Any]
        var responsevalue = [String]()

        responsevalue.append("\(res?["subtotal"] ?? "0")")
        responsevalue.append(calculateLoyaltyPoint(loyalty_point_spent: "\(res?["total_loyalty_point_spent"] ?? "0")",
                                                   loyalty_amt_refunded: "\(res?["loyality_amt_refunded"] ?? "0")"))
        responsevalue.append("\(res?["giftcard_amt_collected"] ?? "0")")
        responsevalue.append(calDiscount(disc: "\(res?["discount"] ?? "0")",
                                         gift_card: "\(res?["total_gift_card_amount"] ?? "0")",
                                         loyalty_point: "\(res?["total_loyalty_point_spent"] ?? "0")"))
        
        
        
        outdoor_dis = "\(res?["outdoor_discount"] ?? "0")"
        coupon_dis = "\(res?["coupon_discount"] ?? "0")"
        
        responsevalue.append(calRefunds(net_Refund: "\(res?["net_refund"] ?? "0")",
                                        net_Refund1: "\(res?["net_refund1"] ?? "0")",
                                        Refunded_all_tax: "\(res?["refunded_all_tax"] ?? "0")"))
        
        
        
        
        
        
        responsevalue.append(calculateNetSales(gross_sale: "\(res?["subtotal"] ?? "0")",
                                               disc: discount_amt,
                                               refund: refunds,
                                               gift_card_amt_Collected: "\(res?["giftcard_amt_collected"] ?? "0")",
                                               loyalty_amt_collected: "\(res?["loyality_amt_collected"] ?? "0")"))
        
        
        
        responsevalue.append(calculateTax(remain_default_tax: "\(res?["remain_default_tax"] ?? "0")",
                                          remain_other_tax: "\(res?["remain_other_tax"] ?? "0")"))
        
        
        
        
        
        //  responsevalue.append("\(res?["del_fee"] ?? "0")")
        responsevalue.append("\(res?["tip"] ?? "0")")
        responsevalue.append(calculateServices(con_fee: "\(res?["con_fee"] ?? "0")",
                                               d_fee: "\(res?["del_fee"] ?? "0")"))
        
        
        responsevalue.append("\(res?["cash_discounting"] ?? "0")")
        
        responsevalue.append("\(res?["cash_back_fee"] ?? "0")")
        
        
        responsevalue.append("") // blank string here
        
        responsevalue.append(calculateCard(card: "\(res?["card_collected"] ?? "0")",
                                           cash_back_amt: "\(res?["cash_back_amt"] ?? "0")",
                                           cash_back_fee: "\(res?["cash_back_fee"] ?? "0")"))
        
        responsevalue.append(calculateCash(cash: "\(res?["cash_collected"] ?? "0")",
                                           cash_back_amt: "\(res?["cash_back_amt"] ?? "0")"))
        
        
        responsevalue.append("\(res?["food_ebt_collected"] ?? "0")")
        responsevalue.append("\(res?["cash_ebt_collected"] ?? "0")")
        
        
        responsevalue.append(calculateAmountCollected(card_Collected: "\(res?["card_collected"] ?? "0")",
                                                      cash_Collected: "\(res?["cash_collected"] ?? "0")",
                                                      cash_ebt_Collected: "\(res?["cash_ebt_collected"] ?? "0")",
                                                      food_ebt_Collected: "\(res?["food_ebt_collected"] ?? "0")",
                                                      cash_back_amt: "\(res?["cash_back_amt"] ?? "0")",
                                                      cash_back_fee: "\(res?["cash_back_fee"] ?? "0")"))
        
        
        print(responsevalue)
        
        responseValues = responsevalue
        loadingIndicator.isAnimating = false
        
        self.tableView.isHidden = false
        self.noDataImage.isHidden = true
        self.dataLabel.isHidden = true
        
    }
}


extension SalesOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if responseValues.count == 0 {
            return 0
        }
        else {
            return salesArray.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SalesOverviewTableViewCell
        
        cell.salesCategory.text = salesArray[indexPath.row]
        
        if indexPath.row == 11 {
            cell.salesAmount.text = ""
        }else{
            let price = roundOf(item: responseValues[indexPath.row])
            print(price)
            let final_price = String(format:"%.02f", price)
            cell.salesAmount.text = "\u{0024}\(final_price)"
        }
        cell.infoBtn.setImage(UIImage(named: "info_black"), for: .normal)
        
        if indexPath.row == 0 {
            cell.bgImage.image = UIImage(named: "orange")
            cell.bgImage.isHidden = false
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 18)
            cell.salesCategory.textColor = UIColor(red: 206.0/255.0, green: 89.0/255.0, blue: 11.0/255.0, alpha: 1.0)
            cell.salesAmount.font = UIFont(name: "Manrope-Bold", size: 18)
        }
        
        else if indexPath.row == 5{
            cell.bgImage.image = UIImage(named: "pink")
            cell.bgImage.isHidden = false
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 18)
            cell.salesCategory.textColor = UIColor(red: 216.0/255.0, green: 11.0/255.0, blue: 81.0/255.0, alpha: 1.0)
            cell.salesAmount.font = UIFont(name: "Manrope-Bold", size: 18)
        }
        else if indexPath.row == 6 {
            cell.bgImage.isHidden = true
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 16)
            cell.salesCategory.textColor = .black
            cell.salesAmount.font = UIFont(name: "Manrope-Medium", size: 16)
        }
        
        else if indexPath.row == 8 {
            cell.bgImage.isHidden = true
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 16)
            cell.salesCategory.textColor = .black
            cell.salesAmount.font = UIFont(name: "Manrope-Medium", size: 16)
        }
        
        
        else if indexPath.row == 11 {
            cell.bgImage.image = UIImage(named: "green")
            cell.bgImage.isHidden = false
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 18)
            cell.salesCategory.textColor = UIColor(red: 20.0/255.0, green: 157.0/255.0, blue: 78.0/255.0, alpha: 1.0)
            cell.salesAmount.font = UIFont(name: "Manrope-Bold", size: 18)
        }
        
        else if indexPath.row == 16 {
            cell.bgImage.image = UIImage(named: "blue1")
            cell.bgImage.isHidden = false
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 18)
            cell.salesCategory.textColor = UIColor.blue
            cell.salesAmount.font = UIFont(name: "Manrope-Bold", size: 18)
        }
        
        else {
            cell.bgImage.isHidden = true
            cell.infoBtn.isHidden = true
            cell.salesCategory.font = UIFont(name: "Manrope-SemiBold", size: 16)
            cell.salesCategory.textColor = .black
            cell.salesAmount.font = UIFont(name: "Manrope-Medium", size: 16)
            
            
        }
        cell.infoBtn.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SalesOverviewViewController {
    
    
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
