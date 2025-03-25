//
//  NaviViewController.swift
//  
//
//  Created by Jamaluddin Syed on 20/04/23.
//

import UIKit

class NaviViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //chooseYourController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isNavigationBarHidden = true
        chooseYourController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func chooseYourController() {
        if checkLogin() {
            performSegue(withIdentifier: "navitoPass", sender: nil)
        }
        else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginTableViewController
            present(root, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "navitoPass" {
            let vc = segue.destination as! PassCodeViewController
        }
    }
    
    func checkLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoggedIn")
    }
}
