//
//  OrderRefundDetailViewController.swift
//  
//
//  Created by Pallavi on 15/03/24.
//

import UIKit
import Alamofire

class OrderRefundDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var deliverName: UILabel!
   
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var grandTable: UITableView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var grandTableHeight: NSLayoutConstraint!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderTableHeight: NSLayoutConstraint!
    @IBOutlet weak var ScrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mapBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paymentModeTitle: UILabel!
    
    @IBOutlet weak var grandTotalValue: UILabel!
    
    @IBOutlet weak var topConstrains: NSLayoutConstraint!
    @IBOutlet weak var DobTitlelbl: UILabel!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderIdValue: UILabel!
    @IBOutlet weak var orderNumberValue: UILabel!
    @IBOutlet weak var payIdValue: UILabel!
    @IBOutlet weak var amtValue: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var RefundTableview: UITableView!
    @IBOutlet weak var orderMerchAddr: UILabel!
    
    @IBOutlet weak var merchEmail: UILabel!
    @IBOutlet weak var merchNumber: UILabel!
    @IBOutlet weak var idValue: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var IcardType: UILabel!
    @IBOutlet weak var icardTypeValue: UILabel!
    @IBOutlet weak var DateTimeVal: UILabel!
    @IBOutlet weak var modeDetail: UILabel!
    @IBOutlet weak var RefTableHeight: NSLayoutConstraint!
    @IBOutlet weak var customerOwesLbl: UILabel!
    @IBOutlet weak var paymentDetailValue: UILabel!
    @IBOutlet weak var refundedView: UIView!
    @IBOutlet weak var refundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cartRefundTable: UITableView!
    @IBOutlet weak var cartRefundTableHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryVewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var RefundedItemLbl: UILabel!
    @IBOutlet weak var delView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
   
    @IBOutlet weak var futureLBL: UILabel!
    @IBOutlet weak var futureOrder: UILabel!
    
    @IBOutlet weak var refundOrderLbl: UILabel!
    
    
    var orderId: String?
    var payId: String?
    var amount: String?
    
    var orderLiveStatus = ""
    var cash_grand = ""
    
    var  arrofCartData = [CartdataRef]()
    var  arrofRefCartData = [CartdataRef]()
    var arrofRefundData = [RefundData]()
    
    var arrofRef = [Refsummery]()
    var arrofprice = [Ordersummery]()
    var sortArrofOrder = [Ordersummery]()
    var sortArrofGrand = [Grand]()
    var sortgrand = [Grand]()
    var arrofGrand = [Grand]()
    var sortRefArr = [Refsummery]()
    var refundDetail = [[String: Any]]()
    var payRefund = [[String]]()
    var payRefundValues = [[String]]()
    var payRefundDate = [String]()
     
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var order_id: String?
    var mode: Int?
    var modetail: String?
    var merchName = ""
    var live_status = ""
    var ref_amt = ""
    var r_tax = ""
    var grand_Total = ""
    var amt_loyalty_add = ""
    var order_method = ""
    var codeCoupon = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        modeDetail.text = modetail
        
        //   deliveryAddress.layer.cornerRadius = 10
        
        tableview.delegate = self
        tableview.dataSource = self
        orderTableView.delegate = self
        orderTableView.dataSource = self
        grandTable.delegate = self
        grandTable.dataSource = self
        RefundTableview.register(UINib(nibName: "RefundHeaderCell", bundle: nil), forCellReuseIdentifier: "RefundHeaderCell")
        RefundTableview.delegate = self
        RefundTableview.dataSource = self
        cartRefundTable.delegate = self
        cartRefundTable.dataSource = self
        
        
        bgView.layer.borderWidth = 0.5
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        print(merchName)
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        tableview.estimatedSectionHeaderHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        cartRefundTable.estimatedSectionHeaderHeight = 0
        cartRefundTable.estimatedSectionFooterHeight = 0
        
        
        RefundTableview.estimatedSectionFooterHeight = 0
        grandTable.estimatedSectionHeaderHeight = 0
        grandTable.estimatedSectionFooterHeight = 0
        orderTableView.estimatedSectionHeaderHeight = 0
        orderTableView.estimatedSectionFooterHeight = 0
        
        RefundedItemLbl.text = "Refunded Item"
        modeDetail.text = "Online Order"
        
        futureLBL.isHidden = true
        futureOrder.isHidden = true
        
        scrollContent.isHidden = true
        loadingIndicator.isAnimating = true
        setupApi(order_id: order_id ?? "")
        

    
    }
    
    
 func createDeliveryStatus() {
     
     let mainWidth = view.bounds.size.width
     let height = ((mainWidth/8) +  10)
     
     let status = UIView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: height))
     
     let width = status.bounds.size.width
     let third = (mainWidth/2) - ((width/8)/2)
     
     
     let btn1 = UIButton(frame: CGRect(x: 20, y: (height - (width/8))/2, width: width/8, height: width/8))
     btn1.backgroundColor = UIColor.init(hexString: "#10C558")
     btn1.clipsToBounds = true
     btn1.setImage(UIImage(named: "Accepted"), for: .normal)
     btn1.layer.cornerRadius = (width/8) * 0.5
     
     let btn2 = UIButton(frame: CGRect(x: (third - (3 * (width/8) * 0.5)), y: (height - (width/8))/2, width: width/8, height: width/8))
     btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
     btn2.clipsToBounds = true
     btn2.setImage(UIImage(named: "UPacking"), for: .normal)
     btn2.layer.cornerRadius = (width/8) * 0.5
     
     let btn3 = UIButton(frame: CGRect(x: ((mainWidth/2) - (width/8)/2), y: (height - (width/8))/2, width: width/8, height: width/8))
     btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
     btn3.clipsToBounds = true
     btn3.setImage(UIImage(named: "UPacked"), for: .normal)
     btn3.layer.cornerRadius = (width/8) * 0.5
     
     let btn4 = UIButton(frame: CGRect(x: ((mainWidth - (3 * width/8))), y: (height - (width/8))/2, width: width/8, height: width/8))
     btn4.backgroundColor = UIColor.init(hexString: "#CECECE")
     btn4.clipsToBounds = true
     btn4.setImage(UIImage(named: "UShipped"), for: .normal)
     btn4.layer.cornerRadius = (width/8) * 0.5
     
     let btn5 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 20)), y: (height - (width/8))/2, width: width/8, height: width/8))
     btn5.backgroundColor = UIColor.init(hexString: "#CECECE")
     btn5.clipsToBounds = true
     btn5.setImage(UIImage(named: "UDelivered"), for: .normal)
     btn5.layer.cornerRadius = (width/8) * 0.5
     
     let prog1 = UIProgressView(frame: CGRect(x: btn1.frame.maxX, y: ((width/8) * 0.5), width: (btn2.frame.minX - btn1.frame.maxX), height: 1))
     prog1.backgroundColor = UIColor.init(hexString: "#CECECE")
     prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
     prog1.progressViewStyle = .bar
     prog1.setProgress(0.5, animated: true)
     
     let prog2 = UIProgressView(frame: CGRect(x: btn2.frame.maxX, y: ((width/8) * 0.5), width: (btn3.frame.minX - btn2.frame.maxX), height: 1))
     prog2.backgroundColor = UIColor.init(hexString: "#CECECE")
     prog2.progressViewStyle = .bar
     prog2.setProgress(0.0, animated: true)
     
     let prog3 = UIProgressView(frame: CGRect(x: btn3.frame.maxX, y: ((width/8) * 0.5), width: (btn4.frame.minX - btn3.frame.maxX), height: 1))
     prog3.backgroundColor = UIColor.init(hexString: "#CECECE")
     prog3.progressViewStyle = .bar
     prog3.setProgress(0.0, animated: true)
     
     let prog4 = UIProgressView(frame: CGRect(x: btn4.frame.maxX, y: ((width/8) * 0.5), width: (btn5.frame.minX - btn4.frame.maxX), height: 1))
     prog4.backgroundColor = UIColor.init(hexString: "#CECECE")
     prog4.progressViewStyle = .bar
     prog4.setProgress(0.0, animated: true)
     
     let lbl1 = UILabel(frame: CGRect(x: (btn1.frame.midX - ((width/8) * 0.5)), y: btn1.frame.maxY + 5, width: btn1.frame.size.width, height: 19))
     lbl1.text = "Accepted"
     lbl1.textAlignment = .center
     lbl1.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
     lbl1.textColor = .black
     
     let lbl2 = UILabel(frame: CGRect(x: (third - (3 * (width/8) * 0.5)), y: btn2.frame.maxY + 5, width: btn2.frame.size.width, height: 19))
     lbl2.text = "Packing"
     lbl2.textAlignment = .center
     lbl2.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
     lbl2.textColor = UIColor.init(hexString: "#CECECE")
     
     let lbl3 = UILabel(frame: CGRect(x: ((mainWidth/2) - (width/8)/2), y: btn3.frame.maxY + 5, width: btn3.frame.size.width, height: 19))
     lbl3.text = "Ready"
     lbl3.textAlignment = .center
     lbl3.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
     lbl3.textColor = UIColor.init(hexString: "#CECECE")
     
     let lbl4 = UILabel(frame: CGRect(x: ((mainWidth - (3 * width/8))), y: btn4.frame.maxY + 5, width: btn4.frame.size.width, height: 19))
     lbl4.text = "Shipped"
     lbl4.textAlignment = .center
     lbl4.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
     lbl4.textColor = UIColor.init(hexString: "#CECECE")
     
     let lbl5 = UILabel(frame: CGRect(x: (mainWidth - ((width/8) + 20)), y: btn5.frame.maxY + 5, width: btn5.frame.size.width, height: 19))
     lbl5.text = "Delivered"
     lbl5.textAlignment = .center
     lbl5.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
     lbl5.textColor = UIColor.init(hexString: "#CECECE")
     
     
     status.addSubview(btn1)
     
     status.addSubview(btn2)
     status.addSubview(btn3)
     status.addSubview(btn4)
     status.addSubview(btn5)
     
     status.addSubview(prog1)
     status.addSubview(prog2)
     status.addSubview(prog3)
     status.addSubview(prog4)
     
     status.addSubview(lbl1)
     status.addSubview(lbl2)
     status.addSubview(lbl3)
     status.addSubview(lbl4)
     status.addSubview(lbl5)
     
     statusView.addSubview(status)
     statusHeight.constant = height + 20
     
     setUpDeliveryStatus(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4, btn5: btn5,
                 prog1: prog1, prog2: prog2, prog3: prog3, prog4: prog4,
                 lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4, lbl5: lbl5)
 }
    
    
    func createPickupStatus() {
        
        let mainWidth = view.bounds.size.width
        let height = ((mainWidth/8) +  10)
        
        let status = UIView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: height))
        
        let width = status.bounds.size.width
        let third = (mainWidth/2) - (1.5 * (width/8))
        let fourth = (mainWidth/2) + (0.5 * (width/8))
        
        
        let btn1 = UIButton(frame: CGRect(x: 30, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn1.backgroundColor = UIColor.init(hexString: "#10C558")
        btn1.setImage(UIImage(named: "Accepted"), for: .normal)
        btn1.clipsToBounds = true
        btn1.layer.cornerRadius = (width/8) * 0.5

        
        let btn2 = UIButton(frame: CGRect(x: third, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn2.setImage(UIImage(named: "UPacking"), for: .normal)
        btn2.clipsToBounds = true
        btn2.layer.cornerRadius = (width/8) * 0.5

        let btn3 = UIButton(frame: CGRect(x: fourth, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn3.setImage(UIImage(named: "UPacked"), for: .normal)
        btn3.clipsToBounds = true
        btn3.layer.cornerRadius = (width/8) * 0.5

        let btn4 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 30)), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn4.backgroundColor = UIColor.init(hexString: "CECECE")
        btn4.setImage(UIImage(named: "UDelivered"), for: .normal)
        btn4.clipsToBounds = true
        btn4.layer.cornerRadius = (width/8) * 0.5

        
        let prog1 = UIProgressView(frame: CGRect(x: btn1.frame.maxX, y: ((width/8) * 0.5), width: (btn2.frame.minX - btn1.frame.maxX), height: 1))
        prog1.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
        prog1.progressViewStyle = .bar
        prog1.setProgress(0.5, animated: true)
        
        let prog2 = UIProgressView(frame: CGRect(x: btn2.frame.maxX, y: ((width/8) * 0.5), width: (btn3.frame.minX - btn2.frame.maxX), height: 1))
        prog2.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog2.progressViewStyle = .bar
        prog2.setProgress(0.0, animated: true)
        
        let prog3 = UIProgressView(frame: CGRect(x: btn3.frame.maxX, y: ((width/8) * 0.5), width: (btn4.frame.minX - btn3.frame.maxX), height: 1))
        prog3.backgroundColor = UIColor.init(hexString: "#CECECE")
        prog3.progressViewStyle = .bar
        prog3.setProgress(0.0, animated: true)
        
        
        let lbl1 = UILabel(frame: CGRect(x: (btn1.frame.midX - ((width/8) * 0.5)), y: btn1.frame.maxY + 5, width: btn1.frame.size.width, height: 19))
        lbl1.text = "Accepted"
        lbl1.textAlignment = .center
        lbl1.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl1.textColor = .black
        
        let lbl2 = UILabel(frame: CGRect(x: third, y: btn2.frame.maxY + 5, width: btn2.frame.size.width, height: 19))
        lbl2.text = "Packing"
        lbl2.textAlignment = .center
        lbl2.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl2.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl3 = UILabel(frame: CGRect(x: fourth, y: btn3.frame.maxY + 5, width: btn3.frame.size.width, height: 19))
        lbl3.text = "Ready"
        lbl3.textAlignment = .center
        lbl3.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl3.textColor = UIColor.init(hexString: "#CECECE")
        
        let lbl4 = UILabel(frame: CGRect(x: (mainWidth - ((width/8) + 30)), y: btn4.frame.maxY + 5, width: btn4.frame.size.width, height: 19))
        lbl4.text = "Picked Up"
        lbl4.textAlignment = .center
        lbl4.font = UIFont(name: "Manrope-SemiBold", size: 10.0)
        lbl4.textColor = UIColor.init(hexString: "#CECECE")
        
        status.addSubview(btn1)
        status.addSubview(btn2)
        status.addSubview(btn3)
        status.addSubview(btn4)
    
        status.addSubview(prog1)
        status.addSubview(prog2)
        status.addSubview(prog3)
        
        status.addSubview(lbl1)
        status.addSubview(lbl2)
        status.addSubview(lbl3)
        status.addSubview(lbl4)
        
        statusView.addSubview(status)
        statusHeight.constant = height + 20
        
        
       setUpPickupStatus(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4,                        
                         prog1: prog1, prog2: prog2, prog3: prog3,
                        lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4)

                        
    }
    
    

    func setUpDeliveryStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton, btn5: UIButton,
                     prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView, prog4: UIProgressView,
                     lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel, lbl5: UILabel) {
        
        
        
        
        if live_status == "Refunded" {
           
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn5.setImage(UIImage(named: "re 1"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn5.backgroundColor = UIColor.init(hexString: "#FE5353")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl5.text = "Refunded"
           
            
        }
        else if live_status == "Delivered" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Shippedonline"), for: .normal)
            btn5.setImage(UIImage(named: "Completed"), for: .normal)
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            prog4.setProgress(1.0, animated: true)
            prog4.progressTintColor =  UIColor.init(hexString: "##03CBFF")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#03CBFF")
            btn5.backgroundColor = UIColor.init(hexString: "#0A64F9")
            paymentDetailValue.text = "Paid"

            
        }
        else if live_status == "Cancelled" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn5.setImage(UIImage(named: "cancel"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn5.backgroundColor = UIColor.init(hexString: "#F55353")
            lbl5.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl5.text = "Cancelled"
        }
        else {
            
        }
       
      
}
 
    func setUpPickupStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton,
                           prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView,
                           lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel){
        
        
        print(live_status)
        
        if live_status == "Refunded" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn4.setImage(UIImage(named: "re 1"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn4.backgroundColor = UIColor.init(hexString: "#FE5353")
            lbl4.textColor = UIColor.black
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl4.text = "Refunded"
        }
        else if live_status == "Completed" {
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Completed"), for: .normal)
           
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#0A64F9")

            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.init(hexString: "#CECECE")
            lbl4.textColor = UIColor.black
        
        }
        else if live_status == "Cancelled" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn4.setImage(UIImage(named: "cancel"), for: .normal)
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            btn4.backgroundColor = UIColor.init(hexString: "#F55353")
            lbl4.textColor = UIColor.black
            lbl4.text = "Cancelled"
        }
        else {
            
        }
        
    }
    
    func roundOf(item : String) -> Double {
            
            var itemDollar = ""
            
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
    
    func setupApi(order_id: String) {
        
        let url = AppURLs.ORDER_DETAILS
        
        let parameters : [String: Any] =
        
        ["merchant_id": UserDefaults.standard.string(forKey: "merchant_id")!,
         "order_id": order_id]
        print(parameters)
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    self.getResponseValues(response: json["result"])
                    print(json)
                    self.loadingIndicator.isAnimating = false
                }
                catch {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let responsevalues = response as! [String:Any]
        let orderMerch = responsevalues["order_detail"] as! [String: Any]
        
        let order = OrderDetail(admin_id: "\(orderMerch["admin_id"] ?? "")", adv_id: "\(orderMerch["adv_id"] ?? "")",
                                amt: "\(orderMerch["amt"] ?? "")", billing_add: "\(orderMerch["billing_add"] ?? "")",
                                billing_name: "\(orderMerch["billing_name"] ?? "")", card_type: "\(orderMerch["card_type"] ?? "")",
                                card_num: "\(orderMerch["card_num"] ?? "")",
                                cash_collected: "\(orderMerch["cash_collected"] ?? "")",
                                cash_discounting: "\(orderMerch["cash_discounting"] ?? "")",
                                cash_discounting_percentage: "\(orderMerch["cash_discounting_percentage"] ?? "")",
                                cashdiscount_refund_amount: "\(orderMerch["cashdiscount_refund_amount"] ?? "")", cash_back_fee: "\(orderMerch["cash_back_fee"] ?? "")",
                                con_fee: "\(orderMerch["con_fee"] ?? "")",
                                coupon_code: "\(orderMerch["coupon_code"] ?? "")" ,
                                customer_app_id: "\(orderMerch["customer_app_id"] ?? "")",
                                customer_email: "\(orderMerch["customer_email"] ?? "")",
                                customer_phone: "\(orderMerch["customer_phone"] ?? "")",
                                customer_id: "\(orderMerch["customer_id"] ?? "")",
                                customer_time: "\(orderMerch["customer_time"] ?? "")", cvvResult: "\(orderMerch["cvvResult"] ?? "")",
                                date_time: "\(orderMerch["date_time"] ?? "")",
                                del_fee: "\(orderMerch["del_fee"] ?? "")",
                                deliver_name: "\(orderMerch["deliver_name"] ?? "")",
                                delivery_addr: "\(orderMerch["delivery_addr"] ?? "")",
                                delivery_phn: "\(orderMerch["delivery_phn"] ?? "")", discount: "\(orderMerch["discount"] ?? "")",
                                dob: "\(orderMerch["dob"] ?? "")", driver_assigned: "\(orderMerch["driver_assigned"] ?? "")",
                                email: "\(orderMerch["email"] ?? "")", employee_id: "\(orderMerch["employee_id"] ?? "")",
                                failResult: "\(orderMerch["failResult"] ?? "")", id: "\(orderMerch["id"] ?? "")",
                                is_future: "\(orderMerch["is_future"] ?? "")", is_online: "\(orderMerch["is_online"] ?? "")",
                                is_outdoor: "\(orderMerch["is_outdoor"] ?? "")", is_partial_refund: "\(orderMerch["is_partial_refund"] ?? "")",
                                is_refunded: "\(orderMerch["is_refunded"] ?? "")", is_split_payment: "\(orderMerch["is_split_payment"] ?? "")",
                                is_tried: "\(orderMerch["is_tried"] ?? "")", kitchen_receipt: "\(orderMerch["kitchen_receipt"] ?? "")",
                                live_status: "\(orderMerch["live_status"] ?? "")", m_status: "\(orderMerch["m_status"] ?? "")",
                                mail_status: "\(orderMerch["mail_status"] ?? "")", mailtriggered: "\(orderMerch["mailtriggered"] ?? "")",
                                merchant_id: "\(orderMerch["merchant_id"] ?? "")", merchant_time: "\(orderMerch["merchant_time"] ?? "")",
                                order_id: "\(orderMerch["order_id"] ?? "")", order_method: "\(orderMerch["order_method"] ?? "")",
                                order_number: "\(orderMerch["order_number"] ?? "")", order_status: "\(orderMerch["order_status"] ?? "")",
                                order_time: "\(orderMerch["order_time"] ?? "")",
                                other_taxes: "\(orderMerch["other_taxes"] ?? "")",
                                other_taxes_desc: "\(orderMerch["other_taxes_desc"] ?? "")", other_taxes_rate_desc:  "\(orderMerch["other_taxes_rate_desc"] ?? "")",
                                pax_details: "\(orderMerch["pax_details"] ?? "")",
                                payment_id: "\(orderMerch["payment_id"] ?? "")",
                                payment_result: "\(orderMerch["payment_result"] ?? "")",
                                print: "\(orderMerch["print"] ?? "")", refund_amount: "\(orderMerch["refund_amount"] ?? "")",
                                shift_setting: "\(orderMerch["shift_setting"] ?? "")", show_status: "\(orderMerch["show_status"] ?? "")",
                                smstriggerd: "\(orderMerch["smstriggerd"] ?? "")", subtotal: "\(orderMerch["subtotal"] ?? "")",
                                tax: "\(orderMerch["tax"] ?? "")", tax_rate: "\(orderMerch["tax_rate"] ?? "")",
                                tip: "\(orderMerch["tip"] ?? "")", tip_refund_amount: "\(orderMerch["tip_refund_amount"] ?? "")",
                                is_loyality:"\(orderMerch["is_loyality"] ?? "")",
                                is_store_credit: "\(orderMerch["is_store_credit"] ?? "")")
        
  
        setOrderDetails(order: order)
        let merch = responsevalues["merchant_details"] as! [[String : Any]]
        setMerchantDetails(merch: merch.first ?? [:])
        
       
        let id = responsevalues["id_card_detail"] as! [String: Any]
        setIdentificationDetails(id: id)
        
        
        let cart = responsevalues["cart_data"] as! [[String: Any]]
        setCartData(list: cart)
        
        let ref = responsevalues["refund_data"] as! [[String: Any]]
        setRefundData(refund_data: ref)
        print(ref)
        
        if responsevalues["future_order_data"] != nil {
            setFutureData(futureData: responsevalues["future_order_data"])
        }
        
        live_status = order.live_status
        order_method = order.order_method
        print(order_method)
        
        if order_method == "Pickup" || order_method == "pickup" {
            createPickupStatus()
            
        }else {
            
            createDeliveryStatus()
        }
        
       
        DispatchQueue.main.async {
            
            self.tableview.reloadData()
            self.cartRefundTable.reloadData()
            self.orderTableView.reloadData()
            self.grandTable.reloadData()
            self.RefundTableview.reloadData()
            
            self.tableHeight.constant = CGFloat(125 * self.arrofCartData.count)
            self.orderTableHeight.constant = 39 * CGFloat(self.sortArrofOrder.count)
            self.grandTableHeight.constant = 39 * CGFloat(self.sortgrand.count)
            self.RefTableHeight.constant = (39 * CGFloat(self.refundDetail.count)) + CGFloat(50 * self.getCountForHeight())
            self.cartRefundTableHeight.constant = CGFloat(125 * self.arrofRefCartData.count)
            
            
            //CGFloat(1500 + CGFloat(125 * arrofCartData.count) + CGFloat(39 * sortArrofOrder.count) + CGFloat(39 * sortgrand.count) + CGFloat(39 * sortRefArr.count) + CGFloat(125 * arrofRefCartData.count) )

            
            let onlineCartHeight = self.tableHeight.constant
            let orderHeight = self.orderTableHeight.constant
            let grandHeight = self.grandTableHeight.constant
            let refheight =  self.RefTableHeight.constant
            let refCartHeight = self.cartRefundTableHeight.constant
            
            let Height = onlineCartHeight + orderHeight + grandHeight + refheight + refCartHeight
            
            self.ScrollHeight.constant = Height + 1050
            
            self.scrollContent.isHidden = false
            self.loadingIndicator.isAnimating = false
        }
        
    }
    
    func setOrderDetails(order: OrderDetail) {
  
        orderId = order.order_id
        orderIdValue.text = orderId
        
        let order_num = order.order_number
        orderNumberValue.text = order_num
       
        payId = order.payment_id
        if  order.payment_id == "Cash" {
            paymentModeTitle.text = "Payment Mode"
            
            if order_method == "Pickup" || order_method == "pickup"{
                
                if order.live_status == "Refunded" {
                    paymentDetailValue.text = "Unpaid"
                }
                else if order.live_status == "Cancelled" {
                    paymentDetailValue.text = "Unpaid"
                    
                }
                else if order.live_status == "Completed" {
                    paymentDetailValue.text = "Paid"
                    
                }
                
            }else
            {
                if order.live_status == "Refunded" {
                    paymentDetailValue.text = "Paid"
                    
                }
                else if order.live_status == "Cancelled" {
                    paymentDetailValue.text = "Unpaid"
                    
                }
                else if order.live_status == "Delivered" {
                    paymentDetailValue.text = "Paid"
                    
                }
            }
            
            
        }
        else{
            paymentModeTitle.text = "Payment Id"
            
            if order_method == "Pickup" || order_method == "pickup"{
                if order.live_status == "Refunded" {
                    paymentDetailValue.text = "Paid"
                    
                }
                else  {
                    paymentDetailValue.text = "Paid"
                    
                }
                
            }else
            {
                if order.live_status == "Refunded" {
                    paymentDetailValue.text = "Paid"
                    
                }
                else {
                    paymentDetailValue.text = "Paid"
                    
                }
            }
            
            
        }
        
        calrefundTax(tax_r: order.tax_rate, tax: order.tax, confee: order.con_fee)
      
        if order.is_refunded  == "1" {
            refundedView.isHidden = false
            deliveryVewHeightConstaint.constant = 50
            refundHeightConstraint.constant =   50
            refundedView.backgroundColor = UIColor.init(hexString: "#EFF5FF")

        }else
         {
            refundedView.isHidden = true
            deliveryVewHeightConstaint.constant = 50
            refundHeightConstraint.constant = 0


        }
        

        let  dictionary =  convertStringToDictionary(text: order.coupon_code)
        
        let c_code = Couponcode(coupon_code: "\(dictionary["coupon_code"] ?? "")",
                                coupon_code_amt: "\(dictionary["coupon_code_amt"] ?? "")",
                                loyalty_point_earned: "\(dictionary["loyalty_point_earned"] ?? "")",
                                loyalty_point_amt_earned: "\(dictionary["loyalty_point_amt_earned"] ?? "")",
                                loyalty_point_amt_spent: "\(dictionary["loyalty_point_amt_spent"] ?? "")",
                                loyalty_point_spent: "\(dictionary["loyalty_point_spent"] ?? "")",
                                store_credit_amt_spent: "\(dictionary["store_credit_amt_spent"] ?? "")" )
        
        
        
        print(c_code)
        
        let  dic = convertStringToDictionary(text: order.other_taxes_desc)
        
        var small = [Ordersummery]()
        
        for (key, value) in dic {
          let dic_tax =   Ordersummery(sub: key, value: "\(value)")
            
            small.append(dic_tax)
            print(dic_tax)
        }
        
        if c_code.coupon_code == "" {
            codeCoupon = "Discounts"
        }else {
            codeCoupon = c_code.coupon_code
        }
        
        arrofprice = [Ordersummery(sub: "Subtotal", value: order.subtotal),
                      Ordersummery(sub: codeCoupon, value: c_code.coupon_code_amt),
                      Ordersummery(sub: "Delivery Fee", value: order.del_fee),
                      Ordersummery(sub: "Convenience Fee", value: order.con_fee),
                      Ordersummery(sub: "tip", value: order.tip),
                      Ordersummery(sub: "DefaultTax", value: order.tax)]
        
        arrofprice.append(contentsOf: small)
        
        print(arrofprice)
        
        sortArrofOrder = arrofprice.filter { $0.value != "0.00" && $0.value != "0" && $0.value != "" && $0.value != "-0.00" && $0.value != "-$0"  && $0.value != "$0.00"}
        print("^^^\(sortArrofOrder)")
        
        
        
        let credit_card =  calculate_credit(amt: order.amt, store_credit_amt_spent: c_code.store_credit_amt_spent)
        print(credit_card)
        
        calcloseGrandTotal(amt: order.amt, loy_point_amt_spend: c_code.loyalty_point_amt_spent, Refund_amt: order.refund_amount)
        
        
      
        if order.is_loyality == "0" && order.is_store_credit == "0"    {
            cash_grand = order.amt
            
        }
        else if order.is_loyality == "0" && order.is_store_credit == "1"{
            cash_grand = calstoreCreditOne(amt: order.amt, store_credit: c_code.store_credit_amt_spent)
        
        }
        else if order.is_loyality == "1" &&  order.is_store_credit == "0" {
            cash_grand = calLoyaltyPointOne(amt: amt_loyalty_add, loylty_point: c_code.loyalty_point_amt_spent)
          
        }
        else if order.is_loyality == "1" && order.is_store_credit == "1" {
            cash_grand = calStoreLoyltybothOne(amtgrandvalue: amt_loyalty_add, loylty_point: c_code.loyalty_point_amt_spent, store_credit: c_code.store_credit_amt_spent)
        }
        else {
            
        }
        
        
       // let point_applied = roundOf(item: c_code.loyalty_point_spent)
        
       // smallPaySumValue.append("(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))")
        
        
        let coupon_code = c_code.coupon_code
        let coupon_code_amt = c_code.coupon_code_amt
        
        let points_earned = c_code.loyalty_point_earned
        let points_amt_earned = c_code.loyalty_point_amt_earned
        
        let points_amt_spent = c_code.loyalty_point_amt_spent
        print(points_amt_spent)
        let points_applied = c_code.loyalty_point_spent
        
        let store_credit = c_code.store_credit_amt_spent
  
        // grandTable
        
        var smallArrGrand = [Grand]()
        
        if points_amt_spent != "0.0" && points_amt_spent != "0.00" && points_amt_spent != "-0.0" &&
            points_amt_spent != "-0.00" && points_amt_spent != "0" && points_amt_spent != ""  {
            
            smallArrGrand.append(Grand(cash: "Points Applied", cashValue:"(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))"))
        }
        
        if order.payment_id == "Cash" {
            
            if cash_grand != "0.0" && cash_grand != "0.00" && cash_grand != "-0.0" &&
                cash_grand != "-0.00" && cash_grand != "0" && cash_grand != "" && handleZero(cashValue: cash_grand)  {
                
                smallArrGrand.append(Grand(cash: "Cash", cashValue: String(format: "%.02f", roundOf(item: cash_grand))))
            }
        }
        else {
            
            if credit_card != "0.0" && credit_card != "0.00" && credit_card != "-0.0" &&
                credit_card != "-0.00" && credit_card != "0" && credit_card != "" && handleZero(cashValue: credit_card)  {
                
                smallArrGrand.append(Grand(cash: "Credit Card", cashValue: String(format: "%.02f", roundOf(item: credit_card))))
            }
        }
     
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" &&
            store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(cashValue: store_credit) {
            
            smallArrGrand.append(Grand(cash: "Store Credit", cashValue: String(format: "%.02f", roundOf(item: store_credit))))
        }
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" &&
            points_earned != "-0.00" && points_earned != "0" && points_earned != "" &&  handleZero(cashValue: points_earned) {
            
            smallArrGrand.append(Grand(cash: "Point Awarded", cashValue: String(format: "%.02f", roundOf(item: points_earned))))
        }
       
        print(sortArrofGrand)
        
        sortgrand = smallArrGrand
        print(sortgrand)
        
        if order.live_status == "Cancelled" {
            paymentDetailValue.textColor = UIColor(named: "deletBorder")
        }
        else {
            paymentDetailValue.textColor = UIColor(named: "Compeletetext")

        }
        
       
        print(sortArrofGrand)
        
        deliverName.text = merchName
        
        payIdValue.text = payId
        amount = order.amt
        amtValue.text = "$\(grand_Total)"
        print(ref_amt)
        DateTimeVal.text = order.date_time
        customerOwesLbl.text = "$0.00"
        grandTotalValue.text = "$\(grand_Total)"
        merchEmail.text = order.customer_email
        merchNumber.text = order.customer_phone
        

        
        print()
        if order.order_method == "pickup"  || order.order_method == "Pickup" {
            let bill_addres = order.billing_add
            orderMerchAddr.text = bill_addres.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
        else {
            let deli_address = order.delivery_addr
            orderMerchAddr.text = deli_address.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
        }
        
        if orderMerchAddr.text == "" {
            mapBtnHeight.constant = 0
            mapBtn.isHidden = true
        }else {
            mapBtnHeight.constant = 14
            mapBtn.isHidden = false
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
    
    
    func handleZero(cashValue : String) -> Bool   {
        print(cashValue)
         let amtValue = Double(cashValue) ?? 0.00
        print(amtValue)
        if  amtValue > 0.00{
            
            return true

        }
        else{
            return false
            
        }
    }
    
    
    func calculate_credit(amt: String , store_credit_amt_spent :String) -> String{
        let am = roundOf(item: amt)
        let scas = roundOf(item: store_credit_amt_spent)
        
        let credit_c = am - scas
        print(credit_c)
        return String(credit_c)
    }
    
    func calrefundTax(tax_r: String,tax: String, confee: String){
        let roundedTaxRate =  roundOf(item: tax_r)
        let R_tax = roundedTaxRate / 100
        let t = roundOf(item: tax)
       let  con_fee = roundOf(item: confee)
       
        let cal_Tax = R_tax * con_fee
        let tax = cal_Tax + t
        print(tax)
        r_tax = String(format: "%.2f", tax)
        
    }
    
    func calculateTotalPrice(p_price: String, q_qty :String)  -> String {
        let p_rice = roundOf(item: p_price)
        let q_ty = roundOf(item: q_qty)
        
        let t_price = p_rice * q_ty
        let final_price = String(format:"%.02f", t_price)
        
        return String(final_price)
    }
    
    func calculateTotalPriceRefund(p_price: String, r_qty :String)  -> String {
        let p_rice = roundOf(item: p_price)
        let r_ty = roundOf(item: r_qty)
        
        let t_price = p_rice * r_ty
        let final_price = String(format:"%.02f", t_price)
        
        return String(final_price)
    }
   
    func calcloseGrandTotal(amt: String , loy_point_amt_spend :String ,Refund_amt: String) {
        let am = roundOf(item: amt)
        let lpas = roundOf(item: loy_point_amt_spend)
        let ra = roundOf(item: Refund_amt)
        
        let grand_t = am + lpas
        
      let amt_plus_lp = String(format:"%.02f", grand_t)
        
        amt_loyalty_add = amt_plus_lp
       
        let final_amt = grand_t - ra
        
        var newAmt = String(format:"%.02f", final_amt)
        
        if newAmt == "0.01" || newAmt == "0.02" || newAmt == "-0.01" || newAmt == "-0.02" || newAmt == "-0.00" {
            
           grand_Total = "0.00"
        }else {
            grand_Total = String(format:"%.02f", final_amt)
        }
        
        
        
        print(grand_Total)
    }
    
    func calstoreCreditOne(amt: String,store_credit:String) -> String{
        let am =  roundOf(item: amt)
        let sc = roundOf(item: store_credit)
        print(sc)

        let store_c_one = am - sc
        let store_credit = String(format: "%.2f", store_c_one)
        return String(store_credit)
        
        
    }
    
    func calLoyaltyPointOne(amt: String,loylty_point: String) -> String {
        let am =  roundOf(item: amt)
        let lpa = roundOf(item: loylty_point)
        
       print(am)
        print(lpa)
        
        let loyalty_p_one = am - lpa
        print(loyalty_p_one)
        let loyalty_point = String(format: "%.2f", loyalty_p_one)
        return String(loyalty_point)
    }
    
    
    func calStoreLoyltybothOne(amtgrandvalue: String,loylty_point: String, store_credit:String) -> String{
        let am =  roundOf(item: amtgrandvalue)
        let lpa = roundOf(item: loylty_point)
        let sc = roundOf(item: store_credit)
        
        print(am)
        print(lpa)
        print(sc)
        
        let store_loyalty_one =  am - lpa - sc
        print(store_loyalty_one)
        let store_loyalty = String(format: "%.2f", store_loyalty_one)
    
        return String(store_loyalty)
    }
   
    func setMerchantDetails(merch: [String: Any]) {
        
        print(merch)
        
        let merch_detail = MerchantDetail(a_address_line_1: "\(merch["a_address_line_1"] ?? "")",
                                          a_address_line_2: "\(merch["a_address_line_2"] ?? "")",
                                          a_address_line_3: "\(merch["a_address_line_3"] ?? "")",
                                          a_city: "\(merch["a_city"] ?? "")", a_country: "\(merch["a_country"] ?? "")",
                                          a_phone: "\(merch["a_phone"] ?? "")", a_state: "\(merch["a_state"] ?? "")",
                                          a_zip: "\(merch["a_zip"] ?? "")", banner_img: "\(merch["banner_img"] ?? "")",
                                          email: "\(merch["email"] ?? "")", fb_url: "\(merch["fb_url"] ?? "")",
                                          img: "\(merch["img"] ?? "")", insta_url: "\(merch["insta_url"] ?? "")",
                                          lat: "\(merch["lat"] ?? "")", lng: "\(merch["lng"] ?? "")",
                                          name: "\(merch["name"] ?? "")", phone: "\(merch["phone"] ?? "")",
                                          timeZone: "\(merch["timeZone"] ?? "")")
        
        
        
    }
    
    func setIdentificationDetails(id: [String: Any]) {
        
        let id_detail = IdentificationDetail(i_card_type: "\(id["i_card_type"] ?? "")", i_card_number: "\(id["i_card_number"] ?? "")",
                                             i_card_ex_date: "\(id["i_card_ex_date"] ?? "")", i_card_dob: "\(id["i_card_dob"] ?? "")",
                                             i_card_front_img: "\(id["i_card_front_img"] ?? "")", i_card_back_img: "\(id["i_card_back_img"] ?? "")")
        
        idValue.text = id_detail.i_card_number
        if id_detail.i_card_dob == ""{
            DobTitlelbl.isHidden = true
            topConstrains.constant = 0
            bottomConstraint.constant = 0
        }else {
            DobTitlelbl.isHidden = false
            topConstrains.constant = 20
            bottomConstraint.constant = 20
        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = dateFormatter.date(from: id_detail.i_card_dob) {
//            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
//            let formattedDate = dateFormatter.string(from: date)
//            print(formattedDate)
//            dob.text = formattedDate
//        }
//        
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = dateFormat.date(from: id_detail.i_card_ex_date) {
//            dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
//            let formattedDate = dateFormat.string(from: date)
//            expiry.text = formattedDate
//        }
        
//        let dateForma = DateFormatter()
//        dateForma.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = dateForma.date(from: id_detail.i_card_ex_date) {
//            dateForma.dateFormat = "MM-dd-yyyy HH:mm"
//            let formattedDate = dateForma.string(from: date)
//            icardTypeValue.text = formattedDate
//        }
        
        dob.text = id_detail.i_card_dob
        expiry.text = id_detail.i_card_ex_date
        icardTypeValue.text = id_detail.i_card_type

    }
    
    
    func setCartData(list: Any) {
        
        let cart = list as! [[String: Any]]
        
        var smallcart = [CartdataRef]()
        var smallcartRef = [CartdataRef]()
        
        for cartItem in cart {
            
            let cart_detail = CartdataRef(line_item_id: "\(cartItem["line_item_id"] ?? "" )",
                                          variant_id: "\(cartItem["variant_id"] ?? "" )",
                                          category_id: "\(cartItem["category_id"] ?? "" )",
                                          cost_price: "\(cartItem["cost_price"] ?? "" )",
                                          name: "\(cartItem["name"] ?? "" )",
                                          is_bulk_price: "\(cartItem["is_bulk_price"] ?? "" )",
                                          bulk_price_id: "\(cartItem["bulk_price_id"] ?? "" )",
                                          qty: "\(cartItem["qty"] ?? "" )",
                                          note: "\(cartItem["note"] ?? "" )",
                                          userData: "\(cartItem["userData"] ?? "" )",
                                          taxRates: "\(cartItem["taxRates"] ?? "" )",
                                          default_tax_amount: "\(cartItem["default_tax_amount"] ?? "" )",
                                          other_taxes_amount: "\(cartItem["other_taxes_amount"] ?? "" )",
                                          other_taxes_desc: "\(cartItem["other_taxes_desc"] ?? "" )",
                                          is_refunded: "\(cartItem["is_refunded"] ?? "" )",
                                          refund_amount: "\(cartItem["refund_amount"] ?? "" )",
                                          refund_qty: "\(cartItem["refund_qty"] ?? "" )",
                                          id: "\(cartItem["id"] ?? "" )",
                                          img: "\(cartItem["img"] ?? "" )",
                                          price: "\(cartItem["price"] ?? "" )",
                                          lp_discount_amt: "\(cartItem["lp_discount_amt"] ?? "" )",
                                          coupon_code_amt: "\(cartItem["coupon_code_amt"] ?? "" )",
                                          discount_amt: "\(cartItem["discount_amt"] ?? "" )",
                                          discount_rate: "\(cartItem["discount_rate"] ?? "" )",
                                          adjust_price: "\(cartItem["adjust_price"] ?? "" )",
                                          bogo_discount: "\(cartItem["bogo_discount"] ?? "" )",
                                          use_point: "\(cartItem["use_point"] ?? "" )",
                                          earn_point: "\(cartItem["earn_point"] ?? "" )",
                                          is_lottery: "\(cartItem["is_lottery"] ?? "" )",
                                          is_adult: "\(cartItem["is_adult"] ?? "" )",
                                          other_taxes_rate_desc: "\(cartItem["other_taxes_rate_desc"] ?? "" )",
                                          other_taxes_refund_desc: "\(cartItem["other_taxes_refund_desc"] ?? "" )",
                                          default_tax_refund_amount: "\(cartItem["default_tax_refund_amount"] ?? "" )",
                                          other_taxes_refund_amount: "\(cartItem["other_taxes_refund_amount"] ?? "" )",
                                          inventory_price: "\(cartItem["inventory_price"] ?? "" )",
                                          vendor_id: "\(cartItem["vendor_id"] ?? "" )",
                                          vendor_name: "\(cartItem["vendor_name"] ?? "" )",
                                          brand_name: "\(cartItem["brand_name"] ?? "" )",
                                          brand_id: "\(cartItem["brand_id"] ?? "" )")
            
            
            if cart_detail.is_refunded == "1" {
                
                if smallcartRef.count != 0 {
                    if smallcartRef.contains(where: { $0.note == cart_detail.note }) {
                        let index = smallcartRef.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
                        let quantity = smallcartRef[index].refund_qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcartRef[index].refund_qty = String(newQty)
                    }
                    else {
                        smallcartRef.append(cart_detail)
                    }
                }
                else {
                    smallcartRef.append(cart_detail)
                }
                RefundedItemLbl.text = "Refunded Item"
                
            }
            else if cart_detail.is_refunded == "2" {
                
                if smallcartRef.count != 0 {
                    if smallcartRef.contains(where: { $0.note == cart_detail.note }) {
                        let index = smallcartRef.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
                        let quantity = smallcartRef[index].refund_qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcartRef[index].refund_qty = String(newQty)
                    }
                    else {
                        smallcartRef.append(cart_detail)
                    }
                }
                else {
                    smallcartRef.append(cart_detail)
                }
                
                if smallcart.count != 0 {
                    if smallcart.contains(where: { $0.note == cart_detail.note }) {
                        let index = smallcart.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
                        let quantity = smallcart[index].qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcart[index].qty = String(newQty)
                    }
                    else {
                        smallcart.append(cart_detail)
                    }
                }
                else {
                    smallcart.append(cart_detail)
                }
            }
            else {
                if smallcart.count != 0 {
                    if smallcart.contains(where: { $0.note == cart_detail.note }) {
                        let index = smallcart.firstIndex(where: { $0.note == cart_detail.note }) ?? 0
                        let quantity = smallcart[index].qty
                        print(quantity)
                        let newQty = (Int(quantity) ?? 0) + 1
                        smallcart[index].qty = String(newQty)
                    }
                    else {
                        smallcart.append(cart_detail)
                    }
                }
                else {
                    smallcart.append(cart_detail)
                }
                modeDetail.text = "Online Order"
                
            }
        }
        
        arrofCartData = smallcart
        arrofRefCartData = smallcartRef
        
        print(arrofCartData.count)
        print(arrofRefCartData.count)
        
        if arrofCartData.count == 0 {
            deliveryVewHeightConstaint.constant = 0
            refundHeightConstraint.constant = 50
            RefundedItemLbl.isHidden = false
            modeDetail.isHidden = true
        }
        else if arrofRefCartData.count == 0 {
            deliveryVewHeightConstaint.constant = 50
            refundHeightConstraint.constant = 0
            RefundedItemLbl.isHidden = true
            modeDetail.isHidden = false
        }
        else{
            
            deliveryVewHeightConstaint.constant = 50
            refundHeightConstraint.constant = 50
            RefundedItemLbl.isHidden = false
            modeDetail.isHidden = false
        }
        
        
        let item = arrofCartData.count
        print(item)
        let item2 = arrofRefCartData.count
        
        let cal_item = item + item2
        print(cal_item)
        
        itemLbl.text = "( \(cal_item) Item)"
    }
        
  
    func setRefundData(refund_data: Any) {
        
        let refund = refund_data as! [[String:Any]]
        refundDetail = refund
        print(refundDetail)
        
        var smallRefund = [[String]]()
        var smallRefundVal = [[String]]()
        var smallDate = [String]()
        
        for ref in refund {
            
         let refund_pay = RefundData(refund_id: "\(ref["refund_id"] ?? "")",
                                                         refunded_by_emp: "\(ref["refunded_by_emp"] ?? "")",
                                                         amount: "\(ref["amount"] ?? "")",
                                                         credit_amt: "\(ref["credit_amt"] ?? "")",
                                                         giftcard_amt: "\(ref["giftcard_amt"] ?? "")",
                                                         debit_amt: "\(ref["debit_amt"] ?? "")",
                                                         cash_amt: "\(ref["cash_amt"] ?? "")",
                                                         loyalty_point_amt: "\(ref["loyalty_point_amt"] ?? "")",
                                                         store_credit_amt: "\(ref["store_credit_amt"] ?? "")",
                                                         reason: "\(ref["reason"] ?? "")",
                                                         created_at: "\(ref["created_at"] ?? "")",
                                                         nca_amt: "\(ref["nca_amt"] ?? "")",
                                                         tip_amt: "\(ref["tip_amt"] ?? "")",
                                                         credit_refund_tax: "\(ref["credit_refund_tax"] ?? "")",
                                                         debit_refund_tax: "\(ref["debit_refund_tax"] ?? "")",
                                                         cash_refund_tax: "\(ref["cash_refund_tax"] ?? "")",
                                                         store_credit_refund_tax: "\(ref["store_credit_refund_tax"] ?? "")",
                                                         loyalty_point_refund_tax: "\(ref["loyalty_point_refund_tax"] ?? "")",
                                                         gift_card_refund_tax: "\(ref["gift_card_refund_tax"] ?? "")",
                                                         default_tax_rate: "\(ref["default_tax_rate"] ?? "")",
                                                         reward_loyalty_refund_amt: "\(ref["reward_loyalty_refund_amt"] ?? "")",
                                                         reward_loyalty_refund_point: "\(ref["reward_loyalty_refund_point"] ?? "")")
                                 
   
                

            let amt = refund_pay.amount
            let card_pay = refund_pay.debit_amt;
            let reward_loyalty_refund_amt = refund_pay.reward_loyalty_refund_amt
            let reward_loyalty_refund_point = refund_pay.reward_loyalty_refund_point
            let cash_pay = refund_pay.cash_amt
            let loyalty_amt = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
            let refund_reason = refund_pay.reason
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
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
            
            if nca_amt != "0.00" {
                smallRef.append("NCA")
                smallRefValues.append("$\(String(format: "%.02f", roundOf(item: nca_amt)))")
                
            }
            smallRefund.append(smallRef)
            print(smallRefund)
            smallRefundVal.append(smallRefValues)
            smallDate.append(create_date)
        }
        
        payRefund = smallRefund
        print(payRefund)
        payRefundValues = smallRefundVal
        payRefundDate = smallDate
        
    }
    
    func setFutureData(futureData: Any) {
        
        let f_details = futureData as! String
        
        
        if f_details == "NOW" || f_details == "now" || f_details == "" {
            futureOrder.isHidden = true
            futureLBL.isHidden = true
        }
        else {
            futureOrder.isHidden = false
            futureLBL.isHidden = false
            
            let date_sep = f_details.components(separatedBy: " ")
            
            let date_first = date_sep[0]
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let startDateCheck = dateFormat.date(from: date_first)
            
            let calendar = Calendar.current
            
            let startDay = calendar.component(.day, from: startDateCheck!)
            let startMonth = calendar.component(.month, from: startDateCheck!)
            let startYear = calendar.component(.year, from: startDateCheck!)
            
            print(startDay)
            print(startMonth)
            print(startYear)
            
            futureLBL.text = "\(startDay)-\(startMonth)-\(startYear) \(date_sep[1])"
        }
    }
    
    func calaculateRefAmt(amt: String,credit_c: String, loyalty_p: String, store_c: String,tip: String,cash_amt: String){
        let am = roundOf(item: amt)
        let cc = roundOf(item: credit_c)
        let lp = roundOf(item: loyalty_p)
        let sc = roundOf(item: store_c)
        let c_amt = roundOf(item: cash_amt)
        let tip = roundOf(item: tip)
        
        
        let add =  cc + lp + sc + c_amt + tip
        print(add)
        let sub_amt = am - add
        print(sub_amt)
        

        ref_amt = String(format: "%.2f", sub_amt)
        
        print(ref_amt)
    }
    
    
    @IBAction func homeBtn(_ sender: Any) {
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }

    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func setUpRing(button: UIImageView, color: UIColor) {
        
        let circleLayer = CAShapeLayer()
        circleLayer.path =
        UIBezierPath(ovalIn: CGRect(x: button.bounds.minX - 5,
                                    y: button.bounds.minY - 5, width: 60, height: 60)).cgPath
        button.layer.addSublayer(circleLayer)
        
        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
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

extension OrderRefundDetailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == RefundTableview {
          
            return refundDetail.count
            
        }else if tableView == cartRefundTable {
            return 1
        }
         else if tableView == tableview{
            return 1

        }
       else if tableView == grandTable{
            return 1
        }
        else{
            return 1
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderTableView {
            return sortArrofOrder.count
            
        }else if tableView == tableview {
            return  arrofCartData.count
            
        }else if tableView == cartRefundTable {
            return  arrofRefCartData.count
            
        } else if tableView == RefundTableview {
            return payRefund[section].count
            
        }else if tableView == grandTable{
            return sortgrand.count
        }else {
            return sortRefArr.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderTableView {

                let cell = orderTableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
                cell.TitleLbl.text = sortArrofOrder[indexPath.row].sub
            if cell.TitleLbl.text == codeCoupon {
                cell.priceLbl.text = "- $\(String(format:"%.02f", roundOf(item: sortArrofOrder[indexPath.row].value)))"
            }
            else {
                
                let price = roundOf(item: sortArrofOrder[indexPath.row].value)
                print(price)
                let final_price = String(format:"%.02f", price)
                print(final_price)
                cell.priceLbl.text =  "\u{0024}\(final_price)"
            }
              
                return cell
   
        }else if tableView == tableview {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "OderDetailTableViewCell", for: indexPath) as! OderDetailTableViewCell
            let price = roundOf(item: arrofCartData[indexPath.row].price)
            print(price)
            let final_price = String(format:"%.02f", price)
            print(final_price)
            cell.priceLbl.text =  "\u{0024}\(final_price)"
            let cart = arrofCartData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            cell.productLbl.text = note.replacingOccurrences(of: "Name-", with: "")
            cell.qtyLbl.text = "\(arrofCartData[indexPath.row].qty)x"
               let  t_total  =  calculateTotalPrice(p_price: arrofCartData[indexPath.row].price , q_qty: arrofCartData[indexPath.row].qty)
            
            cell.totalpriceLbl.text = "$\(t_total)"
                print(arrofCartData)
           
            return cell
            
            
        }else if tableView == RefundTableview {
            let cell = RefundTableview.dequeueReusableCell(withIdentifier: "RefundTableCell", for: indexPath) as! RefundTableCell
            cell.titleLbl.text = payRefund[indexPath.section][indexPath.row]
            cell.valueLbl.text = payRefundValues[indexPath.section][indexPath.row]
            return cell
         
        }else if tableView == cartRefundTable {
            let cell = cartRefundTable.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as! CartTableCell
            let cart = arrofRefCartData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            
            cell.productNameLbl.text = note.replacingOccurrences(of: "Name-", with: "")
            let price = roundOf(item: arrofRefCartData[indexPath.row].price)
            print(price)
            let final_price = String(format:"%.02f", price)
            cell.priceLbl.text =  "\u{0024}\(final_price)"
            cell.refQty.text = "\(arrofRefCartData[indexPath.row].refund_qty)x"
            let t_Price = calculateTotalPriceRefund(p_price: arrofRefCartData[indexPath.row].price, r_qty: arrofRefCartData[indexPath.row].refund_qty)
            cell.totalPrice.text = "$\(t_Price)"
            return cell
        }else {
            let cell = grandTable.dequeueReusableCell(withIdentifier: "GrandTableCell", for: indexPath) as!  GrandTableCell
            cell.content.text = sortgrand[indexPath.row].cash
            cell.contentValue.text =  sortgrand[indexPath.row].cashValue
            
    
            
            if cell.content.text == "Point Awarded"{
                cell.contentValue.textColor = UIColor(named: "Compeletetext")

            }else if cell.content.text == "Points Applied"  {
                cell.contentValue.textColor = UIColor.red
                cell.contentValue.text =  sortgrand[indexPath.row].cashValue

            }else {
                cell.contentValue.textColor = UIColor.black
                cell.contentValue.text =  "$\(sortgrand[indexPath.row].cashValue)"

            }
            return cell
        }
        
    }
    // headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == RefundTableview {
            let header = Bundle.main.loadNibNamed("RefundHeaderCell", owner: self)?.first as! RefundHeaderCell
            header.refDateAndTime.text = payRefundDate[section]
            return header
        }
        else {
            return nil
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableview || tableView == cartRefundTable {
            return 125
        }else {
            return UITableView.automaticDimension
        }
    }
       
    
// HeaderView Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == RefundTableview {
            return 30
        }else {
            return 0
        }
    }
      
}


struct RefundData {
    var refund_id : String
    var refunded_by_emp : String
    var amount : String
    var credit_amt: String
    var giftcard_amt: String
    var debit_amt: String
    var cash_amt: String
    var loyalty_point_amt: String
    var store_credit_amt : String
    var reason: String
    var created_at: String
    var nca_amt: String
    var tip_amt: String
    var credit_refund_tax: String
    var debit_refund_tax: String
    var cash_refund_tax: String
    var store_credit_refund_tax: String
    var loyalty_point_refund_tax: String
    var gift_card_refund_tax: String
    var default_tax_rate: String
    var reward_loyalty_refund_amt: String
    var reward_loyalty_refund_point: String
    
}


struct Refsummery {
    var sub: String
    var value: String
}
