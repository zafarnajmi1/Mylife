//
//  AllFriendsController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage
import NVActivityIndicatorView
import Hero

class AllFriendsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet var btnContacts: UIButton!
    //    @IBOutlet weak var tableViewContraint: NSLayoutConstraint!
    @IBOutlet weak var oltBackButton: UIButton!
    @IBOutlet weak var viewNavigation: UIView!
    var isFromOtherUser = true
    var statusFlag = false
    
    var otherUserId = 0
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var allFriendSearch: UISearchBar!
        {
        didSet{
            allFriendSearch.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var friends = ModelGenerator.generateRequestModel()
    var arrayDataFriends = [UserGetAllFriendsData] ()
    var searchArrayFriendsData = [UserGetAllFriendsData]()
    var refreshControl: UIRefreshControl!
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.allFriendSearch.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -05, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        tableView.addSubview(refreshControl)
        if statusFlag == false{
            viewNavigation.isHidden = true
            btnContacts.isHidden = true
            self.tableViewConstraint.constant = 0
        }else{
            viewNavigation.isHidden = false
            btnContacts.isHidden = false
        }
        
        
        self.title = "All Friends".localized
        
        /*
        let object = RequestModel(name: "Some name", mutalFriends: 6)
        friends.append(object)
        tableView.reloadData()
        */
        
        
        
        getAllFriends()
        addBackButton()
        
        
        let contactsButton = UIButton(type: .custom)
        contactsButton.setImage(#imageLiteral(resourceName: "ic_contact_phone"), for: .normal)
        contactsButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        contactsButton.addTarget(self, action: #selector(onContactsButtonClicked), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: contactsButton)
        
        menuItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
        })
        
        
        navigationItem.rightBarButtonItem  = menuItem
    }
    @objc func onContactsButtonClicked(){
//        print("contacts button clicked")
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ActivityLogViewController") as! ActivityLogViewController
//
//        //self.present(controller, animated: false, completion: nil)
//        self.navigationController?.pushViewController(controller, animated: true)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ActivityLogViewController") as! ActivityLogViewController
        //self.navigationController?.pushViewController(controller, animated: true)
        //let profileController = UIStoryboard.mainStoryboard.instantiateVC(ActivityLogViewController.self)!
        let controller2 = embedIntoNavigationController(controller)
        
        presentVC(controller2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Simple Functions
    
    @objc func refresh(sender:AnyObject) {
        getAllFriends()
    }
    
    @objc func btnUserImageClick(sender : UIButton){
//        let index = sender.tag
//        let objFriend = arrayDataFriends[index]
//
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        controller.isFromOtherUser = true
//        controller.otherUserId = objFriend.id
//
//        self.navigationController?.pushViewController(controller, animated: true)

        let objFriend = arrayDataFriends[sender.tag]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFriend.id
        self.navigationController?.pushViewController(controller, animated: true)
    
    }
    
    func tapProfilePictureGestureRecognizer(tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFriend = arrayDataFriends[index!]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFriend.id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    //MARK:- TableView Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayDataFriends.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Friends found, Pull to refresh".localized
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
        //        return friends.count
        
   
        if(searchActive == true){
            return searchArrayFriendsData.count
        }
        else{
            return arrayDataFriends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllFriendsCell.className, for: indexPath) as! AllFriendsCell
        
        let objOwnUser = UserHandler.sharedInstance.userData
        
        if(searchActive == true)
        {
            let objFriend = searchArrayFriendsData[indexPath.row]
            cell.labelName.text = objFriend.fullName
            cell.labelMutualFriends.text = ""
//            cell.labelMutualFriends.text = objFriend.email
            cell.userImageView.sd_setImage(with: URL(string: objFriend.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
        }
        else
        {
            let objFriend = arrayDataFriends[indexPath.row]
            cell.labelName.text = objFriend.fullName
            cell.labelMutualFriends.text = ""
//            cell.labelMutualFriends.text = objFriend.email
            cell.userImageView.sd_setImage(with: URL(string: objFriend.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
            cell.btnUserImageView.tag = indexPath.row
            cell.btnUserImageView.addTarget(self, action: #selector(self.btnUserImageClick(sender:)), for: .touchUpInside)
            
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
//            cell.userImageView.tag = indexPath.row
//            cell.userImageView.addGestureRecognizer(tapGestureRecognizer)

            let userNameTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
            cell.labelName.tag = indexPath.row
            cell.labelName.isUserInteractionEnabled = true
            cell.labelName.addGestureRecognizer(userNameTapGestureRecognizer)

            if isFromOtherUser {
                cell.buttonTag.isHidden = true
            }
            else{
                if objFriend.id != objOwnUser?.id{
                    cell.buttonTag.isHidden = false
//                    let userNameTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
//                    cell.labelName.tag = indexPath.row
//                    cell.labelName.isUserInteractionEnabled = true
//                    cell.labelName.addGestureRecognizer(userNameTapGestureRecognizer)
                }
            }
            

        }
        
        cell.delegate = self as allFriendDelegateCell
        return cell
    }
    
    // MARK: - Controllers Actions
    @IBAction func actionBack(_ sender: Any) {
        if statusFlag == true{
            navigationController?.popViewController(animated: true)
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnContact(_ sender: UIButton) {
        let profileController = UIStoryboard.mainStoryboard.instantiateVC(ActivityLogViewController.self)!
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllFriendsController") as! AllFriendsController
        self.navigationController?.pushViewController(profileController, animated: true)
        
//        let controller = embedIntoNavigationController(profileController)
//        presentVC(controller) {
//            self.closeNavigationDrawer()
//        }
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllFriendsController") as! AllFriendsController
//        self.present(controller, animated: false, completion: nil)
    }
    
    @objc func userNameTapped (tapGestureRecognizer: UITapGestureRecognizer){
        let index = tapGestureRecognizer.view?.tag
        let objFriend = arrayDataFriends[index!]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        controller.isFromOtherUser = true
        controller.otherUserId = objFriend.id
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    // MARK: - Search Delegate Functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchedFriends(subString:allFriendSearch.text!)
        searchBar.resignFirstResponder()
        //        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if allFriendSearch.text == nil || allFriendSearch.text == ""{
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            self.searchActive = false;
            self.tableView.reloadData()
        }
    }
    
    // MARK: - API Calls
    func getAllFriends()
    {
        self.showLoader()
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print(userID)
        
        if isFromOtherUser{
            userID = otherUserId
        }
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
                self.arrayDataFriends = successResponse.data
                print(self.arrayDataFriends)
                if self.arrayDataFriends.count > 0 {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }else{
                    // show alert friends not found
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
//                    self.displayAlertMessage("you have no friends")
                    //self.addView(withState: .error)
                    
                }
                self.stopAnimating()
            }
            else{
                self.refreshControl.endRefreshing()
                self.stopAnimating()
                self.displayAlertMessage(successResponse.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    func getSearchedFriends(subString:String){
        self.showLoader()
        FriendsHandler.getAllSearchedFriends(subString: subString,success: { (successResponse) in
            if successResponse.statusCode == 200{
                
                self.searchArrayFriendsData = successResponse.data
                if self.searchArrayFriendsData.count > 0 {
                    self.tableView.reloadData()
                }else{
                    // show alert friends not found
                    self.displayAlertMessage("You have no friends")
                }
                self.stopAnimating()
            }
            else{
                self.displayAlertMessage(successResponse.message)
                self.stopAnimating()
            }
        }){ (error) in
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
}
extension AllFriendsController: ViewStateProtocol {
    var errorMessage: String? {
        get {
            return "Pull to refresh your friend list"
        }
        set {
            self.errorMessage = "Pull to refresh your friend list"
        }
    }
    
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        addView(withState: .error)
        addView(withState: .empty)
        removeAllViews()
    }
}

// MARK: - All Extensions
extension AllFriendsController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "All")
    }
}
extension AllFriendsController: allFriendDelegateCell {
    
    internal func informedCell_Index(cell: AllFriendsCell)
    {
        let item = tableView.indexPath(for: cell)
        let getfriendId = arrayDataFriends[item!.item].id
        
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : getfriendId!]
        
        FriendsHandler.removeFriends(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
                self.stopAnimating()
                self.getAllFriends()
                self.tableView.reloadData()
            //    self.viewDidLoad()
                //                self.loginUser()
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }){ (error) in
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
        print(getfriendId!)
    }
}

// MARK: - Delegates - Protocols
protocol allFriendDelegateCell {
    func informedCell_Index(cell: AllFriendsCell)
}

// MARK: - Cell Class
class AllFriendsCell: UITableViewCell {
    
    var delegate:allFriendDelegateCell!
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.roundWithClear()
        }
    }
    
    @IBOutlet var btnUserImageView: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet var labelMutualFriends: UILabel!
    @IBOutlet weak var buttonTag: UIButton!
    
    var isFriend = false {
        didSet {
            if isFriend {
                buttonTag.setBackgroundColor(.primary, forState: .normal)
                buttonTag.setBackgroundColor(.primary, forState: .normal)
            } else {
                buttonTag.setBackgroundColor(.primary, forState: .normal)
                buttonTag.setBackgroundColor(.primary, forState: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonTag.setTitle("UN FRIEND".localized, for: .normal)
        selectionStyle = .none
    }
    
    @IBAction func onButtonUnfriendClicked(_ sender: UIButton) {
        isFriend = !isFriend
        
        self.delegate?.informedCell_Index(cell: self)
    }
}



extension AllFriendsController {
    func embedIntoNavigationController(_ rootController: UIViewController, presentingTransition: HeroDefaultAnimationType = .pageIn(direction: .left), dismissTransition: HeroDefaultAnimationType = .pageOut(direction: .right)) -> UINavigationController {
        rootController.isHeroEnabled = true
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.view.backgroundColor = .white
        navigationController.isHeroEnabled = true
        navigationController.heroModalAnimationType = .selectBy(presenting: presentingTransition, dismissing: dismissTransition)
        
        return navigationController
    }
    
}
