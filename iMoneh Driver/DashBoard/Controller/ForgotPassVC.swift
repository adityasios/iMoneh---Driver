//
//  ForgotPassVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 11/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//
import UIKit

class ForgotPassVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var txfdEmail: UITextField!
    @IBOutlet weak var constraint_btm: NSLayoutConstraint!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txfdEmail.becomeFirstResponder()
    }
    
    // MARK:- INIT METHOD
    func initMethod() {
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardNotification(notification:)),name: UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    // MARK:- SET UI METHOD
    func setUI() {
        setNavigationBar()
        
        txfdEmail.layer.cornerRadius = 4
        txfdEmail.clipsToBounds = true
        txfdEmail.layer.borderColor = UIColor.gray.cgColor
        txfdEmail.layer.borderWidth = 1
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = appYellow
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnActivateClicked(_ sender: UIButton) {
        guard var email = txfdEmail.text,Validation.isValidEmail(strEmail: email) == true else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Email")
            return
        }
        email =  Validation.removeWhiteSpaceAndNewLine(strTemp: email)
        email =  Validation.removeDoubleSpace(email)
        let paraDict = [Parameters.email : email]
        postForgotPassword(para: paraDict)
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.constraint_btm?.constant = 0
            } else {
                Singleton.shared.keyboard_ht = endFrame?.size.height
                if let ht = endFrame?.size.height {
                    self.constraint_btm?.constant = -ht
                }else{
                    self.constraint_btm?.constant = 0
                }
            }
            
            UIView.animate(withDuration: duration,delay: TimeInterval(0),options: animationCurve,animations: { self.view.layoutIfNeeded() },completion: nil)
        }
    }
    
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- Ex - API CALL  METHODS
extension ForgotPassVC {
    func postForgotPassword(para:[String:String]) {
        
        //url
        let strUrl = APIURLFactory.fgt_pass
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
                    self.jsonParsingFogotPass(json: json)
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
extension ForgotPassVC {
    
    func jsonParsingFogotPass(json:Any) {
        print("json for Fgt  = \(json)")
        
        if let jsonTmp = json as? [String: Any]  {
            //msg
            guard let msg = jsonTmp["msg"] as? String else {
                return
            }
            //data
            guard let data = jsonTmp["data"] as? [String:Any] else {
                return
            }
            //id
            guard let id = data["id"] as? Int else {
                return
            }
            //navigate to verify
            let otp = storyboard?.instantiateViewController(withIdentifier: "VerfiyOTP") as! VerfiyOTP
            otp.id_driver = id
            navigationController?.pushViewController(otp, animated: true)
            
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}



/*
 Forgot Password
 driver/forgot/password
 POST
 No
 email: "mayank.sharma@webmazix.com"
 */
