//
//  AddDocumentViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/22/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import FileExplorer
import Alamofire
import NVActivityIndicatorView
import DLRadioButton

class AddDocumentViewController: UIViewController, NVActivityIndicatorViewable {
  
    // MARK: - Outlets and Vars
    var privacyStatus = ""
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var btnSelectDocument: UIButton!
    @IBOutlet weak var txtDocumentName: UITextField!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var privateView: UIView!
    
    @IBOutlet var addDocumentLbl: UILabel!
    @IBOutlet var backBtn: UIButton!
    
    @IBOutlet var privacyLbl: UILabel!
    
    @IBOutlet var publicLbl: UILabel!
    
    @IBOutlet var privateLbl: UILabel!
    //    let checkBoxPublic = Checkbox(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
//    let checkBoxPrivate = Checkbox(frame: CGRect(x: 0, y: 5, width: 20, height: 20))
    var docURL : URL?
    var arrayOfUrls : [URL]?
    
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
        
        
        //male_Female_Status = "male"
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
        
        //male_Female_Status = "female"
    }
   
    //MARK: Loading Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBackButton()
        addDocumentLbl.text = "Add Document".localized;
         privacyStatus = "open"
        btnSelectDocument.setTitle("Select a document".localized, for: .normal)
        txtDocumentName.placeholder = "Name".localized
        privacyLbl.text = "Privacy".localized
        publicLbl.text = "Public".localized
        privateLbl.text = "Private".localized
       buttonMale.setImage(UIImage(named: "selected-radio"), for: .normal)
   
        if lang == "ar" {
            //backBtn.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            backBtn.setBackgroundImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            txtDocumentName.textAlignment = .right
        }
        else {
            backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            txtDocumentName.textAlignment = .left
        }
    }

   
    
    // MARK: - Button Actions
 
    @IBAction func selectDocumentButtonAction(_ sender: Any) {
        print("choose document button pressed")
        let fileExplorer = FileExplorerViewController()
        fileExplorer.allowsMultipleSelection = false
        fileExplorer.fileFilters = [Filter.extension("txt"), Filter.extension("jpg")]
        fileExplorer.canChooseFiles=true
        fileExplorer.delegate = self
        self.present(fileExplorer, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("back button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        print("done button pressed")
        if txtDocumentName.text != ""{
            print("start upload")
            serverCallForUploadingDocuments ()
            //self.dismiss(animated: true, completion: nil)
            }else{
                    let alertController = UIAlertController(title: "File Name Required".localized, message: "", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func serverCallForUploadingDocuments ()
    {
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
        let userID: Int = (objUser?.id)!
        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "orignal_name" : txtDocumentName.text!,
            "privacy" : privacyStatus,
            "id" : userID
        ]
        
        let url = ApiCalls.baseUrlBuild +  ApiCalls.saveDocument
        
        print("save  documnet url",url)
        
//        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
//            switch response.result {
//            case .success:
//                let responseDic : [String : Any] = response.value as! [String : Any]
//                print("\(responseDic)")
//                if(response.result.description == "SUCCESS") {
//
//
//
//                    self.stopAnimating()
//                }
//            case .failure(let error):
//                print("RESPONSE ERROR: \(error)")
//                self.showAlrt(message: "RESPONSE ERROR: \(error)")
//                self.stopAnimating()
//            }
//        }
        
        
        
        
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
                    self.showAlrt(message: "Successfully Uploaded")
                    self.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                print("RESPONSE ERROR: \(encodingError)")
                self.showAlrt(message: "RESPONSE ERROR: \(encodingError)")
                self.stopAnimating()
               
            }
        })
        
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
    
}


// MARK: - File Exporer Methods Delegates

extension AddDocumentViewController: FileExplorerViewControllerDelegate {
     func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        var message = ""
        for url in urls {
            arrayOfUrls?.append(docURL!)
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
        btnSelectDocument.setTitle(message, for: .normal)
    }
    
     func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        
    }
}
