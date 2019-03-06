//
//  ResetPassVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 12/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class ResetPassVC: UIViewController {
    
    @IBOutlet weak var txfdPassword: UITextField!
    @IBOutlet weak var constraint_btm: NSLayoutConstraint!
    
    var id_driver : String?
    var otp_vendor : String?
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txfdPassword.becomeFirstResponder()
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        txfdPassword.layer.cornerRadius = 4
        txfdPassword.clipsToBounds = true
        txfdPassword.layer.borderColor = UIColor.gray.cgColor
        txfdPassword.layer.borderWidth = 1
    }

    // MARK:- BUTTON ACTION
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        guard var pass = txfdPassword.text  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Password")
            return
        }
        pass =  Validation.removeWhiteSpaceAndNewLine(strTemp: pass)
        pass =  Validation.removeDoubleSpace(pass)
        if pass.count < 5 || pass.count > 15 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Password should be greater than 5 characters")
            return
        }
        
        //device_id
        guard let device_Id = Singleton.shared.device_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not able to get Device Id")
            return
        }
        
        //fcm
        guard let fcm = Singleton.shared.fcm_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please register for Push Notification")
            return
        }
        
        let paraDict = [Parameters.otp : otp_vendor!,Parameters.driver_id:id_driver!,Parameters.new_password:pass,Parameters.deviceId:device_Id,Parameters.fcmId:fcm,Parameters.deviceType:Parameters.deviceTypeiOS]
        postResetPassword(para: paraDict)
    }
}

// MARK:- Ex - TEXTFIELD
extension ResetPassVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let ht =  Singleton.shared.keyboard_ht{
            self.constraint_btm?.constant = -ht
        }
        return true
    }
}

// MARK:- Ex - API CALL  METHODS
extension ResetPassVC {
    private func postResetPassword(para:[String:String]) {
        //url
        let strUrl = APIURLFactory.reset_pass
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
                    self.jsonParsingResetPass(json: json)
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

// MARK:- API PARSING
extension ResetPassVC {
    func jsonParsingResetPass(json:Any) {
        print("json for reset  = \(json)")
        if let jsonTmp = json as? [String: Any]  {
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}






/*
 driver/reset/password
 POST
 No
 """otp"": ""3559"",
 ""driver_id"": ""282"",
 ""new_password"": ""111111"",
 ""device_id"": ""715127048340b893"",
 ""device_type"": ""1"",
 ""fcm_id"": ""fts1phfklxE:APA91bHPTNTOv27YIGaCP-RjNsT0a_SOQG-zLvDpuEO-Oqhi_rleps9sr2FML_qnk7UqDO9WtpIzfyahqaQmXvB6TMTqBgr0LI8azjz4_10WrkV6cRtRgdIxOYvsh27FmXFAi1898TtC"""
 */
