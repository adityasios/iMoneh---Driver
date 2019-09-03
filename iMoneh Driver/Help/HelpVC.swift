//
//  HelpViewController.swift
//  iMohenMarket
//
//  Created by Arjun Singh on 24/12/18.
//  Copyright © 2018 Webmazix. All rights reserved.
//

import UIKit
class HelpVC: UIViewController {
    
    @IBOutlet weak var lblHelpTitle: UILabel!
    @IBOutlet weak var lblGetLost: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblFAQ: UILabel!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
        title = "Help".localized
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        setNavigationBar()
        lblHelpTitle.text = "Need Some helps".localized
        lblGetLost.text = "help_desc".localized
        lblAbout.text = "About".localized
        lblContact.text = "Contact".localized
        lblPayment.text = "Payments".localized
        lblFAQ.text = "FAQ".localized
        lblFeedback.text = "Feedback".localized
        lblTerms.text = "Terms".localized
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
            let story = UIStoryboard.init(name: "Help", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "TermVC") as! TermVC
            let nav = UINavigationController.init(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func btnMenuButtonClicked(_ sender: UIBarButtonItem) {
        switch Language.language {
        case .english:
            self.sideMenuViewController?.presentLeftMenuViewController()
        case .arabic:
            self.sideMenuViewController?.presentRightMenuViewController()
        }
    }
}







