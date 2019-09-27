import UIKit
import Material
import SocketIO

protocol LeftViewControllerDelegate {
    func onMyProfileClicked()
    func onActivityLogClciked()
    func onAppSettingClicked()
    func onSentRequestClicked()

    func onHelplClicked()
    func onAboutClicked()
    func onLogoutClicked()
    func onMySchedulesClicked()
    func onSavedStoriesClicked()
    
    func onBlockUserListClicked()
}

class LeftViewController: UIViewController {
    var delegate: LeftViewControllerDelegate?
    let prefs = UserDefaults.standard
    
    
    
    struct MenuModel {
        var title: String
        var image: String
    }
    var MenuList = [MenuModel]()
    
    
    
    
    
    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
 
    
    
    var socket:SocketIOClient!
    var manager:SocketManager!

    open override func viewDidLoad() {
        super.viewDidLoad()
        
         self.MenuList.append(MenuModel(title: "My Profile".localized, image: "profile"))
         self.MenuList.append(MenuModel(title: "Contacts".localized, image: "iconContacts"))
         self.MenuList.append(MenuModel(title: "My Schedules".localized, image: "mySchedule"))
         self.MenuList.append(MenuModel(title: "Saved Stories".localized, image: "saved_stories"))
         self.MenuList.append(MenuModel(title: "Sent Requests".localized, image: "profile"))
         self.MenuList.append(MenuModel(title: "Blocked Contacts".localized, image: "profile"))
         self.MenuList.append(MenuModel(title: "App Settings".localized, image: "setting"))
        // self.MenuList.append(MenuModel(title: "About", image: "about"))
         self.MenuList.append(MenuModel(title: "Help".localized, image: "help"))
         self.MenuList.append(MenuModel(title: "Log Out".localized, image: "logout"))
       
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
         self.populateData()
        
        
    
    }
    
    // MARK: - PopulateData
    func populateData (){
        let objUser = UserHandler.sharedInstance.userData
        let words = objUser?.fullName.components(separatedBy: " ")
        print(words![0])
        let firstName = words![0]
        
        lblUserName.text = objUser?.fullName    //firstName
        lblUserName.font = CommonMethods.getFontOfSize(size: 16)
        lblUserEmail.text = objUser?.email
        if let coverUrl = objUser?.cover{
            imgCover.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: ""))
            imgCover.sd_setShowActivityIndicatorView(true)
            imgCover.sd_setIndicatorStyle(.gray)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }else{
            imgCover.image = #imageLiteral(resourceName: "placeHolderGenral")
        }
        if let profileImageUrl = objUser?.image{
            imgUser.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: ""))
            imgUser.sd_setShowActivityIndicatorView(true)
            imgUser.sd_setIndicatorStyle(.gray)
            imgUser.contentMode = .scaleAspectFill
            imgUser.clipsToBounds = true
        }else{
            imgUser.image = #imageLiteral(resourceName: "user")
        }
        
    }
 
    


    func onAboutClicked(_ sender: UIButton) {
        delegate?.onAboutClicked()
    }

    @IBAction func onLogoutClicked(_ sender: UIButton) {
        
    }
    
    func hitConversation(){
        
        
        
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forcePolling(true),
                .forceWebsockets(false),
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
          
            
            self.socket.on("userLoggedout") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                //  self.socket.emit("conversationsList")
                
            }
            //
            
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
                self.socket.emit("userLoggedout")
                
                
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
}



extension LeftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell") as! LeftTableViewCell
        cell.myTitle.text = self.MenuList[indexPath.row].title
        cell.myImage.image = UIImage(named: self.MenuList[indexPath.row].image)
        
        if indexPath.row != 4 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch  indexPath.row {
        case 0:
            delegate?.onMyProfileClicked()
        case 1:
            delegate?.onActivityLogClciked()
        case 2:
              delegate?.onMySchedulesClicked()
          
        case 3:
            delegate?.onSavedStoriesClicked()
        case 4:
            delegate?.onSentRequestClicked()
        case 5:
            delegate?.onBlockUserListClicked()
        case 6:
             delegate?.onAppSettingClicked()
       
//        case 7:
//           delegate?.onAboutClicked()
            
        case 7:
            delegate?.onHelplClicked()
        case 8:
            LogoutAlert()
            //delegate?.onLogoutClicked()
            hitConversation()
      
        default:
            print("Index ")
        }
    }
    
    func LogoutAlert(){
        
        let alert = UIAlertController(title: "Logout".localized, message: "Do you really want to logout from My Life?".localized, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style:.default, handler: {(action)in
            self.delegate?.onLogoutClicked()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style:.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

















