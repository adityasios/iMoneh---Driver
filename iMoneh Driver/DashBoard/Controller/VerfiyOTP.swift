//
//  VerfiyOTP.swift
//  iMonehMarket
//
//  Created by Rakhi on 12/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class VerfiyOTP: UIViewController {
    @IBOutlet weak var txfdOTP: UITextField!
    @IBOutlet weak var constraint_btm: NSLayoutConstraint!
    var id_driver = 0
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txfdOTP.becomeFirstResponder()
    }
    
    // MARK:- INIT METHOD
    func initMethod() {
    }
    
    // MARK:- SET UI METHOD
    func setUI() {
        txfdOTP.layer.cornerRadius = 4
        txfdOTP.clipsToBounds = true
        txfdOTP.layer.borderColor = UIColor.gray.cgColor
        txfdOTP.layer.borderWidth = 1
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnSubmitOTP(_ sender: UIButton) {
        guard var otp = txfdOTP.text else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter 4 digit OTP")
            return
        }
        otp =  Validation.removeWhiteSpaceAndNewLine(strTemp: otp)
        otp =  Validation.removeDoubleSpace(otp)
        
        if otp.count != 4 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter 4 digit OTP")
            return
        }
        let paraDict = [Parameters.otp : otp,Parameters.driver_id:String(id_driver)]
        postVerifyOTP(para: paraDict)
    }
}

// MARK:- Ex - API PARSING
extension VerfiyOTP: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let ht =  Singleton.shared.keyboard_ht{
            self.constraint_btm?.constant = -ht
        }
        return true
    }
}

// MARK:- Ex - API CALL  METHODS
extension VerfiyOTP {
    func postVerifyOTP(para:[String:String]) {
        
        //url
        let strUrl = APIURLFactory.verify_otp
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: false, para: para) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingForVerifyOTP(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
}


// MARK:- Ex - API PARSING
extension VerfiyOTP {
    func jsonParsingForVerifyOTP(json:Any) {
        if let jsonTmp = json as? [String: Any]  {
            
            //msg
            guard let msg = jsonTmp["msg"] as? String else {
                return
            }
            
            //navigate to reset password
            let reset_pass = storyboard?.instantiateViewController(withIdentifier: "ResetPassVC") as! ResetPassVC
            reset_pass.id_driver = String(id_driver)
            reset_pass.otp_vendor = txfdOTP.text!
            navigationController?.pushViewController(reset_pass, animated: true)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}




/*
driver/verify/otp
POST
No
otp:3559,
driver_id:282
*/
