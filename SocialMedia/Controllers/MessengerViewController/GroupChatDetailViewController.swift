//
//  ViewController.swift
//  Example
//
//  Created by John DeLong on 5/11/16.
//  Copyright © 2016 delong. All rights reserved.
//

import UIKit
import SDWebImage
import ALCameraViewController
import AVFoundation
import AVKit
import NVActivityIndicatorView
import Hero
import DropDown
import TCPickerView
import SDWebImage
import UIKit
import ImagePicker
import Lightbox
import NVActivityIndicatorView
import MobileCoreServices
import AVFoundation
import AVKit
import FileExplorer
import Alamofire
import ImagePicker
import Lightbox
import NVActivityIndicatorView
import MobileCoreServices
import AVFoundation
import AVKit
import FileExplorer
import Alamofire
import SocketIO

class GroupChatDetailViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgGroupIcon: UIImageView!
    
    var navigationView = UIView()
    var header : StretchHeader!
    
    var userConversationData : UserConversationData? = nil
    var allFriends = [UserGetAllFriendsData]()
    var groupChatDetail : GroupDetail? = nil
     var groupId : Int = 0
    let maxHeaderHeight: CGFloat = 188;
    let minHeaderHeight: CGFloat = 44;

    var previousScrollOffset: CGFloat = 0;
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    var pickedImnageUrl: URL?
    var isAdmin : Bool = false
    var isAdminIndex : Int  = 0
   
     var groupMembersDetailsArray = [Int]()
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate.disableKeyboardManager(GroupChatDetailViewController.self)
        hideKeyboardWhenTappedAround()
        setupHeaderView()
        
        if let _groupChatDetail = self.groupChatDetail {
            for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                groupMembersDetailsArray.append(member.id)
            }
        }
        
       
        
        
        let objUser = UserHandler.sharedInstance.userData
        if let _ =  groupChatDetail, let _ownerId = groupChatDetail?.owner_id, let _objUserId = objUser?.id {
            if _ownerId == _objUserId {
                isAdmin = true
            }
        }

        
        tableView.register(UINib(nibName: "CellGroupChatOptions", bundle: nil), forCellReuseIdentifier: "CellGroupChatOptions")
        
          tableView.register(UINib(nibName: "LeaveTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaveTableViewCell")
        
        
        tableView.register(UINib(nibName: "CellGroupChatParticipant", bundle: nil), forCellReuseIdentifier: "CellGroupChatParticipant")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getAllFriends()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupHeaderView() {
        let options = StretchHeaderOptions()
        options.position = .fullScreenTop
        
        header = StretchHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 220),
                                 imageSize: CGSize(width: view.frame.size.width, height: 220),
                                 controller: self,
                                 options: options)
        if let _detail = groupChatDetail {
            let label = UILabel()
            label.frame = CGRect(x: 10, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
            label.textColor = UIColor.white
            label.text = _detail.title
            label.font = UIFont.boldSystemFont(ofSize: 16)
            header.addSubview(label)

            let url : URL = URL(string: _detail.image)!
            header.imageView.sd_setImage(with: url, completed: { (img, error , cacheType , imgUrl) in
                if let _img = img {
                    self.header.imageView.image = _img
                }
            })
        }
        
        tableView.tableHeaderView = header
        
        // NavigationHeader
        let navibarHeight : CGFloat = navigationController!.navigationBar.bounds.height
        let statusbarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: navibarHeight + statusbarHeight)
        //        navigationView.backgroundColor = UIColor(red: 121/255.0, green: 193/255.0, blue: 203/255.0, alpha: 1.0)
        navigationView.backgroundColor = UIColor(red: 66.0/255.0, green: 167.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        navigationView.alpha = 0.0
        view.addSubview(navigationView)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        button.setImage(#imageLiteral(resourceName: "back"), for: UIControl.State())
        //        button.setImage(#imageLiteral(resourceName: "back")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(self.onBackButtonClciked), for: .touchUpInside)
        view.addSubview(button)

    }
    
    // MARK: - Selector
    override func onBackButtonClciked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showChangeGroupNameAlert() {
        let alertController = UIAlertController(title: "Change Group Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let txtGroupName = alertController.textFields![0] as UITextField
            if let _groupChatDetail = self.groupChatDetail {
                let groupId : Int = _groupChatDetail.id
                let name : String = txtGroupName.text!
                let privacy : String = _groupChatDetail.privacy
              var arrayofGroupmember = [String]()
                for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                    arrayofGroupmember.append(String(member.id))
                }
                
            var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy,"group_members":arrayofGroupmember]
               self.updateGroupDetail(Withparameters: parameters)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Group Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc  func btnAddParticipants(_ sender : UIButton) {
        var filteredFriends: [UserGetAllFriendsData] = allFriends
        for friend in allFriends {
            for member in (groupChatDetail?.groupMembers)! {
                if (friend.id == member.id) {
                    if let _index = filteredFriends.index(of: friend) {
                        filteredFriends.remove(at: _index)
                    }
                }
            }
            
        }

        let picker = TCPickerView()
        picker.title = "Select Participants"
        let values = filteredFriends.map { (model : UserGetAllFriendsData) -> TCPickerView.Value in
            
            print(model.fullName)
             return TCPickerView.Value(title: model.fullName)
            
        }
        picker.values = values
//        picker.delegate = self
        picker.selection = .multiply
        picker.completion = { (selectedIndexes) in
            var arrayofGroupmember = [String]()
            if (selectedIndexes.count > 0) {
                if var _groupChatDetail = self.groupChatDetail {
                    let groupId : Int = _groupChatDetail.id
                    let name : String = _groupChatDetail.title
                    let privacy : String = _groupChatDetail.privacy
                    
                    print(selectedIndexes)
//                    for index in selectedIndexes {
//                        print(self.groupChatDetail?.groupMembers[index].full_name)
//                    }
                    
//                    for (key,member) in _groupChatDetail.groupMembers.enumerated() {
//                        print(member)
//                    }
                    
                    for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                       // groupMemberDictionary ["group_members[\(key)]"] =  String(member.id)
                        arrayofGroupmember.append(String(member.id))
                        //_groupChatDetail.groupMembers.append(member)
                        
                        
                    }
                    //self.tableView.reloadData()
                    //self.tableView.reloadData()
                    for (key,memberIndex) in selectedIndexes.enumerated() {
                        let member = filteredFriends[memberIndex]
                        // _groupChatDetail.groupMembers.append(member)
                        arrayofGroupmember.append(String(member.id))
                    }
                    
                    var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy, "group_members": arrayofGroupmember]
                    var groupMemberDictionary = [String: Any]()
                    
                    
                    
                    
//                    parameters.update(other: groupMemberDictionary)
//                    print("parameter : \(parameters)")
//                    var newMemberDictionary = [String: Any]()
//                    for (key,memberIndex) in selectedIndexes.enumerated() {
//                        let member = filteredFriends[memberIndex]
//                        newMemberDictionary ["group_members[\(key + (_groupChatDetail.groupMembers.count))]"] =  String(member.id)
//                    }
//                    parameters.update(other: newMemberDictionary)
                    print("parameter : \(parameters)")
                    self.updateGroupDetail(Withparameters: parameters)
                }
            }
        }
        picker.show()
    }
    
   @objc func btnChangeGroupName(_ sender : UIButton) {
        showChangeGroupNameAlert()
    }

    @objc func btnChangGroupPhoto(_ sender : UIButton) {
        showCamera()
    }
    
    @objc func btnRemoveMember(_ sender : UIButton) {
        
        let alert = UIAlertController(title: "Delete Participent", message: "Do you really want to delete this participent?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            
            if let _groupChatDetail = self.groupChatDetail {
                let groupId : Int = _groupChatDetail.id
                let name : String = _groupChatDetail.title
                let privacy : String = _groupChatDetail.privacy
                var groupMemberDictionary = [String: Any]()
                
                self.groupChatDetail?.groupMembers.remove(at: sender.tag)
                var groupMembersArray = [String]()
                for (key,member) in (self.groupChatDetail?.groupMembers.enumerated())! {
                    groupMemberDictionary ["group_members[\(key)]"] =  String(member.id)
                    groupMembersArray.append(String(member.id))
                }
                self.tableView.reloadData()
                var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy,"group_members": groupMembersArray]
                // parameters.update(other: groupMemberDictionary)
                print("parameter : \(parameters)")
                self.updateGroupDetail(Withparameters: parameters)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
       
    }
    @objc func btnLeaveMember(_ sender : UIButton) {
        
        let alert = UIAlertController(title: "Leave Group", message: "Do you really want to leave this group?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            self.LeaveGroupCall()
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    @objc func btnShowMemberProfile(_ sender : UIButton) {
        print("sender.tag", sender.tag)
        print(groupMembersDetailsArray)
        let groupMemberId = groupMembersDetailsArray[sender.tag]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = groupMemberId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func showCamera() {
        let cameraViewController =  CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            if image != nil{
                self?.saveFileToDocumentsDirectory(image: image!)
                self?.dismiss(animated: true, completion: nil)
            }
            else{
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }

    func saveFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "profilePicture&CoverPicture", extention: ".jpg") {
            self.pickedImnageUrl = savedUrl
            self.changeGroupPhoto (FilePath:pickedImnageUrl!, coverUrl:String(describing: pickedImnageUrl!), parameterName: "image", FileName: "image")
        }
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }

}

extension GroupChatDetailViewController {
    func changeGroupPhoto (FilePath:URL, coverUrl:String, parameterName:String, FileName:String){
        self.showLoader()
        //var dictionaryForm = Dictionary<String, Any>()
        if let _groupChatDetail = self.groupChatDetail {
            let groupId : Int = _groupChatDetail.id
            let name : String = _groupChatDetail.title
            let privacy : String = "members_only"//private
            var groupMemberDictionary = [String: Any]()
            var groupMembersArray = [String]()
            for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                groupMemberDictionary ["group_members[\(key)]"] =  String(member.id)
                groupMembersArray.append(String(member.id))
            }
            
            var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy]//,"group_members": groupMembersArray
            parameters.update(other: groupMemberDictionary)
            print(parameters)

            ConversationsHandler.editGroupPicture(fileName:parameterName,fileUrl: FilePath, params: parameters as NSDictionary, success: { (successResponse) in
                self.stopAnimating()
                print(successResponse)
                if successResponse.statusCode == 200 {
                    //UserHandler.sharedInstance.userData = successResponse.data
                    
                }
            }) { (errorResponse) in
                self.stopAnimating()
                print(errorResponse!)
                //self.stopAnimating()
            }
            
        }
        
        
       
       // print(dictionaryForm)
        
       
        
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    
    func LeaveGroupCall(){
        self.showLoader()
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        //        let objUser = UserHandler.sharedInstance.userData
        //        var userID: Int = (objUser?.id)!
        //        print("user id ",userID)
        
       // print(self.groupId)
        var parameters : [String: Any]
        parameters = [
            "group_id" : self.groupId
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.LeaveChatGroupRequest
        
        
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Leave Group")
                    print("success")
                    
                    self.stopAnimating()
                    
                }
                self.stopAnimating()
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.stopAnimating()
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
    }
    func getAllFriends() {
        self.showLoader()
        let objUser = UserHandler.sharedInstance.userData
        let userID: Int = (objUser?.id)!
        
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
                self.allFriends = successResponse.data
                self.stopAnimating()
            }
            else{
                self.stopAnimating()
                self.displayAlertMessage(successResponse.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    func updateGroupDetail(Withparameters _parameters : [String : Any]) {
        self.showLoader()
        print(_parameters)
        ConversationsHandler.createGroupChat(params: _parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            self.stopAnimating()
            if (successResponse.statusCode == 200){
                
                self.tableView.reloadData()
            }
            else{
                self.stopAnimating()
                self.displayAlertMessage(successResponse.message)
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showError(message: errorResponse!.message)
        }
    }
}

extension GroupChatDetailViewController: CellGroupChatOptionsDelegate {
    func publicCheckClick() {
        if let _groupChatDetail = self.groupChatDetail {
            let groupId : Int = _groupChatDetail.id
            let name : String = _groupChatDetail.title
            let privacy : String = "members_only"//private
            var groupMemberDictionary = [String: Any]()
            var groupMembersArray = [String]()
            for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                groupMemberDictionary ["group_members[\(key)]"] =  String(member.id)
                groupMembersArray.append(String(member.id))
            }
            
            var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy,"group_members": groupMembersArray]
           // parameters.update(other: groupMemberDictionary)
            print("groupMemberDictionary : \(groupMemberDictionary)")
            print("parameter : \(parameters)")
            self.updateGroupDetail(Withparameters: parameters)
        }
    }
    func privateCheckClick() {
        if let _groupChatDetail = self.groupChatDetail {
            let groupId : Int = _groupChatDetail.id
            let name : String = _groupChatDetail.title
            let privacy : String = "private"//
            var groupMemberDictionary = [String: Any]()
            var groupMembersArray = [String]()
            for (key,member) in _groupChatDetail.groupMembers.enumerated() {
                groupMemberDictionary ["group_members[\(key)]"] =  String(member.id)
                groupMembersArray.append(String(member.id))
            }
            var parameters : [String: Any] = ["group_id" : groupId , "title" : name, "privacy" : privacy,"group_members": groupMembersArray]
            //parameters.update(other: groupMemberDictionary)
            print("parameter : \(parameters)")
            self.updateGroupDetail(Withparameters: parameters)
        }
    }
}

extension GroupChatDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return (groupChatDetail?.groupMembers.count)! + 3
        
        if let _groupMembers = groupChatDetail?.groupMembers{
            return _groupMembers.count + 3
            print(_groupMembers.count)
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell : CellGroupChatOptions = tableView.dequeueReusableCell(withIdentifier: "CellGroupChatOptions") as! CellGroupChatOptions
            cell.selectionStyle = .none
            if (!isAdmin) {
                cell.viewOptions.isHidden = true
                return cell
            }
            cell.delegate = self
            cell.btnAddParticipants.addTarget(self, action: #selector(self.btnAddParticipants(_:)), for: .touchUpInside)
            cell.btnChangeGroupName.addTarget(self, action: #selector(self.btnChangeGroupName(_:)), for: .touchUpInside)
            cell.btnChangGroupPhoto.addTarget(self, action: #selector(self.btnChangGroupPhoto(_:)), for: .touchUpInside)
            
            
            if let _ =  groupChatDetail, let _privacy = groupChatDetail?.privacy{
                if _privacy == "members_only"
                {
                    cell.btnPrivate.isChecked = false
                    cell.btnPublic.isChecked = true
                }else{
                    cell.btnPrivate.isChecked = true
                    cell.btnPublic.isChecked = false
                }
                
            }

            
            return cell
            
        case 1:
            
               let cell : LeaveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeaveTableViewCell") as! LeaveTableViewCell
            
               if (!isAdmin) {
                                 cell.lbltext.text = "Leave Group"
                            }
                            else{
                                   cell.lbltext.text = ""
                            }
               cell.btnLeave.addTarget(self, action: #selector(self.btnLeaveMember(_:)), for: .touchUpInside)
             
//            cell?.selectionStyle = .none
//
//
//
//                if (cell == nil) {
//                    cell = UITableViewCell(style: .default, reuseIdentifier: "CellGroupChatParticipantCount")
//                    cell?.selectionStyle = .none
//                }
//            if (!isAdmin) {
//                cell?.textLabel?.text = "Leave Group"
//            }
//            else{
//                  cell?.textLabel?.text = ""
//            }
//                //            if let _groupMembers = groupChatDetail?.groupMembers{
//                //                cell?.textLabel?.text = "Leave Group"
//                //            } else {
//                //                cell?.textLabel?.text = "Participant"
//                //            }
//                cell?.textLabel?.textColor = UIColor(displayP3Red: 66.0/255.0, green: 167.0/255.0, blue: 214.0/255.0, alpha: 1.0)
         
         
            return cell
         
        case 2:
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellGroupChatParticipantCount")
            cell?.selectionStyle = .none
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CellGroupChatParticipantCount")
                cell?.selectionStyle = .none
            }

            if let _groupMembers = groupChatDetail?.groupMembers{
                cell?.textLabel?.text = "\(_groupMembers.count) Participant"
            } else {
                cell?.textLabel?.text = "Participant"
            }
            cell?.textLabel?.textColor = UIColor(displayP3Red: 66.0/255.0, green: 167.0/255.0, blue: 214.0/255.0, alpha: 1.0)
            return cell!
        default:
            let cell : CellGroupChatParticipant = tableView.dequeueReusableCell(withIdentifier: "CellGroupChatParticipant") as! CellGroupChatParticipant
            cell.selectionStyle = .none
            
            for name in (groupChatDetail?.groupMembers)! {
                print(name.full_name)
            }
            print(groupChatDetail?.groupMembers.count)
            cell.lblUsername.text = groupChatDetail?.groupMembers[indexPath.row - 3].full_name
            cell.imgUserImage.clipsToBounds = true
            cell.imgUserImage.contentMode = .scaleAspectFill
            if let _url = groupChatDetail?.groupMembers[indexPath.row - 3].image {
                cell.imgUserImage.sd_setImage(with: URL(string: String(describing: _url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            }
            cell.btnCross.tag = indexPath.row-3
            cell.btnCross.addTarget(self, action: #selector(self.btnRemoveMember(_:)), for: .touchUpInside)
            
            cell.btnOpenUserProfile.tag = indexPath.row-3
            cell.btnOpenUserProfile.addTarget(self, action: #selector(self.btnShowMemberProfile(_:)), for: .touchUpInside)
            
            
            if (isAdmin) {
                cell.btnCross.isHidden = false
            } else {
                cell.btnCross.isHidden = true
            }
            if let _ =  groupChatDetail, let _ownerId = groupChatDetail?.owner_id, let _memberId = groupChatDetail?.groupMembers[indexPath.row - 3].id {
                if _ownerId == _memberId {
                    cell.btnCross.isHidden = false
                    cell.btnCross.setTitle("admin", for: .normal)
                    cell.btnCross.setImage(nil, for: .normal)
                    cell.btnCross.isUserInteractionEnabled = false
                }
            }

            return cell
        }
    }
}

extension GroupChatDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if (isAdmin) {
                return 170.0
            }
            return 0.0
        case 1:
            return 44.0
        case 2:
            return 44.0
        default:
            return 55.0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        // NavigationHeader alpha update
        let offset : CGFloat = scrollView.contentOffset.y
        if (offset > 50) {
            let alpha : CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(50) + (navigationView.frame.height) - offset) / (navigationView.frame.height))
            navigationView.alpha = CGFloat(alpha)
            
        } else {
            navigationView.alpha = 0.0;
        }

//        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
//        let absoluteTop: CGFloat = 0;
//        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
//
//        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
//        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
//
//        if canAnimateHeader(scrollView) {
//
//            // Calculate new header height
//            var newHeight = self.headerHeightConstraint.constant
//            if isScrollingDown {
//                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
//            } else if isScrollingUp {
//                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
//            }
//
//            // Header needs to animate
//            if newHeight != self.headerHeightConstraint.constant {
//                self.headerHeightConstraint.constant = newHeight
//                self.updateHeader()
//                self.setScrollPosition(self.previousScrollOffset)
//            }
//
//            self.previousScrollOffset = scrollView.contentOffset.y
//        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }

    func scrollViewDidStopScrolling() {
//        let range = self.maxHeaderHeight - self.minHeaderHeight
//        let midPoint = self.minHeaderHeight + (range / 2)
//
//        if self.headerHeightConstraint.constant > midPoint {
//            self.expandHeader()
//        } else {
//            self.collapseHeader()
//        }
    }

//    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
//        // Calculate the size of the scrollView when header is collapsed
//        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
//
//        // Make sure that when header is collapsed, there is still room to scroll
//        return scrollView.contentSize.height > scrollViewMaxHeight
//    }

//    func collapseHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.minHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func expandHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.maxHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func setScrollPosition(_ position: CGFloat) {
//        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
//    }
//
//    func updateHeader() {
//    }
}
