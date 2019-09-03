//
//  PickUpConformation.swift
//  iMoneh Driver
//
//  Created by Rakhi on 07/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import MobileCoreServices

class PickUpConformation: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewSign: YPDrawSignatureView!
    @IBOutlet weak var txfdSender: UITextField!
    @IBOutlet weak var imgVSign: UIImageView!
    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblSenderSign: UILabel!
    
    var order_status: Int!
    var order_pass: OrderMod!
    var onPickUpConfirmation: ((_ confirm: Bool) -> ())?
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
        title = "Confirmation".localized
    }
    
    // MARK: - SET UI
    private func setUI(){
        
        imgVSign.isHidden = true
        imgVSign.clipsToBounds = true
        imgVSign.contentMode = .scaleAspectFill
        
        viewBg.layer.cornerRadius = 4
        viewBg.clipsToBounds = true
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
        viewBg.layer.borderWidth = 0.4
        
        viewSign.layer.cornerRadius = 4
        viewSign.clipsToBounds = true
        viewSign.layer.borderColor = UIColor.lightGray.cgColor
        viewSign.layer.borderWidth = 0.4
        
        if order_status == 2 {
            txfdSender.text =  order_pass.vendor_address?.owner_name
            txfdSender.isUserInteractionEnabled = false
            lblSender.text = "Sender".localized
            lblSender.text = "Sender Name".localized
        }else{
            lblSender.text = "Receiver".localized
            lblSender.text = "Receiver Name".localized
        }
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnClearClicked(_ sender: UIButton) {
        imgVSign.isHidden = true
        imgVSign.image = nil
        viewSign.clear()
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        var signImag : UIImage?
        if imgVSign.isHidden {
            guard let signatureImage = viewSign.getSignature(scale: 20) else {
                BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please enter signature".localized)
                return
            }
            signImag = signatureImage
        }else{
            signImag = imgVSign.image
        }
        
        guard let signatImage = signImag else {
            BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please enter signature".localized)
            return
        }
        
        if var name = txfdSender.text,name.count > 0 {
            name = Validation.removeWhiteSpaceAndNewLine(strTemp: name)
            name = Validation.removeDoubleSpace(name)
            if name.count > 2 {
                txfdSender.text = name
                postSignImage(proImg: signatImage)
            }else{
                BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please enter valid name".localized)
            }
        }else{
            BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please enter valid name".localized)
        }
    }
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        actionsheetForSelection()
    }
    
    // MARK:- TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- Ex - UIImagePickerControllerDelegate
extension PickUpConformation : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func actionsheetForSelection(){
        let alert = UIAlertController(title: "Update Sign Image".localized, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default , handler:{ (UIAlertAction)in
            self.showCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery".localized, style: .default , handler:{ (UIAlertAction)in
            self.showGallery()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler:{ (UIAlertAction)in
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
            imgVSign.isHidden = false
            imgVSign.image = chosenImage
            viewSign.clear()
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


// MARK:- Ex - API
extension PickUpConformation {
    private func postSignImage(proImg:UIImage) {
        guard let data_img = proImg.pngData() else {
            return
        }
        
        //url
        let strUrl = APIURLFactory.update_sign
        let tuple = APIURLFactory.createMultipartFileUploadRequestWithPara(strAbs: strUrl, isToken: true, para: [:], filename: "avatar.png", imgData: data_img, img_para: Parameters.image)
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
                    self.jsonParsingSignDetail(json: json)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }

    private func postUpdateOrderStatus(proImg:String) {
        let orderID  = (order_pass.order_id)!
        let vendorID = (order_pass.vendor_id)!
        let strUrl = APIURLFactory.update_status + "/" + String(orderID) + "/"
            + String(vendorID)
        
        let orderTemp = order_status + 1
        let paraTemp : [String:String] = [Parameters.status:String(orderTemp),Parameters.name:txfdSender.text!,Parameters.image:proImg]
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
extension PickUpConformation {
    private  func jsonParsingSignDetail(json:Any) {
        print("json Sign \(json)")
        if let jsonTemp = json as? [String: Any]  {
            //data_order
            guard let data = jsonTemp["data"] as? [String:Any] else {
                return
            }
            //image
            guard let img = data["image"] as? String else {
                return
            }
            print("img \(img)")
            self.postUpdateOrderStatus(proImg: img)
            
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
            self.onPickUpConfirmation!(true)
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}


/*
 Update Order Status
 driver/orders/change/status/{order_id}/{vendor_id}
 POST
 Yes
 
 status:3
 name:
 image:
 
 {"msg":"Success"}
 */

