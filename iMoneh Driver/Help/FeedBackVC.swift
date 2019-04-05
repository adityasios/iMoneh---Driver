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
    @IBOutlet weak var lblSuggest: UILabel!
    @IBOutlet weak var lblMightAdd: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
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
        lblSuggest.text = "Suggest an Item for iMoneh".localized
        lblMightAdd.text = "We might add it for you".localized
        btnSend.setTitle("Send".localized, for: .normal)
    }
    
    func setTxfd() {
        //title
        txfdTitle.font = AppFont.GilroyReg.fontReg15
        txfdTitle.titleActiveTextColour = appDarkYellow
        txfdTitle.titleFont = AppFont.GilroyBold.fontBold14!
        txfdTitle.placeholder = "Title".localized
        txfdTitle.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        
        //desc
        txfddesc.font = AppFont.GilroyReg.fontReg15
        txfddesc.titleActiveTextColour = appDarkYellow
        txfddesc.titleFont = AppFont.GilroyBold.fontBold14!
        txfddesc.placeholder = "Write Your Feedback Here".localized
        txfddesc.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
    }
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnBtmSendClicked(_ sender: UIButton) {
        
        //title
        guard var title = txfdTitle.text else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Title")
            return
        }
        title =  Validation.removeWhiteSpaceAndNewLine(strTemp: title)
        title =  Validation.removeDoubleSpace(title)
        if title.count < 2 || title.count > 150 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Title")
            return
        }
        
        //desc
        guard var desc = txfddesc.text  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Feedback")
            return
        }
        desc =  Validation.removeWhiteSpaceAndNewLine(strTemp: desc)
        desc =  Validation.removeDoubleSpace(desc)
        if desc.count < 2 || desc.count > 300 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Feedback")
            return
        }
        
        let paraDict = [Parameters.title : title, Parameters.feedback : desc]
        postFeedBackAPICall(para: paraDict)
    }
}

// MARK:- API CALL  METHODS
extension FeedBackVC {
    func postFeedBackAPICall(para:[String:String]) {
        
        //url
        let strUrl = APIURLFactory.cms_feedback
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: true, para: para) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingFeedbackApi(json: json)
                    print("json = \(json)")
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    func jsonParsingFeedbackApi(json:Any) {
        if let jsonTmp = json as? [String: Any]  {
            guard let msg = jsonTmp["msg"] as? String else {
                return
            }
            txfdTitle.text = nil
            txfddesc.text = nil
            BasicUtility.getAlert(view: self, titletop: "FeedBack", subtitle:msg)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

/*
 cms/customer/feedback
 POST
 Yes
 title:Testing
 feedback:Just for testing
 */


