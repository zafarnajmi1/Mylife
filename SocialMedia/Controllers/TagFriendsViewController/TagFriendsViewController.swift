//
//  TagFriendsViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 07/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var tagFriendsViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: TagFriendsViewController.className)
    }
}

class TagFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    @IBOutlet var doneBtn: UIButton! {
        didSet {
            doneBtn.setTitle("DONE".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //var friends = ModelGenerator.generateRequestModel()
    
    var arrayFriends = [UserGetAllFriendsData] ()
    var refreshControl: UIRefreshControl!

    var selectedFriends = [UserGetAllFriendsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedsHandler.sharedInstance.taggedFriends?.removeAll()
        FeedsHandler.sharedInstance.isFriendsTagged = false
        self.selectedFriends.removeAll()
        setupViews()
        getAllFriends()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - Custom
    override func onBackButtonClciked() {
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
        
        if selectedFriends.count > 0 {
            FeedsHandler.sharedInstance.isFriendsTagged = true
            FeedsHandler.sharedInstance.taggedFriends = self.selectedFriends
        }else{
            FeedsHandler.sharedInstance.isFriendsTagged = false
            FeedsHandler.sharedInstance.taggedFriends = nil
        }
    }

    func setupViews (){
        self.title = "Tag Friends".localized
        addBackButton()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -05, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        tableView.addSubview(refreshControl)
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    @objc func refresh(sender:AnyObject) {
        getAllFriends()
    }

    // MARK: - UITableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagFriendsCell.className, for: indexPath) as! TagFriendsCell       
        
        let objFriend = arrayFriends[indexPath.row]

        cell.userImageView.sd_setImage(with: URL(string: objFriend.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
        cell.buttonTag.setTitle("TAG".localized, for: .normal)
        let words = objFriend.fullName.components(separatedBy: " ")
        let firstName = words[0]
        cell.labelName.text = firstName
        cell.buttonTag.tag = indexPath.row
        cell.buttonTag.addTarget(self, action: #selector(self.tagUnTag(_:)), for: .touchUpInside)
        //selectedFriends.append(objFriend)
        
//        cell.buttonTag.isHidden = true
//        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        let objFriend = arrayFriends[indexPath.row]
//        selectedFriends.append(objFriend)
//        print(selectedFriends)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //let objFriend = arrayFriends[indexPath.row]
//        selectedFriends.remove(at: indexPath.row)
//        print(selectedFriends)
    }
    
    @objc func tagUnTag(_ sender : UIButton) {
        let objFriend = arrayFriends[sender.tag]
        if (objFriend.isTagged) {
            objFriend.isTagged = false
            sender.setTitle("TAG".localized, for: .normal)
           for index in 0..<selectedFriends.count{
                let friend = selectedFriends[index]
                if friend.id==objFriend.id{
                    selectedFriends.remove(at: index)
                    break
                }
            }
            print(selectedFriends)
        } else {
             let objFriend = arrayFriends[sender.tag]
            
            objFriend.isTagged = true
            sender.setTitle("UN TAG".localized, for: .normal)
            selectedFriends.append(objFriend)
            print(selectedFriends)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        print("done button pressed")
       //self.navigationController?.popViewController(animated: true)
        
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
        
        if selectedFriends.count > 0 {
            FeedsHandler.sharedInstance.isFriendsTagged = true
            FeedsHandler.sharedInstance.taggedFriends = self.selectedFriends
        }else{
            FeedsHandler.sharedInstance.isFriendsTagged = false
            FeedsHandler.sharedInstance.taggedFriends = nil
        }
    }
    // MARK: - API Calls
    func getAllFriends()
    {
        self.showLoader()
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print(userID)
        
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
                self.arrayFriends = successResponse.data
                print(self.arrayFriends)
                if self.arrayFriends.count > 0 {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }else{
                    // show alert friends not found
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                self.stopAnimating()
            }
            else{
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
}


class TagFriendsCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.roundWithClear()
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var buttonTag: UIButton!
    
    var isTagged = false {
        didSet {
            if isTagged {
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
        
        selectionStyle = .none
    }
    
//    @IBAction func onButtonTagClicked(_ sender: UIButton) {
//        if (isTagged) {
//             isTagged = false
//        } else {
//             isTagged = true
//        }
//    }
}
