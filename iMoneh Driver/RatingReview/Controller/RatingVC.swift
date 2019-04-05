//
//  RatingVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 01/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class RatingVC: UIViewController {
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var lblNodata: UILabel!
    var arrRating :[RatingMod] = []
    
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getRatingList()
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Rating & Review".localized
    }
    
    // MARK: - SET UI
    private func setUI(){
        tblv.rowHeight = UITableView.automaticDimension
        tblv.estimatedRowHeight = 170
        lblNodata.text = "No Review Found".localized
    }
    
    // MARK: - BUTTON ACTION
    @IBAction func btnMenuButtonClicked(_ sender: UIBarButtonItem) {
        switch Language.language {
        case .english:
            self.sideMenuViewController?.presentLeftMenuViewController()
        case .arabic:
            self.sideMenuViewController?.presentRightMenuViewController()
        }
    }
}

// MARK:- Ext - API CALL  METHODS
extension RatingVC {
    func getRatingList() {
        //url
        let paraTemp : [String:String] = [Parameters.page:"1"]
        let strUrl = APIURLFactory.driver_review
        guard let request = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para:paraTemp) else {
            return
        }
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("json rating = \(json)")
                    self.jsonParsingReviewList(json: json)
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

// MARK:- API PARSING METHODS
extension RatingVC {
    private  func jsonParsingReviewList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["data"] as? [[String:Any]] else {
                return
            }
            //modelling
            do {
                let dataRate = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                arrRating = try decoder.decode([RatingMod].self, from: dataRate)
                viewNodata.isHidden = arrRating.isEmpty ? false : true
                self.tblv.reloadData()
            } catch let parsingError {
                print("parsingError rate = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- TABLEVIEW DATASOURCE
extension RatingVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rate_mod = arrRating[indexPath.row]
        let tcell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        tcell.lblOrder.text = "#" + rate_mod.order_code!
        tcell.lblName.text = rate_mod.customer_name
        if let star =  rate_mod.rating{
            tcell.lblRating.text = String(star)
        }else{
            tcell.lblRating.text = "0"
        }
        tcell.lblDate.text = DateHelper.getReviewDateInLocalFromUTC(crt: rate_mod.created_at!)
        tcell.lblTitle.text = rate_mod.title
        tcell.lblDesc.text = rate_mod.comments
        if let user_pro = rate_mod.profile_image,let urlimg = URL.init(string: APIURLFactory.cust_proimg + user_pro) {
            tcell.imgVPro.sd_setImage(with: urlimg) { (img, err, type, url) in
            }
        }
        return tcell
    }
}

/*
 Reviews List
 driver/reviews/list
 GET
 Yes
 page: 1
 */
