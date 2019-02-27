//
//  ViewController.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var pageViewControl:UIPageViewController!
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var btnFgotPass: UIButton!
    @IBOutlet var btnBtmLogin: UIButton!
    
    @IBOutlet var lblJoin: UILabel!
    @IBOutlet var lblLogin: UILabel!
    @IBOutlet var viewBtn: UIView!
    
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewJoin: UIView!
    
    /**
     true - Login
     false - reg
     */
    var isSelLogin = true
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        print("ViewController deinit")
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
        setPageViewController()
    }
    
    
    private func setPageViewController() {
        
        
        
        pageViewControl = self.storyboard?.instantiateViewController(withIdentifier: "pageviewcontroller") as? UIPageViewController
        pageViewControl.view.frame = CGRect(x: 0, y: 200, width: AppDevice.ScreenSize.SCREEN_WIDTH, height: AppDevice.ScreenSize.SCREEN_HEIGHT - 200)
        pageViewControl.dataSource = self
        pageViewControl.delegate = self
        
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
        pageViewControl.didMove(toParent: self)
        self.view.bringSubviewToFront(viewBtn)
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
        pageViewControl.setViewControllers([loginVC],direction: .forward,animated: true,completion: nil)
    }
    
    
    // MARK:- SET UI METHOD
    private func setUI() {
        
        
        //login
        btnLogin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnLogin.setTitleColor(UIColor.darkText, for: .normal)
        btnLogin.setTitleColor(appDarkYellow, for: .highlighted)
        lblLogin.backgroundColor = appDarkYellow
        
        //reg
        btnJoin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnJoin.setTitleColor(UIColor.lightGray, for: .normal)
        btnLogin.setTitleColor(UIColor.black, for: .highlighted)
        lblJoin.backgroundColor = UIColor.clear
        
        
        
        if !isSelLogin {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnLogin.setTitleColor(UIColor.lightGray, for: .normal)
                self.lblLogin.backgroundColor = UIColor.clear
                
                self.btnJoin.setTitleColor(UIColor.darkText, for: .normal)
                self.lblJoin.backgroundColor = appDarkYellow
            })
        }
        
        
        setBtns()
    }
    
    private func setBtns() {
        
        //btnFpass
        btnFgotPass.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnFgotPass.setTitleColor(UIColor.white, for: .normal)
        btnFgotPass.setTitleColor(UIColor.black, for: .highlighted)
        btnFgotPass.backgroundColor = UIColor.black
        
        
        //btmLogin
        btnBtmLogin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnBtmLogin.setTitleColor(UIColor.darkText, for: .normal)
        btnBtmLogin.setTitleColor(appYellow, for: .highlighted)
        btnBtmLogin.backgroundColor = appYellow
        
        if isSelLogin {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnFgotPass.isHidden = false
                self.btnBtmLogin.setTitle("Login", for: .normal)
            })
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.btnFgotPass.isHidden = true
                self.btnBtmLogin.setTitle("Create Account", for: .normal)
            })
        }
    }
    
}


extension ViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    
    // MARK:- PAGE VIEW CONTROLLER DELEGATE
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is Reg {
            let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
            return loginVC
        }else{
            return nil
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is Login {
            let regVC = storyboard?.instantiateViewController(withIdentifier:"join") as! Reg
            return regVC
        }else{
            return nil
        }
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers[0] is Login {
                isSelLogin = false
            }
            
            if previousViewControllers[0] is Reg {
                isSelLogin = true
            }
            
            setUI()
        }
    }
    
}


extension ViewController {
    
    // MARK:- ACTION METHOD
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        
        if isSelLogin {
            return
        }
        
        
        isSelLogin = true
        setUI()
        let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
        pageViewControl.setViewControllers([loginVC],direction:.reverse,animated: true,completion: nil)
        
    }
    
    
    @IBAction func btnJoinClicked(_ sender: UIButton) {
        if !isSelLogin {
            return
        }
        
        let regVC = storyboard?.instantiateViewController(withIdentifier:"join") as! Reg
        pageViewControl.setViewControllers([regVC],direction: .forward,animated: true,completion: nil)
        isSelLogin = false
        setUI()
    }
    
    
    @IBAction func btnFgotPassClicked(_ sender: UIButton) {
    }
    
    
    
    @IBAction func btnBtmLoginClicked(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Menu", bundle: nil)
        let rootVC = story.instantiateViewController(withIdentifier:"rootController") as! RootViewController
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window!.rootViewController = rootVC
    }
    
    
    func btnDialCodeClicked(_ sender: UIButton) {
    }
}

