//
//  UserProfileViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 10/25/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import Hero
import DropDown
import ALCameraViewController
import MIBadgeButton_Swift

extension SegueIdentifiable {
    static var userProfileController : SegueIdentifier {
        return SegueIdentifier(rawValue: UserProfileViewController.className)
    }
}
class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable{
    
    @IBOutlet weak var viewTable: UITableView!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var oltBackNavigation: UIButton!
    
    var Friends: MIBadgeButton?
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = true
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    var arrayFeed = [TimelineData]()
    var statusFlag = false
    var isFromOtherUser = false
    var objOtherUser : UserProfileData?
    var otherUserId = Int()
    var pickedImnageUrl: URL?
    var statusFlageForPicture = false
    let dropDownHeaderMenu = DropDown()
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nibHeader = UINib(nibName: "FeedHeaderCell", bundle: nil)
        viewTable.register(nibHeader, forCellReuseIdentifier: "FeedHeaderCell")
        
        let nib = UINib(nibName: "FeedImageCell", bundle: nil)
        viewTable.register(nib, forCellReuseIdentifier: "FeedImageCell")
        
        let textFeed = UINib(nibName: "FeedTextCell", bundle: nil)
        viewTable.register(textFeed, forCellReuseIdentifier: "FeedTextCell")
        
        self.setupViews()
        //self.showLoader()
        
        if statusFlag == false{
            viewNavigation.isHidden = true
        }else{
            viewNavigation.isHidden = false
        }
        if isFromOtherUser{
            self.viewTable.isHidden = true
            self.getOtherUserProfile()
        }else{
            self.getUserTimeline()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
     print(   "(" + "\(UserHandler.sharedInstance.userData!.total_friends!)" + ")" )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom
    func setupViews (){
        self.title = "Profile".localized
        viewTable.delegate = self
        viewTable.dataSource = self
        viewTable.tableFooterView = UIView(frame: .zero)
        viewTable.separatorStyle = .none
        //self.addBackButton()
        addBackButton()
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    func showCustomAlert (message: String, type: Int){
        let alertController = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.rejectFriendRequest(id: (self.objOtherUser?.id)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel){
            UIAlertAction in
            print("Cancel".localized)
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetShare (postId: Int, index: Int){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option".localized, message: nil, preferredStyle: .actionSheet)
        // create an action
        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone".localized, style: .default) { action -> Void in
            print("Public Share")
            self.sharePost(postId: postId, sharingType: "public")
            self.arrayFeed[index].totalShares = self.arrayFeed[index].totalShares + 1
            self.viewTable.reloadData()
        }
        
        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends".localized, style: .default) { action -> Void in
            print("Friends share")
            self.sharePost(postId: postId, sharingType: "friends")
            self.arrayFeed[index].totalShares = self.arrayFeed[index].totalShares + 1
            self.viewTable.reloadData()
        }
        
        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline".localized, style: .default) { action -> Void in
            print("Time line share")
            self.sharePost(postId: postId, sharingType: "private")
            self.arrayFeed[index].totalShares = self.arrayFeed[index].totalShares + 1
            self.viewTable.reloadData()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(sharePublic)
        actionSheetController.addAction(shareFriends)
        actionSheetController.addAction(shareTimeLine)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func goToComments (feedId: Int){
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(CommentsController.self)!
        postControleller.isMotionEnabled = true
        postControleller.postId = "\(feedId)"
        let controller = UINavigationController(rootViewController: postControleller)
        controller.view.backgroundColor = .white
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.cover(direction: .up), dismissing: HeroDefaultAnimationType.uncover(direction: .down))
        
        presentVC(controller)
        //Revert to push
        /*
         let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentsController") as! CommentsController
         self.navigationController?.pushViewController(controller, animated: true)
         */
    }
    func goToFollowers() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowersViewController") as? FollowersViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func goToFollowings (){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyFollowingsViewController") as? MyFollowingsViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    // MARK: - Controller Actions
    
    @IBAction func actionBackNavigation(_ sender: Any) {
        if statusFlag == true{
            navigationController?.popViewController(animated: true)
            dismiss(animated: false, completion: nil)
        }
    }
    var newheight : CGFloat = 0.000
    var newheight2 : CGFloat = 0.000
    // MARK: - UITableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 280
        }else if indexPath.section == 1{
            if isFromOtherUser{
                return 0
            }
            return 60
        }else{
            let objFeed = arrayFeed [indexPath.row]
            if objFeed.postType == "text"{
                return 110 + newheight2
            }
            return 350 + newheight
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //        if isFromOtherUser {
        //            return 2
        //        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return arrayFeed.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedHeaderCell", for: indexPath) as? FeedHeaderCell {
                
                if isFromOtherUser {
                    if objOtherUser != nil{
                        let objuser =  self.objOtherUser
                        
                        if let coverUrl = objuser?.cover{
                            cell.imageCover.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: "placeHolderGenral"))
                            cell.imageCover.sd_setShowActivityIndicatorView(true)
                            cell.imageCover.sd_setIndicatorStyle(.gray)
                            cell.imageCover.contentMode = .scaleAspectFill
                            cell.imageCover.clipsToBounds = true
                        }else{
                            cell.imageCover.image = #imageLiteral(resourceName: "placeHolderGenral")
                        }
                        if let profileImageUrl = objuser?.image{
                            cell.imgUserProfile.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "placeHolderGenral"))
                            cell.imgUserProfile.sd_setShowActivityIndicatorView(true)
                            cell.imgUserProfile.sd_setIndicatorStyle(.gray)
                            cell.imgUserProfile.contentMode = .scaleAspectFill
                            cell.imgUserProfile.clipsToBounds = true
                        }else{
                            cell.imgUserProfile.image = #imageLiteral(resourceName: "userPlaceHolder")
                        }
                        cell.lblUserName.text = objuser?.fullName
                        
                        if objuser?.friendStatus == "friends"{
                            cell.oltOptions.setImage(#imageLiteral(resourceName: "headerFriend"), for: .normal)
                        }else if objuser?.friendStatus == "not-friends"{
                            cell.oltOptions.setImage(#imageLiteral(resourceName: "headerAdd"), for: .normal)
                        }else if objuser?.friendStatus == "request-sent"{
                            cell.oltOptions.setImage(#imageLiteral(resourceName: "headerSent"), for: .normal)
                        } else if objuser?.friendStatus == "request-receive"{
                            cell.oltOptions.setImage(#imageLiteral(resourceName: "headerSent"), for: .normal)
                        }
                        
                        
                        if objuser?.followStatus == "following"{
                            cell.oltMenu.setImage(#imageLiteral(resourceName: "headerFollowing"), for: .normal)
                        }else if objuser?.followStatus == "not-following"{
                            cell.oltMenu.setImage(#imageLiteral(resourceName: "headerUnFollow"), for: .normal)
                        }
                        cell.imgProfile.isHidden = true
                        cell.imgCover.isHidden = true
                    }
                }else{
                    let objuser =  UserHandler.sharedInstance.userData
                    if let coverUrl = objuser?.cover{
                        cell.imageCover.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: ""))
                        cell.imageCover.sd_setShowActivityIndicatorView(true)
                        cell.imageCover.sd_setIndicatorStyle(.gray)
                        cell.imageCover.contentMode = .scaleAspectFill
                        cell.imageCover.clipsToBounds = true
                    }else{
                        cell.imageCover.image = #imageLiteral(resourceName: "placeHolderGenral")
                    }
                    if let profileImageUrl = objuser?.image{
                        cell.imgUserProfile.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: ""))
                        cell.imgUserProfile.sd_setShowActivityIndicatorView(true)
                        cell.imgUserProfile.sd_setIndicatorStyle(.gray)
                        cell.imgUserProfile.contentMode = .scaleAspectFill
                        cell.imgUserProfile.clipsToBounds = true
                    }else{
                        cell.imgUserProfile.image = #imageLiteral(resourceName: "userPlaceHolder")
                    }
                    cell.lblUserName.text = objuser?.fullName
                    
                    cell.imgProfile.isHidden = false
                    cell.imgCover.isHidden = false
                    
                }
                
                //Left to right menu buttons
                let coverImageTapFestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userCoverImageTapped(tapGestureRecognizer:)))
                cell.imageCover.tag = indexPath.row
                cell.imageCover.isUserInteractionEnabled = true
                cell.imageCover.addGestureRecognizer(coverImageTapFestureRecognizer)
                
                let profileImageTapFestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userProfileImageTapped(tapGestureRecognizer:)))
                cell.imgUserProfile.tag = indexPath.row
                cell.imgUserProfile.isUserInteractionEnabled = true
                cell.imgUserProfile.addGestureRecognizer(profileImageTapFestureRecognizer)
                
                cell.imageCover.addGestureRecognizer(coverImageTapFestureRecognizer)
                let profilePictureTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
                cell.imgProfile.tag = indexPath.row
                cell.imgProfile.isUserInteractionEnabled = true
                cell.imgProfile.addGestureRecognizer(profilePictureTapGestureRecognizer)
                
                let coverTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverImageTapped(tapGestureRecognizer:)))
                cell.imgCover.tag = indexPath.row
                cell.imgCover.isUserInteractionEnabled = true
                cell.imgCover.addGestureRecognizer(coverTapGestureRecognizer)
                
                let moreOptionsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerOptionsTapped(tapGestureRecognizer:)))
                cell.oltOptions.tag = indexPath.row
                cell.oltOptions.isUserInteractionEnabled = true
                cell.oltOptions.addGestureRecognizer(moreOptionsTapGestureRecognizer)
                
                let infoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerInfoTapped(tapGestureRecognizer:)))
                cell.oltInfo.tag = indexPath.row
                cell.oltInfo.isUserInteractionEnabled = true
                cell.oltInfo.addGestureRecognizer(infoTapGestureRecognizer)
                
                let friendsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerFriendsTapped(tapGestureRecognizer:)))
                
                if UserHandler.sharedInstance.userData!.total_friends! != 0 {
                    if !isFromOtherUser {
                        
                        cell.badgeLbl.text = String(UserHandler.sharedInstance.userData!.total_friends!)
                    }
                    else {
                        
                        cell.badgeLbl.text = String(UserHandler.sharedInstance.userData!.total_friends!)
                    }
                    
                    
                }
                else {
                    cell.badgeLbl.text = ""
                }
                
                cell.oltFriends?.tag = indexPath.row
                cell.oltFriends?.isUserInteractionEnabled = true
                cell.oltFriends?.addGestureRecognizer(friendsTapGestureRecognizer)
                
                let menuTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerMenuTapped(tapGestureRecognizer:)))
                cell.oltMenu.tag = indexPath.row
                cell.oltMenu.isUserInteractionEnabled = true
                cell.oltMenu.addGestureRecognizer(menuTapGestureRecognizer)
                
                cell.selectionStyle = .none
                
                return cell
            }
        }else if indexPath.section == 1 {
            if let statusCell = tableView.dequeueReusableCell(withIdentifier: "FeedStatusCell", for: indexPath) as? FeedStatusCell{
                statusCell.backgroundColor = .white
                let statusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTapped(tapGestureRecognizer:)))
                statusCell.oltUpdateStatus.tag = indexPath.row
                statusCell.oltUpdateStatus.isUserInteractionEnabled = true
                statusCell.oltUpdateStatus.addGestureRecognizer(statusTapGestureRecognizer)
                return statusCell
            }
        }else if indexPath.section == 2 {
           // let objOwnUser = UserHandler.sharedInstance.userData
            let objFeed = arrayFeed [indexPath.row]
            if objFeed.postType == "image"{
                let cell = CommonMethods.createFeedImageCellTimeline(tableView: tableView, objFeed: objFeed)
                cell.imgPlay.isHidden = true
                
                newheight = 0.000
                let textView = UITextView()
                
                if objFeed.descriptionField != ""{
                    textView.text = objFeed.descriptionField
                }else{
                    textView.right = 0.0
                    
                }
                
                newheight =  textView.contentSize.height //cell.lblDescription.height

                
                
                // Add gesture to display image
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pictureTapped(tapGestureRecognizer:)))
                print(indexPath.row)
                cell.imgPlay.isHidden = true
                cell.imgFeed.tag = indexPath.row
                cell.imgFeed.isUserInteractionEnabled = true
                cell.imgFeed.addGestureRecognizer(tapGestureRecognizer)
                
                if let _postAttachmentData = objFeed.postAttachmentData {
                    switch (_postAttachmentData.count) {
                    case 0:
                        break
                    case 1,2,3:
                        cell.btnMoreFeedImages.backgroundColor = .clear
                        cell.btnMoreFeedImages.setTitle("", for: .normal)
                        cell.btnMoreFeedImages.tag = indexPath.row
                        cell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        cell.btnAllImages.tag = indexPath.row
                        cell.btnAllImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        break
                    default:
                        cell.btnMoreFeedImages.backgroundColor = UIColor.init(r: 0.0/255.0, g: 0.0/255.0, b: 0.0/255.0, a: 0.5) //UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5  )
                        cell.btnMoreFeedImages.setTitle("+\(_postAttachmentData.count - 3) more", for: .normal)
                        cell.btnMoreFeedImages.tag = indexPath.row
                        cell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        cell.btnAllImages.tag = indexPath.row
                        cell.btnAllImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        break
                    }
                }
                
                
                //Likes Action
                let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                if objFeed.myLikeCount == 1{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }else{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                }
                cell.actionLike.tag = indexPath.row
                cell.actionLike.isUserInteractionEnabled = true
                cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
                
                //Comments action
                let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                cell.actionComment.tag = indexPath.row
                cell.actionComment.isUserInteractionEnabled = true
                cell.actionComment.addGestureRecognizer(commentTapGestureRecognizer)
                
                //Share Action
                let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sharesTapped(tapGestureRecognizer:)))
                cell.actionShare.tag = indexPath.row
                cell.actionShare.isUserInteractionEnabled = true
                cell.actionShare.addGestureRecognizer(shareTapGestureRecognizer)
                
                if !isFromOtherUser{
                    cell.oltRemovePost.isHidden = false
                    let removePostTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(removePostTapGestureRecognizer)
                }else{
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.lblUserName.tag = indexPath.row
                    cell.lblUserName.isUserInteractionEnabled = true
                    cell.lblUserName.addGestureRecognizer(userNameTapGesture)
                }
                
                return cell
                
            }else if objFeed.postType == "video"{
                let cell = CommonMethods.createFeedImageCellTimeline(tableView: tableView, objFeed: objFeed)
                
                // Add gesture to play video
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                print(indexPath.row)
                cell.imgPlay.isHidden = false
                cell.imgPlay.tag = indexPath.row
                cell.imgPlay.isUserInteractionEnabled = true
                cell.imgFeed.isUserInteractionEnabled = false
                cell.imgPlay.addGestureRecognizer(tapGestureRecognizer)
                

                //Likes Action
                let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                cell.actionLike.tag = indexPath.row
                cell.actionLike.isUserInteractionEnabled = true
                cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
                if objFeed.myLikeCount == 1{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }else{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                }
                
                //Comments action
                let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                cell.actionComment.tag = indexPath.row
                cell.actionComment.isUserInteractionEnabled = true
                cell.actionComment.addGestureRecognizer(commentTapGestureRecognizer)
                
                //Share Action
                let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sharesTapped(tapGestureRecognizer:)))
                cell.actionShare.tag = indexPath.row
                cell.actionShare.isUserInteractionEnabled = true
                cell.actionShare.addGestureRecognizer(shareTapGestureRecognizer)
                
                if !isFromOtherUser{
                    cell.oltRemovePost.isHidden = false
                    let removePostTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(removePostTapGestureRecognizer)
                }else{
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.lblUserName.tag = indexPath.row
                    cell.lblUserName.isUserInteractionEnabled = true
                    cell.lblUserName.addGestureRecognizer(userNameTapGesture)
                }
                
                return cell
            }else if objFeed.postType == "text"{
                let cell = CommonMethods.createFeedTextCellTimeline(tableView: tableView, objFeed: objFeed)
                
                newheight2 = 0.000
                let textView = UITextView()
                
                if objFeed.descriptionField != ""{
                    textView.text = objFeed.descriptionField
                    if textView.contentSize.height <= 0{
                        textView.contentSize.height = 10
                    }else{
                        textView.contentSize.height = 50
                    }
                }else{
                    textView.right = 0.0
                }
                
                newheight2 =  textView.contentSize.height
                //Like action
                let likesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                cell.actionLikes.tag = indexPath.row
                cell.actionLikes.isUserInteractionEnabled = true
                cell.actionLikes.addGestureRecognizer(likesTapGestureRecognizer)
                if objFeed.myLikeCount == 1{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }else{
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                }
                
                //Action Comments
                let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                cell.actionComments.tag = indexPath.row
                cell.actionComments.isUserInteractionEnabled = true
                cell.actionComments.addGestureRecognizer(commentTapGestureRecognizer)
                
                //Action Share
                let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sharesTapped(tapGestureRecognizer:)))
                cell.actionShares.tag = indexPath.row
                cell.actionShares.isUserInteractionEnabled = true
                cell.actionShares.addGestureRecognizer(shareTapGestureRecognizer)
                
                if !isFromOtherUser{
                    
                    cell.oltRemovePost.isHidden = false
                    let removePostTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(removePostTapGestureRecognizer)
                }else{
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.lblUserName.tag = indexPath.row
                    cell.lblUserName.isUserInteractionEnabled = true
                    cell.lblUserName.addGestureRecognizer(userNameTapGesture)

                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
//        let postID = arrayFeed[indexPath.row].id
//        guard let newData = postID else{return}
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
//        controller.postId = String(describing: newData)
//        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: Table Header Menus
    @objc func pictureTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        let index = tapGestureRecognizer.view?.tag
//        let objFeed = arrayFeed[index!]
////        print(objFeed.postAttachment.path)
//        if objFeed.postType == "image"{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
//            controller.state = true
//            var path : String = ""
//            if let _postAttachmentData = objFeed.postAttachmentData {
//                if (_postAttachmentData.count > 0) {
//                    controller.imageString = _postAttachmentData[0].path
//                }
//            } else {
//                controller.imageString = ""
//            }
////            controller.imageString = objFeed.postAttachment.path
//            self.present(controller, animated: false, completion: nil)
//        }
        
        
        
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        //        print(objFeed.postAttachment.path)
        //        print(objFeed.postType)
        if objFeed.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: NewsFeedOnProfileDisplayImageViewController.className) as! NewsFeedOnProfileDisplayImageViewController
            controller.objFeed = objFeed
            self.present(controller, animated: false, completion: nil)
        }
        
        
        
        
    }
        
        
       
    
    @objc func coverImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        statusFlageForPicture = true
        openImgPicker()
    }
    @objc func userCoverImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        if isFromOtherUser {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.state = true
            controller.imageString = (self.objOtherUser?.cover)!
            self.present(controller, animated: false, completion: nil)
        }else{
            let objuser =  UserHandler.sharedInstance.userData
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.state = true
            controller.imageString = (objuser?.cover)!
            self.present(controller, animated: false, completion: nil)
        }
    }
    @objc func userProfileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if isFromOtherUser {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.state = true
            controller.imageString = (self.objOtherUser?.image)!
            self.present(controller, animated: false, completion: nil)
        }else{
            let objuser =  UserHandler.sharedInstance.userData
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.state = true
            controller.imageString = (objuser?.image)!
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        statusFlageForPicture = false
        openImgPicker()
    }
    
    @objc func headerOptionsTapped(tapGestureRecognizer: UITapGestureRecognizer){
      
        if isFromOtherUser {
            //           objOtherUser?.friendStatus
            if objOtherUser?.friendStatus == "friends"{
                let alert = UIAlertController(title: "UN FRIEND".localized, message: "Do you really want to remove this user as friend?".localized, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: { action in
                    self.removeFriendRequest(friendId: (self.objOtherUser?.id.toString)!)
                    
                }))
                alert.addAction(UIAlertAction(title: "CANCEL".localized, style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }else if objOtherUser?.friendStatus == "not-friends"{
                sendFriendRequest(friendId: (objOtherUser?.id.toString)!)
            }
            else if objOtherUser?.friendStatus == "request-receive"{
                acceptFriendRequest(id: (objOtherUser?.id)!)
            }
    }
    else{
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ActivityLogViewController") as! ActivityLogViewController
    //self.navigationController?.pushViewController(controller, animated: true)
            //let profileController = UIStoryboard.mainStoryboard.instantiateVC(ActivityLogViewController.self)!
            let controller2 = embedIntoNavigationController(controller)
            
            presentVC(controller2)
                
            
    }
    
}
    
    @objc func headerInfoTapped (tapGestureRecognizer: UITapGestureRecognizer){
        //segueTo(controller: .aboutViewcontroller)
        // let index = tapGestureRecognizer.view?.tag
        if statusFlag == true{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            if isFromOtherUser{
                if statusFlag == true{
                    controller.statusFlag = true
                }
                controller.isFromOtheruser = true
                controller.otherUserId = otherUserId
            }else{
                if statusFlag == true{
                    controller.statusFlag = true
                }
                controller.isFromOtheruser = false
            }
            self.present(controller, animated: false, completion: nil)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            if isFromOtherUser{
                controller.isFromOtheruser = true
                controller.otherUserId = otherUserId
            }else{
                controller.isFromOtheruser = false
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        /*
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        if isFromOtherUser{
            controller.isFromOtheruser = true
            controller.otherUserId = otherUserId
        }else{
            controller.isFromOtheruser = false
        }
        self.navigationController?.pushViewController(controller, animated: true)*/
    }
    
    @objc func headerFriendsTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //segueTo(controller: .friendsController)
        
        if statusFlag == true{
            
           let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllFriendsController") as! AllFriendsController
            
            //self.performSegue(withIdentifier: "AllFriends", sender: self)
            
            if isFromOtherUser{
                if statusFlag == true{
                    controller.statusFlag = true
                }
                controller.isFromOtherUser = true
                controller.otherUserId = otherUserId
                
                
            }else{
                if statusFlag == true{
                    controller.statusFlag = true
                }
                controller.isFromOtherUser = false
                controller.otherUserId = 0
            }
            self.present(controller, animated: false, completion: nil)
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllFriendsController") as! AllFriendsController
            if isFromOtherUser{
                controller.isFromOtherUser = true
                controller.otherUserId = otherUserId
                
                
            }else{
                controller.isFromOtherUser = false
                controller.otherUserId = 0
            }
            //self.present(controller, animated: false, completion: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func headerMenuTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if isFromOtherUser{
            let userId = self.objOtherUser?.id!
            print(userId!)
            
            if self.objOtherUser?.followStatus == "following"{
                self.unFollowTheUser(id: userId!)
            }else if self.objOtherUser?.followStatus == "not-following"{
                self.followTheUser(id: userId!)
            }
            
        }else{
            let index = tapGestureRecognizer.view?.tag
            let indexPath = IndexPath(item: index!, section: 0)
            let cell = self.viewTable.cellForRow(at: indexPath) as! FeedHeaderCell
            let lang = UserDefaults.standard.string(forKey: "i18n_language")
            if lang == "ar" {
                dropDownHeaderMenu.anchorView = cell.oltOptions
            }
            else {
                
                dropDownHeaderMenu.anchorView = cell.oltMenu
            }
            
            dropDownHeaderMenu.dataSource = ["followers ".localized + "(" + "\(UserHandler.sharedInstance.userData!.totalFollowers!)" + ")","following ".localized + "(" + "\(UserHandler.sharedInstance.userData!.total_followings!)" + ")"]
            dropDownHeaderMenu.show()
            dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected Item \(item) at index: \(index)")
                if index == 0{
                    self.goToFollowers()
                }else{
                    self.goToFollowings()
                }
            }
        }
    }
    
    // MARK: Cell actions
    @objc func statusTapped(tapGestureRecognizer: UITapGestureRecognizer){
        segueTo(controller: .updateStatusViewController)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
//        print(objFeed.postAttachment.path)
        var path : String = ""
        if let _postAttachmentData = objFeed.postAttachmentData {
            if (_postAttachmentData.count > 0) {
                path = _postAttachmentData[0].path
            }
        }
        
//        let videoURL = URL(string: objFeed.postAttachment.path)
        let videoURL = URL(string: path)
        let player = AVPlayer(url: videoURL!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
        
    }
    @objc func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        let objOwnUser = UserHandler.sharedInstance.userData
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if objOwnUser?.id != objFeed.userId{
            controller.isFromOtherUser = true
            controller.otherUserId = objFeed.userId
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func likesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        print(objFeed.id)
        arrayFeed[index!].totalLikes = objFeed.totalLikes + 1
        
        self.likePost(postId: objFeed.id)
        //self.viewTable.reloadData()
        let indexPath = IndexPath(item: index!, section: 2)
        self.viewTable.reloadRows(at: [indexPath], with: .none)
        
    }
    @objc func commentsTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        self.goToComments(feedId: objFeed.id)
    }
    @objc func sharesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        print(objFeed.id)
        
        self.showActionSheetShare(postId: objFeed.id, index: index!)
    }
    @objc func removePost (tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        
        let alertController = UIAlertController(title: "Alert".localized, message: "Are you sure you want to remove this post?".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.showLoader()
            self.removePost(postId: objFeed.id)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel){
            UIAlertAction in
            print("Cancel")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    func saveFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "profilePicture&CoverPicture", extention: ".jpg") {
            self.pickedImnageUrl = savedUrl
            if statusFlageForPicture == true{
                self.changeCoverPhoto (FilePath:pickedImnageUrl!, coverUrl:String(describing: pickedImnageUrl!), parameterName: "cover", FileName: "cover")
            }else{
                self.changeCoverPhoto (FilePath:pickedImnageUrl!, coverUrl:String(describing: pickedImnageUrl!), parameterName: "image", FileName: "image")
            }
        }
    }
    private func openImgPicker() {
        
        
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            //            self?.imageView.image = image
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
    
    
    // MARK: - API Calls
    // MARK: - Accept Friend Request
    func acceptFriendRequest(id: Int) {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id": id]
        FriendsHandler.acceptFriendRequest(params: parameters as NSDictionary,success: { (success) in
            if(success.statusCode == 200)
            {
                self.stopAnimating()
                self.getOtherUserProfile()
                
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
            
        }){ (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
    
    func sendFriendRequest(friendId: String){
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : friendId]
        
        FriendsHandler.sendFriendRequest(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200)
            {
                self.stopAnimating()
                self.getOtherUserProfile()
         
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
                self.stopAnimating()
            
        }
    }
    // MARK : remove friend request
    func removeFriendRequest(friendId: String){
        
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : friendId]
        
        FriendsHandler.removeFriends(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
               self.stopAnimating()
                self.getOtherUserProfile()
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }){ (error) in
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    // MARK : get users timeline
    func getUserTimeline () {
        let url = ApiCalls.baseUrlBuild + ApiCalls.userTimeLine
        print(url)
        var userId = 0
        if isFromOtherUser {
            userId = (objOtherUser?.id)!
        }else{
            let objuser = UserHandler.sharedInstance.userData
            userId = (objuser?.id!)!
        }
        let parameters : [String: Int] = ["user_id" : (userId) ]
        
        FeedsHandler.getUserTimeline(url: url, params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.arrayFeed = successResponse.data
                if self.arrayFeed.count > 0 {
                    self.viewTable.reloadData()
                    //self.stopAnimating()
                }else{
                    //self.stopAnimating()
                    // self.showAlrt(message: "No Timeline posts found.")
                }
            }
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: - API Call Edit User Information
    func changeCoverPhoto (FilePath:URL, coverUrl:String, parameterName:String, FileName:String){
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            parameterName : coverUrl
            
        ]
        print(dictionaryForm)
        UserHandler.editProfilePictureAndCoverPhoto(fileName:FileName,fileUrl: FilePath, params: dictionaryForm as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            print(successResponse)
            if successResponse.statusCode == 200 {

                UserHandler.sharedInstance.userData = successResponse.data
//                NotificationCenter.default.post(name: notificationName, object: nil)
                self.viewTable.reloadData()
                //self.stopAnimating()
            }
        }) { (errorResponse) in
            self.stopAnimating()
            print(errorResponse!)
            //self.stopAnimating()
        }
        
    }
    // MARK : Share Post
    func sharePost (postId: Int, sharingType: String){
        self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
        print(parameters)
        FeedsHandler.shareFeed(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            //let message = successResponse["message"]
            // self.showAlrt(message: message as! String)
            //self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: Like Post
    func likePost (postId: Int){
        //self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        print(parameters)
        FeedsHandler.postLike(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            //let message = successResponse["message"]
            // self.showAlrt(message: message as! String)
            //self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: Get Other User Profile
    func getOtherUserProfile (){
        let parameters : [String: Int] = ["user_id" : otherUserId]
        print(parameters)
        UserHandler.getOtherUserProfile(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse.data)
            if successResponse.statusCode == 200 {
                self.objOtherUser = successResponse.data
                UserHandler.sharedInstance.userData!.total_friends! = successResponse.data.friendsCount
                self.viewTable.reloadData()
                self.getUserTimeline()
            }else{
                print(successResponse.message)
                self.showAlrt(message: successResponse.message)
            }
            self.viewTable.isHidden = false
            //self.stopAnimating()
            
        }) { (errorResponse) in
            //self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: Reject Friend Request
    func sendFriendRequest (id: Int){
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : id]
        print(parameters)
        FriendsHandler.sendFriendRequest(params: parameters as NSDictionary , success: { (success) in
            //self.stopAnimating()
            if success.statusCode == 200 {
                self.displayAlertMessage(success.message)
                self.objOtherUser?.friendStatus = "request-sent"
                self.viewTable.reloadData()
            }else{
                self.displayAlertMessage(success.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            //self.stopAnimating()
        }
    }
    // MARK: Reject Friend Request
    func rejectFriendRequest(id: Int){
        self.showLoader()
        let parameters : [String: Any] = ["friend_id": id]
        print(parameters)
        
        FriendsHandler.rejectFriendRequest(params: parameters as NSDictionary,success: { (successResponse) in
            //self.stopAnimating()
            if successResponse.statusCode == 200 {
                self.displayAlertMessage(successResponse.message)
                self.objOtherUser?.friendStatus = "not-friends"
                self.viewTable.reloadData()
            }else{
                self.displayAlertMessage(successResponse.message)
            }
        }){ (error) in
            print("error = ",error!)
            //self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
    func removePost (postId : Int){
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        
        FeedsHandler.removePost(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            self.stopAnimating()
            let message = successResponse["message"] as! String
            self.showAlrt(message: message)
            self.arrayFeed.removeAll()
            self.getUserTimeline()
        }) { (errorResponse) in
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    @objc  func btnFeedMoreImagesClick(_ sender : UIButton) {
        let index = sender.tag
        let objFeed = arrayFeed[index]
        if objFeed.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewsFeedMultipleImagesViewController") as! NewsFeedMultipleImagesViewController
            controller.timelineFeedData = objFeed
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Follow User
    func followTheUser(id: Int)
    {
        self.showLoader()
        let parameters : [String: Int] = ["following_id" : id]
        print(parameters)
        
        FriendsHandler.followTheUser(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
                self.stopAnimating()
                self.displayAlertMessage("Successfully Followed".localized)
                self.objOtherUser?.followStatus = "following"
                self.viewTable.reloadData()
            }
            else{
                self.stopAnimating()
                self.displayAlertMessage(success.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
    // MARK: Unfollow User
    func unFollowTheUser(id: Int){
        self.showLoader()
        let parameters : [String: Int] = ["following_id" : id]
        print(parameters)
        
        FriendsHandler.unFollowTheUser(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
                self.stopAnimating()
                self.displayAlertMessage("Successfully Un-Followed".localized)
                self.objOtherUser?.followStatus = "not-following"
                self.viewTable.reloadData()
            }
            else{
                self.stopAnimating()
                self.displayAlertMessage(success.message)
            }
        }){ (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
}
extension UserProfileViewController {
    func embedIntoNavigationController(_ rootController: UIViewController, presentingTransition: HeroDefaultAnimationType = .pageIn(direction: .left), dismissTransition: HeroDefaultAnimationType = .pageOut(direction: .right)) -> UINavigationController {
        rootController.isHeroEnabled = true
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.view.backgroundColor = .white
        navigationController.isHeroEnabled = true
        navigationController.heroModalAnimationType = .selectBy(presenting: presentingTransition, dismissing: dismissTransition)
        
        return navigationController
    }
    
}
