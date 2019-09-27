//
//  MessengerViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 16/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView
import SocketIO

extension SegueIdentifiable {
    static var messengerViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: MessengerViewController.className)
    }
}

class MessengerViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var friendsTitleLbl: UILabel!
        
    
    @IBOutlet var conversationLbl: UILabel!
    var  arrayMessageData  = [UserConversationData]()
    var  arrayUserData  = [UserConversationUser]()
    var arrayOnlineFriends = [UserGetAllFriendsData]()
     var isFromOtherUser = true
      var otherUserId = 0
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var messages = ModelGenerator.generateMessengerModel()
    var socket:SocketIOClient!
     var manager:SocketManager!
  @IBOutlet weak var lblnoFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTitleLbl.text = "Friends".localized
        addBackButton()
        self.title = "Conversations".localized
        conversationLbl.text = "Conversations".localized
        lblnoFound.text = "No friend found".localized
        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
//        let headerLabel = UILabel(frame: CGRect(x: 8, y: 5, width:
//            headerView.frame.size.width, height:  headerView.frame.size.height))
//        headerLabel.textColor = UIColor.black
//        headerLabel.font = UIFont(name: AppFont.semiBold, size: 18.0)
//        headerLabel.text = "Conversations"
////        headerLabel.attributedText = "Conversations".semiBold(of: 18.0)
//        headerView.addSubview(headerLabel)
//        tableView.tableHeaderView = headerView
        self.lblnoFound.isHidden = true
       // getOnlineFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   getAllConversation()
        getAllFriends()
              self.showLoader()
        hitConversation()
        addRightBarItem()
    }
    
    func hitConversation(){
        
      //   self.showLoader()
        
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
            
            
//            self.socket  = SocketIOClient(
//                socketURL: NSURL(string: ApiCalls.baseUrlSocket)! as URL as URL,
//                config: specs)
            
            self.manager = SocketManager(socketURL: URL(string:  ApiCalls.baseUrlSocket)! , config: specs)
            
            self.socket = manager.defaultSocket
            
            self.socket.on("connected") { (data, ack) in
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
                
            }
            
            self.socket.on("userLoggedin") { (data, ack) in
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                let chat = Typing.init(dictionary: dictionary as NSDictionary)
                print(dictionary)
                  self.getAllFriendsOnline()
                
            }
            self.socket.on("userLoggedout") { (data, ack) in
                
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                let chat = Typing.init(dictionary: dictionary as NSDictionary)
                print(dictionary)
                  self.getAllFriendsOnline()
                
                
            }
            
                        self.socket.on("conversationsList") { (data, ack) in
                            let modified =  (data[0] as AnyObject)
            
                              print(modified)
                            let dictionary = modified as! [String: AnyObject]
            
                            print(dictionary)
                            
                            
                           
                            let objData = UserConversationModel(fromDictionary: dictionary)
                          


                            


                            

                            self.arrayMessageData = (objData.data)!
                            if self.arrayMessageData.count > 0 {
                                self.tableView.reloadData()
                                //                    self.refreshControl.endRefreshing()
                            }else{
                                
                                self.tableView.reloadData()
                                //                    self.refreshControl.endRefreshing()
                            }
                            self.stopAnimating()
            
            
                           
            
                        }
            
//            self.socket.on("conversationsList") { (data, ack) in
//                let modified =  (data[0] as AnyObject)
//
//                let dictionary = modified as! [String: AnyObject]
//
//                print(dictionary)
//                //  self.socket.emit("conversationsList")
//
//            }
            //
            self.socket.on("lastMessage") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                self.socket.emit("conversationsList")
                
            }
            //
            self.socket.on("createEditChatGroup") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                self.socket.emit("conversationsList")
                
            }
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
                self.socket.emit("conversationsList")
                
                
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Add Navigation Items
    func addRightBarItem() {
        let messageButton = UIButton(type: .custom)
        messageButton.addTarget(self, action: #selector(segueToMessagesController), for: .touchUpInside)
        messageButton.setImage(#imageLiteral(resourceName: "createGroup"), for: .normal)
        messageButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let messageItem = UIBarButtonItem(customView: messageButton)
        
        self.navigationItem.setRightBarButtonItems([messageItem], animated: true)
    }
    
    @objc func segueToMessagesController() {
        let createGroupControleller : CreateGroupViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
        createGroupControleller.isHeroEnabled = true
        createGroupControleller.isMotionEnabled = true
        createGroupControleller.arrayCreateGroupOnlineFriends = arrayOnlineFriends
        self.navigationController?.pushViewController(createGroupControleller, animated: true)
    }

    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    func getAllFriendsOnline()
    {
    //    self.showLoader()
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print(userID)
        
        
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
                //   self.arrayDataFriends = successResponse.data
                self.stopAnimating()
                self.arrayOnlineFriends = successResponse.data
                if self.arrayOnlineFriends.count > 0{
                    self.collectionView.reloadData()
                }
                else{
                    self.lblnoFound.isHidden = false
                    
                }
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
    
    func getAllFriends()
    {
        self.showLoader()
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print(userID)
        
     
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
             //   self.arrayDataFriends = successResponse.data
                self.stopAnimating()
                self.arrayOnlineFriends = successResponse.data
                if self.arrayOnlineFriends.count > 0{
                    self.collectionView.reloadData()
                }
                else{
                    self.lblnoFound.isHidden = false
                    
                }
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
    
    //MARK: - GET ONLINE FRIENDS
//    func getOnlineFriends() {
//        self.showLoader()
//        FriendsHandler.getOnlineFriends(success: { (success) in
//            if (success.statusCode == 200){
//                self.stopAnimating()
//                self.arrayOnlineFriends = success.data!
//                if self.arrayOnlineFriends.count > 0{
//                    self.collectionView.reloadData()
//                }
//                else{
//                    self.lblnoFound.isHidden = false
//
//                }
//            }
//            else{
//                self.stopAnimating()
//                self.displayAlertMessage(success.message)
//
//
//            }
//        }){ (error) in
//            print("error = ",error!)
//            self.stopAnimating()
//            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.")
//        }
//    }
//
    
    // MARK: - API Calls
    func getAllConversation(){
        self.showLoader()
        ConversationsHandler.getConversation(success: { (successResponse) in
            if (successResponse.statusCode == 200)
            {
                self.arrayMessageData = successResponse.data
                if self.arrayMessageData.count > 0 {
                    self.tableView.reloadData()
                    //                    self.refreshControl.endRefreshing()
                }else{
                   
                    self.tableView.reloadData()
                    //                    self.refreshControl.endRefreshing()
                }
                self.stopAnimating()
            }
            else
            {
                self.displayAlertMessage(successResponse.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    // MARK: - Delete Conversation
    func deleteConversation (conversationId:String,indexId: Int, indexPathid: IndexPath) {
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            "conversation_id" : conversationId
        ]
        print(dictionaryForm)
        
        ConversationsHandler.deleteConversation(params: dictionaryForm as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.arrayMessageData.remove(at: indexId)
                self.tableView.deleteRows(at: [indexPathid], with: .fade)
                self.tableView.reloadData()
                self.stopAnimating()
            }else{
                let alert = UIAlertController(title: "Error", message: successResponse.message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.stopAnimating()
          
                
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
        }
    }
}


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


// MARK:- Message Extensions
extension MessengerViewController: ViewStateProtocol {
    var errorMessage: String? {
        get {
            return "You have no new conversation".localized
        }
        set {
            self.errorMessage = "You have no new conversation".localized
        }
    }
    
    
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        addView(withState: .error)
        addView(withState: .empty)
        removeAllViews()
    }
}

// MARK: TableView
extension MessengerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayMessageData.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You have no new conversation".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessageData.count
        //return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessengerTableViewCell.className, for: indexPath) as! MessengerTableViewCell
        
        let objMessage = arrayMessageData[indexPath.row]
        
        
        if (objMessage.chatGroup.id == nil) {
            cell.labelName.text = objMessage.user.fullName
            
            let msg = getEmoji(name:objMessage.message)
            cell.labelMsg.attributedText = msg
            
            
          //  cell.labelMsg.text = objMessage.message
//            cell.labelTime.text = self.convertDate(dateString: objMessage.user.createdAt.toDouble)//message.user.createdAt.toString
//            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objMessage.user.createdAt.toDouble))
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objMessage.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.imageViewProfilePicture.sd_setImage(with: URL(string: objMessage.user.image), placeholderImage: UIImage(named: "placeHolderGenral"))
        }
        else
        {
            cell.labelName.text = objMessage.chatGroup.title
            let msg = getEmoji(name:objMessage.message)
            cell.labelMsg.attributedText = msg
            
         //   cell.labelMsg.text = objMessage.message
//            cell.labelTime.text = self.convertDate(dateString: objMessage.chatGroup.created_at.toDouble)//message.user.createdAt.toString
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objMessage.createdAt.toDouble))
            let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
            cell.labelTime.text = date
            cell.imageViewProfilePicture.sd_setImage(with: URL(string: objMessage.chatGroup.imageUrl), placeholderImage: UIImage(named: "placeHolderGenral"))
        }
        cell.selectionStyle = .none
        
        if (objMessage.isRead == true)
        {
            cell.backgroundColor = UIColor.white
        }
        else
        {
            let overAllBackGroundColor = UIColor(red:239/255, green:239/255, blue:244/255, alpha: 1)
            cell.backgroundColor = overAllBackGroundColor
        }
        
//        let message = messages[indexPath.row]
//        cell.labelName.text = message.name
//        cell.labelMsg.text = message.message
//        cell.labelTime.text = message.time.toString()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objMessage = arrayMessageData[indexPath.row]

        print(objMessage)
        
        if (objMessage.chatGroup.id == nil) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            controller.recevierId = objMessage.user.id
            controller.navTitle = objMessage.user.fullName
            controller.userImage = objMessage.user.image
            controller.conversationId = objMessage.conversationId
         

            
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
            controller.groupId = objMessage.chatGroup.id
            controller.navigTitle = objMessage.chatGroup.title
            controller.userImage = objMessage.chatGroup.imageUrl
            controller.userConversationData = objMessage
            controller.onlineFriends = arrayOnlineFriends
              controller.conversationId = objMessage.conversationId
            //controller.groupChatDetail = objMessage
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    // this method handles row deletion
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
           
            
            
            let alert = UIAlertController(title: "Delete Conversation", message: "Do you really want to delete this conversation?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                self.deleteConversation(conversationId:String(self.arrayMessageData[indexPath.row].conversationId!), indexId: indexPath.row,indexPathid: indexPath)
                
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
}

// MARK: CollectionView
extension MessengerViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOnlineFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessengerCollectionViewCell.className, for: indexPath) as! MessengerCollectionViewCell
        let dictionaryArray = arrayOnlineFriends[indexPath.item]
        cell.labelFullname.text = dictionaryArray.fullName
        cell.imageViewProfilePicture.sd_setImage(with: URL(string: dictionaryArray.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
        if(dictionaryArray.is_online == 1){
            cell.onlineImage.isHidden = false

        }
        else{
        cell.onlineImage.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objOnlineFriend = arrayOnlineFriends[indexPath.item]
        print(objOnlineFriend)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        
        controller.recevierId = objOnlineFriend.id
        controller.navTitle = objOnlineFriend.fullName
        controller.userImage = objOnlineFriend.profilePicturePath
     controller.onlineFriend = 1
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

class MessengerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelFullname: UILabel!
     @IBOutlet weak var onlineImage: UIImageView!
    @IBOutlet var imageViewProfilePicture: UIImageView! {
        didSet{
            imageViewProfilePicture.roundWithClearColor()
        }
    }
    
}

class MessengerTableViewCell: UITableViewCell {
    
    @IBOutlet var imageViewProfilePicture: UIImageView! {
        didSet {
            imageViewProfilePicture.roundWithClearColor()
        }
    }
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelMsg: UILabel!
    @IBOutlet var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

struct MessengerModel {
    var name: String
    var message: String
    var time: Date
}
