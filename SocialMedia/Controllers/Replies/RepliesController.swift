//
//  RepliesController.swift
//  SocialMedia
//
//  Created by iOSDev on 7/4/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

    import UIKit
    import Material
    import SDWebImage
    import NVActivityIndicatorView
    import ImagePicker
    import Lightbox
    
    extension SegueIdentifiable {
        static var RepliesController : SegueIdentifier {
            return SegueIdentifier(rawValue: CommentsController.className)
        }
    }
    
    class RepliesController: UIViewController, NVActivityIndicatorViewable,ImagePickerDelegate {
        @IBOutlet weak var oltAddAttachment: UIButton!
        @IBOutlet var belowTextFieldRoundView: UIView!
        let user = ShareData.sharedUserInfo
        
        @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
        @IBOutlet weak var viewContainer: UIView!
        var arrayCommentData = [GetCommentsData]()
        @IBOutlet weak var oltSend: UIButton!
        var pickedImnageUrl: URL?
        var postId = ""
        var commentId = ""
        var obj: UserLoginData?
        var userId = ""
        var state = false
        var keyboardhide = false

        var imgCounter = 0
        var postcommentWitoutImageFlage = false
        var totalLastPage = 0
        var currentPage = 0
        
        
        @IBOutlet var selectedViewForSelectedImage: UIView!
        @IBOutlet var selectedImageView: UIImageView!
        @IBOutlet var selectedImageNameLabel: UILabel!
        
        @IBAction func removeSelectedImage(_ sender: Any) {
            selectedViewForSelectedImage.isHidden=true
            self.imgCounter = 0
        }
        
        @IBOutlet var tableView: UITableView! {
            didSet {
                tableView.delegate = self
                tableView.dataSource = self
                tableView.tableFooterView = UIView()
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = tableView.rowHeight
            }
        }
        
        //    @IBOutlet var writeCommentView: UIView!
        
        
        @IBOutlet weak var inputTextField: UITextField!{
            didSet {
                inputTextField.delegate = self
            }
        }
        
        var isKeyboardOpened = false
        var isKeyboardToggling = false
        var previousScrollPosition = CGPoint.zero
        
        override func viewDidLoad() {
            super.viewDidLoad()
            var keyboardhide = false
            self.setupKeyboardScrolling()
            inputTextField.text = "Type Comment...".localized
            selectedViewForSelectedImage.isHidden=true
            //        inputTextField.roundView()
            //        hideKeyboardWhenTappedAround()
            //        tableView.estimatedRowHeight = 268
            //        tableView.rowHeight = UITableViewAutomaticDimension
            obj = UserHandler.sharedInstance.userData
            
            
            userId = "\(String(describing: obj?.id))"
            appDelegate.disableToolbarOnKeyboard(controller: RepliesController.self)
            appDelegate.disableDistanceHandling(controller: RepliesController.self)
            appDelegate.enableTouchOnKeyboard(controller: RepliesController.self)
            
            addBackButton()
            getUserComments(postId: postId,commentId: commentId, page_no: "0")
            navigationController?.navigationBar.barTintColor = .primary
            
            self.title = "Replies".localized
          //  self.viewContainer.backgroundColor = CommonMethods.textFieldColor()
            // Do any additional setup after loading the view.
            let imageSend = #imageLiteral(resourceName: "iconSend")
            let renderdImage = imageSend.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.oltSend.setImage(renderdImage, for: .normal)
            self.oltSend.tintColor = UIColor(red: 0.2824, green: 0.7059, blue: 0.9529, alpha: 1.0)//UIColor.white
            
            let imgAdd = #imageLiteral(resourceName: "attach")
            let attachRendImage = imgAdd.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.oltAddAttachment.setImage(attachRendImage, for: .normal)
            self.oltAddAttachment.tintColor = UIColor(red: 0.2824, green: 0.7059, blue: 0.9529, alpha: 1.0)//UIColor.white
            
            self.inputTextField.layer.cornerRadius = 0
            self.inputTextField.delegate = self
        }
        private func scrollToBottom(animated: Bool) {
            
            if self.arrayCommentData.count > 0 {
                let lastRow = IndexPath(row: self.arrayCommentData.count - 1 , section: 0)
                self.tableView.scrollToRow(at: lastRow, at: .bottom, animated: animated)
            }
        }
        // MARK: - KEYBOARD SCROLLING
        private var keyboard: Keyboard!
        
        private func setupKeyboardScrolling() {
            self.keyboard = Keyboard()
            
            // Lift/lower send view based on keyboard height.
            let keyboardAnimation = { [unowned self] in
                
                self.keyboardhide = true
                var keyboardHeight = self.keyboard.height
                if #available(iOS 11.0, *) {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    keyboardHeight -= bottomInset
                }
                self.bottomConstrain.constant  = keyboardHeight
                //  self.bottomConstraint.constant = self.keyboard.height
                self.view.layoutIfNeeded()
            }
            // Scroll to bottom after animation.
            let keyboardCompletion: (Bool) -> Void = { [unowned self] _ in
                self.scrollToBottom(animated: true)
                
                
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
            self.tableView.addGestureRecognizer(tap)
        }
        
        @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
            //  self.sendView?.removeFocus()
            view.endEditing(true)
            if(self.keyboardhide){
                
                
                if #available(iOS 11.0, *) {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    //  self.viewMainContainer.isHidden = true
                    //   self.isKeyboardOpened2 = false
                    self.bottomConstrain.constant  += bottomInset
                    self.keyboardhide = false
                }
            }
            
            
            
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
         //   startObservingKeyboard()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
          //  stopObservingKeyboard()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        // MARK: - Animation Loader
        func showLoader(){
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
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
            selectedViewForSelectedImage.isHidden=false
            selectedImageView.image = images[0]
            selectedImageNameLabel.text = "Image-25207000000"
            saveFileToDocumentsDirectory(image: images[0])
            imagePicker.dismiss(animated: true, completion: nil)
        }
        func saveFileToDocumentsDirectory(image: UIImage) {
            if let savedUrl = FileManager.default.saveImageToDocumentsDirectory(image: image, name: "CommentPicture", extention: ".jpg") {
                self.pickedImnageUrl = savedUrl
                self.imgCounter = 1
                
                // onSendMessageButtonClick("Anything")
            }
        }
        
        func cancelButtonDidPress(_ imagePicker: ImagePickerController){
            
        }
        func imagePickerControllerDidCancel(picker: ImagePickerController!)
        {
            picker.dismiss(animated: true, completion: nil) 
        }
        
        @IBAction func onOpenCameraLibraryAction(_ sender: Any) {
            let imagePickerController = ImagePickerController()
            imagePickerController.imageLimit = 1
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        @IBAction func onSendMessageButtonClick(_ sender: Any) {
            
            if self.imgCounter == 1 {
                
                //            if(!(inputTextField.text?.isEmpty)!){
                //                String(describing: pickedImnageUrl)
                postCommentsWithImage(filePath:pickedImnageUrl!,postId:postId,commentId: commentId,comments:inputTextField.text!,attatchements: "")
                //            }
                //            else{
                //                let alertView = AlertView.prepare(title: "Error", message: "Pl fill the text.", okAction: { _ in
                //                })
                //                self.present(alertView, animated: true, completion: nil)
                //            }
                
            }
            else{
                if(!(inputTextField.text?.isEmpty)!){
                    postCommentsWithoutImage(postId:self.postId,commentId: commentId,comments: inputTextField.text!,attatchements:" ")
                }
                else{
                    let alertView = AlertView.prepare(title: "Error".localized, message: "Please fill the text.".localized, okAction: {
                    })
                    self.present(alertView, animated: true, completion: nil)
                }
                
            }
            
        }
        
        @IBAction func onShowEmojiKeyboardClicked(_ sender: UIButton) {
            //        isKeyboardToggling = true
            //        _ = self.resignFirstResponder()
            //        inputTextField.toggleKayboard()
            //        _ = self.becomeFirstResponder()
            //
            //        Timer.after(0.4.seconds) {
            //            self.isKeyboardToggling = false
            //        }
            //    }
        }
    }
    
    extension RepliesController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            view.endEditing(true)
            if(self.keyboardhide){
                
                
                if #available(iOS 11.0, *) {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    //  self.viewMainContainer.isHidden = true
                    //   self.isKeyboardOpened2 = false
                    self.bottomConstrain.constant  += bottomInset
                    self.keyboardhide = false
                }
            }
            //self.onSendMessageButtonClick("Anything")
            return true
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            //        self.txtMessage.resignFirstResponder()
        }
    }
    
    extension RepliesController: KeyboardObserver {
        override func keyboardWillShowWithFrame(_ frame: CGRect) {
            if !isKeyboardOpened && !isKeyboardToggling {
                UIView.animate(withDuration: 0.2, animations: {
                    var keyboardHeight = frame.height
                    if #available(iOS 11.0, *) {
                        let bottomInset = self.view.safeAreaInsets.bottom
                        keyboardHeight -= bottomInset
                    }
                    
                    self.bottomConstrain.constant  = keyboardHeight
                  
                    //                self.tableView.scrollToBottom(animated: true)
                }, completion: { _ in
                    self.isKeyboardOpened = true
                })
            }
        }
        override func keyboardWillHideWithFrame(_ frame: CGRect) {
            if isKeyboardOpened && !isKeyboardToggling {
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomConstrain.constant = 0
                    //                self.tableView.scrollToBottom(animated: true)
                }, completion: { _ in
                    self.isKeyboardOpened = false
                })
            }
        }
    }
    
    // MARK: -  Tableview Delegate and Datasourse Methods
    extension RepliesController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.rowHeight
        }
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return tableView.estimatedRowHeight
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            if arrayCommentData.count == 0{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Write a comment...".localized
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
            return arrayCommentData.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if state == false{
                let objComment = arrayCommentData[indexPath.row]
                if(objComment.attachment != ""){
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: commentWithImageCell2.className, for: indexPath) as! commentWithImageCell2
                    cell.userNameLabel.text = objComment.user.fullName
                    
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.userNameLabel.tag = indexPath.row
                    cell.userNameLabel.isUserInteractionEnabled = true
                    cell.userNameLabel.addGestureRecognizer(userNameTapGesture)
                    let userNameTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = true
                    cell.profileImageView.addGestureRecognizer(userNameTapGesture2)
                    
                    cell.profileImageView.sd_setImage(with: URL(string: objComment.user.image), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell.profileImageView.sd_setIndicatorStyle(.gray)
                    cell.profileImageView.clipsToBounds = true
                    
                    cell.commentLabel.text = objComment.comment
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objComment.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.commentTimeLabel.text = date
                    cell.image_attachementView.sd_setImage(with: URL(string: objComment.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.image_attachementView.sd_setShowActivityIndicatorView(true)
                    cell.image_attachementView.sd_setIndicatorStyle(.gray)
                    cell.image_attachementView.clipsToBounds = true
                    
                    if(userId == "\(String(describing: objComment.userId))"){
                        cell.deleteComments.isHidden = false
                        cell.updateComments.isHidden = false
                        
                        let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                        cell.deleteComments.tag = indexPath.row
                        cell.deleteComments.isUserInteractionEnabled = true
                        cell.deleteComments.addGestureRecognizer(commentTapGestureRecognizer)
                        
                        
                        let updatecommentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatecommentsTapped(tapGestureRecognizer:)))
                        cell.updateComments.tag = indexPath.row
                        cell.updateComments.isUserInteractionEnabled = true
                        cell.updateComments.addGestureRecognizer(updatecommentTapGestureRecognizer)
                    }
                    else{
                        cell.deleteComments.isHidden = true
                        cell.updateComments.isHidden = true
                        
                    }
                    
                    
                    
                    
                    return cell
                }
                else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell2.className, for: indexPath) as! CommentCell2
                    cell.userNameLabel.text = objComment.user.fullName
                    
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.userNameLabel.tag = indexPath.row
                    cell.userNameLabel.isUserInteractionEnabled = true
                    cell.userNameLabel.addGestureRecognizer(userNameTapGesture)
                    let userNameTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = true
                    cell.profileImageView.addGestureRecognizer(userNameTapGesture2)
                    
                    
                    
                    cell.profileImageView.sd_setImage(with: URL(string: objComment.user.image), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell.profileImageView.sd_setIndicatorStyle(.gray)
                    cell.profileImageView.clipsToBounds = true
                    
                    cell.commentLabel.text = objComment.comment
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objComment.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.commentTimeLabel.text = date
                    
                    if(userId == "\(String(describing: objComment.userId))"){
                        cell.deleteComments.isHidden = false
                        cell.updateComments.isHidden = false
                        
                        let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                        cell.deleteComments.tag = indexPath.row
                        cell.deleteComments.isUserInteractionEnabled = true
                        cell.deleteComments.addGestureRecognizer(commentTapGestureRecognizer)
                        
                        
                        let updatecommentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatecommentsTapped(tapGestureRecognizer:)))
                        cell.updateComments.tag = indexPath.row
                        cell.updateComments.isUserInteractionEnabled = true
                        cell.updateComments.addGestureRecognizer(updatecommentTapGestureRecognizer)
                    }
                    else{
                        cell.deleteComments.isHidden = true
                        cell.updateComments.isHidden = true
                        
                    }
                    
                    
                    return cell
                }
            }else{
                
                let objComment = arrayCommentData.reversed()[indexPath.row]
                if(objComment.attachment != ""){
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: commentWithImageCell2.className, for: indexPath) as! commentWithImageCell2
                    cell.userNameLabel.text = objComment.user.fullName
                    
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.userNameLabel.tag = indexPath.row
                    cell.userNameLabel.isUserInteractionEnabled = true
                    cell.userNameLabel.addGestureRecognizer(userNameTapGesture)
                    let userNameTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = true
                    cell.profileImageView.addGestureRecognizer(userNameTapGesture2)
                    
                    
                    
                    cell.profileImageView.sd_setImage(with: URL(string: objComment.user.image), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell.profileImageView.sd_setIndicatorStyle(.gray)
                    cell.profileImageView.clipsToBounds = true
                    
                    cell.commentLabel.text = objComment.comment
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objComment.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.commentTimeLabel.text = date
                    cell.image_attachementView.sd_setImage(with: URL(string: objComment.attachment), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.image_attachementView.sd_setShowActivityIndicatorView(true)
                    cell.image_attachementView.sd_setIndicatorStyle(.gray)
                    cell.image_attachementView.clipsToBounds = true
                    if(userId == "\(String(describing: objComment.userId))"){
                        cell.deleteComments.isHidden = false
                        cell.updateComments.isHidden = false
                        
                        let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                        cell.deleteComments.tag = indexPath.row
                        cell.deleteComments.isUserInteractionEnabled = true
                        cell.deleteComments.addGestureRecognizer(commentTapGestureRecognizer)
                        
                        
                        let updatecommentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatecommentsTapped(tapGestureRecognizer:)))
                        cell.updateComments.tag = indexPath.row
                        cell.updateComments.isUserInteractionEnabled = true
                        cell.updateComments.addGestureRecognizer(updatecommentTapGestureRecognizer)
                    }
                    else{
                        cell.deleteComments.isHidden = true
                        cell.updateComments.isHidden = true
                        
                    }
                    
                    
                    
                    return cell
                }
                else{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell2.className, for: indexPath) as! CommentCell2
                    cell.userNameLabel.text = objComment.user.fullName
                    
                    
                    let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.userNameLabel.tag = indexPath.row
                    cell.userNameLabel.isUserInteractionEnabled = true
                    cell.userNameLabel.addGestureRecognizer(userNameTapGesture)
                    let userNameTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
                    cell.profileImageView.tag = indexPath.row
                    cell.profileImageView.isUserInteractionEnabled = true
                    cell.profileImageView.addGestureRecognizer(userNameTapGesture2)
                    
                    
                    cell.profileImageView.sd_setImage(with: URL(string: objComment.user.image), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell.profileImageView.sd_setIndicatorStyle(.gray)
                    cell.profileImageView.clipsToBounds = true
                    
                    cell.commentLabel.text = objComment.comment
                    let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objComment.createdAt.toDouble))
                    let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                    cell.commentTimeLabel.text = date
                    if(userId == "\(String(describing: objComment.userId))"){
                        cell.deleteComments.isHidden = false
                        cell.updateComments.isHidden = false
                        
                        let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentsTapped(tapGestureRecognizer:)))
                        cell.deleteComments.tag = indexPath.row
                        cell.deleteComments.isUserInteractionEnabled = true
                        cell.deleteComments.addGestureRecognizer(commentTapGestureRecognizer)
                        
                        
                        let updatecommentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatecommentsTapped(tapGestureRecognizer:)))
                        cell.updateComments.tag = indexPath.row
                        cell.updateComments.isUserInteractionEnabled = true
                        cell.updateComments.addGestureRecognizer(updatecommentTapGestureRecognizer)
                    }
                    else{
                        cell.deleteComments.isHidden = true
                        cell.updateComments.isHidden = true
                        
                    }
                    
                    
                    
                    
                    return cell
                }
            }
            
        }
        
        @objc func updatecommentsTapped(tapGestureRecognizer: UITapGestureRecognizer){
            view.endEditing(true)

            let popup = PopupController
                .create(self)
                .customize(
                    [
                        .animation(.slideUp),
                        .scrollable(false),
                        .backgroundStyle(.blackFilter(alpha: 0.7))
                    ]
                )
                .didShowHandler { popup in
                    print("showed popup!")
                }
                .didCloseHandler { _ in
                    print("closed popup!")
            }
            //.show(CountryPopupViewController.instance())
            let container = PopupViewController.instance()
            container.closeHandler = {
                popup.dismiss()
                
                if(self.user.flagAPI){
                    self.showLoader()
                    if(self.state){
                        let index = tapGestureRecognizer.view?.tag
                        let objFeed =  self.arrayCommentData.reversed()[index!]
                        
                        
                        
                        if( self.user.flagimage){
                            
                            self.updateComment(filePath:self.user.pickedImnageUrl!,postId:objFeed.id!,comments:self.user.comment!,attatchements: "")
                        }
                        else{
                            self.updateCommentwithoutImage(postId:objFeed.id!,comments:self.user.comment!,attatchements: "")
                        }
                    }
                    else{
                        let index = tapGestureRecognizer.view?.tag
                        let objFeed =  self.arrayCommentData[index!]
                        
                        
                        
                        if( self.user.flagimage){
                            
                            self.updateComment(filePath:self.user.pickedImnageUrl!,postId:objFeed.id!,comments:self.user.comment!,attatchements: "")
                        }
                        else{
                            self.updateCommentwithoutImage(postId:objFeed.id!,comments:self.user.comment!,attatchements: "")
                        }
                    }
                    
                }
                
            }
            if(self.state){
                let index = tapGestureRecognizer.view?.tag
                let objFeed = self.arrayCommentData.reversed()[index!]
                
                print(index)
                self.user.comment = objFeed.comment
                self.user.attactment = objFeed.attachment
                
                popup.show(container)
            }
            else{
                let index = tapGestureRecognizer.view?.tag
                let objFeed = self.arrayCommentData[index!]
                
                print(index)
                self.user.comment = objFeed.comment
                self.user.attactment = objFeed.attachment
                
                popup.show(container)
            }
            
            // self.goToComments(objFeed: objFeed)
        }
        
        func updateCommentwithoutImage(postId:Int,comments:String,attatchements:String)
        {
            self.showLoader()
            let parameters : [String: Any] = ["id": postId,
                                              "comment": comments,
                                              "attactment": attatchements]
            UserHandler.updateCommentwithoutAttachement(params: parameters as NSDictionary , success: { (success) in
                
                if(success.statusCode == 200){
                    //                self.state = true
                    //                self.arrayCommentData.append(success.data)
                    //                self.tableView.reloadData()
                    //                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    self.state = false
                    self.getUserComments(postId: self.postId, commentId: self.commentId, page_no: "0")
                    self.stopAnimating()
                    
                    //                self.imgCounter = 0
                    //                self.inputTextField.text = ""
                }
                else{
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
        
        func updateComment(filePath:URL,postId:Int,comments:String,attatchements:String)
        {
            
            view.endEditing(true)
            if(self.keyboardhide){
                
                
                if #available(iOS 11.0, *) {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    //  self.viewMainContainer.isHidden = true
                    //   self.isKeyboardOpened2 = false
                    self.bottomConstrain.constant  += bottomInset
                    self.keyboardhide = false
                }
            }
            self.showLoader()
            let parameters : [String: Any] = ["id": postId,
                                              "comment": comments,
                                              "attactment": attatchements]
            print(filePath)
            UserHandler.updateComment(fileUrl: filePath, params: parameters as NSDictionary , success: { (success) in
                self.selectedViewForSelectedImage.isHidden=true
                if(success.statusCode == 200){
                    //                self.state = true
                    //                self.arrayCommentData.append(success.data)
                    //                self.tableView.reloadData()
                    self.state = false
                    self.getUserComments(postId: self.postId ,commentId: self.commentId, page_no: "0")
                    
                    //                self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    self.stopAnimating()
                    //                self.imgCounter = 0
                    //                self.inputTextField.text = ""
                }
                else{
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
        
        @objc  func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
            view.endEditing(true)
            if(self.keyboardhide){
                
                
                if #available(iOS 11.0, *) {
                    let bottomInset = self.view.safeAreaInsets.bottom
                    //  self.viewMainContainer.isHidden = true
                    //   self.isKeyboardOpened2 = false
                    self.bottomConstrain.constant  += bottomInset
                    self.keyboardhide = false
                }
            }
            let index = tapGestureRecognizer.view?.tag
            if(self.state){
                let objFeed = self.arrayCommentData.reversed()[index!]
                print(index)
                //  let objFeed = self.arrayDataPeople[index!]
                let objOwnUser = UserHandler.sharedInstance.userData
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                print(objOwnUser?.id)
                print(objFeed.id)
                if objOwnUser?.id != objFeed.userId{
                    controller.isFromOtherUser = true
                    controller.otherUserId = objFeed.userId
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else{
                let objFeed = self.arrayCommentData[index!]
                
                print(index)
                //  let objFeed = self.arrayDataPeople[index!]
                let objOwnUser = UserHandler.sharedInstance.userData
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                
                print(objOwnUser?.id)
                print(objFeed.id)
                if objOwnUser?.id != objFeed.userId{
                    controller.isFromOtherUser = true
                    controller.otherUserId = objFeed.userId
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }

        
        @objc func commentsTapped(tapGestureRecognizer: UITapGestureRecognizer){
            self.showLoader()
            let parameters : [String: Any]
            let index = tapGestureRecognizer.view?.tag
            if(self.state){
                let objFeed = self.arrayCommentData.reversed()[index!]
                parameters = [
                    "comment_id": objFeed.id
                ]
            }
            else{
                let objFeed = self.arrayCommentData[index!]
                parameters  = [
                    "comment_id": objFeed.id
                ]
                
            }
            print(index)
            
            
            UserHandler.deleteComment(params: parameters as NSDictionary , success: { (success) in
                
                if(success.statusCode == 200){
                    
                    //                self.postcommentWitoutImageFlage = true
                    
                    //                if  self.arrayCommentData.isEmpty == false {
                    //
                    //                     var arrayCommentData2 = [GetCommentsData]()
                    //
                    //                    arrayCommentData2 = self.arrayCommentData.reversed()
                    //
                    //                    arrayCommentData2.remove(at: index!)
                    //
                    //                    self.arrayCommentData.removeAll()
                    //
                    self.state = false
                    self.getUserComments(postId: self.postId,commentId: self.commentId, page_no: "0")
                    //                self.arrayCommentData = arrayCommentData2
                    //                     self.state = false
                    //                    self.tableView.reloadData()
                    //                  if  arrayCommentData2.isEmpty == false {
                    //                 //  self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    //                    }
                    //                }
                    
                    //  self.arrayCommentData.append(success.data)
                    
                    //
                    self.inputTextField.text = ""
                    self.stopAnimating()
                }
                else{
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
            // self.goToComments(objFeed: objFeed)
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastItem = arrayCommentData.count - 1
            if indexPath.row == lastItem{
                loadMoreData()
            }
        }
        func loadMoreData(){
            if currentPage < totalLastPage{
              //  getUserComments(postId: postId,commentId: commentId, page_no: "0")
                getUserCommentsPagination(postId:postId,commentId: commentId, page_no:String(currentPage + 1))
            }
            else{
                print("You have no more data")
            }
            
            
        }
        // MARK: - Api Calls
        func getUserComments(postId: String,commentId: String, page_no: String)
        {
            self.showLoader()
           
            let parameters : [String: Any] = ["post_id": postId, "comment_id": commentId]
            
            print(parameters)
            UserHandler.getSubComments(pageNo: page_no, params: parameters as NSDictionary , success: { (success) in
                
                if(success.statusCode == 200) {
                    self.arrayCommentData.removeAll()
//                    self.totalLastPage = success.pagination.lastPage
//                    self.currentPage = success.pagination.currentPage
                    
                    if(success.data.count > 0 ){
                        
                        self.arrayCommentData = success.data
                        self.tableView.reloadData()
                        //                    self.tableView.scrollRectToVisible(CGRect.init(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height), animated: true)
                        //                    self.tableView.scrollToBottom(animated: true)
                        self.stopAnimating()
                    }else{
                        //let alertView = AlertView.prepare(title: "Message", message: success.message, okAction: { _ in})
                        // self.present(alertView, animated: true, completion: nil)
                        self.tableView.reloadData()
                        self.stopAnimating()
                    }
                }
                else{
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
        
        func postCommentsWithoutImage(postId:String,commentId: String,comments:String,attatchements:String)
        {
            self.showLoader()
            let parameters : [String: Any] = ["post_id": postId,
                                              "comment": comments,
                                              "comment_id": commentId,
                                              "attachment": attatchements]
            UserHandler.postsubCommentwithoutAttachement(params: parameters as NSDictionary , success: { (success) in
                
                if(success.statusCode == 200){
                    
                    self.postcommentWitoutImageFlage = true
                    self.arrayCommentData.append(success.data)
                    self.tableView.reloadData()
                    self.state = true
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    
                    self.inputTextField.text = ""
                    self.stopAnimating()
                }
                else{
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
        func postCommentsWithImage(filePath:URL,postId:String,commentId: String,comments:String,attatchements:String)
        {
            self.showLoader()
            
        //    post_id, comment_id,  comment, attachment
           
            
            
            let parameters : [String: Any] = ["post_id": postId,
                                              "comment_id": commentId,
                                              "comment": comments,
                                              "attachment": attatchements]
            UserHandler.postsubCommentsWithAttachment(fileUrl: filePath, params: parameters as NSDictionary , success: { (success) in
                self.selectedViewForSelectedImage.isHidden=true
                if(success.statusCode == 200){
                    self.state = true
                    self.arrayCommentData.append(success.data)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
                    self.stopAnimating()
                    self.imgCounter = 0
                    self.inputTextField.text = ""
                }
                else{
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
        
        func getUserCommentsPagination(postId:String,commentId:String, page_no:String)
        {
            self.showLoader()
            let parameters : [String: Any] = ["post_id": postId, "comment_id": commentId]
            UserHandler.getSubComments(pageNo: page_no, params: parameters as NSDictionary , success: { (success) in
                
                if(success.statusCode == 200){
                    self.totalLastPage = success.pagination.lastPage
                    self.currentPage = success.pagination.currentPage
                    
                    if(success.data.count > 0 ){
                        for i in 0..<success.data.count   {
                            self.arrayCommentData.append(success.data[i])
                        }
                        self.tableView.reloadData()
                        self.stopAnimating()
                        
                    }else{
                        let alertView = AlertView.prepare(title: "Message", message: success.message, okAction: {
                        })
                        self.present(alertView, animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }
                else{
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
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let scrollPosition = scrollView.contentOffset
            
            if isKeyboardOpened {
                if scrollPosition.y > previousScrollPosition.y {
                    dismissKeyboard()
                }
            }
            previousScrollPosition = scrollPosition
        }
    }
    
    class CommentCell2: UITableViewCell {
        
        @IBOutlet var profileImageView: UIImageView!{
            didSet {
                profileImageView.roundWithClearColor()
            }
        }
        
        @IBOutlet var userNameLabel: UILabel!
        @IBOutlet var commentLabel: UILabel!
        @IBOutlet var commentTimeLabel: UILabel!
        
        @IBOutlet weak var deleteComments: UIButton!
        
        @IBOutlet weak var updateComments: UIButton!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            selectionStyle = .none
        }
    }
    
    class commentWithImageCell2: UITableViewCell {
        
        @IBOutlet var profileImageView: UIImageView!{
            didSet {
                profileImageView.roundWithClearColor()
            }
        }
        @IBOutlet weak var image_attachementView: UIImageView!
        @IBOutlet weak var deleteComments: UIButton!
        @IBOutlet weak var updateComments: UIButton!
        @IBOutlet var userNameLabel: UILabel!
        @IBOutlet var commentLabel: UILabel!
        @IBOutlet var commentTimeLabel: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            selectionStyle = .none
        }
}
