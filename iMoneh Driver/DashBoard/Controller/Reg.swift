//
//  Reg.swift
//  iMonehMarket
//
//  Created by Rakhi on 07/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class Reg: UITableViewController,UITextFieldDelegate,DialCodeVCDelegate {
    
    
    
    @IBOutlet var lblJoin : UILabel!
    @IBOutlet var lblDialCode : UILabel!
    @IBOutlet var imgVFlag : UIImageView!
    @IBOutlet var txfdMark: FloatingLabelTextField!
    @IBOutlet var txfdArMark: FloatingLabelTextField!
    @IBOutlet var txfdEmailAdd: FloatingLabelTextField!
    @IBOutlet var txfdPhone: FloatingLabelTextField!
    @IBOutlet var txfdLoc: FloatingLabelTextField!
    @IBOutlet var txfdPass: FloatingLabelTextField!
    
    var arr_ctry : [CountryMod] = []
    
    
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getCountryList()
    }
    
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    // MARK:- INIT METHOD
    func initMethod() {
    }
    
    // MARK:- SET UI METHOD
    func setUI() {
        setTxfd()
    }
    
    
    
    
    
    
    
    func setTxfd() {
        
        //mark
        txfdMark.font = AppFont.GilroyReg.fontReg15
        txfdMark.titleActiveTextColour = appDarkYellow
        txfdMark.titleFont = AppFont.GilroyBold.fontBold14!
        
        //ar mark
        txfdArMark.font = AppFont.GilroyReg.fontReg15
        txfdArMark.titleActiveTextColour = appDarkYellow
        txfdArMark.titleFont = AppFont.GilroyBold.fontBold14!
        
        //email address
        txfdEmailAdd.font = AppFont.GilroyReg.fontReg15
        txfdEmailAdd.titleActiveTextColour = appDarkYellow
        txfdEmailAdd.titleFont = AppFont.GilroyBold.fontBold14!
        
        //phone
        txfdPhone.font = AppFont.GilroyReg.fontReg15
        txfdPhone.titleActiveTextColour = appDarkYellow
        txfdPhone.titleFont = AppFont.GilroyBold.fontBold14!
        
        
        //location
        txfdLoc.font = AppFont.GilroyReg.fontReg15
        txfdLoc.titleActiveTextColour = appDarkYellow
        txfdLoc.titleFont = AppFont.GilroyBold.fontBold14!
        
        
        //password
        txfdPass.font = AppFont.GilroyReg.fontReg15
        txfdPass.titleActiveTextColour = appDarkYellow
        txfdPass.titleFont = AppFont.GilroyBold.fontBold14!
    }
    
    
    func setDialCodeData(_ ctrMod:CountryMod) {
        DispatchQueue.main.async {
            self.lblDialCode.text = ctrMod.dial_code
        }
    }
    
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func btnDialCodeClicked(_ sender: UIButton) {
        if arr_ctry.isEmpty {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"No country found for dial code")
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DialCodeVC") as! DialCodeVC
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            controller.modalPresentationStyle = .overCurrentContext
            controller.arr_Pass = arr_ctry
            controller.delegate = self
            present(controller, animated: true)
        }
    }
    
    // MARK:- DELEGATE METHODS
    func dialCodeSelected(countMod: CountryMod) {
        setDialCodeData(countMod)
    }
}


// MARK:- API CALL  METHODS
extension Reg {
    
    func getCountryList() {
        
        //url
        let strUrl = APIURLFactory.country_list
        guard let request = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: false, para: [:]) else {
            return
        }
        
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("json = \(json)")
                    self.jsonParsingCountryList(json: json)
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
extension Reg {
    
    func jsonParsingCountryList(json:Any) {
        
        if let json_res = json as? [String: Any]  {
            guard let arr_data = json_res["data"] as? [[String:Any]] else {
                return
            }
            
            do {
                let data_ctr = try JSONSerialization.data(withJSONObject: arr_data, options:[])
                let decoder = JSONDecoder()
                arr_ctry = try decoder.decode([CountryMod].self, from: data_ctr)
                if arr_ctry.count > 0 {
                    self.setDialCodeData(arr_ctry.first!)
                }
            } catch let parsingError  {
                print("parsingError = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }
    }
}
