//
//  FeedBackVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 06/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class FeedBackVC: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var txfdTitle: FloatingLabelTextField!
    @IBOutlet weak var txfddesc: FloatingLabelTextField!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- INIT METHOD
    func initMethod() {
    }
    
    // MARK:- SET UI METHOD
    func setUI() {
        setTxfd()
    }
    
    func setTxfd() {
        //title
        txfdTitle.font = AppFont.GilroyReg.fontReg15
        txfdTitle.titleActiveTextColour = appDarkYellow
        txfdTitle.titleFont = AppFont.GilroyBold.fontBold14!
        
        //desc
        txfddesc.font = AppFont.GilroyReg.fontReg15
        txfddesc.titleActiveTextColour = appDarkYellow
        txfddesc.titleFont = AppFont.GilroyBold.fontBold14!
    }
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
