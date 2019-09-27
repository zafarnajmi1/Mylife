//
//  UpdateStatusScheduleBirthdayTableViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/20/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class UpdateStatusScheduleBirthdayTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var btnbackbutton: UIButton!
    var arrayFriends = [UserGetAllFriendsData] ()
    var selectedFriends = [UserGetAllFriendsData]()
    @IBOutlet weak var fiendsTableView: UITableView!
    
    @IBOutlet var lblbirthdayupcoming: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayFriends.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/2.8, y: 340, width: 130, height: 30))
            noDataLabel.text          = "No Upcoming Birthdays Found \n Tap to refresh".localized
            noDataLabel.textColor     = UIColor(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            
            let noDataLabel2: UILabel     = UILabel(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 340, width: 130, height: 30))
            noDataLabel2.text = ""
            tableView.backgroundView  = noDataLabel2
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 270, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(noDataLabel)
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
        }else{
            tableView.backgroundView = nil
        }
        return arrayFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateStatusScheduleBirthdayTableViewCell", for: indexPath) as! UpdateStatusScheduleBirthdayTableViewCell
        
        let objFriend = arrayFriends[indexPath.row]
        
        
        cell.imgViewProfile.sd_setImage(with: URL(string: objFriend.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
        let words = objFriend.fullName.components(separatedBy: " ")
        let firstName = words[0]
        
        cell.lblUserName.text = firstName
        
        // cell.imgViewProfile.image = #imageLiteral(resourceName: "send")
        // cell.lblUserName.text = "imran"
        let timeInterval = Double(objFriend.birthday)
        let birthdayInDateFormate = Date(timeIntervalSince1970: timeInterval)
        let convertedDate = convertDateFormater(String(describing: birthdayInDateFormate))
        
        cell.lblBirthdayTime.text = "Birthday On ".localized + String(describing: convertedDate)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedFriends.removeAll()
        
        let objFriend = arrayFriends[indexPath.row]
        selectedFriends.append(objFriend)
        print(selectedFriends)
        
        if selectedFriends.count > 0 {
            FeedsHandler.sharedInstance.isFriendsTagged = true
            FeedsHandler.sharedInstance.taggedFriends = self.selectedFriends
        }else{
            FeedsHandler.sharedInstance.isFriendsTagged = false
            FeedsHandler.sharedInstance.taggedFriends = nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scheduleMultiplePostsViewController = storyboard.instantiateViewController(withIdentifier: "ScheduleMultiplePostsViewController") as! ScheduleMultiplePostsViewController
        scheduleMultiplePostsViewController.arrayOfDates.removeAll()
        scheduleMultiplePostsViewController.arrayOfDatesInInteger.removeAll()
        let timeInterval = Double(objFriend.birthday)
        let birthdayInDateFormate = Date(timeIntervalSince1970: timeInterval)
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.timeStyle = DateFormatter.Style.medium
        let date = dateformatter.string(from: birthdayInDateFormate)
        
        scheduleMultiplePostsViewController.arrayOfDates.append(date)
        scheduleMultiplePostsViewController.arrayOfDatesInInteger.append(objFriend.birthday)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(scheduleMultiplePostsViewController.arrayOfDatesInInteger, forKey: "scheduledIntegerDates")
        userDefaults.set(scheduleMultiplePostsViewController.arrayOfDates, forKey: "scheduledDates")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("back button pressed")
        if selectedFriends.count > 0 {
            FeedsHandler.sharedInstance.isFriendsTagged = true
            FeedsHandler.sharedInstance.taggedFriends = self.selectedFriends
        }else{
            FeedsHandler.sharedInstance.isFriendsTagged = false
            FeedsHandler.sharedInstance.taggedFriends = nil
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedsHandler.sharedInstance.taggedFriends = nil
        FeedsHandler.sharedInstance.isFriendsTagged = false
        self.lblbirthdayupcoming.text = "Up Coming Birthdays".localized
        getAllFriends()
        
        if(lang == "ar"){
            btnbackbutton.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
        }else{
            btnbackbutton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func getAllFriends()
    {
        self.showLoader()
        
        let objUser = UserHandler.sharedInstance.userData
        var userID: Int = (objUser?.id)!
        print(userID)
        
        let parameters : [String: Any] = ["criteria" : "", "user_id": userID, "birthday" : 1 ]
        print(parameters)
        
        FriendsHandler.getAllFriends(params: parameters as NSDictionary,success: { (successResponse) in
            if successResponse.statusCode == 200{
                self.arrayFriends = successResponse.data
                print(self.arrayFriends)
                if self.arrayFriends.count > 0 {
                    self.fiendsTableView.reloadData()
                    // self.refreshControl.endRefreshing()
                }else{
                    // show alert friends not found
                    self.fiendsTableView.reloadData()
                    // self.refreshControl.endRefreshing()
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
