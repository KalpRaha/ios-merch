//
//  SetupTaxViewController.swift
//  
//
//  Created by Jamaluddin Syed on 14/03/23.
//

import UIKit
import Alamofire

class SetupTaxViewController: UIViewController {
    
    
    @IBOutlet weak var addTaxBtn: UIButton!
    @IBOutlet weak var noTaxLabel: UILabel!
    @IBOutlet weak var clickToAddBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addNewTax: UIButton!
    @IBOutlet weak var topview: UIView!
    
    @IBOutlet weak var noTaxView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var taxesLabel: UILabel!
    
    var taxesArray = [SetupTaxes]()
    var taxName = [String]()
    var actionSend: String?
    var titleSend: String?
    var displaySend: String?
    var percentSend: String?
    var idSend: String?
    var isDelete: Int?
    var merchant_id: String?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clickToAddBtn.setTitle("Click '+' To Add Tax", for: .normal)
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        topview.addBottomShadow()
        
        tableview.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backButton.isHidden = false
            taxesLabel.textAlignment = .left
        }
        
        else {
            backButton.isHidden = true
            taxesLabel.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        
        tableview.isHidden = true
        noTaxView.isHidden = true
        loadingIndicator.isAnimating = true
        setupApi()
    }
    
    @objc func pullToRefresh() {
        
        setupApi()
    }
    
    func showUpdatedToast(mode: String) {
        
        if mode == "Add" {
            ToastClass.sharedToast.showToast(message: "  Added Successfully", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
        }
        else {
            ToastClass.sharedToast.showToast(message: "  Updated Successfully", font: UIFont(name: "Manrope-SemiBold", size: 12.0)!)
        }
    }
    
    
    func setupApi() {
        
        
        let url = AppURLs.TAX_LIST

        let parameters: [String:Any] = [
            "merchant_id": merchant_id ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    if json["status"] as! Int == 0 {
                        print("No taxes found")
                        self.tableview.isHidden = true
                        self.loadingIndicator.isAnimating = false
                        self.noTaxView.isHidden = false
                    }
                    else {
                        guard let jsonDict = json["result"] else {
                            self.loadingIndicator.isAnimating = false
                            self.tableview.isHidden = true
                            self.noTaxView.isHidden = false
                            return
                        }
                        self.getResponseValues(responseValues: jsonDict)
                        self.loadingIndicator.isAnimating = false
                        self.tableview.reloadData()
                        self.tableview.isHidden = false
                        self.noTaxView.isHidden = true
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
        var first = 0
        var taxArray = [SetupTaxes]()
        var name = [String]()
        for res in response {
            let setTax = SetupTaxes(alternateName: "\(res["alternateName"] ?? "")",
                                    created_on: "\(res["created_on"] ?? "")",
                                    displayname: "\(res["displayname"] ?? "")",
                                    id: "\(res["id"] ?? "")",
                                    merchant_id: "\(res["merchant_id"] ?? "")",
                                    percent: "\(res["percent"] ?? "")",
                                    title: "\(res["title"] ?? "")",
                                    user_id: "\(res["user_id"] ?? "")")
            if first != 0 {
                taxArray.append(setTax)
                name.append(setTax.title)
            }
            first += 1
            print(setTax)
        }
        taxesArray = taxArray
        taxName = name
        print(taxesArray)
        print(taxesArray)

    }
    
    @IBAction func addButtonClick(_ sender: UIButton) {
        actionSend = "add"
        titleSend = ""
        displaySend = ""
        percentSend = ""
        idSend = ""
        performSegue(withIdentifier: "toAddTaxSetup", sender: nil)
    }
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            var destiny = 0
            let viewcontrollerArray = navigationController?.viewControllers

            if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
                destiny = destinationIndex
            }
            
            navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
        }
        
        else {
           dismiss(animated: true)
        }
    }
    
    @IBAction func addTaxBtnClick(_ sender: UIButton) {
        actionSend = "add"
        titleSend = ""
        displaySend = ""
        percentSend = ""
        idSend = ""
        performSegue(withIdentifier: "toAddTaxSetup", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddTaxSetup" {
            
            let vc = segue.destination as! SetupAddTaxViewController
            vc.action = actionSend
            vc.updateTitle = titleSend
            vc.updateDisplay = displaySend
            vc.updatePercent = percentSend
            vc.updateId = idSend
            vc.merchant_id = merchant_id
            vc.deleteHide = isDelete
            vc.viewControl = self
        }
    }
}

extension SetupTaxViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SetupTaxTableViewCell
        
        cell.titleLabel.text = "Title:"
        cell.titleLabelValue.text = taxesArray[indexPath.row].title
        
        cell.displayName.text = "Display Name:"
        let display = "\(taxesArray[indexPath.row].displayname)"
        
        if display == "" {
            cell.displayNameValue.text = "-"
        }
        else {
            cell.displayNameValue.text = display
        }
        
        cell.percentage.text = "Percentage:"
        cell.percentageValue.text = "\(taxesArray[indexPath.row].percent)"
        
        print(taxesArray[indexPath.row].id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        actionSend = "update"
        titleSend = taxesArray[indexPath.row].title
        displaySend = "\(taxesArray[indexPath.row].displayname)"
        percentSend = taxesArray[indexPath.row].percent
        idSend = taxesArray[indexPath.row].id
        isDelete = indexPath.row
        performSegue(withIdentifier: "toAddTaxSetup", sender: nil)
    }
}

extension SetupTaxViewController {
    
    
    
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



struct SetupTaxes {
    
    let alternateName: String
    let created_on: String
    let displayname: String
    let id: String
    let merchant_id: String
    let percent: String
    let title: String
    let user_id: String
}
