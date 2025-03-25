//
//  ItemSalesViewController.swift
//  
//
//  Created by Jamaluddin Syed on 12/01/23.
//

import UIKit
import Alamofire

class ItemSalesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    var itemSalesValueArray = [String]()
    var responseValues = [[String:Any]]()
    var items = [Items]()

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
        tableView.isHidden = true
        dataLabel.text = "No Data Found"
        dataLabel.isHidden = true
        setupUI()

        
        loadingIndicator.isAnimating = true
        
        getApiCallData(tag: 2)
    }
    
    func getApiCallData(tag:Int) {
        
        let url = AppURLs.ITEMWISE_SALE
        
        let manager = APIManager.shared
        itemSalesValueArray = manager.getApiCallData(tag: tag)
        print(itemSalesValueArray)
        
        let parameters: [String:Any] = [
            "start_date_time": itemSalesValueArray[0],
            "end_date_time": itemSalesValueArray[1],
            "order_env": itemSalesValueArray[2],
            "order_typ": itemSalesValueArray[3],
            "cat_name": itemSalesValueArray[4],
            "merchant_id": itemSalesValueArray[5]
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
                        self.tableView.isHidden = true
                        self.noDataImage.isHidden = false
                        self.dataLabel.isHidden = false
                        return
                    }
                    self.getResponseValues(response: jsonDict)
                    self.loadingIndicator.isAnimating = false
                    self.tableView.isHidden = false
                    self.noDataImage.isHidden = true
                    self.dataLabel.isHidden = true
                    self.tableView.reloadData()
                }
                catch {
                    
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func getResponseValues(response: Any) {

        let responsevalues = response as! [[String:Any]]
        responseValues = responsevalues

    }
}


extension ItemSalesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return responseValues.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemSalesTableViewCell
        
        cell.configure(with: responseValues[indexPath.row])
        
        cell.collectionView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        cell.collectionView.layer.borderWidth = 1.0
        cell.collectionView.layer.cornerRadius = 10
        
        cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                         at: .left,
                                    animated: false)
        return cell

    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct Items {
    
    let refund_amount: String
    let total_price: String
    let adjust_price: String
    let price: String
    let refund_amount_without_tax: String
    let othertx: String
    let categories:String
    let discount_amt: String
    let refund_qty: String
    let total_qty: String
    let saletx: String
    let name: String
}

extension ItemSalesViewController {
    
    
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


