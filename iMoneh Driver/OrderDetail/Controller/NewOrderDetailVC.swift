//
//  NewOrderDetailVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 18/04/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

// 142.93.210.141:3000/api/cancellation/reasons/list


class NewOrderDetailVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnViewItems: UIButton!
    
    var order_pass      : OrderMod!
    var arr_temp1       : [OrderTemoMod] = []
    var arr_temp2       : [SinglePayment] = []
    var onBookingAccept : ((_ accept: Bool) -> ())?
    var subOrderId      : Int = 0
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderList()
        initMethod()
        setUI()
        getOrderDetail()
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Order Detail".localized
        tblv.estimatedRowHeight = 60
        tblv.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    private func registerCell() {
        let nibSt = UINib.init(nibName: "OrderDetailCell", bundle: nil)
        self.tblv.register(nibSt, forCellReuseIdentifier: "OrderDetailCell")
    }
    
    // MARK: - SET UI
    private func setUI(){
        lblStatus.text = (order_pass.market_name ?? "").localized
        btnViewItems.layer.cornerRadius = 2
        btnViewItems.layer.borderColor = UIColor.white.cgColor
        btnViewItems.layer.borderWidth = 1.0
    }
}

// MARK:- Ex - BUTTON ACTION
extension NewOrderDetailVC {
    @IBAction func btnAcceptClicked(_ sender: UIButton) {
        let passID = (order_pass.id ?? 0)
        let orderID = (order_pass.order_id ?? 0)
        acceptOrderRequest(id: String(passID), order_id: String(orderID))
    }
    @IBAction func btnRejectClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderCancelVC") as! OrderCancelVC
        vc.didSelectReason = {[weak self] (reason, extraComment) in
            self?.rejectOrderRequest(reason: reason, extraCmmnt: extraComment)
        }
        present(vc, animated: true, completion: nil)
        //showActionSheetForReject()
    }
    
    @IBAction func btnViewItemsClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewOrderItemsVC") as!  ViewOrderItemsVC
        vc.order_pass = order_pass
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- Ex - API
extension NewOrderDetailVC {
    private func getOrderDetail() {
        let strUrl = APIURLFactory.order_detail + String(order_pass.id ?? 0) + "/\(String(order_pass.sub_order_id ?? 0))"
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
    
    private func acceptOrderRequest(id: String, order_id: String) {
        let strUrl = APIURLFactory.orders_accept + id + "/" + order_id  + "/" + String(subOrderId)
        print("strUrl \(strUrl)")
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para:[:]) else {
            return
        }
        
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json_det = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOrderAccept(json: json_det)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle: err)
            }
        }
    }
    
    private func rejectOrderRequest(reason: OrderCancellationReasonMod, extraCmmnt: String) {
        let passID = (order_pass.id)!
        let strUrl = APIURLFactory.orders_reject
        let paraDic : [String: String] = [Parameters.comments : reason.title ?? "",
                                          Parameters.id : String(passID),
                                          "extra_comment" : extraCmmnt]
        
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: true, para: paraDic) else {
            return
        }
        
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json_det = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOrderAccept(json: json_det)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    
    private func getOrderList() {
        let strUrl = APIURLFactory.order_list
        let paraTemp : [String:String] = [Parameters.page:"1",Parameters.status:OrderStatus.new.rawValue]
        
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: paraTemp) else {
            return
        }
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in

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
    
    private  func jsonParsingOrderList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            print("jsonTemp \(jsonTemp)")
            
            //data_order
            guard let data = jsonTemp["data"] as? [[String:Any]] else {
                return
            }
            
            //modelling
            do {
                let dataOrder = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                let arrOrder = try decoder.decode([OrderMod].self, from: dataOrder)
                let subOrderData = arrOrder.filter{$0.id == order_pass.id}
                if let subOrder = subOrderData.first {
                    self.subOrderId = subOrder.sub_order_id ?? 0
                }
                
            } catch let parsingError {
                print("parsingError new order = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- Ex - API PARSING METHODS
extension NewOrderDetailVC {
    private func jsonParsingOrderDetail(json:Any) {
        print("new order json \(json)")
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
    
    private  func jsonParsingOrderAccept(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            print("jsonTemp accept/reject \(jsonTemp)")
            self.onBookingAccept!(true)
            self.navigationController?.popViewController(animated: true)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- EXT - Helper Method
extension NewOrderDetailVC {
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
        let needChangeAmount =  "\(order_pass.currency ?? "") \(order_pass.change_amount ?? 0)"
        let mod3 = OrderTemoMod.init(title_one: "Payment Type".localized, desc_one: pay_method, img_one:"pay_method", title_two: "Cash on Pick Need Change".localized, desc_two: needChangeAmount, img_two:"pay_method")
        arr_temp1.append(mod3)
        
        //sub total amt
        let subtotal = (String(order_pass.currency!) + " " + (order_pass.sub_total)!.clean)
        let modsub = SinglePayment.init(title_one: "Subtotal".localized, desc_one: subtotal)
        arr_temp2.append(modsub)
        
        //delivery cost
        let delivery = (String(order_pass.currency!) + " " + (order_pass.delivery_cost)!.clean)
        let moddel = SinglePayment.init(title_one: "Delivery Cost".localized, desc_one: delivery)
        arr_temp2.append(moddel)
        
        //tax (%)
        let taxp = SinglePayment.init(title_one: "Tax(%)                        \(order_pass.tax_percentage!)%", desc_one: String(""))
        arr_temp2.append(taxp)
        
        //tax
        let taxap = (String(order_pass.currency!) + " " + (order_pass.tax_amount)!.clean)
        let tax = SinglePayment.init(title_one: "Tax Amount                 \(taxap)".localized, desc_one:"")
        arr_temp2.append(tax)
        
        //total_amount
        let totalAmt = (String(order_pass.currency!) + " " + (order_pass.total_amount)!.clean)
        let total = SinglePayment.init(title_one: "Received Amount".localized, desc_one:totalAmt)
        arr_temp2.append(total)
    }
}

// MARK:- EXT - UITableViewDataSource
extension NewOrderDetailVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if order_pass.product_not_available_option != nil && order_pass.order_options != nil  {
            return 4
        }else if order_pass.product_not_available_option != nil || order_pass.order_options != nil  {
            return 3
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (arr_temp1.count + 1)
        case 1:
            return arr_temp2.count
        case 2,3:
            return 1
        default:
            return 0
        }
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
                
                var cust_add = (order_pass.customer_address?.address ?? "")
                cust_add.append("\u{00a0}")
                cust_add.append(order_pass.customer_address?.area_name ?? "")
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
        }else if indexPath.section == 1{
            let mod = arr_temp2[indexPath.row]
            let tcell = tableView.dequeueReusableCell(withIdentifier: "cellprice", for: indexPath)
            let lblTitle = tcell.viewWithTag(10) as! UILabel
            let lblDesc =  tcell.viewWithTag(20) as! UILabel
            lblTitle.text = mod.title_one
            lblDesc.text = mod.desc_one
            return tcell
        }else if indexPath.section == 2{
            let tcell = tableView.dequeueReusableCell(withIdentifier: "celldesc", for: indexPath)
            let lblTitle = tcell.viewWithTag(10) as! UILabel
            if let orderOpt = order_pass.product_not_available_option {
                lblTitle.text =  ProductNotAvailable.getProductNotAvailableOptionString(opt: orderOpt)
            }
            return tcell
        }else {
            let tcell = tableView.dequeueReusableCell(withIdentifier: "celldesc", for: indexPath)
            let lblTitle = tcell.viewWithTag(10) as! UILabel
            if let orderOpt = order_pass.order_options{
                var option = ""
                var indexTemp = 1
                let arrTemp = Array(orderOpt)
                for str in arrTemp {
                    if let intValue = Int(String(str)){
                        option += String(indexTemp) + "\u{00a0}" + OrderOption.getOrderOptionString(opt: intValue)
                        indexTemp += 1
                        option.append("\n")
                    }
                }
                lblTitle.text =  option
            }
            return tcell
        }
    }
}

// MARK:- EXT - UITableViewDelegate
extension NewOrderDetailVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return UITableView.automaticDimension
        }else if indexPath.section == 0{
            return 55
        }else if indexPath.section == 2 || indexPath.section == 3{
            return UITableView.automaticDimension
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Order Info".localized
        case 1:
            return "Payment Info".localized
        case 2:
            return "If Product Not Available".localized
        case 3:
            return "Order Options".localized
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = AppFont.GilroySemiBold.fontSemiBold15
        header.textLabel?.textAlignment = .left
        header.textLabel?.frame = header.frame
    }
}

// MARK:- extension - ALERT METHODS
extension NewOrderDetailVC {
    private func showActionSheetForReject() {
        let alertmsg  = "Please Enter Reason".localized
        let alertController = UIAlertController(title: alertmsg, message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Reason".localized
        }
        let saveAction = UIAlertAction(title: "Submit".localized, style: UIAlertAction.Style.default, handler: { alert -> Void in
            let txfd = alertController.textFields![0] as UITextField
            if let value = txfd.text,value.count > 4{
                //self.rejectOrderRequest(reason: value)
                alertController.dismiss(animated: true, completion: nil)
            }else{
                alertController.dismiss(animated: true, completion: nil)
                BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please Enter a Valid Reason".localized)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: { alert -> Void in
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}




/*
 Accept Order
 driver/orders/accept/{id}
 GET
 Yes
 {"msg":"Success"}
 id: from api # 6.
 */





/*
 let passID = (order_pass.id)!
 
"Please Enter Reason"
"Reason"
"Submit"
"Please Enter a Valid Reason"
"Cancel"
 
"Call you"
"Remove item from the cart"
"Exchange product with similar prduct"
"Unauthorize Option"
"If Product Not Available"
 
 "Order Options
 "Notes"
 */




