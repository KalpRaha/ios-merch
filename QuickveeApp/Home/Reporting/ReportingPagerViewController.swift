//
//  ReportingPagerViewController.swift
//
//
//  Created by Jamaluddin Syed on 12/01/23.
//

import UIKit
import DropDown
class ReportingPagerViewController: UIViewController {
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var pageContentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var pageViewController = PageViewController()
    
    let menu = DropDown()
    
    let tabs = ["Sales Overview", "Item Sales", "Order Types", "Taxes"]
    
    var currentVC = 0
    
    let pageControl = UIPageControl()
    
    let subControllers: [UIViewController] =
    [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Sales"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemSales"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Order"),
     UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Taxes")]
    
    var merchant_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        topView.addBottomShadow()
        
        collection.delegate = self
        collection.dataSource = self
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageControl.numberOfPages = subControllers.count
        pageControl.currentPage = 0
        
        pageViewController.setViewControllers([subControllers[0]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        UserDefaults.standard.set(0, forKey: "highlight")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    
    func configure() {
        
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageContentView.addSubview(pageViewController.view)
        
        let views : [String:Any] = ["pageView": pageViewController.view]
        
        pageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        pageContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
    }
    
    func send(str: Int) {
        UserDefaults.standard.set(str, forKey: "highlight")
        selectHighlight()
    }
    
    func selectHighlight() {
        
        UIView.transition(with: collection, duration: 1.0, animations: {
            
            self.collection.reloadData()
        })
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    @IBAction func infoClick(_ sender: UIButton) {
        
        showAlert(title: "Info", message: "Default or Sales tax is included with Convenience fee tax!")
    }
    
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonClick(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "newFilter") as! FilterNewViewController
        vc.navigationController?.isNavigationBarHidden = true
        vc.identity = currentVC
        
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func homeButtonClick(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension ReportingPagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReportingTabsCollectionViewCell
        
        cell.tabText.text = tabs[indexPath.row]
        cell.tabText.textColor = .black
        
        if indexPath.row == UserDefaults.standard.integer(forKey: "highlight") {
            cell.tabText.textColor = UIColor(red: 10.0/255.0, green: 100.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            cell.highlight.isHidden = false
        }
        
        else {
            cell.tabText.textColor = .black
            cell.highlight.isHidden = true
        }
        
        if indexPath.row == 3 {
            cell.infoButton.isHidden = false
        }
        else {
            cell.infoButton.isHidden = true
        }
        
        cell.tag = indexPath.row
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collection.bounds.size.width
        return CGSize(width: width * 0.35, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collection.cellForItem(at: indexPath)
        
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
        UserDefaults.standard.set(cell!.tag, forKey: "highlight")
        selectHighlight()
        collection.deselectItem(at: indexPath, animated: true)
        
        currentVC = cell!.tag
    }
}

extension ReportingPagerViewController: UIPageViewControllerDataSource {
    
    
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

extension ReportingPagerViewController : UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = subControllers.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        send(str: currentIndex)
        
        if currentIndex == 3 {
            let indexPath = IndexPath(item: 3, section: 0)
            collection.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        
        if currentIndex == 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collection.scrollToItem(at: indexPath, at: .left, animated: true)
            
        }
        
        currentVC = currentIndex
        
    }
}

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
        
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
        
        
    }
}
