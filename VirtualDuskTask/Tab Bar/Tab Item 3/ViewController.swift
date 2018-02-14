//
//  ViewController.swift
//  VirtualDuskTask
//
//  Created by Pavankumar G on 13/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//

//MARK: - Singleton class 


class AccountManager {
    static let sharedInstance = AccountManager()
    
    var userInfo = (ID: "bobthedev", Password: 01036343984)
    var readStringProject = ""
    let fileURLProject = Bundle.main.path(forResource: "CollectionJSON", ofType: "txt")
        // Read from the file
    
        var tempDict : NSDictionary = [:]
    
    
    
    // Networking: communicating server
    func network() -> NSDictionary? {
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
            
            
        } catch let error as NSError {
            print("Failed reading from URL:, Error: " + error.localizedDescription)
        }
        
        let jsonData = readStringProject.data(using: .utf8)
        
        if let urlCont = jsonData {
            
            do {
                
                let jsonResult  = try JSONSerialization.jsonObject(with: urlCont, options:
                    JSONSerialization.ReadingOptions.mutableContainers)
                
                tempDict = jsonResult as! NSDictionary
                return tempDict
            }catch {
                
                print("JSON Processing Failed")
                return nil
            }
        }
        return nil
        // get everything
    }
    
    private init() { }
}

//MARK: - UIImageView extension

extension UIImageView {
    public func imageFromServerURL(urlString: String) -> UIImage {
        var imagee = UIImage.init(named: "degaultImage")
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                imagee = image
               
            })
            
            
        }).resume()
        return imagee!
    }
    
}


import UIKit




class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var userProfileLinkBtnPrty: UIButton!
    @IBOutlet weak var navigationBarObj: UINavigationBar!
    @IBOutlet weak var btnTab1: UIButton!
    
    @IBOutlet weak var btnTab2: UIButton!
    
    @IBOutlet weak var btnTab3: UIButton!
    @IBOutlet weak var btnTab4: UIButton!
   
    
    @IBOutlet weak var profileDetailsBackGroundViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageProperty: UIImageView!
    @IBOutlet weak var editProfileBtnProperty: UIButton!
    
    var tab1VC:GridViewController! = nil
    var tab2VC:MenuViewController! = nil
    var tab3VC:LocationViewController! = nil
    var tab4VC:ProfileDetailsViewController! = nil
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!

    var tempImageArray : NSMutableArray = []
    var tempDict : NSDictionary = [:]
    
    //MARK: - View Life cycle method

    override func viewDidLoad() {
        super.viewDidLoad()
        // Using singleton we can access the TXT file data in different view controllers
        
//       let shhh =  AccountManager.sharedInstance.network()
//        print(shhh!)

        let fileURLProject = Bundle.main.path(forResource: "CollectionJSON", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        
        
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
            
            
        } catch let error as NSError {
            print("Failed reading from URL:, Error: " + error.localizedDescription)
        }
        
        let jsonData = readStringProject.data(using: .utf8)

        if let urlCont = jsonData {
            
            do {
                
                let jsonResult  = try JSONSerialization.jsonObject(with: urlCont, options:
                    JSONSerialization.ReadingOptions.mutableContainers)
                
                tempDict = jsonResult as! NSDictionary
            }catch {
                
                print("JSON Processing Failed")
            }
        }
        
     //   print(readStringProject)

      //  print("tempDict:\(tempDict)")

        navigationBarObj.topItem?.title = tempDict.value(forKey: "title") as? String
        
        tempImageArray = (tempDict.value(forKey: "items") as? NSMutableArray)!
        
        let str:String! = tempDict.value(forKey: "link") as! String
        
        
        self.userProfileLinkBtnPrty.setTitle(str, for: UIControlState.normal)
        
         currentPage = 0
        
         DispatchQueue.main.async(execute: {
        self.profileImageProperty.layer.cornerRadius = self.profileImageProperty.frame.size.width/2
            self.profileImageProperty.layer.masksToBounds = true
         })
        
        self.profileImageProperty.contentMode = .scaleAspectFit
        self.profileImageProperty.clipsToBounds = true
        
        self.profileImageProperty.image = UIImage.init(named: "profilePicture")
        let colorr : UIColor = UIColor.init(patternImage: UIImage.init(named: "profilePicture")!)
        self.profileImageProperty.backgroundColor = colorr
        self.profileImageProperty.backgroundColor = self.profileImageProperty.backgroundColor?.withAlphaComponent(0.9)
        

        createPageViewController()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Memory Warning method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - All four Button actions

    
    @IBAction func anyOneBtnClickedAction(_ sender: UIButton)
    {
        
        pageController.setViewControllers([arrVC[sender.tag-1]], direction: UIPageViewControllerNavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
                 })
        resetTabBarForTag(tag: sender.tag-1)
        
    }
    
    //MARK: - CreatePagination
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: self.profileDetailsBackGroundViewHeight.constant+self.btnTab1.frame.size.height+64, width: self.view.frame.size.width, height: self.view.frame.size.height-self.profileDetailsBackGroundViewHeight.constant-self.btnTab1.frame.size.height-64)
        }
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tab1VC = homeStoryboard.instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
        tab2VC = homeStoryboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        tab3VC = homeStoryboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        
        tab4VC = homeStoryboard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as! ProfileDetailsViewController
        
        arrVC = [tab1VC, tab2VC, tab3VC, tab4VC]
        btnTab1.backgroundColor = UIColor.lightGray
        pageController.setViewControllers([tab1VC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
    }
    
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller))
        {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
        }
    }
    
    //MARK: - Set Top bar after selecting Option from Top Tabbar
    
    private func resetTabBarForTag(tag: Int) {
        
        var sender: UIButton!
        
        if(tag == 0) {
            sender = btnTab1
        }
        else if(tag == 1) {
            sender = btnTab2
        }
        else if(tag == 2) {
            sender = btnTab3
        }else if(tag == 3) {
            sender = btnTab4
        }
        
        currentPage = tag
        
        unSelectedButton(btn: btnTab1)
        unSelectedButton(btn: btnTab2)
        unSelectedButton(btn: btnTab3)
        unSelectedButton(btn: btnTab4)

        
        selectedButton(btn: sender)
        
    }
    
    //MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
   print("\(currentPage!)")
       
    }
    
    //MARK: - Custom Methods
    
    private func selectedButton(btn: UIButton) {
        
        btn.backgroundColor = UIColor.lightGray

        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func unSelectedButton(btn: UIButton) {
        btn.backgroundColor = UIColor.white
    }
    //MARK: - Navigation bar Right btn Action

    @IBAction func rightNavigationBarBtnAction(_ sender: UIBarButtonItem)
    {
        
    }
    
    //MARK: - user Profile Btn Action

    @IBAction func userProfileBtnAction(_ sender: UIButton) {
        
        guard URL(string: tempDict.value(forKey: "link") as! String) != nil else {
            return //be safe
        }
        let url = NSURL(string:tempDict.value(forKey: "link") as! String)!
        
        print("url:\(url)")

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    

    
}

