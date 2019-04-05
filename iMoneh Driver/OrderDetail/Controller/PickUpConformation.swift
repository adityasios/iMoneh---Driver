//
//  PickUpConformation.swift
//  iMoneh Driver
//
//  Created by Rakhi on 07/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class PickUpConformation: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewSign: YPDrawSignatureView!
    @IBOutlet weak var txfdSender: UITextField!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Profile"
    }
    
    // MARK: - SET UI
    private func setUI(){
        viewBg.layer.cornerRadius = 4
        viewBg.clipsToBounds = true
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
        viewBg.layer.borderWidth = 0.4
        
        viewSign.layer.cornerRadius = 4
        viewSign.clipsToBounds = true
        viewSign.layer.borderColor = UIColor.lightGray.cgColor
        viewSign.layer.borderWidth = 0.4
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnClearClicked(_ sender: UIButton) {
        viewSign.clear()
    }
    @IBAction func btnSendClicked(_ sender: UIButton) {
        if let signatureImage = viewSign.getSignature(scale: 20) {
            viewSign.clear()
        }
    }
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



