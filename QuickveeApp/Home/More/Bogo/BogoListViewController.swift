//
//  BogoListViewController.swift
//  bogoUi
//
//  Created by Pallavi Patil on 27/01/25.
//

import UIKit

class BogoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var blueAddBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noBogolBL: UILabel!
    @IBOutlet weak var clickLbl: UILabel!
    
    @IBOutlet weak var enableAllBtn: UIButton!
    @IBOutlet weak var enableAlllLbl: UILabel!
    
    
    var bogoList = [BogoModel]()
    
    var bogoMixItemsIdArr = [String]()
    
    var bogoObject : BogoModel?
    var bogoDisableArr = [String]()
    var mode = ""
    var bogo_id = ""
    
    var flag = 0
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addBottomShadow()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        enableAllBtn.isEnabled = false
        enableAllBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        
        bogoDisableArr = []
        flag = 0
        bogoListApiCall()
    }
    
    func bogoListApiCall() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        tableView.isHidden = true
        loadingIndicator.isAnimating = true
        blueAddBtn.isHidden = true
        addBtn.isHidden = true
        noBogolBL.isHidden = true
        clickLbl.isHidden = true
        
        print(bogoDisableArr)
        
        ApiCalls.sharedCall.getBOGOList(merchant_id: id) { isSuccess, responseData in
            
            
            if isSuccess {
                
                if let data = responseData["bogo_list"], (data as! [[String:Any]]).count != 0   {
                    
                    self.flag = 1
                    self.getResponseValues(list: data)
                }
                else {
                    self.setupMixnmatchApi()
                }
            }
            else {
                print("Api Error")
            }
        }
        
    }
    
    func getResponseValues(list: Any) {
        
        let response = list as! [[String: Any]]
        
        var small = [BogoModel]()
        var bogoItemsArr = [[String:Any]]()
        
        for items in response {
            
            let bogodeal = BogoModel(id: "\(items["id"] ?? "")",
                                     merchant_id: "\(items["mrchant_id"] ?? "" )",
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
            bogoDisableArr.append(disable)
        }
        
        if small.count == 0 {
            enableAllBtn.isEnabled = false
            enableAllBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
        }
        else {
            enableAllBtn.isEnabled = true
            
            if bogoDisableArr.contains("1") {
                enableAllBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
            }
            else {
                enableAllBtn.setImage(UIImage(named: "check inventory"), for: .normal)
            }
            
            bogoList = small
            
            var keyArr = [String]()
            var valueArr = [String]()
            
            for bogo in bogoItemsArr {
                
                for (k,v) in bogo {
                    
                    keyArr.append(k)
                    
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
            
            bogoMixItemsIdArr = keyArr + valueArr
        }
        setupMixnmatchApi()
    }
    
    func setupMixnmatchApi() {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.mixnMatchList(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                if let list = responseData["data"], (list as! [[String:Any]]).count != 0 {
                    self.getmixResponseValues(list: list)
                }
                else {
                    
                    if self.flag == 0  {
                        
                        self.addBtn.isHidden = false
                        self.blueAddBtn.isHidden = true
                        self.noBogolBL.isHidden = false
                        self.clickLbl.isHidden = false
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = true
                        self.loadingIndicator.removeFromSuperview()
                    }
                    else {
                        
                        self.addBtn.isHidden = true
                        self.blueAddBtn.isHidden = false
                        self.noBogolBL.isHidden = true
                        self.clickLbl.isHidden = true
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
            }
            
            else{
                print("Api Error")
            }
            
        }
    }
    
    
    func getmixResponseValues(list: Any) {
        
        var mixitemsIdArr = [String]()
        
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
        
        // mixnMatchList = small
        
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
        
        bogoMixItemsIdArr.append(contentsOf: mixitemsIdArr)
        
        
        if flag == 0 {
            self.loadingIndicator.isAnimating = false
            self.tableView.isHidden = true
            self.loadingIndicator.removeFromSuperview()
            
            self.addBtn.isHidden = false
            self.blueAddBtn.isHidden = true
            self.noBogolBL.isHidden = false
            self.clickLbl.isHidden = false
        }
        else {
            
            DispatchQueue.main.async {
                self.loadingIndicator.isAnimating = false
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
                self.addBtn.isHidden = true
                self.blueAddBtn.isHidden = false
                self.noBogolBL.isHidden = true
                self.clickLbl.isHidden = true
                
                
            }
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        mode = "add"
        performSegue(withIdentifier: "toCreateBogo", sender: nil)
    }
    
    
    @IBAction func homebtnClick(_ sender: UIButton) {
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    @objc func changeShadow(sender : UISwitch) {
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! BogoListTableViewCell
        
        var is_disable = ""
        let bogoId = bogoList[index.row].id
        
        if cell.swichBtn.isOn {
            is_disable = "0"
        }
        else {
            is_disable = "1"
        }
        
        loadingIndicator.isAnimating = true
        tableView.isHidden = true
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.enableBogoApiCall(merchant_id: id, id: bogoId, is_enable: is_disable) { isSuccess, responseData in
            
            if isSuccess {
                
                if is_disable == "1" {
                    cell.swichBtn.isOn = false
                    cell.swichBtn.thumbTintColor = .white
                }
                else {
                    cell.swichBtn.isOn = true
                    cell.swichBtn.thumbTintColor = .systemBlue
                }
                
                self.bogoDisableArr[index.row] = is_disable
                
                if self.bogoDisableArr.contains("1") {
                    self.enableAllBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                else {
                    self.enableAllBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
                
                self.loadingIndicator.isAnimating = false
                self.tableView.isHidden = false
                
                ToastClass.sharedToast.showToast(message: "Data Updated Successfully",
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
                
            }
            
            else {
                self.loadingIndicator.isAnimating = false
                self.tableView.isHidden = false
                print("Api Error")
            }
        }
    }
    
    @IBAction func enableAllBtnClick(_ sender: UIButton) {
        
        var enable_All = ""
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! BogoListTableViewCell
        
        if sender.currentImage == UIImage(named: "uncheck inventory") {
            
            enable_All = "enable"
            
            cell.swichBtn.isOn = true
            cell.swichBtn.thumbTintColor = .systemBlue
            
        }
        else {
            enable_All = "disable"
            
            cell.swichBtn.isOn = false
            cell.swichBtn.thumbTintColor = .white
        }
        
        enableAllApiCall(enable_All: enable_All)
    }
    
    func enableAllApiCall(enable_All: String) {
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        ApiCalls.sharedCall.enableAllBogoApiCall(merchant_id: id, enable_all: enable_All) { isSuccess,responseData in
            
            if isSuccess {
                
                let list = responseData["msg"] as? String ?? ""
                
                if list == "All records disabled successfully." {
                    
                    self.enableAllBtn.setImage(UIImage(named: "uncheck inventory"), for: .normal)
                }
                else {
                    self.enableAllBtn.setImage(UIImage(named: "check inventory"), for: .normal)
                }
            }
            else {
                print("API Error")
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
    
    
    func startEndDateFormat(date: String) -> String {
        
        let dateFormat1 = DateFormatter()
        dateFormat1.dateFormat = "yyyy-MM-dd"
        
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "MM/dd/yyyy"
        
        if date == "0000-00-00" {
            return date
        }
        else {
            let dateold = dateFormat1.date(from: date)
            let dateNew = dateFormat2.string(from: dateold!)
            return dateNew
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCreateBogo" {
            
            let vc = segue.destination as! CreateBOGODealViewController
            
            if mode == "edit" {
                vc.bogoObj = bogoObject
            }
            vc.mode = mode
            vc.bogo_mix_exist_ids = bogoMixItemsIdArr
        }
    }
}

extension BogoListViewController {
    
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


extension BogoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bogoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BogoListTableViewCell") as! BogoListTableViewCell
        
        cell.dealLbl.text = bogoList[indexPath.row].deal_name
        cell.offerLbl.text = bogoList[indexPath.row].desc
        
        if bogoList[indexPath.row].start_date == "0000-00-00" && bogoList[indexPath.row].end_date == "0000-00-00" {
            cell.validDate.text = "NA"
        }
        else {
            cell.validDate.text =
            "\(startEndDateFormat(date: bogoList[indexPath.row].start_date)) - \(startEndDateFormat(date: bogoList[indexPath.row].end_date))"
        }
        
        cell.swichBtn.tag = indexPath.row
        cell.swichBtn.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        cell.swichBtn.addTarget(self, action: #selector(changeShadow), for: .valueChanged)
        
        if bogoDisableArr[indexPath.row] == "0" {
            cell.swichBtn.isOn = true
            cell.swichBtn.thumbTintColor = .systemBlue
        }
        else {
            cell.swichBtn.isOn = false
            cell.swichBtn.thumbTintColor = .white
        }
        
        cell.bgView.layer.borderColor = UIColor(hexString: "#DEDEDE").cgColor
        cell.bgView.layer.borderWidth = 1
        cell.bgView.layer.cornerRadius = 10
        cell.smallbgView.layer.cornerRadius = 10
        cell.smallbgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mode = "edit"
        bogoObject = bogoList[indexPath.row]
        
        performSegue(withIdentifier: "toCreateBogo", sender: nil)
    }
}

struct BogoModel {
    
    let id: String
    let merchant_id: String
    let start_date: String
    let end_date: String
    let deal_name: String
    let desc: String
    let no_end_date: String
    let use_with_coupon: String
    let buy_qty: String
    let free_qty: String
    let discount: String
    let discount_type: String
    let is_disable: String
    let items: String
    let use_status: String
    let created_at: String
    let updated_at: String
    let is_deleted: String
    
}
