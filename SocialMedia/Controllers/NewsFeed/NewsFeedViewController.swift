//
//  NewsFeedViewController.swift
//  SocialMedia
//
//  Created by Macbook on 20/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Hero
import NVActivityIndicatorView
import ActionSheetPicker_3_0
import ImagePicker
import Lightbox



class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable,sendPostId, StoriesCellDelegate,UITabBarControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    
    
    @IBOutlet var tblView: UITableView!
    static var arrayOfImages = [UIImage]()
    static var arrayOfImagesURLS = [URL]()
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var galleryImage:UIImage?
    var arrayStories = [StoriesData] ()
    var arrayFeed = [NewsFeedData]()
    var objFeedPagination : NewsFeedPagination?
    var refreshControl: UIRefreshControl!
    static var isDeletedStory = false
    override func viewDidAppear(_ animated: Bool) {
        print("view did apear called")
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
        tblView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsFeedViewController.arrayOfImages.removeAll()
       
        
        NewsFeedViewController.arrayOfImagesURLS.removeAll()
        
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "FeedImageCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "FeedImageCell")
        
        let textFeed = UINib(nibName: "FeedTextCell", bundle: nil)
        tblView.register(textFeed, forCellReuseIdentifier: "FeedTextCell")
        
        self.setupViews()
        //self.showLoader()
        self.getStories()
        self.getNewsFeed()
    }
    
    
    
    internal func postId(postId:Int){
        print("delegate Success")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //watchAllLbl.text = "Watch All".localized
        
        //This is search string (Content written by Wajahat Hassan
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "searchString")
        userDefaults.synchronize()
        
        if FeedsHandler.sharedInstance.isVideoSelected || FeedsHandler.sharedInstance.isSelectdImage{
            //self.uploadStory()
        }
        
        self.getStories()
        
        if FeedsHandler.sharedInstance.isStatusPosted {
            FeedsHandler.sharedInstance.isStatusPosted = false
            //self.showLoader()
            self.getNewsFeed()
            self.getStories()
        }
    }
    // MARK: - Custom
    func setupViews(){
        //self.title = "My Life"
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView(frame: .zero)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        tblView.addSubview(refreshControl)
        
    }
    @objc func refresh(sender:AnyObject) {
        self.getStories()
        self.getNewsFeed()
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showAlrt (message: String) {
        //let alert = CommonMethods.showBasicAlert(message: message)
        //self.present(alert, animated: true,completion: nil)
    }
    
    func goToComments (objFeed: NewsFeedData) {
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(CommentsController.self)!
        postControleller.isMotionEnabled = true
        print(objFeed.id)
        postControleller.postId = "\(objFeed.id!)"
        
        let controller = UINavigationController(rootViewController: postControleller)
        controller.view.backgroundColor = .white
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: .cover(direction: .up), dismissing: .uncover(direction: .down))
        
        presentVC(controller)
        //Revert to push
        /*
         let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentsController") as! CommentsController
         self.navigationController?.pushViewController(controller, animated: true)
         */
    }
    func showCustomAlert (message: String, postId: Int, index : Int){
        let alertController = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.showLoader()
            
            
            print(self.arrayFeed.count)
            self.arrayFeed.remove(at: index)
            print(self.arrayFeed.count)
            //self.
            self.tblView.reloadData()
            self.removePost(postId: postId)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel){
            UIAlertAction in
            print("Cancel")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    var newheight : CGFloat = 0.000
    var newheight2 : CGFloat = 0.000
    // MARK: - UITableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 80
        case 2:
            let objFeed = arrayFeed [indexPath.row]
            if objFeed.postType == "text"{
               
                 return 110.00 + newheight2
            }
            return 350 + newheight
        default:
            return 100
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayFeed.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/2.8, y: 340, width: 120, height: 30))
            noDataLabel.text          = "No result found".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            
            let noDataLabel2: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 340, width: 120, height: 30))
            noDataLabel2.text = ""
            tableView.backgroundView  = noDataLabel2
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 270, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(noDataLabel)
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return arrayFeed.count
        }
        return 1
    }
    var dataArraytest = [StoriesData] ()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let storiesCell = tableView.dequeueReusableCell(withIdentifier: "FeedStoriesTableViewCell",
                                                               for: indexPath) as? FeedStoriesTableViewCell {
                storiesCell.selectionStyle = .none
                
             storiesCell.lblShareStories.text = "Stories".localized
               
                dataArraytest = arrayStories
                
                for (key,_story) in dataArraytest.enumerated(){
                    if UserHandler.sharedInstance.userData?.id == _story.userId{
                        dataArraytest.remove(at: key)
                    }
                }
                
                if dataArraytest.count == 0{
                    storiesCell.watchAllView.isHidden=true
                }else{
                    storiesCell.watchAllView.isHidden=false
                }
                
                storiesCell.dataArray = arrayStories
                storiesCell.newdataArray = dataArraytest
                storiesCell.delegate = self
                storiesCell.reloadData()
                return storiesCell
            }
        }else if indexPath.section == 1 {
            if let statusCell = tableView.dequeueReusableCell(withIdentifier: "FeedStatusCell", for: indexPath) as? FeedStatusCell{
                
            //statusCell
                statusCell.lblStatus.text = "What's On Your Mind".localized
                let statusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTapped(tapGestureRecognizer:)))
                statusCell.oltUpdateStatus.tag = indexPath.row
                statusCell.oltUpdateStatus.isUserInteractionEnabled = true
                statusCell.oltUpdateStatus.addGestureRecognizer(statusTapGestureRecognizer)
                
                return statusCell
            }
        }else if indexPath.section == 2{
            let objOwnUser = UserHandler.sharedInstance.userData
            
            let objFeed = arrayFeed [indexPath.row]
            print(objFeed.postType)
            if indexPath.row == arrayFeed.count - 2  {
                self.getNewsFeedNextPage()
            }
            
            if objFeed.postType == "image"{
                let cell = CommonMethods.createFeedImageCell(tableView: tableView, objFeed: objFeed)
                cell.imgPlay.isHidden = true
                newheight = 0.000
                let textView = UITextView()
                
                if objFeed.descriptionField != ""{
                     textView.clipsToBounds  = true
                    if(lang == "ar") //me
                    {
                        textView.textAlignment = .right
                        textView.contentMode = .right
                    }else
                    {
                        textView.textAlignment = .left
                        textView.contentMode = .left
                    }
                    textView.text = objFeed.descriptionField
                    
                }else{
                    textView.right = 0.0
                    
                }
               
                ////////////////////////////////////////////////////////////////
                
                newheight =  textView.contentSize.height //cell.lblDescription.height
                // Add gesture to display image
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pictureTapped(tapGestureRecognizer:)))
                print(indexPath.row)
                cell.imgPlay.isHidden = true
                cell.imgFeed.tag = indexPath.row
                cell.imgFeed.isUserInteractionEnabled = true
               // cell.imgFeed.image =    objFeed.postAttachment.thumbnail
                cell.imgFeed.addGestureRecognizer(tapGestureRecognizer)
                if let _postAttachmentData = objFeed.postAttachmentData {
                    switch (_postAttachmentData.count) {
                    case 0:
                        break
                    case 1,2,3:
                        cell.btnMoreFeedImages.backgroundColor = .clear
                        cell.btnMoreFeedImages.setTitle("", for: .normal)
                        cell.btnMoreFeedImages.tag = indexPath.row
                        cell.btnAllImages.tag = indexPath.row
                        cell.btnAllImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                       
                        // cell.imgFeedImage1.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                       // cell.imgFeedImage2.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                       // cell.imgFeedImage3.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        break
                    default:
                        cell.btnMoreFeedImages.backgroundColor = UIColor.init(r:0.0/255.0 , g: 0.0/255.0, b: 0.0/255.0, a: 0.5) //UIColor(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5  )
                        cell.btnMoreFeedImages.setTitle("+\(_postAttachmentData.count - 3)" + "more".localized, for: .normal)
                        cell.btnMoreFeedImages.tag = indexPath.row
                        cell.btnAllImages.tag = indexPath.row
                        cell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        break
                    }
                }
                
                //Likes Action
                if objFeed.myLikeCount == 1{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLike.tag = indexPath.row
                    cell.actionLike.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                    cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLike.tag = indexPath.row
                    cell.actionLike.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                    cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
                }
                
                
                let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                cell.lblUserName.tag = indexPath.row
                if(lang == "en")
                {
                cell.lblUserName.textAlignment = .left
                }else
                {
                    cell.lblUserName.textAlignment = .right
                }
                cell.lblUserName.isUserInteractionEnabled = true
                cell.lblUserName.addGestureRecognizer(userNameTapGesture)
                
                let userProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                cell.actionprofile.tag = indexPath.row
                cell.actionprofile.isUserInteractionEnabled = true
                cell.actionprofile.addGestureRecognizer(userProfileTapGesture)
                
                //more buttpn action
                cell.myController = self
                cell.setData(myId: objOwnUser!.id, userId: objFeed.userId, postId: objFeed.id )
                
                
                
                
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
                
                if objOwnUser?.id == objFeed.userId {
                    cell.oltRemovePost.isHidden = false
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    cell.oltRemovePost.isHidden = true
                }
                
                if objFeed.totalLikes > 0{
                    cell.oltLike.isSelected = true
                }else {
                    cell.oltLike.isSelected = false
                }
                return cell
                
            }else if objFeed.postType == "video"{
                let cell = CommonMethods.createFeedImageCell(tableView: tableView, objFeed: objFeed)
                
                // Add gesture to play video
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                print(indexPath.row)
                cell.imgPlay.isHidden = false
                cell.imgPlay.tag = indexPath.row
                cell.imgPlay.isUserInteractionEnabled = true
                cell.imgFeed.isUserInteractionEnabled = false
                cell.imgPlay.addGestureRecognizer(tapGestureRecognizer)
                
                let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                
                if(lang == "en")
                {
                    cell.lblUserName.textAlignment = .left
                }else
                {
                    cell.lblUserName.textAlignment = .right
                }
                cell.lblUserName.tag = indexPath.row
                cell.lblUserName.isUserInteractionEnabled = true
                cell.lblUserName.addGestureRecognizer(userNameTapGesture)
                let userProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                cell.actionprofile.tag = indexPath.row
                cell.actionprofile.isUserInteractionEnabled = true
                cell.actionprofile.addGestureRecognizer(userProfileTapGesture)
                //Likes Action
                if objFeed.myLikeCount == 1{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLike.tag = indexPath.row
                    cell.actionLike.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                    cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLike.tag = indexPath.row
                    cell.actionLike.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                    cell.actionLike.addGestureRecognizer(likeTapGestureRecognizer)
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
                
                if objOwnUser?.id == objFeed.userId {
                    cell.oltRemovePost.isHidden = false
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    cell.oltRemovePost.isHidden = true
                }
                if objFeed.totalLikes > 0{
                    cell.oltLike.isSelected = true
                }else {
                    cell.oltLike.isSelected = false
                }
                return cell
            }else if objFeed.postType == "text"{
                let cell = CommonMethods.createFeedTextCell(tableView: tableView, objFeed: objFeed)
               
                let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                if(lang == "en")
                {
                    cell.lblUserName.textAlignment = .left
                }else
                {
                    cell.lblUserName.textAlignment = .right
                }
                cell.lblUserName.tag = indexPath.row
                cell.lblUserName.isUserInteractionEnabled = true
                cell.lblUserName.addGestureRecognizer(userNameTapGesture)
                let userProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                cell.actionprofile.tag = indexPath.row
                cell.actionprofile.isUserInteractionEnabled = true
                cell.actionprofile.addGestureRecognizer(userProfileTapGesture)
                newheight2 = 0.000
                
                let textView = UITextView()
                
                if objFeed.descriptionField != ""{
                    textView.clipsToBounds  = true
                    if(lang == "ar") //me
                    {
                        textView.textAlignment = .right
                        textView.contentMode = .right
                    }else
                    {
                        textView.textAlignment = .left
                        textView.contentMode = .left
                    }
                    textView.text = objFeed.descriptionField 
                    print(textView.text)
                    if textView.contentSize.height <= 0{
                        textView.contentSize.height = 10
                    }else{
                        textView.contentSize.height = 50
                    }
                }else{
                    textView.right = 0.0
                }
                
                newheight2 =  textView.contentSize.height
                /////////////////////////////////////////////////////////////
                
               // newheight = cell.lblStatus.height
                //Like action
                if objFeed.myLikeCount == 1{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLikes.tag = indexPath.row
                    cell.actionLikes.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                    cell.actionLikes.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTapped(tapGestureRecognizer:)))
                    cell.actionLikes.tag = indexPath.row
                    cell.actionLikes.isUserInteractionEnabled = true
                    cell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                    cell.actionLikes.addGestureRecognizer(likeTapGestureRecognizer)
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
                
                if objOwnUser?.id == objFeed.userId {
                    cell.oltRemovePost.isHidden = false
                    let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePost(tapGestureRecognizer:)))
                    cell.oltRemovePost.tag = indexPath.row
                    cell.oltRemovePost.isUserInteractionEnabled = true
                    cell.oltRemovePost.addGestureRecognizer(likeTapGestureRecognizer)
                }else{
                    cell.oltRemovePost.isHidden = true
                }
                if objFeed.totalLikes > 0{
                    cell.oltLike.isSelected = true
                }else {
                    cell.oltLike.isSelected = false
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let postID = arrayFeed[indexPath.row].id
//        guard let newData = postID else{return}
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
//        controller.postId = String(describing: newData)
//        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Cell Delegates
    
    @objc func btnFeedMoreImagesClick(_ sender : UIButton) {
        let index = sender.tag
        let objFeed = arrayFeed[index]
        if objFeed.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewsFeedMultipleImagesViewController") as! NewsFeedMultipleImagesViewController
            controller.newFeedData = objFeed
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func statusTapped(tapGestureRecognizer: UITapGestureRecognizer){
        segueTo(controller: .updateStatusViewController)
    }
    @objc  func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
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
    
    @objc func pictureTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
//        print(objFeed.postAttachment.path)
//        print(objFeed.postType)
        if objFeed.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewsFeedImageDisplayViewController") as! NewsFeedImageDisplayViewController
            controller.objFeed = objFeed
            self.present(controller, animated: false, completion: nil)
        }
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
    @objc func removePost (tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        
        self.showCustomAlert(message: "Are you sure you want to remove this post?".localized, postId: objFeed.id, index : index!)
    }
    @objc  func likesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        print(objFeed.id)
        if objFeed.myLikeCount == 0{
            arrayFeed[index!].totalLikes = objFeed.totalLikes + 1
            arrayFeed[index!].myLikeCount = objFeed.myLikeCount + 1
            let indexPath = IndexPath(item: index!, section: 2)
            if objFeed.postType == "image"{
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedImageCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                
                
                
                if arrayFeed[index!].totalLikes.toString != "0"{
                     currentCell.lblLike.text =  arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLike.text =   " Like".localized
                }
               
            }else if objFeed.postType == "video"{
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedImageCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                
                currentCell.myController = self
                currentCell.delegate = self
                let objOwnUser = UserHandler.sharedInstance.userData
                
                currentCell.setData(myId: objOwnUser!.id , userId: objFeed.userId, postId: objFeed.id)
                
                
                
                if arrayFeed[index!].totalLikes.toString != "0"{
                    currentCell.lblLike.text =  arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLike.text =   " Like".localized
                }
                
                
                
            }
            else if objFeed.postType == "text"{
                
    
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedTextCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                
                currentCell.myController = self
                currentCell.delegate = self
                 let objOwnUser = UserHandler.sharedInstance.userData
                
                currentCell.setData(myId: objOwnUser!.id , userId: objFeed.userId, postId: objFeed.id)
                
                if  arrayFeed[index!].totalLikes.toString != "0"{
                    currentCell.lblLikes.text =  arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLikes.text =   " Like".localized
                }
            }
            
        }else{
            arrayFeed[index!].totalLikes = objFeed.totalLikes - 1
            arrayFeed[index!].myLikeCount = objFeed.myLikeCount - 1
            let indexPath = IndexPath(item: index!, section: 2)
           
            if objFeed.postType == "image"{
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedImageCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                
                
                currentCell.myController = self
                currentCell.delegate = self
                let objOwnUser = UserHandler.sharedInstance.userData
                
                currentCell.setData(myId: objOwnUser!.id , userId: objFeed.userId, postId: objFeed.id)
                
                
                
                
                if  arrayFeed[index!].totalLikes.toString != "0"{
                    currentCell.lblLike.text = arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLike.text = " Like".localized
                }
                
                
                
            }
            else if objFeed.postType == "video"{
               
              
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedImageCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                
                currentCell.myController = self
                currentCell.delegate = self
                let objOwnUser = UserHandler.sharedInstance.userData
                
                currentCell.setData(myId: objOwnUser!.id , userId: objFeed.userId, postId: objFeed.id)
                
                if arrayFeed[index!].totalLikes.toString != "0"{
                    currentCell.lblLike.text = arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLike.text = " Like".localized
                }
                
                
            }
            
            else if objFeed.postType == "text"{
                
                
                let currentCell = tblView.cellForRow(at: indexPath) as! FeedTextCell
                currentCell.oltLike.setImage(#imageLiteral(resourceName: "greylike"), for: .normal)
                
                currentCell.myController = self
                currentCell.delegate = self
                let objOwnUser = UserHandler.sharedInstance.userData
                
                currentCell.setData(myId: objOwnUser!.id , userId: objFeed.userId, postId: objFeed.id)
                
                
                if  arrayFeed[index!].totalLikes.toString != "0"{
                    currentCell.lblLikes.text = arrayFeed[index!].totalLikes.toString + " Like".localized
                }else{
                    currentCell.lblLikes.text =  " Like".localized
                }
            }
            
        }
        
        self.likePost(postId: objFeed.id)
        //        let indexPath = IndexPath(item: index!, section: 2)
        //        let indexPath = IndexPath(item: index!, section: 2)
        //        if let visibleIndexPaths = tblView.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
        //            if visibleIndexPaths != NSNotFound {
        //                tblView.reloadRows(at: [indexPath], with: .none)
        //            }
        //        }
        
        //        let indexPath = IndexPath(item: index!, section: 2)
        //        tblView.reloadRows(at: [indexPath], with: .none)
        
        
    }
    @objc func commentsTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        self.goToComments(objFeed: objFeed)
    }
    @objc func sharesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = arrayFeed[index!]
        self.showActionSheetShare(postId: objFeed.id, index: index!)
    }
    
    func showShareConfirmationAlert(WithMsg _msg : String, Type _type : String ,PostId _postId : Int, Index _index : Int) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Share Post".localized, message: _msg, preferredStyle: .alert)
        // create an action
        let okAction: UIAlertAction = UIAlertAction(title: "Ok".localized, style: .default) { action -> Void in
            //print("Public Share")
            self.showSchedulingSharingAlert(Type:_type ,PostId: _postId, Index: _index)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func showSchedulingSharingAlert(Type _type : String, PostId _postId : Int, Index _index : Int) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Schedule Sharing".localized, message: "Do you want to schedule this share?".localized, preferredStyle: .alert)
        // create an action
        let okAction: UIAlertAction = UIAlertAction(title: "Yes".localized, style: .default) { action -> Void in
            let datePicker = ActionSheetDatePicker(title: "Schedule Post".localized, datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
                picker, value, index in
                
                self.sharePost(postId: _postId, sharingType: _type, rescheduleAt: (value as! Date))
                self.arrayFeed[_index].totalShares = self.arrayFeed[_index].totalShares + 1
                self.tblView.reloadData()
                return
            }, cancel: { ActionStringCancelBlock in return },
               origin: (self.view as AnyObject).superview!?.superview)
            datePicker?.minimumDate = Date()
            datePicker?.show()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "NO! JUST SHARE IT NOW".localized, style: .default) { action -> Void in
            self.sharePost(postId: _postId, sharingType: _type)
            self.arrayFeed[_index].totalShares = self.arrayFeed[_index].totalShares + 1
            self.tblView.reloadData()
        }
        
        // add actions
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func showActionSheetShare (postId: Int, index: Int){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option".localized, message: nil, preferredStyle: .actionSheet)
        // create an action
        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone".localized, style: .default) { action -> Void in
            print("Public Share".localized)
//            Do you really want to share this post as public post?
            self.showShareConfirmationAlert(WithMsg: "Do you really want to share this post as public post?".localized, Type : "public" ,PostId: postId, Index: index)
          }
        
        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends".localized, style: .default) { action -> Void in
            print("Friends share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to share this post with your friends?".localized, Type : "friends" ,PostId: postId, Index: index)
        }
        
        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline".localized, style: .default) { action -> Void in
            print("Time line share")
            self.showShareConfirmationAlert(WithMsg: "Do you really want to share this post on your timeline?".localized, Type : "private" ,PostId: postId, Index: index)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(sharePublic)
        actionSheetController.addAction(shareFriends)
        actionSheetController.addAction(shareTimeLine)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                galleryImage = image
        
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            {
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)
                
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.pngData()! as NSData
                data.write(toFile: localPath!, atomically: true)
                let imageData = NSData(contentsOfFile: localPath!)!
                let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!
                galleryImage = image
               
            
//                //photoEditor.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .left), dismissing: .pageOut(direction: .right))
//
//                _root.presentVC(photoEditor)
                
                gpuImageCapture(image)
              print(image)
                galleryImage = image
                
                
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        dismiss(animated: true, completion:{
            let photoEditor = PhotoEditorViewController(nibName: "PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.isHeroEnabled = true
            photoEditor.heroModalAnimationType = .auto
            photoEditor.image = self.galleryImage
            photoEditor.hiddenControls = [.crop, .share]
            self.presentVC(photoEditor)
        })
        
    }
        
    
    // MARK: - StoriesCellDegate
    func actionCreateStory(){
        
        let actionSheet: UIAlertController = UIAlertController(title: "Selection Option".localized, message: nil, preferredStyle: .actionSheet)
        // create an action
        let pickFromCamera: UIAlertAction = UIAlertAction(title: "Pick from Camera".localized, style: .default) { action -> Void in
            
            
            let controller = UIStoryboard.mainStoryboard.instantiateViewController(GPUImageCameraViewController.self)!
            controller.isMotionEnabled = true
            controller.isHeroEnabled = true
            controller.delegate = self
            controller.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .left), dismissing: .pageOut(direction: .right))
            
            self.presentVC(controller)
        }
        let pickFromGallery: UIAlertAction = UIAlertAction(title: "Pick from Gallery".localized, style: .default) { action -> Void in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
            
            //self.imageFromGallery()
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        actionSheet.addAction(pickFromCamera)
        actionSheet.addAction(pickFromGallery)
        actionSheet.addAction(cancelAction)
        present(actionSheet,animated: true,completion: nil)
        // let controller = self.storyboard?.instantiateViewController(withIdentifier: "SwiftyCameraViewController") as! SwiftyCameraViewController
        // self.navigationController?.pushViewController(controller, animated: true)
        
       
        
        //self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //var storiesController: ViewStoriesController?
    
    func actionViewStory (objStory: StoriesData) {
        let controller = UIStoryboard.mainStoryboard.instantiateVC(AllStoriesViewController.self)!
        controller.stories = [objStory]
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
        self.presentVC(controller)
        
//        //let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewStoriesController") as! ViewStoriesController
//        let storiesController = UIStoryboard.mainStoryboard.instantiateVC(StoriesViewController.self)!
//        storiesController.snapsArray = objStory.snaps
//        storiesController.user = objStory.user
//        storiesController.isMotionEnabled = true
//        storiesController.isHeroEnabled = true
//        storiesController.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
//        self.presentVC(storiesController)

    }
    
    @IBAction func btnWatchAll(_ sender: Any) {
        
        if arrayStories.count == 0 {
            return
        }
        
        let controller = UIStoryboard.mainStoryboard.instantiateVC(AllStoriesViewController.self)!
        controller.stories = arrayStories
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
        self.presentVC(controller)
    }
    // MARK: - API Calls
    func getStories (){
        FeedsHandler.getStories(success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.arrayStories = successResponse.data
                print(self.arrayStories.count)
                if self.arrayStories.count > 0 {
                    self.tblView.reloadData()
                }
            }else{
                self.showError(message: "No Stories")
                print("No stories Data")
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.showError(message: errorResponse!.message)
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: Get Newe Feeds
    func getNewsFeed (){
        let url = ApiCalls.baseUrlBuild + ApiCalls.getNewsFeed
        print(url)
        
        FeedsHandler.getNewsfeed(url: url,success: { (successResponse) in
            
            print(successResponse)
            if successResponse.statusCode == 200
            {
                self.arrayFeed = successResponse.data
                print(self.arrayFeed.count)
                self.objFeedPagination = successResponse.pagination
                self.refreshControl.endRefreshing()
                self.tblView.reloadData()
                //self.stopAnimating()
            }else{
                self.refreshControl.endRefreshing()
                print("No Feed data")
                self.showSuccess(message: "No Feed data")
               // self.stopAnimating()
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.refreshControl.endRefreshing()
            self.showError(message: errorResponse!.message)
            //self.stopAnimating()
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    // MARK: Get News Feed Next Page
    func getNewsFeedNextPage (){
        guard let url = self.objFeedPagination?.nextPageUrl else {
            return
        }
        FeedsHandler.getNewsfeed(url: url,success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                guard let newData = successResponse.data else{return}
                self.arrayFeed.append(contentsOf: newData)
                self.objFeedPagination = successResponse.pagination
                self.tblView.reloadData()
                //self.stopAnimating()
            }else{
                print("No Feed data")
                self.showError(message: "No Feed")
                //self.stopAnimating()
            }
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
            self.showError(message: errorResponse!.message)
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    func sharePost (postId: Int, sharingType: String, rescheduleAt : Date? = nil){
        var parameters : [String: Any] = [String: Any]()
        if let _date = rescheduleAt {
            let timeInterval = _date.timeIntervalSince1970 //.timeIntervalSince1970
            let localparameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType, "schedule_at": "\(Int(timeInterval))"]
            parameters = localparameters
        } else {
            let localparameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
            parameters = localparameters
        }
        
        //self.showLoader()
        
//        let parameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
        print(parameters)
        FeedsHandler.shareFeed(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            let message = successResponse["message"] as! String
            // self.showAlrt(message: message as! String)
            self.showSuccess(message: message)
            //self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            //self.stopAnimating()
            self.showError(message: errorResponse!.message)

            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    func likePost (postId: Int){
        //self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        print(parameters)
        FeedsHandler.postLike(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            //let message = successResponse["message"] as! String
            //self.showSuccess(message: message)
            // self.showAlrt(message: message as! String)
            //self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            self.showError(message: errorResponse!.message)
            //self.stopAnimating()
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    func removePost (postId : Int){
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        

        
        FeedsHandler.removePost(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            
            
//            for x in 0..<self.arrayFeed.count
//            {
//                if(self.arrayFeed[x].id == postId)
//                {
//                    self.arrayFeed.remove(at: x)
//                }
//            }
            
            //self.arrayFeed.removeAll()
            //self.tblView.reloadData()
            
            self.stopAnimating()
            
            let message = successResponse["message"] as! String
            self.showSuccess(message: message)
            //self.showAlrt(message: message)
            
            
            self.getNewsFeed()
        }) { (errorResponse) in
            self.showError(message: errorResponse!.message)
            self.stopAnimating()
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    // MARK: - Post Story
    func uploadStory(){
       // self.showLoader()
        let fileUrl : URL
        if FeedsHandler.sharedInstance.isVideoSelected {
            fileUrl = FeedsHandler.sharedInstance.selectedVideoUrl!
        } else{
            fileUrl = FeedsHandler.sharedInstance.selectedImageUrl!
        }
        let userName = UserHandler.sharedInstance.userData?.fullName
        //        let parameters : [String: Any] = ["name" : userName!]
        
        let names = ["name": userName!]
        let namesArray = "{" + names.description + "}"
        let parameters = ["values" : namesArray]
        //        let dic = ["type": "video", "filter_id": "-1"]
        //        parameters["values"] = dic.description
        
        //parameters = ["values" : ["type", "video", "filter_id", "-1"]]
        
        print(parameters)
        
        FeedsHandler.uploadStory(fileUrl: fileUrl, params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
            FeedsHandler.sharedInstance.isVideoSelected = false
            FeedsHandler.sharedInstance.isSelectdImage = false
            self.getStories()
            self.showSuccess(message: "Story Uploaded")
            
            //self.stopAnimating()
            
        }) { (errorResponse) in
            print(errorResponse!)
            self.showError(message: errorResponse!.message)
            //self.stopAnimating()
        }
    }
}

func convertDic() {
    let paramsArray = [ "one", "two" ]
    print(paramsArray)
    do {
        //Convert to Data
        let jsonData = try JSONSerialization.data(withJSONObject: paramsArray, options: JSONSerialization.WritingOptions.prettyPrinted)
        print(jsonData)
        //Convert back to string. Usually only do this for debugging
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    } catch {
        //print(error.description)
    }
}

extension NewsFeedViewController : GPUImageCameraDelegate {
    func gpuImageCapture(_ image: UIImage) {
        print(image)
//        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [top presentViewController:secondView animated:YES completion: nil];
        let photoEditor = PhotoEditorViewController(nibName: "PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.isHeroEnabled = true
        photoEditor.heroModalAnimationType = .auto
        photoEditor.image = image
        photoEditor.hiddenControls = [.crop, .share]
        
        photoEditor.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .left), dismissing: .pageOut(direction: .right))
        //_root.presentVC(photoEditor)
        presentVC(photoEditor)
//        if let _root = UIApplication.shared.keyWindow?.rootViewController {
//
//
//        }
    }
}



extension NewsFeedViewController:FeedImageCellDelegate  {
    func refreshTableView() {
      
        
        if FeedsHandler.sharedInstance.isStatusPosted {
            FeedsHandler.sharedInstance.isStatusPosted = false
            //self.showLoader()
            self.getNewsFeed()
            self.getStories()
        }
        else {
            self.getStories()
        }
    }
    
    
}

extension NewsFeedViewController:FeedTextCellDelegate  {
    func refreshFeedTextCellTableView() {
      
       
        
        if FeedsHandler.sharedInstance.isStatusPosted {
            FeedsHandler.sharedInstance.isStatusPosted = false
            //self.showLoader()
            self.getNewsFeed()
            self.getStories()
        }
        else {
           self.getStories()
        }
    }
    
    
}

