//
//  HomeVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class HomeVC: UIViewController {
    @IBOutlet weak var stackViewTab: UIStackView!
    @IBOutlet weak var viewNew: UIView!
    @IBOutlet weak var viewAssigned: UIView!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var lblNewUndeline: UILabel!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var lblAssignUndeline: UILabel!
    @IBOutlet weak var btnAssign: UIButton!
    @IBOutlet weak var lblCompUndeline: UILabel!
    @IBOutlet weak var btnComp: UIButton!
    
    private var pageViewControl:UIPageViewController!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    deinit {
        print("HomeVC deinit")
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
        title = "Market Order List".localized
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        let index = Singleton.shared.isDeliveryCompany ? 1:0
        setNavTabUI(crtIndex: index)
        setPageViewController()
    }
    
    private func setNavTabUI(crtIndex:Int) {
        
        viewNew.isHidden = Singleton.shared.isDeliveryCompany ? true:false
        btnNew.setTitle("New".localized, for: .normal)
        btnAssign.setTitle("Assigned".localized, for: .normal)
        btnComp.setTitle("Completed".localized, for: .normal)
        
        switch crtIndex {
        case 0:
            btnNew.setTitleColor(UIColor.white, for: .normal)
            btnAssign.setTitleColor(UIColor.darkGray, for: .normal)
            btnComp.setTitleColor(UIColor.darkGray, for: .normal)
            
            lblNewUndeline.backgroundColor = UIColor.gray
            lblNewUndeline.isHidden = false
            lblAssignUndeline.isHidden = true
            lblCompUndeline.isHidden = true
        case 1:
            btnNew.setTitleColor(UIColor.darkGray, for: .normal)
            btnAssign.setTitleColor(UIColor.white, for: .normal)
            btnComp.setTitleColor(UIColor.darkGray, for: .normal)
            
            lblAssignUndeline.backgroundColor = UIColor.gray
            lblNewUndeline.isHidden = true
            lblAssignUndeline.isHidden = false
            lblCompUndeline.isHidden = true
        case 2:
            btnNew.setTitleColor(UIColor.darkGray, for: .normal)
            btnAssign.setTitleColor(UIColor.darkGray, for: .normal)
            btnComp.setTitleColor(UIColor.white, for: .normal)
            
            lblCompUndeline.backgroundColor = UIColor.gray
            lblNewUndeline.isHidden = true
            lblAssignUndeline.isHidden = true
            lblCompUndeline.isHidden = false
        default:
            break
        }
    }
    
    private func setPageViewController() {
        let Ypage = AppDevice.ScreenSize.SCREEN_HEIGHT*0.07
        pageViewControl = self.storyboard?.instantiateViewController(withIdentifier: "pagevieworder") as? UIPageViewController
        pageViewControl.view.frame = CGRect(x: 0, y: Ypage, width: AppDevice.ScreenSize.SCREEN_WIDTH, height: AppDevice.ScreenSize.SCREEN_HEIGHT - Ypage)
        pageViewControl.dataSource = self
        pageViewControl.delegate = self
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
        pageViewControl.didMove(toParent: self)
        self.view.bringSubviewToFront(stackViewTab)
        
        let pend = Singleton.shared.isDeliveryCompany ? storyboard?.instantiateViewController(withIdentifier:"AssignVC") as! AssignVC  : storyboard?.instantiateViewController(withIdentifier:"NewVC") as! NewVC
        pageViewControl.setViewControllers([pend],direction: .forward,animated: true,completion: nil)
    }
}

// MARK:- extension - button action
extension HomeVC {
    @IBAction func btnMenuButtonClicked(_ sender: UIBarButtonItem) {
        switch Language.language {
        case .english:
            self.sideMenuViewController?.presentLeftMenuViewController()
        case .arabic:
            self.sideMenuViewController?.presentRightMenuViewController()
        }
    }
    
    @IBAction func btnNewClicked(_ sender: UIButton) {
        setNavTabUI(crtIndex: 0)
        let newVC = storyboard?.instantiateViewController(withIdentifier:"NewVC") as! NewVC
        pageViewControl.setViewControllers([newVC],direction: .forward,animated: true,completion: nil)
    }
    @IBAction func btnAssignClicked(_ sender: UIButton) {
        setNavTabUI(crtIndex: 1)
        let assignVC = storyboard?.instantiateViewController(withIdentifier:"AssignVC") as! AssignVC
        pageViewControl.setViewControllers([assignVC],direction: .forward,animated: true,completion: nil)
    }
    @IBAction func btnHistoryClicked(_ sender: UIButton) {
        setNavTabUI(crtIndex: 2)
        let compVC = storyboard?.instantiateViewController(withIdentifier:"CompletedVC") as! CompletedVC
        pageViewControl.setViewControllers([compVC],direction: .forward,animated: true,completion: nil)
    }
}

// MARK:- Ex - UIPageViewControllerDelegate
extension HomeVC : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is AssignVC {
            let pendVC = Singleton.shared.isDeliveryCompany ? nil : storyboard?.instantiateViewController(withIdentifier:"NewVC") as! NewVC
            return pendVC
        }else if viewController is CompletedVC {
            let ongVC = storyboard?.instantiateViewController(withIdentifier:"AssignVC") as! AssignVC
            return ongVC
        }else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is NewVC {
            let ongVC = storyboard?.instantiateViewController(withIdentifier:"AssignVC") as! AssignVC
            return ongVC
        }else if viewController is AssignVC {
            let hisVC = storyboard?.instantiateViewController(withIdentifier:"CompletedVC") as! CompletedVC
            return hisVC
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard  let vc = pageViewControl.viewControllers?.first else{
                return
            }
            if vc is NewVC {
                setNavTabUI(crtIndex: 0)
            }else if vc is AssignVC {
                setNavTabUI(crtIndex: 1)
            }else if vc is CompletedVC {
                setNavTabUI(crtIndex: 2)
            }
        }
    }
}








