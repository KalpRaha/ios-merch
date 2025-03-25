//
//  UpdateMixnMatchViewController.swift
//
//
//  Created by Pallavi on 17/06/24.
//

import UIKit
import MaterialComponents

class UpdateMixnMatchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    func setUI(){
        
        
    }
    
    func createCustomTextField(textField: MDCOutlinedTextField) {
      
    }
}

extension UpdateMixnMatchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMixnMatchCell", for: indexPath) as! AddMixnMatchCell
        cell.contentView.backgroundColor = UIColor.white
        return cell
        
    }
    
    
}
