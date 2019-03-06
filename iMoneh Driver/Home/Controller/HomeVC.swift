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
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblAssignUndeline: UILabel!
    @IBOutlet weak var lblAssign: UILabel!
    @IBOutlet weak var lblCompUndeline: UILabel!
    @IBOutlet weak var lblComp: UILabel!
    
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
        title = "Market Order List"
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        setNavTabUI(crtIndex: 0)
        setPageViewController()
    }
    
    private func setNavTabUI(crtIndex:Int) {
        switch crtIndex {
        case 0:
            lblNew.textColor = UIColor.white
            lblAssign.textColor = UIColor.darkGray
            lblComp.textColor = UIColor.darkGray
            
            lblNewUndeline.backgroundColor = UIColor.gray
            lblNewUndeline.isHidden = false
            lblAssignUndeline.isHidden = true
            lblCompUndeline.isHidden = true
        case 1:
            lblNew.textColor = UIColor.darkGray
            lblAssign.textColor = UIColor.white
            lblComp.textColor = UIColor.darkGray
            
            lblAssignUndeline.backgroundColor = UIColor.gray
            lblNewUndeline.isHidden = true
            lblAssignUndeline.isHidden = false
            lblCompUndeline.isHidden = true
        case 2:
            lblNew.textColor = UIColor.darkGray
            lblAssign.textColor = UIColor.darkGray
            lblComp.textColor = UIColor.white
            
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
        
        let pend = storyboard?.instantiateViewController(withIdentifier:"NewVC") as! NewVC
        pageViewControl.setViewControllers([pend],direction: .forward,animated: true,completion: nil)
    }
}

// MARK:- Ex - UIPageViewControllerDelegate
extension HomeVC : UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is AssignVC {
            let pendVC = storyboard?.instantiateViewController(withIdentifier:"NewVC") as! NewVC
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







