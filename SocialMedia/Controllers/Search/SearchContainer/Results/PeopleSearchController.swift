//
//  PeopleSearchController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 25/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var peopleSearchController : SegueIdentifier {
        return SegueIdentifier(rawValue: PeopleSearchController.className)
    }
}

class PeopleSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable{
    
    
    @IBOutlet weak var viewTopBoarder: UIView!
    @IBOutlet weak var searchPeople: UITableView!
    var errorMessage: String? = "Please Try Again".localized
    var refreshControl: UIRefreshControl!
    var arrayDataPeople = [SearchPeopleData] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTopBoarder.isHidden = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: 0.0, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        searchPeople.addSubview(refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: People_ScreensNotification), object: nil)
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        if searchType == nil{
           
            getSearchedFriends(subString:"")
        }
        else{
             getSearchedFriends(subString:searchType!)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set("3", forKey: "searchKey")
        userDefaults.synchronize()
        
    }
  
    @objc private func getDataUpdate() {
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        
        if searchType != nil{
            getSearchedFriends(subString:searchType!)
        }
        else{
            displayAlertMessage("Search text is empty.".localized)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func SearchString(searchString: String) {
        print(searchString)
    }
    
    // MARK: - Simple Functions
    
    @objc func refresh(sender:AnyObject) {
        
        getSearchedFriends(subString:"")
    }
    
    func addFriendCellRemoveMethod(myIndex: Int) {
        
        self.arrayDataPeople.remove(at: myIndex) // dataSource being your dataSource array
        self.searchPeople!.reloadData()
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - API Calls
    func getSearchedFriends(subString:String)
    {
        self.showLoader()
        let parameters : [String: Any] = ["criteria" : subString ]
        
        UserHandler.searchPeople(params: parameters as NSDictionary , success: { (successResponse) in
            
        //    print(successResponse.data)
            
            if successResponse.statusCode == 200{
                
                
                self.arrayDataPeople = successResponse.data
                
                print("\n")
                print(successResponse.data)
                print("\n")
                
                
                if self.arrayDataPeople.count > 0
                {
                    self.searchPeople.reloadData()
                    self.viewTopBoarder.isHidden = false
                    self.refreshControl.endRefreshing()
                }
                else
                {
                    // show alert friends not found
                    self.viewTopBoarder.isHidden = true
                    self.refreshControl.endRefreshing()
                    self.arrayDataPeople.removeAll()
                    self.searchPeople.reloadData()
                    
                }
                self.stopAnimating()
            }
            else
            {
                self.viewTopBoarder.isHidden = true
                self.displayAlertMessage(successResponse.message)
                self.refreshControl.endRefreshing()
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
             self.viewTopBoarder.isHidden = true
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            
            
            
        }
    }
    
    
    // MARK: - TableView Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayDataPeople.count == 0{
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayDataPeople.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchPeople.dequeueReusableCell(withIdentifier: PeopleSearchControllerCell.className, for: indexPath) as! PeopleSearchControllerCell
        
        
        let objFriend = arrayDataPeople[indexPath.row]
        cell.labelName.text = objFriend.fullName
        cell.userId = objFriend.id
        cell.myController = self
        

//        let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped(tapGestureRecognizer:)))
//        cell.labelName.tag = indexPath.row
//        cell.labelName.isUserInteractionEnabled = true
//        cell.labelName.addGestureRecognizer(userNameTapGesture)
        
        
//        cell.location.text = String(indexPath.row) + " Mutual Friends"
        cell.location.isHidden = true
        cell.userImageView.sd_setImage(with: URL(string: objFriend.image), placeholderImage: UIImage(named: "placeholder.png"))
        cell.userImageView.isUserInteractionEnabled = false
        cell.delegate = self as PeopleDelegateCell
        
        cell.blockBtn.setTitle("Block".localized, for: .normal)
        
        if ((objFriend.friends?.count)! > 0)
        {
            print("is friend ")
            
            if (objFriend.friends![0].is_friend == true)
            {
                cell.AddFriendButton.setTitle("Unfriend".localized, for: .normal)
            }
            else
            {
                cell.AddFriendButton.setTitle("Cancel Request".localized, for: .normal)
            }
        }
        else
        {
            cell.AddFriendButton.setTitle("Add Friend".localized, for: .normal)
        
        }
        
        return cell
    }
    internal func peopleSearchString(searchString: String) {
        print(searchString)
    }
    func userNameTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        let index = tapGestureRecognizer.view?.tag
//        let objFeed = self.arrayDataPeople[index!]
//        let objOwnUser = UserHandler.sharedInstance.userData
//
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//
//        if objOwnUser?.id != objFeed.id{
//            controller.isFromOtherUser = true
//            controller.otherUserId = objFeed.id
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - All Extensions
extension PeopleSearchController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PEOPLE".localized)
    }
}

extension PeopleSearchController: ViewStateProtocol {
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        
        self.errorMessage = "Please Try Again"
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}

extension PeopleSearchController: PeopleDelegateCell {
    func refreshTableView(message: String) {
        print("nvMsg: \(message)")
        self.getSearchedFriends(subString: "")
    }
    
    
    
  
    
    
    internal func peopleInformedCell_Index(cell: PeopleSearchControllerCell)
    {
        
        let item = searchPeople.indexPath(for: cell)
        
        let getfriendId = arrayDataPeople[item!.item].id
        
        let data = arrayDataPeople[item!.item]
        
        if ((data.friends?.count)! > 0)
        {
            print("is friend ")
            
            if (data.friends![0].is_friend == true)
            {
                unFriendClick(id: getfriendId!)
                //cell.AddFriendButton.setTitle("un Friend", for: .normal)
            }
            else
            {
                //cell.AddFriendButton.setTitle("Request Send", for: .normal)
                rejectFriendRequest(id: getfriendId!)
            }
            
        }
        else
        {
            self.addFriend(getfriendId: getfriendId!)
            //cell.AddFriendButton.setTitle("Add Friend", for: .normal)
        }
        
        
       
        
    }
    
    // un friend
    func unFriendClick(id: Int)
    {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : id]
        
        FriendsHandler.removeFriends(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200)
            {
                self.stopAnimating()
               // self.displayAlertMessage(success.message)
                
                let alertView = AlertView.prepare(title: "Alert".localized, message: success.message, okAction: {
                    
                    let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
                    if searchType != nil
                    {
                        self.arrayDataPeople.removeAll()
                        self.searchPeople.reloadData()
                        self.getSearchedFriends(subString:searchType!)
                    }
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                
                
                
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }){ (error) in
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    // MARK: - Reject Friend Request
    func rejectFriendRequest(id: Int) {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id": id]
        FriendsHandler.rejectFriendRequest(params: parameters as NSDictionary,success: { (successResponse) in
            if (successResponse.statusCode == 200){
                self.stopAnimating()
    
                let alertView = AlertView.prepare(title: "Alert".localized, message: successResponse.message, okAction: {
                    
                    let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
                    if searchType != nil
                    {
                        self.arrayDataPeople.removeAll()
                        self.searchPeople.reloadData()
                        self.getSearchedFriends(subString:"")
                    }
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
            }
            else{
                self.stopAnimating()

                self.displayAlertMessage(successResponse.message)
            }
        }){ (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
    
    
    func addFriend(getfriendId : Int)
    {
        self.showLoader()
        let parameters : [String: Any] = ["friend_id" : getfriendId]
        
        FriendsHandler.sendFriendRequest(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Alert".localized, message: success.message, okAction: {
                    
                    let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
                    if searchType != nil
                    {
                        self.arrayDataPeople.removeAll()
                        self.searchPeople.reloadData()
                        self.getSearchedFriends(subString:searchType!)
                    }
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
            }
            else
            {
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
}

// MARK: - Delegates - Protocols
protocol PeopleDelegateCell {
    
    func peopleInformedCell_Index(cell: PeopleSearchControllerCell)
    func refreshTableView(message : String)
}

// MARK: - Cell Class
class PeopleSearchControllerCell: UITableViewCell {
    
    var delegate:PeopleDelegateCell!
    var myController: UIViewController!
    var userId: Int!
    
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.roundWithClear()
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet weak var AddFriendButton: UIButton!
     @IBOutlet weak var blockBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func onButtonAddFriendButtonClicked(_ sender: UIButton) {
        
        self.delegate?.peopleInformedCell_Index(cell: self)
    }
    
    @IBAction func blockBtnTapped(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title:"".localized,message:"Do you really want to block this contact?".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"Yes".localized,style: .default){UIAlertAction in
            print("ok button pressed")
             self.requestToBlockUser()
        }
        let cancelAction = UIAlertAction(title:"No".localized,style: .default){UIAlertAction in
            print("cancel button pressed")
        }
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
         self.myController.present(alertController, animated: true, completion: nil)
     
    }
    
    
    func requestToBlockUser() {
        UserBlockManager.shared.blockUserBy(userId: userId) { (error, rootModel) in
            if error == nil {
              
                 let title = "".localized
                let alertView = AlertView.prepare(title: title, message: (rootModel?.message!)!.localized, okAction: {
                      self.delegate.refreshTableView(message: (rootModel?.message!)!.localized)
                })
                self.myController.present(alertView, animated: true, completion: nil)
                
            }
            else {
                let alertView = AlertView.prepare(title: "Error".localized, message: error!, okAction: {
                })
                self.myController.present(alertView, animated: true, completion: nil)
              
            }
        }
    }
    
}


