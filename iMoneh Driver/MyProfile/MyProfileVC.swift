//
//  MyProfileVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 27/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import MobileCoreServices

enum EditImageType {
    case editProfile
    case editVehicle
}

class MyProfileVC: UIViewController {
    
    private var edit_imge_type = EditImageType.editProfile
    
    @IBOutlet weak var viewHead: UIView!
    @IBOutlet weak var imgVPro: UIImageView!
    @IBOutlet weak var imgVCar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNoDeliveries: UILabel!
    @IBOutlet weak var lblNoRejected: UILabel!
    @IBOutlet weak var lblMyEmail: UILabel!
    @IBOutlet weak var lblMyPhone: UILabel!
    @IBOutlet weak var lblDel: UILabel!
    @IBOutlet weak var lblReject: UILabel!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
        getProfiledata()
    }
    
    deinit {
        print("MyProfileVC deinit")
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Profile".localized
    }
    
    // MARK: - SET UI
    private func setUI(){
        
        lblMyEmail.text = "my email".localized
        lblMyPhone.text = "my phone".localized
        lblDel.text = "Deliveries".localized
        lblReject.text = "Rejected".localized
        
        //view
        viewHead.layer.cornerRadius = 4
        viewHead.clipsToBounds = true
        viewHead.semanticContentAttribute = .forceLeftToRight
        
        //profile
        imgVPro.layer.cornerRadius = (AppDevice.ScreenSize.SCREEN_HEIGHT * 0.25)/4
        imgVPro.clipsToBounds = true
        ProjectHelper.setProfileImage(imgV: imgVPro)
        
        //name
        lblName.text = Singleton.shared.userMod?.name
        
        //gender
        if let gender_id = Singleton.shared.userMod?.gender {
            lblGender.text = (gender_id == 1) ? "Male".localized : "Female".localized
        }else{
            lblGender.text = ""
        }
        
        //vehicle
        imgVCar.layer.cornerRadius = (AppDevice.ScreenSize.SCREEN_HEIGHT * 0.25)/4
        imgVCar.clipsToBounds = true
        ProjectHelper.setVehicleImage(imgV: imgVCar)
        
        
        //mobile
        lblPhone.text = "\(Singleton.shared.userMod!.dial_code!)-\(Singleton.shared.userMod!.mobile!)"
        
        //email
        lblEmail.text = Singleton.shared.userMod?.email
        
        //accepted order
        if let total_accepted_orders = Singleton.shared.userMod?.total_accepted_orders {
            lblNoDeliveries.text = String(total_accepted_orders)
        }else {
            lblNoDeliveries.text = "0"
        }
        
        //rejected order
        if let total_rejected_orders = Singleton.shared.userMod?.total_rejected_orders {
            lblNoRejected.text = String(total_rejected_orders)
        }else {
            lblNoRejected.text = "0"
        }
    }
}

// MARK:- Ex - API PARSING METHODS
extension MyProfileVC {
    
    private func getProfiledata() {
        //url
        let strUrl = APIURLFactory.profile_info
        guard let request = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: [:]) else {
            return
        }
        URlSessionWrapper.getDatefromSession(request: request) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingProfileData(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    private func postUpdateProfileImage(proImg:UIImage) {
        guard let data_img = proImg.pngData() else {
            return
        }
        //url
        let strUrl = APIURLFactory.update_pro_img
        let tuple = APIURLFactory.createMultipartFileUploadRequestWithPara(strAbs: strUrl, isToken: true, para: [:], filename: "avatar.png", imgData: data_img, img_para: Parameters.profile_image)
        guard let req = tuple.req , let data = tuple.dta  else {
            print("invalid request for  \(strUrl)")
            return
        }
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.uploadDatefromSession(request: req, data_req: data) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    Singleton.shared.img_profile = proImg
                    self.jsonParsingProfileImageUpdate(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    private func postUpdateVehicleImage(proImg:UIImage) {
        guard let data_img = proImg.pngData() else {
            return
        }
        //url
        let strUrl = APIURLFactory.update_vehicle_img
        let tuple = APIURLFactory.createMultipartFileUploadRequestWithPara(strAbs: strUrl, isToken: true, para: [:], filename: "avatar.png", imgData: data_img, img_para: Parameters.vehicle_image)
        guard let req = tuple.req , let data = tuple.dta  else {
            print("invalid request for  \(strUrl)")
            return
        }
        Loader.showLoadingView(view: self.view)
        URlSessionWrapper.uploadDatefromSession(request: req, data_req: data) { (data, err) in
            Loader.hideLoadingView(view: self.view)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingVehicleImageUpdate(json: json)
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
extension MyProfileVC {
    private func jsonParsingProfileData(json:Any) {
        print("Profile data json \(json)")
        if let jsonMain = json as? [String: Any]  {
            //user
            guard let user = jsonMain["user"] as? [String:Any] else {
                return
            }
            do {
                let dataUser = try JSONSerialization.data(withJSONObject: user, options:[])
                let decoder = JSONDecoder()
                let model = try decoder.decode(UserMod.self, from: dataUser)
                ProjectHelper.saveUserModel(userMod: model)
                setUI()
            } catch let parsingError {
                print("parsingError profile \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
    
    private func jsonParsingProfileImageUpdate(json:Any) {
        if let json_tmp = json as? [String: Any]  {
            guard let data = json_tmp["data"] as? [String:Any] else {
                return
            }
            guard let pro_img = data["profile_image"] as? String else {
                return
            }
            print("new pro_img = \(pro_img)")
            
            //save user data
            Singleton.shared.userMod?.profile_image = pro_img
            ProjectHelper.saveUserModel(userMod: Singleton.shared.userMod!)
            ProjectHelper.setVehicleImage(imgV: imgVCar)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
    
    private func jsonParsingVehicleImageUpdate(json:Any) {
        if let json_tmp = json as? [String: Any]  {
            guard let data = json_tmp["data"] as? [String:Any] else {
                return
            }
            guard let veh_img = data["vehicle_image"] as? String else {
                return
            }
            
            //save user data
            Singleton.shared.userMod?.vehicle_image = veh_img
            ProjectHelper.saveUserModel(userMod: Singleton.shared.userMod!)
        }else{
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

// MARK:- Ex - BUTTON ACTION
extension MyProfileVC {
    @IBAction func btnProfileClicked(_ sender: UIButton) {
        edit_imge_type = .editProfile
        actionsheetForSelection()
    }
    
    @IBAction func btnVehicleClicked(_ sender: UIButton) {
        edit_imge_type = .editVehicle
        actionsheetForSelection()
    }
    
    @IBAction func btnMenuButtonClicked(_ sender: UIBarButtonItem) {
        switch Language.language {
        case .english:
            self.sideMenuViewController?.presentLeftMenuViewController()
        case .arabic:
            self.sideMenuViewController?.presentRightMenuViewController()
        }
    }
}

// MARK:- Ex - UIImagePickerControllerDelegate
extension MyProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func actionsheetForSelection(){
        let alert = UIAlertController(title: "Update Profile Image", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.showCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.showGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func showCamera(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
    }
    
    func showGallery(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if edit_imge_type == .editVehicle {
                imgVCar.image = chosenImage
                self.postUpdateVehicleImage(proImg: chosenImage)
            }else{
                imgVPro.image = chosenImage
                self.postUpdateProfileImage(proImg: chosenImage)
            }
            dismiss(animated:true, completion: nil)
        case kUTTypeMovie:
            print("kUTTypeMovie selected")
            break
        case kUTTypeLivePhoto:
            print("kUTTypeLivePhoto selected")
            break
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
}


/*
 Driver Profile
 driver/profile/info
 GET
 Yes
 */

/*
 Upload Image
 driver/profile/image/update
 POST
 Yes
 profile_image:
 */
