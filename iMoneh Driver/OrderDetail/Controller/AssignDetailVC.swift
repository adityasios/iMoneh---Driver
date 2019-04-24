//
//  AssignDetailVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 19/04/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class AssignDetailVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var btnViewItems: UIButton!
    
    var order_status: Int!
    var order_pass: OrderMod!
    var arr_temp1: [OrderTemoMod] = []
    var arr_temp2 : [SinglePayment] = []
    var onBookingAccept: ((_ accept: Bool) -> ())?
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getOrderDetail()
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Order Detail".localized
        registerCell()
    }
    
    private func registerCell() {
        let nibSt = UINib.init(nibName: "OrderDetailCell", bundle: nil)
        self.tblv.register(nibSt, forCellReuseIdentifier: "OrderDetailCell")
    }
    
    // MARK: - SET UI
    private func setUI(){
        btnViewItems.layer.cornerRadius = 2
        btnViewItems.layer.borderColor = UIColor.white.cgColor
        btnViewItems.layer.borderWidth = 1.0
        
        lblStatus.text = ProjectHelper.getOrderStatus(st: (order_pass.order_status!))
        lblStatus.text = lblStatus.text?.uppercased()
        switch order_status {
        case 2:
            btnChangeStatus.setTitle( "Pick Up".localized, for: .normal)
        case 3:
            btnChangeStatus.setTitle( "On the way".localized, for: .normal)
        case 4:
            btnChangeStatus.setTitle( "Delivered".localized, for: .normal)
        default:
            break
        }
    }
}

// MARK:- Ex - API
extension AssignDetailVC {
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
    
    private func postUpdateOrderStatus() {
        let orderID  = (order_pass.order_id)!
        let vendorID = (order_pass.vendor_id)!
        let strUrl = APIURLFactory.update_status + "/" + String(orderID) + "/"
            + String(vendorID)
        
        let orderTemp = order_status + 1
        let paraTemp : [String:String] = [Parameters.status:String(orderTemp)]
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: true, para: paraTemp) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOrderUpdate(json: json)
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
extension AssignDetailVC {
    private  func jsonParsingOrderDetail(json:Any) {
        print("json \(json)")
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["data"] as? [String:Any] else {
                return
            }
            
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
    
    private  func jsonParsingOrderUpdate(json:Any) {
        print("json OrderUpdate \(json)")
        if let jsonTemp = json as? [String: Any]  {
            guard let _ = jsonTemp["msg"] as? String else {
                return
            }
            self.onBookingAccept!(true)
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- EXT - Helper Method
extension AssignDetailVC {
    func helperCreateDetailModel(){
        //cust name & mobile
        let phone = (order_pass.customer?.dial_code)! + " " +  (order_pass.customer?.mobile)!
        let mod1 = OrderTemoMod.init(title_one: "Customer Name".localized, desc_one:order_pass.customer?.name, img_one:"cust_name", title_two: "Contact Details".localized, desc_two:phone, img_two:"cust_mob")
        arr_temp1.append(mod1)
        
        //delivery date  & time
        let del_date = DateHelper.getDeliveryDateInLocalFromUTC(crt: order_pass.delivery_date!)
        let mod2 = OrderTemoMod.init(title_one: "Delivery Date".localized, desc_one:del_date, img_one:"et", title_two: "Delivery Time".localized, desc_two:order_pass.delivery_time, img_two:"et")
        arr_temp1.append(mod2)
        
        //payment_staus & payment_method
        let pay_method =  ProjectHelper.getPaymentMethod(st: order_pass.payment_method!)
        let pay_status =  ProjectHelper.getPaymentStatus(st: order_pass.payment_status!)
        let mod3 = OrderTemoMod.init(title_one: "Payment Method".localized, desc_one:pay_method, img_one:"pay_method", title_two: "Payment Status".localized, desc_two:pay_status, img_two:"et")
        arr_temp1.append(mod3)
        
        //sub total amt
        let subtotal = (String(order_pass.currency!) + " " + (order_pass.sub_total)!.clean)
        let modsub = SinglePayment.init(title_one: "Subtotal".localized, desc_one: subtotal)
        arr_temp2.append(modsub)
        
        //delivery cost
        let delivery = (String(order_pass.currency!) + " " + (order_pass.delivery_cost)!.clean)
        let moddel = SinglePayment.init(title_one: "Delivery".localized, desc_one: delivery)
        arr_temp2.append(moddel)
        
        //tax (%)
        let taxp = SinglePayment.init(title_one: "Tax(%)", desc_one: String(order_pass.tax_percentage!))
        arr_temp2.append(taxp)
        
        //tax
        let taxap = (String(order_pass.currency!) + " " + (order_pass.tax_amount)!.clean)
        let tax = SinglePayment.init(title_one: "Tax".localized, desc_one:taxap)
        arr_temp2.append(tax)
        
        //total_amount
        let totalAmt = (String(order_pass.currency!) + " " + (order_pass.total_amount)!.clean)
        let total = SinglePayment.init(title_one: "Total Amount".localized, desc_one:totalAmt)
        arr_temp2.append(total)
    }
}

// MARK:- EXT - UITableViewDataSource
extension AssignDetailVC : UITableViewDataSource{
    
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
            let mod = arr_temp2[indexPath.row]
            let tcell = tableView.dequeueReusableCell(withIdentifier: "cellprice", for: indexPath)
            let lblTitle = tcell.viewWithTag(10) as! UILabel
            let lblDesc = tcell.viewWithTag(20) as! UILabel
            lblTitle.text = mod.title_one
            lblDesc.text = mod.desc_one
            return tcell
        }
    }
}

// MARK:- EXT - UITableViewDelegate
extension AssignDetailVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return UITableView.automaticDimension
        }else if indexPath.section == 0{
            return 55
        }else{
            return 40
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

// MARK:- Ex - BUTTON ACTION
extension AssignDetailVC {
    @IBAction func btnPickUpClicked(_ sender: UIButton) {
        switch order_status {
        case 2:
            pushToPickUpConfirmationScreen()
        case 3:
            postUpdateOrderStatus()
        case 4:
            pushToPickUpConfirmationScreen()
        default:
            break
        }
    }
    
    @IBAction func btnViewItemsClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewOrderItemsVC") as!  ViewOrderItemsVC
        vc.order_pass = order_pass
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushToPickUpConfirmationScreen(){
        let story = UIStoryboard.init(name: "OrderDetail", bundle: nil)
        let nav = story.instantiateViewController(withIdentifier: "PickUpConformation") as! PickUpConformation
        nav.order_status = order_status
        nav.order_pass = order_pass
        nav.onPickUpConfirmation = {(status) in
            if status {
                self.onBookingAccept!(true)
            }
        }
        navigationController?.pushViewController(nav, animated: true)
    }
}



