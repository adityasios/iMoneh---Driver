//
//  ViewOrderItemsVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 23/04/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import SDWebImage

class ViewOrderItemsVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    var order_pass: OrderMod!
    var arrOrder : [OrderItemMod] = []
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderItemsDetail()
    }
}

// MARK:- EXT - UITableViewDataSource
extension ViewOrderItemsVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mod = arrOrder[indexPath.row]
        let tcell = tableView.dequeueReusableCell(withIdentifier: "cellitems", for: indexPath)
        
        //product img
        let imgV = tcell.viewWithTag(10) as! UIImageView
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = 2
        if let img = mod.product_image,let urlImg = URL.init(string: APIURLFactory.pro_img + img) {
            imgV.sd_setImage(with: urlImg, placeholderImage: imgPro_place, options:SDWebImageOptions.progressiveDownload, completed: nil)
        }else{
            imgV.image = imgPro_place
        }
        
        let lblTitle = tcell.viewWithTag(20) as! UILabel
        lblTitle.text = mod.product_name! + "\n" + "Qty :" + String(mod.quantity!)
        return tcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK:- Ex - API
extension ViewOrderItemsVC {
    private func getOrderItemsDetail() {
        let strUrl = APIURLFactory.product_details + "/" + String(order_pass.id!)
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para:[:]) else {
            return
        }
        Loader.showLoadingView(view: view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json_det = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingProductList(json: json_det)
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
extension ViewOrderItemsVC {
    private  func jsonParsingProductList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            //data
            guard let data = jsonTemp["data"] as? [String:Any] else {
                return
            }
            //products_list
            guard let products_list = data["products_list"] as? [[String:Any]] else {
                return
            }
            //modelling
            do {
                let dataOrder = try JSONSerialization.data(withJSONObject: products_list, options:[])
                let decoder = JSONDecoder()
                arrOrder = try decoder.decode([OrderItemMod].self, from: dataOrder)
                tblv.reloadData()
            } catch let parsingError {
                print("parsingError new order = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}
