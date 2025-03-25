//
//  SetupBusinessHoursViewController.swift
//  
//
//  Created by Jamaluddin Syed on 24/02/23.
//

import UIKit
import LabelSwitch
import MaterialComponents
import Alamofire

class SetupBusinessHoursViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blackView: UIView!
    
    var loaded = false
    var merchant_id: String?
    
    let dayArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var hoursArray = [SetupBusinessHours]()
    var dualDayCodes = [String]()
    var dualhoursArray = [SetupBusinessHours]()

    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        blackView.isHidden = true
        
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        tableView.isHidden = true
        loadingIndicator.isAnimating = true
        setupApi()
    }
    
    @objc func pullToRefresh() {
        
        setupApi()
        refresh.endRefreshing()
    }
        
    func setupApi() {
        
        let url = AppURLs.GET_BUSINESS_HOURS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id!
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    let result = json["result"] as! NSArray
                    if result.count == 0 {
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = true
                        self.loaded = false
                        self.tableView.reloadData()
                    }
                    else {
                        self.getResponseValues(responseValues: json["result"])
                        
                        self.loaded = true
                        self.loadingIndicator.isAnimating = false
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                    }
                    if self.refresh.isRefreshing {
                        self.refresh.endRefreshing()
                    }
                }
                catch {
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func getResponseValues(responseValues: Any) {
        
        let response = responseValues as! [[String:Any]]
        var ogHours = [SetupBusinessHours]()
        var hoursArr = [SetupBusinessHours]()
        var dualHoursArr = [SetupBusinessHours]()
        var dualDayCode = [String]()
        var day = 0
        let emptyHour =
        SetupBusinessHours(id: "", is_holiday: "", merchant_id: "", multiple_flag: "", open_time: "", close_time: "", day: "", day_code: "")
        
        for hours in response {
            let hour = SetupBusinessHours(id: "\(hours["id"] ?? "")",
                                          is_holiday: "\(hours["is_holiday"] ?? "")",
                                          merchant_id: "\(hours["merchant_clover_id"] ?? "")",
                                          multiple_flag: "\(hours["multiple_flag"] ?? "")",
                                          open_time: "\(hours["open_time"] ?? "")",
                                          close_time: "\(hours["close_time"] ?? "")",
                                          day: "\(hours["day_name"] ?? "")",
                                          day_code: "\(hours["day_code"] ?? "")")
            
            ogHours.append(hour)
        }
        
        
        var sundayArray = [SetupBusinessHours]()
        var mondayArray = [SetupBusinessHours]()
        var tuesdayArray = [SetupBusinessHours]()
        var weddayArray = [SetupBusinessHours]()
        var thursdayArray = [SetupBusinessHours]()
        var fridayArray = [SetupBusinessHours]()
        var satdayArray = [SetupBusinessHours]()
        
        for separate in ogHours {
            
            if Int(separate.day_code) == 0 && sundayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                sundayArray.append(separate)
            }
            else if Int(separate.day_code) == 1 && mondayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                mondayArray.append(separate)
            }
            else if Int(separate.day_code) == 2 && tuesdayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                tuesdayArray.append(separate)
            }
            else if Int(separate.day_code) == 3 && weddayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                weddayArray.append(separate)
            }
            else if Int(separate.day_code) == 4 && thursdayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                thursdayArray.append(separate)
            }
            else if Int(separate.day_code) == 5 && fridayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                fridayArray.append(separate)
            }
            else if Int(separate.day_code) == 6 && satdayArray.count < 2 && (Int(separate.multiple_flag) == 0 || Int(separate.multiple_flag) == 1) {
                satdayArray.append(separate)
            }
            else {
                continue
            }
        }
        
        sundayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        mondayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        tuesdayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        weddayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        thursdayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        fridayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
        satdayArray.sort (by: { $0.multiple_flag < $1.multiple_flag })
            
            
            print(sundayArray)
            print(mondayArray)
            print(tuesdayArray)
            print(weddayArray)
            print(thursdayArray)
            print(fridayArray)
            print(satdayArray)
        
        var updatedHours = [SetupBusinessHours]()
        
        updatedHours.append(contentsOf: sundayArray)
        for mf in sundayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: mondayArray)
        for mf in mondayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: tuesdayArray)
        for mf in tuesdayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: weddayArray)
        for mf in weddayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: thursdayArray)
        for mf in thursdayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: fridayArray)
        for mf in fridayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        updatedHours.append(contentsOf: satdayArray)
        for mf in satdayArray {
            dualDayCode.append(mf.multiple_flag)
        }
        
        print(updatedHours.count)
        print(dualDayCode)
            
            for hour in 0...dualDayCode.count - 1 {
                
                if hour == dualDayCode.count - 1 {
                    
                    if dualDayCode[hour] == "1" {
                        
                        print("end")
                    }
                    
                    else {
                        hoursArr.append(updatedHours[hour])
                        dualHoursArr.append(emptyHour)
                    }
                }
                
                else {
                    
                    if dualDayCode[hour] == "0" &&  dualDayCode[hour + 1] == "1" {
                        
                        hoursArr.append(updatedHours[hour])
                        dualHoursArr.append(updatedHours[hour + 1])
                    }
                    
                    else if dualDayCode[hour] == "0" {
                        hoursArr.append(updatedHours[hour])
                        dualHoursArr.append(emptyHour)
                    }
                    
                    else {
                        print("skip")
                    }
                }
            }

        hoursArray = hoursArr
        dualhoursArray = dualHoursArr
        dualDayCodes = dualDayCode

        print(hoursArray)
        print(hoursArray.count)
        print(dualhoursArray)
        print(dualhoursArray.count)
        print("")

    }
   
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SetupBusinessHoursViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded {
            return dayArray.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetupBusinessTableViewCell
        
        cell.dayTitle.text = dayArray[indexPath.row]
        
        cell.closeBtn.layer.cornerRadius = 5
                
        cell.cellView.layer.cornerRadius = 5
        
        if hoursArray[indexPath.row].is_holiday == "1" {
            cell.closeBtn.setTitle("Closed", for: .normal)
            let first = cell.stackview.arrangedSubviews[0]
            first.isHidden = true
            cell.separate.isHidden = true
        }

        else {
            cell.closeBtn.setTitle("Open", for: .normal)
            let first = cell.stackview.arrangedSubviews[0]
            first.isHidden = false
            cell.separate.isHidden = false
        }
        
        if dualhoursArray[indexPath.row].multiple_flag == "1" {
            cell.firstLabel.text = "\(hoursArray[indexPath.row].open_time) - \(hoursArray[indexPath.row].close_time)"
            cell.verticalSeparate.isHidden = false
            cell.secondLabel.text = "\(dualhoursArray[indexPath.row].open_time) - \(dualhoursArray[indexPath.row].close_time)"
        }
        
        else {
            cell.firstLabel.text = "\(hoursArray[indexPath.row].open_time) - \(hoursArray[indexPath.row].close_time)"
            cell.verticalSeparate.isHidden = true
            cell.secondLabel.text = ""
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! SetupBusinessTableViewCell
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(red: 14.0/255.0, green: 14.0/255.0, blue: 14.0/255.0, alpha: 0.7)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddHours") as! AddBusinessHoursViewController
        var text = ""
        var start_time_1 = ""
        var end_time_1 = ""
        var start_time_2 = ""
        var end_time_2 = ""
        
        if cell.secondLabel.text == "" {
            text = "0"
            start_time_1 = hoursArray[indexPath.row].open_time
            end_time_1 = hoursArray[indexPath.row].close_time
            start_time_2 = ""
            end_time_2 = ""
        }
        else {
            text = "1"
            start_time_1 = hoursArray[indexPath.row].open_time
            end_time_1 = hoursArray[indexPath.row].close_time
            start_time_2 = dualhoursArray[indexPath.row].open_time
            end_time_2 = dualhoursArray[indexPath.row].close_time
        }
        let week = cell.dayTitle.text
        
        let day_code = hoursArray[indexPath.row].day_code
        let is_holiday = hoursArray[indexPath.row].is_holiday
        
        vc.setup = AddHours(merchant_id: merchant_id!, textCount: text, week: week!, start_time_1: start_time_1,
                            end_time_1: end_time_1, start_time_2: start_time_2, end_time_2: end_time_2,
                            day_code: day_code, is_holiday: is_holiday)
        
        vc.viewControl = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
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

struct SetupBusinessHours {
    
    let id: String
    let is_holiday: String
    let merchant_id: String
    let multiple_flag: String
    let open_time: String
    let close_time: String
    let day: String
    let day_code: String
    
}
