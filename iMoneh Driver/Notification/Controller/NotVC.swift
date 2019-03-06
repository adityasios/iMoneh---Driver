//
//  NotVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 12/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class NotVC: UIViewController {
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tblv: UITableView!
    var arrNot:[NotMod] = []
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getNotificationList()
    }
    
    deinit {
        print("RootViewController deinit")
    }
    
    // MARK:- INIT METHOD
    private  func initMethod() {
        self.title = "Notification List"
        tblv.estimatedRowHeight = 80
        tblv.rowHeight = UITableView.automaticDimension
    }
    
    // MARK:- SET UI METHOD
    private func setUI() {
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = appYellow
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // MARK:- BUTTON ACTION
    @objc func btnDeleteClicked(_ sender: UIButton) {
        let btnPost = sender.convert(CGPoint.zero, to: self.tblv)
        if let indexPath = self.tblv.indexPathForRow(at: btnPost) {
            deleteNotification(notIndex: indexPath.row)
        }
    }
}

// MARK:- Ex - API
extension NotVC {
  
    private func getNotificationList() {
        let strUrl = APIURLFactory.not_list
        let paraTemp : [String:String] = [Parameters.page:"1"]
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: paraTemp) else {
            return
        }
        
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingNotList(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    private func deleteNotification(notIndex:Int) {
        let mod = arrNot[notIndex]
        let strUrl = APIURLFactory.not_delete + String(mod.id!)
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: [:]) else {
            return
        }
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingDeleteNot(json: json, notIndex: notIndex)
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
extension NotVC {
    private  func jsonParsingNotList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["data"] as? [[String:Any]] else {
                return
            }
            print("data \(data)")
            //modelling
            do {
                let dataNot = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                arrNot = try decoder.decode([NotMod].self, from: dataNot)
                if arrNot.isEmpty {
                    viewNoData.isHidden = false
                }else{
                    viewNoData.isHidden = true
                    self.tblv.reloadData()
                }
            } catch let parsingError {
                print("parsingError not = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
    
    private  func jsonParsingDeleteNot(json:Any,notIndex:Int) {
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["msg"] as? [String:Any] else {
                return
            }
            arrNot.remove(at: notIndex)
            self.tblv.reloadData()
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- TABLEVIEW DATASOURCE
extension NotVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mod = arrNot[indexPath.row]
        let tcell = tableView.dequeueReusableCell(withIdentifier: "NotCell", for: indexPath) as! NotCell
        tcell.lblTitle.text = mod.title
        tcell.lblDesc.text = mod.content
        tcell.lblDate.text = DateHelper.getNotDateInLocalFromUTC(crt: mod.created_at!)
        tcell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(_:)), for: .touchUpInside)
        return tcell
    }
}

/*
Notifications List
driver/notifications/list
GET
Yes
page: 1
*/
