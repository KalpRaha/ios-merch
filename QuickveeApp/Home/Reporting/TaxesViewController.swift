//
//  TaxesViewController.swift
//  
//
//  Created by Jamaluddin Syed on 12/01/23.
//

import UIKit
import Alamofire


class TaxesViewController: UIViewController {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
   
    var taxCategories = [[String:Any]]()
    
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
        noDataLabel.text = "No Data Found"
        noDataLabel.isHidden = true
        setupUI()
        
        loadingIndicator.isAnimating = true

        
        getApiCallData(tag: 4)
        
        
    }
    
    
    func getApiCallData(tag:Int) {
        
        let url = AppURLs.TAXES_SALE
        
        let manager = APIManager.shared
        let taxesValueArray = manager.getApiCallData(tag: tag)
        print(taxesValueArray)
        
        let parameters: [String:Any] = [
            "start_date_time": taxesValueArray[0],
            "end_date_time": taxesValueArray[1],
            "order_env": taxesValueArray[2],
            "order_typ": taxesValueArray[3],
            "merchant_id": taxesValueArray[4],
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
                        self.noDataLabel.isHidden = false
                        return
                    }
                    self.getResponseValues(response: jsonDict)
                    self.loadingIndicator.isAnimating = false
                    
                    self.tableView.isHidden = false
                    self.noDataImage.isHidden = true
                    self.noDataLabel.isHidden = true
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
    
    func getResponseValues(response: Any) {
        
        let responseArray = response as! [[String:Any]]
        let taxCat = responseArray
    
        taxCategories = taxCat
        print(taxCategories)
        print(taxCategories)

    }

}


extension TaxesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxCategories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaxesTableViewCell
        
        cell.configure(with: taxCategories[indexPath.row])
        cell.collectionView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        cell.collectionView.layer.borderWidth = 1.0
        cell.collectionView.layer.cornerRadius = 10
        
        cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                         at: .left,
                                    animated: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


struct Taxes {
    
    let collected_tax: String
    let refunded_tax:String
    let tax_name: String
    let tax_rate: String
    
    init(collected_tax: String, refunded_tax: String, tax_name: String, tax_rate: String) {
        self.collected_tax = collected_tax
        self.refunded_tax = refunded_tax
        self.tax_name = tax_name
        self.tax_rate = tax_rate
    }
}

extension TaxesViewController {
    
    
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

