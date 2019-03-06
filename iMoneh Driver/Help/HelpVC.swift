//
//  HelpViewController.swift
//  iMohenMarket
//
//  Created by Arjun Singh on 24/12/18.
//  Copyright © 2018 Webmazix. All rights reserved.
//

import UIKit
class HelpVC: UIViewController {
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
        title = "Help"
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = appYellow
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnAboutUsClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackVC") as! FeedBackVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermVC") as! TermVC
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}







