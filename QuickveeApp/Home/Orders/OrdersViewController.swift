//
//  OrdersViewController.swift
//
//
//  Created by Jamaluddin Syed on 06/06/23.
//

import UIKit

class OrdersViewController: UIViewController {
   
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ordersContentView: UIView!
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var orderTitle: UILabel!
    
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var homeWidth: NSLayoutConstraint!
  
    var search = false
    
    var pageViewController = PageViewController()
    let tabs = ["Online", "Store"]
    var currentVC = 0
    var merchant_id: String?
    
    let pageControl = UIPageControl()
    
    let subControllers: [UIViewController] =
    [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "orderOnline"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "orderInStore")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        topview.addBottomShadow()
        configure()
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageControl.numberOfPages = subControllers.count
        pageControl.currentPage = 0
        
        pageViewController.setViewControllers([subControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        UserDefaults.standard.set(0, forKey: "orders_highlight")
   
        if search {
            if currentVC == 0 {
                
                let vc = subControllers[0] as! OrderOnlineViewController
                
            }
            else {
                //                let vc = subControllers[1] as! OrderInStoreViewController
                //                let tap = UITapGestureRecognizer(target: self, action: #selector(searchTap))
                //                vc.tableview.addGestureRecognizer(tap)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        
        backBtn.alpha = 1
        orderTitle.alpha = 1
        searchBtn.alpha = 1
        searchBar.text = ""
        searchBar.alpha = 0
        filterBtn.alpha = 1
        homeBtn.alpha = 1
        homeWidth.constant = 50
        
        collectionView.isHidden = false
        collectionHeight.constant = 50
        
    }
   
    func configure() {
        
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        ordersContentView.addSubview(pageViewController.view)
        
        let views : [String:Any] = ["pageView": pageViewController.view]
        
        ordersContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        ordersContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
    }
    
    
    func send(str: Int) {
        UserDefaults.standard.set(str, forKey: "orders_highlight")
        selectHighlight()
    }
    
    func selectHighlight() {
        
        UIView.transition(with: collectionView, duration: 1.0, animations: {
            
            self.collectionView.reloadData()
        })
    }
  
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        backBtn.alpha = 0
        orderTitle.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        filterBtn.alpha = 0
        homeBtn.alpha = 0
        homeWidth.constant = 0
        
        collectionView.isHidden = true
        collectionHeight.constant = 0
        
        
        if currentVC == 0 {
            let vc = subControllers[0] as! OrderOnlineViewController
            vc.onlineStack.isHidden = true
            vc.onlineStackHeight.constant = 0
            vc.searchMode = true
            
            searchBar.placeholder = "Search Orders by name or order id"
        }
        
        else {
            let vc = subControllers[1] as! OrderInStoreViewController
            vc.storeStack.isHidden = true
            vc.instoreStackHeight.constant = 0
            vc.searchMode = true
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                searchBar.placeholder = "Search Orders by name, order ID, or the last 4 digits of credit card."
            }
            else {
                searchBar.placeholder = "Search Orders by name, order ID, or the last 4 digits of credit card."
            }
        }
        
        searchBar.text = ""
    }
    
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "orderFilter") as! OrderFilterViewController
        
        if currentVC == 0 {
            vc.hideType = false
            let mode = UserDefaults.standard.string(forKey: "modeOnlineSelected") ?? ""
            vc.filterMode = mode
        }
        else {
            vc.hideType = true
            let mode = UserDefaults.standard.string(forKey: "modeSelected") ?? ""
            vc.filterMode = mode
        }
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension OrdersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            if currentVC == 0 {
                let vc = subControllers[0] as! OrderOnlineViewController
                
                vc.tableview.isHidden = true
                vc.loadingIndicator.isAnimating = false
            }
            
            else {
                let vc = subControllers[1] as! OrderInStoreViewController
                
                vc.tableview.isHidden = true
                vc.loadingIndicator.isAnimating = false
            }
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if currentVC == 0 {
            
            let vc = subControllers[0] as! OrderOnlineViewController
            search = true
            vc.performSearch(searchText: searchBar.text ?? "")
            
        }
        else if currentVC == 1{
            let vc = subControllers[1] as! OrderInStoreViewController
            search = true
            vc.performSearch(searchText: searchBar.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        backBtn.alpha = 1
        orderTitle.alpha = 1
        searchBtn.alpha = 1
        searchBar.text = ""
        searchBar.alpha = 0
        filterBtn.alpha = 1
        homeBtn.alpha = 1
        homeWidth.constant = 50
        
        collectionView.isHidden = false
        collectionHeight.constant = 50
        
        if currentVC == 0 {
            let vc = subControllers[0] as! OrderOnlineViewController
            vc.onlineStack.isHidden = false
            vc.onlineStackHeight.constant = 40
            vc.searchMode = false
            vc.tableview.isHidden = true
            vc.loadingIndicator.isAnimating = true
            
            if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "new" {
                vc.buttonShadow(tag: 1)
            }
            else  if UserDefaults.standard.string(forKey: "modeOnlineSelected") == "closed" {
                vc.buttonShadow(tag: 2)
            }
            else {
                vc.buttonShadow(tag: 3)
            }
        }
        
        else {
            let vc = subControllers[1] as! OrderInStoreViewController
            vc.storeStack.isHidden = false
            vc.instoreStackHeight.constant = 40
            vc.searchMode = false
            vc.tableview.isHidden = true
            vc.loadingIndicator.isAnimating = true
            
            if UserDefaults.standard.string(forKey: "modeSelected") == "paid" {
                vc.buttonShadow(tag: 1)
            }
            else {
                vc.buttonShadow(tag: 2)
            }
        }
        
        searchBar.resignFirstResponder()
    }
}

extension OrdersViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = subControllers.firstIndex(of: viewController) else {
            return nil
        }
        print(viewControllerIndex)
        let previousIndex = viewControllerIndex - 1
        print(previousIndex)
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard subControllers.count > previousIndex else {
            return nil
        }
        
        return subControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = subControllers.firstIndex(of: viewController) else {
            return nil
        }
        print(viewControllerIndex)
        let nextIndex = viewControllerIndex + 1
        print(nextIndex)
        
        
        let orderedViewControllersCount = subControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return subControllers[nextIndex]
    }
}

extension OrdersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OrdersCollectionViewCell
        
        cell.orderTabText.text = tabs[indexPath.row]
        cell.orderTabText.textColor = .black
        
        if indexPath.row == UserDefaults.standard.integer(forKey: "orders_highlight") {
            cell.orderTabText.textColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            cell.orderHighlight.isHidden = false
        }
        
        else {
            cell.orderTabText.textColor = .black
            cell.orderHighlight.isHidden = true
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width / 2
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        print(cell!.tag)
        
        let deselect = pageControl.currentPage
        
        if pageControl.currentPage < cell!.tag {
            pageControl.currentPage += 1
            pageViewController.setViewControllers([subControllers[cell!.tag]], direction: .forward, animated: true, completion: nil)
        }
        else {
            pageControl.currentPage -= 1
            pageViewController.setViewControllers([subControllers[cell!.tag]], direction: .reverse, animated: true, completion: nil)
        }
        UserDefaults.standard.set(cell!.tag, forKey: "orders_highlight")
        selectHighlight()
        collectionView.deselectItem(at: indexPath, animated: true)
        
        currentVC = cell!.tag
        
        if currentVC == 0 {
            UserDefaults.standard.set("new", forKey: "modeOnlineSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_paid_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_paid_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_refund_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_refund_max_amt")
            
        }
        else {
            UserDefaults.standard.set("paid", forKey: "modeSelected")
        }
        
        if search {
            if currentVC == 0 {
                
            }
            else {
                
            }
        }
    }
}

extension OrdersViewController : UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = subControllers.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        send(str: currentIndex)
        
        currentVC = currentIndex
        
        if currentVC == 0 {
            
            UserDefaults.standard.set("new", forKey: "modeOnlineSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_paid_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_paid_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_paid_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_paid_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_refund_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_refund_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_refund_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_refund_max_amt")
            
        }
        else {
            UserDefaults.standard.set("paid", forKey: "modeSelected")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_new_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_new_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_new_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_closed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_closed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_closed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_closed_max_amt")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "temp_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "temp_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "temp_order_failed_max_amt")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_start_date")
            UserDefaults.standard.set("", forKey: "valid_order_failed_end_date")
            
            UserDefaults.standard.set("", forKey: "valid_order_failed_min_amt")
            UserDefaults.standard.set("", forKey: "valid_order_failed_max_amt")
            
        }
        
        if search {
            if currentVC == 0 {
                
                let vc = subControllers[0] as! OrderOnlineViewController
                
            }
            else {
                //                let vc = subControllers[1] as! OrderInStoreViewController
                //                let tap = UITapGestureRecognizer(target: self, action: #selector(searchTap))
                //                vc.tableview.addGestureRecognizer(tap)
            }
        }
        
    }
}

//extension UIPageViewController {
//
//    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        guard let currentPage = viewControllers?[0] else { return }
//        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
//
//        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
//    }
//
//    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        guard let currentPage = viewControllers?[0] else { return }
//        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
//
//        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
//    }
//
//    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
//        setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
//    }
//}
