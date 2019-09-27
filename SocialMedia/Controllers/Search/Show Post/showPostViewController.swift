//
//  showPostViewController.swift
//  SocialMedia
//
//  Created by wajahat hassan on 11/2/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Hero
import NVActivityIndicatorView
import ActionSheetPicker_3_0

class showPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblView: UITableView!
    var arrayFeed: PostDetailsData?
    var postId = String()
    var statusFlag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "FeedImageCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "FeedImageCell")
        
        let textFeed = UINib(nibName: "FeedTextCell", bundle: nil)
        tblView.register(textFeed, forCellReuseIdentifier: "FeedTextCell")
        addBackButton()
        self.setupViews()
        self.showLoader()
        
        
        PostDetail(postId:postId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom
    func setupViews(){
        self.title = "Post Details".localized
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView(frame: .zero)
        
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    
    func showActionSheetShare (postId: Int, index: Int)
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option", message: nil, preferredStyle: .actionSheet)
        // create an action
        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone", style: .default) { action -> Void in
            print("Public Share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to share this post as public post?", Type : "public" ,PostId: postId, Index: index)
        }
        
        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends", style: .default) { action -> Void in
            print("Friends share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to shate this post with your friends?", Type : "friends" ,PostId: postId, Index: index)
        }
        
        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline", style: .default) { action -> Void in
            print("Time line share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to shate this post on your timeline?", Type : "private" ,PostId: postId, Index: index)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(sharePublic)
        actionSheetController.addAction(shareFriends)
        actionSheetController.addAction(shareTimeLine)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func showShareConfirmationAlert(WithMsg _msg : String, Type _type : String ,PostId _postId : Int, Index _index : Int) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Share Post", message: _msg, preferredStyle: .alert)
        // create an action
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            print("Public Share")
            self.showSchedulingSharingAlert(Type:_type ,PostId: _postId, Index: _index)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func showSchedulingSharingAlert(Type _type : String, PostId _postId : Int, Index _index : Int) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Schedule Sharing", message: "Do you want to schedule this share?", preferredStyle: .alert)
        // create an action
        let okAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            let datePicker = ActionSheetDatePicker(title: "Schedule Post", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
                picker, value, index in
                guard let newData = self.arrayFeed else{return}
                self.sharePost(postId: _postId, sharingType: _type)
//                self.sharePost(postId: _postId, sharingType: _type, rescheduleAt: (value as! Date))
                newData.totalShares = newData.totalShares + 1
                self.tblView.reloadData()
                return
            }, cancel: { ActionStringCancelBlock in return },
               origin: (self.view as AnyObject).superview!?.superview)
            datePicker?.minimumDate = Date()
            datePicker?.show()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "NO! JUST SHARE IT NOW", style: .default) { action -> Void in
            guard let newData = self.arrayFeed else{return}
            self.sharePost(postId: _postId, sharingType: _type)
            newData.totalShares = newData.totalShares + 1
            self.tblView.reloadData()
        }
        
        // add actions
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Api Calls
    func PostDetail(postId:String) {
        self.showLoader()
        let parameters : [String: Any] = ["post_id": postId ]
        
        print(parameters)
        SearchHandler.getPostDetails(params: parameters as NSDictionary , success: { (success) in
            
            print(success)
            if success.statusCode == 200 {
                self.arrayFeed = success.data
                
                self.tblView.reloadData()
                self.stopAnimating()
            }else{
                print("No Feed data")
                self.stopAnimating()
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    func likePost (postId: Int){
        //self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        print(parameters)
        FeedsHandler.postLike(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            let message = successResponse["message"]
            print(message)
            // self.showAlrt(message: message as! String)
            self.stopAnimating()
            self.tblView.reloadData()
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    func goToComments (objFeed: PostDetailsData){
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(CommentsController.self)!
        postControleller.isMotionEnabled = true
        print(objFeed.id)
        postControleller.postId = "\(objFeed.id!)"
        
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
    func sharePost (postId: Int, sharingType: String, rescheduleAt : Date? = nil){
        self.showLoader()
//        let parameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
        var parameters : [String: Any] = [String: Any]()
        if let _date = rescheduleAt {
            let timeInterval = _date.timeIntervalSince1970 //.timeIntervalSince1970
            let localparameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType, "schedule_at": "\(Int(timeInterval))"]
            parameters = localparameters
        } else {
            let localparameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
            parameters = localparameters
        }
        print(parameters)
        FeedsHandler.shareFeed(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            //let message = successResponse["message"]
            // self.showAlrt(message: message as! String)
            self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    // MARK: - UITableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if arrayFeed?.postType == "text"{
            return 150
        }else{
            return 350
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((arrayFeed?.id) != nil) {
            return 1
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objFeed = arrayFeed
        
        if objFeed?.postType == "image"{
            
            let cell = CommonMethods.showFeedImageCell(tableView: tableView, objFeed: objFeed!)
            cell.imgPlay.isHidden = true
            
            //Likes Action
            let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
            cell.actionLike.tag = indexPath.row
            cell.actionLike.isUserInteractionEnabled = true
            cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
            if objFeed?.myLikeCount == 1{
                cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            }else{
                cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
            }

            
            let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
            cell.lblUserName.tag = indexPath.row
            cell.lblUserName.isUserInteractionEnabled = true
            cell.lblUserName.addGestureRecognizer(userNameTapGesture)
            
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
            
            return cell
            
        }else if objFeed?.postType == "video"{
            let cell = CommonMethods.showFeedImageCell(tableView: tableView, objFeed: objFeed!)            
            // Add gesture to play video
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            print(indexPath.row)
            cell.imgPlay.isHidden = false
            cell.imgPlay.tag = indexPath.row
            cell.imgPlay.isUserInteractionEnabled = true
            cell.imgPlay.addGestureRecognizer(tapGestureRecognizer)
            
            let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
            cell.lblUserName.tag = indexPath.row
            cell.lblUserName.isUserInteractionEnabled = true
            cell.lblUserName.addGestureRecognizer(userNameTapGesture)
            
            //Likes Action
            let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
            cell.actionLike.tag = indexPath.row
            cell.actionLike.isUserInteractionEnabled = true
            cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
            if objFeed?.myLikeCount == 1{
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
            
            return cell
        }else if objFeed?.postType == "text"{
            let cell = CommonMethods.showFeedTextCell(tableView: tableView, objFeed: objFeed!)
            
            let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
            cell.lblUserName.tag = indexPath.row
            cell.lblUserName.isUserInteractionEnabled = true
            cell.lblUserName.addGestureRecognizer(userNameTapGesture)
            
            //Like action
            let likesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
            cell.actionLikes.tag = indexPath.row
            cell.actionLikes.isUserInteractionEnabled = true
            cell.actionLikes.addGestureRecognizer(likesTapGestureRecognizer)
            if objFeed?.myLikeCount == 1{
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
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newData = arrayFeed else{return}
        if newData.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
            controller.state = true
           controller.imageString = newData.postAttachment.path
            self.present(controller, animated: false, completion: nil)
            
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
//            controller.imageString = newData.postAttachment.path
//            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Cell Delegates
    @objc  func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let objOwnUser = UserHandler.sharedInstance.userData
        guard let newData = arrayFeed else{return}
        
        if objOwnUser?.id != newData.userId{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            controller.isFromOtherUser = true
            controller.statusFlag = true
            controller.otherUserId = (newData.userId)!
            self.present(controller, animated: false, completion: nil)
        }
        //        }else{
        //            controller.statusFlag = true
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
//        self.present(controller, animated: false, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let newData = arrayFeed else{return}
        print(newData.postAttachment.path)
        
        let videoURL = URL(string: newData.postAttachment.path)
        let player = AVPlayer(url: videoURL!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
        
    }
    @objc func likesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let newData = arrayFeed else{return}
        print(newData.id)
//        newData.totalLikes = newData.totalLikes + 1
        
        
        if newData.myLikeCount == 0{
            arrayFeed?.totalLikes = newData.totalLikes + 1
            arrayFeed?.myLikeCount = newData.myLikeCount + 1
        }else{
            arrayFeed?.totalLikes = newData.totalLikes - 1
            arrayFeed?.myLikeCount = newData.myLikeCount - 1
        }
        
        self.likePost(postId: newData.id)
        self.tblView.reloadData()
        
    }
    @objc  func commentsTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let newData = arrayFeed else{return}
        self.goToComments(objFeed: newData)
    }
    @objc  func sharesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let newData = arrayFeed else{return}
        print(newData.id)
        self.showActionSheetShare(postId: newData.id)
    }
    func showActionSheetShare (postId: Int){
        guard let newData = arrayFeed else{return}
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option", message: nil, preferredStyle: .actionSheet)
        // create an action
        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone", style: .default) { action -> Void in
            print("Public Share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to share this post as public post?", Type : "public" ,PostId: postId, Index: 0)
        }
        
        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends", style: .default) { action -> Void in
            print("Friends share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to shate this post with your friends?", Type : "friends" ,PostId: postId, Index: 0)
        }
        
        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline", style: .default) { action -> Void in
            print("Time line share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to shate this post on your timeline?", Type : "private" ,PostId: postId, Index: 0)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(sharePublic)
        actionSheetController.addAction(shareFriends)
        actionSheetController.addAction(shareTimeLine)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
        // create an actionSheet
//        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option", message: nil, preferredStyle: .actionSheet)
//        // create an action
//        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone", style: .default) { action -> Void in
//            print("Public Share")
////            self.sharePost(postId: postId, sharingType: "public")
////            newData.totalShares = newData.totalShares + 1
////            self.tblView.reloadData()
//        }
//
//        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends", style: .default) { action -> Void in
//            print("Friends share")
////            self.sharePost(postId: postId, sharingType: "friends")
////            newData.totalShares = newData.totalShares + 1
////            self.tblView.reloadData()
//        }
//
//        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline", style: .default) { action -> Void in
//            print("Time line share")
////            self.sharePost(postId: postId, sharingType: "private")
////            newData.totalShares = newData.totalShares + 1
////            self.tblView.reloadData()
//        }
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//
//        // add actions
//        actionSheetController.addAction(sharePublic)
//        actionSheetController.addAction(shareFriends)
//        actionSheetController.addAction(shareTimeLine)
//        actionSheetController.addAction(cancelAction)
//
//        // present an actionSheet...
//        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
