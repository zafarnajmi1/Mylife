//
//  MySchedulesViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import Hero
import DropDown
//import ALCameraViewController


extension SegueIdentifiable {
    static var mySchedulesViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: MySchedulesViewController.className)
    }
}


class MySchedulesViewController: UIViewController , NVActivityIndicatorViewable {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var viewTable: UITableView!
    var dataSource : [NewsFeedData] = []
    var pagination : NewsFeedPagination?
   static var isCameFromMySchedulePostViewController = false
    var sortOrder = "newest"
    var buttonn = UIButton()
    var buttonn1 = UIButton()

    var oldToNewBool = Bool()
    var newToOldBool = Bool()

    var label = UILabel()
    var label1 = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        oldToNewBool = false
        newToOldBool = false
        
        
        buttonn = UIButton(frame: CGRect(x: 20, y: 50, width: 30, height: 30))
        buttonn.backgroundColor = .clear
        buttonn.tag = 1
        buttonn.setImage(#imageLiteral(resourceName: "radio"), for: UIControl.State.normal)
        buttonn.setImage(#imageLiteral(resourceName: "selected-radio"), for: UIControl.State.selected)
        buttonn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        buttonn1 = UIButton(frame: CGRect(x: 20, y: 90, width: 30, height: 30))
        buttonn1.backgroundColor = .clear
        buttonn1.tag = 2
        buttonn1.setImage(#imageLiteral(resourceName: "radio"), for: UIControl.State.normal)
        buttonn1.setImage(#imageLiteral(resourceName: "selected-radio"), for: UIControl.State.selected)
        buttonn1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        
        label = UILabel(frame: CGRect(x: 80, y: 50, width: 200, height: 30))
        
        label1 = UILabel(frame: CGRect(x: 80, y: 90, width: 200, height: 30))
        label.text = "Old To New".localized
        label1.text = "New To Old".localized
    
        self.title = "Scheduled Posts".localized
        addBackButton()
        setupViews()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        switch sender.tag {
        case 1:
            
            if buttonn.isSelected == true{
                buttonn.isSelected = false
                oldToNewBool = false
                newToOldBool = false

            }
            else{
                buttonn.isSelected = true
                buttonn1.isSelected = false
                oldToNewBool = true
                
                newToOldBool = false
            }
            
            break
            
        case 2:
            
            if buttonn1.isSelected == true{
                buttonn1.isSelected = false
                newToOldBool = false
                oldToNewBool = false
            }
            else{
                buttonn1.isSelected = true
               
                buttonn.isSelected = false
                oldToNewBool = false
                newToOldBool = true
            }
            
            break
        
        default:
            break
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyScheduledData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
     func addBackButton1(backImage: UIImage = #imageLiteral(resourceName: "back")) {
        hideBackButton()
        
        
        
        if lang == "ar" {
            let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Ar-back"), style: .plain, target: self, action: #selector(onBackButtonClciked))
            navigationItem.leftBarButtonItem  = backButton
        }
        else {
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClciked))
            navigationItem.leftBarButtonItem  = backButton
        }
       
        
        
      
            let sortingButton = UIButton(type: .custom)
            sortingButton.setImage(#imageLiteral(resourceName: "sort"), for: .normal)
            sortingButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            sortingButton.addTarget(self, action: #selector(MySchedulesViewController.sortingButtonAction), for: .touchUpInside)
            let menuItem = UIBarButtonItem(customView: sortingButton)
            
            menuItem.customView?.snp.makeConstraints({ (make) in
                make.width.equalTo(22)
                make.height.equalTo(22)
            })
            
        
            navigationItem.rightBarButtonItem = menuItem
    }
    
    @objc func sortingButtonAction(){
        print("sorting button pressed")
        showAleert()
    }
    
    
    
    
    func showAleert(){
        let alertController = UIAlertController(title: "Sort Scheduled Posts".localized, message: nil, preferredStyle: UIAlertController.Style.alert) //if you increase actionSheet height to move default button down increase \n \n count and get your layout proper
        
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 110)
        let customView = UIView(frame: rect)
        
        customView.backgroundColor = .clear //Background colour as clear
        if(lang == "ar"){
            
            let mov  = CGRect(x: customView.frame.origin.x  , y: 50, width: self.label.frame.size.width, height: self.label.frame.size.height)
            self.label.frame = mov
            
            let mov1  = CGRect(x: customView.frame.origin.x , y: 90, width: self.label1.frame.size.width, height: self.label1.frame.size.height)
            self.label1.frame = mov1
            
            let v = CGRect(x: customView.frame.origin.x + 125, y: 50, width: self.label.frame.size.width, height: self.label.frame.size.height)
            buttonn.frame = v
            let vv = CGRect(x: customView.frame.origin.x + 125, y: 90, width: self.label1.frame.size.width, height: self.label1.frame.size.height)
            buttonn1.frame = vv
        }
        customView.addSubview(label)
        customView.addSubview(label1)
        customView.addSubview(buttonn)
        customView.addSubview(buttonn1)
       
        
        alertController.view.addSubview(customView)
        let ExitAction = UIAlertAction(title: "SORT".localized, style: .default, handler: {(alert: UIAlertAction!) in
            
            if self.oldToNewBool == true {
                //go to juice Controller
                print("Old to New")
                self.sortOrder = "oldest"
                self.getMyScheduledData()
            }
            if self.newToOldBool == true{
                //go to food controller
                print("New to Old")
                 self.sortOrder = "newest"
                self.getMyScheduledData()
            }
           
            if (self.oldToNewBool == false)  && (self.newToOldBool == false){
                //peform your operation like naything you want safety side
                print("Not selected Any")
            }
            
            
        })
        //self.view.frame.height
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.30) //here you can define new height for action Sheet
        alertController.view.addConstraint(height);
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(ExitAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
        
    }

    
    
    
    
    
    
    func setupViews(){
        
        let nib = UINib(nibName: "CellMyScheduleSimpleCell", bundle: nil)
        viewTable.register(nib, forCellReuseIdentifier: "CellMyScheduleSimpleCell")
        
        let textFeed = UINib(nibName: "CellMyScheduleImage", bundle: nil)
        viewTable.register(textFeed, forCellReuseIdentifier: "CellMyScheduleImage")

        viewTable.delegate = self
        viewTable.dataSource = self
        viewTable.tableFooterView = UIView(frame: .zero)
        
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "")
//        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
//        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
//        tblView.addSubview(refreshControl)
        
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    
    func showImageInFeedCell (ImageView _imageView : UIImageView, URL _imageUrl : String?) {
        if let _string = _imageUrl {
            if let url = URL(string: _string) {
                _imageView.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                _imageView.sd_setShowActivityIndicatorView(true)
                _imageView.sd_setIndicatorStyle(.gray)
                _imageView.contentMode = .scaleAspectFill
                _imageView.clipsToBounds = true
            }
        }
    }
    
    //MARK:- Button Clicks
    @objc func btnFeedMoreImagesClick(_ sender : UIButton) {
        let index = sender.tag
        let objFeed = dataSource[index]
        if objFeed.postType == "image"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NewsFeedMultipleImagesViewController") as! NewsFeedMultipleImagesViewController
            controller.newFeedData = objFeed
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func btnEditPostClick(_ sender : UIButton) {
        
      
        MySchedulesViewController.isCameFromMySchedulePostViewController=true
        
        let index = sender.tag
        let objFeed = dataSource[index]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditMySchedulePostViewController") as! EditMySchedulePostViewController
        controller.selectedPost = objFeed
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func btnRemovePostClick(_ sender : UIButton) {
        
        
        let alert = UIAlertController(title: "REMOVE POST".localized, message: "Do you really want to remove this post?".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: { action in
            let index = sender.tag
            let objFeed = self.dataSource[index]
            if let _id = objFeed.id {
                self.removePost (postId : _id)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFeed = dataSource[index!]
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
    
}

// MARK: My Schedule Services
extension MySchedulesViewController {
    
    func getMyScheduledData (){
        showLoader()
        FeedsHandler.getMySchedules(sortOrder: sortOrder, success: { (successResponse) in
            
            self.stopAnimating()
            if successResponse.statusCode == 200 {
                self.dataSource = successResponse.data
                self.pagination = successResponse.pagination
                self.viewTable.reloadData()
                
            }else{
                print("No Feed data")
                self.showSuccess(message: "No schedule post available")
            }
            
        }) { (errorResponse) in
            print("errors")
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    func getMyScheduleNextPage (){
        guard let url = self.pagination?.nextPageUrl else {
            return
        }
        
//        FeedsHandler.getNewsFeedNextPage(
        FeedsHandler.getMyShedulesNextPage(url: url,success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                guard let newData = successResponse.data else{return}
                self.dataSource.append(contentsOf: newData)
                self.pagination = successResponse.pagination
                self.viewTable.reloadData()
            }else{
                print("No Feed data")
//                self.showError(message: "No Feed")
                //self.stopAnimating()
            }
        }) { (errorResponse) in
            self.showError(message: errorResponse!.message)
        }
    }
    
    func removePost (postId : Int){
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        showLoader()
        FeedsHandler.removePost(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            self.stopAnimating()
            let message = successResponse["message"] as! String
            self.showSuccess(message: message)
            self.dataSource.removeAll()
            self.getMyScheduledData()
        }) { (errorResponse) in
            self.showError(message: errorResponse!.message)
            self.stopAnimating()
            //self.showAlrt(message: (errorResponse?.message)!)
        }
    }
    
    
}

extension MySchedulesViewController : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let objFeed = dataSource[indexPath.row]
        
        if objFeed.postType == "text"{
            return 110
        } else if (objFeed.postType == "video" || objFeed.postType == "image") {
            let simpleCell = tableView.dequeueReusableCell(withIdentifier: "CellMyScheduleImage") as! CellMyScheduleImage
            return CGFloat(300+Int(simpleCell.txtDescriptionOfPost.layer.height))
        }
        return 110
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Scheduled post found".localized + "\n" + "Pull to refresh :)".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 2
            tableView.backgroundView  = noDataLabel
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 190, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = dataSource[indexPath.row]
        
        if indexPath.row == dataSource.count - 2  {
            self.getMyScheduleNextPage()
        }
        
        
        if (post.postType == "video" || post.postType == "image") {
            let simpleCell = tableView.dequeueReusableCell(withIdentifier: "CellMyScheduleImage") as! CellMyScheduleImage
            simpleCell.selectionStyle = .none
            simpleCell.viewContainer.clipsToBounds = true
            simpleCell.viewContainer.layer.cornerRadius = 5
            
            simpleCell.oltRemovePost.tag = indexPath.row
            simpleCell.oltEditPost.tag = indexPath.row
            
//            btnRemovePostClick

            simpleCell.oltEditPost.addTarget(self, action: #selector(self.btnEditPostClick(_:)), for: .touchUpInside)
            simpleCell.oltRemovePost.addTarget(self, action: #selector(self.btnRemovePostClick(_:)), for: .touchUpInside)
            
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(post.createdAt.toDouble))
            let date = CommonMethods.timeAfterSinceDate(date: timeStream, numericDates: true) // .timeAgoSinceDate(date: timeStream, numericDates:true)
            
            var checkinPlace = ""
            var feelingText = ""
            if post.checkinPlace != nil && post.checkinPlace != ""{
                checkinPlace = " is at " + post.checkinPlace
            }
            if post.feeling.translation != nil {
                feelingText = " feeling " + post.feeling.translation.title
            }
            
            var friendsString = ""
            if post.tagFriends.count > 0{
                 friendsString = " with "
                for item in post.tagFriends{
                    friendsString = friendsString + " \(item.fullName!)" + ","
                }
            }
            
           
            let dateScheduledFor = NSDate(timeIntervalSince1970: post.scheduleAt.toDouble)
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            
            let dateString = dayTimePeriodFormatter.string(from: dateScheduledFor as Date)
            
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:post.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: date + friendsString + feelingText + "\(checkinPlace)" + "  Scheduled For \(dateString)", attributes:attrs2)
            
            
            attributedString1.append(attributedString2)
            simpleCell.lblUserName.attributedText = attributedString1
            
            let imgUrl2 = post.user.image
            if let url = URL(string: imgUrl2!) {
                simpleCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                simpleCell.imgUser.sd_setShowActivityIndicatorView(true)
                simpleCell.imgUser.sd_setIndicatorStyle(.gray)
                simpleCell.imgUser.contentMode = .scaleAspectFill
                simpleCell.imgUser.clipsToBounds = true
            }
            
            if (post.postType == "image") {
                if let _data = post.postAttachmentData {
                    switch (_data.count) {
                    case 0:
                        simpleCell.viewMultipleFeedImages.isHidden = true
                        simpleCell.txtDescriptionOfPost.isHidden=false
                        
                        simpleCell.imgFeed.isHidden = true
                        simpleCell.imgPlay.isHidden = true
                        break;
                    case 1:
                        simpleCell.btnMoreFeedImages.backgroundColor = .clear
                        simpleCell.btnMoreFeedImages.setTitle("", for: .normal)
                        simpleCell.btnMoreFeedImages.tag = indexPath.row
                        simpleCell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        simpleCell.btnMoreFeedImages2.tag = indexPath.row
                        simpleCell.btnMoreFeedImages2.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        
                        if post.descriptionField != ""{
                            simpleCell.txtDescriptionOfPost.isHidden=false
                            simpleCell.txtDescriptionOfPost.text = post.descriptionField!
                            
                            var frame = simpleCell.txtDescriptionOfPost.frame
                            frame.size.height = simpleCell.txtDescriptionOfPost.contentSize.height
                            simpleCell.txtDescriptionOfPost.frame = frame
                            
                            
                        }
                        
                        simpleCell.viewMultipleFeedImages.isHidden = true
                        simpleCell.imgFeed.isHidden = false
                        simpleCell.imgPlay.isHidden = true
                        showImageInFeedCell(ImageView: simpleCell.imgFeed, URL: _data[0].path)
                        break;
                    case 2:
                        simpleCell.btnMoreFeedImages.backgroundColor = .clear
                        simpleCell.btnMoreFeedImages.setTitle("", for: .normal)
                        simpleCell.btnMoreFeedImages.tag = indexPath.row
                        simpleCell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        simpleCell.btnMoreFeedImages2.tag = indexPath.row
                        simpleCell.btnMoreFeedImages2.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        if post.descriptionField != ""{
                            simpleCell.txtDescriptionOfPost.isHidden=false
                            simpleCell.txtDescriptionOfPost.text = post.descriptionField!
                        }
                        
                        simpleCell.viewMultipleFeedImages.isHidden = false
                        simpleCell.imgFeed.isHidden = true
                        simpleCell.imgPlay.isHidden = true
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage2, URL: _data[1].path)
                        break;
                    case 3:
                        simpleCell.btnMoreFeedImages.backgroundColor = .clear
                        simpleCell.btnMoreFeedImages.setTitle("", for: .normal)
                        simpleCell.btnMoreFeedImages.tag = indexPath.row
                        simpleCell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        simpleCell.btnMoreFeedImages2.tag = indexPath.row
                        simpleCell.btnMoreFeedImages2.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        
                        if post.descriptionField != ""{
                            simpleCell.txtDescriptionOfPost.isHidden=false
                            simpleCell.txtDescriptionOfPost.text = post.descriptionField!
                        }
                        
                        simpleCell.viewMultipleFeedImages.isHidden = false
                        simpleCell.imgFeed.isHidden = true
                        simpleCell.imgPlay.isHidden = true
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage2, URL: _data[1].path)
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage3, URL: _data[2].path)
                        break;
                    default:
                        simpleCell.btnMoreFeedImages.backgroundColor = UIColor.init(r: 0.0/255.0, g: 0.0/255.0, b:0.0/255.0, a: 0.5) //UIColor.init(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5  )
                        simpleCell.btnMoreFeedImages.setTitle("+\(_data.count - 3) more", for: .normal)
                        simpleCell.btnMoreFeedImages.tag = indexPath.row
                        simpleCell.btnMoreFeedImages.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)
                        simpleCell.btnMoreFeedImages2.tag = indexPath.row
                        simpleCell.btnMoreFeedImages2.addTarget(self, action: #selector(self.btnFeedMoreImagesClick(_:)), for: .touchUpInside)

                        if post.descriptionField != ""{
                            simpleCell.txtDescriptionOfPost.isHidden=false
                            simpleCell.txtDescriptionOfPost.text = post.descriptionField!
                        }
                        
                        simpleCell.viewMultipleFeedImages.isHidden = false
                        simpleCell.imgFeed.isHidden = true
                        simpleCell.imgPlay.isHidden = true
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage2, URL: _data[1].path)
                        showImageInFeedCell(ImageView: simpleCell.imgFeedImage3, URL: _data[2].path)
                        break
                    }
                }
            } else {
                if let _data = post.postAttachmentData {
                    switch (_data.count) {
                    case 0:
                        simpleCell.viewMultipleFeedImages.isHidden = true
                        simpleCell.imgFeed.isHidden = true
                        simpleCell.imgPlay.isHidden = true
                        break;
                    case 1:
                        
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                        print(indexPath.row)
                        simpleCell.imgPlay.addGestureRecognizer(tapGestureRecognizer)
                        
                        simpleCell.viewMultipleFeedImages.isHidden = true
                        simpleCell.txtDescriptionOfPost.isHidden=true
                        simpleCell.imgFeed.isHidden = false
                        simpleCell.imgPlay.isHidden = false
                        showImageInFeedCell(ImageView: simpleCell.imgFeed, URL: _data[0].thumbnail)
                        break;
                    default:
                        break
                    }
                }
            }
            
            
            return simpleCell
        } else {
            let simpleCell = tableView.dequeueReusableCell(withIdentifier: "CellMyScheduleSimpleCell") as! CellMyScheduleSimpleCell
            simpleCell.selectionStyle = .none
            simpleCell.viewContainer.clipsToBounds = true
            simpleCell.viewContainer.layer.cornerRadius = 5
            
            simpleCell.oltRemovePost.tag = indexPath.row
            simpleCell.oltEditPost.tag = indexPath.row

            simpleCell.oltEditPost.addTarget(self, action: #selector(self.btnEditPostClick(_:)), for: .touchUpInside)
            simpleCell.oltRemovePost.addTarget(self, action: #selector(self.btnRemovePostClick(_:)), for: .touchUpInside)
            
            let timeStream = NSDate(timeIntervalSince1970: TimeInterval(post.createdAt.toDouble))
            let date = CommonMethods.timeAfterSinceDate(date: timeStream, numericDates: true)    //.timeAgoSinceDate(date: timeStream, numericDates:true)

            
            let dateScheduledFor = NSDate(timeIntervalSince1970: post.scheduleAt.toDouble)
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            
            let dateString = dayTimePeriodFormatter.string(from: dateScheduledFor as Date)

            
            var checkinPlace = ""
            var feelingText = ""
            if post.checkinPlace != nil && post.checkinPlace != ""{
                checkinPlace = " is at ".localized + post.checkinPlace
            }
            if post.feeling.translation != nil {
                feelingText = " feeling ".localized + post.feeling.translation.title
            }
            
            var friendsString = ""
            if post.tagFriends.count > 0{
                 friendsString = " with "
                for item in post.tagFriends{
                    friendsString = friendsString + " \(item.fullName!)" + ","
                }
                
            }
            
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:post.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: date + friendsString + feelingText + "\(checkinPlace)" + "\nScheduled For \(dateString)", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            simpleCell.lblUserName.attributedText = attributedString1
            simpleCell.lblDescription.text = post.descriptionField
            
            let imgUrl2 = post.user.image
            if let url = URL(string: imgUrl2!) {
                simpleCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                simpleCell.imgUser.sd_setShowActivityIndicatorView(true)
                simpleCell.imgUser.sd_setIndicatorStyle(.gray)
                simpleCell.imgUser.contentMode = .scaleAspectFill
                simpleCell.imgUser.clipsToBounds = true
            }
            
            return simpleCell
        }
        return UITableViewCell()
    }

}
