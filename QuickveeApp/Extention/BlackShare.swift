//
//  BlackShare.swift
//  
//
//  Created by Jamaluddin Syed on 10/17/23.
//

import UIKit

class BlackShare {
    
    static let shared = BlackShare()
    
    
    var blackview: UIView?
     
    func blackShow() {
        
        blackview!.isHidden = false
    }

    func blackHide() {
        
        blackview!.isHidden = true
    }
}
