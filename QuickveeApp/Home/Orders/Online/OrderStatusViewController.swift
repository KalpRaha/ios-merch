//
//  OrderStatusViewController.swift
//
//
//  Created by Pallavi on 03/04/24.
//

import UIKit

protocol OrderStatusViewControllerProtocol: AnyObject {
    func reloadTableView()
    
}

class OrderStatusViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    var live_status = ""
    var order_method = ""
    var order_id = ""
    var statusName = ""
    var number = ""
    var orderStatusArray = [OnlineOrdersModel]()
    
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    var progressViews: [UIProgressView] = []
    
    var buttonsPickup: [UIButton] = []
    var labelsPickup: [UILabel] = []
    var progressViewsPickup: [UIProgressView] = []
    
    var delegate:OrderStatusViewControllerProtocol?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(statusName)
        
        orderName.text = "\(statusName) -"
        phoneNumber.text = number
        
        if order_method == "Pickup" ||  order_method == "pickup" {
            createPickupStatus()
        }
        else {
            createDeliveryStatus()
        }
        
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
                            lbl1: lbl1, lbl2: lbl2, lbl3: lbl3, lbl4: lbl4)
        
        
        
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
                             lbl1: UILabel,  lbl2: UILabel,  lbl3: UILabel,  lbl4: UILabel) {
        
        print(order_method)
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
            
            prog1.setProgress(1.0, animated: true)
            prog1.progressTintColor =  UIColor.init(hexString: "#10C558")
            prog2.setProgress(1.0, animated: true)
            prog2.progressTintColor =  UIColor.init(hexString: "#FFB303")
            prog3.setProgress(0.5, animated: true)
            prog3.progressTintColor =  UIColor.init(hexString: "#C520F5")
            lbl1.textColor = UIColor.init(hexString: "#CECECE")
            lbl2.textColor =  UIColor.init(hexString: "#CECECE")
            lbl3.textColor = UIColor.black
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
            btn4.setImage(UIImage(named: "Shippedonline"), for: .normal)
            
            btn2.backgroundColor = UIColor.init(hexString: "#FFB303")
            btn3.backgroundColor = UIColor.init(hexString: "#C520F5")
            btn4.backgroundColor = UIColor.init(hexString: "#03CBFF")
            
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
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        delegate?.reloadTableView()
        dismiss(animated: true)
        
    }
    
    
    @objc func acceptedClick(sender: UIButton) {
        
        let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let od = order_id
        
        ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "1")
        { isSuccess, responseData in
            
            if isSuccess {
                
                if self.order_method == "Pickup" ||  self.order_method == "pickup" {
                    
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
    
    @objc func packingClick(sender: UIButton) {
        
        let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let od = order_id
        
        ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: "2") { isSuccess, responseData in
            
            if isSuccess {
                
                if self.order_method == "Pickup" ||  self.order_method == "pickup" {
                    
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
    
    @objc func readyClick(sender: UIButton) {
        var readystatus = ""
        let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        let od = order_id
        
        if order_method == "Pickup" || order_method == "pickup"  {
            readystatus = "3"
        }
        else {
            readystatus = "6"
        }
        
        ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: readystatus) { isSuccess, responseData in
            
            if isSuccess {
                
                
                
                if self.order_method == "Pickup" || self.order_method == "pickup" {
                    
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
                    
                }else {
                    
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
    
    @objc func ShippedClick(sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "lock_update_order_status") {
            
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 15.0)!)
        }
        else {
        
        
        if order_method == "Pickup" ||  order_method == "pickup" {
            var status = ""
            let merchant_id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
            let od = order_id ?? ""
            
            if order_method == "pickup" || order_method == "Pickup" {
                status = "4"
            }
            else {
                status = "3"
            }
            
            ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: status) { isSuccess, responseData in
                
                if isSuccess {
                    
                    if self.order_method == "Pickup" ||  self.order_method == "pickup" {
                        
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
                
                if order_method == "Pickup" ||  order_method == "pickup" {
                    status = "4"
                }
                else {
                    status = "3"
                }
                
                ApiCalls.sharedCall.getOrderStatus(merchant_id: merchant_id, order_id: od, status: status) { isSuccess, responseData in
                    
                    if isSuccess {
                        
                        if self.order_method == "Pickup" ||  self.order_method == "pickup" {
                            
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
        }
    }
}
    @objc func deliveryClick(sender: UIButton) {
        
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
                else {
                    
                }
            }
            
            
        }
        
    }
}
