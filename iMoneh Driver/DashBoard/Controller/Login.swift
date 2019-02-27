//
//  Login.swift
//  iMonehMarket
//
//  Created by Rakhi on 07/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class Login: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txfdId: FloatingLabelTextField!
    @IBOutlet var txfdPass: FloatingLabelTextField!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    
    // MARK:- INIT METHOD
    func initMethod() {
    }
    
    
    
    // MARK:- SET UI METHOD
    func setUI() {
        setTxfd()
    }
    
    
    func setTxfd() {
        
        /*
         txfdId.text = "market@imoneh.com"
         txfdPass.text = "121212"
         */
        
        
        txfdId.text = "test1@gmail.com"
        txfdPass.text = "123456789"
        
        
        //id
        txfdId.font = AppFont.GilroyReg.fontReg15
        txfdId.titleActiveTextColour = appDarkYellow
        txfdId.titleFont = AppFont.GilroyBold.fontBold14!
        
        //pass
        txfdPass.font = AppFont.GilroyReg.fontReg15
        txfdPass.titleActiveTextColour = appDarkYellow
        txfdPass.titleFont = AppFont.GilroyBold.fontBold14!
    }
    
    
   
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    // MARK:- BUTTON ACTION
    @objc func btnFPassClicked() {
        print("Button Clicked")
    }
    
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

