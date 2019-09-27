//
//  GroupChatViewController.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 23/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

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
import SwiftyJSON

extension SegueIdentifiable {
    static var groupChatViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: GroupChatViewController.className)
    }
}

//class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,NVActivityIndicatorViewable, ImagePickerDelegate, UIActionSheetDelegate {
class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate,NVActivityIndicatorViewable, ImagePickerDelegate, UIActionSheetDelegate {
    var iconsArray = [Icons]()
    var combination = NSMutableAttributedString()

    
    @IBOutlet var chatHeadCollection: UICollectionView!
    @IBOutlet weak var attachmentImageConstOne: NSLayoutConstraint!
    @IBOutlet weak var attachmentImageConstTwo: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomAttachment: UIImageView!
    @IBOutlet weak var btmDiscardAttachment: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblParticipants: UILabel!
    var userConversationData : UserConversationData? = nil
    var groupDetail : GroupDetail? = nil
    var onlineFriends = [UserGetAllFriendsData]()
    
    
    @IBOutlet var msgContainerView: UIView!
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var dataArray = [ChatData] ()
    
    var participantsArrayImageUrl = [String]()
    var participantsArray = [String]()
    var participantsArrayName = [String]()
    var is_online = [Int]()
    var user_ID = [Int]()

    let barHeight: CGFloat = 50
    var recevierId = 0
    var conversationId = 0
    var groupId = Int()
    var pickedImnageUrl: URL?
    var thumnailUrl: URL?
    var imgCounter = 0
    var addMedia = false
    var isKeyboardOpened = false
    var isKeyboardToggling = false
    var navTitle : String?
    var navigTitle : String = ""
    var userImage : String = ""
    var docURL : URL?
    let user = SharedData.sharedUserInfo

    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var viewMainContainer: UIView!
    
    @IBOutlet var viewContainer1: UIView!
    @IBOutlet var viewContainer2: UIView!
    @IBOutlet var viewContainer3: UIView!
    @IBOutlet var viewContainer4: UIView!
    @IBOutlet var viewContainer5: UIView!
    @IBOutlet var viewImageAtt: UIView!
    var keyboardhide = false

    var isKeyboardOpened2 = false
    var isKeyboardToggling2 = false
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var oltSend: UIButton!
    @IBOutlet var oltAddAttachment: UIButton!
    @IBOutlet var imgProfilePhoto: UIImageView!
    

    var txtMessageValue : String = ""
    
    var userEmoji : String = ""
    
    
    var socket:SocketIOClient!
    var manager:SocketManager!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
         self.setupKeyboardScrolling()
        appDelegate.disableToolbarOnKeyboard(controller: GroupChatViewController.self)
        appDelegate.disableDistanceHandling(controller: GroupChatViewController.self)
        appDelegate.enableTouchOnKeyboard(controller: GroupChatViewController.self)
         leftMarginToPlaceHolder()
      //  self.attachmentImageConstOne.constant = 5
      //  self.attachmentImageConstTwo.constant = 5
        self.imageViewBottomAttachment.isHidden = true
        self.btmDiscardAttachment.isHidden = true
        self.keyboardhide = false

        self.imageViewBottomAttachment.isHidden = true
        self.btmDiscardAttachment.isHidden = true
        self.viewImageAtt.isHidden = true
        self.viewMainContainer.isHidden = true
        iconsArray.removeAll()
        if self.user.EmojiArray.isEmpty {
            return
        }
        else {
            iconsArray = self.user.EmojiArray[0].icons!
        }
        
        showGroupParticipants()
        
        self.showLoader()
        self.hitConversation()
        // Do any additional setup after loading the view.
    }
    private func scrollToBottom(animated: Bool) {
         if self.dataArray.count > 0 {
        let lastRow = IndexPath(row: self.dataArray.count - 1 , section: 0)
        self.tblView.scrollToRow(at: lastRow, at: .top, animated: animated)
        }
    }
    // MARK: - KEYBOARD SCROLLING
    private var keyboard: Keyboard!
    
    private func setupKeyboardScrolling() {
        self.keyboard = Keyboard()
          self.keyboardhide = true
        // Lift/lower send view based on keyboard height.
        let keyboardAnimation = { [unowned self] in
            self.keyboardhide = true

            var keyboardHeight = self.keyboard.height
            if(self.keyboardhide){
                if #available(iOS 11.0, *) {
                let bottomInset = self.view.safeAreaInsets.bottom
                keyboardHeight -= bottomInset
                }
            }
            self.viewMainContainer.isHidden = true
            self.bottomConstraint.constant  = keyboardHeight
            self.isKeyboardOpened2 = false
            //  self.bottomConstraint.constant = self.keyboard.height
            self.view.layoutIfNeeded()
        }
        // Scroll to bottom after animation.
        let keyboardCompletion: (Bool) -> Void = { [unowned self] _ in
            self.scrollToBottom(animated: true)
            
            self.isKeyboardOpened2 = false
            
        }
        
        // React to keyboard height changes.
        self.keyboard.heightChanged = {
            UIView.animate(
                withDuration: 0.2,
                animations: keyboardAnimation,
                completion: keyboardCompletion
            )
        }
        
        // Hide keyboard on tap.
        let tap =
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.hideKeyboard(_:))
        )
        self.tblView.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        //  self.sendView?.removeFocus()
        view.endEditing(true)
        if(self.keyboardhide){
            if #available(iOS 11.0, *) {
                let bottomInset = self.view.safeAreaInsets.bottom
                
                self.bottomConstraint.constant  += bottomInset
                self.keyboardhide = false
            }
        }
        
        
        
        let conversationID = [
            "receiver_id":  0,
                                "chat_group_id": "\(self.groupId)",
                                "conversation_id": 0
            
            
            ] as [String : Any]
        self.socket.emit("typing-end", with: [conversationID])
      //  self.viewMainContainer.isHidden = true
    }
    func leftMarginToPlaceHolder() {
        let message = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
       // txtMessage.leftView = message
        
       // txtMessage.leftViewMode = UITextFieldViewMode.always
    }
    @IBOutlet var EmojiCollection: UICollectionView!{
        didSet{
            EmojiCollection.delegate = self
            EmojiCollection.dataSource = self
        }
    }
    @IBAction func bowtieButtonPressed(_ sender: UIButton) {
        iconsArray.removeAll()
        self.viewContainer1.backgroundColor = UIColor.gray
        self.viewContainer2.backgroundColor = UIColor.white
        self.viewContainer3.backgroundColor = UIColor.white
        self.viewContainer4.backgroundColor = UIColor.white
        self.viewContainer5.backgroundColor = UIColor.white
        
        iconsArray = self.user.EmojiArray[0].icons!
        self.EmojiCollection.reloadData()
    }
    
    @IBAction func cornButtonPressed(_ sender: UIButton) {
        iconsArray.removeAll()
        iconsArray = self.user.EmojiArray[3].icons!
        self.viewContainer1.backgroundColor = UIColor.white
        self.viewContainer2.backgroundColor = UIColor.white
        self.viewContainer3.backgroundColor = UIColor.white
        self.viewContainer4.backgroundColor = UIColor.gray
        self.viewContainer5.backgroundColor = UIColor.white
        self.EmojiCollection.reloadData()
        
    }
    
    @IBAction func oneButtonPressed(_ sender: UIButton) {
        iconsArray.removeAll()
        iconsArray = self.user.EmojiArray[4].icons!
        self.viewContainer1.backgroundColor = UIColor.white
        self.viewContainer2.backgroundColor = UIColor.white
        self.viewContainer3.backgroundColor = UIColor.white
        self.viewContainer4.backgroundColor = UIColor.white
        self.viewContainer5.backgroundColor = UIColor.gray
        self.EmojiCollection.reloadData()
        
    }
    
    @IBAction func squirrelButtonPressed(_ sender: UIButton) {
        iconsArray.removeAll()
        iconsArray = self.user.EmojiArray[2].icons!
        self.viewContainer1.backgroundColor = UIColor.white
        self.viewContainer2.backgroundColor = UIColor.white
        self.viewContainer3.backgroundColor = UIColor.gray
        self.viewContainer4.backgroundColor = UIColor.white
        self.viewContainer5.backgroundColor = UIColor.white
        self.EmojiCollection.reloadData()
        
    }
    @IBAction func sunnyButtonPressed(_ sender: UIButton) {
        iconsArray.removeAll()
        iconsArray = self.user.EmojiArray[1].icons!
        self.viewContainer1.backgroundColor = UIColor.white
        self.viewContainer2.backgroundColor = UIColor.gray
        self.viewContainer3.backgroundColor = UIColor.white
        self.viewContainer4.backgroundColor = UIColor.white
        self.viewContainer5.backgroundColor = UIColor.white
        self.EmojiCollection.reloadData()
        
    }
    func hitConversation(){
        
        
        
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forcePolling(false),
                .forceWebsockets(true),
                .path("/socket.io"),
                .connectParams(usertoken),
                .log(true)
            ]
            self.manager = SocketManager(socketURL: URL(string:  ApiCalls.baseUrlSocket)! , config: specs)
            
            self.socket = manager.defaultSocket
            
//            self.socket  = SocketIOClient(
//                socketURL: NSURL(string: ApiCalls.baseUrlSocket)! as URL as URL,
//                config: specs)
            
            
            
            self.socket.on("connected") { (data, ack) in
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
                
            }
            
            self.socket.on("userLoggedin") { (data, ack) in
                
                let modified =  (data[0] as AnyObject)
                
               
                let swiftY = JSON(modified)
                print(swiftY["data"]["user_id"].intValue)
                
                for (index,id) in self.user_ID.enumerated() {
                    if id == swiftY["data"]["user_id"].intValue {
                        self.is_online[index] = 1
                        
                    }
                }
                self.chatHeadCollection.reloadData()
             
                
            }
            self.socket.on("userLoggedout") { (data, ack) in
                
                let modified =  (data[0] as AnyObject)
                
                
                let swiftY = JSON(modified)
                print(swiftY["data"]["user_id"].intValue)
                
                for (index,id) in self.user_ID.enumerated() {
                    if id == swiftY["data"]["user_id"].intValue {
                        self.is_online[index] = 0
                    }
                }
                
                self.chatHeadCollection.reloadData()
            }
            //
            
            self.socket.on("typing") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print( dictionary)
//                if let _navTitle = self.navTitle {
//                    self.navigationItem.titleView = self.setTitle(title: _navTitle, subtitle: "SUBTITLE")
//
//                    //   self.title = _navTitle
//                } else  {
//                    self.title = "Messages"
//                }
            }
            self.socket.on("typing-end") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print( dictionary)
//                if let _navTitle = self.navTitle {
//                    self.navigationItem.titleView = self.setTitle(title: _navTitle, subtitle: "")
//                    
//                    //   self.title = _navTitle
//                } else  {
//                    self.title = "Messages"
//                }
            }
            self.socket.on("getConversation") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print( dictionary)
                
                
                self.participantsArrayName.removeAll()
                self.is_online.removeAll()
                self.participantsArray.removeAll()
                self.user_ID.removeAll()
                
                let objData = ChatModel(fromDictionary: dictionary)
                
                
                if(objData.message! == "Please Accept Request"){
                    let alertController = UIAlertController(title:"Accept Request".localized,message:"Are you sure you want to Accept Request?".localized, preferredStyle: .alert)
                    let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
                        print("ok button pressed")
                       self.AcceptGroupCall()
                    }
                    let cancelAction = UIAlertAction(title:"Cancel".localized,style: .default){UIAlertAction in
                        print("cancel button pressed")
                    }
                    alertController.addAction(OkAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                                    for status in objData.groupDetail.groupMembers {
                                        self.is_online.append(status.is_online)
                    
                                        self.participantsArrayName.append(status.full_name)
                                        self.participantsArrayImageUrl.append(status.image!)
                                        self.user_ID.append(status.id!)
                                        print(status.image!)
                                    }
                }
                
                
                self.dataArray = (objData.data)!
                

                
                
                 self.chatHeadCollection.reloadData()
                //   self.dataArray = successResponse.data
                print(objData.data)
                print( self.dataArray)
                //var groupId : Int = 0
                if let _ = self.userConversationData, let _ = self.userConversationData?.chatGroup, let _groupId = self.userConversationData?.chatGroup.id {
                  self.groupId = _groupId
                } else {
                    // return
                }
                
                if self.dataArray.count > 0 {
                    self.tblView.reloadData()
                    self.updateTableContentInset()
                    self.tblView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: false)
                }
                
                //                let Conversation = ChatModel.init(dictionary: dictionary as NSDictionary)
                //
                //
                //                self.dataArray =  (Conversation?.data?.messages!)!
                //
                //                self.tableView.delegate = self
                //                self.tableView.dataSource = self
                //
                //                self.tableView.reloadData()
                //                self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .top, animated: true)
                
                self.stopAnimating()
                
            }
            let conversationID = [
                "receiver_id":  self.recevierId,
                "chat_group_id":  self.groupId
                
            ]
            
            print(conversationID)
            
            self.socket.on("conversationsList") { (data, ack) in
                
                self.socket.emit("getConversation", with: [conversationID])
            }
            self.socket.on("messageReceived") { (data, ack) in
                self.socket.emit("getConversation", with: [conversationID])
                
                
            }
            self.socket.on("newMessage") { (data, ack) in
                //  self.getConversationMessages()
                self.socket.emit("getConversation", with: [conversationID])
            }
            
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
                
                
                self.socket.emit("getConversation", with: [conversationID])
                
            }
            
            
            self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
                //handle diconnect
            })
            
            self.socket.onAny({ (event) in
                //handle event
            })
            
            self.socket.connect()
            // CFRunLoopRun()
            
            // Do any additional setup after loading the view.
        }
    }
    
    func AcceptGroupCall(){
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
        
        print(self.groupId)
        var parameters : [String: Any]
        parameters = [
            "group_id" : self.groupId
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.AcceptChatGroupRequest
        
     
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                 // self.showAlrt(message: "Successfully")
                    print("success")
                    let conversationID = [
                        "receiver_id":  self.recevierId,
                        "chat_group_id":  self.groupId
                        
                    ]
                      self.socket.emit("getConversation", with: [conversationID])
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
    @IBAction func feelingsButtonAction(_ sender: Any) {
//        print("feelings view controller")
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeelingsViewController") as! FeelingsViewController
//        self.navigationController?.pushViewController(controller, animated: true)
        self.keyboardhide = false

        let conversationID = [
            "receiver_id":  0,
            "chat_group_id": "\(self.groupId)",
            "conversation_id": 0
            
            
            ] as [String : Any]
        self.socket.emit("typing-end", with: [conversationID])
   view.endEditing(true)
        if !isKeyboardOpened2 && !isKeyboardToggling2 {
            UIView.animate(withDuration: 0.10, animations: {
                
                self.bottomConstraint.constant  = 250
                self.tblView.reloadData()
                self.updateTableContentInset()
                self.tblView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
                
                //  self.tableView.scrollToBottom(animated: true)
            }, completion: { _ in
                // self.bottomConstraint.constant = 0
                self.isKeyboardOpened2 = true
            })
            
            self.viewMainContainer.isHidden = false
            print("feelings button pressed")
        }
        if isKeyboardOpened2 && !isKeyboardToggling2 {
            UIView.animate(withDuration: 0.10, animations: {
                self.viewMainContainer.isHidden = true
                self.keyboardhide = false

                 self.updateTableContentInset()
                self.bottomConstraint.constant = 0
                //                self.tableView.scrollToBottom(animated: true)
            }, completion: { _ in
                
                
                self.isKeyboardOpened2 = false
            })
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.hitConversation()
        if let _navTitle = navTitle {
            self.title = _navTitle
        } else  {
            //self.title = ""
            self.title = "Group Chat".localized
        }
        
        if let _ = userConversationData, let _ = userConversationData?.chatGroup, let _title = userConversationData?.chatGroup.title {
            lblTitle.text = navigTitle
        }
        
        
        
        print(groupDetail?.groupMembers)
        lblTitle.text = navigTitle
        //let ids = array.map { $0.id }
        //lblParticipants.text = participantsArray.joined(separator: ", ")
        print(participantsArray)
        
        imgProfilePhoto.roundWithClearColor()
        imgProfilePhoto.sd_setImage(with: URL(string: userImage), placeholderImage: UIImage(named: "userPlaceHolder"))
        
        //let abc = CZPic
        
    //    startObservingKeyboard()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        addBackButton()
        self.setupView()
       self.getConversationMessages()
        let objUser = UserHandler.sharedInstance.userData
        if let _ =  userConversationData?.chatGroup, let _ownerId = userConversationData?.chatGroup?.owner_id, let _objUserId = objUser?.id ,let _privacy = userConversationData?.chatGroup?.privacy {
            if (_privacy != "members_only") {
                if (_ownerId != _objUserId) {
                    msgContainerView.isHidden = true
                }
            }
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.participantsArrayName.removeAll()
        
    }
    
    deinit {
        self.participantsArrayName = []
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func addBackButton(backImage: UIImage = #imageLiteral(resourceName: "back")) {
//        hideBackButton()
//
//        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClciked))
//        navigationItem.leftBarButtonItem  = backButton
//    }
    
    override func onBackButtonClciked() {
//        navigationController?.popViewController(animated: true)
//        dismissVC(completion: nil)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MessengerViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    // MARK: - Custom
    func setupView(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.tblView.estimatedRowHeight = self.barHeight
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.contentInset.bottom = self.barHeight
        self.tblView.scrollIndicatorInsets.bottom = self.barHeight
        
        
       // self.viewContainer.backgroundColor = CommonMethods.getAppColor()
        
        let imageSend = #imageLiteral(resourceName: "iconSend")
        let renderdImage = imageSend.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.oltSend.setImage(renderdImage, for: .normal)
        self.oltSend.tintColor = CommonMethods.getAppColor() ///UIColor.white
        
        let imgAdd = #imageLiteral(resourceName: "attach")
        let attachRendImage = imgAdd.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.oltAddAttachment.setImage(attachRendImage, for: .normal)
        self.oltAddAttachment.tintColor = CommonMethods.getAppColor() //UIColor.white
        
        self.txtMessage.layer.cornerRadius = 10
        self.txtMessage.delegate = self
        
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showGroupParticipants() {
//
//        if let _detail = groupDetail {
//            let groupMembers = _detail.groupMembers.map({ (member : GroupMember) -> String in
//
//                participantsArrayName.append(member.full_name)
//                participantsArrayImageUrl.append(member.image)
//               // is_online.append(member.is_online)
//                return member.full_name
//            }).joined(separator: ", ")
//            print(groupMembers)
//            //lblParticipants.text = groupMembers
//        } else {
//            //lblParticipants.text = ""
//        }
//        self.chatHeadCollection.reloadData()
    }
    
    // MARK:- Image Picker Delegate Metods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("wrapper= ",images)
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("Done Bitton = ",images)
        if images.count > 0{
            saveFileToDocumentsDirectory(image: images[0])
            self.imageViewBottomAttachment.image = images[0]
            self.addMedia = true
            self.updateAttachmentConstraint()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func saveFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "MessagesPicture", extention: ".jpg") {
            self.pickedImnageUrl = savedUrl
            //            self.imgCounter = 1
            
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    func imagePickerControllerDidCancel(picker: ImagePickerController!)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save Video File
    func saveThumnailFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "CommentPicture", extention: ".jpg") {
            self.thumnailUrl = savedUrl
        }
    }
    
    // MARK: - Video Browser function
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegates
    
    func getEmoji(name:String) -> (NSMutableAttributedString) {
        
        let iconsSize = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        var sample = name
        
        var attributedString = NSMutableAttributedString(string: sample)
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: "\\:.+?\\:", options: .caseInsensitive)
            var matches = regex.matches(in: sample, options: []
                , range: NSMakeRange(0, (sample.count))) as Array<NSTextCheckingResult>
            print(matches)
            
            var cnt=0;
            
            for match in matches {
                var r = (sample as! NSString).substring(with: match.range)
                
                var image1Attachment = NSTextAttachment()
                r.removeFirst()
                r.removeLast()
                image1Attachment.image = UIImage(named:r+".png")
                image1Attachment.bounds = iconsSize
                
                let image1String = NSAttributedString(attachment: image1Attachment)
                print(match.range)
                
                var nCnt = 0;
                
                var newRange = NSMakeRange(match.range.location + cnt, match.range.length)
                
                attributedString.insert(image1String,at: newRange.location )
                
                print(attributedString.length)
                
                cnt += 1
                
            }
            
            var totalAdded = 0;
            var prevTokSize = 0;
            var sumOfPrevTokSizes = 0;
            
            for match in matches {
                
                attributedString.mutableString.replaceCharacters(in: NSMakeRange( match.range.location - sumOfPrevTokSizes + 1 + totalAdded , match.range.length), with: "")
                totalAdded += 1;
                
                prevTokSize = match.range.length
                sumOfPrevTokSizes += prevTokSize
            }
        } catch {
            print(error)
        }
        return (attributedString)
    }
    
    func updateTableContentInset() {
        let numRows = tableView(self.tblView, numberOfRowsInSection: 0)
        var contentInsetTop = self.tblView.bounds.size.height
        for i in 0..<dataArray.count {
            let rowRect = self.tblView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        self.tblView.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count > 0{
            
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = ""
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return dataArray.count
        }else{
            
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You have no new message".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objChat = dataArray[indexPath.row]
        let objUser = UserHandler.sharedInstance.userData
        
        if objChat.senderId == objUser?.id{
            
            if objChat.attachment == ""{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                
                let msg = getEmoji(name:objChat.message)
                cell.message.attributedText = msg
                cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
              //  cell.message.text = objChat.message
                cell.message.textColor = UIColor.white
                if(objChat.isRead){
                    cell.messageRead.image = UIImage(named: "done_all")
                }
                else{
                    cell.messageRead.image = UIImage(named: "done-1")
                    
                }
                let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objChat.createdAt.toDouble))
                let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                cell.time.text = date
                cell.messageBackground.backgroundColor = CommonMethods.getAppColor()
                return cell
                
            }
            else{
                if objChat.attachment_type == "video/quicktime"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverCellWithAttachment", for: indexPath) as! RecieverCellWithAttachment
                   // cell.message.text = objChat.message
                    let msg = getEmoji(name:objChat.message)
                    cell.message.attributedText = msg
                    cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
                    cell.message.textColor = UIColor.white
                    cell.videoPlayerButton.isHidden = false
                    if(objChat.isRead){
                        cell.messageRead.image = UIImage(named: "done_all")
                    }
                    else{
                        cell.messageRead.image = UIImage(named: "done-1")
                        
                    }
                    cell.messageBackground.backgroundColor = CommonMethods.getAppColor()
                    cell.messageAttachment.sd_setImage(with: URL(string: objChat.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.messageAttachment.sd_setShowActivityIndicatorView(true)
                    cell.messageAttachment.sd_setIndicatorStyle(.gray)
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objChat.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.lblDateTime.text = date
                    cell.messageAttachment.clipsToBounds = true
                    cell.delegate = self as tapOnMessageAttachementReciever
                    return cell
                }
                else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverCellWithAttachment", for: indexPath) as! RecieverCellWithAttachment
                
                    let msg = getEmoji(name:objChat.message)
                    cell.message.attributedText = msg
                    cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
                    //   cell.message.text = objChat.message
                    cell.message.textColor = UIColor.white
                    cell.videoPlayerButton.isHidden = true
                    if(objChat.isRead){
                        cell.messageRead.image = UIImage(named: "done_all")
                    }
                    else{
                        cell.messageRead.image = UIImage(named: "done-1")
                        
                    }
                    cell.messageBackground.backgroundColor = CommonMethods.getAppColor()
                    cell.messageAttachment.sd_setImage(with: URL(string: objChat.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.messageAttachment.sd_setShowActivityIndicatorView(true)
                    cell.messageAttachment.sd_setIndicatorStyle(.gray)
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objChat.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.lblDateTime.text = date
                    cell.messageAttachment.clipsToBounds = true
                    cell.delegate = self as tapOnMessageAttachementReciever
                    return cell
                }
                
            }
        }else{
            if objChat.attachment == ""{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                
                let msg = getEmoji(name:objChat.message)
                cell.message.attributedText = msg
                cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
                
                //cell.message.text = objChat.message
                cell.message.textColor = UIColor.gray
                let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objChat.createdAt.toDouble))
                let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                cell.time.text = date
                cell.messageBackground.backgroundColor = UIColor.groupTableViewBackground
                var imageUrl = ""
                print(objChat.sender.image)
                if objChat.sender.image != nil {
                    imageUrl = objChat.sender.image
                   var senderName = objChat.sender.fullName
                    print(senderName)
                }
                if let url = URL(string: imageUrl) {
                    
                    cell.profilePic.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.profilePic.sd_setShowActivityIndicatorView(true)
                    cell.profilePic.sd_setIndicatorStyle(.gray)
                    cell.profilePic.clipsToBounds = true
                    cell.senderName.text = objChat.sender.fullName
                    
                }else{
                    
                }
                return cell
                
            }
            else{
                if objChat.attachment_type == "video/quicktime"{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCellWithImage", for: indexPath) as! SenderCellWithImage
                  
                    let msg = getEmoji(name:objChat.message)
                    cell.message.attributedText = msg
                    cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
                    //  cell.message.text = objChat.message
                     cell.message.textColor = UIColor.gray
                    cell.videoPlayerButton.isHidden = false
                    cell.messageBackground.backgroundColor = UIColor.groupTableViewBackground
                    cell.messageAttachment.sd_setImage(with: URL(string: objChat.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.messageAttachment.sd_setShowActivityIndicatorView(true)
                    cell.messageAttachment.sd_setIndicatorStyle(.gray)
                    //                    cell.messageAttachment.contentMode = .scaleToFill
                    cell.messageAttachment.clipsToBounds = true
                    var imageUrl = ""
                    print(objChat.sender.image)
                    if objChat.sender.image != nil {
                        imageUrl = objChat.sender.image
                    }
                    if let url = URL(string: imageUrl) {
                        cell.profilePic.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                        cell.profilePic.sd_setShowActivityIndicatorView(true)
                        cell.profilePic.sd_setIndicatorStyle(.gray)
                        //                        cell.profilePic.contentMode = .scaleToFill
                        cell.profilePic.clipsToBounds = true
                    }else{
                        // cell.profilePic.image
                    }
                    cell.delegate = self as tapOnMessageAttachement
                    return cell
                }
                else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCellWithImage", for: indexPath) as! SenderCellWithImage
                    
                    let msg = getEmoji(name:objChat.message)
                    cell.message.attributedText = msg
                    cell.message.font = UIFont(name: "Lato-Semibold", size: 16)
                    
                  //  cell.message.text = objChat.message
                     cell.message.textColor = UIColor.gray
                    cell.videoPlayerButton.isHidden = true
                    cell.messageBackground.backgroundColor = UIColor.groupTableViewBackground
                    cell.messageAttachment.sd_setImage(with: URL(string: objChat.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.messageAttachment.sd_setShowActivityIndicatorView(true)
                    cell.messageAttachment.sd_setIndicatorStyle(.gray)
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objChat.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    
                    cell.lblDateTime.text = date
                    //                    cell.messageAttachment.contentMode = .scaleToFill
                    cell.messageAttachment.clipsToBounds = true
                    var imageUrl = ""
                    print(objChat.sender.image)
                    if objChat.sender.image != nil {
                        imageUrl = objChat.sender.image
                    }
                    if let url = URL(string: imageUrl) {
                        cell.profilePic.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                        cell.profilePic.sd_setShowActivityIndicatorView(true)
                        cell.profilePic.sd_setIndicatorStyle(.gray)
                        //                        cell.profilePic.contentMode = .scaleToFill
                        cell.profilePic.clipsToBounds = true
                    }else{
                        // cell.profilePic.image
                    }
                    cell.delegate = self as tapOnMessageAttachement
                    return cell
                }
                
            }
            
        }
        
    }
    // this method handles row deletion
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
           
            let alert = UIAlertController(title: "Delete Message", message: "Do you really want to delete this message?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                self.deleteConversationMessages (messageId:String(self.dataArray[indexPath.row].id), indexId: indexPath.row,indexPathid: indexPath)
                
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    // MARK: - UITextFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.bottomConstraint.constant = 0
        self.actionSend("Anything")
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtMessage.resignFirstResponder()
    }
    // MARK: - IBActions
    @IBAction func openGroupChatDetail(_ sender: UIButton) {
        let gcDetailControleller : GroupChatDetailViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "GroupChatDetailViewController") as! GroupChatDetailViewController
        gcDetailControleller.isHeroEnabled = true
        gcDetailControleller.isMotionEnabled = true
        gcDetailControleller.groupChatDetail = groupDetail
        gcDetailControleller.groupId = self.groupId
        gcDetailControleller.userConversationData = userConversationData
        //gcDetailControleller.onlineFriends = onlineFriends
        self.navigationController?.pushViewController(gcDetailControleller, animated: true)
    }
    @IBAction func actionSend(_ sender: Any) {
        var fileUrl2 : URL?
      
        if let url = pickedImnageUrl{
            
            if (txtMessage.text?.characters.count)! > 0 {
                self.postMessageWithAttachment(FilePath: url,Comments:txtMessage.text!)
            }
            else if url != nil{
                self.postMessageWithAttachment(FilePath: url,Comments:"")
            }
        }
        else if let videoUrl = videoURL{
            if (txtMessage.text?.characters.count)! > 0 {
                if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: videoUrl){
                    saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
                    fileUrl2 = thumnailUrl
                }
                self.postMessageWithVideoAttachment(FilePath: videoUrl,Comments:txtMessage.text!, thumbNailUrl: fileUrl2!)
            }
            else{
                if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: videoUrl){
                    saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
                    fileUrl2 = thumnailUrl
                }
                self.postMessageWithVideoAttachment(FilePath: videoUrl,Comments:"", thumbNailUrl: fileUrl2!)
            }
        }else if let _docURL = docURL{
            print("post documnet shoud be called")
            serverCallForUploadingDocuments ()
        }
        else{
            if (txtMessage.text?.characters.count)! > 0 {
                self.postChatMessage()
            }
        }
    //    self.updateTableContentInset()
//        var fileUrl2 : URL?
//        if let url = pickedImnageUrl{
//
//            if (txtMessage.text?.characters.count)! > 0 {
//                self.postMessageWithAttachment(FilePath: url,Comments:txtMessage.text!)
//            }
//            else{
//                self.postMessageWithAttachment(FilePath: url,Comments:"")
//            }
//        }
//        else if let videoUrl = videoURL{
//            if (txtMessage.text?.characters.count)! > 0 {
//                if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: videoUrl){
//                    saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
//                    fileUrl2 = thumnailUrl
//                }
//                self.postMessageWithVideoAttachment(FilePath: videoUrl,Comments:txtMessage.text!, thumbNailUrl: fileUrl2!)
//            }
//            else{
//                if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: videoUrl){
//                    saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
//                    fileUrl2 = thumnailUrl
//                }
//                self.postMessageWithVideoAttachment(FilePath: videoUrl,Comments:"", thumbNailUrl: fileUrl2!)
//            }
//        }
//        else{
//            if (txtMessage.text?.characters.count)! > 0 {
//                self.postChatMessage()
//            }
//        }
    }
    @IBAction func actionDiscardAttachment(_ sender: Any) {
        self.discardAttachmentChanges()
    }
    
    @IBAction func actionAddAttachment(_ sender: Any) {
        
        if self.addMedia == false{
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option".localized, message: nil, preferredStyle: .actionSheet)
            // create an action
            let selectPhotoes: UIAlertAction = UIAlertAction(title: "Select Photo".localized, style: .default) { action -> Void in
                let imagePickerController = ImagePickerController()
                imagePickerController.imageLimit = 1
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            let selectVideos: UIAlertAction = UIAlertAction(title: "Select Video".localized, style: .default) { action -> Void in
                self.openImgPicker()
            }
            
            let selectDocument: UIAlertAction = UIAlertAction(title: "Select Document".localized, style: .default) { action -> Void in
                print("select document called")
                let fileExplorer = FileExplorerViewController()
                fileExplorer.allowsMultipleSelection = false
                fileExplorer.fileFilters = [Filter.extension("txt"), Filter.extension("jpg")]
                fileExplorer.canChooseFiles=true
                fileExplorer.delegate = self
                self.present(fileExplorer, animated: true, completion: nil)
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
            
            // add actions
            actionSheetController.addAction(selectPhotoes)
            actionSheetController.addAction(selectVideos)
            actionSheetController.addAction(selectDocument)
            //             actionSheetController.addAction(recordVideos)
            actionSheetController.addAction(cancelAction)
            // present an actionSheet...
            present(actionSheetController, animated: true, completion: nil)
        }
        else{
            self.displayAlertMessage("Please cancel previous attachment or proceed first with previous attachment than add other media.")
        }
    }
    
    // MARK: - API Calls
    func getConversationMessages () {
    //    self.showLoader()
        //var groupId : Int = 0
        if let _ = userConversationData, let _ = userConversationData?.chatGroup, let _groupId = userConversationData?.chatGroup.id {
            groupId = _groupId
        } else {
           // return
        }
        
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            //"receiver_id" : "\(recevierId)"
            "chat_group_id" : "\(groupId)"
        ]
        print(dictionaryForm)
        ConversationsHandler.getConversationMessages(params: dictionaryForm as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.dataArray = successResponse.data
                self.groupDetail = successResponse.groupDetail
                self.showGroupParticipants()
                if self.dataArray.count > 0 {
                    self.tblView.reloadData()
                    self.updateTableContentInset()
                    self.tblView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: false)
                    self.stopAnimating()
                }else{
                    
                    self.stopAnimating()
                    
                }
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
        }
    }
    // MARK: - API Calls
    func deleteConversationMessages (messageId:String,indexId: Int, indexPathid: IndexPath) {
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            "message_id" : messageId
        ]
        print(dictionaryForm)
        
        ConversationsHandler.deleteConversationMessage(params: dictionaryForm as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.dataArray.remove(at: indexId)
                //                self.tblView.reloadData()
                self.tblView.deleteRows(at: [indexPathid], with: .left)
                //self.stopAnimating()
                
            }
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
        }
    }
    
    // MARK: - API Calls
    func postChatMessage (){
//        if !isKeyboardOpened2 && !isKeyboardToggling2 {
//            UIView.animate(withDuration: 0.10, animations: {
//
//                self.bottomConstraint.constant = 0
//                self.tblView.reloadData()
//                self.updateTableContentInset()
//                self.tblView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
//
//                //  self.tableView.scrollToBottom(animated: true)
//            }, completion: { _ in
//                // self.bottomConstraint.constant = 0
//                self.isKeyboardOpened2 = true
//            })
//
//            self.viewMainContainer.isHidden = true
//            print("feelings button pressed")
//        }
//        if isKeyboardOpened2 && !isKeyboardToggling2 {
//            UIView.animate(withDuration: 0.10, animations: {
//                self.viewMainContainer.isHidden = true
//
//                self.bottomConstraint.constant = 0
//                //                self.tableView.scrollToBottom(animated: true)
//            }, completion: { _ in
//
//
//                self.isKeyboardOpened2 = false
//            })
//
//        }
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        var feelingId = 0
        print("\(groupId)")
        if FeedsHandler.sharedInstance.objFeeling != nil{
            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        }
        
        dictionaryForm = [
            "feeling_id" : "\(feelingId)",
            "receiver_id" : "\(recevierId)",
            "message" : self.txtMessage.text!,
        ]
        
        
        //   chat_group_id:integer, fileName: string }
        
        let conversationID = [
          
            "chat_group_id": "\(groupId)",
            "message" : self.txtMessage.text!,
            "mime_type" : "text",
          
            
            ] as [String : Any]
        
        
        print(conversationID)
        // handle connected
        
        
        self.socket.emit("sendMessage", with: [conversationID])
        self.txtMessageValue = ""
        self.combination  = NSMutableAttributedString()
        self.txtMessage.text = ""
//        var dictionaryForm = Dictionary<String, String>()
//        dictionaryForm = [
//            //"receiver_id" : "\(recevierId)",
//            "message" : self.txtMessage.text!,
//            "chat_group_id" : "\(groupId)"
//        ]
//        self.txtMessage.text = ""
//        print(dictionaryForm)
//        ConversationsHandler.postConversationMessage(params: dictionaryForm as NSDictionary, success: { (successResponse) in
//            print(successResponse)
//            if successResponse.statusCode == 200 {
//                self.getConversationMessages()
//
//            }
//        }) { (errorResponse) in
//            print(errorResponse!)
//        }
        self.stopAnimating()
    }
    func postMessageWithAttachment (FilePath:URL, Comments:String){
       
        
        self.showLoader()
   
        var dictionaryForm = Dictionary<String, String>()
        
        var feelingId = 0
        
        if FeedsHandler.sharedInstance.objFeeling != nil{
            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        }
        
        
        //   let uurl = self.docURL
        let data = try? Data(contentsOf: FilePath)
        let imageFromUrl = UIImage(data: data!)
        
        let image = imageFromUrl
        //let imageData = UIImageJPEGRepresentation(image, 0.9)
        let imgData: NSData = NSData(data: image!.jpegData(compressionQuality: 1.0)!)
        
        
        let imageSize: Int = imgData.length
        print("size of image in B: %f ", Double(imageSize) )
        
        print(imgData as Data)
        
        
        
        let imageDataforSever = [
            "name":   "test.png",
            "size" : Double(imageSize)
            ] as [String : Any]
        
        
        print(imageDataforSever)
        self.socket.emit("startFileUpload", with: [imageDataforSever])
        self.socket.on("startUpload") { (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            
            print(dictionary)
            
        }
        
        let imageData = imgData as Data
        let uploadChunkSize = 102400
        //   let uploadChunkSize = 5
        let totalSize = imageData.count
        var offset = 0
        self.socket.on("moreData") { (data, ack) in
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let moreData = MoreData.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            
            
            let imageData = imgData as Data
            imageData.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                
                print(totalSize)
                // while offset < totalSize {
                
                let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                offset += chunkSize
                //  let b1 = String(uploadChunkSize, radix: 2)
                //    if let string = String(data: chunk.base64EncodedData(), encoding: .utf8) {
                //  if let str = String(data: chunk, encoding: String.Encoding.utf8) {
                
                let chunkSize2 = chunk.count
                
                
                
                let imageDataupload = [
                    "name":   "test.png",
                    "data" : chunk as NSData ,
                   "pointer" : moreData!.data!.pointer! ,

                    "chunkSize" : chunkSize2
                    ] as [String : Any]
                
                print(imageDataupload)
                
                self.socket.emit("uploadChunk", with: [imageDataupload])
                
                
                
                
                // }
                
                //  }
            }
        }
        
        
        self.socket.on("uploadCompleted") { (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let chat = CompleteChat.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            let conversationID = [
                "chat_group_id": self.groupId,
                "mime_type" : "image/jpeg",
                "message" : self.txtMessage.text!,
                "attachment" : chat!.data!.fileName!
                ] as [String : Any]
            //            let conversationID = [
            //                "conversation":  self.user.conversationID,
            //                "type" : "image/jpeg"
            //              //  "fileName" : chat?.data?.fileName!
            //                ] as [String : Any]
            print(conversationID)
            
            self.socket.emit("sendMessage", with: [conversationID])
            
            self.addMedia = false
            self.txtMessage.text = ""
            self.discardAttachmentChanges()
            
            self.stopAnimating()
            
            
        }
    }
    
    func postMessageWithVideoAttachment (FilePath:URL, Comments:String, thumbNailUrl:URL){
        
        
        
        
        
        self.showLoader()
        //        var dictionaryForm = Dictionary<String, String>()
        //
        //        var feelingId = 0
        //
        //        if FeedsHandler.sharedInstance.objFeeling != nil{
        //            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        //        }
        //
        
        //   let uurl = self.docURL
        let imgData = try? Data(contentsOf: FilePath)
        //   let imageFromUrl = UIImage(data: data!)
        
        //   let image = imageFromUrl
        //let imageData = UIImageJPEGRepresentation(image, 0.9)
        //    let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image)!, 0.25)!)
        
        
        let imageSize: Int = imgData!.count
        print("size of image in B: %f ", Double(imageSize) )
        
        
        
        
        
        let imageDataforSever = [
            "name":   "test.mp4",
            "size" : Double(imageSize)
            ] as [String : Any]
        
        
        print(imageDataforSever)
        self.socket.emit("startFileUpload", with: [imageDataforSever])
        
        let imageData = imgData
        let uploadChunkSize = 102400
        //   let uploadChunkSize = 5
        let totalSize = imageData?.count
        var offset = 0
        self.socket.on("moreData") { (data, ack) in
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let moreData = MoreData.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            
            
            let imageData = imgData
            imageData?.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                
                print(totalSize)
                print(offset)
                
                if (offset < totalSize!) {
                    let chunkSize = offset + uploadChunkSize > totalSize! ? totalSize! - offset : uploadChunkSize
                    let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                    offset += chunkSize
                    //  let b1 = String(uploadChunkSize, radix: 2)
                    // if let string = String(data: chunk.base64EncodedData(), encoding: .utf8) {
                    //  if let str = String(data: chunk, encoding: String.Encoding.utf8) {
                    
                    let chunkSize2 = chunk.count
                    print(chunkSize2)
                    
                    
                    let imageDataupload = [
                        "name":   "test.mp4",
                        "data" : chunk as NSData ,
                      "pointer" : moreData!.data!.pointer! ,

                        "chunkSize" : chunkSize2
                        ] as [String : Any]
                    
                    print(imageDataupload)
                    
                    self.socket.emit("uploadChunk", with: [imageDataupload])
                    
                    //  }
                    
                }
                
                
            }
        }
        
        
        self.socket.on("uploadCompleted") { (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let chat = CompleteChat.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            let conversationID = [
                "chat_group_id": "\(self.groupId)",
                "mime_type" : "video/quicktime",
                "message" : self.txtMessage.text!,
                "attachment" : chat!.data!.fileName!
                ] as [String : Any]
            //            let conversationID = [
            //                "conversation":  self.user.conversationID,
            //                "type" : "image/jpeg"
            //              //  "fileName" : chat?.data?.fileName!
            //                ] as [String : Any]
            print(conversationID)
            
            self.socket.emit("sendMessage", with: [conversationID])
            self.txtMessageValue = ""
            self.combination  = NSMutableAttributedString()
            self.addMedia = false
            self.txtMessage.text = ""
            self.discardAttachmentChanges()
            self.stopAnimating()
        }
        
//        self.showLoader()
//        var dictionaryForm = Dictionary<String, String>()
//
//        var feelingId = 0
//
//        if FeedsHandler.sharedInstance.objFeeling != nil{
//            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
//        }
//        //"feeling_id" : "\(feelingId)",
//
//
//        dictionaryForm = [
//            //"receiver_id" : "\(recevierId)",
//            "feeling_id" : "\(feelingId)",
//            "message" : Comments,
//            "chat_group_id" : "\(groupId)"
//            //            "" : self.pickedImnageUrl
//        ]
//        print(dictionaryForm)
//        ConversationsHandler.postCoversationMessageWithVideoAttachment(fileUrl: FilePath,fileUrl2: thumbNailUrl, params: dictionaryForm as NSDictionary, success: { (successResponse) in
//            //        ConversationsHandler.postCoversationMessageWithAttachment(fileUrl: FilePath, params: dictionaryForm as NSDictionary, success: { (successResponse) in
//            print(successResponse)
//            if successResponse.statusCode == 200 {
//                self.addMedia = false
//                self.getConversationMessages()
//                self.discardAttachmentChanges()
//                //self.stopAnimating()
//            }
//        }) { (errorResponse) in
//            print(errorResponse!)
//            //self.stopAnimating()
//        }
        
    }
    
    func serverCallForUploadingDocuments (){
        
      
        self.showLoader()
        //        var dictionaryForm = Dictionary<String, String>()
        //
        //        var feelingId = 0
        //
        //        if FeedsHandler.sharedInstance.objFeeling != nil{
        //            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        //        }
        //
        
        //   let uurl = self.docURL
        let imgData = try? Data(contentsOf: self.docURL!)
        //   let imageFromUrl = UIImage(data: data!)
        
        //   let image = imageFromUrl
        //let imageData = UIImageJPEGRepresentation(image, 0.9)
        //    let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image)!, 0.25)!)
        
        
        let imageSize: Int = imgData!.count
        print("size of image in B: %f ", Double(imageSize) )
        
        
        
        
        
        let imageDataforSever = [
            "name":   "test.jpg",
            "size" : Double(imageSize)
            ] as [String : Any]
        
        
        print(imageDataforSever)
        self.socket.emit("startFileUpload", with: [imageDataforSever])
        
        let imageData = imgData
        let uploadChunkSize = 102400
        //   let uploadChunkSize = 5
        let totalSize = imageData?.count
        var offset = 0
        self.socket.on("moreData") { (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let moreData = MoreData.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            
            
            let imageData = imgData
            imageData?.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                
                print(totalSize)
                print(offset)
                
                if (offset < totalSize!) {
                    let chunkSize = offset + uploadChunkSize > totalSize! ? totalSize! - offset : uploadChunkSize
                    let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                    offset += chunkSize
                    //  let b1 = String(uploadChunkSize, radix: 2)
                    // if let string = String(data: chunk.base64EncodedData(), encoding: .utf8) {
                    //  if let str = String(data: chunk, encoding: String.Encoding.utf8) {
                    
                    let chunkSize2 = chunk.count
                    print(chunkSize2)
                    
                    
                    let imageDataupload = [
                        "name":   "test.jpg",
                        "data" : chunk as NSData ,
                       "pointer" : moreData!.data!.pointer! ,

                        "chunkSize" : chunkSize2
                        ] as [String : Any]
                    
                    print(imageDataupload)
                    
                    self.socket.emit("uploadChunk", with: [imageDataupload])
                    
                    //  }
                    
                }
                
                
            }
        }
        
        
        self.socket.on("uploadCompleted") { (data, ack) in
            
            
            
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            let chat = CompleteChat.init(dictionary: dictionary as NSDictionary)
            print(dictionary)
            let conversationID = [
                "receiver_id": 0,
                "chat_group_id": "\(self.groupId)",
                "mime_type" : "txt/jpg",
                "conversation_id" : 0,
                "message" : self.txtMessage.text!,
                "attachment" : chat!.data!.fileName!
                ] as [String : Any]
            //            let conversationID = [
            //                "conversation":  self.user.conversationID,
            //                "type" : "image/jpeg"
            //              //  "fileName" : chat?.data?.fileName!
            //                ] as [String : Any]
            print(conversationID)
            
            self.socket.emit("sendMessage", with: [conversationID])
            self.combination  = NSMutableAttributedString()
            self.addMedia = false
            self.txtMessage.text = ""
            self.txtMessageValue = ""
            self.discardAttachmentChanges()
            self.stopAnimating()
        }
//        self.showLoader()
//
//        var headers: HTTPHeaders
//        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
//            headers = [
//                "Accept": "application/json",
//                "Authorization" : userToken//"Bearer \(userToken)"
//            ]
//        } else{
//            headers = [
//                "Accept": "application/json",
//            ]
//        }
//
//        let objUser = UserHandler.sharedInstance.userData
//        var userID: Int = (objUser?.id)!
//        print("user id ",userID)
//
//        var feelingId = 0
//
//        if FeedsHandler.sharedInstance.objFeeling != nil{
//            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
//        }
//        //"feeling_id" : "\(feelingId)",
//
//
//        var dictionaryForm = Dictionary<String, String>()
//        dictionaryForm = [
//            //"receiver_id" : "\(recevierId)",
//            "feeling_id" : "\(feelingId)",
//            "message" : self.txtMessage.text!,
//            "chat_group_id" : "\(groupId)"
//        ]
//
//        var parameters : [String: Any]
//        parameters = [
//            "feeling_id" : "\(feelingId)",
//            "receiver_id" : recevierId,
//        ]
//
//        let url = ApiCalls.baseUrlBuild + ApiCalls.postConversationMessage
////        postConversationMessage
//
//        print("save  documnet url",url)
//
//        Alamofire.upload(multipartFormData:  { multipartFormData in
//
//            let uurl = self.docURL
//            let data = try? Data(contentsOf: uurl!)
//            let imageFromUrl = UIImage(data: data!)
//
//
//            if let image = imageFromUrl    {
//                let imageData = UIImageJPEGRepresentation(image, 0.9)
//                let imageName = "attachment"
//                let fileName = imageName + ".jpg"
//                let imageSize = Double(imageData!.count)
//
//                print("\(imageName) size in KB = \(imageSize/1024.0)")
//
//                multipartFormData.append(data!, withName: imageName, fileName: fileName, mimeType: "any")
//            }
//
//            for (key, value) in dictionaryForm  {
//                multipartFormData.append(String(describing: value).data(using:.utf8, allowLossyConversion: false)!, withName: key)
//            }
//
//        }, usingThreshold: UInt64(), to: url, method: .post, headers: headers, encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print(response)
//                    self.discardAttachmentChanges()
//                    self.showAlrt(message: "Successfully Uploaded")
//                    self.stopAnimating()
//                    self.dismiss(animated: true, completion: nil)
//
//                }
//
//            case .failure(let encodingError):
//                print(encodingError)
//                print("RESPONSE ERROR: \(encodingError)")
//                self.showAlrt(message: "RESPONSE ERROR: \(encodingError)")
//                self.stopAnimating()
//
//            }
//        })
//
    }
    
    func updateAttachmentConstraint(){
        self.imageViewBottomAttachment.isHidden = false
        self.btmDiscardAttachment.isHidden = false
          self.viewImageAtt.isHidden = false
       // self.attachmentImageConstOne.constant = 40
     //   self.attachmentImageConstTwo.constant = 5
        self.imageViewBottomAttachment.layer.borderWidth = 1
    }
    func discardAttachmentChanges(){
        self.pickedImnageUrl = nil
        self.videoURL = nil
        self.imageViewBottomAttachment.isHidden = true
        self.btmDiscardAttachment.isHidden = true
          self.viewImageAtt.isHidden = true
    //    self.attachmentImageConstOne.constant = 5
      //  self.attachmentImageConstTwo.constant = 5
        self.imageViewBottomAttachment.image = nil
        self.txtMessage.text = ""
        self.addMedia = false
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
}
////MARK:- Keyboard Extension
//extension GroupChatViewController: KeyboardObserver {
//    override func keyboardWillShowWithFrame(_ frame: CGRect) {
//        if !isKeyboardOpened && !isKeyboardToggling {
//            UIView.animate(withDuration: 0.10, animations: {
//                var keyboardHeight = frame.height
//                if #available(iOS 11.0, *) {
//                    let bottomInset = self.view.safeAreaInsets.bottom
//                    keyboardHeight -= bottomInset
//                }
//
//                self.bottomConstraint.constant  = keyboardHeight
//                self.tblView.reloadData()
//                self.updateTableContentInset()
//                if( self.dataArray.count == 0) {
//
//                }
//                else{
//                    self.tblView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: false)
//
//                }
//                self.viewMainContainer.isHidden = true
//                //  self.tableView.scrollToBottom(animated: true)
//            }, completion: { _ in
//                let conversationID = [
//                    "receiver_id":  0,
//                    "chat_group_id": "\(self.groupId)",
//                    "conversation_id": 0
//
//
//                    ] as [String : Any]
//                self.socket.emit("typing-end", with: [conversationID])
//                if let _navTitle = self.navTitle {
//                    //  self.navigationItem.titleView = self.setTitle(title: _navTitle, subtitle: ".")
//
//                    self.title = _navTitle
//                } else  {
//                    self.title = "Messages"
//                }
//                self.viewMainContainer.isHidden = true
//                self.isKeyboardOpened2 = false
//                self.isKeyboardOpened = true
//            })
//        }
//    }
//    override func keyboardWillHideWithFrame(_ frame: CGRect) {
//        if isKeyboardOpened && !isKeyboardToggling {
//            UIView.animate(withDuration: 0.10, animations: {
//                self.viewMainContainer.isHidden = true
//                let conversationID = [
//                    "receiver_id":  0,
//                    "chat_group_id": "\(self.groupId)",
//                    "conversation_id": 0
//
//
//                    ] as [String : Any]
//                self.socket.emit("typing-end", with: [conversationID])
//                self.bottomConstraint.constant = 0
//                //                self.tableView.scrollToBottom(animated: true)
//            }, completion: { _ in
//
//                self.isKeyboardOpened2 = false
//                self.isKeyboardOpened = false
//            })
//        }
//    }
//}

extension GroupChatViewController: ViewStateProtocol {
    var errorMessage: String? {
        get {
            return "You have no new message".localized
        }
        set {
            self.errorMessage = "You have no new message".localized
        }
    }
    
    
    @objc func handleTap(_ sender: UIView) {
        
        addView(withState: .loading)
        
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}

// MARK:- Sender Cell Delegate Extension
extension GroupChatViewController: tapOnMessageAttachement {
    
    internal func sendCellIndex(cell: SenderCellWithImage)
    {
        let item = tblView.indexPath(for: cell)
        
        if dataArray[item!.item].attachment_type == "video/quicktime"{
            
            let videoAttachment = dataArray[item!.item].attachment
            let videoURL = URL(string: videoAttachment!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else if dataArray[item!.item].attachment_type == "image/jpeg"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.imageString = dataArray[item!.item].attachment
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
// MARK:- Receiver Cell Delegate Extension
extension GroupChatViewController: tapOnMessageAttachementReciever {
    
    internal func ReceiverSendCellIndex(cell: RecieverCellWithAttachment)
    {
        let item = tblView.indexPath(for: cell)
        
        if dataArray[item!.item].attachment_type == "video/quicktime"{
            
            let videoAttachment = dataArray[item!.item].attachment
            let videoURL = URL(string: videoAttachment!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else if dataArray[item!.item].attachment_type == "image/jpeg"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.imageString = dataArray[item!.item].attachment
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension GroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        print("videoURL:\(String(describing: videoURL))")
        self.imageViewBottomAttachment.image = UIImage(named: "video")
        self.updateAttachmentConstraint()
        self.addMedia = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupChatViewController: FileExplorerViewControllerDelegate {
    func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        var message = ""
        for url in urls {
            docURL =  url
            message += "\(url.lastPathComponent)"
            if url != urls.last {
                message += "\n"
            }
        }
        
        print("choosen file url is.. ", docURL)
        self.imageViewBottomAttachment.image = UIImage(named: "photo")
        self.updateAttachmentConstraint()
        self.addMedia = true
        
    }
    
    func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        
    }
}

extension GroupChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 80)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


extension GroupChatViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.EmojiCollection {
            return iconsArray.count
        }
        else {
            
            return (participantsArrayName.count)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.EmojiCollection {
            let myCell = EmojiCollection.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            let iconsObject = self.iconsArray[indexPath.row]
            if let imgUrl = URL(string: iconsObject.image!) {
                print(imgUrl)
                myCell.EmojiImage.sd_setImage(with: imgUrl, placeholderImage:UIImage(named: "sunny"))
            }
            
            
            return myCell
        }
        else {
            
            let myCell = chatHeadCollection.dequeueReusableCell(withReuseIdentifier: "chatHead", for: indexPath) as! groupChatCollectionViewCell
                myCell.participantName.text = participantsArrayName[indexPath.row]
          print(is_online[indexPath.row])
            
            if is_online[indexPath.row] == 0 {
                myCell.onlineImage.image = nil
            }
            else {
                myCell.onlineImage.image = #imageLiteral(resourceName: "onlineStatus")
            }
            if let imgUrl = URL(string: "http://myliife.com/" + participantsArrayImageUrl[indexPath.row]) {
                print(imgUrl)
                myCell.participantImage.sd_setImage(with: imgUrl, placeholderImage:UIImage(named: "placeHolderGenral"))
            }
                
            return myCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.EmojiCollection {
            
        
        
        let iconsObject = self.iconsArray[indexPath.row]
        userEmoji = userEmoji + iconsObject.name!
        
        
        var emojiName = ""
        var emojiNametxt = ""
        
        var attributedString = NSMutableAttributedString(string: "")
        let iconsSize = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        
        for i in 0 ..<  self.user.EmojiArray.count {
            var icons = [Icons]()
            icons = self.user.EmojiArray[i].icons!
            
            for k in 0 ..<  icons.count {
                
                
                if(icons[k].name! == iconsObject.name!){
                    
                    emojiName = iconsObject.name!
                    emojiNametxt = iconsObject.name!
                    
                    emojiName.removeFirst()
                    emojiName.removeLast()
                    
                    print(emojiName)
                    var image1Attachment = NSTextAttachment()
                    image1Attachment.image = UIImage(named:emojiName+".png")
                    image1Attachment.bounds = iconsSize
                    
                    let image1String = NSAttributedString(attachment: image1Attachment)
                    
                    attributedString.insert(image1String,at: 0 )
                    
                    
                }
                else{
                    
                }
            }
            // self.enArr.append(tit)
        }
        if(emojiName == ""){
            // cell.message.text = objChat.message
        }
        else
        {
            //  cell.message.text = ""
            // cell.message.backgroundColor = UIColor(patternImage: UIImage(named: "done-1")!)
        }
        
        //   attributedString2 = [attributedString2.appendAttributedStringattributedString];
        
        txtMessageValue = emojiNametxt
        
        
        
        
        
        //     let combination = NSMutableAttributedString()
        
        combination.append(attributedString)
        
        print(combination)
        
        
        //     self.txtMessage.attributedText =  combination
    self.txtMessage.text = self.txtMessage.text + txtMessageValue
        
        //   txtMessageValue =  self.txtMessage.text
        
        var test = self.txtMessage.text
        
        print( self.txtMessage.attributedText)
        
        
        //  let msg = getEmoji(name : test!)
        
        //  self.txtMessage.attributedText = msg
        
        
        //        let selectedIndex = indexPath.row
        //        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        //        let categoryDatt = cattArr[indexPath.row]
        //        self.user.isFrom = ""
        //        if lang == "ar" {
        //            viewPush.controllerTitle = categoryDatt.title.arabicCategories
        //        }else if lang == "en" {
        //            viewPush.controllerTitle = categoryDatt.title.englishCategories
        //        }
        //        viewPush.selectedCellId = categoryDatt.categoryId
        //        self.navigationController?.pushViewController(viewPush, animated: true)
    }
    }
    
}

