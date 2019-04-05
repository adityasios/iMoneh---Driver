//
//  AboutUsVC.swift
//  iMonehNew
//
//  Created by Webmaazix on 12/11/18.
//  Copyright © 2018 Webmaazix. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var txtViewAbout: UITextView!
    
    //MARK: - init Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getAboutUsAPI()
    }
    
    //MARK: - SET UI
    private func setUI () {
        self.title = "About".localized
        txtViewAbout.text = nil
    }
}

// MARK:- Ext - API CALL  METHODS
extension AboutUsVC {
    func getAboutUsAPI() {
        //url
        let strUrl = APIURLFactory.about_us
        guard let request = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: false, para: [:]) else {
            return
        }
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingAboutUs(json: json)
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
    
    func jsonParsingAboutUs(json:Any) {
        if let json_res = json as? [String: Any]  {
            guard let dic_data = json_res["data"] as? [String:Any] else {
                return
            }
            
            guard let content = dic_data["content"] as? String else {
                return
            }
            self.txtViewAbout.text = content
        }
    }
}
