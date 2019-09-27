//
//  EditMySchedulePostViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.

//

//EditMySchedulePostViewController

import UIKit
import Material
import DropDown
import ActionSheetPicker_3_0
import Fusuma
import Hero
import NVActivityIndicatorView
import ImagePicker
import Lightbox
import AVFoundation
import AVKit
import MobileCoreServices
import Alamofire

extension SegueIdentifiable {
    static var editMySchedulePostViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: EditMySchedulePostViewController.className)
    }
}

class EditMySchedulePostViewController: UIViewController, NVActivityIndicatorViewable, ImagePickerDelegate {
    let placeHolderText =  "Whats on your mind?".localized
    
    @IBOutlet var textViewStatus: UITextView! {
        didSet {
            //            textViewStatus.borderColor = UIColor.white
            //            textViewStatus.borderWidth = 0
            //            textViewStatus.layer.borderWidth = 0.0
        }
    }
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    //New Outlets start
    @IBOutlet weak var showImagesView: UIView!
    @IBOutlet weak var selectedImageViewOne: UIImageView!
    @IBOutlet weak var selectedImageViewTwo: UIImageView!
    @IBOutlet weak var selectedImageViewThree: UIImageView!
    @IBOutlet weak var statusTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageAndTextShowMainView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesCountLabel: UILabel!
    var selectedPost : NewsFeedData?
    @IBOutlet weak var deleteVideoThumbnailButtonOutlet: UIButton!
     @IBOutlet var playVideoButton: UIButton!
    var arrayOfDates = [String]()
    var arrayOfDatesInInteger = [Int]()
    
    //NEw outlets end
    func imagesAreNotSelected(){
        statusTextViewTopConstraint.constant = 0
        showImagesView.isHidden=true
        heightConstraint.constant = 70
    }
    @IBAction func deleteVideoThumbnailButtonAction(_ sender: Any) {
        FeedsHandler.sharedInstance.isVideoSelected = false
        deleteVideoThumbnailButtonOutlet.isHidden=true
        playVideoButton.isHidden=true
        selectedImageViewOne.layer.width = 215.0
        selectedImageViewOne.layer.height = 157.0
        EditMySchedulePostViewController.arrayOfImages.removeAll()
        EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
        imagesAreSelected()
    }
    func imagesAreSelected(){
        
        statusTextViewTopConstraint.constant = 145
        showImagesView.isHidden=false
        heightConstraint.constant = 255
        
        if EditMySchedulePostViewController.arrayOfImages.count==0{
            imagesAreNotSelected()
        }else if EditMySchedulePostViewController.arrayOfImages.count==1{
            selectedImageViewOne.isHidden=false
            selectedImageViewOne.image = EditMySchedulePostViewController.arrayOfImages[0]
            
            selectedImageViewTwo.isHidden=true
            selectedImageViewThree.isHidden=true
            imagesCountLabel.isHidden=true
            
        }else if EditMySchedulePostViewController.arrayOfImages.count==2{
            selectedImageViewOne.isHidden=false
            selectedImageViewOne.image = EditMySchedulePostViewController.arrayOfImages[0]
            selectedImageViewTwo.isHidden=false
            selectedImageViewTwo.image = EditMySchedulePostViewController.arrayOfImages[1]
            selectedImageViewThree.isHidden=true
            imagesCountLabel.isHidden=true
            
        }else if EditMySchedulePostViewController.arrayOfImages.count==3{
            selectedImageViewOne.isHidden=false
            selectedImageViewOne.image = EditMySchedulePostViewController.arrayOfImages[0]
            selectedImageViewTwo.isHidden=false
            selectedImageViewTwo.image = EditMySchedulePostViewController.arrayOfImages[1]
            selectedImageViewThree.isHidden=false
            selectedImageViewThree.image = EditMySchedulePostViewController.arrayOfImages[2]
            imagesCountLabel.isHidden=true
        }else if EditMySchedulePostViewController.arrayOfImages.count>3{
            selectedImageViewOne.isHidden=false
            selectedImageViewOne.image = EditMySchedulePostViewController.arrayOfImages[0]
            selectedImageViewTwo.isHidden=false
            selectedImageViewTwo.image = EditMySchedulePostViewController.arrayOfImages[1]
            selectedImageViewThree.isHidden=false
            selectedImageViewThree.image = EditMySchedulePostViewController.arrayOfImages[2]
            imagesCountLabel.isHidden=false
            let count = EditMySchedulePostViewController.arrayOfImages.count - 3
            imagesCountLabel.text = "+ " + String(count) + "More"
        }
        
    }
    
    
    @IBOutlet weak var topConstraintName: NSLayoutConstraint!
    @IBOutlet weak var topConstraintFriendsView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintStatus: NSLayoutConstraint!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var childView: [UIView]!
    
    @IBOutlet var labelStatusPrivacy: UILabel!
    @IBOutlet weak var scheduleMultiplePostsLabel: UILabel!
    
    @IBOutlet var buttonPrivacyDropDown: UIButton!
    
    @IBOutlet var schedulePostContainer: UIView!
    
    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var lblFeelingDetail: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var oltRemoveFeeling: UIButton!
    @IBOutlet weak var oltRemoveCheckin: UIButton!
    
    @IBOutlet weak var lblTagFriends: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var oltRemoveSelectedImage: UIButton!
    
    @IBOutlet weak var oltRemoveTags: UIButton!
    
    @IBOutlet weak var oltRemoveScheduledTimes: UIButton!
    
    var videoURL: URL?
    var isImageSelected = false
    var isVideoSelected = false
    var isVideoSelectedFromGallery = false
    var imagePickerController = UIImagePickerController()
    var isKeyboardOpened = false
    let postPrivacyDropDown = DropDown()
    var selectedSharingType = 0
    let imagePicker = UIImagePickerController()
    var pickedImnageUrl: URL?
    var thumnailUrl: URL?
    static var arrayOfImages = [UIImage]()
    static var arrayOfImagesURLS = [URL]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        imagesAreNotSelected()
        self.addPostButton()
        self.setInitialConstraints()
        
        Timer.after(0.0.seconds) {
            UIView.animate(withDuration: 0.0) {
                self.animateBottomViews()
                self.title = "Write Post".localized
            }
        }
        populateData()
    }
    
    @IBAction func removeScheduledTimesButtonActioon(_ sender: Any) {
        print("remove scheduled button pressed")
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "scheduledDates")
        userDefaults.removeObject(forKey: "scheduledIntegerDates")
        oltRemoveScheduledTimes.isHidden=true
        scheduleMultiplePostsLabel.text = "Schedule Post"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        textViewStatus.becomeFirstResponder()
        showStatusBar()
        imagesAreSelected()
        if(lang == "ar")
        {
        textViewStatus.textAlignment = .right
        
        }else
        {
            textViewStatus.textAlignment = .left
        }
        let userDefaults = UserDefaults.standard
        let arrayOfDates =  userDefaults.value(forKey: "scheduledDates") as? [String] ?? [String]()
        var stringOfDates = "Schedule Post"
        
        for date in arrayOfDates {
            print("total dates are",date)
            
//            let dateformatter = DateFormatter()
//            let datee = dateformatter.date(from: date)
//            dateformatter.dateStyle = DateFormatter.Style.medium
//            dateformatter.timeStyle = DateFormatter.Style.medium
//            let dateee = dateformatter.string(from: datee!)
           // let datee = dateformatter.string(from: date as! Date)
            stringOfDates.append(","+date)
            
        }
        
        if stringOfDates != "Schedule Post"   {
            scheduleMultiplePostsLabel.text = stringOfDates
            oltRemoveScheduledTimes.isHidden=false
        }else{
            scheduleMultiplePostsLabel.text = "Schedule Post"
            oltRemoveScheduledTimes.isHidden=true
        }
        
        
        if FeedsHandler.sharedInstance.isVideoSelected{
            //            textViewStatus.text = "Video Added"
            isVideoSelected = true
        }
        if FeedsHandler.sharedInstance.isSelectdImage {
            self.pickedImnageUrl = FeedsHandler.sharedInstance.selectedImageUrl
            self.isImageSelected = true
            
            imgSelected.image = FeedsHandler.sharedInstance.selectedImage
            imagesAreSelected()
            imgSelected.isHidden = false
            oltRemoveSelectedImage.isHidden = false
        }
        
        if FeedsHandler.sharedInstance.isFeelingSelected {
            //print(FeedsHandler.sharedInstance.objFeeling?.translation.title!)
            let objfeelig = FeedsHandler.sharedInstance.objFeeling
            oltRemoveFeeling.isHidden = false
//            topConstraintName.constant = 8
//            topConstraintFriendsView.constant = 8
            imgFeeling.isHidden = false
            lblFeelingDetail.isHidden = false
            
            if let profileImageUrl = objfeelig?.emoji{
                imgFeeling.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "user"))
                imgFeeling.sd_setShowActivityIndicatorView(true)
                imgFeeling.sd_setIndicatorStyle(.gray)
                imgFeeling.contentMode = .scaleAspectFill
                imgFeeling.clipsToBounds = true
            }
            lblFeelingDetail.text = "Feeling " + (objfeelig?.translation.title!)!
        }
        
        if FeedsHandler.sharedInstance.isPlaceSelected{
            lblCheckIn.isHidden = false
            oltRemoveCheckin.isHidden = false
            
            let objSelectedPlace = FeedsHandler.sharedInstance.selectedPlace
            let locationName: String = (objSelectedPlace?.name)!
            lblCheckIn.text = "Checked into " + locationName
            lblCheckIn.font = CommonMethods.getFontOfSize(size: 14)
        }
        
        if FeedsHandler.sharedInstance.isFriendsTagged {
            self.oltRemoveTags.isHidden = false
            
            self.idsArray.removeAll()
            var namesArray = [String]()
            if self.idsArray.count == 0{
                for (index, item)  in FeedsHandler.sharedInstance.taggedFriends!.enumerated(){
                    namesArray.append(item.fullName)
                    self.idsArray.append(item.id)
                    
                    // let keyString = "friends[\(index)]"
                    //                    taggedFriendsDictionary = [
                    //                       // keyString :item.id
                    //                        "friends[\(index)]" = item.id
                    //                    ]
                }
                
            }
            //  print(taggedFriendsDictionary)
            
            print(namesArray)
            print(idsArray)
            let namesString = namesArray.joined(separator: ", ")
            lblTagFriends.text = "TAGGED: " + namesString
            
        }
    }
    var selectedIdString = ""
    var idsArray = [Int]()
    var taggedFriendsDictionary = [String: Int]()
    
    var taggedFriendsJsonString = ""
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        textViewStatus.becomeFirstResponder()
        

        if MySchedulesViewController.isCameFromMySchedulePostViewController==true{
//            EditMySchedulePostViewController.arrayOfImages.removeAll()
//            EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
            MySchedulesViewController.isCameFromMySchedulePostViewController=false
            if selectedPost?.postType=="text"{
                imagesAreNotSelected()
                arrayOfDatesInInteger.removeAll()
                arrayOfDates.removeAll()
                textViewStatus.text = selectedPost?.descriptionField
                if let _abc = selectedPost, let _scheduleAt = selectedPost?.scheduleAt {
                    
                    let timeInterval = Double(_scheduleAt)
                    let myNSDate = Date(timeIntervalSince1970: timeInterval)
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = DateFormatter.Style.medium
                    dateformatter.timeStyle = DateFormatter.Style.medium
                    let date = dateformatter.string(from: myNSDate)
                    
                    arrayOfDatesInInteger.append(_scheduleAt)
                    arrayOfDates.append(String(describing: date))
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(arrayOfDatesInInteger, forKey: "scheduledIntegerDates")
                    userDefaults.set(arrayOfDates, forKey: "scheduledDates")
                    scheduleMultiplePostsLabel.text = "Schedule Post \(date)"
                    textViewStatus.text = selectedPost?.descriptionField
                    oltRemoveScheduledTimes.isHidden=false
                }
                //scheduleMultiplePostsLabel.text = "\(selectedPost?.scheduleAt!!)"
                print("text",scheduleMultiplePostsLabel.text)
                
                //scheduleMultiplePostsLabel.text = String(describing: selectedPost?.scheduleAt!)
                imgFeeling.isHidden = false
                lblFeelingDetail.isHidden = false
                
                lblCheckIn.text = selectedPost?.checkinPlace
                if let _feelingss = selectedPost?.feeling.id{
                    lblFeelingDetail.text  = "Feeling " + (selectedPost?.feeling.translation.title)! //.emoji
                }else{
                    lblFeelingDetail.text = ""
                }
                
            }else if selectedPost?.postType=="image"{
                self.showLoader()
                isImageSelected = true
               
                arrayOfDatesInInteger.removeAll()
                arrayOfDates.removeAll()
                textViewStatus.text = selectedPost?.descriptionField
                if let _abc = selectedPost, let _scheduleAt = selectedPost?.scheduleAt {
                    
                    let timeInterval = Double(_scheduleAt)
                    let myNSDate = Date(timeIntervalSince1970: timeInterval)
                    
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = DateFormatter.Style.medium
                    dateformatter.timeStyle = DateFormatter.Style.medium
                    let date = dateformatter.string(from: myNSDate)
                    
                    
                    
                    
                    arrayOfDatesInInteger.append(_scheduleAt)
                    arrayOfDates.append(String(describing: date))
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(arrayOfDatesInInteger, forKey: "scheduledIntegerDates")
                    userDefaults.set(arrayOfDates, forKey: "scheduledDates")
                    scheduleMultiplePostsLabel.text = "Schedule Post \(date)"
                    textViewStatus.text = selectedPost?.descriptionField
                    oltRemoveScheduledTimes.isHidden=false
                }
                //scheduleMultiplePostsLabel.text = "\(selectedPost?.scheduleAt!!)"
                print("text",scheduleMultiplePostsLabel.text)
                
                //scheduleMultiplePostsLabel.text = String(describing: selectedPost?.scheduleAt!)
                lblCheckIn.text = selectedPost?.checkinPlace
                imgFeeling.isHidden = false
                lblFeelingDetail.isHidden = false
                //imgFeeling.image = selectedPost?.feeling.emoji .emoji//.translation.title
                imgFeeling.sd_setImage(with: URL(string: (selectedPost?.feeling.emoji)!), placeholderImage: UIImage(named: "placeHolderGenral"))
                lblFeelingDetail.text  = "Feeling " + (selectedPost?.feeling.translation.title)! //.emoji
                
                
//                arrayOfDatesInInteger.removeAll()
//                arrayOfDates.removeAll()
                EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
                EditMySchedulePostViewController.arrayOfImages.removeAll()
                
                for attachment in (selectedPost?.postAttachmentData)! {
                    print("attachment url.. ",attachment.path )
                    let url = URL(string: attachment.path)
                    let imageView = UIImageView()
                    imageView.sd_setImage(with: url, completed: { (img, error , cacheType , imgUrl) in
                        if let _img = img {
                            EditMySchedulePostViewController.arrayOfImagesURLS.append(imgUrl!)
                            EditMySchedulePostViewController.arrayOfImages.append(_img)
                        }
                    })
                }
                
               imagesAreSelected()
                
                textViewStatus.text = selectedPost?.descriptionField
                let timeInterval = Double((selectedPost?.scheduleAt)!)
                let myNSDate = Date(timeIntervalSince1970: timeInterval)
               
                let userDefaults = UserDefaults.standard
                userDefaults.set(arrayOfDatesInInteger, forKey: "scheduledIntegerDates")
                userDefaults.set(arrayOfDates, forKey: "scheduledDates")
                
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.medium
                dateformatter.timeStyle = DateFormatter.Style.medium
                let date = dateformatter.string(from: myNSDate)
                
                arrayOfDatesInInteger.append((selectedPost?.scheduleAt)!)
                arrayOfDates.append(String(describing: date))
                
                scheduleMultiplePostsLabel.text = "Schedule Post \(date)"
                lblCheckIn.text = selectedPost?.checkinPlace
                oltRemoveScheduledTimes.isHidden=false
                lblFeelingDetail.text  = "Feeling " + (selectedPost?.feeling.translation.title)!//.emoji
                for friend in (selectedPost?.tagFriends)! {
                    lblTagFriends.text = lblTagFriends.text! + ", \(friend.fullName)"
                }
               
                
            }
            self.stopAnimating()
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom
    func populateData (){
        let objUser = UserHandler.sharedInstance.userData
        
        if let profileImageUrl = objUser?.image{
            imgUser.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "user"))
            imgUser.sd_setShowActivityIndicatorView(true)
            imgUser.sd_setIndicatorStyle(.gray)
            imgUser.contentMode = .scaleAspectFill
            imgUser.clipsToBounds = true
            imgUser.layer.cornerRadius = imgUser.size.width/2
            
        }
        //lblName.text = objUser?.fullName
        lblName.text = "You".localized
        
        if(selectedPost?.sharingType == "public")
        {
            labelStatusPrivacy.text = "Public".localized
            selectedSharingType = 0
        }
        if(selectedPost?.sharingType == "friends")
        {
            labelStatusPrivacy.text = "Friends Only".localized
             selectedSharingType = 1
        }
        if(selectedPost?.sharingType == "private")
        {
            selectedSharingType = 2
            labelStatusPrivacy.text = "On my timeline".localized
        }
        lblName.font = CommonMethods.getFontOfSize(size: 14)
        
    }
    
    func setInitialConstraints (){
        //        topConstraintName.constant = 25
        //        topConstraintFriendsView.constant = -10
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    func addPostButton() {
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.setTitle("UPDATE".localized, for: .normal)
        btn1.setTitleColor(.white, for: .normal)
        btn1.titleLabel?.font = CommonMethods.getFontOfSize(size: 16)
        btn1.addTarget(self, action: #selector(self.onPostClick), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }
    
    @objc func onPostClick() {
        print("Post")
        if textViewStatus.text.characters.count > 0 {
            if isImageSelected || isVideoSelected || isVideoSelectedFromGallery {
                self.postStatusWithImage()
            }else{
                if textViewStatus.text == placeHolderText{
                    self.showAlrt(message: "Please write what's on your mind".localized)
                }else{
                    self.postStatus()
                }
            }
        }else{
            self.showAlrt(message: "Please write what's on your mind".localized)
        }
        
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    func showCustomAlert (message: String){
        let alertController = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.onBackButtonClciked()
            FeedsHandler.sharedInstance.isStatusPosted = true
            
        }
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    func saveFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "CommentPicture".localized, extention: ".jpg") {
            
            self.pickedImnageUrl = savedUrl
            EditMySchedulePostViewController.arrayOfImagesURLS.append(pickedImnageUrl!)
            self.isImageSelected = true
        }
    }
    
    func saveThumnailFileToDocumentsDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "CommentPicture", extention: ".jpg") {
            self.thumnailUrl = savedUrl
            self.isImageSelected = true
        }
    }
    
    // MARK: - Action
    
    @IBAction func onButtonStatusPrivacyClicked(_ sender: UIButton) {
        showPostPrivacyDropDown()
    }
    
    @IBAction func onButtonAddPhotosClicked(_ sender: UIButton) {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 50
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        /*
         imagePicker.allowsEditing = false
         imagePicker.sourceType = .photoLibrary
         present(imagePicker, animated: true, completion: nil)
         */
        /*
         let fusuma = FusumaViewController()
         fusumaBackgroundColor = .primary
         fusumaTintColor = .primaryDark
         fusumaTitleFont = UIFont.semiBold
         
         fusuma.cropHeightRatio = 0.6 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
         fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
         self.present(fusuma, animated: true, completion: nil)
         */
    }
    
    @IBAction func onButtonAddVideoClicked(_ sender: UIButton) {
        //segueTo(controller: .gothamCameraController)
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Selection Option".localized, message: nil, preferredStyle: .actionSheet)
        // create an action
        let selectPhotoes: UIAlertAction = UIAlertAction(title: "Select Video From Gallery".localized, style: .default) { action -> Void in
            self.openImgPicker()
        }
        
        let selectVideos: UIAlertAction = UIAlertAction(title: "Open Video Camera".localized, style: .default) { action -> Void in
            self.segueTo(controller: .swiftyCameraViewController)
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(selectPhotoes)
        actionSheetController.addAction(selectVideos)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
        
        
        //        let controller = UIStoryboard.mainStoryboard.instantiateViewController(GPUImageCameraViewController.self)!
        //        controller.modalPresentationStyle = .overFullScreen
        //        controller.isMotionEnabled = true
        //        controller.motionModalTransitionType = .autoReverse(presenting: .auto)
        //        presentVC(controller)
        
        //        self.showAlrt(message: "In Process")
        
    }
    
    @IBAction func onButtonAddFeelingClicked(_ sender: UIButton) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeelingsViewController") as! FeelingsViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        //                let cameraController = UIStoryboard.mainStoryboard.instantiateViewController(SwiftyCameraViewController.self)!
        //                cameraController.isHeroEnabled = true
        //        //
        //                let galleryController = UIStoryboard.mainStoryboard.instantiateVC(SwiftyGalleryNavigationController.self)!
        //                galleryController.isHeroEnabled = true
        ////        //
        //                let leftController = UIViewController()
        //                leftController.view.backgroundColor = .primary
        //        //
        //                let containerController = SnapContainerViewController.containerViewWith(leftController, middleVC: cameraController, rightVC: leftController, topVC: nil, bottomVC: galleryController)
        //                containerController.isHeroEnabled = true
        //        //
        //                self.presentVC(containerController)
        
        //        let controller = UIStoryboard.mainStoryboard.instantiateViewController(GPUImageCameraViewController.self)!
        //        controller.modalPresentationStyle = .overFullScreen
        //        controller.isMotionEnabled = true
        //        controller.motionModalTransitionType = .autoReverse(presenting: .auto)
        //        presentVC(controller)
    }
    
    @IBAction func onButtonCheckInClicked(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onButtonTagFriendsClicked(_ sender: UIButton) {
        segueTo(controller: .tagFriendsViewController)
    }
    
    @IBAction func onButtonSchedulePostClicked(_ sender: UIButton) {
        //showDatePicker()
        goToScheduleMultipleScreen()
    }
    
    func goToScheduleMultipleScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scheduleMultplePostViewController = storyboard.instantiateViewController(withIdentifier: "ScheduleMultiplePostsViewController") as! ScheduleMultiplePostsViewController
        present(scheduleMultplePostViewController, animated: true, completion: nil)
    }
    
    @IBAction func onButtonScheduleBirthdayClicked(_ sender: Any) {
        print("schedule birthday button pressed ")
        goToScheduleBirthdayScreen()
    }
    func goToScheduleBirthdayScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scheduleBirthdayScreen = storyboard.instantiateViewController(withIdentifier: "UpdateStatusScheduleBirthdayTableViewController") as! UpdateStatusScheduleBirthdayTableViewController
        present(scheduleBirthdayScreen, animated: true, completion: nil)
    }
    
    @IBAction func actionRemoveFeeling(_ sender: Any) {
        FeedsHandler.sharedInstance.isFeelingSelected = false
        FeedsHandler.sharedInstance.objFeeling = nil
        setInitialConstraints()
        imgFeeling.isHidden = true
        lblFeelingDetail.isHidden = true
        oltRemoveFeeling.isHidden = true
        
    }
    
    @IBAction func actionRemoveCheckin(_ sender: Any) {
        FeedsHandler.sharedInstance.isPlaceSelected = false
        FeedsHandler.sharedInstance.selectedPlace = nil
        
        lblCheckIn.isHidden = true
        oltRemoveCheckin.isHidden = true
    }
    @IBAction func actionRemoveSelectedImage(_ sender: Any) {
        oltRemoveSelectedImage.isHidden = true
        imgSelected.image = nil
        imgSelected.isHidden = true
        
    }
    
    @IBAction func actionRemoveTags(_ sender: Any) {
        FeedsHandler.sharedInstance.taggedFriends = nil
        FeedsHandler.sharedInstance.isFriendsTagged = false
        
        lblTagFriends.text = "Tag Friends"
        oltRemoveTags.isHidden = true
    }
    // MARK: - UIImagePickerControllerDelegate Methods
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
        print("Done Button = ",images)
        EditMySchedulePostViewController.arrayOfImages.removeAll()
        EditMySchedulePostViewController.arrayOfImages = images
        
        imagesAreSelected()
        
        
        imgSelected.image = images[0]
        imgSelected.isHidden = true
        oltRemoveSelectedImage.isHidden = true
        
        for image in images {
            saveFileToDocumentsDirectory(image: image)
        }
        
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    func imagePickerControllerDidCancel(picker: ImagePickerController!)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: - Video Browser function
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    /*
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     NSLog("\(info)")
     if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
     imgSelected.image = image
     imgSelected.isHidden = false
     oltRemoveSelectedImage.isHidden = false
     self.saveFileToDocumentsDirectory(image: image)
     
     dismiss(animated: true, completion: nil)
     }
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     dismiss(animated: true, completion: nil)
     }
     
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let controller = segue.destination as? SwiftyCameraViewController {
     controller.isHeroEnabled = true
     }
     }*/
    
    // MARK: - API Call
    
    func postStatus (){
        self.showLoader()
        let userDefaults = UserDefaults.standard
        var integerDates = userDefaults.value(forKey: "scheduledIntegerDates") as? [Int] ?? [Int]()
        print("new integer datessss",integerDates)
        if integerDates.count==0{
            integerDates = [0]
        }
        
        //        for var i in 0..<integerDates.count {
        var feelingId = 0
        
        if FeedsHandler.sharedInstance.objFeeling != nil{
            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        }
        
        var lat: Double = 0.00
        var long: Double = 0.00
        var selectedPlace = ""
        var scheduleTime = [Int]()
        if integerDates.count != 0{
            scheduleTime = integerDates             //Int(stringToScheduleTime)    //0
        }else{
            scheduleTime = [0]
        }
        
        
        
        var stringToScheduleTime = [String]()
        for date in integerDates {
            print("total dates are",date)
            let newStrigDate = String(date)
            stringToScheduleTime.append(","+newStrigDate)
            //stringToScheduleTime.append(newStrigDate)
        }
        
        
        
        
        if FeedsHandler.sharedInstance.isPlaceSelected{
            let objSelectedPlace = FeedsHandler.sharedInstance.selectedPlace
            lat = (objSelectedPlace?.coordinate.latitude)!
            long = (objSelectedPlace?.coordinate.longitude)!
            selectedPlace = (objSelectedPlace?.name)!
        }
        
        
        var shareingType = ""
        switch selectedSharingType {
        case 0:
            shareingType = "public"
            
        case 1:
            shareingType = "friends"
        case 2:
            shareingType = "private"
        default:
            shareingType = "public"
        }
        
        
        var parameters : [String: Any]
        
        
        
        
        if feelingId > 0 {
            
            parameters = [
                "id":selectedPost?.id! as Any,
                "feeling_id" : "\(feelingId)",
                "sharing_type" : shareingType,
                "description" : self.textViewStatus.text,
                "checkin_place" : selectedPlace,
                "latitude" : "\(lat)",
                "longitude" : "\(long)",
                "schedule_at" : scheduleTime,
                "friends" : idsArray
                
            ]
            
        } else {
            parameters = [
                "id":selectedPost?.id! as Any,
                "sharing_type" : shareingType,
                "description" : self.textViewStatus.text,
                "checkin_place" : selectedPlace,
                "latitude" : "\(lat)",
                "longitude" : "\(long)",
                "schedule_at" : scheduleTime,
                "friends" : idsArray
            ]
        }
        
        //        if scheduleTime.first != 0{
        //
        //             parameters.updateValue("0", forKey: "schedule_at[0]" )
        //        }else{
        //           parameters.updateValue("0", forKey: "schedule_at[0]" )
        //        }
        
        //
        
//        var timeDictionary = [String: Any]()
//
//        if scheduleTime.first != 0 {
//            for (key, value) in scheduleTime.enumerated(){
//                print(key)
//
//                timeDictionary ["schedule_at[\(key)]"] =  String(value)
//            }
//            print("timeDictionary",timeDictionary)
//            parameters.update(other: timeDictionary)
//        }
//        else{
//            parameters ["schedule_at[0]"] =  "0"
//        }
        
//        print("new paramters are after adding scheduling...",parameters)
//        var idsDictionary = [String: Any]()
//
//        if idsArray.count > 0 {
//            for (key, value) in self.idsArray.enumerated(){
//                print(key)
//                idsDictionary ["friends[\(key)]"] =  value
//            }
//            print("idsDictionary",idsDictionary)
//            parameters.update(other: idsDictionary)
//        }
//        print(parameters)

        
//        var idsDictionary = [String: Any]()
//
//        if idsArray.count > 0 {
//            for (key, value) in self.idsArray.enumerated(){
//                print(key)
//                idsDictionary ["friends[\(key)]"] =  value
//            }
//            print("idsDictionary",idsDictionary)
//            parameters.update(other: idsDictionary)
//        }
//        print(parameters)
        
        
        print(parameters)
        FeedsHandler.postStatus(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            let status = successResponse["status_code"] as! Int
            if status == 200 {
                print(successResponse["message"]!)
                let message = successResponse["message"] as! String
                
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "scheduledDates")
                userDefaults.removeObject(forKey: "scheduledIntegerDates")
                self.oltRemoveScheduledTimes.isHidden=true
                self.scheduleMultiplePostsLabel.text = "Schedule Post"
                
                self.viewDidLoad()
                self.stopAnimating()
                self.showSuccess(message: message)
                EditMySchedulePostViewController.arrayOfImages.removeAll()
                EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
                
                self.navigationController?.popViewController(animated: true)
                //self.showCustomAlert(message: successResponse["message"] as! String)
            }else {
                self.stopAnimating()
                let message = successResponse["message"] as! String
                self.showError(message: message)
                //let message = successResponse["message"] as! String
                //self.showAlrt(message: message)
            }
            
        }) { (errorResponse) in
            self.showError(message: errorResponse!.message)
            
            self.stopAnimating()
            //self.showAlrt(message: (errorResponse?.message)!)
        }
        
        
        
        // }
        self.stopAnimating()
        
    }
    
    func postStatusWithImage (){
        self.showLoader()
        
        let userDefaults = UserDefaults.standard
        var integerDates = userDefaults.value(forKey: "scheduledIntegerDates") as? [Int] ?? [Int]()
        if integerDates.count==0{
            integerDates = [0]
        }
        print("new integer datessss",integerDates)
        //for var i in 0..<integerDates.count {
        
        var feelingId = 0
        
        if FeedsHandler.sharedInstance.objFeeling != nil{
            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
        }
        
        var lat: Double = 0.00
        var long: Double = 0.00
        var selectedPlace = ""
        var scheduleTime = [Int]()
        if integerDates.count != 0{
            scheduleTime = integerDates             //Int(stringToScheduleTime)    //0
        }else{
            scheduleTime = [0]
        }
        
        if FeedsHandler.sharedInstance.isPlaceSelected{
            let objSelectedPlace = FeedsHandler.sharedInstance.selectedPlace
            lat = (objSelectedPlace?.coordinate.latitude)!
            long = (objSelectedPlace?.coordinate.longitude)!
            selectedPlace = (objSelectedPlace?.name)!
        }
        
        //        var shareingType = ""
        //        switch selectedSharingType {
        //        case 0:
        //            shareingType = "friends"
        //        case 1:
        //            shareingType = "public"
        //        case 2:
        //            shareingType = "private"
        //
        //        default:
        //            shareingType = "friends"
        //        }
        
        
        var shareingType = ""
        switch selectedSharingType {
        case 0:
            shareingType = "public"
            
        case 1:
            shareingType = "friends"
        case 2:
            shareingType = "private"
        default:
            shareingType = "public"
        }
        
        var statusString = ""
        if self.textViewStatus.text != placeHolderText {
            statusString = self.textViewStatus.text
        }
        
        var parameters : [String: Any]
        if feelingId > 0 {
            parameters = [
                "id":selectedPost?.id! as Any,
                "feeling_id" : "\(feelingId)",
                "sharing_type" : shareingType,
                "description" : statusString,
                "checkin_place" : selectedPlace,
                "latitude" : "\(lat)",
                "longitude" : "\(long)",
                
                // "schedule_at" : scheduleTime
                
            ]
        }else{
            parameters = [
                "id":selectedPost?.id! as Any,
                "sharing_type" : shareingType,
                "description" : statusString,
                "checkin_place" : selectedPlace,
                "latitude" : "\(lat)",
                "longitude" : "\(long)",
                // "schedule_at" : scheduleTime
                
            ]
        }
        
        
        
        var timeDictionary = [String: Any]()
        
        if scheduleTime.first != 0 {
            for (key, value) in scheduleTime.enumerated(){
                print(key)
                
                timeDictionary ["schedule_at[\(key)]"] =  String(value)
            }
            print("timeDictionary",timeDictionary)
            parameters.update(other: timeDictionary)
        }
        else{
            parameters ["schedule_at[0]"] =  "0"
        }
        
        print("parameters are..",parameters)
        
        
        var idsDictionary = [String: Any]()
        
        if idsArray.count > 0 {
            for (key, value) in self.idsArray.enumerated(){
                print(key)
                idsDictionary ["friends[\(key)]"] =  value
            }
            print("idsDictionary",idsDictionary)
            parameters.update(other: idsDictionary)
        }
        print(parameters)
        
        var fileUrl : URL?
        var fileUrl2 : URL?
        if isImageSelected {
            
            fileUrl = self.pickedImnageUrl
        } else if isVideoSelectedFromGallery{
            fileUrl = videoURL
            if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: fileUrl!){
                saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
                fileUrl2 = thumnailUrl
            }
        }
        else{
            if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: FeedsHandler.sharedInstance.selectedVideoUrl!){
                saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
                fileUrl2 = thumnailUrl
            }
            fileUrl = FeedsHandler.sharedInstance.selectedVideoUrl
        }
        //  print(fileUrl!)
        
        if fileUrl2 == nil {
            fileUrl2 = fileUrl
        }
        FeedsHandler.postStatusWithImage(fileUrls: UpdateStatusController.arrayOfImagesURLS, params: parameters as NSDictionary, success: { (successResponse) in
            let status = successResponse["status_code"] as! Int
            if status == 200 {
                print(successResponse["message"]!)
                let message = successResponse["message"] as! String
                self.showSuccess(message: message)
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "scheduledDates")
                userDefaults.removeObject(forKey: "scheduledIntegerDates")
                
                
                self.idsArray.removeAll()
                self.viewDidLoad()
                self.stopAnimating()
                //self.showCustomAlert(message: successResponse["message"] as! String)
                
                for url in UpdateStatusController.arrayOfImagesURLS{
                    self.removeFileFromDocuments(fileUrl: url)
                }
                UpdateStatusController.arrayOfImages.removeAll()
                UpdateStatusController.arrayOfImagesURLS.removeAll()
                
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                
            }else {
                self.stopAnimating()
                let message = successResponse["message"] as! String
                self.showError(message: message)
                //self.showAlrt(message: message)
            }
        }
            , failure:  { (errorResponse) in
                self.showError(message: errorResponse!.message)
                self.stopAnimating()
                //self.showAlrt(message: (errorResponse?.message)!)
        })
        
        
        //        FeedsHandler.postStatusWithImage(fileUrl: fileUrl!,fileUrl2: fileUrl2!, params: parameters as NSDictionary, success: { (successResponse) in
        //            let status = successResponse["status_code"] as! Int
        //            if status == 200 {
        //                print(successResponse["message"]!)
        //                let message = successResponse["message"] as! String
        //                self.showSuccess(message: message)
        //                self.viewDidLoad()
        //                self.stopAnimating()
        //                //self.showCustomAlert(message: successResponse["message"] as! String)
        //                self.removeFileFromDocuments(fileUrl: fileUrl!)
        //
        //            }else {
        //                self.stopAnimating()
        //                let message = successResponse["message"] as! String
        //                self.showError(message: message)
        //                //self.showAlrt(message: message)
        //            }
        //        }) { (errorResponse) in
        //            self.showError(message: errorResponse!.message)
        //            self.stopAnimating()
        //            //self.showAlrt(message: (errorResponse?.message)!)
        //            }
        
        // }
    }
    
    
    
    
    
//    func postStatusWithImage (){
//        self.showLoader()
//
//        let userDefaults = UserDefaults.standard
//        var integerDates = userDefaults.value(forKey: "scheduledIntegerDates") as? [Int] ?? [Int]()
//        if integerDates.count==0{
//            integerDates = [0]
//        }
//        print("new integer datessss",integerDates)
//        //for var i in 0..<integerDates.count {
//
//        var feelingId = 0
//
//        if FeedsHandler.sharedInstance.objFeeling != nil{
//            feelingId = (FeedsHandler.sharedInstance.objFeeling?.id)!
//        }
//
//        var lat: Double = 0.00
//        var long: Double = 0.00
//        var selectedPlace = ""
//        var scheduleTime = [Int]()
//        if integerDates.count != 0{
//            scheduleTime = integerDates             //Int(stringToScheduleTime)    //0
//        }else{
//            scheduleTime = [0]
//        }
//
//
//        if FeedsHandler.sharedInstance.isPlaceSelected{
//            let objSelectedPlace = FeedsHandler.sharedInstance.selectedPlace
//            lat = (objSelectedPlace?.coordinate.latitude)!
//            long = (objSelectedPlace?.coordinate.longitude)!
//            selectedPlace = (objSelectedPlace?.name)!
//        }
//
//        var shareingType = ""
//        switch selectedSharingType {
//        case 0:
//            shareingType = "friends"
//        case 1:
//            shareingType = "public"
//        case 2:
//            shareingType = "private"
//
//        default:
//            shareingType = "friends"
//        }
//
//        var statusString = ""
//        if self.textViewStatus.text != placeHolderText {
//            statusString = self.textViewStatus.text
//        }
//
//        var parameters : [String: Any]
//        if feelingId > 0 {
//            parameters = [
//                "id":selectedPost?.id! as Any,
//                "feeling_id" : "\(feelingId)",
//                "sharing_type" : shareingType,
//                "description" : statusString,
//                "checkin_place" : selectedPlace,
//                "latitude" : "\(lat)",
//                "longitude" : "\(long)",
//                //"schedule_at" : scheduleTime
//
//            ]
//        }else{
//            parameters = [
//                "id":selectedPost?.id! as Any,
//                "sharing_type" : shareingType,
//                "description" : statusString,
//                "checkin_place" : selectedPlace,
//                "latitude" : "\(lat)",
//                "longitude" : "\(long)",
//                //"schedule_at" : scheduleTime
//
//            ]
//        }
//
//
//
//        var timeDictionary = [String: Any]()
//
//        if scheduleTime.first != 0 {
//            for (key, value) in scheduleTime.enumerated(){
//                print(key)
//
//                timeDictionary ["schedule_at[\(key)]"] =  String(value)
//            }
//            print("timeDictionary",timeDictionary)
//            parameters.update(other: timeDictionary)
//        }
//        else{
//            parameters ["schedule_at[0]"] =  "0"
//        }
//
//        var fileUrl : URL?
//        var fileUrl2 : URL?
//        if isImageSelected {
//
//            fileUrl = self.pickedImnageUrl
//        } else if isVideoSelectedFromGallery{
//            fileUrl = videoURL
//            if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: fileUrl!){
//                saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
//                fileUrl2 = thumnailUrl
//            }
//        }
//        else{
//            if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: FeedsHandler.sharedInstance.selectedVideoUrl!){
//                saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
//                fileUrl2 = thumnailUrl
//            }
//            fileUrl = FeedsHandler.sharedInstance.selectedVideoUrl
//        }
//        print(fileUrl!)
//
//        if fileUrl2 == nil {
//            fileUrl2 = fileUrl
//        }
//        FeedsHandler.postStatusWithImage(fileUrls: EditMySchedulePostViewController.arrayOfImagesURLS, params: parameters as NSDictionary, success: { (successResponse) in
//            let status = successResponse["status_code"] as! Int
//            if status == 200 {
//                print(successResponse["message"]!)
//                let message = successResponse["message"] as! String
//                self.showSuccess(message: message)
//                let userDefaults = UserDefaults.standard
//                userDefaults.removeObject(forKey: "scheduledDates")
//                userDefaults.removeObject(forKey: "scheduledIntegerDates")
//
//
//
//                self.viewDidLoad()
//                self.stopAnimating()
//
//                //self.showCustomAlert(message: successResponse["message"] as! String)
//                self.removeFileFromDocuments(fileUrl: fileUrl!)
//                EditMySchedulePostViewController.arrayOfImages.removeAll()
//                EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
//                self.navigationController?.popViewController(animated: true)
//
//            }else {
//                self.stopAnimating()
//                let message = successResponse["message"] as! String
//                self.showError(message: message)
//                //self.showAlrt(message: message)
//            }
//        }
//            , failure:  { (errorResponse) in
//                self.showError(message: errorResponse!.message)
//                self.stopAnimating()
//                //self.showAlrt(message: (errorResponse?.message)!)
//        })
//
//
//        //        FeedsHandler.postStatusWithImage(fileUrl: fileUrl!,fileUrl2: fileUrl2!, params: parameters as NSDictionary, success: { (successResponse) in
//        //            let status = successResponse["status_code"] as! Int
//        //            if status == 200 {
//        //                print(successResponse["message"]!)
//        //                let message = successResponse["message"] as! String
//        //                self.showSuccess(message: message)
//        //                self.viewDidLoad()
//        //                self.stopAnimating()
//        //                //self.showCustomAlert(message: successResponse["message"] as! String)
//        //                self.removeFileFromDocuments(fileUrl: fileUrl!)
//        //
//        //            }else {
//        //                self.stopAnimating()
//        //                let message = successResponse["message"] as! String
//        //                self.showError(message: message)
//        //                //self.showAlrt(message: message)
//        //            }
//        //        }) { (errorResponse) in
//        //            self.showError(message: errorResponse!.message)
//        //            self.stopAnimating()
//        //            //self.showAlrt(message: (errorResponse?.message)!)
//        //            }
//
//        // }
//    }
    
    func removeFileFromDocuments (fileUrl: URL){
        _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension EditMySchedulePostViewController {
    func animateBottomViews() {
        self.childView.forEach {
            $0.isHidden = !$0.isHidden
        }
    }
    
    override func prepareView() {
        super.prepareView()
        
        
        
        //image one tappable
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditMySchedulePostViewController.imageTapped(gesture:)))
        selectedImageViewOne.addGestureRecognizer(tapGesture)
        selectedImageViewOne.isUserInteractionEnabled = true
        
        //image two tappable
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(EditMySchedulePostViewController.imageTapped(gesture:)))
        
        selectedImageViewTwo.addGestureRecognizer(tapGesture1)
        selectedImageViewTwo.isUserInteractionEnabled = true
        
        //image three tappable
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(EditMySchedulePostViewController.imageTapped(gesture:)))
        
        selectedImageViewThree.addGestureRecognizer(tapGesture2)
        selectedImageViewThree.isUserInteractionEnabled = true
        
        
        
        
        self.textViewStatus.delegate = self
        prepareTextview()
        prepareChildViewsInStackView()
        preparePrivacyDropDown()
        
        oltRemoveFeeling.isHidden = true
        oltRemoveCheckin.isHidden = true
        imgFeeling.isHidden = true
        lblFeelingDetail.isHidden = true
        lblFeelingDetail.font = CommonMethods.getFontOfSize(size: 14)
        
        lblCheckIn.isHidden = true
        lblCheckIn.font = CommonMethods.getFontOfSize(size: 14)
        
        addBackButton()
        appDelegate.disableKeyboardManager(EditMySchedulePostViewController.self)
        hideKeyboardWhenTappedAround()
        
        oltRemoveCheckin.setTitleColor(.black, for: .normal)
        oltRemoveFeeling.setTitleColor(.black, for: .normal)
        oltRemoveSelectedImage.setTitleColor(.black, for: .normal)
        
        oltRemoveSelectedImage.isHidden = true
        imgSelected.isHidden = true
        oltRemoveTags.isHidden = true
       // imagesAreNotSelected()
        
    }
    
    
    
    @objc  func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            self.goToUpdateStatusSelectedImagesViewScreen()
        }
    }
    
    func goToUpdateStatusSelectedImagesViewScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateStatusSelectedImagesViewController = storyboard.instantiateViewController(withIdentifier: "UpdateStatusSelectedImagesViewController") as! UpdateStatusSelectedImagesViewController
        present(updateStatusSelectedImagesViewController, animated: true, completion: nil)
    }
    
    override func onBackButtonClciked() {
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "scheduledDates")
        userDefaults.removeObject(forKey: "scheduledIntegerDates")
        
        FeedsHandler.sharedInstance.isFeelingSelected = false
        FeedsHandler.sharedInstance.objFeeling = nil
        FeedsHandler.sharedInstance.isStatusUpdated = true
        
        FeedsHandler.sharedInstance.isPlaceSelected = false
        FeedsHandler.sharedInstance.selectedPlace = nil
        
        FeedsHandler.sharedInstance.isFriendsTagged = false
        FeedsHandler.sharedInstance.taggedFriends = nil
        
        FeedsHandler.sharedInstance.isVideoSelected = false
        FeedsHandler.sharedInstance.selectedVideoUrl = nil
        
        // To refresh data on previous controller
        FeedsHandler.sharedInstance.isStatusPosted = false
        EditMySchedulePostViewController.arrayOfImages.removeAll()
        EditMySchedulePostViewController.arrayOfImagesURLS.removeAll()
        
        
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
        
    }
    
    func prepareTextview() {
        textViewStatus.text = placeHolderText
        textViewStatus.textColor = UIColor.lightGray
        _ = textViewStatus.resignFirstResponder()
    }
    
    func prepareChildViewsInStackView() {
        childView.forEachEnumerated { index, child in
            // child.addTopBorder()
            if index == 0 {
                //child.addBottomBorder()
            }
            child.isHidden = true
        }
    }
    
    func preparePrivacyDropDown() {
        //postPrivacyDropDown.selectionBackgroundColor = .clear
        postPrivacyDropDown.textColor = UIColor.black.withAlphaComponent(0.8)
        postPrivacyDropDown.textFont = UIFont.thin
        postPrivacyDropDown.anchorView = buttonPrivacyDropDown
        
        let items = ["Public", "Friends Only", "On my timeline"]
        
        postPrivacyDropDown.dataSource = items
        
        postPrivacyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelStatusPrivacy.text = items[index]
            self.selectedSharingType = index
        }
        
        postPrivacyDropDown.width = labelStatusPrivacy.plainView.bounds.width
        postPrivacyDropDown.bottomOffset = CGPoint(x: 0, y: labelStatusPrivacy.plainView.bounds.height)
        postPrivacyDropDown.direction = .bottom
        postPrivacyDropDown.backgroundColor = .white
        postPrivacyDropDown.dismissMode = .automatic
    }
    
    func showPostPrivacyDropDown() {
        postPrivacyDropDown.show()
    }
    
    func showDatePicker() {
        let datePicker = ActionSheetDatePicker(title: "Schedule Post", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            print("value = \(String(describing: value))")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            
            return
        }, cancel: { ActionStringCancelBlock in return },
           origin: (schedulePostContainer as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = Date()
        
        datePicker?.show()
    }
    
    
}

extension EditMySchedulePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText{
            textView.text = ""
            textView.textColor = .black
            if(lang == "ar")
            {
              textView.textAlignment = .right
            }else
            
            {
               textView.textAlignment = .left
            }
        }
        
        //        if textView.textColor == UIColor.lightGray {
        //            textView.text = nil
        //            textView.textColor = UIColor.black
        //        }
        
        //self.stackView.isHidden = true
//        UIView.animate(withDuration: 0.4.seconds) {
//            self.animateBottomViews()
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
            if(lang == "ar")
            {
                textView.textAlignment = .right
            }else
            {
                textView.textAlignment = .left
            }
        }
        //        if textView.textColor == UIColor.lightGray {
        //            textView.text = nil
        //            textView.textColor = UIColor.black
        //        }
        
        //self.stackView.isHidden = false
        
        UIView.animate(withDuration: 0.0.seconds) {
            self.animateBottomViews()
            
            //self.textViewStatus.text = self.placeHolderText
            self.textViewStatus.textColor = UIColor.lightGray
            if(self.lang == "ar")
            {
                self.textViewStatus.textAlignment = .right
            }else
            {
               self.textViewStatus.textAlignment = .left
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView
        /*
         if currentText.text.isEmpty {
         textView.text = placeHolderText
         textView.textColor = UIColor.lightGray
         
         return false
         } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
         textView.text = nil
         textView.textColor = UIColor.black
         }
         */
        
        return true
    }
    
}
//extension Dictionary {
//
//    mutating func merge(with dictionary: Dictionary) {
//        dictionary.forEach { updateValue($1, forKey: $0) }
//    }
//
//    func merged(with dictionary: Dictionary) -> Dictionary {
//        var dict = self
//        dict.merge(with: dictionary)
//        return dict
//    }
//}
extension EditMySchedulePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        print("videoURL:\(String(describing: videoURL))")
        
        if let thumbnailImage = CommonMethods.getThumbnailImage(forUrl: videoURL!){
            selectedImageViewOne.layer.width = 170.0
            selectedImageViewOne.layer.height = 189
            saveThumnailFileToDocumentsDirectory(image: thumbnailImage)
            //fileUrl2 = thumnailUrl
            EditMySchedulePostViewController.arrayOfImages.append(thumbnailImage)
            //UpdateStatusController.arrayOfImagesURLS.append(thumnailUrl!)
            EditMySchedulePostViewController.arrayOfImagesURLS.append(videoURL!)
            deleteVideoThumbnailButtonOutlet.isHidden=false
            playVideoButton.isHidden=false
            self.imagesAreSelected()
        }
        
        

        isVideoSelectedFromGallery = true
        self.dismiss(animated: true, completion: nil)
    }
}


