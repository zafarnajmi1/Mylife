//
//  EditDocumentViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/23/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Alamofire
import FileExplorer
import NVActivityIndicatorView

class EditDocumentViewController: UIViewController, NVActivityIndicatorViewable {

    var privacyStatus : String?
    @IBOutlet weak var txtDocumentName: UITextField!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var selectDocumnetButton: UIButton!
    @IBOutlet var editDocumentHeading: UILabel!
    @IBOutlet var privacyLbl: UILabel!
    @IBOutlet var backBtn: UIButton!
    
    @IBOutlet var publicLbl: UILabel!
    
    @IBOutlet var privacyHeader: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    //    let checkBoxPublic = Checkbox(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
//    let checkBoxPrivate = Checkbox(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
    var docURL : URL?
    var documentsDataInfo : DocumentsDataInfo?
    
    @IBOutlet weak var buttonMale: CheckBox! {
        didSet {
            buttonMale.isChecked = true
        }
    }
    
    @IBOutlet weak var buttonFemale: CheckBox! {
        didSet {
            buttonFemale.isChecked = false
            
        }
    }
    
    @IBAction func actionMale(_ sender: Any) {
        if buttonMale.isChecked==true{
            buttonMale.isChecked=false
            
        }else{
            privacyStatus = "open"
            buttonMale.isChecked = true
            buttonFemale.isChecked = false
            buttonFemale.setImage(UIImage(named: "radio"), for: .normal)
            buttonMale.setImage(UIImage(named: "selected-radio"), for: .normal)
        }
        
    }
    
    @IBAction func actionFemale(_ sender: Any) {
        
        if buttonFemale.isChecked==true{
           
            buttonFemale.isChecked = false
        }else{
            privacyStatus = "close"
            buttonMale.isChecked = false
            buttonFemale.isChecked = true
            buttonMale.setImage(UIImage(named: "radio"), for: .normal)
            buttonFemale.setImage(UIImage(named: "selected-radio"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      buttonMale.setImage(UIImage(named: "selected-radio"), for: .normal)
        selectDocumnetButton.setTitle(documentsDataInfo?.orignal_name!, for: .normal)
         privacyStatus = "open"
        
        editDocumentHeading.text = "Edit Document".localized;
        privacyStatus = "open"
        selectDocumnetButton.setTitle("Select a document".localized, for: .normal)
        txtDocumentName.placeholder = "Name".localized
        privacyLbl.text = "Private".localized
        publicLbl.text = "Public".localized
        //privateLbl.text = "Private".localized
        privacyHeader.text = "Privacy".localized
        buttonMale.setImage(UIImage(named: "selected-radio"), for: .normal)
        
        if lang == "ar" {
            //backBtn.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            backBtn.setBackgroundImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            self.txtDocumentName.textAlignment = .right
        }
        else {
            backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            self.txtDocumentName.textAlignment = .left
        }
        
        
        //privacyStatus = (documentsDataInfo?.privacy!)!
       // docURL = ((documentsDataInfo?.path)!)! as! URL
        
//        publicView.addSubview(checkBoxPublic)
//        privateView.addSubview(checkBoxPrivate)
//
//        checkBoxPublic.checkedBorderColor = .blue
//        checkBoxPublic.uncheckedBorderColor = .black
//
//        checkBoxPrivate.checkedBorderColor = .blue
//        checkBoxPrivate.uncheckedBorderColor = .black
//
//        checkBoxPublic.borderStyle = .circle
//        checkBoxPrivate.borderStyle = .circle
//
//        checkBoxPublic.borderWidth = 1.0
//        checkBoxPrivate.borderWidth = 1.0
//
//        checkBoxPublic.checkmarkStyle = .circle
//        checkBoxPrivate.checkmarkStyle = .circle
//
//        checkBoxPublic.isChecked=true
//
//        checkBoxPublic.addTarget(self, action: #selector(publiccheckboxValueChanged(sender:)), for: .valueChanged)
//        checkBoxPrivate.addTarget(self, action: #selector(privatecheckboxValueChanged(sender:)), for: .valueChanged)
//
    }
    
    // MARK: - CheckBox Selectors
    
    @objc func publiccheckboxValueChanged(sender: Checkbox) {
        print("public checkbox value change: \(sender.isChecked)")
        
        print("check box public")
       // checkBoxPrivate.isChecked=false
        privacyStatus = "open"
        
    }
    
    @objc func privatecheckboxValueChanged(sender: Checkbox) {
        print("private checkbox value change: \(sender.isChecked)")
        print("check box private")
        //checkBoxPublic.isChecked=false
        privacyStatus = "close"
    }
    
    //MARK: - Helping Methods
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - Button Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("back button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectDocumentButtonAction(_ sender: Any) {
        print("choose document button pressed")
        let fileExplorer = FileExplorerViewController()
        fileExplorer.allowsMultipleSelection = false
        fileExplorer.fileFilters = [Filter.extension("txt"), Filter.extension("jpg")]
        fileExplorer.canChooseFiles=true
        fileExplorer.delegate = self
        self.present(fileExplorer, animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        print("done button pressed")
        if txtDocumentName.text != ""{
            print("start upload")
            if docURL != nil{
                serverCallForUploadingDocuments ()
            }else{
                serverCallForUploadingDocumentsWithoutURL ()
            }
            
            //self.dismiss(animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "File Name Required".localized, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func serverCallForUploadingDocuments (){
        self.showLoader()
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken//"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "orignal_name" : txtDocumentName.text!,
            "privacy" : privacyStatus!,
            "id" : documentsDataInfo?.id as Any
        ]
        
        let url = ApiCalls.baseUrlBuild +  ApiCalls.saveDocument
        
        print("save  documnet url",url)
        
        Alamofire.upload(multipartFormData:  { multipartFormData in
            
            let uurl = self.docURL
            let data = try? Data(contentsOf: uurl!)
            let imageFromUrl = UIImage(data: data!)
            
            
            if let image = imageFromUrl    {
                let imageData = image.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(image, 0.9)
                let imageName = "attachment"
                let fileName = imageName + ".jpg"
                let imageSize = Double(imageData!.count)
                
                print("\(imageName) size in KB = \(imageSize/1024.0)")
                
                multipartFormData.append(data!, withName: imageName, fileName: fileName, mimeType: "any") //"image/jpeg"
            }
            
            for (key, value) in parameters  {
                multipartFormData.append(String(describing: value).data(using:.utf8, allowLossyConversion: false)!, withName: key)
            }
            
        }, usingThreshold: UInt64(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    self.dismiss(animated: true, completion: nil)
                    self.showAlrt(message: "Successfully Updated")
                    self.stopAnimating()
                   
                }
                
            case .failure(let encodingError):
                print(encodingError)
                print("RESPONSE ERROR: \(encodingError)")
                self.showAlrt(message: "RESPONSE ERROR: \(encodingError)")
                self.stopAnimating()
                
            }
        })
        
    }
    
    func serverCallForUploadingDocumentsWithoutURL (){
        self.showLoader()
        
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken//"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "orignal_name" : txtDocumentName.text!,
            "privacy" : privacyStatus!,
            "id" : documentsDataInfo?.id as Any
        ]
        
        
        let url = ApiCalls.baseUrlBuild +  ApiCalls.saveDocument
        
        print("save  documnet url",url)
        
        
        print("url for updating documnets",url)
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    self.dismiss(animated: true, completion: nil)
                    self.showAlrt(message: "Successfully Updated")
                    self.stopAnimating()
                   
                }
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                self.stopAnimating()
            }
            
        }
        
    }
        
    
    
    
    
    
}




// MARK: - File Exporer Methods Delegates

extension EditDocumentViewController: FileExplorerViewControllerDelegate {
     func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        var message = ""
        for url in urls {
           // arrayOfUrls?.append(docURL!)
            docURL =  url
            message += "\(url.lastPathComponent)"
            if url != urls.last {
                message += "\n"
            }
        }

        //        let alertController = UIAlertController(title: "Choosen files", message: message, preferredStyle: .alert)
        //        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        self.present(alertController, animated: true, completion: nil)

        print("choosen file is", message)
        selectDocumnetButton.setTitle(message, for: .normal)
    }

     func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {

    }
}


