//
//  AllSearchController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 25/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import Hero
extension SegueIdentifiable {
    static var allSearchController : SegueIdentifier {
        return SegueIdentifier(rawValue: AllSearchController.className)
    }
}

class AllSearchController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    var errorMessage: String? = "Please Try Again"
    var arrayPostData = [searchPostData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: All_ScreensNotification), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboardWhenTappedAround()
        
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        if searchType != nil{
            getAllPost(criteriaString:searchType!, postType:"")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        userDefaults.set("1", forKey: "searchKey")
        userDefaults.synchronize()
    }
    @objc private func getDataUpdate() {
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        if searchType != nil{
            getAllPost(criteriaString:searchType!, postType:"")
        }
        else{
            displayAlertMessage("Search text is empty.".localized)
        }
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
    
 // MARK: - Api Calls
    func getAllPost(criteriaString:String, postType:String)
    {
        self.showLoader()
        let parameters : [String: Any] = ["criteria": criteriaString,
                                          "post_type": postType
        ]
        SearchHandler.getPost(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
                if(success.data.count > 0 ){
                    self.arrayPostData = success.data
                    self.tableView.reloadData()
                    self.stopAnimating()
                }else{
                    self.stopAnimating()
                    self.arrayPostData.removeAll()
                    self.tableView.reloadData()
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
    func likePost (postId: Int){
        //self.showLoader()
        let parameters : [String: Any] = ["post_id" : "\(postId)"]
        print(parameters)
        FeedsHandler.postLike(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            //let message = successResponse["message"]
            // self.showAlrt(message: message as! String)
            self.stopAnimating()
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.displayAlertMessage((errorResponse?.message)!)
            
        }
    }
    
}

extension AllSearchController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "All POSTS".localized)
    }
}

extension AllSearchController: ViewStateProtocol {
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}


extension AllSearchController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - TableView Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayPostData.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No result found".localized + "\n" + "Try something else:)".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 2
            tableView.backgroundView  = noDataLabel
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 160, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "Searchicon")
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
            
        }else{
            tableView.backgroundView = nil
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayPostData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let objSearch = arrayPostData[indexPath.row]
        
        if objSearch.postType == "image"{
            let cell = tableView.dequeueReusableCell(withIdentifier: allPhotoSearchControllerCell.className, for: indexPath) as! allPhotoSearchControllerCell
            cell.name.text = objSearch.user.fullName
            if let _likes = objSearch.totalLikes {
                cell.likeCount.text = (_likes == 0) ? " Like".localized : "\(_likes) Like".localized
            }
            if let _comments = objSearch.totalComments {
                cell.commentCount.text = (_comments == 0) ? " comment".localized : "\(_comments) comment".localized
            }
//            cell.commentCount.text = String(objSearch.totalComments) + " comment"
//            cell.likeCount.text = String(objSearch.totalLikes) + " Like"
            cell.comment.text = objSearch.descriptionField
            let myNSDate = NSDate(timeIntervalSince1970: TimeInterval(objSearch.createdAt.toDouble))
            cell.time.text = CommonMethods.timeAgoSinceDate(date:myNSDate, numericDates:true)
            cell.userImageView.sd_setImage(with: URL(string: objSearch.postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))
            cell.userImageView.sd_setShowActivityIndicatorView(true)
            cell.userImageView.sd_setIndicatorStyle(.gray)
            cell.userImageView.contentMode = .scaleAspectFill
            cell.userImageView.clipsToBounds = true
            //        cell.delegate = self as! PhotoDelegateCell
            cell.delegate = self as AllPhotoDelegateCell
            return cell
            
        }else if objSearch.postType == "video"{
            let cell = tableView.dequeueReusableCell(withIdentifier: allVideoSearchControllerCell.className, for: indexPath) as! allVideoSearchControllerCell
            cell.name.text = objSearch.user.fullName
            if let _likes = objSearch.totalLikes {
                cell.likeCount.text = (_likes == 0) ? " Like".localized : "\(_likes) Like".localized
            }
            if let _comments = objSearch.totalComments {
                cell.commentCount.text = (_comments == 0) ? " comment".localized : "\(_comments) comment".localized
            }
//            cell.commentCount.text = String(objSearch.totalComments) + " comment"
//            cell.likeCount.text = String(objSearch.totalLikes) + " Like"
            cell.comment.text = objSearch.descriptionField
            let myNSDate = NSDate(timeIntervalSince1970: TimeInterval(objSearch.createdAt.toDouble))
            cell.time.text = CommonMethods.timeAgoSinceDate(date:myNSDate, numericDates:true)
            cell.userImageView.sd_setImage(with: URL(string: objSearch.postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeHolderGenral"))
            cell.userImageView.sd_setShowActivityIndicatorView(true)
            cell.userImageView.sd_setIndicatorStyle(.gray)
            cell.userImageView.contentMode = .scaleAspectFill
            cell.userImageView.clipsToBounds = true
            //        cell.delegate = self as! PhotoDelegateCell
            cell.delegate = self as AllVideoDelegateCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: simplePostCell.className, for: indexPath) as! simplePostCell
            cell.name.text = objSearch.user.fullName
            if let _likes = objSearch.totalLikes {
                cell.likeCount.text = (_likes == 0) ? " Like".localized : "\(_likes) Like".localized
            }
            if let _comments = objSearch.totalComments {
                cell.commentCount.text = (_comments == 0) ? " comment".localized : "\(_comments) comment".localized
            }
//            cell.commentCount.text = String(objSearch.totalComments) + " comment"
//            cell.likeCount.text = String(objSearch.totalLikes) + " Like"
            cell.comment.text = objSearch.descriptionField
            let myNSDate = NSDate(timeIntervalSince1970: TimeInterval(objSearch.createdAt.toDouble))
            cell.time.text = CommonMethods.timeAgoSinceDate(date:myNSDate, numericDates:true)
            //        cell.delegate = self as! PhotoDelegateCell
            cell.delegate = self as AllSimplePostDelegateCell
            return cell
            
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postID = arrayPostData[indexPath.row].id
        guard let newData = postID else{return}
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
        controller.postId = String(describing: newData)
        self.present(controller, animated: true, completion: nil)
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
//        controller.postId = String(describing: newData)
//        self.navigationController?.pushViewController(controller, animated: false)
    }
}


extension AllSearchController:AllSimplePostDelegateCell{
    
    func simplePostLike_Index(cell: simplePostCell) {
        let item = tableView.indexPath(for: cell)
        let objFeed = arrayPostData[item!.item]
        
        if objFeed.myLikeCount == 0{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes + 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount + 1
        }else{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes - 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount - 1
        }
        
        self.likePost(postId: objFeed.id)
        //        let indexPath = IndexPath(item: index!, section: 2)
        
        self.tableView.reloadData()
        
    }
    func simplePostComment_Index(cell: simplePostCell){
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        let objFeed = arrayPostData[item!.item]
        self.goToComments(objFeed: objFeed)
    }
    func sendsimplePostIndexNumber(cell:simplePostCell){
        let item = tableView.indexPath(for: cell)
        let index = item!.item
        let objFeed = arrayPostData[index]
        let objOwnUser = UserHandler.sharedInstance.userData
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if objOwnUser?.id != objFeed.userId{
            controller.isFromOtherUser = true
            controller.statusFlag = true
            controller.otherUserId = objFeed.userId
        }else{
            controller.statusFlag = true
        }
        self.present(controller, animated: false, completion: nil)
    }
    
}


// MARK: - Delegates - Protocols
protocol AllSimplePostDelegateCell {
    
    func simplePostLike_Index(cell: simplePostCell)
    func simplePostComment_Index(cell: simplePostCell)
    func sendsimplePostIndexNumber(cell:simplePostCell)
    
    
}
// MARK: - Cell Class
class simplePostCell: UITableViewCell {
    
    var delegate:AllSimplePostDelegateCell!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTap(tapGestureRecognizer:)))
        name.isUserInteractionEnabled = true
        name.addGestureRecognizer(tapGestureRecognizer)
        selectionStyle = .none
    }
    
    @IBAction func actionLike(_ sender: Any) {
        self.delegate?.simplePostLike_Index(cell: self)
    }
    @IBAction func actionComment(_ sender: Any) {
        self.delegate?.simplePostComment_Index(cell: self)
    }
    @objc func userNameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.sendsimplePostIndexNumber(cell:self)
    }
}


extension AllSearchController:AllPhotoDelegateCell{
    
    func photoLike_Index(cell: allPhotoSearchControllerCell) {
        let item = tableView.indexPath(for: cell)
        let objFeed = arrayPostData[item!.item]
        
        if objFeed.myLikeCount == 0{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes + 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount + 1
        }else{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes - 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount - 1
        }
        
        self.likePost(postId: objFeed.id)
        //        let indexPath = IndexPath(item: index!, section: 2)
        
        self.tableView.reloadData()
        
    }
    func photoComment_Index(cell: allPhotoSearchControllerCell){
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        let objFeed = arrayPostData[item!.item]
        self.goToComments(objFeed: objFeed)
    }
    func sendPhotoIndexNumber(cell:allPhotoSearchControllerCell){
        let item = tableView.indexPath(for: cell)
        let index = item!.item
        let objFeed = arrayPostData[index]
        let objOwnUser = UserHandler.sharedInstance.userData
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if objOwnUser?.id != objFeed.userId{
            controller.isFromOtherUser = true
            controller.statusFlag = true
            controller.otherUserId = objFeed.userId
        }else{
            controller.statusFlag = true
        }
        self.present(controller, animated: false, completion: nil)
    }
    
}
// MARK: - Delegates - Protocols
protocol AllPhotoDelegateCell {
    
    func photoLike_Index(cell: allPhotoSearchControllerCell)
    func photoComment_Index(cell: allPhotoSearchControllerCell)
     func sendPhotoIndexNumber(cell:allPhotoSearchControllerCell)
    
}
// MARK: - Cell Class
class allPhotoSearchControllerCell: UITableViewCell {
    
    var delegate:AllPhotoDelegateCell!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            //            userImageView.roundWithClear()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTap(tapGestureRecognizer:)))
        name.isUserInteractionEnabled = true
        name.addGestureRecognizer(tapGestureRecognizer)
        selectionStyle = .none
    }
    
    @IBAction func actionLike(_ sender: Any) {
        self.delegate?.photoLike_Index(cell: self)
    }
    @IBAction func actionComment(_ sender: Any) {
        self.delegate?.photoComment_Index(cell: self)
    }
    @objc func userNameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.sendPhotoIndexNumber(cell:self)
    }
    
}


extension AllSearchController:AllVideoDelegateCell{

   
    //MARK:- Delegate Function
    
    func goToComments (objFeed: searchPostData){
        
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
    
    func videoLike_Index(cell: allVideoSearchControllerCell) {
        let item = tableView.indexPath(for: cell)
        let objFeed = arrayPostData[item!.item]
        
        if objFeed.myLikeCount == 0{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes + 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount + 1
        }else{
            arrayPostData[item!.item].totalLikes = objFeed.totalLikes - 1
            arrayPostData[item!.item].myLikeCount = objFeed.myLikeCount - 1
        }
        
        self.likePost(postId: objFeed.id)
        //        let indexPath = IndexPath(item: index!, section: 2)
        
        self.tableView.reloadData()
        
    }
    func videoComment_Index(cell: allVideoSearchControllerCell){
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        let objFeed = arrayPostData[item!.item]
        self.goToComments(objFeed: objFeed)
    }
    func sendIndexNumber(cell:allVideoSearchControllerCell){
        let item = tableView.indexPath(for: cell)
        let index = item!.item
        let objFeed = arrayPostData[index]
        let objOwnUser = UserHandler.sharedInstance.userData
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if objOwnUser?.id != objFeed.userId{
            controller.isFromOtherUser = true
            controller.statusFlag = true
            controller.otherUserId = objFeed.userId
        }else{
            controller.statusFlag = true
        }
        self.present(controller, animated: false, completion: nil)
    }
    
}

// MARK: - Delegates - Protocols
protocol AllVideoDelegateCell {
    
    func videoLike_Index(cell: allVideoSearchControllerCell)
    func videoComment_Index(cell: allVideoSearchControllerCell)
     func sendIndexNumber(cell:allVideoSearchControllerCell)
    
}
// MARK: - Cell Class
class allVideoSearchControllerCell: UITableViewCell {
    
    var delegate:AllVideoDelegateCell!
    
    @IBOutlet weak var vieoPlayerButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            //            userImageView.roundWithClear()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTap(tapGestureRecognizer:)))
        name.isUserInteractionEnabled = true
        name.addGestureRecognizer(tapGestureRecognizer)
        selectionStyle = .none
    }
    
    @IBAction func actionLike(_ sender: Any) {
        self.delegate?.videoLike_Index(cell: self)
    }
    @IBAction func actionComment(_ sender: Any) {
        self.delegate?.videoComment_Index(cell: self)
    }
    @objc func userNameTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.sendIndexNumber(cell:self)
    }
    
    @IBAction func actionVideoPlayer(_ sender: Any) {
    }
}
