//
//  CompDetailVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 05/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class CompDetailVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgVSign: UIImageView!
    
    var order_pass : OrderMod! = nil
    var arr_temp1 : [OrderTemoMod] = []
    var arr_temp2 : [OrderTemoMod] = []
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getOrderDetail()
    }
    
    deinit {
        print("CompDetailVC deinit")
    }
    
    // MARK: - INIT METHOD
    func initMethod(){
        tblv.estimatedRowHeight = 150
        tblv.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    private func registerCell() {
        let nibSt = UINib.init(nibName: "OrderDetailCell", bundle: nil)
        self.tblv.register(nibSt, forCellReuseIdentifier: "OrderDetailCell")
    }
    
    // MARK: - SET UI
    func setUI(){
        viewBg.layer.cornerRadius = 8
        viewBg.clipsToBounds = true
    }
}

// MARK:- Ex - API
extension CompDetailVC {
    private func getOrderDetail() {
        let strUrl = APIURLFactory.order_detail + String(order_pass.id!)
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para:[:]) else {
            return
        }
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json_det = try JSONSerialization.jsonObject(with: data, options: [])
                    print("json_det = \(json_det)")
                    self.jsonParsingOrderDetail(json: json_det)
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
extension CompDetailVC {
    private  func jsonParsingOrderDetail(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["data"] as? [String:Any] else {
                return
            }
            print("data \(data)")
            //modelling
            do {
                let dataOrder = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                order_pass = try decoder.decode(OrderMod.self, from: dataOrder)
                self.helperCreateDetailModel()
                self.tblv.reloadData()
            } catch let parsingError {
                print("parsingError order detail comp = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- EXT - UITableViewDataSource
extension CompDetailVC : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? (arr_temp1.count + 1) : arr_temp2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let tcell = tableView.dequeueReusableCell(withIdentifier: "celladd", for: indexPath)
                let lblComp = tcell.viewWithTag(10) as! UILabel
                
                let attbuteHead = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.gray]
                let attbuteTitle = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.darkText]
                //from - to
                var vendor_add = (order_pass.vendor_address?.area_name ?? "")
                vendor_add.append("\u{00a0}")
                vendor_add.append((order_pass.vendor_address?.city_name ?? ""))
                vendor_add.append("\u{00a0}")
                vendor_add.append((order_pass.vendor_address?.country_name ?? ""))
                
                let from = NSMutableAttributedString(string:"From : ", attributes:attbuteHead)
                let from_add = NSMutableAttributedString(string:"\(vendor_add)\n", attributes:attbuteTitle)
                
                var cust_add = (order_pass.customer_address?.area_name ?? "")
                cust_add.append("\u{00a0}")
                cust_add.append((order_pass.customer_address?.city_name ?? ""))
                cust_add.append("\u{00a0}")
                cust_add.append((order_pass.customer_address?.country_name ?? ""))
                
                let to = NSMutableAttributedString(string:"To : ", attributes:attbuteHead)
                let to_add = NSMutableAttributedString(string:"\(cust_add)", attributes:attbuteTitle)
                
                from.append(from_add)
                from.append(to)
                from.append(to_add)
                
                lblComp.attributedText = from
                return tcell
            }else{
                let tcell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
                let mod = arr_temp1[indexPath.row - 1]
                tcell.lblTitleOne.text = mod.title_one
                tcell.lblTitleTwo.text = mod.title_two
                tcell.lblDecOne.text = mod.desc_one
                tcell.lblDecTwo.text = mod.desc_two
                tcell.imgVOne.image = UIImage.init(named: mod.img_one!)
                tcell.imgVTwo.image = UIImage.init(named: mod.img_two!)
                return tcell
            }
        }else{
            let tcell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            let mod = arr_temp2[indexPath.row]
            tcell.lblTitleOne.text = mod.title_one
            tcell.lblTitleTwo.text = mod.title_two
            tcell.lblDecOne.text = mod.desc_one
            tcell.lblDecTwo.text = mod.desc_two
            tcell.imgVOne.image = UIImage.init(named: mod.img_one!)
            tcell.imgVTwo.image = UIImage.init(named: mod.img_two!)
            return tcell
        }
    }
}

// MARK:- EXT - UITableViewDelegate
extension CompDetailVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return UITableView.automaticDimension
        }else{
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Order Info".localized : "Payment Info".localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = AppFont.GilroySemiBold.fontSemiBold15
        header.textLabel?.textAlignment = .center
        header.textLabel?.frame = header.frame
    }
}

// MARK:- EXT - Helper Method
extension CompDetailVC {
    func helperCreateDetailModel(){
        
        //cust name & mobile
        let phone = (order_pass.customer?.dial_code)! + " " +  (order_pass.customer?.mobile)!
        let mod1 = OrderTemoMod.init(title_one: "Customer Name".localized, desc_one:order_pass.customer?.name, img_one:"cust_name", title_two: "Contact Details".localized, desc_two:phone, img_two:"cust_mob")
        arr_temp1.append(mod1)
        
        //delivery date  & time
        let del_date = DateHelper.getDeliveryDateInLocalFromUTC(crt: order_pass.deliver_datetime!)
        let del_time = DateHelper.getDeliveryTimeInLocalFromUTC(crt: order_pass.deliver_datetime!)
        let mod2 = OrderTemoMod.init(title_one: "Delivery Date".localized, desc_one:del_date, img_one:"et", title_two: "Delivery Time".localized, desc_two:del_time, img_two:"et")
        arr_temp1.append(mod2)
        
        //pick up date  & time
        let pick_date = DateHelper.getDeliveryDateInLocalFromUTC(crt: order_pass.pickup_datetime!)
        let pick_time = DateHelper.getDeliveryDateInLocalFromUTC(crt: order_pass.pickup_datetime!)
        let mod3 = OrderTemoMod.init(title_one: "PickUp Date".localized, desc_one:pick_date, img_one:"et", title_two: "PickUp Time".localized, desc_two:pick_time, img_two:"et")
        arr_temp1.append(mod3)
        
        //receiver name  & sender
        let mod4 = OrderTemoMod.init(title_one: "Receiver Name".localized, desc_one:order_pass.receiver_name, img_one:"cust_name", title_two: "Sender Name".localized, desc_two:order_pass.sender_name, img_two:"cust_name")
        arr_temp1.append(mod4)
        
        //total amt & delivery cost
        let mod5 = OrderTemoMod.init(title_one: "Total Amount".localized, desc_one:(String(order_pass.currency!) + " " + String(order_pass.total_amount!)), img_one: "total_amt", title_two: "Delivery Cost".localized, desc_two:(String(order_pass.currency!) + String(order_pass.delivery_cost!)), img_two: "del_cost")
        arr_temp2.append(mod5)
        
        //payment_staus & payment_method
        let pay_method =  ProjectHelper.getPaymentMethod(st: order_pass.payment_method!)
        let pay_status =  ProjectHelper.getPaymentStatus(st: order_pass.payment_status!)
        let mod6 = OrderTemoMod.init(title_one: "Payment Method".localized, desc_one:pay_method, img_one:"pay_method", title_two: "Payment Status".localized, desc_two:pay_status, img_two:"et")
        arr_temp2.append(mod6)
        
        //sign image
        imgVSign.layer.cornerRadius = 2
        imgVSign.clipsToBounds = true
        imgVSign.contentMode = .scaleAspectFill
        imgVSign.layer.borderColor = UIColor.lightGray.cgColor
        imgVSign.layer.borderWidth = 1
        if let str_pro = order_pass.pickup_signature_image,let urlimg = URL.init(string: APIURLFactory.cust_proimg + str_pro) {
            imgVSign.sd_setImage(with: urlimg) { (img, err, type, url) in
            }
        }
    }
}


//cellgen
/*
 Order Details
 driver/orders/details{id}
 GET
 Yes
 
 "receiver_name" = Arun;
 "sender_name" = Pavan;
 
 "payment_method" = 1;
 "payment_status" = 2;
 
 
 "deliver_datetime" = "2019-03-01T18:08:44.000Z";
 */
