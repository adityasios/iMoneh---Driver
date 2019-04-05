//
//  AssignVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class AssignVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var viewNodata: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var arrOrder : [OrderMod] = []
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getOrderList()
    }
    
    deinit {
        Loader.hideLoadingView(view: self.view)
        print("AssignVC deinit")
    }
    
    // MARK: - INIT METHOD
    func initMethod(){
        tblv.estimatedRowHeight = 150
        tblv.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    private func registerCell() {
        let nibSt = UINib.init(nibName: "OrderCell", bundle: nil)
        self.tblv.register(nibSt, forCellReuseIdentifier: "OrderCell")
    }
    
    // MARK: - SET UI
    func setUI(){
        lblNoData.text = "No Assigned Order Found".localized
    }
}

// MARK:- EXT - UITableViewDataSource
extension AssignVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tcell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order_mod = arrOrder[indexPath.row]
        
        //orders
        let attbuteHead = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attbuteTitle = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.darkText]
        let order = NSMutableAttributedString(string:"Orders #: ", attributes:attbuteHead)
        let order_id = NSMutableAttributedString(string:String(order_mod.order_id!), attributes:attbuteTitle)
        order.append(order_id)
        tcell.lblOrder.attributedText = order
        
        //price
        tcell.lblPrice.font = AppFont.GilroySemiBold.fontSemiBold13!
        tcell.lblPrice.textColor = UIColor.darkText
        tcell.lblPrice.text = String(order_mod.currency!) + " " + String(order_mod.total_amount!)
        
        //from - to
        var vendor_add = (order_mod.vendor_address?.area_name ?? "")
        vendor_add.append("\u{00a0}")
        vendor_add.append((order_mod.vendor_address?.city_name ?? ""))
        vendor_add.append("\u{00a0}")
        vendor_add.append((order_mod.vendor_address?.country_name ?? ""))
        
        let from = NSMutableAttributedString(string:"From : ", attributes:attbuteHead)
        let from_add = NSMutableAttributedString(string:"\(vendor_add)\n", attributes:attbuteTitle)
        
        var cust_add = (order_mod.customer_address?.area_name ?? "")
        cust_add.append("\u{00a0}")
        cust_add.append((order_mod.customer_address?.city_name ?? ""))
        cust_add.append("\u{00a0}")
        cust_add.append((order_mod.customer_address?.country_name ?? ""))
        
        let to = NSMutableAttributedString(string:"To : ", attributes:attbuteHead)
        let to_add = NSMutableAttributedString(string:"\(cust_add)\n", attributes:attbuteTitle)
        
        from.append(from_add)
        from.append(to)
        from.append(to_add)
        
        tcell.lblAdd.attributedText = from
        
        
        //delivery date|time
        if let del_date = order_mod.delivery_date,let del_time = order_mod.delivery_time {
            let date_time = "\(DateHelper.getDeliveryDateInLocalFromUTC(crt: del_date)) | \(del_time)"
            let delivery = NSMutableAttributedString(string:"Delivery Date : \n", attributes:attbuteHead)
            let date = NSMutableAttributedString(string:date_time, attributes:attbuteTitle)
            delivery.append(date)
            tcell.lblDeliveryDate.attributedText = delivery
        }else{
            tcell.lblDeliveryDate.text = ""
        }
        
        //distance
        tcell.lblDistance.font = AppFont.GilroySemiBold.fontSemiBold13!
        tcell.lblDistance.textColor = UIColor.darkText
        tcell.lblDistance.isHidden = true
        return tcell
    }
}

// MARK:- Ex - API
extension AssignVC {
    private func getOrderList() {
        let strUrl = APIURLFactory.order_list
        let paraTemp : [String:String] = [Parameters.page:"1",Parameters.status:OrderStatus.assigned.rawValue]
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: paraTemp) else {
            return
        }
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOrderList(json: json)
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

// MARK:- Ex - API PARSING METHODS
extension AssignVC {
    private  func jsonParsingOrderList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            print("jsonTemp assign \(jsonTemp)")
            
            //data_order
            guard let data = jsonTemp["data"] as? [[String:Any]] else {
                return
            }
            
            //modelling
            do {
                let dataOrder = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                arrOrder = try decoder.decode([OrderMod].self, from: dataOrder)
                viewNodata.isHidden = arrOrder.isEmpty ? false : true
                self.tblv.reloadData()
            } catch let parsingError {
                print("parsingError assign order = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

//let nav = story.instantiateViewController(withIdentifier: "PickUpConformation") as! PickUpConformation
