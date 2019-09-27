//
//  PhotosSearchController.swift
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
    static var photosSearchController : SegueIdentifier {
        return SegueIdentifier(rawValue: PhotosSearchController.className)
    }
}

// MARK: - Delegates - Protocols
protocol sendPostId: class {
    
    func postId(postId:Int)
    
}

class PhotosSearchController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource {
  weak var delegate:sendPostId?
    
    @IBOutlet weak var searchPstTableView: UITableView!
   
    
    var errorMessage: String? = "Please Try Again"
    var arrayPostData = [searchPostData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchPstTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: photos_ScreensNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        if searchType != nil{
            getPhotoPost(criteriaString:searchType!, postType:"image")
        }
        else{
            getPhotoPost(criteriaString:"", postType:"image")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("4", forKey: "searchKey")
        userDefaults.synchronize()
    }
    
    @objc private func getDataUpdate() {
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        if searchType != nil{
            getPhotoPost(criteriaString:searchType!, postType:"image")
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
    func getPhotoPost(criteriaString:String, postType:String)
    {
        self.showLoader()
        let parameters : [String: Any] = ["criteria": criteriaString,
                                          "post_type": postType
        ]
        SearchHandler.getPost(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200){
                
//                self.totalLastPage = success.pagination.lastPage
//                self.currentPage = success.pagination.currentPage
                
                if(success.data.count > 0 ){
                    self.arrayPostData = success.data
                    self.searchPstTableView.reloadData()
                  // self.tableView.scrollToBottom(animated: true)
                    self.searchPstTableView.reloadData()
                    self.stopAnimating()
                }else{
                    self.stopAnimating()
                    self.arrayPostData.removeAll()
                    self.searchPstTableView.reloadData()
                }
            }
            else{
                self.stopAnimating()
//                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: { _ in
//                })
//                self.present(alertView, animated: true, completion: nil)
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
    
    // MARK: - TableView Delegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 140
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if arrayPostData.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No result found".localized + "\n" + "Try something else:)".localized;        noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayPostData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchPstTableView.dequeueReusableCell(withIdentifier: photoSearchControllerCell.className, for: indexPath) as! photoSearchControllerCell
        
        
        let objSearch = arrayPostData[indexPath.row]
        cell.name.text = objSearch.user.fullName
        if let _likes = objSearch.totalLikes {
            if  _likes == 0{
                    cell.likeCount.text = " Like"
            }else{
                 cell.likeCount.text = "\(_likes) Like"
            }
           
        }
        if let _comments = objSearch.totalComments {
            if _comments == 0{
                cell.commentCount.text =  " comment" // "\(_comments) comment"
            }else{
                cell.commentCount.text =  "\(_comments) comment"
            }
            
        }
//        cell.commentCount.text = String(objSearch.totalComments) + " comment"
//        cell.likeCount.text = String(objSearch.totalLikes) + " Like"
        cell.comment.text = objSearch.descriptionField
         let myNSDate = NSDate(timeIntervalSince1970: TimeInterval(objSearch.createdAt.toDouble))
        cell.time.text = CommonMethods.timeAgoSinceDate(date:myNSDate, numericDates:true)
        cell.userImageView.sd_setImage(with: URL(string: objSearch.postAttachmentData[0].path!), placeholderImage: UIImage(named: "placeHolderGenral"))
        cell.userImageView.sd_setShowActivityIndicatorView(true)
        cell.userImageView.sd_setIndicatorStyle(.gray)
        cell.userImageView.contentMode = .scaleAspectFill
        cell.userImageView.clipsToBounds = true
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postID = arrayPostData[indexPath.row].id
        guard let newData = postID else{return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "showPostViewController") as! showPostViewController
        controller.postId = String(describing: newData)
        self.present(controller, animated: true, completion: nil)
    }
}
extension PhotosSearchController: PhotoDelegateCell{
    
    
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
    
    func photoLike_Index(cell: photoSearchControllerCell){
        
        let item = searchPstTableView.indexPath(for: cell)
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
        
        self.searchPstTableView.reloadData()
    }
    func photoComment_Index(cell: photoSearchControllerCell){
        let item = searchPstTableView.indexPath(for: cell)
        print(item!.item)
        let objFeed = arrayPostData[item!.item]
        self.goToComments(objFeed: objFeed)
        
    }
    func sendIndexNumber(cell:photoSearchControllerCell){
        
        let item = searchPstTableView.indexPath(for: cell)
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

extension PhotosSearchController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PHOTOS".localized)
    }
}

extension PhotosSearchController: ViewStateProtocol {
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        
        self.errorMessage = "Please Try Again"
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}

// MARK: - Delegates - Protocols
protocol PhotoDelegateCell {
    
    func photoLike_Index(cell: photoSearchControllerCell)
    func photoComment_Index(cell: photoSearchControllerCell)
    func sendIndexNumber(cell:photoSearchControllerCell)
    
}
// MARK: - Cell Class
class photoSearchControllerCell: UITableViewCell {
    
    var delegate:PhotoDelegateCell!
    
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
        self.delegate?.sendIndexNumber(cell:self)
    }

}

