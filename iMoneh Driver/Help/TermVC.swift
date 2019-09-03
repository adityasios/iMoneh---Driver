//
//  TermVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 06/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class TermVC: UIViewController {
    @IBOutlet weak var tblv: UITableView!
    var str_title : String?
    var str_desc : String?
    
    //MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Terms"
        tblv.estimatedRowHeight = 50
        tblv.rowHeight = UITableView.automaticDimension
        getTermAPI()
    }
}

// MARK:- Ext - API CALL  METHODS
extension TermVC {
    func getTermAPI() {
        //url
        let strUrl = APIURLFactory.cms_terms
        guard let request = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: false, para: [:]) else {
            return
        }
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingTermAPI(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    func jsonParsingTermAPI(json:Any) {
        if let json_res = json as? [String: Any]  {
            guard let arr_data = json_res["data"] as? [[String:Any]],let dict_data = arr_data.first else {
                return
            }
            if let title = dict_data["title"] {
                str_title = title as? String
            }
            
            if let desc = dict_data["content"] {
                str_desc = desc as? String
            }
            self.tblv.reloadData()
        }
    }
}

// MARK:- Ext - API CALL  METHODS
extension TermVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tcell = tableView.dequeueReusableCell(withIdentifier: "cellpay", for: indexPath)
        let lblTitle = tcell.viewWithTag(10) as! UILabel
        lblTitle.textColor = (indexPath.row == 0) ? UIColor.gray : UIColor.darkGray
        lblTitle.text = (indexPath.row == 0) ? str_title : str_desc
        return tcell;
    }
}

// MARK:- BUTTON ACTION
extension TermVC {
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

/*
 cms/terms_conditions
 GET
 No
 */


