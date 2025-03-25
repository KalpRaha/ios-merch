//
//  OrderTypesViewController.swift
//  
//
//  Created by Jamaluddin Syed on 12/01/23.
//

import UIKit
import Alamofire

class OrderTypesViewController: UIViewController {
        
    var responseArray = [[String:Any]]()
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var noDataImage: UIImageView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noDataImage.image = UIImage(named: "No Data")
        noDataImage.isHidden = true
        tableview.isHidden = true
        noDataLabel.text = "No Data Found"
        noDataLabel.isHidden = true
        setupUI()

        
        loadingIndicator.isAnimating = true

        
        getApiCallData(tag: 3)
    
    }
    
    func getApiCallData(tag:Int) {
        
        let url = AppURLs.ORDERTYPE_SALE
        
        let manager = APIManager.shared
        let orderValueArray = manager.getApiCallData(tag: tag)
        
        let parameters: [String:Any] = [
            "start_date_time": orderValueArray[0],
            "end_date_time": orderValueArray[1],
            "order_env": orderValueArray[2],
            "merchant_id": orderValueArray[3]
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
                    guard let jsonDict = json["result"] else {
                        self.loadingIndicator.isAnimating = false
                        self.tableview.isHidden = true
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                        return
                    }
                    self.getResponseValues(response: jsonDict)
                    self.loadingIndicator.isAnimating = false

                    self.tableview.isHidden = false
                    self.noDataImage.isHidden = true
                    self.noDataLabel.isHidden = true
                    self.tableview.reloadData()
                    break
                }
                catch {
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getResponseValues(response: Any) {
        
        let responsearray = response as! [[String:Any]]
        responseArray = responsearray
    }
}

extension OrderTypesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        responseArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTypesTableViewCell
        
        cell.configure(with: responseArray[indexPath.row])
        cell.collectionView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        cell.collectionView.layer.borderWidth = 1.0
        cell.collectionView.layer.cornerRadius = 10
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


struct Order {
    let order_method: String
    let total_count: String
    let amount_with_tip: String
    let amt_without_tip: String
    let tip: String
}

extension OrderTypesViewController {
    
    
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
