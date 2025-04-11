//
//  SalesNewViewController.swift
//  
//
//  Created by Jamaluddin Syed on 20/09/24.
//

import UIKit
@preconcurrency import WebKit

class SalesNewViewController: UIViewController {
    
    //    @IBOutlet weak var webview : WKWebView!
    
    // @IBOutlet weak var topview: UIView!
    @IBOutlet weak var viewback: UIView!
    
    
    @IBOutlet weak var homeBtn: UIButton!
    
    var page: URL?
    
    var webURLObserver: NSKeyValueObservation?
    
    weak var delegate: UpdatePermissionDelegate?
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = true
        webViewConfiguration.userContentController.add(self, name: "navigateTo")
        webViewConfiguration.userContentController.add(self, name: "loginbtn")
        webViewConfiguration.userContentController.add(self, name: "dropdownSelected")
        
        webview = WKWebView(frame: CGRect(origin: CGPoint.zero, size: .zero), configuration: webViewConfiguration)
        
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        webview.scrollView.maximumZoomScale = 1.0
        webview.scrollView.minimumZoomScale = 1.0
        
        if #available(iOS 14.0, *) {
            webview.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            
        }
        
        loadingIndicator.isAnimating = true
        webview.isHidden = true
        webview.scrollView.showsVerticalScrollIndicator = false
        
        webview.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        
        guard let pageurl = page else {
            loadingIndicator.isAnimating = false
            webview.isHidden = false
            return
        }
                
        webview.load(URLRequest(url: pageurl))
        
        webURLObserver = webview.observe(\.url, options: .new) { webView, change in
            
            let urlString = change.newValue!?.absoluteString
           // https://awsbackend.quickvee.com
            // "https://quickvee.com/merchants/login"
            //"https://backend.quickvee.com/login"
            if urlString == "https://backend.quickvee.com/login" {
                
                self.loadingIndicator.isAnimating = true
                self.webview.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.webview.reload()
                }
            }
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        delegate?.updatePermission()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        delegate?.updatePermission()
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: view.centerYAnchor, constant: 50),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 40),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //"https://awsbackend.quickvee.com/login"
        if webview.url!.absoluteString == "https://backend.quickvee.com/login" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                let store_name = UserDefaults.standard.string(forKey: "store_name_webview") ?? ""
                let mail = UserDefaults.standard.string(forKey: "email_webview") ?? ""
                let pass = UserDefaults.standard.string(forKey: "read_pass_webview") ?? ""
                
                self.webview.evaluateJavaScript("var input = document.getElementsByName('storename')[0]; input.focus(); document.execCommand('insertText', false, \'\(store_name)\')") { res,error in
                    
                    if error == nil {
                        
                        self.webview.evaluateJavaScript("var input = document.getElementsByName('username')[0]; input.focus(); document.execCommand('insertText', false, \'\(mail)\')") { res,error in
                            
                            if error == nil {
                                
                                self.webview.evaluateJavaScript("var input = document.getElementsByName('password')[0]; input.focus(); document.execCommand('insertText', false, \'\(pass)\');") { res,error in
                                    
                                    if error == nil {
                                        
                                        let javascript = """
                                        (function() {
                                        
                                            function loginClick() {
                                                var loginClick = document.querySelector('.MuittonBase-root.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.customer-btn.css-1hw9j7s');
                                        
                                                if (loginClick) {
                                                    loginClick.addEventListener('click', function() {
                                                    window.webkit.messageHandlers.loginbtn.postMessage(null);
                                                    });
                                                }
                                            }
                                            
                                           
                                            loginClick();
                                        
                                            var observer = new MutationObserver(function(mutations) {
                                                mutations.forEach(function(mutation) {
                                                    loginClick();
                                                });
                                            });
                                        
                                            observer.observe(document.body, { childList: true, subtree: true });
                                        })();
                                        """
                                        
                                        self.webview.evaluateJavaScript(javascript) { (result, error) in
                                            
                                            if error == nil {
                                                
                                                self.webview.evaluateJavaScript("document.querySelector('.MuiButtonBase-root.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.MuiButton-root.MuiButton-contained.MuiButton-containedPrimary.MuiButton-sizeMedium.MuiButton-containedSizeMedium.customer-btn.css-1hw9j7s').click()") { res, error in
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        
                                                        // user logo
                                                        
                                                        let script = """
                                                                var observer = new MutationObserver(function(mutationsList, observer) {
                                                                    var img = document.querySelector('img[src="/merchants/static/media/UserLogo.147f8363b761bbcbe01823d6b2f9a0c7.svg"]');
                                                                    if (img) {
                                                                        img.style.display = 'none';
                                                                          // Stop observing after the element is found
                                                                    }
                                                                });
                                                                
                                                                observer.observe(document.body, { childList: true, subtree: true });
                                                                """
                                                        
                                                        // Inject the JavaScript into the WebView
                                                        self.webview.evaluateJavaScript(script) { (result, error) in
                                                            if let error = error {
                                                                print("JavaScript evaluation error: \(error)")
                                                            } else {
                                                                print("JavaScript executed successfully")
                                                            }
                                                        }
                                                        
                                                        let scripted = """
                                                                var observer = new MutationObserver(function(mutationsList, observer) {
                                                                    var img = document.querySelector('.export-report-android');
                                                                    if (img) {
                                                                        img.style.display = 'none';
                                                                          // Stop observing after the element is found
                                                                    }
                                                                });
                                                                observer.observe(document.body, { childList: true, subtree: true });
                                                                """
                                
                                                        // Inject the JavaScript into the WebView
                                                        self.webview.evaluateJavaScript(scripted) { (result, error) in
                                                            if let error = error {
                                                                print("JavaScript evaluation error: \(error)")
                                                            } else {
                                                                print("JavaScript executed successfully")
                                                            }
                                                        }
                                                        
                                                        
                                                        let scripte = """
                                                                var observer = new MutationObserver(function(mutationsList, observer) {
                                                                    var img = document.querySelector('.MuiGrid-root.MuiGrid-direction-xs-row.css-105ekn5');
                                                                    if (img) {
                                                                        img.style.display = 'none';
                                                                          // Stop observing after the element is found
                                                                    }
                                                                });
                                                                observer.observe(document.body, { childList: true, subtree: true });
                                                                """
                                
                                                        // Inject the JavaScript into the WebView
                                                        self.webview.evaluateJavaScript(scripte) { (result, error) in
                                                            if let error = error {
                                                                print("JavaScript evaluation error: \(error)")
                                                            } else {
                                                                print("JavaScript executed successfully")
                                                            }
                                                        }
                                                        
                                                        // quickvee logo
                                                        let scriptee = """
                                                                var observer = new MutationObserver(function(mutationsList, observer) {
                                                                    var img = document.querySelector('img[src="/merchants/static/media/Qlogo.93f94457a43968c938eb7b732891c26b.svg"]');
                                                                    if (img) {
                                                                        img.style.display = 'none';
                                                                          // Stop observing after the element is found
                                                                    }
                                                                });
                                                                
                                                                observer.observe(document.body, { childList: true, subtree: true });
                                                                """
                                                        
                                                        // Inject the JavaScript into the WebView
                                                        self.webview.evaluateJavaScript(scriptee) { (result, error) in
                                                            if let error = error {
                                                                print("JavaScript evaluation error: \(error)")
                                                            } else {
                                                                print("JavaScript executed successfully")
                                                            }
                                                        }
                                                        
                                                        
                                                        //
                                                        //                                                        if self.webview.url!.absoluteString !=
                                                        //
                                                        //                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        //
                                                        //                                                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Orders-for-android { display: none; }'; document.head.appendChild(style);")
                                                        //                                                                { res, error in
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_coupon") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Coupons-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.store-name-for-android { display: none; }'; document.head.appendChild(style);")
                                                        //                                                                { res, error in
                                                        //                                                                }
                                                        //
                                                        //                                                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Mix-And-Match-Pricing-for-android { display: none; }'; document.head.appendChild(style);")
                                                        //                                                                { res, error in }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_customer") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                let javascript = """
                                                        //                                                        (function() {
                                                        //                                                            // Function to show the 'Add Coupons' link
                                                        //                                                            function showAddCouponsLink() {
                                                        //                                                                var addCouponsLink = document.querySelector('.Home-for-android');
                                                        //                                                                if (addCouponsLink) {
                                                        //                                                                    addCouponsLink.style.display = 'block';
                                                        //                                                                    addCouponsLink.addEventListener('click', function() {
                                                        //
                                                        //                                                                        window.webkit.messageHandlers.navigateTo.postMessage(null);
                                                        //                                                                    });
                                                        //                                                                }
                                                        //                                                            }
                                                        //
                                                        //
                                                        //                                                            showAddCouponsLink();
                                                        //
                                                        //                                                            // Set up MutationObserver to watch for changes in the DOM
                                                        //                                                            var observer = new MutationObserver(function(mutations) {
                                                        //                                                                mutations.forEach(function(mutation) {
                                                        //                                                                    showAddCouponsLink();
                                                        //                                                                });
                                                        //                                                            });
                                                        //
                                                        //                                                            // Start observing the body for any changes
                                                        //                                                            observer.observe(document.body, { childList: true, subtree: true });
                                                        //                                                        })();
                                                        //                                                        """
                                                        //
                                                        //                                                                self.webview.evaluateJavaScript(javascript) { (result, error) in
                                                        //
                                                        //                                                                }
                                                        //
                                                        //
                                                        //                                                                let jsCode = """
                                                        //                                                                                          (function() {
                                                        //                                                                                              function hideElements() {
                                                        //                                                                                                  var style = document.createElement('style');
                                                        //                                                                                                  style.textContent = `
                                                        //                                                                                                      .profile-menu-for-android ul li:nth-child(1),
                                                        //                                                                                                      .profile-menu-for-android ul li:nth-child(2),
                                                        //                                                                                                        .profile-menu-for-android ul li:nth-child(3),
                                                        //                                                                                                      .profile-menu-for-android ul li:nth-child(5),
                                                        //                                                                                                      .profile-menu-for-android ul li:nth-child(6) {
                                                        //                                                                                                          display: none;
                                                        //                                                                                                      }
                                                        //                                                                                                  `;
                                                        //                                                                                                  document.head.appendChild(style);
                                                        //                                                                                              }
                                                        //                                                                                              hideElements();
                                                        //                                                                                              var observer = new MutationObserver(function(mutationsList, observer) {
                                                        //                                                                                                  hideElements();
                                                        //                                                                                              });
                                                        //                                                                                              observer.observe(document.body, { childList: true, subtree: true });
                                                        //                                                                                          })();
                                                        //                                                                                          """
                                                        //
                                                        //                                                                self.webview.evaluateJavaScript(jsCode) { (result, error) in
                                                        //                                                                    if let error = error {
                                                        //                                                                        print("Error evaluating JavaScript: \(error)")
                                                        //                                                                    } else {
                                                        //                                                                        print("JavaScript evaluated successfully: \(String(describing: result))")
                                                        //                                                                    }
                                                        //                                                                }
                                                        //                                                                //login
                                                        //
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_vendors") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Vendors-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_stocktake") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Stocktake-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_dashboard_graph") {
                                                        //
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: none;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                        self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.old-dashboard-Android { display: block;}'; document.head.appendChild(style);")
                                                        //                                                                        { res, error in
                                                        //
                                                        //                                                                        }
                                                        //                                                                    }
                                                        //                                                                }
                                                        //                                                                else {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: block;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative. { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_sales_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Sales-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_inventory_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_payment_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Payment-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_register_activity") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Register-Activity-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_refund_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Refund-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_loyalty_report") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Report-for-android { pointer-events: none; opacity: 0.5;}' ; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_sc_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Credit-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_gc_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Gift-Card-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_customer_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_employee_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_tax_reports") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tax-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_employee_hours") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Hours-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_taxes") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Taxes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_employees") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_employees") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Manage-Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_timesheet") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Timesheet-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_po") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Purchase-Orders-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //                                                                //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_access_inventory") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Inventory-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_categories") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Category-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_products") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Products-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_attributes") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Attributes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_brands") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Brand-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_manage_tags") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tag-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_store_access") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Store-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_store_info") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Info-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_store_setup") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Setup-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_store_options") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Option-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_alert") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Alerts-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_inventory_settings") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_report_time") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Reporting-Time-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        //
                                                        //                                                                if UserDefaults.standard.bool(forKey: "lock_loyalty_program") {
                                                        //                                                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Program-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                                                        //                                                                    { res, error in
                                                        //                                                                    }
                                                        //                                                                }
                                                        //
                                                        
                                                        
                                                        
                                                        self.loadingIndicator.isAnimating = false
                                                        self.webview.isHidden = false
                                                        self.viewback.addSubview(self.webview)
                                                        
                                                        //                                                        let whiteview = UIView(frame: CGRect(x: self.view.bounds.width - 85, y: 20, width: 24, height: 40))
                                                        //                                                        whiteview.backgroundColor = .white
                                                        //                                                        self.viewback.addSubview(whiteview)
                                                        
                                                        self.webview.translatesAutoresizingMaskIntoConstraints = false
                                                        
                                                        self.webview.leadingAnchor.constraint(equalTo: self.viewback.leadingAnchor, constant: 0).isActive = true
                                                        
                                                        self.webview.trailingAnchor.constraint(equalTo: self.viewback.trailingAnchor, constant: 0).isActive = true
                                                        
                                                        self.webview.topAnchor.constraint(equalTo: self.viewback.topAnchor, constant: 0).isActive = true
                                                        
                                                        self.webview.bottomAnchor.constraint(equalTo: self.viewback.bottomAnchor, constant: 0).isActive = true
                                                        //                                                            }
                                                        //                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
//        if self.webview.url!.absoluteString == "e" {
//            
//            loadingIndicator.isAnimating = true
//            webview.isHidden = false
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                
//                let name = UserDefaults.standard.string(forKey: "store_name") ?? ""
//                
//                self.webview.evaluateJavaScript("var list = document.querySelectorAll('.store-items-list .store-items-store-name'); for (let i = 0; i < list.length; i++) { if (list[i].innerText.trim() == '\(name)') { list[i].click(); break;}}")
//                { res,error in
//                    
//                    if error == nil {
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            //
//                            //                            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Orders-for-android { display: none; }'; document.head.appendChild(style);")
//                            //                            { res, error in
//                            //                            }
//                            //
//                            //                            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.store-name-for-android { display: none; }'; document.head.appendChild(style);")
//                            //                            { res, error in
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_coupon") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Coupons-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_customer") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Mix-And-Match-Pricing-for-android { display: none; }'; document.head.appendChild(style);")
//                            //                            { res, error in
//                            //                            }
//                            //
//                            //                            let jsCode = """
//                            //                                                                      (function() {
//                            //                                                                          function hideElements() {
//                            //                                                                              var style = document.createElement('style');
//                            //                                                                              style.textContent = `
//                            //                                                                                  .profile-menu-for-android ul li:nth-child(1),
//                            //                                                                                  .profile-menu-for-android ul li:nth-child(2),
//                            //                                                                                    .profile-menu-for-android ul li:nth-child(3),
//                            //                                                                                  .profile-menu-for-android ul li:nth-child(5),
//                            //                                                                                  .profile-menu-for-android ul li:nth-child(6) {
//                            //                                                                                      display: none;
//                            //                                                                                  }
//                            //                                                                              `;
//                            //                                                                              document.head.appendChild(style);
//                            //                                                                          }
//                            //                                                                          hideElements();
//                            //                                                                          var observer = new MutationObserver(function(mutationsList, observer) {
//                            //                                                                              hideElements();
//                            //                                                                          });
//                            //                                                                          observer.observe(document.body, { childList: true, subtree: true });
//                            //                                                                      })();
//                            //                                                                      """
//                            //
//                            //                            self.webview.evaluateJavaScript(jsCode) { (result, error) in
//                            //                                if let error = error {
//                            //                                    print("Error evaluating JavaScript: \(error)")
//                            //                                } else {
//                            //                                    print("JavaScript evaluated successfully: \(String(describing: result))")
//                            //                                }
//                            //                            }
//                            //
//                            //                            let javascript = """
//                            //                            (function() {
//                            //                                // Function to show the 'Add Coupons' link
//                            //                                function showAddCouponsLink() {
//                            //                                    var addCouponsLink = document.querySelector('.Home-for-android');
//                            //                                    if (addCouponsLink) {
//                            //                                        addCouponsLink.style.display = 'block';
//                            //                                        addCouponsLink.addEventListener('click', function() {
//                            //
//                            //                                            window.webkit.messageHandlers.navigateTo.postMessage(null);
//                            //                                        });
//                            //                                    }
//                            //                                }
//                            //
//                            //
//                            //                                showAddCouponsLink();
//                            //
//                            //                                // Set up MutationObserver to watch for changes in the DOM
//                            //                                var observer = new MutationObserver(function(mutations) {
//                            //                                    mutations.forEach(function(mutation) {
//                            //                                        showAddCouponsLink();
//                            //                                    });
//                            //                                });
//                            //
//                            //                                // Start observing the body for any changes
//                            //                                observer.observe(document.body, { childList: true, subtree: true });
//                            //                            })();
//                            //                            """
//                            //
//                            //                            self.webview.evaluateJavaScript(javascript) { (result, error) in
//                            //
//                            //                            }
//                            //
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_vendors") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Vendors-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_stocktake") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Stocktake-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_dashboard_graph") {
//                            //
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: none;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.old-dashboard-Android { display: block;}'; document.head.appendChild(style);")
//                            //                                    { res, error in
//                            //
//                            //                                    }
//                            //                                }
//                            //                            }
//                            //                            else {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: block;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative. { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_sales_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Sales-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_inventory_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_payment_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Payment-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_register_activity") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Register-Activity-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_refund_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Refund-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_loyalty_report") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_sc_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Credit-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_gc_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Gift-Card-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_customer_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_employee_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_tax_reports") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tax-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_employee_hours") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Hours-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_taxes") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Taxes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_employees") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_employees") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Manage-Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_timesheet") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Timesheet-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_po") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Purchase-Orders-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_access_inventory") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Inventory-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_categories") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Category-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_products") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Products-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_attributes") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Attributes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_brands") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Brand-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_manage_tags") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tag-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_store_access") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Store-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_store_info") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Info-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_store_setup") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Setup-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_store_options") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Option-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_alert") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Alerts-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_inventory_settings") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_report_time") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Reporting-Time-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //
//                            //                            if UserDefaults.standard.bool(forKey: "lock_loyalty_program") {
//                            //                                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Program-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
//                            //                                { res, error in
//                            //                                }
//                            //                            }
//                            //
//                            //
//                            //
//                            
//                            
//                            
//                            self.loadingIndicator.isAnimating = false
//                            self.webview.isHidden = false
//                            self.viewback.addSubview(self.webview)
//                            
//                            self.webview.translatesAutoresizingMaskIntoConstraints = false
//                            
//                            self.webview.leadingAnchor.constraint(equalTo: self.viewback.leadingAnchor, constant: 0).isActive = true
//                            
//                            self.webview.trailingAnchor.constraint(equalTo: self.viewback.trailingAnchor, constant: 0).isActive = true
//                            
//                            self.webview.topAnchor.constraint(equalTo: self.viewback.topAnchor, constant: 0).isActive = true
//                            
//                            self.webview.bottomAnchor.constraint(equalTo: self.viewback.bottomAnchor, constant: 0).isActive = true
//                            
//                            //                            let whiteview = UIView(frame: CGRect(x: self.view.bounds.width - 85, y: 20, width: 24, height: 40))
//                            //                            whiteview.backgroundColor = .white
//                        }
//                    }
//                }
//            }
//        }
        
        //        if webview.url!.absoluteString == "" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_category") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-category-for-android').style.visibility='hidden';")
        //                    { res, error in }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_product") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.view-category-item-modal-header.viewModal-width { pointer-events: none; }'; document.head.appendChild(style);") { res, error in
        //
        //                    }
        //                }
        //
        //
        //                if UserDefaults.standard.bool(forKey: "lock_disable_category") {
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.categoryTable table thead tr th:nth-child(4) { display: none;} .categoryTable table tbody tr td:nth-child(4) { display: none;}'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_category") {
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.categoryTable table thead tr th:nth-child(5) { display: none;} .categoryTable table tbody tr td:nth-child(5) { display: none;}'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_delete_category") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.categoryTable table thead tr th:nth-child(6) { display: none;} .categoryTable table tbody tr td:nth-child(6) { display: none;}'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_disable_category") {
        //
        //                    self.webview.evaluateJavaScript("document.getElementById('disable-permission-add category').style.visibility='hidden';") { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("\") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_disable_category") {
        //
        //                    self.webview.evaluateJavaScript("document.getElementById('disable-permission-edit category').style.visibility='hidden';") { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        
        //        else if self.webview.url!.absoluteString == "" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_product") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-product-for-android').style.visibility='hidden';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_product") {
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'div#products-table table thead th:nth-child(1) { pointer-events: none; } div#products-table table tbody tr td:nth-child(1) { pointer-events: none; }'; document.head.appendChild(style);") { res, error in
        //                    }
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'div#products-table table thead th:nth-child(3) { display: none; } div#products-table table tbody tr td:nth-child(3) { display: none; }'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_delete_product") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'div#products-table table thead th:nth-child(5) { display: none; } div#products-table table tbody tr td:nth-child(5) { display: none; }'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://.com/merchants/inventory/products/edit/") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_disable_product") {
        //                    self.webview.evaluateJavaScript("document.querySelectorAll('.disable-checkbox-for-android').forEach(function(label) { label.style.display = 'none';});") { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/vendors" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_vendors") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-vendor-for-android').style.visibility='hidden';")
        //                    { res, error in
        //                    }
        //                }
        //
        //
        //                if UserDefaults.standard.bool(forKey: "lock_disable_vendors") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'div#vendors-table table thead th:nth-child(5) { display: none; } div#vendors-table table tbody tr td:nth-child(5) { display: none; }'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_vendors") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'div#vendors-table table thead th:nth-child(6) { display: none; } div#vendors-table table tbody tr td:nth-child(6) { display: none; }'; document.head.appendChild(style);") { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/stocktake" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_stocktake") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.stocktake-Add-Android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_view_stocktake") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.stocktakelisting-table-Android table tbody { pointer-events: none; }'; document.head.appendChild(style);")
        //                    { res, error in
        //
        //                    }
        //                }
        //
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://.com/merchants/stocktake/completed/") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_void_stocktake") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.stocktake-Void-Android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://.com/merchants/stocktake/UpdateStocktake/") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_stocktake") {
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.stocktakecreate-Add-Android').style.display='none';")
        //                    { res, error in
        //                    }
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.quic-btn.quic-btn-save.w-48').style.display='none';")
        //                    { res, error in
        //                    }
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.quic-btn.quic-btn-save.w-32').style.display='none';")
        //                    { res, error in
        //                    }
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.MuiTable-root.css-1j6seji thead th:nth-child(6) { display: none; } .MuiTable-root.css-1j6seji tbody tr td:nth-child(6) { display: none; }'; document.head.appendChild(style);")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/employee/addemployee" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_delete_employees") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.employee-table-for-android table thead tr th:nth-child(9) { display: none; } .employee-table-for-android table tbody tr td:nth-child(9) { display: none; }'; document.head.appendChild(style);")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/purchase-data" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_create_po") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-new-po-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_view_po") {
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = 'table#purchase-order-table tbody {pointer-events: none;}'; document.head.appendChild(style);")
        //                    { res, error in}
        //                }
        //
        //
        //
        //
        //
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://.com/merchants/purchase-data") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_po") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.edit-po-button-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_void_po") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.void-button-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_receive_po") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.receive-button-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/coupons" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_coupon") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-new-coupon-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_coupon") {
        //                    self.webview.evaluateJavaScript("document.querySelectorAll('.edit-coupon-icon-for-android').forEach(function(label) { label.style.display = 'none';});")
        //                    { res, error in
        //                    }
        //
        //                    self.webview.evaluateJavaScript("document.querySelectorAll('.q_coupon_status_btn').forEach(function(label) { label.style.display = 'none';});")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_delete_coupon") {
        //                    self.webview.evaluateJavaScript("document.querySelector('.delete-coupon-icon-for-android').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/loyalty-program" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "add_bonus_points") {
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.add-bonus-point-promotions').style.visibility='hidden';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "edit_loyalty_program") {
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.attributeUpdateBTN').style.display='none';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "edit_bonus_points") {
        //                    self.webview.evaluateJavaScript("document.querySelectorAll('.loyaty-program-card-edit-for-android').forEach(function(label) { label.style.display='none';});")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "delete_bonus_points") {
        //
        //                    self.webview.evaluateJavaScript("document.querySelectorAll('.loyaty-program-card-delete-for-android').forEach(function(label) { label.style.display='none';});")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://www..com/merchants/store-reporting") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                //                self.webview.evaluateJavaScript("function onSelectChange(event) { const selectedValue = event.target.value; window.webkit.messageHandlers.selectHandler.postMessage(selectedValue);}")
        //
        //                //                        let javascript = """
        //                //                        (function() {
        //                //
        //                //                            function dropdownChange() {
        //                //                                var dropdown = document.querySelector('.select-date-range-for-android');
        //                //
        //                //                                if (dropdown) {
        //                //                                    dropdown.addEventListener('change', function() {
        //                //                                        // Get the selected value from the dropdown
        //                //                                        var selectedValue = dropdown.value;
        //                //
        //                //                                        // Send the selected value to the native app (iOS)
        //                //                                        window.webkit.messageHandlers.dropdownSelected.postMessage(selectedValue);
        //                //                                    });
        //                //                                }
        //                //                            }
        //                //
        //                //                            dropdownChange();
        //                //
        //                //                            // Observer for dynamically added dropdowns or changes to the page
        //                //                            var observer = new MutationObserver(function(mutations) {
        //                //                                mutations.forEach(function(mutation) {
        //                //                                    dropdownChange();
        //                //                                });
        //                //                            });
        //                //
        //                //                            observer.observe(document.body, { childList: true, subtree: true });
        //                //
        //                //                        })();
        //                //        """
        //                //                        self.webview.evaluateJavaScript(javascript) { res, error in}
        //
                                                
        //
        //                let scripted = """
        //                                var observer = new MutationObserver(function(mutationsList, observer) {
        //                                    var img = document.querySelector('img[src="/merchants/static/media/UserLogo.147f8363b761bbcbe01823d6b2f9a0c7.svg"]');
        //                                    if (img) {
        //                                        img.style.display = 'none';
        //                                          // Stop observing after the element is found
        //                                    }
        //                                });
        //
        //                                observer.observe(document.body, { childList: true, subtree: true });
        //                                """
        //
        //                // Inject the JavaScript into the WebView
        //                self.webview.evaluateJavaScript(scripted) { (result, error) in
        //                    if let error = error {
        //                        print("JavaScript evaluation error: \(error)")
        //                    } else {
        //                        print("JavaScript executed successfully")
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString == "https://.com/merchants/customer" {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //                if UserDefaults.standard.bool(forKey: "lock_add_customer") {
        //
        //                    self.webview.evaluateJavaScript("document.querySelector('.q-category-bottom-header').style.visibility='hidden';")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_edit_customer") {
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.edit.cursor-pointer { display: none; }'; document.head.appendChild(style);")
        //                    { res, error in
        //                    }
        //                }
        //
        //                if UserDefaults.standard.bool(forKey: "lock_delete_customer") {
        //
        //                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.delete.cursor-pointer { display: none; }'; document.head.appendChild(style);")
        //                    { res, error in
        //                    }
        //                }
        //
        //                self.loadingIndicator.isAnimating = false
        //                self.webview.isHidden = false
        //            }
        //        }
        
        //        else if self.webview.url!.absoluteString.contains("https://.com/merchants/customer/view-customer") {
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //
        //
        //
        //
        //            }
        //        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            let script = """
                (function() {
                    // Function to show the 'Add Coupons' link
                    function showAddCouponsLink() {
                        var addCouponsLink = document.querySelector('.Home-for-android');
                        if (addCouponsLink) {
                            addCouponsLink.style.display = 'block';
                            addCouponsLink.addEventListener('click', function() {
                                
                                window.webkit.messageHandlers.navigateTo.postMessage(null);
                            });
                        }
                    }
                    
                   
                    showAddCouponsLink();
                
                    // Set up MutationObserver to watch for changes in the DOM
                    var observer = new MutationObserver(function(mutations) {
                        mutations.forEach(function(mutation) {
                            showAddCouponsLink();
                        });
                    });
                
                    // Start observing the body for any changes
                    observer.observe(document.body, { childList: true, subtree: true });
                })();
                """
            
            self.webview.evaluateJavaScript(script) { (result, error) in
                
            }
            
            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Orders-for-android { display: none; }'; document.head.appendChild(style);")
            { res, error in
            }
            
            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.store-name-for-android { display: none; }'; document.head.appendChild(style);")
            { res, error in
            }
            
            //            if UserDefaults.standard.bool(forKey: "lock_access_coupon") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Coupons-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            
            if UserDefaults.standard.bool(forKey: "lock_customer") {
                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
                { res, error in
                }
            }
            
            self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Mix-And-Match-Pricing-for-android { display: none; }'; document.head.appendChild(style);")
            { res, error in
            }
            
            
            let jsCode = """
                                              (function() {
                                                  function hideElements() {
                                                      var style = document.createElement('style');
                                                      style.textContent = `
                                                          .profile-menu-for-android ul li:nth-child(1),
                                                          .profile-menu-for-android ul li:nth-child(2),
                                                        .profile-menu-for-android ul li:nth-child(3),
                                                          .profile-menu-for-android ul li:nth-child(5),
                                                          .profile-menu-for-android ul li:nth-child(6) {
                                                              display: none;
                                                          }
                                                      `;
                                                      document.head.appendChild(style);
                                                  }
                                                  hideElements();
                                                  var observer = new MutationObserver(function(mutationsList, observer) {
                                                      hideElements();
                                                  });
                                                  observer.observe(document.body, { childList: true, subtree: true });
                                              })();
                                              """
            
            self.webview.evaluateJavaScript(jsCode) { (result, error) in
                if let error = error {
                    print("Error evaluating JavaScript: \(error)")
                } else {
                    print("JavaScript evaluated successfully: \(String(describing: result))")
                }
            }
            
            //            if UserDefaults.standard.bool(forKey: "lock_access_vendors") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Vendors-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_stocktake") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Stocktake-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
            //                }
            //            }
            
            //            self.webview.evaluateJavaScript("document.querySelector('.export-report-android').style.display='none';")
            //            { res, error in
            //            }
            
            self.loadingIndicator.isAnimating = false
            self.webview.isHidden = false
            
            
            if UserDefaults.standard.bool(forKey: "lock_dashboard_graph") {
                
                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: none;}'; document.head.appendChild(style);")
                { res, error in
                    self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.old-dashboard-Android { display: block;}'; document.head.appendChild(style);")
                    { res, error in
                        
                    }
                }
            }
            else {
                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.new-dashboard-Android { display: block;}'; document.head.appendChild(style);")
                { res, error in
                }
            }
            
            //            if UserDefaults.standard.bool(forKey: "lock_access_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.https://.com/merchants { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_sales_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Sales-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_inventory_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_payment_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Payment-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_register_activity") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Register-Activity-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_refund_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Refund-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_loyalty_report") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Report-for-android { pointer-events: none; opacity: 0.5;}' ; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_sc_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Credit-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_gc_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Gift-Card-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_customer_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Customer-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_employee_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Reports-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //
            //            if UserDefaults.standard.bool(forKey: "lock_tax_reports") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tax-Report-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_employee_hours") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Employee-Hours-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //
            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_taxes") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Taxes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_employees") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_employees") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Manage-Employees-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_timesheet") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Timesheet-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);") { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_po") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Purchase-Orders-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //            //
            //            if UserDefaults.standard.bool(forKey: "lock_access_inventory") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Inventory-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_categories") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Category-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_products") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Products-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_attributes") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Attributes-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_brands") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Brand-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_manage_tags") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Tag-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_store_access") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.relative.Store-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_store_info") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Info-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_store_setup") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Setup-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_store_options") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Store-Option-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_alert") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Alerts-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_inventory_settings") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Inventory-Settings-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //            if UserDefaults.standard.bool(forKey: "lock_report_time") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Reporting-Time-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
            //
            //
            //            if UserDefaults.standard.bool(forKey: "lock_loyalty_program") {
            //                self.webview.evaluateJavaScript("var style = document.createElement('style'); style.innerHTML = '.Loyalty-Program-for-android { pointer-events: none; opacity: 0.5;}'; document.head.appendChild(style);")
            //                { res, error in
            //                }
            //            }
        }
    }
}

extension SalesNewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}


extension SalesNewViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "navigateTo" {
            
            if UserDefaults.standard.bool(forKey: "goToHome") {
                UserDefaults.standard.set(false, forKey: "home_return")
                UserDefaults.standard.set(false, forKey: "goToHome")
                delegate?.updatePermission()
                navigationController?.popViewController(animated: true)
            }
        }
        
        else if message.name == "loginbtn" {

//            self.webview.evaluateJavaScript("document.getElementsByName('username')[0].value") { res,error in
//
//                if error == nil {
//
//                    let text = res as! String
//                    let mail = UserDefaults.standard.string(forKey: "merchant_email") ?? ""
//
//                    if text != mail {
//                        self.webview.stopLoading()
//                        let javascript = "alert('Please login with the same credentials as that of in the app.');"
//                        self.webview.evaluateJavaScript(javascript) { (result, error) in
//                            if let error = error {
//                                print("JavaScript evaluation error: \(error)")
//                            }
//                        }
//                    }
//                    else {
//                        self.webview.evaluateJavaScript("document.getElementsByName('password')[0].value") { res,error in
//
//                            let pass = res as! String
//                            UserDefaults.standard.set(pass, forKey: "merchant_password")
//                        }
//                    }
//                }
//            }
            
            let store_name = UserDefaults.standard.string(forKey: "store_name_webview") ?? ""
            let mail = UserDefaults.standard.string(forKey: "email_webview") ?? ""
            let pass = UserDefaults.standard.string(forKey: "read_pass_webview") ?? ""
            
            if store_name == "" || mail == "" || pass == "" {
                view.bringSubviewToFront(homeBtn)
            }
        }
        
        else if message.name == "dropdownSelected" {

//            webview.isHidden = true
//            loadingIndicator.isAnimating = true

//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.webview.evaluateJavaScript("document.querySelector('.export-report-android').style.display='none';")
//                { res, error in
//                    self.loadingIndicator.isAnimating = false
//                    self.webview.isHidden = false
//                }
//            }
        }
    }
}

extension SalesNewViewController: WKUIDelegate {
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
