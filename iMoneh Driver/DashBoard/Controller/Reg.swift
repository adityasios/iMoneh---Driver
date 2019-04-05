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
    @IBOutlet var btnTermsCond : UIButton!
    
    @IBOutlet var txfdName: FloatingLabelTextField!
    @IBOutlet var txfdEmailAdd: FloatingLabelTextField!
    @IBOutlet var txfdPhone: FloatingLabelTextField!
    @IBOutlet var txfdGender: FloatingLabelTextField!
    @IBOutlet var txfdLoc: FloatingLabelTextField!
    @IBOutlet var txfdPass: FloatingLabelTextField!
    @IBOutlet var txfdCountry: FloatingLabelTextField!
    @IBOutlet var txfdCity: FloatingLabelTextField!
    @IBOutlet var txfdArea: FloatingLabelTextField!
    
    var arr_ctry : [CountryMod] = []
    var str_gender:String = "0"
    var country_mod : CountryMod?
    var city_mod : LocMod?
    var area_mod : LocMod?
    var arr_city : [LocMod] = []
    var arr_area : [LocMod] = []
    var isDialCode : Bool = true
    
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
        lblJoin.text = "Please Enter Driver Information".localized
        btnTermsCond.setTitle("I have read Terms & Condition".localized, for: .normal)
    }
    
    func setTxfd() {
        
        //name
        txfdName.font = AppFont.GilroyReg.fontReg15
        txfdName.titleActiveTextColour = appDarkYellow
        txfdName.titleFont = AppFont.GilroyBold.fontBold14!
        txfdName.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdName.placeholder = "Name".localized
        
        //email address
        txfdEmailAdd.font = AppFont.GilroyReg.fontReg15
        txfdEmailAdd.titleActiveTextColour = appDarkYellow
        txfdEmailAdd.titleFont = AppFont.GilroyBold.fontBold14!
        txfdEmailAdd.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdEmailAdd.placeholder = "Email Address".localized
        
        //phone
        txfdPhone.font = AppFont.GilroyReg.fontReg15
        txfdPhone.titleActiveTextColour = appDarkYellow
        txfdPhone.titleFont = AppFont.GilroyBold.fontBold14!
        txfdPhone.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdPhone.placeholder = "Phone Number".localized
        
        //gender
        txfdGender.font = AppFont.GilroyReg.fontReg15
        txfdGender.titleActiveTextColour = appDarkYellow
        txfdGender.titleFont = AppFont.GilroyBold.fontBold14!
        txfdGender.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdGender.placeholder = "Select Gender".localized
        
        //location
        txfdLoc.font = AppFont.GilroyReg.fontReg15
        txfdLoc.titleActiveTextColour = appDarkYellow
        txfdLoc.titleFont = AppFont.GilroyBold.fontBold14!
        txfdLoc.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdLoc.placeholder = "Address".localized
        
        //password
        txfdPass.font = AppFont.GilroyReg.fontReg15
        txfdPass.titleActiveTextColour = appDarkYellow
        txfdPass.titleFont = AppFont.GilroyBold.fontBold14!
        txfdPass.textAlignment = (Language.language == .english) ? NSTextAlignment.left : NSTextAlignment.right
        txfdPass.placeholder = "Password".localized
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
            isDialCode = true
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
        if isDialCode {
            setDialCodeData(countMod)
        }else{
            setCountryField(countMod: countMod)
        }
        
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
    
    private func getCityList(countMod:CountryMod) {
        let paraDict = [Parameters.country_id : String(countMod.id!)]
        
        //url
        let strUrl = APIURLFactory.cities_list
        guard let request = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: false, para: paraDict)else {
            return
        }
        Loader.showLoadingView(view: UIApplication.shared.keyWindow!)
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            Loader.hideLoadingView(view: UIApplication.shared.keyWindow!)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingForCityApi(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    func getAreaList(city_mod:LocMod) {
        let paraDict = [Parameters.country_id : String(country_mod!.id!),Parameters.city_id : String(city_mod.id!)]
        
        //url
        let strUrl = APIURLFactory.areas_list
        guard let request = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: false, para: paraDict)else {
            return
        }
        
        Loader.showLoadingView(view: UIApplication.shared.keyWindow!)
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            Loader.hideLoadingView(view: UIApplication.shared.keyWindow!)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingForAreaApi(json: json)
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
    
    func jsonParsingForCityApi(json:Any) {
        if let dict_json = json as? [String: Any]  {
            guard let data = dict_json["data"] as? [[String:Any]] else {
                return
            }
            do {
                let dataCity = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                arr_city = try decoder.decode([LocMod].self, from: dataCity)
            } catch let parsingError {
                print(parsingError)
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
    
    func jsonParsingForAreaApi(json:Any) {
        if let dict_json = json as? [String: Any]  {
            guard let data = dict_json["data"] as? [[String:Any]] else {
                return
            }
            
            do {
                let dataArea = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                arr_area = try decoder.decode([LocMod].self, from: dataArea)
            } catch let parsingError {
                print(parsingError)
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
            
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- Ext- UITextFieldDelegate
extension Reg : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txfdCountry {
            if arr_ctry.isEmpty {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"No country found for dial code")
            }else{
                presentCountrySelectionList()
            }
            return false
        }else if textField == txfdCity {
            presentCitySelectionList()
            return false
        }else if textField == txfdArea {
            presentAreaSelectionList()
            return false
        }else if textField == txfdGender {
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
        let alert = UIAlertController(title: "Select Gender".localized, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male".localized, style: .default , handler:{ (UIAlertAction)in
            self.txfdGender.text = "Male".localized
            self.str_gender = Parameters.kMale
        }))
        alert.addAction(UIAlertAction(title: "Female".localized, style: .default , handler:{ (UIAlertAction)in
            self.txfdGender.text = "Female".localized
            self.str_gender = Parameters.kFemale
        }))
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}

// MARK:- extension - HELPER METHODS
extension Reg {
    func presentCountrySelectionList() {
        isDialCode = false
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DialCodeVC") as! DialCodeVC
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = .overCurrentContext
        controller.arr_Pass = arr_ctry
        controller.delegate = self
        if let country_mod = country_mod {
            controller.crt_dial_code = country_mod.dial_code!
        }
        present(controller, animated: true)
    }
    
    func setCountryField(countMod: CountryMod) {
        txfdCountry.text = countMod.country_name
        if let country = country_mod {
            if countMod.id! != country.id! {
                country_mod = countMod
                getCityList(countMod: countMod)
                txfdCity.text = nil
                city_mod = nil
                txfdArea.text = nil
                area_mod = nil
            }
        }else{
            country_mod = countMod
            getCityList(countMod: countMod)
        }
    }
    
    func presentCitySelectionList() {
        if arr_city.isEmpty || arr_city.isEmpty{
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"No city found for selected country")
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CityAreaVC") as! CityAreaVC
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            controller.modalPresentationStyle = .overCurrentContext
            controller.arr_city = arr_city
            controller.strTitle = "Select State for \(country_mod!.country_name!)"
            controller.delegate = self
            controller.mod_city = city_mod
            controller.isCity = true
            present(controller, animated: true)
        }
    }
    
    func presentAreaSelectionList() {
        if arr_area.isEmpty || arr_city.isEmpty {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"No area found for selected city")
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CityAreaVC") as! CityAreaVC
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            controller.modalPresentationStyle = .overCurrentContext
            controller.arr_city = arr_area
            controller.strTitle = "Select State for \(city_mod!.city_name!)"
            controller.delegate = self
            controller.mod_city = area_mod
            controller.isCity = false
            present(controller, animated: true)
        }
    }
}

// MARK:- LocVCDelegate Methods
extension Reg:LocVCDelegate {
    func locModSelected(locMod: LocMod,isCity:Bool){
        if isCity {
            txfdCity.text = locMod.city_name
            if let city = city_mod {
                if locMod.id! != city.id! {
                    city_mod = locMod
                    getAreaList(city_mod: locMod)
                    txfdArea.text = nil
                    area_mod = nil
                }
            }else{
                city_mod = locMod
                getAreaList(city_mod: locMod)
            }
            
        }else{
            txfdArea.text = locMod.area_name
            if let area = area_mod {
                if locMod.id! != area.id! {
                    area_mod = locMod
                }
            }else{
                area_mod = locMod
            }
        }
    }
}
