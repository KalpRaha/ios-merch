//
//  OrdersDetailViewController.swift
//
//
//  Created by Jamaluddin Syed on 14/06/23.
//

import UIKit
import Alamofire
import SwiftUI
import Nuke


class OrdersDetailViewController: UIViewController {
    
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
    
    
    @IBOutlet weak var customerOwesLbl: UILabel!
    @IBOutlet weak var paymentDetailValue: UILabel!
    @IBOutlet weak var cardItem: UILabel!
    @IBOutlet weak var refundItemTable: UITableView!
    @IBOutlet weak var RefundItemTableHeight: NSLayoutConstraint!
    @IBOutlet weak var refundOrderTableView: UITableView!
    
    @IBOutlet weak var refudTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var RefundItemView: UIView!
    
    @IBOutlet weak var refundItemViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryView: UIView!
    
    @IBOutlet weak var delViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var RefundedItemLbl: UILabel!
    
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var futureLbl: UILabel!
    
    @IBOutlet weak var futureOrder: UILabel!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    
    
    var payId: String?
    var amount: String?
    
    
    var arrofCartData = [CartdataRef]()
    var arrofCartRefundData = [CartdataRef]()
    var arrofprice = [Ordersummery]()
    var sortArrofOrder = [Ordersummery]()
    var sortArrofGrand = [Grand]()
    var finalGrand = [Grand]()
    var sortgrand = [Grand]()
    
    var paySum = [String]()
    var paySumValue = [String]()
    
    
    
    var arrofGrand = [Grand]()
    var multiplearrofRefund =  [[String: Any]]()
    var refundDetail = [[String: Any]]()
    var payRefund = [[String]]()
    var payRefundValues = [[String]]()
    var payRefundDate = [String]()
    
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    var progressViews: [UIProgressView] = []
    
    var buttonsPickup: [UIButton] = []
    var labelsPickup: [UILabel] = []
    var progressViewsPickup: [UIProgressView] = []
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var order_id: String?
    var modetail: String?
    var merchName = ""
    var grand_Total = ""
    var store_credit_one_amt = ""
    var loyalty_point_one_amt = ""
    var store_loyalty_both_one_amt = ""
    var d_tax = ""
    var live_status = ""
    var order_method = ""
    var ready = ""
    var cash_grand = ""
    var codeCoupon = ""
    var mode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topview.addBottomShadow()
        
        
        tableview.delegate = self
        tableview.dataSource = self
        orderTableView.delegate = self
        orderTableView.dataSource = self
        grandTable.delegate = self
        grandTable.dataSource = self
        refundItemTable.dataSource = self
        refundItemTable.delegate = self
        refundOrderTableView.register(UINib(nibName: "RefundHeaderCell", bundle: nil), forCellReuseIdentifier: "RefundHeaderCell")
        refundOrderTableView.dataSource = self
        refundOrderTableView.delegate = self
        
        bgView.layer.borderWidth = 0.5
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        tableview.estimatedSectionHeaderHeight = 0
        tableview.estimatedSectionFooterHeight = 0
        refundItemTable.estimatedSectionHeaderHeight = 0
        refundItemTable.estimatedSectionFooterHeight = 0
        refundOrderTableView.estimatedSectionFooterHeight = 0
        grandTable.estimatedSectionHeaderHeight = 0
        grandTable.estimatedSectionFooterHeight = 0
        orderTableView.estimatedSectionHeaderHeight = 0
        orderTableView.estimatedSectionFooterHeight = 0
        
        futureOrder.isHidden = true
        futureLbl.isHidden = true
        
        loadingIndicator.isAnimating = true
        scrollContent.isHidden = true
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
            btn1.addTarget(self, action: #selector(acceptedClick), for: .touchUpInside)
            btn1.layer.cornerRadius = (width/8) * 0.5
            
            let btn2 = UIButton(frame: CGRect(x: (third - (3 * (width/8) * 0.5)), y: (height - (width/8))/2, width: width/8, height: width/8))
            btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
            btn2.clipsToBounds = true
            btn2.setImage(UIImage(named: "UPacking"), for: .normal)
            btn2.addTarget(self, action: #selector(packingClick), for: .touchUpInside)
            btn2.layer.cornerRadius = (width/8) * 0.5
            
            let btn3 = UIButton(frame: CGRect(x: ((mainWidth/2) - (width/8)/2), y: (height - (width/8))/2, width: width/8, height: width/8))
            btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
            btn3.clipsToBounds = true
            btn3.setImage(UIImage(named: "UPacked"), for: .normal)
            btn3.layer.cornerRadius = (width/8) * 0.5
            btn3.addTarget(self, action: #selector(readyClick), for: .touchUpInside)
            
            
            let btn4 = UIButton(frame: CGRect(x: ((mainWidth - (3 * width/8))), y: (height - (width/8))/2, width: width/8, height: width/8))
            btn4.backgroundColor = UIColor.init(hexString: "#CECECE")
            btn4.clipsToBounds = true
            btn4.setImage(UIImage(named: "UShipped"), for: .normal)
            btn4.layer.cornerRadius = (width/8) * 0.5
            btn4.addTarget(self, action: #selector(ShippedClick), for: .touchUpInside)
            
            let btn5 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 20)), y: (height - (width/8))/2, width: width/8, height: width/8))
            btn5.backgroundColor = UIColor.init(hexString: "#CECECE")
            btn5.clipsToBounds = true
            btn5.setImage(UIImage(named: "UDelivered"), for: .normal)
            btn5.layer.cornerRadius = (width/8) * 0.5
            btn5.addTarget(self, action: #selector(deliveryClick), for: .touchUpInside)
            
            
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
            
            
            
            buttons = [btn1, btn2, btn3, btn4, btn5]
            labels = [lbl1, lbl2, lbl3, lbl4, lbl5]
            progressViews = [prog1, prog2, prog3, prog4]
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
        btn1.addTarget(self, action: #selector(acceptedClick), for: .touchUpInside)
        
        
        let btn2 = UIButton(frame: CGRect(x: third, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn2.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn2.setImage(UIImage(named: "UPacking"), for: .normal)
        btn2.clipsToBounds = true
        btn2.layer.cornerRadius = (width/8) * 0.5
        btn2.addTarget(self, action: #selector(packingClick), for: .touchUpInside)
        
        let btn3 = UIButton(frame: CGRect(x: fourth, y: (height - (width/8))/2, width: width/8, height: width/8))
        btn3.backgroundColor = UIColor.init(hexString: "#CECECE")
        btn3.setImage(UIImage(named: "UPacked"), for: .normal)
        btn3.clipsToBounds = true
        btn3.layer.cornerRadius = (width/8) * 0.5
        btn3.addTarget(self, action: #selector(readyClick), for: .touchUpInside)
        
        let btn4 = UIButton(frame: CGRect(x: (mainWidth - ((width/8) + 30)), y: (height - (width/8))/2, width: width/8, height: width/8))
        btn4.backgroundColor = UIColor.init(hexString: "CECECE")
        btn4.setImage(UIImage(named: "UDelivered"), for: .normal)
        btn4.clipsToBounds = true
        btn4.layer.cornerRadius = (width/8) * 0.5
        btn4.addTarget(self, action: #selector(ShippedClick), for: .touchUpInside)
        
        
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
        
        
        
        
        buttonsPickup = [btn1, btn2, btn3, btn4]
        labelsPickup = [lbl1, lbl2, lbl3, lbl4]
        progressViewsPickup = [prog1, prog2, prog3]
        
    }
  
    
    func setUpDeliveryStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton, btn5: UIButton,
                             prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView, prog4: UIProgressView,
                             lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel, lbl5: UILabel) {
        
        print(live_status)
        
        if live_status == "Accepted" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            prog1.setProgress(0.5, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            btn1.backgroundColor = UIColor.init(hexString: "#10C558")
            lbl1.textColor = UIColor.black
            
        }
        else if live_status == "Packed" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(0.5, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.black
            
        }
        
        else if live_status == "Ready" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(0.5, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "##C520F5")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor =  UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.black
        }
        
        else if live_status == "Shipped" {
            
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Shippedonline"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#03CBFF")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.5, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            prog4.setProgress(0.5, animated: true)
            prog4.progressTintColor =  UIColor.init(hexString: "#03CBFF")
            
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor =  UIColor.init(hexString: "#CECECE")
            lbl3.textColor =  UIColor.init(hexString: "#CECECE")
            lbl4.textColor = UIColor.black
            
        }
        else  {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Shippedonline"), for: .normal)
            btn5.setImage(UIImage(named: "Completed"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#03CBFF")
            btn5.backgroundColor = UIColor.init(hexString: "#0A64F9")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            prog3.setProgress(0.5, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#0A64F9")
            
            
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor =  UIColor.init(hexString: "#CECECE")
            lbl3.textColor =  UIColor.init(hexString: "#CECECE")
            lbl4.textColor =  UIColor.init(hexString: "#CECECE")
            lbl5.textColor = UIColor.black
        }
        
    }
    
  
    func setUpPickupStatus(btn1: UIButton, btn2: UIButton, btn3: UIButton, btn4: UIButton,
                           prog1: UIProgressView, prog2: UIProgressView, prog3: UIProgressView,
                           lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel){
        
        
        print(live_status)
        if live_status == "Accepted" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            prog1.setProgress(0.5, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            lbl1.textColor = UIColor.black
        }
        else if live_status == "Packed" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(0.5, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.black
        }
        
        else if live_status == "Ready" {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(0.5, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.black
        }
        else  {
            
            btn1.setImage(UIImage(named: "Accepted"), for: .normal)
            btn2.setImage(UIImage(named: "Packing"), for: .normal)
            btn3.setImage(UIImage(named: "Packed"), for: .normal)
            btn4.setImage(UIImage(named: "Completed"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#0A64F9")
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(1.0, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            
            
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor = UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.init(hexString: "#CECECE")
            lbl4.textColor = UIColor.black
            
        }
       
    }
    
    
    func roundOf(item : String) -> Double {
        
        var itemDollar = ""
        
        if item.starts(with: "$"){
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
    
    
    func calculateTotalPrice(p_price: String, q_qty :String)  -> String {
        let p_rice = roundOf(item: p_price)
        let q_ty = roundOf(item: q_qty)
        
        let t_price = p_rice * q_ty
        print(t_price)
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
                                order_time: "\(orderMerch["order_time"] ?? "")", other_taxes: "\(orderMerch["other_taxes"] ?? "")",
                                other_taxes_desc:"\( orderMerch["other_taxes_desc"] ?? "")", other_taxes_rate_desc: "\( orderMerch["other_taxes_rate_desc"] ?? "")",
                                pax_details: "\(orderMerch["pax_details"] ?? "")",
                                payment_id: "\(orderMerch["payment_id"] ?? "")",
                                payment_result: "\(orderMerch["payment_result"] ?? "")",
                                print: "\(orderMerch["print"] ?? "")", refund_amount: "\(orderMerch["refund_amount"] ?? "")",
                                shift_setting: "\(orderMerch["shift_setting"] ?? "")", show_status: "\(orderMerch["show_status"] ?? "")",
                                smstriggerd: "\(orderMerch["smstriggerd"] ?? "")", subtotal: "\(orderMerch["subtotal"] ?? "")",
                                tax: "\(orderMerch["tax"] ?? "")", tax_rate: "\(orderMerch["tax_rate"] ?? "")",
                                tip: "\(orderMerch["tip"] ?? "")", tip_refund_amount: "\(orderMerch["tip_refund_amount"] ?? "")",
                                is_loyality: "\(orderMerch["is_loyality"] ?? "")",
                                is_store_credit: "\(orderMerch["is_store_credit"] ?? "")")
        
        setOrderDetails(order: order)
        
        if responsevalues["merchant_details"] != nil {
            setMerchantDetails(merch: responsevalues["merchant_details"] as! [[String : Any]])
        }
        
        
        if  responsevalues["id_card_detail"] != nil {
            setIdentificationDetails(id: responsevalues["id_card_detail"] as! [String : Any] )
        }
        
        
        if responsevalues["cart_data"] != nil {
            setCartData(list: responsevalues["cart_data"] as! [[String : Any]])
        }

        if responsevalues["refund_data"] != nil {
            setRefundData(refund_data:responsevalues["refund_data"] as! [[String: Any]] )
        }
        
        if responsevalues["future_order_data"] != nil {
            setFutureData(futuredata: responsevalues["future_order_data"] as! String)
        }
        
        live_status = order.live_status
        order_method = order.order_method
        
        if order.order_method ==  "pickup" || order.order_method ==  "Pickup" {
            createPickupStatus()
        }
        else {
            createDeliveryStatus()
        }
        
        if order.live_status == "Delivered" || order.live_status == "delivered"{
            paymentDetailValue.text = "Paid"
        }else {
            paymentDetailValue.text = "Unpaid"
        }

        DispatchQueue.main.async {
            
            self.tableview.reloadData()
            self.refundItemTable.reloadData()
            self.orderTableView.reloadData()
            self.grandTable.reloadData()
            self.refundOrderTableView.reloadData()
            
            self.tableHeight.constant = CGFloat(125 * self.arrofCartData.count)
            self.orderTableHeight.constant = 39 * CGFloat(self.sortArrofOrder.count)
            self.grandTableHeight.constant = 39 * CGFloat(self.sortgrand.count)
            self.refudTableHeight.constant = (39 * CGFloat(self.refundDetail.count)) + CGFloat(50 * self.getCountForHeight())
            self.RefundItemTableHeight.constant = CGFloat(125 * self.arrofCartRefundData.count)
            
            
            
            let onlineCartHeight = self.tableHeight.constant
            let orderHeight = self.orderTableHeight.constant
            let grandHeight = self.grandTableHeight.constant
            let refheight =  self.refudTableHeight.constant
            let refCartHeight = self.RefundItemTableHeight.constant
            
            
            let height =  onlineCartHeight + orderHeight + grandHeight + refheight + refCartHeight
            
            
            self.ScrollHeight.constant = height + 1000
            
            self.loadingIndicator.isAnimating = false
            self.scrollContent.isHidden = false
            
            //CGFloat(1500 + CGFloat(125 * arrofCartData.count) + CGFloat(39 * sortArrofOrder.count) + CGFloat(39 * sortgrand.count) + (30 * CGFloat.refundDetail.count) + CGFloat(50 * self.getCountForHeight()) + CGFloat(125 * arrofCartRefundData.count))
        }
   
    }
    
    
    
    func setOrderDetails(order: OrderDetail) {
        
        orderIdValue.text = order_id
        
        let order_num = order.order_number
        orderNumberValue.text = order_num
        
        payId = order.payment_id
        
        if  order.payment_id == "Cash" {
            paymentModeTitle.text = "Payment Mode"
            paymentDetailValue.text = "Unpaid"
        }else{
            paymentModeTitle.text = "Payment Id"
            paymentDetailValue.text = "Paid"
        }
        payIdValue.text = payId
        
        
        DateTimeVal.text = order.date_time
        print(grand_Total)
        
        calrefundTax(tax_r: order.tax_rate, tax: order.tax)
        
        
        
        
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
        
        if c_code.coupon_code == ""  {
            codeCoupon = "Discounts"
            print(c_code.coupon_code)
        }else {
            codeCoupon = c_code.coupon_code
            print(c_code.coupon_code)
        }
       
        
        arrofprice = [Ordersummery(sub: "Subtotal", value: order.subtotal),
                      Ordersummery(sub: codeCoupon, value:  c_code.coupon_code_amt),
                      Ordersummery(sub: "Delivery Fee", value: order.del_fee),
                      Ordersummery(sub: "Convenience Fee", value: order.con_fee),
                      Ordersummery(sub: "tip", value: order.tip),
                      Ordersummery(sub: "DefaultTax", value: order.tax)]
        
        arrofprice.append(contentsOf: small)
        
        
        print(arrofprice)
        
        
        sortArrofOrder = arrofprice.filter { $0.value != "0.00" && $0.value != "0" && $0.value != "" && $0.value != "-0.00" && $0.value != "-$0"  && $0.value != "$0.00" && $0.value != "<null>"  && $0.value != "- 0.00" && $0.value != "- $0" }
            print("^^^\(sortArrofOrder)")
        
       
        
        
        let credit_card =  calculatecredit(amt: order.amt, store_credit_amt_spent: c_code.store_credit_amt_spent)
        print(credit_card)
        
        
        
        calGrandTotal(amt: order.amt, loy_point_amt_spend: c_code.loyalty_point_amt_spent, refund_amt: order.refund_amount)
        
        
        
        if order.is_loyality == "0" && order.is_store_credit == "0"    {
            cash_grand = order.amt
            
        }
        else if order.is_loyality == "0" && order.is_store_credit == "1" {
            cash_grand = calstoreCreditOne(amt: order.amt, store_credit: c_code.store_credit_amt_spent)
            
        }
        else if order.is_loyality == "1" &&  order.is_store_credit == "0" {
            cash_grand = calLoyaltyPointOne(amt: grand_Total, loylty_point: c_code.loyalty_point_amt_spent)
            
        }
        else if order.is_loyality == "1" && order.is_store_credit == "1" {
            cash_grand = calStoreLoyltybothOne(amtgrandvalue: grand_Total, loylty_point: c_code.loyalty_point_amt_spent, store_credit: c_code.store_credit_amt_spent)
        }
        else {
            
        }
        
      
        
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
                credit_card != "-0.00" && credit_card != "0" && credit_card != ""  && handleZero(cashValue: credit_card){
                
                smallArrGrand.append(Grand(cash: "Credit Card", cashValue: String(format: "%.02f", roundOf(item: credit_card))))
            }
        }
        
        
        if store_credit != "0.0" && store_credit != "0.00" && store_credit != "-0.0" &&
            store_credit != "-0.00" && store_credit != "0" && store_credit != "" && handleZero(cashValue: store_credit) {
            
            smallArrGrand.append(Grand(cash: "Store Credit", cashValue: String(format: "%.02f", roundOf(item: store_credit))))
        }
        
        if points_earned != "0.0" && points_earned != "0.00" && points_earned != "-0.0" &&
            points_earned != "-0.00" && points_earned != "0" && points_earned != "" && handleZero(cashValue: points_earned) {
            
            smallArrGrand.append(Grand(cash: "Point Awarded", cashValue: String(format: "%.02f", roundOf(item: points_earned))))
        }
        
        
        
        
        //        arrofGrand = [Grand(cash: "Points Applied", cashValue:"(-\(String(format: "%.02f", roundOf(item: points_applied))))-$\(String(format: "%.02f", roundOf(item: points_amt_spent)))"),
        //                      grand(cash: "Credit Card", cashValue: (String(format: "%.02f", roundOf(item: credit_card)))),
        //                      grand(cash: "Cash", cashValue: (String(format: "%.02f", roundOf(item: cash_grand)))),
        //                      grand(cash: "Store Credit", cashValue: (String(format: "%.02f", roundOf(item: store_credit)))),
        //                      grand(cash: "Point Awarded", cashValue: (String(format: "%.02f", roundOf(item: points_earned))))
        //        ]
        
        
        //        print(arrofGrand)
        //
        //        sortArrofGrand = arrofGrand.filter{ $0.cashValue != "$0.00"  && $0.cashValue != "$0" && $0.cashValue != ""  && $0.cashValue != "0.00"  &&  $0.cashValue != "0" &&  $0.cashValue != "(-0.00)-$0"   &&  $0.cashValue != "(0)-$0"  && $0.cashValue != "(-0.00)-$0.00" && $0.cashValue != "(-0)-$0" && $0.cashValue != "-0.01" && $0.cashValue != "-0.02" && $0.cashValue != "0.01" && $0.cashValue != "0.02" && $0.cashValue != "-0.03"}
        //
        
        
        sortgrand = smallArrGrand
        print(sortgrand)
        
        
        
        //        if order.payment_id != "Cash" {
        //           sortgrand = sortArrofGrand.filter{ $0.cash != "Cash"}
        //
        //
        //        } else {
        //            sortgrand = sortArrofGrand.filter{ $0.cash != "Credit Card"}
        //        }
        print(sortgrand)
        
      
        
        deliverName.text = merchName
        
        amtValue.text = "$\(grand_Total)"
        grandTotalValue.text = "$\(grand_Total)"
        merchEmail.text = order.customer_email
        merchNumber.text = order.customer_phone
        customerOwesLbl.text = "$0.00"
        
        
        
        if order.order_method == "pickup" || order.order_method == "Pickup" {
            
            let bill_addres = order.billing_add
            orderMerchAddr.text = bill_addres.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
        }else {
            
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

        if order.is_refunded == "0" {
            RefundItemView.isHidden = true
            refundItemViewHeight.constant = 0
            
        }else
        {
            RefundItemView.isHidden = false
            RefundItemView.backgroundColor = UIColor.init(hexString: "#EFF5FF")
            refundItemViewHeight.constant = 50
        }
    }
    
    func getCountForHeight() -> Int {
        var counter = 0
        print(payRefund.count)
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
    
    
    
    
    func calculatecredit(amt: String , store_credit_amt_spent :String) -> String {
        let am = roundOf(item: amt)
        let scas = roundOf(item: store_credit_amt_spent)
        
        let credit_c = am - scas
        print(credit_c)
        return String(credit_c)
    }
    
    func calGrandTotal(amt: String , loy_point_amt_spend :String, refund_amt: String) {
        
        let am = roundOf(item: amt)
        let lpas = roundOf(item: loy_point_amt_spend)
        let ra = roundOf(item: refund_amt)
        
        let grand_t = am + lpas
        let final_p =  grand_t - ra
        
        // grand_Total = String(format:"%.02f", final_p)
        
        let newAmt = String(format:"%.02f", final_p)
        
        if newAmt == "0.01" || newAmt == "0.02" || newAmt == "-0.01" || newAmt == "-0.02" || newAmt == "-0.00" ||  newAmt == "0"{
            
            grand_Total = "0.00"
        }else {
            grand_Total = String(format:"%.02f", final_p)
        }

    }
    
    func calrefundTax(tax_r: String,tax: String) {
        let roundedTaxRate =  roundOf(item: tax_r)
        let R_tax = roundedTaxRate / 100
        let t = roundOf(item: tax)
        
        let cal_Tax = R_tax + t
        
        d_tax = String(format: "%.2f", cal_Tax)
        
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
    
    
    func setMerchantDetails(merch: [[String: Any]]) {
        
        for item in merch {
            
            let merch_detail = MerchantDetail(a_address_line_1: "\(item["a_address_line_1"] ?? "")",
                                              a_address_line_2: "\(item["a_address_line_2"] ?? "")",
                                              a_address_line_3: "\(item["a_address_line_3"] ?? "")",
                                              a_city: "\(item["a_city"] ?? "")", a_country: "\(item["a_country"] ?? "")",
                                              a_phone: "\(item["a_phone"] ?? "")", a_state: "\(item["a_state"] ?? "")",
                                              a_zip: "\(item["a_zip"] ?? "")", banner_img: "\(item["banner_img"] ?? "")",
                                              email: "\(item["email"] ?? "")", fb_url: "\(item["fb_url"] ?? "")",
                                              img: "\(item["img"] ?? "")", insta_url: "\(item["insta_url"] ?? "")",
                                              lat: "\(item["lat"] ?? "")", lng: "\(item["lng"] ?? "")",
                                              name: "\(item["name"] ?? "")", phone: "\(item["phone"] ?? "")",
                                              timeZone: "\(item["timeZone"] ?? "")")
            
            
            
            
        }
    }
    
    func setIdentificationDetails(id: [String: Any]) {
        
        let id_detail = IdentificationDetail(i_card_type: "\(id["i_card_type"] ?? "")",
                                             i_card_number: "\(id["i_card_number"] ?? "")",
                                             i_card_ex_date: "\(id["i_card_ex_date"] ?? "")",
                                             i_card_dob: "\(id["i_card_dob"] ?? "")",
                                             i_card_front_img: "\(id["i_card_front_img"] ?? "")",
                                             i_card_back_img: "\(id["i_card_back_img"] ?? "")")
        
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
        dob.text = id_detail.i_card_dob
        expiry.text = id_detail.i_card_ex_date
        icardTypeValue.text = id_detail.i_card_type
        
        // icardImageView.image = UIImage(named: id_detail.i_card_back_img)
        //
        //        let img_url = "\(AppURLs.ORDER_CARD_IMAGE)\(id_detail.i_card_back_img)"
        //        Nuke.loadImage(with: img_url , into: icardImageView)
        //        print(img_url)
    }
    
    
    func setCartData(list: Any){
        
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
            
            
            
            print(cart_detail)
            
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
                
                RefundedItemLbl.text = "Refunded Item"
                modeDetail.text = "Online Order"
                
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
        arrofCartRefundData = smallcartRef
        
        let item = arrofCartData.count
        print(item)
        let item2 = arrofCartRefundData.count
        
        let cal_item = item + item2
        print(cal_item)
        
        cardItem.text = "( \(cal_item))"
        
        
        if arrofCartData.count == 0 {
            delViewheightConstraint.constant = 0
            refundItemViewHeight.constant = 50
            RefundedItemLbl.isHidden = false
            modeDetail.isHidden = true
        }
        else if arrofCartRefundData.count == 0 {
            delViewheightConstraint.constant = 50
            refundItemViewHeight.constant = 0
            RefundedItemLbl.isHidden = true
            modeDetail.isHidden = false
        }
        else{
            
            delViewheightConstraint.constant = 50
            refundItemViewHeight.constant = 50
            RefundedItemLbl.isHidden = false
            modeDetail.isHidden = false
        }
        
    }
    
    
    
    
    
    
    
    func setRefundData(refund_data: Any) {
        
        let refund = refund_data as! [[String:Any]]
        refundDetail = refund
        
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
            let card_pay = refund_pay.debit_amt
            let cash_pay = refund_pay.cash_amt
            let loyalty_amt = refund_pay.loyalty_point_amt
            let store_cred = refund_pay.store_credit_amt
            let refund_reason = refund_pay.reason
            let create_date = refund_pay.created_at
            let tip_amt = refund_pay.tip_amt
            let nca_amt = refund_pay.nca_amt
            let reward_loyalty_refund_amt = refund_pay.reward_loyalty_refund_amt
            let reward_loyalty_refund_point = refund_pay.reward_loyalty_refund_point
            
            
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
    
    func setFutureData(futuredata: Any){
        
        let f_details = futuredata as! String
        
        print(f_details)
        print(f_details)
        
        if f_details == "NOW" || f_details == "now" || f_details == "" {
            futureOrder.isHidden = true
            futureLbl.isHidden = true
        }
        else {
            futureOrder.isHidden = false
            futureLbl.isHidden = false
            
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
            
            futureLbl.text = "\(startDay)-\(startMonth)-\(startYear) \(date_sep[1])"
        }
    }
    
    
    
    @objc func acceptedClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            
            let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let od = order_id ?? ""
            
            ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "1")
            { isSuccess, responseData in
                
                if isSuccess {
                    
                    if  self.order_method == "pickup" || self.order_method == "Pickup" {
                        
                        let acceptLbl = self.labelsPickup[0]
                        acceptLbl.textColor = UIColor.black
                        let packingLbl = self.labelsPickup[1]
                        packingLbl.textColor = UIColor.init(hexString: "CECECE")
                        let readylbl = self.labelsPickup[2]
                        readylbl.textColor = UIColor.init(hexString: "CECECE")
                        let shippedlbl = self.labelsPickup[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        
                        let acceptBtn = self.buttonsPickup[0]
                        let packingbtn = self.buttonsPickup[1]
                        packingbtn.setImage(UIImage(named: "UPacking"), for: .normal)
                        
                        let readybtn = self.buttonsPickup[2]
                        readybtn.setImage(UIImage(named: "UPacked"), for: .normal)
                        let shippedBtn = self.buttonsPickup[3]
                        shippedBtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        readybtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        
                        
                        let acceptedProgress = self.progressViewsPickup[0]
                        acceptedProgress.setProgress(0.5, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViewsPickup[1]
                        packingProgress.setProgress(0.0, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        let readyProgress = self.progressViewsPickup[2]
                        readyProgress.setProgress(0.0, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                    }
                    
                    else {
                        let acceptLbl = self.labels[0]
                        acceptLbl.textColor = UIColor.black
                        let packingLbl = self.labels[1]
                        packingLbl.textColor = UIColor.init(hexString: "CECECE")
                        let readylbl = self.labels[2]
                        readylbl.textColor = UIColor.init(hexString: "CECECE")
                        let shippedlbl = self.labels[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        let diliveredLbl = self.labels[4]
                        diliveredLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingbtn = self.buttons[1]
                        packingbtn.setImage(UIImage(named: "UPacking"), for: .normal)
                        
                        let readybtn = self.buttons[2]
                        readybtn.setImage(UIImage(named: "UPacked"), for: .normal)
                        let shippedBtn = self.buttons[3]
                        shippedBtn.setImage(UIImage(named: "UShipped"), for: .normal)
                        let deliveredbtn = self.buttons[4]
                        deliveredbtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        readybtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        deliveredbtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        
                        
                        let acceptedProgress = self.progressViews[0]
                        acceptedProgress.setProgress(0.5, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViews[1]
                        packingProgress.setProgress(0.0, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        let readyProgress = self.progressViews[2]
                        readyProgress.setProgress(0.0, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        let shippedProgress = self.progressViews[3]
                        shippedProgress.setProgress(0.0, animated: true)
                        shippedProgress.progressTintColor = UIColor.init(hexString: "#00CBFF" )
                        
                        
                    }
                    
                }
                
                else {
                    
                }
            }
        }
    }
    
    @objc func packingClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            
            let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let od = order_id ?? ""
            
            ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "2") { isSuccess, responseData in
                
                if isSuccess {
                    
                    if   self.order_method == "pickup" || self.order_method == "Pickup" {
                        
                        let acceptLbl = self.labelsPickup[0]
                        acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingLbl = self.labelsPickup[1]
                        packingLbl.textColor = UIColor.black
                        
                        let readylbl = self.labelsPickup[2]
                        readylbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let shippedlbl = self.labelsPickup[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        
                        let acceptedProgress = self.progressViewsPickup[0]
                        acceptedProgress.setProgress(1.0, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViewsPickup[1]
                        packingProgress.setProgress(0.5, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        
                        let readyProgress = self.progressViewsPickup[2]
                        readyProgress.setProgress(0.0, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        
                        
                        
                        let packingbtn = self.buttonsPickup[1]
                        packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                        let readybtn = self.buttonsPickup[2]
                        readybtn.setImage(UIImage(named: "UPacked"), for: .normal)
                        let shippedBtn = self.buttonsPickup[3]
                        shippedBtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                        readybtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        
                        
                    }
                    else {
                        
                        
                        let acceptLbl = self.labels[0]
                        acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingLbl = self.labels[1]
                        packingLbl.textColor = UIColor.black
                        
                        let readylbl = self.labels[2]
                        readylbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let shippedlbl = self.labels[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let delLbl = self.labels[4]
                        delLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let acceptedProgress = self.progressViews[0]
                        acceptedProgress.setProgress(1.0, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViews[1]
                        packingProgress.setProgress(0.5, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        
                        let readyProgress = self.progressViews[2]
                        readyProgress.setProgress(0.0, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        let shippedProgress = self.progressViews[3]
                        shippedProgress.setProgress(0.0, animated: true)
                        shippedProgress.progressTintColor = UIColor.init(hexString: "#00CBFF" )
                        
                        
                        let packingbtn = self.buttons[1]
                        packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                        let readybtn = self.buttons[2]
                        readybtn.setImage(UIImage(named: "UPacked"), for: .normal)
                        let shippedBtn = self.buttons[3]
                        shippedBtn.setImage(UIImage(named: "UShipped"), for: .normal)
                        let deliveredbtn = self.buttons[4]
                        deliveredbtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                        readybtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        deliveredbtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                    }
                    
                }
                else {
                    
                }
            }
        }
    }
    
    @objc func readyClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            var readystatus = ""
            let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let od = order_id ?? ""
            
            if order_method == "pickup" || order_method == "Pickup" {
                readystatus = "3"
            }
            else {
                readystatus = "6"
            }
            
            ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: readystatus) { isSuccess, responseData in
                
                if isSuccess {
                    
                    if   self.order_method == "pickup" || self.order_method == "Pickup"  {
                        
                        let acceptLbl = self.labelsPickup[0]
                        acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingLbl = self.labelsPickup[1]
                        packingLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let readylbl = self.labelsPickup[2]
                        readylbl.textColor = UIColor.black
                        
                        let shippedlbl = self.labelsPickup[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let acceptedProgress = self.progressViewsPickup[0]
                        acceptedProgress.setProgress(1.0, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViewsPickup[1]
                        packingProgress.setProgress(1.0, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        
                        let readyProgress = self.progressViewsPickup[2]
                        readyProgress.setProgress(0.5, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        let packingbtn = self.buttonsPickup[1]
                        packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                        let readybtn = self.buttonsPickup[2]
                        readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                        let shippedBtn = self.buttonsPickup[3]
                        shippedBtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                        readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        
                    }
                    else {
                        
                        
                        let acceptLbl = self.labels[0]
                        acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingLbl = self.labels[1]
                        packingLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let readylbl = self.labels[2]
                        readylbl.textColor = UIColor.black
                        
                        let shippedlbl = self.labels[3]
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let delLbl = self.labels[4]
                        delLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        
                        
                        let acceptedProgress = self.progressViews[0]
                        acceptedProgress.setProgress(1.0, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViews[1]
                        packingProgress.setProgress(1.0, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        
                        let readyProgress = self.progressViews[2]
                        readyProgress.setProgress(0.5, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        let shippedProgress = self.progressViews[3]
                        shippedProgress.setProgress(0.0, animated: true)
                        shippedProgress.progressTintColor = UIColor.init(hexString: "#00CBFF" )
                        
                        let packingbtn = self.buttons[1]
                        packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                        let readybtn = self.buttons[2]
                        readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                        let shippedBtn = self.buttons[3]
                        shippedBtn.setImage(UIImage(named: "UShipped"), for: .normal)
                        let deliveredbtn = self.buttons[4]
                        deliveredbtn.setImage(UIImage(named: "UDelivered"), for: .normal)
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                        readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                        deliveredbtn.backgroundColor = UIColor.init(hexString: "#CECECE")
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    
    @objc func ShippedClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        
        else {
            
            if order_method == "pickup" || order_method == "Pickup"{
                var status = ""
                let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                let od = order_id ?? ""
                
                if order_method == "pickup" || order_method == "Pickup"{
                    status = "4"
                }
                else {
                    status = "3"
                }
                
                ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: status) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        if   self.order_method == "pickup" || self.order_method == "Pickup"  {
                            
                            let acceptLbl = self.labelsPickup[0]
                            acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let packingLbl = self.labelsPickup[1]
                            packingLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let readylbl = self.labelsPickup[2]
                            readylbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            
                            let shippedlbl = self.labelsPickup[3]
                            shippedlbl.text = "Picked Up"
                            shippedlbl.textColor = UIColor.black
                            
                            
                            let acceptedProgress = self.progressViewsPickup[0]
                            acceptedProgress.setProgress(1.0, animated: true)
                            acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                            
                            let packingProgress = self.progressViewsPickup[1]
                            packingProgress.setProgress(1.0, animated: true)
                            packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                            
                            
                            let readyProgress = self.progressViewsPickup[2]
                            readyProgress.setProgress(1.0, animated: true)
                            readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                            
                            
                            let packingbtn = self.buttonsPickup[1]
                            packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                            let readybtn = self.buttonsPickup[2]
                            readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                            let shippedBtn = self.buttonsPickup[3]
                            shippedBtn.setImage(UIImage(named: "Completed"), for: .normal)
                            
                            
                            packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                            readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                            shippedBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                            
                            
                            
                        }else {
                            
                            
                            let acceptLbl = self.labels[0]
                            acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let packingLbl = self.labels[1]
                            packingLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let readylbl = self.labels[2]
                            readylbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            
                            let shippedlbl = self.labels[3]
                            shippedlbl.text = "Shipped"
                            shippedlbl.textColor = UIColor.black
                            
                            let delLbl = self.labels[4]
                            delLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            
                            let packingbtn = self.buttons[1]
                            packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                            let readybtn = self.buttons[2]
                            readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                            let shippedBtn = self.buttons[3]
                            shippedBtn.setImage(UIImage(named: "Shippedonline"), for: .normal)
                            
                            
                            
                            let acceptedProgress = self.progressViews[0]
                            acceptedProgress.setProgress(1.0, animated: true)
                            acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                            
                            let packingProgress = self.progressViews[1]
                            packingProgress.setProgress(1.0, animated: true)
                            packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                            
                            
                            let readyProgress = self.progressViews[2]
                            readyProgress.setProgress(1.0, animated: true)
                            readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                            
                            let shippedProgress = self.progressViews[3]
                            shippedProgress.setProgress(0.5, animated: true)
                            shippedProgress.progressTintColor = UIColor.init(hexString: "#03CBFF")
                            
                            packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                            readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                            shippedBtn.backgroundColor = UIColor.init(hexString: "#03CBFF")
                            
                        }
                        
                    }
                    else {
                        
                    }
                }
            }
            
            else {
                
                if UserDefaults.standard.string(forKey: "dispatch_status_delivery") == "1" {
                    ToastClass.sharedToast.showToast(message: "Driver must claim this order from Dispatch Center", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else {
                    var status = ""
                    let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                    let od = order_id ?? ""
                    
                    if order_method ==  "pickup" || order_method ==  "Pickup" {
                        status = "4"
                    }
                    else {
                        status = "3"
                    }
                    
                    ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: status) { isSuccess, responseData in
                        
                        if isSuccess {
                            
                            if   self.order_method == "pickup" || self.order_method == "Pickup"  {
                                
                                let acceptLbl = self.labelsPickup[0]
                                acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                let packingLbl = self.labelsPickup[1]
                                packingLbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                let readylbl = self.labelsPickup[2]
                                readylbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                
                                let shippedlbl = self.labelsPickup[3]
                                shippedlbl.text = "Picked Up"
                                shippedlbl.textColor = UIColor.black
                                
                                
                                let acceptedProgress = self.progressViewsPickup[0]
                                acceptedProgress.setProgress(1.0, animated: true)
                                acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                                
                                let packingProgress = self.progressViewsPickup[1]
                                packingProgress.setProgress(1.0, animated: true)
                                packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                                
                                
                                let readyProgress = self.progressViewsPickup[2]
                                readyProgress.setProgress(1.0, animated: true)
                                readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                                
                                
                                let packingbtn = self.buttonsPickup[1]
                                packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                                let readybtn = self.buttonsPickup[2]
                                readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                                let shippedBtn = self.buttonsPickup[3]
                                shippedBtn.setImage(UIImage(named: "Completed"), for: .normal)
                                
                                
                                packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                                readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                                shippedBtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                                
                            }
                            else {
                                
                                
                                let acceptLbl = self.labels[0]
                                acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                let packingLbl = self.labels[1]
                                packingLbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                let readylbl = self.labels[2]
                                readylbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                
                                let shippedlbl = self.labels[3]
                                shippedlbl.text = "Shipped"
                                shippedlbl.textColor = UIColor.black
                                
                                let delLbl = self.labels[4]
                                delLbl.textColor = UIColor.init(hexString: "CECECE")
                                
                                
                                let packingbtn = self.buttons[1]
                                packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                                let readybtn = self.buttons[2]
                                readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                                let shippedBtn = self.buttons[3]
                                shippedBtn.setImage(UIImage(named: "Shippedonline"), for: .normal)
                                
                                let acceptedProgress = self.progressViews[0]
                                acceptedProgress.setProgress(1.0, animated: true)
                                acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                                
                                let packingProgress = self.progressViews[1]
                                packingProgress.setProgress(1.0, animated: true)
                                packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                                
                                
                                let readyProgress = self.progressViews[2]
                                readyProgress.setProgress(1.0, animated: true)
                                readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                                
                                let shippedProgress = self.progressViews[3]
                                shippedProgress.setProgress(0.5, animated: true)
                                shippedProgress.progressTintColor = UIColor.init(hexString: "#03CBFF")
                                
                                packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                                readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                                shippedBtn.backgroundColor = UIColor.init(hexString: "#03CBFF")
                                
                            }
                            
                        }
                        else {
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func deliveryClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
            
            if   self.order_method == "pickup" || self.order_method == "Pickup"  {
                
                let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                let od = order_id ?? ""
                ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "4") { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        
                        let acceptLbl = self.labels[0]
                        acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let packingLbl = self.labels[1]
                        packingLbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let readylbl = self.labels[2]
                        readylbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        
                        let shippedlbl = self.labels[3]
                        shippedlbl.text = "Shipped"
                        shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                        
                        let delLbl = self.labels[4]
                        delLbl.textColor = UIColor.black
                        
                        
                        let packingbtn = self.buttons[1]
                        packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                        let readybtn = self.buttons[2]
                        readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                        let shippedBtn = self.buttons[3]
                        shippedBtn.setImage(UIImage(named: "Delivery"), for: .normal)
                        let deliveredbtn = self.buttons[4]
                        deliveredbtn.setImage(UIImage(named: "Completed"), for: .normal)
                        
                        
                        
                        let acceptedProgress = self.progressViews[0]
                        acceptedProgress.setProgress(1.0, animated: true)
                        acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                        
                        let packingProgress = self.progressViews[1]
                        packingProgress.setProgress(1.0, animated: true)
                        packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                        
                        
                        let readyProgress = self.progressViews[2]
                        readyProgress.setProgress(1.0, animated: true)
                        readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                        
                        let shippedProgress = self.progressViews[3]
                        shippedProgress.setProgress(1.0, animated: true)
                        shippedProgress.progressTintColor = UIColor.init(hexString: "#03CBFF")
                        
                        packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                        readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                        shippedBtn.backgroundColor = UIColor.init(hexString: "#03CBFF")
                        deliveredbtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                        
                    }
                }
            }
            else {
                
                if UserDefaults.standard.string(forKey: "dispatch_status_delivery") == "1" {
                    ToastClass.sharedToast.showToast(message: "Driver must confirm delivery Dispatch Center", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                }
                
                else {
                    
                    let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
                    let od = order_id ?? ""
                    ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "4") { isSuccess, responseData in
                        
                        if isSuccess {
                            
                            
                            let acceptLbl = self.labels[0]
                            acceptLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let packingLbl = self.labels[1]
                            packingLbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let readylbl = self.labels[2]
                            readylbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            
                            let shippedlbl = self.labels[3]
                            shippedlbl.text = "Shipped"
                            shippedlbl.textColor = UIColor.init(hexString: "CECECE")
                            
                            let delLbl = self.labels[4]
                            delLbl.textColor = UIColor.black
                            
                            
                            let packingbtn = self.buttons[1]
                            packingbtn.setImage(UIImage(named: "Packing"), for: .normal)
                            let readybtn = self.buttons[2]
                            readybtn.setImage(UIImage(named: "Packed"), for: .normal)
                            let shippedBtn = self.buttons[3]
                            shippedBtn.setImage(UIImage(named: "Delivery"), for: .normal)
                            let deliveredbtn = self.buttons[4]
                            deliveredbtn.setImage(UIImage(named: "Completed"), for: .normal)
                            
                            
                            
                            let acceptedProgress = self.progressViews[0]
                            acceptedProgress.setProgress(1.0, animated: true)
                            acceptedProgress.progressTintColor = UIColor.init(hexString: "#10C558")
                            
                            let packingProgress = self.progressViews[1]
                            packingProgress.setProgress(1.0, animated: true)
                            packingProgress.progressTintColor = UIColor.init(hexString: "#FFB303")
                            
                            
                            let readyProgress = self.progressViews[2]
                            readyProgress.setProgress(1.0, animated: true)
                            readyProgress.progressTintColor = UIColor.init(hexString: "#C520F5")
                            
                            let shippedProgress = self.progressViews[3]
                            shippedProgress.setProgress(1.0, animated: true)
                            shippedProgress.progressTintColor = UIColor.init(hexString: "#03CBFF")
                            
                            packingbtn.backgroundColor = UIColor.init(hexString: "#FFB303")
                            readybtn.backgroundColor = UIColor.init(hexString: "#C520F5")
                            shippedBtn.backgroundColor = UIColor.init(hexString: "#03CBFF")
                            deliveredbtn.backgroundColor = UIColor.init(hexString: "#0A64F9")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if mode == "notify" {
            dismiss(animated: true)
        }
        
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        if mode == "notify" {
            dismiss(animated: true)
        }
        
        else {
            let viewcontrollerArray = navigationController?.viewControllers
            var destiny = 0
            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
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


extension OrdersDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == refundOrderTableView {
            
            return refundDetail.count
            
        }else if tableView == refundItemTable {
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
            
        } else if tableView == refundItemTable {
            return  arrofCartRefundData.count
            
        }else if tableView == grandTable {
            return sortgrand.count
        }
        else {
            return payRefund[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderTableView {
            
            let cell = orderTableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
            cell.TitleLbl.text = sortArrofOrder[indexPath.row].sub
            if cell.TitleLbl.text == codeCoupon {
                cell.priceLbl.text = "- $\(String(format:"%.02f", roundOf(item: sortArrofOrder[indexPath.row].value)))"
                print(sortArrofOrder[indexPath.row].value)
            }else{
                let price = roundOf(item: sortArrofOrder[indexPath.row].value)
                print(price)
                let final_price = String(format:"%.02f", price)
                print(final_price)
                cell.priceLbl.text = "\u{0024}\(final_price)"
                
            }
            
            return cell
            
        }else if tableView == tableview {
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "OderDetailTableViewCell", for: indexPath) as! OderDetailTableViewCell
            let cart = arrofCartData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            cell.productLbl.text = note.replacingOccurrences(of: "Name-", with: "")
            
            let price = roundOf(item: arrofCartData[indexPath.row].price)
            print(price)
            
            let final_price = String(format:"%.02f", price)
            cell.priceLbl.text = "\u{0024}\(final_price)"
            cell.qtyLbl.text = "\(arrofCartData[indexPath.row].qty)x"
            let t_price = calculateTotalPrice(p_price: arrofCartData[indexPath.row].price , q_qty: arrofCartData[indexPath.row].qty)
            
            cell.totalpriceLbl.text = "$\(t_price)"
            return cell
            
            
        } else if tableView == refundItemTable {
            let cell = refundItemTable.dequeueReusableCell(withIdentifier: "RefundedItemCell", for: indexPath) as! RefundedItemCell
            
            
            let cart = arrofCartRefundData[indexPath.row]
            let note = cart.note.replacingOccurrences(of: "~", with: "\n")
            cell.productNameLbl.text = note.replacingOccurrences(of: "Name-", with: "")
            
            
            let price = roundOf(item: arrofCartRefundData[indexPath.row].price)
            print(price)
            let final_price = String(format:"%.02f", price)
            cell.price.text =  "\u{0024}\(final_price)"
            
            
            cell.qty.text = "\(arrofCartRefundData[indexPath.row].refund_qty)x"
            let t_Price = calculateTotalPriceRefund(p_price: arrofCartRefundData[indexPath.row].price, r_qty: arrofCartRefundData[indexPath.row].refund_qty)
            cell.totalPrice.text = "$\(t_Price)"
            
            return cell
            
        }
        else  if tableView == grandTable {
        
            let cell = grandTable.dequeueReusableCell(withIdentifier: "GrandTableCell", for: indexPath) as!  GrandTableCell
            cell.content.text = sortgrand[indexPath.row].cash
            
            print(sortgrand)
            print(sortgrand[indexPath.row].cashValue)
            cell.contentValue.text = sortgrand[indexPath.row].cashValue
            
            
            
            if cell.content.text == "Point Awarded"{
                cell.contentValue.textColor = UIColor(named: "Compeletetext") 
            }else if cell.content.text == "Points Applied"  {
                cell.contentValue.textColor = UIColor(named: "borderRed")
                cell.contentValue.text = sortgrand[indexPath.row].cashValue
            }else {
                cell.contentValue.textColor = UIColor.black
                cell.contentValue.text = "$\(sortgrand[indexPath.row].cashValue)"
            }
            return cell
        }
        else {
            let cell = refundOrderTableView.dequeueReusableCell(withIdentifier: "RefundCell", for: indexPath)  as! RefundCell
            cell.titleLbl.text = payRefund[indexPath.section][indexPath.row]
            cell.titlelblValue.text = payRefundValues[indexPath.section][indexPath.row]
            return cell
            
        }
    }
    // headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == refundOrderTableView {
            let header = Bundle.main.loadNibNamed("RefundHeaderCell", owner: self)?.first as! RefundHeaderCell
            header.refDateAndTime.text = payRefundDate[section]
            return header
        }
        else {
            return nil
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableview || tableView == refundItemTable {
            return 125
        }else {
            return UITableView.automaticDimension
        }
    }
    
    // HeaderView Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == refundOrderTableView {
            return 30
        }else {
            return 0
        }
    }
}

struct MerchantDetail {
    
    let a_address_line_1: String
    let a_address_line_2: String
    let a_address_line_3: String
    let a_city: String
    let a_country: String
    let a_phone: String
    let a_state: String
    let a_zip: String
    let banner_img: String
    let email: String
    let fb_url: String
    let img: String
    let insta_url: String
    let lat: String
    let lng: String
    let name: String
    let phone: String
    let timeZone: String
}

struct OrderDetail {
    
    let admin_id: String
    let adv_id: String
    let amt: String
    let billing_add: String
    let billing_name: String
    let card_type: String
    let card_num: String
    let cash_collected: String
    let cash_discounting: String
    let cash_discounting_percentage: String
    let cashdiscount_refund_amount: String
    let cash_back_fee: String
    let con_fee: String
    let coupon_code: String
    let customer_app_id: String
    let customer_email: String
    let customer_phone : String
    let customer_id: String
    let customer_time: String
    let cvvResult: String
    let date_time: String
    let del_fee: String
    let deliver_name: String
    let delivery_addr: String
    let delivery_phn: String
    let discount: String
    let dob: String
    let driver_assigned: String
    let email: String
    let employee_id: String
    let failResult: String
    let id: String
    let is_future: String
    let is_online: String
    let is_outdoor: String
    let is_partial_refund: String
    let is_refunded: String
    let is_split_payment: String
    let is_tried: String
    let kitchen_receipt: String
    let live_status: String
    let m_status: String
    let mail_status: String
    let mailtriggered: String
    let merchant_id: String
    let merchant_time: String
    let order_id: String
    let order_method: String
    let order_number: String
    let order_status: String
    let order_time: String
    let other_taxes: String
    let other_taxes_desc: String
    let other_taxes_rate_desc: String
    let pax_details: String
    var payment_id: String
    let payment_result: String
    let print: String
    let refund_amount: String
    let shift_setting: String
    let show_status: String
    let smstriggerd: String
    let subtotal: String
    let tax: String
    let tax_rate: String
    let tip: String
    let tip_refund_amount: String
    let is_loyality: String
    let is_store_credit: String
}

struct IdentificationDetail {
    
    let i_card_type: String
    let i_card_number: String
    let i_card_ex_date: String
    let i_card_dob: String
    let i_card_front_img: String
    let i_card_back_img: String
}



struct CartdataRef {
    
    var line_item_id: String
    var variant_id: String
    var category_id: String
    var cost_price: String
    var name: String
    var is_bulk_price: String
    var bulk_price_id: String
    var qty: String
    var note: String
    var userData: String
    var taxRates: String
    var default_tax_amount: String
    var other_taxes_amount: String
    var other_taxes_desc: String
    var is_refunded: String
    var refund_amount: String
    var refund_qty: String
    var id: String
    var img: String
    var price: String
    var lp_discount_amt: String
    var coupon_code_amt: String
    var discount_amt: String
    var discount_rate: String
    var adjust_price: String
    var bogo_discount: String
    var use_point: String
    var earn_point: String
    var is_lottery: String
    var is_adult: String
    var other_taxes_rate_desc: String
    var other_taxes_refund_desc: String
    var default_tax_refund_amount: String
    var other_taxes_refund_amount: String
    var inventory_price: String
    var vendor_id: String
    var vendor_name: String
    var brand_name: String
    var brand_id: String
}

struct Ordersummery {
    
    var sub: String
    var value: String
}

struct Couponcode {
    
    let coupon_code : String
    let coupon_code_amt: String
    let loyalty_point_earned :String
    let loyalty_point_amt_earned :String
    let loyalty_point_amt_spent : String
    let loyalty_point_spent : String
    let store_credit_amt_spent : String
}

struct Grand {
    var cash: String
    var cashValue : String
}

struct RefundDetails {
    var refund_data : String
    let amount : String
    
}

struct FutureDetails {
    var future_order_data : String
}

struct OrderDetails {
    
    let id: String
    let order_id: String
    let order_number: String        //subtotal, discount, tip, tax, other_taxes, con_fee, del_fee, amt, cash_collected, total_loyalty_pts,
    let customer_id: String       //total_store_credit
    let merchant_id: String
    let admin_id: String
    let order_status: String
    let date_time: String
    let payment_id: String
    let pax_details: String
    let card_num: String
    let payment_result: String
    let cvvResult: String
    let failResult: String
    let card_type: String
    let customer_app_id: String
    let discount: String
    let tip: String
    let tax: String
    let other_taxes: String
    let other_taxes_desc: String
    let other_taxes_rate_desc: String
    let change_due: String
    let con_fee: String
    let del_fee: String
    let subtotal: String
    let tax_rate: String
    let coupon_code: String
    let amt: String
    let billing_name: String
    let billing_add: String
    let deliver_name: String
    let delivery_addr: String
    let delivery_phn: String
    let email: String
    let m_status: String
    let mailtriggered: String
    let smstriggerd: String
    let order_method: String
    let is_online: String
    let merchant_time: String
    let customer_time: String
    let order_time: String
    let mail_status: String
    let is_tried: String
    let kitchen_receipt: String
    let print: String
    let cash_collected: String
    let driver_assigned: String
    let show_status: String
    let is_future: String
    let is_refunded: String
    let is_partial_refund: String
    let refund_amount: String
    let is_split_payment: String
    let tip_refund_amount: String
    let cash_discounting: String
    let cash_discounting_percentage: String
    let cashdiscount_refund_amount: String
    let is_outdoor: String
    let employee_id: String
    let dob: String
    let adv_id: String
    let shift_setting: String
    let is_loyality: String
    let is_store_credit: String
    let is_gift_card: String
    let sms_notify: String
    let live_status: String
    let customer_email: String
    let customer_phone: String
    let total_loyalty_pts: String
    let total_store_credit: String
    let cash_back_amt: String
    let cash_back_fee: String
    
}

struct Cart_Data {
    
    let line_item_id: String
    let variant_id: String
    let category_id: String
    let cost_price: String
    let name: String
    let is_bulk_price: String
    let bulk_price_id: String
    var qty: String
    let note: String
    let userData: String
    let taxRates: String
    let bogo_discount: String
    let default_tax_amount: String
    let other_taxes_amount: String
    let other_taxes_desc: String
    let is_refunded: String
    let refund_amount: String
    var refund_qty: String
    let id:  String
    let img: String
    let price: String
    var discount_amt: String
    let coupon_code_amt: String
    let is_lottery: String
    let discount_rate: String
    let adjust_price: String
    let use_point: String
    let earn_point: String
    let lp_discount_amt: String
    let other_taxes_rate_desc: String
    let other_taxes_refund_desc: String
    let default_tax_refund_amount: String
    let other_taxes_refund_amount: String
    let inventory_price: String
    let vendor_id: String
    let vendor_name: String
    let brand_name: String
    let brand_id: String
}

struct Split_Data {
    
    let id: String
    let order_id: String
    let merchant_id: String
    let pay_count: String
    let pay_type: String
    let pay_amount: String
    let remaining_amount: String
    let cash_discounting_amount: String
    let cash_discounting_percentage: String
    let cash_back_amt: String
    let cash_back_fee: String
    let payment_id: String
    let tip: String
    let pax_details: String
    let card_type: String
    let last_four_digit: String
    let created_date_time: String
    let adv_id: String
    let split_by_emp: String
    let shift_setting: String
}

struct CouponCode {
    
    let coupon_code: String
    let coupon_code_amt: String
    let bogo_discount: String
    let loyalty_point_earned: String
    let loyalty_point_amt_earned: String
    let loyalty_point_amt_spent: String
    let loyalty_point_spent: String
    let store_credit_amt_spent: String
    let gift_card_number: String
    let gift_card_amount: String
    let gift_card_balance: String
    let surcharge_label: String
    let total_lottery_payout: String
    let total_scratcher_payout: String
    let lottery_order_pay: String
    let lottery_cash_pay: String
    let scratch_order_pay: String
    let scratch_cash_pay: String
    let employee_name: String
}

struct Refund_Data {
    
    let refund_id: String
    let refunded_by_emp: String
    let amount: String
    let credit_amt: String
    let debit_amt: String
    let cash_amt: String
    let loyalty_point_amt: String
    let store_credit_amt: String
    let giftcard_amt: String
    let reason: String
    let created_at: String
    let nca_amt: String
    let tip_amt: String
    let credit_refund_tax: String
    let debit_refund_tax: String
    let cash_refund_tax: String
    let store_credit_refund_tax: String
    let loyality_refund_tax: String
    let gift_card_refund_tax: String
    let default_tax_rate: String
    let other_tax_rate_desc: String
    let default_tax_refund_amount: String
    let other_taxes_refund_amount: String
    let other_taxes_refund_desc: String
    let reward_loyalty_refund_amt: String
    let reward_loyalty_refund_point: String
    let refund_pax_details: String
    let card_type: String
    
    //"TC:\nTVR:0000000000\nAID:A0000000031010\nTSI:0000\nATC:\nAPPLAB:VISADEBIT\nIAD:\nARC:Z1\nLast4Digit:4788\nRefNum:6\nApprovedAmount:9514\nPaymentMode:Credit Card\nCardMethod:Chip\nAuthCode:000000\n",
}

struct IdentificationDetails {
    
    let i_card_type: String
    let i_card_number: String
    let i_card_ex_date: String
    let i_card_dob: String
    let i_card_front_img: String
    let i_card_back_img: String
}

struct Loyalty {
    
    let loyalty_points: String
    let loyalty_date: String
}


struct Tax_Order_Summary {
    
    var tax_name: String
    var tax_rate: String
    var tax_amount: String
    var sale_due: String
}
