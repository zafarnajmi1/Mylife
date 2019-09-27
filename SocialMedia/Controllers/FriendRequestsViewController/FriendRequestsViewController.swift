//
//  FriendRequestsViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 07/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FriendRequestsViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let someHeight: CGFloat = 40
            let someView = UIView(x: 0, y: 0, w: tableView.bounds.size.width, h: someHeight)
            
            tableView.tableHeaderView = someView
            tableView.contentInset = UIEdgeInsets(top: -someHeight, left: 0, bottom: 0, right: 0)
            tableView.showsHorizontalScrollIndicator = false
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let requests = ModelGenerator.generateRequestModel()
    var  arrayDataMyFriendRequest  = [MyFriendRequestData]()
    var refreshControl: UIRefreshControl!
    var delegate: chnageFriendRequestNotificationsCount?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        getAllFriends()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupViews (){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        tableView.addSubview(refreshControl)
    }
    
    //MARK:- Simple Functions
    
    @objc func refresh(sender:AnyObject) {
        getAllFriends()
    }
    
    
    // MARK: - API Calls
    // MARK:  My Friend Request
    func getAllFriends()
    {
        
        
        self.showLoader()
        FriendsHandler.myFriendRequest(success: { (successResponse) in
            self.stopAnimating()
            if (successResponse.statusCode == 200){
                self.arrayDataMyFriendRequest = successResponse.data
                
                
                
                print(self.arrayDataMyFriendRequest)
                self.delegate?.getAllFriends()
                self.tableView.reloadData()
                if self.arrayDataMyFriendRequest.count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainHomeTabController")
                   
//                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }else{
                    self.refreshControl.endRefreshing()
//                    self.stopAnimating()
                }
//                 self.stopAnimating()
            }
            else{
                self.displayAlertMessage(successResponse.message)
                self.stopAnimating()
            }
            self.stopAnimating()
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
             self.stopAnimating()
        }
    }
    
    // MARK: - Accept Friend Request
    func acceptFriendRequest(id: Int) {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id": id]
        FriendsHandler.acceptFriendRequest(params: parameters as NSDictionary,success: { (successResponse) in
            if (successResponse.statusCode == 200){
                
                self.arrayDataMyFriendRequest.removeAll()
                self.getAllFriends()
                self.stopAnimating()
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "friendNotification"), object: nil)
               // self.displayAlertMessage(successResponse.message)
                //self.tableView.reloadData()
            }
            else{
                 self.stopAnimating()
                self.displayAlertMessage(successResponse.message)
               // self.tableView.reloadData()
            }
        }){ (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - Reject Friend Request
    func rejectFriendRequest(id: Int) {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id": id]
        FriendsHandler.rejectFriendRequest(params: parameters as NSDictionary,success: { (successResponse) in
            if (successResponse.statusCode == 200){
                 self.stopAnimating()
                self.getAllFriends()
                self.tableView.reloadData()
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "friendNotification"), object: nil)
                //self.displayAlertMessage(successResponse.message)
            }
            else{
                self.stopAnimating()
                self.tableView.reloadData()
                //self.displayAlertMessage(successResponse.message)
            }
        }){ (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
}

extension FriendRequestsViewController: ViewStateProtocol {
    var errorMessage: String? {
        get {
            return "No Friend requests found, Pull to refresh"
        }
        set {
            self.errorMessage = "No Friend requests found, Pull to refresh"
        }
    }
}
    
    

// MARK: - TableView Delegate Functions
extension FriendRequestsViewController:  UITableViewDelegate, UITableViewDataSource, FriendRequestDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayDataMyFriendRequest.count == 0{
            
            
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/3.9, y: tableView.bounds.size.height/1.9, width: 200, height: 60))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No Friend requests found".localized + "\n" + "Pull to refresh".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center

            
            let noDataLabel2: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 340, width: 120, height: 30))
            noDataLabel2.text = ""
            tableView.backgroundView  = noDataLabel2
            
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: tableView.bounds.size.height/2.5, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(noDataLabel)
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        return arrayDataMyFriendRequest.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestsCell.className, for: indexPath) as! FriendRequestsCell
        
        let request = arrayDataMyFriendRequest[indexPath.section]
        cell.tag = request.id
        print(request.fullName)
        cell.labelName.text = request.fullName
        cell.imageViewProfile.sd_setImage(with: URL(string: request.image), placeholderImage: UIImage(named: "placeholder.png"))
        cell.labelMutualFriends.text = "1" + " mutual fiends"
        
        cell.buttonViewProfileOfUser.tag = indexPath.section
         cell.buttonViewProfileOfUser.addTarget(self, action: #selector(FriendRequestsViewController.userNameTapped(sender:)), for: .touchUpInside)
        
        //cell.buttonViewProfileOfUser.addTarget(self, action: #selector(FriendRequestsViewController.heartTapped(_:)), for: .touchUpInside)
        
        cell.delegate = self
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(sender:)))
        cell.imageViewProfile.tag = indexPath.row
        cell.imageViewProfile.isUserInteractionEnabled = true
        cell.imageViewProfile.addGestureRecognizer(imageTapGesture)

        let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(sender:)))
        cell.labelName.tag = indexPath.row
        cell.labelName.isUserInteractionEnabled = true
        cell.labelName.addGestureRecognizer(userNameTapGesture)

        return cell
    }
    
   
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if section == 0 {
            headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            
            let headerLabel = UILabel(frame: CGRect(x: 20, y: 5, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
            headerLabel.textColor = UIColor.black.withAlphaComponent(0.8)
            headerLabel.attributedText = "Make New Friends".localized.semiBold()
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            
        } else  {
            headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
        
        return headerView
    }
    @objc func userNameTapped(sender : UIButton){
        let index = sender.tag
        let objFriend = arrayDataMyFriendRequest[index]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFriend.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Protocol Functions
    internal func didAcceptFriendRequest(cell: FriendRequestsCell) {
        //guard let cell = tableView.indexPath(for: cell) else { return }
        print(cell.tag)
        acceptFriendRequest(id: cell.tag)
    }
    
    func didDeclineFriendRequest(cell: FriendRequestsCell) {
        //guard let item = tableView.indexPath(for: cell) else { return }
        print(cell.tag)
        rejectFriendRequest(id: cell.tag)
    }
    
    func didTapProfilePicture(cell: FriendRequestsCell) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = cell.tag
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    git add .
//    git commit -m "message"
//    git push origin branch_name
}

// MARK: - Protocols
@objc protocol FriendRequestDelegate {
    func didAcceptFriendRequest(cell: FriendRequestsCell)
    func didDeclineFriendRequest(cell: FriendRequestsCell)
    @objc optional func didTapProfilePicture(cell: FriendRequestsCell)
}


// MARK: - Cell Class
class FriendRequestsCell: UITableViewCell {
    
    var delegate:FriendRequestDelegate!
    
    
    var viewfriendProfileDelegate: ViewFriendProfileDelegate?
    var viewMutualFriendsDelegate: ViewMutualFriendsDelegate?
    
    @IBOutlet weak var imageViewProfile: UIImageView! {
        didSet {
            imageViewProfile.roundWithClearColor()
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMutualFriends: UILabel!
    @IBOutlet var buttonAcceptFriend: UIButton!
    @IBOutlet var buttonDeclineFriend: UIButton!
    @IBOutlet weak var buttonViewProfileOfUser: UIButton!
    
    var profileId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        let profileTapGesturerecognizer = UITapGestureRecognizer(target: self, action: #selector(onFriendProfileTapped(_:)))
        imageViewProfile.addGestureRecognizer(profileTapGesturerecognizer)
        labelName.addGestureRecognizer(profileTapGesturerecognizer)
        
        let mutualFriendsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFriendMutualFriendsTapped(_:)))
        labelMutualFriends.addGestureRecognizer(mutualFriendsTapGestureRecognizer)
        
    }
    
    @IBAction func onButtonAcceptFriendClciked(_ sender: UIButton) {
        delegate?.didAcceptFriendRequest(cell: self)
    }
    
    @IBAction func onButtonDeclineFriendClicked(_ sender: UIButton) {
        delegate?.didDeclineFriendRequest(cell: self)
    }
    
    @objc func onFriendProfileTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapProfilePicture!(cell: self)
        viewfriendProfileDelegate?.didTapOnFriendProfile(profileId: profileId)
    }
    
    @objc func onFriendMutualFriendsTapped(_ sender: UITapGestureRecognizer) {
        viewMutualFriendsDelegate?.didTapOnMutualFriends(profileId: profileId)
    }
}

struct RequestModel {
    var name: String
    var mutalFriends: Int
}
