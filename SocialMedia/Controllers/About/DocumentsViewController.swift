//
//  DocumentsViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/22/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class DocumentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable {
   
    var documnetDataResponseArray: NSMutableArray = []
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var addDocumentButton: UIButton!
    var statusFlag = false
    var isFromOtherUser = false
    var otherUserId = 0
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var documentTableView: UITableView!
    
    @IBOutlet var documentHeading: UILabel!
    //MARK: -   Loading Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if lang == "ar" {
            //backBtn.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            backBtn.setBackgroundImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
        }
        else {
            backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        
        
       documentHeading.text = "Documents".localized
        if (isFromOtherUser) {
            addDocumentButton.isHidden=true
        }else{
            addDocumentButton.isHidden=false
        }
        DispatchQueue.main.async {
           self.showLoader()
        }
        serverCallForGetAllDocuments ()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documnetDataResponseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsTableViewCell.className, for: indexPath) as! DocumentsTableViewCell
        
        cell.btnDeleteDocument.setTitle("DELETE".localized, for: .normal)
        cell.btnEditDocument.setTitle("EDIT".localized, for: .normal)
        cell.btnViewDocument.setTitle("VIEW FILE".localized, for: .normal)
        
        
        cell.lblDocumentName.text = (self.documnetDataResponseArray[indexPath.row] as! DocumentsDataInfo).orignal_name!
        if (isFromOtherUser) {
            cell.btnEditDocument.isHidden = true
            //cell.btnDeleteDocument.isHidden = true
             cell.btnViewDocument.isHidden = true
            cell.btnViewDocument.addTarget(self, action: #selector(viewFileButtonAction(_:)), for: .touchUpInside)
           
            
            cell.btnDeleteDocument.setTitle("VIEW FILE".localized, for: .normal)
            cell.btnDeleteDocument.addTarget(self, action: #selector(viewFileButtonAction(_:)), for: .touchUpInside)
        } else {
            cell.btnEditDocument.isHidden = false
            cell.btnDeleteDocument.isHidden = false
            cell.btnViewDocument.isHidden = false
            
            cell.btnViewDocument.addTarget(self, action: #selector(viewFileButtonAction(_:)), for: .touchUpInside)
            cell.btnDeleteDocument.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
            cell.btnEditDocument.addTarget(self, action: #selector(editButonAction(_:)), for: .touchUpInside)
        }

        cell.btnEditDocument.tag = indexPath.row
        cell.btnDeleteDocument.tag = indexPath.row
        cell.btnViewDocument.tag = indexPath.row
        
        let documentSelect = UITapGestureRecognizer(target: self, action: #selector(documentSelect(tapGestureRecognizer:)))
        cell.lblDocumentName.tag = indexPath.row
        cell.lblDocumentName.isUserInteractionEnabled = true
        cell.lblDocumentName.addGestureRecognizer(documentSelect)
        
        cell.imgDocument.tag = indexPath.row
        cell.imgDocument.isUserInteractionEnabled = true
        cell.imgDocument.addGestureRecognizer(documentSelect)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //MARK: - Button Actions
    @IBAction func addDocument(_ sender: Any) {
        print("Add Document Pressed")
        goToAddDocumentScreen()
    }
    func goToAddDocumentScreen(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addDocumentViewController = storyboard.instantiateViewController(withIdentifier: "AddDocumentViewController") as! AddDocumentViewController
        present(addDocumentViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("Back Buton Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func documentSelect(tapGestureRecognizer: UITapGestureRecognizer) {
        let index = tapGestureRecognizer.view?.tag
        let documentsDataInfo = documnetDataResponseArray[index!] as? DocumentsDataInfo
        UIApplication.shared.open(URL(string : ((documentsDataInfo?.path)!)!)!, options: [:], completionHandler: { (status) in
            
        })
    }
    
    @objc func editButonAction(_ sender: UIButton){
        print("edit button action", sender.tag)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addsViewController = storyboard.instantiateViewController(withIdentifier: EditDocumentViewController.className) as! EditDocumentViewController
        addsViewController.documentsDataInfo = documnetDataResponseArray[sender.tag] as? DocumentsDataInfo
        present(addsViewController, animated: true, completion: nil)
        goToMoreItemsScreen()
    }
    func goToMoreItemsScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addsViewController = storyboard.instantiateViewController(withIdentifier: EditDocumentViewController.className) as! EditDocumentViewController
        present(addsViewController, animated: true, completion: nil)
    }
    
    @objc  func deleteButtonAction(_ sender: UIButton){
        print("delete button action", sender.tag)
        let docid =    (self.documnetDataResponseArray[sender.tag] as! DocumentsDataInfo).id!
        serverCallForDeletingDocuments (docid : docid!, index: sender.tag)
        
    }
    
    @objc func viewFileButtonAction(_ sender: UIButton){
        let documentsDataInfo = documnetDataResponseArray[sender.tag] as? DocumentsDataInfo
        UIApplication.shared.open(URL(string : ((documentsDataInfo?.path)!)!)!, options: [:], completionHandler: { (status) in
            
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
    
    
    
    //MARK: - Server Calls
    func serverCallForGetAllDocuments (){
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
        if isFromOtherUser {
            userID = otherUserId
        }
        
        var parameters : [String: Any]
        parameters = [
            "id" : userID,
            "page" : 1
        ]
        
        let url = ApiCalls.baseUrlBuild +  ApiCalls.getAllDocuments
        
        print("url for all documnets",url)
        Alamofire.request(url, method: .get , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    //let dic =  responseDic.val
                    let documentsDataArray  = responseDic["data"] as! NSArray
                    
                            for i in 0..<documentsDataArray.count{

                                let documentDataInfo = DocumentsDataInfo()

                                documentDataInfo.id =  (documentsDataArray[i] as! NSDictionary).value(forKey: "id") as? Int
                                documentDataInfo.user_id =  (documentsDataArray[i] as! NSDictionary).value(forKey: "user_id") as? Int
                                documentDataInfo.orignal_name =  (documentsDataArray[i] as! NSDictionary).value(forKey: "orignal_name") as? String
                                documentDataInfo.doc_type =  (documentsDataArray[i] as! NSDictionary).value(forKey: "doc_type") as? String
                                documentDataInfo.path =  (documentsDataArray[i] as! NSDictionary).value(forKey: "path") as? String
                                documentDataInfo.privacy =  (documentsDataArray[i] as! NSDictionary).value(forKey: "privacy") as? String
                                documentDataInfo.created_at =  (documentsDataArray[i] as! NSDictionary).value(forKey: "created_at") as? String
                                documentDataInfo.updated_at =  (documentsDataArray[i] as! NSDictionary).value(forKey: "updated_at") as? String

                                self.documnetDataResponseArray.add(documentDataInfo)

                    }
                    self.documentTableView.reloadData()
                    self.stopAnimating()
                }
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                self.stopAnimating()
            }
            
        }
        
    }
   
    func serverCallForDeletingDocuments (docid : Int, index : Int){
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
            "id" : docid,
        ]
        
        let url = ApiCalls.baseUrlBuild +  ApiCalls.deleteDocument
        
        print("url for delete documnets",url)
        Alamofire.request(url, method: .delete , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    //let dic =  responseDic.val
                 //   let documentsDataArray  = responseDic["data"] as! NSArray
                 
                    self.documnetDataResponseArray.removeObject(at: index)
                     print("Successfully Deleted")
                    self.documentTableView.reloadData()
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
