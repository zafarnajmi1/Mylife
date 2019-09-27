//
//  NewsFeedImageDisplayViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 11/20/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView
import ImageScrollView
import ActionSheetPicker_3_0

class NewsFeedImageDisplayViewController: UIViewController, NVActivityIndicatorViewable,UIScrollViewDelegate {
    
    @IBOutlet weak var newsFeedImage: UIImageView!

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var oltLike: UILabel!
    @IBOutlet weak var oltComment: UILabel!
    @IBOutlet weak var oltShare: UILabel!
    @IBOutlet weak var oltDownloadImage: UIButton!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var newFeedImageScrollView: UIScrollView!
    
    var objFeed : NewsFeedData?
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.newsFeedImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        //        newFeedImageScrollView = UIScrollView()
        //        newFeedImageScrollView.delegate = self
        newFeedImageScrollView.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        newFeedImageScrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        newFeedImageScrollView.alwaysBounceVertical = false
        newFeedImageScrollView.alwaysBounceHorizontal = false
        newFeedImageScrollView.showsVerticalScrollIndicator = true
        newFeedImageScrollView.flashScrollIndicators()
        
        newFeedImageScrollView.minimumZoomScale = 1.0
        newFeedImageScrollView.maximumZoomScale = 10.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        newFeedImageScrollView.addGestureRecognizer(doubleTapGest)
        // Do any additional setup after loading the view.
        
        newsFeedImage.sd_setImage(with: URL(string: (objFeed?.postAttachment.path)!), placeholderImage: UIImage(named: "placeHolderGenral"))                  //need to uncomment this line
        
        newsFeedImage.sd_setShowActivityIndicatorView(true)
        newsFeedImage.sd_setIndicatorStyle(.gray)
        newsFeedImage.clipsToBounds = true
        userProfilePicture.sd_setImage(with: URL(string: (objFeed?.user.image)!), placeholderImage: UIImage(named: "placeHolderGenral"))
        userProfilePicture.sd_setShowActivityIndicatorView(true)
        userProfilePicture.sd_setIndicatorStyle(.gray)
        userProfilePicture.clipsToBounds = true
        //newsFeedImageScrollView.display(image: newsFeedImage.image ?? UIImage(named: "placeHolderGenral")!)
        
//        oltLike.text = (objFeed?.totalLikes!.toString)! + "  Like"
//        oltComment.text = (objFeed?.totalComments!.toString)! + "  Comment"
//        oltShare.text = (objFeed?.totalShares!.toString)! + "  Share"
//
        if (objFeed?.totalLikes!.toString)! != "0"{
            oltLike.text = (objFeed?.totalLikes!.toString)! + "  Like"
        }else{
            oltLike.text =  "  Like"
        }
       
        if  (objFeed?.totalComments!.toString)! != "0"{
            oltComment.text = (objFeed?.totalComments!.toString)! + "  Comment"
        }else{
            oltComment.text =  "  Comment"
        }
        
        if  (objFeed?.totalShares!.toString)! != "0"{
            oltShare.text = (objFeed?.totalShares!.toString)! + "  Share"
        }else{
            oltShare.text =  "  Share"
        }
        
        userName.text = (objFeed?.user.fullName)!
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval((objFeed?.createdAt.toDouble)!))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        postTime.text = String(describing: date)
        if objFeed?.descriptionField != ""{
            postText.text = objFeed?.descriptionField
            postText.isHidden=false
        }else{
            postText.isHidden=true
        }
        
//        let imageRecord = UIImage (named: "saveIMG")
//        let tintedImageRecord = imageRecord?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        oltDownloadImage.setImage(tintedImageRecord, for: .normal)
//        oltDownloadImage.tintColor = UIColor.white
    }

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if newFeedImageScrollView.zoomScale == 1 {
            newFeedImageScrollView.zoom(to: zoomRectForScale(scale: newFeedImageScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            newFeedImageScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = newsFeedImage.frame.size.height / scale
        zoomRect.size.width  = newsFeedImage.frame.size.width  / scale
        let newCenter = newsFeedImage.convert(center, from: newFeedImageScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!".localized, message: "Picture has been saved to your photos".localized, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK:- Api Calls
    
    func likePost (postId: Int){
        //self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        print(parameters)
        FeedsHandler.postLike(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            _ = successResponse["message"]
            // self.showAlrt(message: message as! String)
            self.stopAnimating()
            
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    func goToComments (objFeed: NewsFeedData){
        
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
    func sharePost (postId: Int, sharingType: String){
        self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)" , "sharing_type": sharingType]
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
    
    
    func showActionSheetShare (postId: Int, index: Int){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option", message: nil, preferredStyle: .actionSheet)
        // create an action
        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone", style: .default) { action -> Void in
            print("Public Share")
            //            Do you really want to share this post as public post?
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
                
                self.sharePost(postId: _postId, sharingType: _type, rescheduleAt: (value as! Date))
               // self.arrayFeed[_index].totalShares = self.arrayFeed[_index].totalShares + 1
               // self.tblView.reloadData()
                guard let newData = self.objFeed else{return}
                self.objFeed?.totalShares = newData.totalShares + 1
                
                if  (self.objFeed?.totalShares!.toString)! != "0"{
                    self.oltShare.text = (self.objFeed?.totalShares!.toString)! + " Share"
                }else{
                    self.oltShare.text =  " Share"
                }
                return
            }, cancel: { ActionStringCancelBlock in return },
               origin: (self.view as AnyObject).superview!?.superview)
            datePicker?.minimumDate = Date()
            datePicker?.show()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "NO! JUST SHARE IT NOW", style: .default) { action -> Void in
            self.sharePost(postId: _postId, sharingType: _type)
            guard let newData = self.objFeed else{return}
            self.objFeed?.totalShares = newData.totalShares + 1
            
            if  (self.objFeed?.totalShares!.toString)! != "0"{
                self.oltShare.text = (self.objFeed?.totalShares!.toString)! + " Share"
            }else{
                self.oltShare.text =  " Share"
            }
           // self.arrayFeed[_index].totalShares = self.arrayFeed[_index].totalShares + 1
           // self.tblView.reloadData()
        }
        
        // add actions
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
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
    
    //---Commented by Imran
//    func showActionSheetShare (postId: Int){
//        guard let newData = objFeed else{return}
//        // create an actionSheet
//        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option", message: nil, preferredStyle: .actionSheet)
//        // create an action
//        let sharePublic: UIAlertAction = UIAlertAction(title: "Share with everyone", style: .default) { action -> Void in
//            print("Public Share")
//            self.sharePost(postId: postId, sharingType: "public")
//            self.objFeed?.totalShares = newData.totalShares + 1
//
//            if  (self.objFeed?.totalShares!.toString)! != "0"{
//                self.oltShare.text = (self.objFeed?.totalShares!.toString)! + " Share"
//            }else{
//                self.oltShare.text =  " Share"
//            }
//
//        }
//
//        let shareFriends: UIAlertAction = UIAlertAction(title: "Share with friends", style: .default) { action -> Void in
//            print("Friends share")
//            self.sharePost(postId: postId, sharingType: "friends")
//            self.objFeed?.totalShares = newData.totalShares + 1
//
//
//            if (self.objFeed?.totalShares!.toString)! != "0"{
//                 self.oltShare.text = (self.objFeed?.totalShares!.toString)! + " Share"
//            }else{
//                self.oltShare.text =  " Share"
//            }
//
//        }
//
//        let shareTimeLine: UIAlertAction = UIAlertAction(title: "Share on my timeline", style: .default) { action -> Void in
//            print("Time line share")
//            self.sharePost(postId: postId, sharingType: "private")
//            self.objFeed?.totalShares = newData.totalShares + 1
//            if (self.objFeed?.totalShares!.toString)!  != "0"{
//                 self.oltShare.text = (self.objFeed?.totalShares!.toString)! + " Share"
//            }else{
//                self.oltShare.text = " Share"
//            }
//
//
//        }
//
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
//    }
    
    
    //MARK:- IBAction
    @IBAction func actionCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionLike(_ sender: Any) {
        guard let newData = objFeed else{return}
        print(newData.id)
        
        if newData.myLikeCount == 0{
            objFeed?.totalLikes = newData.totalLikes + 1
            objFeed?.myLikeCount = newData.myLikeCount + 1
            if (objFeed?.totalLikes!.toString)! != "0"{
                oltLike.text = (objFeed?.totalLikes!.toString)! + " Like".localized
            }else{
                oltLike.text =  " Like".localized
            }
            
        }else{
            objFeed?.totalLikes = newData.totalLikes - 1
            objFeed?.myLikeCount = newData.myLikeCount - 1
            if (objFeed?.totalLikes!.toString)! != "0"{
                oltLike.text = (objFeed?.totalLikes!.toString)! + " Like".localized
            }else{
                oltLike.text =  " Like".localized
            }
        }
        
        self.likePost(postId: newData.id)
    }
    @IBAction func actionComments(_ sender: Any) {
        guard let newData = objFeed else{return}
        self.goToComments(objFeed: newData)
    }
    @IBAction func actionShare(_ sender: Any) {
        guard let newData = objFeed else{return}
        print(newData.id)
        
        self.showActionSheetShare(postId: newData.id, index: 0)
    }
    
    @IBAction func actionSaveImage(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(newsFeedImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
}
