//
//  SentRequestViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 7/9/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import AVFoundation
import AVKit

class SentRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable {
    var sentRequestArray: NSMutableArray = []
    var userID = Int()
    @IBOutlet weak var storiesTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var objOtherUser : AboutUserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sent Request".localized
        addBackButton()
        self.setupViews()
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
        
      //  var parameters : [String: Any]
//        parameters = [
//            "user_id" : "\(userID)"
//        ]
//        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.getSentRequest
        
        print("get  favourtie story url",url)
        
        Alamofire.request(url, method: .get , parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    self.sentRequestArray.removeAllObjects()
                    let savedStoriesArray = responseDic["data"] as! NSArray
                    for i in 0..<savedStoriesArray.count
                    {
                        let story  = PermanentStoriesDataModel()
                        story.id = (savedStoriesArray[i] as! NSDictionary).value(forKey: "id") as? Int
                        story.name = (savedStoriesArray[i] as! NSDictionary).value(forKey: "full_name") as? String
                   
                        story.image_path = (savedStoriesArray[i] as! NSDictionary).value(forKey: "image") as? String
                        print(story)
                        self.sentRequestArray.add(story)
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
        if self.sentRequestArray.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No sent request found".localized  + "\n" + "Pull to refresh".localized
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
        return  self.sentRequestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveStoriesPermanentlyTableViewCell", for: indexPath) as! SaveStoriesPermanentlyTableViewCell
        
        //        (self.newsResponseArray[indexPath.row] as! PermanentStoriesDataModel).updated_at
        let imageurl = ((self.sentRequestArray[indexPath.row] as! PermanentStoriesDataModel).image_path!)
          cell.imgStory.sd_setImage(with: URL(string:imageurl), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        cell.imgStory.sd_setShowActivityIndicatorView(true)
        cell.imgStory.sd_setIndicatorStyle(.gray)
        cell.imgStory.clipsToBounds = true
             cell.imgStory.roundWithClearColor()
        
      cell.lblStoryOwnerName.text = ((self.sentRequestArray[indexPath.row] as! PermanentStoriesDataModel).name!)
     //   cell.lblStoryTime.text = dateString
        //        let imageString : String?
        //        imageString = UserHandler.sharedInstance.userData?.image
        //        cell.imgStory.sd_setImage(with: URL(string: imageString!), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        
//        let objUser = UserHandler.sharedInstance.userData
//        let currentUserID: Int = (objUser?.id)!
//        if currentUserID == userID{
//            cell.btnStoryDelete.isHidden = false
//        }else{
//            cell.btnStoryDelete.isHidden = true
//        }
        
        cell.btnStoryDelete.setTitle("CANCEL REQUEST".localized, for: .normal)
        cell.btnStoryDelete.tag = indexPath.row
        cell.btnStoryDelete.addTarget(self, action: #selector(deletePremanentSavedStoryButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
//        tableView.deselectRow(at: indexPath, animated: true)
//        let path = ((self.sentRequestArray[indexPath.row] as! PermanentStoriesDataModel).video_path)!
//        let videoURL = URL(string: path)
//        let player = AVPlayer(url: videoURL!)
//        
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        self.present(playerController, animated: true) {
//            player.play()
//        }
        
        
    }
    
    @objc func deletePremanentSavedStoryButtonAction(_ sender : UIButton){
        print("sender",sender.tag)
        let alertController = UIAlertController(title:"Cancel Request".localized,message:"Do you want to cancel this request".localized, preferredStyle: .alert)
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
            "friend_id" : (self.sentRequestArray[index] as! PermanentStoriesDataModel).id!
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.RemoveFriendRequest
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Canceled".localized)
                    print("success")
                    self.sentRequestArray.removeObject(at: index)
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
