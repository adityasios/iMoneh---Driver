//
//  ViewController.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var pageViewControl:UIPageViewController!
    
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var btnFgotPass: UIButton!
    @IBOutlet var btnBtmLogin: UIButton!
    
    @IBOutlet var lblJoin: UILabel!
    @IBOutlet var lblLogin: UILabel!
    @IBOutlet var viewBtn: UIView!
    
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewJoin: UIView!
    
    /**
     true - Login
     false - reg
     */
    var isSelLogin = true
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        print("ViewController deinit")
    }
    
    // MARK:- INIT METHOD
    private func initMethod() {
        setPageViewController()
    }
    
    private func setPageViewController() {
        pageViewControl = self.storyboard?.instantiateViewController(withIdentifier: "pageviewcontroller") as? UIPageViewController
        pageViewControl.view.frame = CGRect(x: 0, y: 200, width: AppDevice.ScreenSize.SCREEN_WIDTH, height: AppDevice.ScreenSize.SCREEN_HEIGHT - 200)
        pageViewControl.dataSource = self
        pageViewControl.delegate = self
        
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
        pageViewControl.didMove(toParent: self)
        self.view.bringSubviewToFront(viewBtn)
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
        pageViewControl.setViewControllers([loginVC],direction: .forward,animated: true,completion: nil)
    }

    // MARK:- SET UI METHOD
    private func setUI() {
        
        //login
        btnLogin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnLogin.setTitleColor(UIColor.darkText, for: .normal)
        btnLogin.setTitleColor(appDarkYellow, for: .highlighted)
        lblLogin.backgroundColor = appDarkYellow
        
        //reg
        btnJoin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnJoin.setTitleColor(UIColor.lightGray, for: .normal)
        btnLogin.setTitleColor(UIColor.black, for: .highlighted)
        lblJoin.backgroundColor = UIColor.clear
        
        if !isSelLogin {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnLogin.setTitleColor(UIColor.lightGray, for: .normal)
                self.lblLogin.backgroundColor = UIColor.clear
                
                self.btnJoin.setTitleColor(UIColor.darkText, for: .normal)
                self.lblJoin.backgroundColor = appDarkYellow
            })
        }
        setBtns()
    }
    
    private func setBtns() {
        
        //btnFpass
        btnFgotPass.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnFgotPass.setTitleColor(UIColor.white, for: .normal)
        btnFgotPass.setTitleColor(UIColor.black, for: .highlighted)
        btnFgotPass.backgroundColor = UIColor.black
        
        //btmLogin
        btnBtmLogin.titleLabel?.font = AppFont.GilroySemiBold.fontSemiBold14
        btnBtmLogin.setTitleColor(UIColor.darkText, for: .normal)
        btnBtmLogin.setTitleColor(appYellow, for: .highlighted)
        btnBtmLogin.backgroundColor = appYellow
        
        if isSelLogin {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnFgotPass.isHidden = false
                self.btnBtmLogin.setTitle("Login", for: .normal)
            })
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.btnFgotPass.isHidden = true
                self.btnBtmLogin.setTitle("Create Account", for: .normal)
            })
        }
    }
}

// MARK:- Ex- PAGE VIEW CONTROLLER DELEGATE
extension ViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is Reg {
            let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
            return loginVC
        }else{
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is Login {
            let regVC = storyboard?.instantiateViewController(withIdentifier:"join") as! Reg
            return regVC
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers[0] is Login {
                isSelLogin = false
            }
            
            if previousViewControllers[0] is Reg {
                isSelLogin = true
            }
            setUI()
        }
    }
}

// MARK:- Ex - ACTION METHOD
extension ViewController {
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        if isSelLogin {
            return
        }
        
        isSelLogin = true
        setUI()
        let loginVC = storyboard?.instantiateViewController(withIdentifier:"login") as! Login
        pageViewControl.setViewControllers([loginVC],direction:.reverse,animated: true,completion: nil)
    }
    
    
    @IBAction func btnJoinClicked(_ sender: UIButton) {
        if !isSelLogin {
            return
        }
        
        let regVC = storyboard?.instantiateViewController(withIdentifier:"join") as! Reg
        pageViewControl.setViewControllers([regVC],direction: .forward,animated: true,completion: nil)
        isSelLogin = false
        setUI()
    }
    
    @IBAction func btnFgotPassClicked(_ sender: UIButton) {
        let forgot = storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        let nav = UINavigationController.init(rootViewController: forgot)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnBtmLoginClicked(_ sender: UIButton) {
        if isSelLogin {
            validateLoginApiCall()
        }else{
            validateSignUpApiCall()
        }
    }
}

// MARK:- Ex - VALIDATE  METHODS
extension ViewController {
    
    func validateLoginApiCall() {
        
        let  arrChild = pageViewControl.children
        guard let  login = arrChild.first as? Login else {
            return
        }
        
        //email
        guard var email = login.txfdId.text,Validation.isValidEmail(strEmail: email) == true else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Email")
            return
        }
        email =  Validation.removeWhiteSpaceAndNewLine(strTemp: email)
        email =  Validation.removeDoubleSpace(email)
        
        //password
        guard var pass = login.txfdPass.text  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Password")
            return
        }
        pass =  Validation.removeWhiteSpaceAndNewLine(strTemp: pass)
        pass =  Validation.removeDoubleSpace(pass)
        if pass.count < 5 || pass.count > 15 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Password should be greater than 3 characters")
            return
        }
    
        //device_id
        guard let device_Id = Singleton.shared.device_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not able to get Device Id")
            return
        }
        
        //fcm
        guard let fcm = Singleton.shared.fcm_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please register for Push Notification")
            return
        }
        
        
        let paraDict = [Parameters.email : email, Parameters.pass : pass,Parameters.deviceId:device_Id,Parameters.fcmId:fcm,Parameters.deviceType:Parameters.deviceTypeiOS]
        postLoginAction(para: paraDict)
    }

    
    func validateSignUpApiCall() {
        let  arrChild = pageViewControl.children
        guard let  reg = arrChild.last as? Reg else {
            return
        }
        
        //terms & cond
        if reg.btnTerms.isSelected == false {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please select Terms & Condition")
            return
        }
        
        //name
        guard var mkName = reg.txfdName.text else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Name")
            return
        }
        mkName =  Validation.removeWhiteSpaceAndNewLine(strTemp: mkName)
        mkName =  Validation.removeDoubleSpace(mkName)
        if mkName.count < 5 || mkName.count > 30 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Name should be greater then 5 characters and lesser then 30 characters")
            return
        }
        
        //email
        guard var email = reg.txfdEmailAdd.text,Validation.isValidEmail(strEmail: email) == true else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Email")
            return
        }
        email =  Validation.removeWhiteSpaceAndNewLine(strTemp: email)
        email =  Validation.removeDoubleSpace(email)
        
        //dial code
        guard let dialcode = reg.lblDialCode.text , dialcode.count > 1 else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please Select Dial Code")
            return
        }
        
        //mobile no
        guard let mobile = reg.txfdPhone.text , mobile.count > 6 else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please Enter Valid Mobile Number")
            return
        }
        
        //gender
        guard let gender = Int(reg.str_gender),gender > 0 else{
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please Select Gender")
            return
        }
        
        //location
        guard let add = reg.txfdLoc.text , add.count > 5 else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please Select Dial Code")
            return
        }
        
        //password
        guard var pass = reg.txfdPass.text  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please enter Valid Password")
            return
        }
        
        pass =  Validation.removeWhiteSpaceAndNewLine(strTemp: pass)
        pass =  Validation.removeDoubleSpace(pass)
        if pass.count < 5 || pass.count > 15 {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Password should be greater than 3 characters")
            return
        }
        
        //device_id
        guard let device_Id = Singleton.shared.device_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not able to get Device Id")
            return
        }
        
        //fcm
        guard let fcm = Singleton.shared.fcm_Id  else {
            BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Please register for Push Notification")
            return
        }
        
        let paraDict = [Parameters.name:mkName,Parameters.email:email,Parameters.dial_code:dialcode,Parameters.mobile:mobile,Parameters.pass:pass,Parameters.gender:reg.str_gender,Parameters.address:add,Parameters.deviceId:device_Id,Parameters.fcmId:fcm,Parameters.deviceType:Parameters.deviceTypeiOS]
        postRegAction(para: paraDict)
    }
}

// MARK:- API CALL  METHODS
extension ViewController {

    func postLoginAction(para:[String:String]) {
        
        //url
        let strUrl = APIURLFactory.login
        
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: false, para: para) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingLoginApi(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    func postRegAction(para:[String:String]) {
        
        //url
        let strUrl = APIURLFactory.sign_up
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: false, para: para) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingRegApi(json: json)
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
extension ViewController {
    
    func jsonParsingLoginApi(json:Any) {
        print("json for Login  = \(json)")
        if let jsonArray = json as? [String: Any]  {
            
            //token
            guard let token = jsonArray["token"] as? String else {
                return
            }
            Singleton.shared.token = token
            
            //user
            guard let user = jsonArray["user"] as? [String:Any] else {
                return
            }
            
            do {
                let dataUser = try JSONSerialization.data(withJSONObject: user, options:[])
                let decoder = JSONDecoder()
                let model = try decoder.decode(UserMod.self, from: dataUser)
                saveUserModel(userMod: model)
                } catch let parsingError {
                print("parsingError login \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }

    func saveUserModel(userMod:UserMod) {
        DispatchQueue.main.async {
            Singleton.shared.userMod = userMod
            //save token
            UserDefaults.standard.set(Singleton.shared.token!, forKey: AppUserDefault.token.rawValue)
            
            //save login data
            let data = try! PropertyListEncoder().encode(userMod)
            UserDefaults.standard.set(data, forKey: AppUserDefault.login_data.rawValue)
            self.navigateToHome()
        }
    }
    
    func jsonParsingRegApi(json:Any) {
        print("json for sign up \(json)")
        if let jsonTmp = json as? [String: Any]  {
            guard let msg = jsonTmp["msg"] as? String else {
                return
            }
            resetJoinForm()
            BasicUtility.getAlert(view: self, titletop: "Registration", subtitle:msg)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
    
    func resetJoinForm(){
        let  arrChild = pageViewControl.children
        guard let  reg = arrChild.last as? Reg else {
            return
        }
        reg.txfdName.text = nil
        reg.txfdEmailAdd.text = nil
        reg.txfdPhone.text = nil
        reg.txfdGender.text = nil
        reg.txfdLoc.text = nil
        reg.txfdPass.text = nil
        reg.btnTerms.isSelected = false
    }
}

// MARK:- NAVIGATE METHODS
extension ViewController {
    private func navigateToHome() {
        let story = UIStoryboard.init(name: "Menu", bundle: nil)
        let root = story.instantiateViewController(withIdentifier: "rootController") as! RootViewController
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window!.rootViewController = root
    }
}


/*
 Register
 driver/register
 POST
 No
 
 "name": "Pavan Kr",
 "email": "test89@mailinator.com",
 "dial_code": "962",
 "mobile": "9898989889",
 "password": "123456",
 "gender": 1,
 "address": "Test Address",
 "device_id": "715127048340b893",
 "device_type": "1",
 "fcm_id": "fts1phfklxE:APA91bHPTNTOv27YIGaCP-RjNsT0a_SOQG-zLvDpuEO-Oqhi_rleps9sr2FML_qnk7UqDO9WtpIzfyahqaQmXvB6TMTqBgr0LI8azjz4_10WrkV6cRtRgdIxOYvsh27FmXFAi1898TtC"
 */



/*
Login
driver/login
POST
No

"email": "info@imoneh.com",
"password":"111111",
"fcm_id": "2sd1f2ds1f32s",
"device_id": "dsfjlsfs",
"device_type": 1
*/
