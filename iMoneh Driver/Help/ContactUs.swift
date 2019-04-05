//
//  ContactUs.swift
//  iMoneh Driver
//
//  Created by Rakhi on 06/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import MessageUI

class ContactUs: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblFaceBook: UILabel!
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var lblInsta: UILabel!
    let composeVC = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact".localized
        lblTitle.text = "contact_title".localized
        lblEmail.text = "Email".localized
        lblWebsite.text = "Website".localized
        lblFaceBook.text = "Facebook".localized
        lblTwitter.text = "Twitter".localized
        lblInsta.text = "Instgram".localized
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnContactUsClicked(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            self.createMessageFromEmail()
        case 20:
            guard let url = URL(string: "http://www.imoneh.com") else { return }
            UIApplication.shared.open(url)
        default:
            break
        }
    }
}

// MARK:- Ex - BUTTON ACTION
extension ContactUs:MFMailComposeViewControllerDelegate {
    private func createMessageFromEmail(){
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["info@imoneh.com"])
        composeVC.setSubject("iMonehGo")
        composeVC.setMessageBody("www.imoneh.com", isHTML: false)
        UINavigationBar.appearance().tintColor = UIColor.white
        present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,didFinishWith result: MFMailComposeResult,error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


