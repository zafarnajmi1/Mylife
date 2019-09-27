//
//  SavedStoriesPermanentlyViewController.swift
//  SocialMedia
//
//  Created by Macbook on 20/03/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import AVFoundation
import AVKit

class SavedStoriesPermanentlyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable {
   var savedPermanentStoriesArray: NSMutableArray = []
    var userID = Int()
     @IBOutlet weak var storiesTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var objOtherUser : AboutUserData?
    var userObj: UserLoginData?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Stories".localized
        addBackButton()
        self.setupViews()
        userObj = UserHandler.sharedInstance.userData
        print(userObj?.id)
        serverCallToGetPermanentStories()
        
        

    }
    func setupViews(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        storiesTableView.addSubview(refreshControl)
        
    }
    @objc func refresh(sender:AnyObject) {
         self.savedPermanentStoriesArray.removeAllObjects()
       serverCallToGetPermanentStories()
        refreshControl.endRefreshing()
    }
    

    // MARK: - API Calls
    func serverCallToGetPermanentStories(){
        self.showLoader()
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        var uid = Int()
//        if objOtherUser?.id != nil {
//            uid = (objOtherUser?.id)!
//        }else{
//            uid = (userObj?.id)!
//        }
        var parameters : [String: Any]
        parameters = [
            "user_id" : userObj?.id
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.getPermanentStories
        
        print("get  favourtie story url",url)
        
        Alamofire.request(url, method: .get , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    let savedStoriesArray = responseDic["data"] as! NSArray
                    for i in 0..<savedStoriesArray.count{
                        let story  = PermanentStoriesDataModel()
                        story.id = (savedStoriesArray[i] as! NSDictionary).value(forKey: "id") as? Int
                        story.is_permanent = (savedStoriesArray[i] as! NSDictionary).value(forKey: "is_permanent") as? Int
                        story.updated_at = (savedStoriesArray[i] as! NSDictionary).value(forKey: "updated_at") as? Int
                        story.created_at = (savedStoriesArray[i] as! NSDictionary).value(forKey: "created_at") as? Int
                        story.video_path = (savedStoriesArray[i] as! NSDictionary).value(forKey: "video_path") as?String
                        story.storyUserId = (savedStoriesArray[i] as! NSDictionary).value(forKey: "user_id") as? Int
                        print(story)
                        self.savedPermanentStoriesArray.add(story)
                    }
                    self.storiesTableView.reloadData()
                    print("savedStoriesArray",savedStoriesArray)
                    self.stopAnimating()
                }
                self.stopAnimating()
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.stopAnimating()
                 self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
        
        
    }
    
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.savedPermanentStoriesArray.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No saved stories found".localized + "\n" + "Pull to refresh".localized
            noDataLabel.textColor     = UIColor.darkGray //(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 18)
            noDataLabel.textAlignment = .center
            
            
            tableView.backgroundView  = noDataLabel
            
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: tableView.bounds.size.height/3, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            storiesTableView.backgroundView?.addSubview(backgroundimageview)
            storiesTableView.separatorStyle  = .none
            
        }else{
            storiesTableView.backgroundView = nil
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.savedPermanentStoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveStoriesPermanentlyTableViewCell", for: indexPath) as! SaveStoriesPermanentlyTableViewCell
        cell.btnStoryDelete.setTitle("DELETE".localized, for: .normal)
//        (self.newsResponseArray[indexPath.row] as! PermanentStoriesDataModel).updated_at
        
        let dtee = ((self.savedPermanentStoriesArray[indexPath.row] as! PermanentStoriesDataModel).created_at?.toDouble)!
        let dateScheduledFor = NSDate(timeIntervalSince1970: dtee)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MM-yyyy hh:mm a"//"MMM dd YYYY hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: dateScheduledFor as Date)
        cell.lblStoryOwnerName.text = UserHandler.sharedInstance.userData?.fullName
        cell.lblStoryTime.text = dateString
//        let imageString : String?
//        imageString = UserHandler.sharedInstance.userData?.image
//        cell.imgStory.sd_setImage(with: URL(string: imageString!), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        
        let objUser = UserHandler.sharedInstance.userData
        let currentUserID: Int = (objUser?.id)!
        if currentUserID == userID{
            cell.btnStoryDelete.isHidden = false
        }else{
            cell.btnStoryDelete.isHidden = false
        }
        
        
        cell.btnStoryDelete.tag = indexPath.row
        cell.btnStoryDelete.addTarget(self, action: #selector(deletePremanentSavedStoryButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        let path = ((self.savedPermanentStoriesArray[indexPath.row] as! PermanentStoriesDataModel).video_path)!
        let videoURL = URL(string: path)
        let player = AVPlayer(url: videoURL!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }

        
    }
    
    @objc func deletePremanentSavedStoryButtonAction(_ sender : UIButton){
        print("sender",sender.tag)
        let alertController = UIAlertController(title:"Remove Story".localized,message:"Are you sure you want to remove this story?".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
            print("ok button pressed")
            self.serverCallForDeleteStoryPermanently(index:sender.tag)
        }
        let cancelAction = UIAlertAction(title:"Cancel".localized,style: .default){UIAlertAction in
            print("cancel button pressed")
            }
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    func serverCallForDeleteStoryPermanently(index:Int){
        self.showLoader()
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        //        let objUser = UserHandler.sharedInstance.userData
        //        var userID: Int = (objUser?.id)!
        //        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "story_id" : (self.savedPermanentStoriesArray[index] as! PermanentStoriesDataModel).id!
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.deletePermanentStory
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Deleted".localized)
                    print("success")
                    self.savedPermanentStoriesArray.removeObject(at: index)
                    self.storiesTableView.reloadData()
                    self.stopAnimating()
                    
                }
                self.stopAnimating()
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                self.stopAnimating()
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
    }
    
    
    

}
