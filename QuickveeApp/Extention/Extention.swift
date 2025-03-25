//
//  Extention.swift
//
//
//  Created by Jamaluddin Syed on 12/12/23.
//

import Foundation
import UIKit

public class ToastClass {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let sharedToast = ToastClass()
    
    public func showToast(message: String, font: UIFont) {
                
        let toast_view = UIView(frame: .zero)
        toast_view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast_view.translatesAutoresizingMaskIntoConstraints = false
        toast_view.clipsToBounds = true
        toast_view.layer.cornerRadius = 6
        
        let toast = UILabel(frame: .zero)
        
        toast.text = message
        toast.font = UIFont(name: "Manrope-SemiBold", size: 15.0)!
        toast.numberOfLines = 0
        toast.textAlignment = .center
        toast.lineBreakMode = .byWordWrapping
        toast.textColor = .white
        toast.translatesAutoresizingMaskIntoConstraints = false
        
        toast_view.addSubview(toast)
        
        appDelegate.window!.addSubview(toast_view)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            toast.topAnchor.constraint(equalTo: toast_view.topAnchor, constant: padding),
            toast.bottomAnchor.constraint(equalTo: toast_view.bottomAnchor, constant: -padding),

            toast.leadingAnchor.constraint(equalTo: toast_view.leadingAnchor, constant: padding),
            toast.trailingAnchor.constraint(equalTo: toast_view.trailingAnchor, constant: -padding),
            
            toast_view.leadingAnchor.constraint(equalTo: appDelegate.window!.leadingAnchor, constant: padding),
            toast_view.trailingAnchor.constraint(equalTo: appDelegate.window!.trailingAnchor, constant: -padding),
            
            toast_view.centerXAnchor.constraint(equalTo: appDelegate.window!.centerXAnchor),
            toast_view.centerYAnchor.constraint(equalTo: appDelegate.window!.centerYAnchor, constant: 300),
            
            
        ])
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast_view.alpha = 0.0
        }, completion: {(isCompleted) in
            toast_view.removeFromSuperview()
        })
    }
}


extension ToastClass {
    
    func setDateFormat(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            dateFormatter.locale = Locale(identifier: "en_US")
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
 
    func setCouponsDateFormat(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
    
    func setStockDateFormat(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
    
    func setcustomerDateFormat(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
    
    
    func setCouponlistDate(dateStr: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return ""
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIView {

    func addDashedBorder() {
        
        self.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }

        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(hexString: "#707070").cgColor
        shapeLayer.lineWidth = 2
        
        
        shapeLayer.lineDashPattern = [2,3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}


//    public func showToastXS(message : String, font: UIFont) {
//
//        let win = appDelegate.window
//        let width = win?.screen.bounds.size.width ?? 0
//        let height = win?.screen.bounds.size.height ?? 0
//
//        let toastButton = UIButton(frame: CGRect(x: width/2 - 60, y: height - 160, width: 120, height: 40))
//
//        toastButton.setTitle(message, for: .normal)
//        toastButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastButton.setTitleColor(.white, for: .normal)
//        toastButton.titleLabel?.font = font
//        toastButton.alpha = 1.0
//        toastButton.layer.cornerRadius = 10
//        toastButton.clipsToBounds  =  true
//        appDelegate.window?.addSubview(toastButton)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastButton.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastButton.removeFromSuperview()
//        })
//    }
    
//    public func showToastMedium(message : String, font: UIFont) {
//
//        let win = appDelegate.window
//        let width = win?.screen.bounds.size.width ?? 0
//        let height = win?.screen.bounds.size.height ?? 0
//
//        let toastButton = UIButton(frame: CGRect(x: width/2 - 100, y: height - 160, width: 185, height: 40))
//
//        toastButton.setTitle(message, for: .normal)
//        toastButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastButton.setTitleColor(.white, for: .normal)
//        toastButton.titleLabel?.font = font
//        toastButton.alpha = 1.0
//        toastButton.layer.cornerRadius = 10
//        toastButton.clipsToBounds  =  true
//        appDelegate.window?.addSubview(toastButton)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastButton.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastButton.removeFromSuperview()
//        })
//    }
    
//    public func showToastLarge(message : String, font: UIFont) {
//
//        let win = appDelegate.window
//        let width = win?.screen.bounds.size.width ?? 0
//        let height = win?.screen.bounds.size.height ?? 0
//
//        let toastButton = UIButton(frame: CGRect(x: width/2 - 110, y: height - 160, width: 240, height: 40))
//
//        toastButton.setTitle(message, for: .normal)
//        toastButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastButton.setTitleColor(.white, for: .normal)
//        toastButton.titleLabel?.font = font
//        toastButton.alpha = 1.0
//        toastButton.layer.cornerRadius = 10
//        toastButton.clipsToBounds  =  true
//        appDelegate.window?.addSubview(toastButton)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastButton.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastButton.removeFromSuperview()
//        })
//    }
    
//    public func showToastXL(message : String, font: UIFont) {
//
//        let win = appDelegate.window
//        let width = win?.screen.bounds.size.width ?? 0
//        let height = win?.screen.bounds.size.height ?? 0
//
//        let toastButton = UIButton(frame: CGRect(x: width - 360, y: height - 160, width: 330, height: 40))
//
//        toastButton.setTitle(message, for: .normal)
//        toastButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastButton.setTitleColor(.white, for: .normal)
//        toastButton.titleLabel?.font = font
//        toastButton.alpha = 1.0
//        toastButton.layer.cornerRadius = 10
//        toastButton.clipsToBounds  =  true
//        appDelegate.window?.addSubview(toastButton)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastButton.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastButton.removeFromSuperview()
//        })
//    }
