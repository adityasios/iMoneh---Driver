//
//  Reg.swift
//  iMonehMarket
//
//  Created by Rakhi on 07/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import SDWebImage

class Reg: UITableViewController,DialCodeVCDelegate {
    
    @IBOutlet var lblJoin : UILabel!
    @IBOutlet var lblDialCode : UILabel!
    @IBOutlet var imgVFlag : UIImageView!
    @IBOutlet var btnTerms : UIButton!
    
    @IBOutlet var txfdName: FloatingLabelTextField!
    @IBOutlet var txfdEmailAdd: FloatingLabelTextField!
    @IBOutlet var txfdPhone: FloatingLabelTextField!
    @IBOutlet var txfdGender: FloatingLabelTextField!
    @IBOutlet var txfdLoc: FloatingLabelTextField!
    @IBOutlet var txfdPass: FloatingLabelTextField!
    
    var arr_ctry : [CountryMod] = []
    var str_gender:String = "0"
    
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
        
        //name
        txfdName.font = AppFont.GilroyReg.fontReg15
        txfdName.titleActiveTextColour = appDarkYellow
        txfdName.titleFont = AppFont.GilroyBold.fontBold14!
        
        //email address
        txfdEmailAdd.font = AppFont.GilroyReg.fontReg15
        txfdEmailAdd.titleActiveTextColour = appDarkYellow
        txfdEmailAdd.titleFont = AppFont.GilroyBold.fontBold14!
        
        //phone
        txfdPhone.font = AppFont.GilroyReg.fontReg15
        txfdPhone.titleActiveTextColour = appDarkYellow
        txfdPhone.titleFont = AppFont.GilroyBold.fontBold14!
        
        //gender
        txfdGender.font = AppFont.GilroyReg.fontReg15
        txfdGender.titleActiveTextColour = appDarkYellow
        txfdGender.titleFont = AppFont.GilroyBold.fontBold14!
        
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
            if  let flagimg =  ctrMod.flag_image,let urlimg = URL.init(string: APIURLFactory.country_flag + flagimg) {
                self.imgVFlag.sd_setImage(with: urlimg, completed: nil)
            }
        }
    }
    
    
    // MARK:- BUTTON ACTION
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
            if let dial_code = lblDialCode.text {
                controller.crt_dial_code = dial_code
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func btnCheckBoxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnTermsClicked(_ sender: UIButton) {
    }
    
    // MARK:- DELEGATE METHODS
    func dialCodeSelected(countMod: CountryMod) {
        setDialCodeData(countMod)
    }
}

// MARK:- Ext - API CALL  METHODS
extension Reg {
    
    func getCountryList() {
        
        //already_saved_json
        if let json_saved = UserDefaults.standard.object(forKey: AppUserDefault.ctry_data.rawValue) {
            self.jsonParsingCountryList(json: json_saved)
            return
        }
        
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

// MARK:- Ext - API PARSING METHODS
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
                    UserDefaults.standard.set(json, forKey: AppUserDefault.ctry_data.rawValue)
                    self.setDialCodeData(arr_ctry.first!)
                }
            } catch let parsingError  {
                print("parsingError = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }
    }
}

// MARK:- Ext- UITextFieldDelegate
extension Reg : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txfdGender {
            genderSelected()
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func genderSelected(){
        let alert = UIAlertController(title: "Select Gender", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            self.txfdGender.text = "Male"
            self.str_gender = Parameters.kMale
        }))
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            self.txfdGender.text = "Female"
            self.str_gender = Parameters.kFemale
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}
