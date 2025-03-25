//
//  InventoryViewController.swift
//  
//
//  Created by Jamaluddin Syed on 9/4/23.
//

import UIKit
import BarcodeScanner


class InventoryViewController: UIViewController {
    
    
    var contents = ["Category", "Products", "Attributes", "Variants", "Brands", "Tags", "Stocktake", "Lottery"]
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var inventContentView: UIView!
    @IBOutlet weak var blackview: UIView!
    
    @IBOutlet weak var invent_lbl: UILabel!
    
    @IBOutlet weak var syncbtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var scanUpcBtn: UIButton!
    
    @IBOutlet weak var scanWidth: NSLayoutConstraint!
    
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.systemBlue], lineWidth: 3)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    var currentIndex = Int()
    var deselect = 0
    var pageViewController = PageViewController()
    var currentVC = 0
    var setHeight = 0
    var searching = false
    var searchInventoryArray = [InventoryCategory]()
    
    var categoryList = [InventoryCategory]()
    
    var isLottery = false
    
    let pageControl = UIPageControl()
    
    var subControllers: [UIViewController] =
    [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventCategory"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventProduct"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventAttribute"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventVariant"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventBrand"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventTags"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventStock"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inventLottery")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackview.isHidden = true
        
        topView.addBottomShadow()
        
        isLottery = UserDefaults.standard.bool(forKey: "lottery_inventory")
        
        if isLottery {
            // nothing
        }
        else {
            subControllers.remove(at: 7)
            contents.remove(at: 7)
        }
        
        configure()
        
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageControl.numberOfPages = subControllers.count
        pageControl.currentPage = 0
        
        pageViewController.setViewControllers([subControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        UserDefaults.standard.set(0, forKey: "inventory_highlight")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchTap))
        blackview.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        blackview.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBtn.alpha = 1
        searchBar.alpha = 0
        scanUpcBtn.alpha = 1
        syncbtn.alpha = 1
        backBtn.alpha = 1
        invent_lbl.alpha = 1
        searchBar.showsCancelButton = true
        searchBar.iq.resignOnTouchOutsideMode = .enabled
        searchBar.iq.toolbar.doneBarButton
        
       
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            backBtn.isHidden = false
            invent_lbl.textAlignment = .left
        }
        
        else {
            backBtn.isHidden = true
            invent_lbl.textAlignment = .center
        }
        navigationController?.isNavigationBarHidden = true
        splitViewController?.view.backgroundColor = .lightGray
        searching = false
        
        if UserDefaults.standard.integer(forKey: "inventory_highlight") == 1 ||
            UserDefaults.standard.integer(forKey: "inventory_highlight") == 3
            //||UserDefaults.standard.integer(forKey: "inventory_highlight") == 6
        {
            
            scanUpcBtn.isHidden = false
            scanWidth.constant = 50
        }
        
        else {
            scanUpcBtn.isHidden = true
            scanWidth.constant = 0
        }
    }
    
    @objc func searchTap(){
        searchBar.resignFirstResponder()
        blackview.isHidden = true
    }
    
    func configure() {
        
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        inventContentView.addSubview(pageViewController.view)
        
        let views : [String:Any] = ["pageView": pageViewController.view]
        
        inventContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        inventContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func send(str: Int) {
        UserDefaults.standard.set(str, forKey: "inventory_highlight")
        selectHighlight()
    }
    
    func selectHighlight() {
        
        UIView.transition(with: collection, duration: 1.0, animations: {
            
            self.collection.reloadData()
        })
    }
    
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        let viewcontrollerArray = navigationController?.viewControllers
        var destiny = 0
        if let destinationIndex = viewcontrollerArray!.firstIndex(where: { $0 is HomeViewController }) {
            destiny = destinationIndex
        }
        
        navigationController?.popToViewController(viewcontrollerArray![destiny], animated: true)
    }
    
    
    
    @IBAction func syncDataBtn(_ sender: UIButton) {
        setupUI()

        syncbtn.alpha = 0
        loadingIndicator.isAnimating = true
        
        let id = UserDefaults.standard.string(forKey: "merchant_id") ?? ""
        
        ApiCalls.sharedCall.SyncDataCall(merchant_id: id) { isSuccess, responseData in
            
            if isSuccess {
                
                guard let list = responseData["message"] else {
                    self.syncbtn.alpha = 1
                    self.loadingIndicator.isAnimating = false
                    self.loadingIndicator.removeFromSuperview()

                    return
                }
                print(list)
                ToastClass.sharedToast.showToast(message: "Your Data has been Synced", 
                                                 font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
         
                self.syncbtn.alpha = 1
                self.loadingIndicator.isAnimating = false
                self.loadingIndicator.removeFromSuperview()

            }else{
                print("Api Error")
                self.syncbtn.alpha = 1
                self.loadingIndicator.isAnimating = false
                self.loadingIndicator.removeFromSuperview()

            }
        }
        
    }
    
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
            
        syncbtn.alpha = 0
        backBtn.alpha = 0
        invent_lbl.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        scanUpcBtn.alpha = 0
        
        blackview.isHidden = false
        
        searchBar.text = ""
        
        if isLottery {
         
            if currentVC == 0 {
                searchBar.placeholder = "Search Category"
            }
            else if currentVC == 1 {
                searchBar.placeholder = "Search Product"
            }
            else if currentVC == 2 {
                searchBar.placeholder = "Search Attribute"
            }
            else if currentVC == 3 {
                searchBar.placeholder = "Search Variants"
            }
            else if currentVC == 4 {
                searchBar.placeholder = "Search Brands"
            }
            else if currentVC == 5 {
                searchBar.placeholder = "Search Tags"
            }
            else if currentVC == 6 {
                searchBar.placeholder = "Search Stock"
            }
            else {
                searchBar.placeholder = "Search Lottery"
            }
        }
        
        else {
            
            if currentVC == 0 {
                searchBar.placeholder = "Search Category"
            }
            else if currentVC == 1 {
                searchBar.placeholder = "Search Product"
            }
            else if currentVC == 2 {
                searchBar.placeholder = "Search Attribute"
            }
            else if currentVC == 3 {
                searchBar.placeholder = "Search Variants"
            }
            else if currentVC == 4 {
                searchBar.placeholder = "Search Brands"
            }
            else if currentVC == 5 {
                searchBar.placeholder = "Search Tags"
            }
            else {
                searchBar.placeholder = "Search Stock"
            }
        }
        
        searchBar.becomeFirstResponder()
        
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        let vc = BarcodeScannerViewController()
        vc.codeDelegate = self
        vc.errorDelegate = self
        vc.dismissalDelegate = self
        
        self.present(vc, animated: true)
    }
    
    
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        topView.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: syncbtn.centerXAnchor, constant: 0),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: syncbtn.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 15),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
}

extension InventoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isLottery {
            
            if currentVC == 0 {
                
                let vc = subControllers[0] as! CategoryViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 1 {
                let vc = subControllers[1] as! ProductsViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 2 {
                let vc = subControllers[2] as! AttributeViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 3 {
                let vc = subControllers[3] as! VariantViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 4 {
                let vc = subControllers[4] as! BrandsTagsViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 5 {
                let vc = subControllers[5] as! TagsViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 6 {
                let vc = subControllers[6] as! StockTakeViewController
                vc.performSearch(searchText: searchText)
            }
            else {
                let vc = subControllers[7] as! LotteryViewController
                vc.performSearch(searchText: searchText)
          
            }
        }
        
        else {
            
            if currentVC == 0 {
                
                let vc = subControllers[0] as! CategoryViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 1 {
                let vc = subControllers[1] as! ProductsViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 2 {
                let vc = subControllers[2] as! AttributeViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 3 {
                let vc = subControllers[3] as! VariantViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 4 {
                let vc = subControllers[4] as! BrandsTagsViewController
                vc.performSearch(searchText: searchText)
            }
            else if currentVC == 5 {
                let vc = subControllers[5] as! TagsViewController
                vc.performSearch(searchText: searchText)
            }
            else {
                let vc = subControllers[6] as! StockTakeViewController
                vc.performSearch(searchText: searchText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        syncbtn.alpha = 1
        backBtn.alpha = 1
        invent_lbl.alpha = 1
        searchBtn.alpha = 1
        scanUpcBtn.alpha = 1
        searchBar.alpha = 0
        
        blackview.isHidden = true
        
        view.endEditing(true)
        
        if isLottery {
            if currentVC == 0 {
                let vc = subControllers[0] as! CategoryViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 1{
                
                let vc = subControllers[1] as! ProductsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 2 {
                
                let vc = subControllers[2] as! AttributeViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 3 {
                let vc = subControllers[3] as! VariantViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 4 {
                let vc = subControllers[4] as! BrandsTagsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 5 {
                let vc = subControllers[5] as! TagsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 6 {
                let vc = subControllers[6] as! StockTakeViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else {
                let vc = subControllers[7] as! LotteryViewController
                vc.searching = false
                vc.performSearch(searchText: "")
                
                
            }
        }
        
        else {
            
            if currentVC == 0 {
                let vc = subControllers[0] as! CategoryViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 1{
                
                let vc = subControllers[1] as! ProductsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 2 {
                
                let vc = subControllers[2] as! AttributeViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 3 {
                let vc = subControllers[3] as! VariantViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 4 {
                let vc = subControllers[4] as! BrandsTagsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else if currentVC == 5 {
                let vc = subControllers[5] as! TagsViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
            else {
                let vc = subControllers[6] as! StockTakeViewController
                vc.searching = false
                vc.performSearch(searchText: "")
            }
        }
    }
}


extension InventoryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = subControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
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
        
        let nextIndex = viewControllerIndex + 1
        
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


extension InventoryViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        print("diddismiss")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didReceiveError error: Error) {
        print("error")
    }
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("success")
        
        syncbtn.alpha = 0
        backBtn.alpha = 0
        invent_lbl.alpha = 0
        searchBtn.alpha = 0
        searchBar.alpha = 1
        scanUpcBtn.alpha = 0
        
        searchBar.text = code
        
        searchBar.becomeFirstResponder()
        controller.dismiss(animated: true)
        
        if currentVC == 1 {
            let vc = subControllers[1] as! ProductsViewController
            vc.performSearch(searchText: code)
        }
        else if currentVC == 3 {
            let vc = subControllers[3] as! VariantViewController
            vc.performSearch(searchText: code)
        }
        else if currentVC == 6 {
            let vc = subControllers[6] as! StockTakeViewController
            vc.performSearch(searchText: code)
        }
        else {
            let vc = subControllers[7] as! LotteryViewController
            vc.performSearch(searchText: code)
            
          
        }
    }
}

extension InventoryViewController : UIPageViewControllerDelegate {
    

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, 
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let cI = subControllers.firstIndex(of: viewControllers[0]) else { return }
        
        currentIndex = cI
        
        pageControl.currentPage = currentIndex
        
        deselect = pageControl.currentPage
        send(str: currentIndex)
        
        
        if currentIndex == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            collection.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        
        else if currentIndex == 2 {
            let indexPath = IndexPath(item: 2, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 3 {
            let indexPath = IndexPath(item: 3, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 4 {
            let indexPath = IndexPath(item: 4, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 5 {
            let indexPath = IndexPath(item: 5, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 6 {
            let indexPath = IndexPath(item: 6, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 7 {
            let indexPath = IndexPath(item: 7, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        if currentIndex == 0 || currentIndex == 2 || currentIndex == 3 || currentIndex == 4 || currentIndex == 5 || currentIndex == 6 {
            
            let vc = subControllers[1] as! ProductsViewController
            vc.selectArray = []
        }
        
        if currentIndex == 0 || currentIndex == 2 || currentIndex == 1 || currentIndex == 4 || currentIndex == 5 || currentIndex == 6 {
            let vc1 = subControllers[3] as! VariantViewController
            vc1.selectArray = []
        }
        
        currentVC = currentIndex
        
        if isLottery {
           
            if currentIndex == 1 || currentIndex == 3 {
                scanUpcBtn.isHidden = false
                scanWidth.constant = 50
            }
            else {
                scanUpcBtn.isHidden = true
                scanWidth.constant = 0
            }
        }
        
        else {
            if currentIndex == 1 || currentIndex == 3 {
                scanUpcBtn.isHidden = false
                scanWidth.constant = 50
            }
            else {
                scanUpcBtn.isHidden = true
                scanWidth.constant = 0
            }
        }
      
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InventoryCollectionViewCell
        
        cell.inventoryLabel.text = contents[indexPath.row]
        
        if indexPath.row == UserDefaults.standard.integer(forKey: "inventory_highlight") {
            cell.inventoryLabel.textColor = UIColor(named: "SelectCat")
            cell.highlight.isHidden = false
        }
        
        else {
            cell.inventoryLabel.textColor = UIColor(named: "lightText")
            cell.highlight.isHidden = true
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collection.bounds.size.width / 2
        return CGSize(width: width * 0.75, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        deselect = pageControl.currentPage
        
        if pageControl.currentPage < cell!.tag {
            pageControl.currentPage += 1
            pageViewController.setViewControllers([subControllers[cell!.tag]], direction: .forward, animated: true, completion: nil)
        }
        else {
            pageControl.currentPage -= 1
            pageViewController.setViewControllers([subControllers[cell!.tag]], direction: .reverse, animated: true, completion: nil)
        }
        
        UserDefaults.standard.set(cell!.tag, forKey: "inventory_highlight")
        selectHighlight()
        collectionView.deselectItem(at: indexPath, animated: true)
        
        currentVC = cell!.tag
        
        currentIndex = currentVC
        
        if currentIndex == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            collection.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        
        else if currentIndex == 2 {
            let indexPath = IndexPath(item: 2, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 3 {
            let indexPath = IndexPath(item: 3, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 4 {
            let indexPath = IndexPath(item: 4, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 5 {
            let indexPath = IndexPath(item: 5, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 6 {
            let indexPath = IndexPath(item: 6, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        else if currentIndex == 7 {
            let indexPath = IndexPath(item: 7, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
        if currentIndex == 0 || currentIndex == 2 || currentIndex == 3 || currentIndex == 4 || currentIndex == 5 || currentIndex == 6  {
            
            let vc = subControllers[1] as! ProductsViewController
            vc.selectArray = []
        }
        
        
        if currentIndex == 0 || currentIndex == 1 || currentIndex == 2 || currentIndex == 4 || currentIndex == 5 || currentIndex == 6 {
            let vc1 = subControllers[3] as! VariantViewController
            vc1.selectArray = []
        }
        
        if isLottery {
            if indexPath.row == 1 || indexPath.row == 3 {
                scanUpcBtn.isHidden = false
                scanWidth.constant = 50
            }
            else {
                scanUpcBtn.isHidden = true
                scanWidth.constant = 0
            }
        }
        
        else {
            if indexPath.row == 1 || indexPath.row == 3 {
                scanUpcBtn.isHidden = false
                scanWidth.constant = 50
            }
            else {
                scanUpcBtn.isHidden = true
                scanWidth.constant = 0
            }
        }
        
        searchBar.text = ""
        syncbtn.alpha = 1
        backBtn.alpha = 1
        invent_lbl.alpha = 1
        searchBtn.alpha = 1
        scanUpcBtn.alpha = 1
        searchBar.alpha = 0
        
    }
}
