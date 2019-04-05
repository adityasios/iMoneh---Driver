//
//  ShareVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 15/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class ShareVC: UIViewController {
    
    @IBOutlet var lblShareOnSocial: UILabel!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Share".localized
        lblShareOnSocial.text = "Share on Social Media".localized
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnShareClicked(_ sender: UIButton) {
        let textToShare = "iMoneh is awesome!  Check out this website about it!"
        if let myWebsite = URL(string: "http://imoneh.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
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
