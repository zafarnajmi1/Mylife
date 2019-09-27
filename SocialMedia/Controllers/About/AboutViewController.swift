//
//  AboutViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import AVFoundation
import AVKit
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var aboutViewcontroller : SegueIdentifier {
        return SegueIdentifier(rawValue: AboutViewController.className)
    }
}

class AboutViewController: UIViewController, NVActivityIndicatorViewable  {
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var oltBackBtn: UIButton!
    @IBOutlet weak var navigationConstraint: NSLayoutConstraint!
    var statusFlag = false
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = tableView.rowHeight
        }
    }
    
    var userProfile = [String:Any]()
    var arrayUserPhotoes = [UserPhotoesData]()
    var arrayUserVideos = [UserVideosData]()
    var obj: UserLoginData?
    var objOtherUser : AboutUserData?
    
    var isFromOtheruser = false
    var otherUserId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if statusFlag == false{
            viewNavigation.isHidden = true
            self.navigationConstraint.constant = 0
            
        }else{
            viewNavigation.isHidden = false
            
        }
        
        obj = UserHandler.sharedInstance.userData
        addBackButton()
        
        self.title = "User Info".localized
        if isFromOtheruser
        {
            tableView.delegate = nil
            tableView.dataSource = nil
            self.showLoader()
            getUserAbout()
        }
        else
        {
            tableView.delegate = self
            tableView.dataSource = self
            addRightButton()
            setupUserPhotoes()
            setupUserVideos()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        obj = UserHandler.sharedInstance.userData
        tableView.reloadData()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if statusFlag == true{
            navigationController?.popViewController(animated: true)
            dismiss(animated: false, completion: nil)
        }
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    //MARK:- APi Calls
    // Get Other user About info
    func getUserAbout (){
        let parameters : [String: Any] = ["user_id" : otherUserId ]
        UserHandler.getUserAbout(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200{
                self.objOtherUser = successResponse.data
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.setupUserPhotoes()
                self.setupUserVideos()
                 self.stopAnimating()
            }else{
                
            }
        }) { (errorResponse) in
            //print(errorResponse?.message)
             self.stopAnimating()
        }
    }
    // User Photos
    func setupUserPhotoes() {
        self.showLoader()
        var uid = obj?.id
        if isFromOtheruser{
            uid = otherUserId
        }
        let parameters : [String: Any] = ["user_id" :  String(uid!) ]
        
        UserHandler.getUserPhotoes(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.arrayUserPhotoes = success.data
                self.stopAnimating()
                self.tableView.reloadData()
                 self.stopAnimating()
            }
            else
            {
                self.displayAlertMessage(success.message)
                self.stopAnimating()
                
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    func setupUserVideos() {
        self.showLoader()
        var uid = obj?.id
        if isFromOtheruser {
            uid = otherUserId
        }
        let parameters : [String: Any] = ["user_id" :  String(uid!) ]
        
        UserHandler.getUserVideos(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.arrayUserVideos = success.data
                self.stopAnimating()
                self.tableView.reloadData()
                 self.stopAnimating()
            }
            else
            {
                self.displayAlertMessage(success.message)
                self.stopAnimating()
            }
        })
        { (error) in
            print("error = ",error!)
           self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    
    //MARK:- Tableview number of section Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if obj?.email != nil
        {
//            if obj?.workDetails.count != 0 && obj?.educationDetails.count != 0 && arrayUserPhotoes.count != 0 && arrayUserVideos.count != 0{
//                return 6
//            }
//            else if obj?.workDetails.count != 0 &&
            return 9
        }
        else
        {
            return 0
        }
    }
}

extension AboutViewController {
    func addRightButton() {
        let editButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(onEditButtonClicked))
        editButton.title = "Edit".localized
        navigationItem.rightBarButtonItem  = editButton
    }
    
    @objc func onEditButtonClicked() {
        segueTo(controller: .editProfileViewController)
    }
    
    func playVideo(url:Int) {
        
        if arrayUserVideos[url].postAttachmentData[0].path != nil{
            let videoAttachment = arrayUserVideos[url].postAttachmentData[0].path
            let videoURL = URL(string: videoAttachment!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else{
            
        }
    }
}

//MARK:- tableView Delegate Functions

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 7 && indexPath.row == 1 || indexPath.section == 8 && indexPath.row == 1 {
            return 200
        } else if (indexPath.section == 5 && indexPath.row == 0) {
            return 40
        }
        else if (indexPath.section == 6 && indexPath.row == 0) {
            return 40
        }else if (indexPath.section == 3 || indexPath.section == 4){
            return 35
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 7 && indexPath.row == 1 || indexPath.section == 8 && indexPath.row == 1 {
            return 200
        } else if (indexPath.section == 5 && indexPath.row == 0) {
            return 30
        }
        else if (indexPath.section == 6 && indexPath.row == 0) {
            return 30
        }
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        if section == 1{
            return 3
        }
        else if section == 2 && obj?.aboutMe != "''" {
            return 2
        }
        else if section == 3 && obj?.workDetails.count != 0{
            if isFromOtheruser {
                if objOtherUser != nil{
                    return (objOtherUser?.workDetails.count)!
                }else{
                    return 0
                }
            }else {
                return (obj?.workDetails.count)!
            }
        }
        else if section == 4 && obj?.educationDetails.count != 0{
            if isFromOtheruser{
                if objOtherUser != nil{
                    return (objOtherUser?.educationDetails.count)!
                }else {
                    return 0
                }
            }else {
                return (obj?.educationDetails.count)!
            }
            
        }else if section == 5{
            return 1
        }else if section == 6{
            return 1
        }
            
        else if section == 7 && arrayUserPhotoes.count != 0{
            return 2
        }else if section == 8 && arrayUserVideos.count != 0{
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
            if indexPath.row == 0
            {
                cell.labelInfo.text = isFromOtheruser ? objOtherUser?.fullName : obj?.fullName
                cell.leftImage.image = #imageLiteral(resourceName: "profile")
                cell.hideEditButton = true
            }
            else if indexPath.row == 1
            {
                cell.labelInfo.text = isFromOtheruser ? objOtherUser?.livingPlace : obj?.livingPlace
                cell.leftImage.image = #imageLiteral(resourceName: "address")
                cell.hideEditButton = true
            }
            else if indexPath.row == 2
            {
                cell.labelInfo.text = isFromOtheruser ? objOtherUser?.mobile : obj?.mobile
                cell.leftImage.image = #imageLiteral(resourceName: "phone")
                cell.hideEditButton = true
                
                let border = CALayer()
                border.backgroundColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 8, y: cell.frame.size.height - 1, width: cell.frame.size.width - 16, height: 0.5)
                cell.layer.addSublayer(border)
            }
            else if indexPath.row == 3
            {
                cell.labelInfo.text = isFromOtheruser ? objOtherUser?.email : obj?.email
                cell.leftImage.image = #imageLiteral(resourceName: "email")
                cell.hideEditButton = true
            }
            
            return cell
        }
        else if indexPath.section == 1
        {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoOtherCell.className, for: indexPath) as! UserInfoOtherCell
                if isFromOtheruser {
                    cell.labelHeading.text = "Birthday".localized
                    cell.labelInfo.text = convertDate(dateString: (objOtherUser?.birthday.toDouble)!)
                    let border = CALayer()
                    border.backgroundColor = UIColor.lightGray.cgColor
                    border.frame = CGRect(x: 8, y: cell.frame.size.height - 1, width: cell.frame.size.width - 16, height: 0.5)
                    cell.layer.addSublayer(border)
                }else {
                    cell.labelHeading.text = "Birthday".localized
                    cell.labelInfo.text = convertDate(dateString: (obj?.birthday.toDouble)!)
                    let border = CALayer()
                    border.backgroundColor = UIColor.lightGray.cgColor
                    border.frame = CGRect(x: 8, y: cell.frame.size.height - 1, width: cell.frame.size.width - 16, height: 0.5)
                    cell.layer.addSublayer(border)
                }
                cell.hideEditButton = true
                return cell
            }
            else if (indexPath.row == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoOtherCell.className, for: indexPath) as! UserInfoOtherCell
                if isFromOtheruser {
                    cell.labelHeading.text = "Gender".localized
                    if let gender = obj?.gender {
                        cell.labelInfo.text = gender.localized
                    }
                    //cell.labelInfo.text = objOtherUser?.gender.localized
                }else {
                    cell.labelHeading.text = "Gender".localized
                    if let gender = obj?.gender {
                        cell.labelInfo.text = gender.localized
                    }
                    
                    
                }
                cell.hideEditButton = true
                return cell
            }
            else if (indexPath.row == 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoOtherCell.className, for: indexPath) as! UserInfoOtherCell
                if isFromOtheruser {
                    cell.labelHeading.text = "Relationship Status".localized
                    if let relationStatus = obj?.relationship {
                        cell.labelInfo.text = relationStatus.localized
                    }
                    
                }else {
                    cell.labelHeading.text = "Relationship Status".localized
                    if let relationStatus = obj?.relationship {
                        cell.labelInfo.text = relationStatus.localized
                    }
                    
                }
                cell.hideEditButton = true
                return cell
            }
        }
            
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutEditCell.className, for: indexPath) as! AboutEditCell
                //cell.aboutHeader.text = "Some"
                if(lang == "ar")
                {
                    cell.aboutBtn.setTitle("About".localized, for: .normal)
                    cell.aboutBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
                }else
                {
                    cell.aboutBtn.setTitle("About".localized, for: .normal)
                    cell.aboutBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                }
                
                cell.backgroundColor = UIColor.white
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutDetailCell.className, for: indexPath) as! AboutDetailCell
                cell.labelAbout.text = isFromOtheruser ? objOtherUser?.aboutMe : obj?.aboutMe
                //cell.labelAbout.text = "SOme"
                cell.backgroundColor = UIColor.white
                return cell
            }
        }
        else if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
            var workInfo = "Not Available"

            if isFromOtheruser {
                if objOtherUser != nil{
                    workInfo = (objOtherUser?.workDetails[indexPath.row].position)! + " at " + (objOtherUser?.workDetails[indexPath.row].company)!
                }
            }else {
                workInfo = (obj?.workDetails[indexPath.row].position)! + " at " + (obj?.workDetails[indexPath.row].company)!
            }
            cell.labelInfo.text = workInfo
            cell.leftImage.image = #imageLiteral(resourceName: "work")
            cell.hideEditButton = true
            return cell
        }
            
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
            var educationInfo = "Not Available"
            if isFromOtheruser{
                if objOtherUser != nil{
                    educationInfo = "Studied " + (objOtherUser?.educationDetails[indexPath.row].degree)! + " at " + (objOtherUser?.educationDetails[indexPath.row].school)!
                }
            }else{
                educationInfo = "Studied " + (obj?.educationDetails[indexPath.row].degree)! + " at " + (obj?.educationDetails[indexPath.row].school)!
            }
            cell.labelInfo.text = educationInfo
            cell.leftImage.image = #imageLiteral(resourceName: "education")
            cell.hideEditButton = true
            return cell
            
        }else if indexPath.section==5 {
            let docCell  = tableView.dequeueReusableCell(withIdentifier: DocumentsCell.className, for: indexPath) as! DocumentsCell
            docCell.documentLbl.text = "Documents".localized
            return docCell
        }
        else if indexPath.section==6 {
            let savedStoriesCell  = tableView.dequeueReusableCell(withIdentifier: SavedStoriesCell.className, for: indexPath) as! SavedStoriesCell

            savedStoriesCell.savedStoriesLbl.text = "Saved Stories".localized
            
            return savedStoriesCell
        }
        
        else if indexPath.section == 7
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
                cell.labelInfo.text = "Photos".localized
                cell.leftImage.image = #imageLiteral(resourceName: "photo")
                cell.buttonEdit.isHidden = true
                return cell
            }
            else
            {
                if arrayUserPhotoes.count == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myPhotoesCell_1", for: indexPath) as! myPhotoesCell
                    cell.imgViewOne.image = UIImage(named: "placeHolderGenral")
                    cell.imgViewOne.clipsToBounds = true
                    return cell
                }
                else if arrayUserPhotoes.count == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myPhotoesCell_1", for: indexPath) as! myPhotoesCell
                    cell.imgViewOne.sd_setImage(with: URL(string: arrayUserPhotoes[0].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgViewOne.sd_setShowActivityIndicatorView(true)
                    cell.imgViewOne.sd_setIndicatorStyle(.gray)
                    cell.imgViewOne.clipsToBounds = true
                    cell.delegate = self as TapOnPicture
                    return cell
                }
                else if arrayUserPhotoes.count == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myPhotoesCell_2", for: indexPath) as! myPhotoesCell
                    cell.imgView2One.sd_setImage(with: URL(string: arrayUserPhotoes[0].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView2Two.sd_setImage(with: URL(string: arrayUserPhotoes[1].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    
                    cell.imgView2One.sd_setShowActivityIndicatorView(true)
                    cell.imgView2One.sd_setIndicatorStyle(.gray)
                    cell.imgView2One.clipsToBounds = true
                    
                    cell.imgView2Two.sd_setShowActivityIndicatorView(true)
                    cell.imgView2Two.sd_setIndicatorStyle(.gray)
                    cell.imgView2Two.clipsToBounds = true
                    
                    cell.delegate = self as TapOnPicture
                    return cell
                    
                }
                else if arrayUserPhotoes.count == 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myPhotoesCell_3", for: indexPath) as! myPhotoesCell
                    cell.imgView3One.sd_setImage(with: URL(string: arrayUserPhotoes[0].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView3Two.sd_setImage(with: URL(string: arrayUserPhotoes[1].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView3Three.sd_setImage(with: URL(string: arrayUserPhotoes[2].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    
                    cell.imgView3One.sd_setShowActivityIndicatorView(true)
                    cell.imgView3One.sd_setIndicatorStyle(.gray)
                    cell.imgView3One.clipsToBounds = true
                    
                    cell.imgView3Two.sd_setShowActivityIndicatorView(true)
                    cell.imgView3Two.sd_setIndicatorStyle(.gray)
                    cell.imgView3Two.clipsToBounds = true
                    
                    cell.imgView3Three.sd_setShowActivityIndicatorView(true)
                    cell.imgView3Three.sd_setIndicatorStyle(.gray)
                    cell.imgView3Three.clipsToBounds = true
                    
                    cell.delegate = self as TapOnPicture
                    return cell
                    
                }
                else if arrayUserPhotoes.count > 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myPhotoesCell_4", for: indexPath) as! myPhotoesCell
                    cell.imgView4One.sd_setImage(with: URL(string: arrayUserPhotoes[0].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView4Two.sd_setImage(with: URL(string: arrayUserPhotoes[1].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView4Three.sd_setImage(with: URL(string: arrayUserPhotoes[2].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.imgView4Four.sd_setImage(with: URL(string: arrayUserPhotoes[3].postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
                    
                    cell.imgView4One.sd_setShowActivityIndicatorView(true)
                    cell.imgView4One.sd_setIndicatorStyle(.gray)
                    cell.imgView4One.clipsToBounds = true
                    
                    cell.imgView4Two.sd_setShowActivityIndicatorView(true)
                    cell.imgView4Two.sd_setIndicatorStyle(.gray)
                    cell.imgView4Two.clipsToBounds = true
                    
                    cell.imgView4Three.sd_setShowActivityIndicatorView(true)
                    cell.imgView4Three.sd_setIndicatorStyle(.gray)
                    cell.imgView4Three.clipsToBounds = true
                    
                    cell.imgView4Four.sd_setShowActivityIndicatorView(true)
                    cell.imgView4One.sd_setIndicatorStyle(.gray)
                    cell.imgView4One.clipsToBounds = true
                    
                    cell.delegate = self as TapOnPicture
                    return cell
                }
                
                return UITableViewCell()
            }
            
        }
        else if indexPath.section == 8
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
                cell.labelInfo.text = "Videos".localized
                cell.leftImage.image = #imageLiteral(resourceName: "video")
                cell.buttonEdit.isHidden = true
                return cell
            }
            else
            {
                 if arrayUserVideos.count == 1{
                
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myVideosCell_4", for: indexPath) as! myVideosCell
                    cell.videoView4One.sd_setImage(with: URL(string: self.arrayUserVideos[0].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Two.isHidden = true
                    cell.videoView4Four.isHidden = true
                    cell.videoView4Three.isHidden = true
                    cell.btnCell4PlayVideoTwoSimpleButton.isHidden = true
                    cell.btnCell4PlayVideoThreeSimpleButton.isHidden = true
                    cell.btnCell4MoreSimpleButton.isHidden = true
                    cell.delegate = self as TapOnVideo
                    return cell
                
                }
                else if arrayUserVideos.count == 2{
                
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myVideosCell_4", for: indexPath) as! myVideosCell
                    cell.videoView4One.sd_setImage(with: URL(string: self.arrayUserVideos[0].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Two.sd_setImage(with: URL(string: self.arrayUserVideos[1].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.btnCell4MoreSimpleButton.isHidden = true
                    cell.videoView4Four.isHidden = true
                    cell.videoView4Three.isHidden = true
                    cell.btnCell4PlayVideoThreeSimpleButton.isHidden = true
                    cell.delegate = self as TapOnVideo
                    return cell
                }else if arrayUserVideos.count == 3{
               
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myVideosCell_4", for: indexPath) as! myVideosCell
                    cell.videoView4One.sd_setImage(with: URL(string: self.arrayUserVideos[0].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Two.sd_setImage(with: URL(string: self.arrayUserVideos[1].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Three.sd_setImage(with: URL(string: self.arrayUserVideos[2].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.btnCell4MoreSimpleButton.isHidden = true
                    cell.videoView4Four.isHidden = true
                    cell.delegate = self as TapOnVideo
                    return cell
                
                }
                else if arrayUserVideos.count > 3{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "myVideosCell_4", for: indexPath) as! myVideosCell
                    //Need to uncomment these lines
                    cell.videoView4One.sd_setImage(with: URL(string: self.arrayUserVideos[0].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Two.sd_setImage(with: URL(string: self.arrayUserVideos[1].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Three.sd_setImage(with: URL(string: self.arrayUserVideos[2].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.videoView4Four.sd_setImage(with: URL(string: self.arrayUserVideos[3].postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
                    cell.delegate = self as TapOnVideo
                    return cell
                }
                
            }
            
        }
        else
        {
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==5{
            print("Documents Selected")
            goToMoreItemsScreen()
        }
        if  indexPath.section==6{
            print("Saved Stories Selected")
            goToSavedStoriesScreen()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
 //SavedStoriesPermanentlyViewController
    
    func goToSavedStoriesScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addsViewController = storyboard.instantiateViewController(withIdentifier: SavedStoriesPermanentlyViewController.className) as! SavedStoriesPermanentlyViewController
        
        if isFromOtheruser {
            addsViewController.userID = (objOtherUser?.id)!
        }else{
            let objUser = UserHandler.sharedInstance.userData
            let userID: Int = (objUser?.id)!
            print("user id ",userID)
            addsViewController.userID = userID
            
        }
        
       navigationController?.pushViewController(addsViewController, animated: true)
      //  present(addsViewController, animated: true, completion: nil)
    }
    
    
    func goToMoreItemsScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addsViewController = storyboard.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController

        if isFromOtheruser{
            if statusFlag == true{
                addsViewController.statusFlag = true
            }
            addsViewController.isFromOtherUser = true
            addsViewController.otherUserId = otherUserId
            
            
        }else{
            if statusFlag == true{
                addsViewController.statusFlag = true
            }
            addsViewController.isFromOtherUser = false
            addsViewController.otherUserId = 0
        }
        present(addsViewController, animated: true, completion: nil)
    }
    
    
}
// MARK:- Sender Cell Delegate Extension
extension AboutViewController: TapOnVideo {
    
    internal func sendVideoButtonNumber(cell: Int)
    {
        playVideo(url:cell)
    }
    internal func TapOnMoreVideo()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MoreVideosViewController") as! MoreVideosViewController
        if isFromOtheruser{
            controller.objOtherUser = objOtherUser
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK:- Sender Cell Delegate Extension
extension AboutViewController: TapOnPicture {
    
    internal func sendPictureButtonNumber(cell: Int)
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
//        controller.imageString = arrayUserPhotoes[cell].postAttachment.path
        controller.imageString = arrayUserPhotoes[cell].postAttachmentData[0].path
        self.navigationController?.pushViewController(controller, animated: true)
    }
    internal func TapOnMorePicture(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MorePhotosViewController") as! MorePhotosViewController
        if isFromOtheruser{
            controller.objOtherUser = objOtherUser
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Video Delegates - Protocols
protocol TapOnPicture {
    
    func sendPictureButtonNumber(cell: Int)
    func TapOnMorePicture()
}

class myPhotoesCell: UITableViewCell{
    
    var delegate:TapOnPicture!
    
    
    @IBOutlet weak var imgViewOne: UIImageView!
    @IBOutlet weak var imgView2One: UIImageView!
    @IBOutlet weak var imgView2Two: UIImageView!

    @IBOutlet weak var imgView3One: UIImageView!
    @IBOutlet weak var imgView3Two: UIImageView!
    @IBOutlet weak var imgView3Three: UIImageView!
    
    @IBOutlet weak var imgView4One: UIImageView!
    @IBOutlet weak var imgView4Two: UIImageView!
    @IBOutlet weak var imgView4Three: UIImageView!
    @IBOutlet weak var imgView4Four: UIImageView!
    @IBAction func actionImageFour(_ sender: Any) {
        
        self.delegate?.TapOnMorePicture()
    }
    
    override func awakeFromNib() {
        
    }
    // image cell - 4 Actions
    @IBAction func imageView4OneAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 0)
    }
    @IBAction func imageView4TwoAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 1)
    }
    @IBAction func imageView4ThreeAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 2)
    }
    // image cell - 3 Actions
    @IBAction func imageView3OneAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 0)
    }
    @IBAction func imageView3TwoAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 1)
    }
    @IBAction func imageView3FourAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 2)
    }
    // image cell - 2 Actions
    @IBAction func imageView2OneAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 0)
    }
    @IBAction func imageView2TwoAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 1)
    }
    // image cell - 1 Actions
    @IBAction func imageView1TwoAction(_ sender: Any) {
        self.delegate?.sendPictureButtonNumber(cell: 0)
    }
}

// MARK: - Video Delegates - Protocols
protocol TapOnVideo {
    
    func sendVideoButtonNumber(cell: Int)
    func TapOnMoreVideo()
}
class myVideosCell: UITableViewCell{
    
    var delegate:TapOnVideo!
    
    @IBOutlet weak var videoView4One: UIImageView!
    @IBOutlet weak var videoView4Two: UIImageView!
    @IBOutlet weak var videoView4Three: UIImageView!
    @IBOutlet weak var videoView4Four: UIImageView!
    
    @IBOutlet weak var btnCell4PlayVideoOneSimpleButton: UIButton!
    
    @IBOutlet weak var btnCell4PlayVideoTwoSimpleButton: UIButton!
    @IBAction func actionVideoFour(_ sender: Any) {
        self.delegate?.TapOnMoreVideo()
    }
    @IBOutlet weak var btnCell4PlayVideoThreeSimpleButton: UIButton!
    
    @IBOutlet weak var btnCell4MoreSimpleButton: UIButton!
    //MARK:- Video Cell 4 Actions
    @IBAction func btnCell4PlayVideoOne(_ sender: Any) {
        
        self.delegate?.sendVideoButtonNumber(cell: 0)
    }
    @IBAction func btnCell4PlayVideoTwo(_ sender: Any) {
        self.delegate?.sendVideoButtonNumber(cell: 1)
    }
    @IBAction func btnCell4PlayVideoThree(_ sender: Any) {
        self.delegate?.sendVideoButtonNumber(cell: 2)
    }
    
    
    
    
    
    
    
}
