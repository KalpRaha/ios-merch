//
//  MixnMatchPricingViewController.swift
//
//
//  Created by Pallavi on 11/06/24.
//

import UIKit

protocol PriceQtyDelegate: AnyObject {
    
    func getPriceQty(price: String, is_percent: String, quantity: String)
}

class MixnMatchPricingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var blueAddBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noMixlBL: UILabel!
    @IBOutlet weak var clickLbl: UILabel!
    
    var mixnMatchList = [MixnMatchModel]()
    var itemSendEditIds = ""
    
    var bogolistitemsIdArr = [String]()
    var mixitemsIdArr = [String]()

    var mode = ""
    var deal_Name = ""
    var deal_description = ""
    var min_qty = ""
    var discount = ""
    var e_disc = ""
    var mix_id = ""
    var is_enable = ""
    var ispercent = ""
    var flag = 0
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        topView.addBottomShadow()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flag = 0
        setupUI()
        tableView.isHidden = true
        noMixlBL.isHidden = true
        addBtn.isHidden = true
        blueAddBtn.isHidden = true
        clickLbl.isHidden = true
       
        setupMixnmatchApi()
        
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func homeBtn(_ sender: UIButton) {
        
        let viewcontrollerArray = self.navigationController?.viewControllers
        var destiny = 0
        
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        self.navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "add_mix_match") {
            ToastClass.sharedToast.showToast(message: "Access Denied",
                                             font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
        else {
            let modal = UserDefaults.standard.integer(forKey: "modal_screen")
            
            if modal == 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PriceMixnMatchViewController") as! PriceMixnMatchViewController
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
 
    @objc func changeShadow(sender : UISwitch) {
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! MixnMatchPricingCell
        
        mix_id = mixnMatchList[index.row].id
        
        if cell.swichBtn.isOn {
            is_enable = "1"
            cell.swichBtn.thumbTintColor = .systemBlue
        }
        else {
            is_enable = "0"
            cell.swichBtn.thumbTintColor = .white
            
        }
        
        isEnableAPICall()
        setupUI()
        loadingIndicator.isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadingIndicator.isAnimating = false
            self.loadingIndicator.removeFromSuperview()
            ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
        }
    }
    
    func isEnableAPICall(){
        
        loadingIndicator.isAnimating = true
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.enableMixnMatch(merchant_id: id, mix_id: mix_id, is_enable: is_enable )
        { isSuccess, responseData in
            
            if isSuccess {
//                ToastClass.sharedToast.showToast(message: "Data Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
            }
            
            else {
                self.loadingIndicator.isAnimating = false
                print("Api Error")
            }
        }
    }
  
    func setupMixnmatchApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        loadingIndicator.isAnimating = true
        
        ApiCalls.sharedCall.mixnMatchList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                if let data = responseData["data"], (data as! [[String:Any]]).count != 0   {
                    self.flag = 1
                    self.getResponseValues(list: data)
                }
                else {
                    self.bogoListApiCall()
                }
            }else{
                print("Api Error")
            }
        }
    }
  
    func getResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [MixnMatchModel]()
        var mixItemsArr = [[String:Any]]()
      
        for match in response {
            
            let mixnMatch =  MixnMatchModel(id:  "\(match["id"] ?? "")",
                                            merchant_id: "\(match["merchant_id"] ?? "")",
                                            items_id: "\(match["items_id"] ?? "")",
                                            deal_name: "\(match["deal_name"] ?? "")",
                                            desc: "\(match["description"] ?? "")",
                                            min_qty: "\(match["min_qty"] ?? "")",
                                            is_percent: "\(match["is_percent"] ?? "")",
                                            discount: "\(match["discount"] ?? "")",
                                            is_enable: "\(match["is_enable"] ?? "")")
            
            //"{\"604167\":[\"1280405\",\"1280406\"], \"604169\":[\"\"]}
            
            small.append(mixnMatch)
            let ids = mixnMatch.items_id
            let mixItems = convertStringToDictionary(text: ids)
            mixItemsArr.append(mixItems)
        }
        
        mixnMatchList = small
        
        var keyArr = [String]()
        var valueArr = [String]()
        
        for mix in mixItemsArr {
            
            for (k,v) in mix {
                keyArr.append(k)
                
                let valarr = v as? [String] ?? []
                
                for val in valarr {
                    if val.count == 0{
                    }
                    else{
                        valueArr.append(val)
                    }
                }
            }
        }
        
        mixitemsIdArr = keyArr + valueArr
        bogoListApiCall()
        
//
//        if response.count == 0 {
//            self.tableView.isHidden = true
//            self.loadingIndicator.isAnimating = false
//            self.blueAddBtn.isHidden = true
//            self.addBtn.isHidden = false
//            self.noMixlBL.isHidden = false
//            self.clickLbl.isHidden = false
//        }
//        else {
//            self.tableView.isHidden = false
//            self.loadingIndicator.isAnimating = false
//            self.blueAddBtn.isHidden = false
//            self.addBtn.isHidden = true
//            self.noMixlBL.isHidden = true
//            self.clickLbl.isHidden = true
//        }
//        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    
    func bogoListApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
 
        ApiCalls.sharedCall.getBOGOList(merchant_id: id){ isSuccess, responseData in
            
            if isSuccess {
                
                if let list = responseData["bogo_list"], (list as! [[String:Any]]).count != 0 {
                    
                    self.getbogoResponseValues(list: list)
                }
                else {
                    
                    if self.flag == 0 {
                        self.addBtn.isHidden = false
                        self.blueAddBtn.isHidden = true
                        self.noMixlBL.isHidden = false
                        self.clickLbl.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = true
                        self.loadingIndicator.removeFromSuperview()
                    }
                    else {
                        self.addBtn.isHidden = true
                        self.blueAddBtn.isHidden = false
                        self.noMixlBL.isHidden = true
                        self.clickLbl.isHidden = true
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                        
                }
            }
            else {
                print("Api Error")
            }
        }
        
    }
    
    
    func getbogoResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [BogoModel]()
        var bogoItemsArr = [[String:Any]]()
        
        for items in response {
            
            let bogodeal = BogoModel(id: "\(items["id"] ?? "")",
                                     merchant_id: "\(items["merchant_id"] ?? "" )",
                                     start_date: "\(items["start_date"] ?? "")",
                                     end_date: "\(items["end_date"] ?? "")",
                                     deal_name: "\(items["deal_name"] ?? "")",
                                     desc: "\(items["description"] ?? "")",
                                     no_end_date: "\(items["no_end_date"] ?? "")",
                                     use_with_coupon: "\(items["use_with_coupon"] ?? "")",
                                     buy_qty: "\(items["buy_qty"] ?? "")",
                                     free_qty: "\(items["free_qty"] ?? "")",
                                     discount: "\(items["discount"] ?? "")",
                                     discount_type: "\(items["discount_type"] ?? "")",
                                     is_disable: "\(items["is_disable"] ?? "")",
                                     items: "\(items["items"] ?? "")",
                                     use_status: "\(items["use_status"] ?? "")",
                                     created_at: "\(items["created_at"] ?? "")",
                                     updated_at: "\(items["updated_at"] ?? "")",
                                     is_deleted:"\(items["is_deleted"] ?? "")")
            
            //"{\"1303835\":[\"\"],\"1303837\":[\"1825755\"],\"1148353\":[\"1721500\",\"1721501\"],\"1148355\":[\"1721513\",\"1721514\"]}"
            
            small.append(bogodeal)
            let ids = bogodeal.items
            let disable = bogodeal.is_disable
            let bogoItems = convertStringToDictionary(text: ids)
            bogoItemsArr.append(bogoItems)
          
        }
        var keyArr = [String]()
        var valueArr = [String]()
        
        for bogo in bogoItemsArr {
            
            for (k,v) in bogo {
                
                keyArr.append(k)
                print(keyArr)
                
                let valarr = v as? [String] ?? []
                
                for val in valarr {
                    if val.count == 0 {
                        
                    }
                    else {
                        valueArr.append(val)
                    }
                }
                
            }
        }
        
        bogolistitemsIdArr = keyArr + valueArr
       
        print("BOGO\(bogolistitemsIdArr)")
        print("MIX\(mixitemsIdArr)")
        
        mixitemsIdArr.append(contentsOf: bogolistitemsIdArr)
        
        if flag == 0 {
            self.loadingIndicator.isAnimating = false
            self.tableView.isHidden = true
            self.tableView.reloadData()
            self.loadingIndicator.removeFromSuperview()
            self.addBtn.isHidden = false
            self.blueAddBtn.isHidden = true
            self.noMixlBL.isHidden = false
            self.clickLbl.isHidden = false
        }
        else {
            
            DispatchQueue.main.async {
                self.loadingIndicator.isAnimating = false
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
                self.addBtn.isHidden = true
                self.blueAddBtn.isHidden = false
                self.noMixlBL.isHidden = true
                self.clickLbl.isHidden = true
                
                
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUpdateMixnMatch" {
            
            let vc = segue.destination as! AddMixnMatchViewController
            
            vc.mode = "edit"
            vc.e_deal_name = deal_Name
            vc.e_discount = e_disc
            vc.e_qty = min_qty
            vc.e_desc = deal_description
            vc.e_m_id = mix_id
            vc.itemsEditIds = itemSendEditIds
            vc.itemsAllEditIds = mixitemsIdArr
            vc.is_percent = ispercent
        }
        
        else {
            
            let vc = segue.destination as! SelectMixnMatchViewController
            
            vc.mix_exist_ids = mixitemsIdArr
            vc.price = discount
            vc.qty = min_qty
            vc.mode = "add"
            vc.isperc = ispercent
        }
    }
}

extension MixnMatchPricingViewController {
    
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

extension MixnMatchPricingViewController: PriceQtyDelegate {
    
    func getPriceQty(price: String, is_percent: String, quantity: String) {
        
        let modal = UserDefaults.standard.integer(forKey: "modal_screen")
        
        if modal == 1 {
            discount = price
            ispercent = is_percent
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "QtyMixnMatchViewController") as! QtyMixnMatchViewController
            
            vc.delegate = self
            present(vc, animated: true)
        }
        else if modal == 2 {
            min_qty = quantity
            performSegue(withIdentifier: "toSelectMixnMatch", sender: nil)
        }
    }
}

extension MixnMatchPricingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixnMatchList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MixnMatchPricingCell", for: indexPath) as! MixnMatchPricingCell
        cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.cornerRadius = 10
        cell.smallbgView.layer.cornerRadius = 10
        cell.smallbgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell.contentView.backgroundColor = UIColor.white
        
        cell.dealLbl.text = mixnMatchList[indexPath.row].deal_name
        cell.offerLbl.text = mixnMatchList[indexPath.row].desc
        
        cell.swichBtn.isEnabled = true
        cell.swichBtn.tag = indexPath.row
        cell.swichBtn.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        cell.swichBtn.addTarget(self, action: #selector(changeShadow), for: .valueChanged)
        
        if mixnMatchList[indexPath.row].is_enable == "0" {
            cell.swichBtn.isOn = false
            cell.swichBtn.thumbTintColor = .white
        }
        else {
            cell.swichBtn.isOn = true
            cell.swichBtn.thumbTintColor = .systemBlue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deal_Name = mixnMatchList[indexPath.row].deal_name
        deal_description = mixnMatchList[indexPath.row].desc
        min_qty = mixnMatchList[indexPath.row].min_qty
        e_disc = mixnMatchList[indexPath.row].discount
        ispercent = mixnMatchList[indexPath.row].is_percent
        mix_id = mixnMatchList[indexPath.row].id
        itemSendEditIds = mixnMatchList[indexPath.row].items_id

        performSegue(withIdentifier: "toUpdateMixnMatch", sender: nil)
    }
}

struct MixnMatchModel {
    
    let id: String
    let merchant_id: String
    let items_id: String
    let deal_name: String
    let desc: String
    let min_qty: String
    let is_percent: String
    let discount : String
    let is_enable: String
    
}
