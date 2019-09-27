////
////  newsFeedCell.swift
////  SocialMedia
////
////  Created by My Technology on 16/08/2018.
////  Copyright © 2018 My Technology. All rights reserved.
////
//
//import Foundation
//import UIKit
//protocol StoriesCellDelegate: class {
//    func actionCreateStory()
//    func actionViewStory(objStory: StoriesData)
//}
//class FeedStoriesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    weak var delegate: StoriesCellDelegate?
//    
//    @IBOutlet weak var watchAllView: UIView!
//    @IBOutlet var lblShareStories: UILabel!
//    @IBOutlet var viewCollection: UICollectionView!
//    var userStoryFlag = false
//    var dataArray = [StoriesData] ()
//    var newdataArray = [StoriesData] ()
//    var testdataArray = [StoriesData] ()
//    var checkFlag = false
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        //        for _story2 in dataArray{
//        //            if _story2.userId != UserHandler.sharedInstance.userData?.id{
//        //
//        //                watchAllView.isHidden=false
//        //                break
//        //            }else{
//        //                watchAllView.isHidden=true
//        //            }
//        //        }
//        
//        
//        
//        
//        self.setupViews()
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
//    // MARK: - CUstom
//    func setupViews(){
//        viewCollection.delegate = self
//        viewCollection.dataSource = self
//        viewCollection.showsHorizontalScrollIndicator = false
//        viewCollection.showsVerticalScrollIndicator = false
//        viewCollection.backgroundColor = UIColor.clear
//        
//        self.lblShareStories.text = "Stories"
//        //  self.lblShareStories.font = CommonMethods.getFontOfSize(size: 16)
//    }
//    func reloadData(){
//        
//        //        testdataArray = dataArray
//        //
//        //       for (key,_story) in testdataArray.enumerated(){
//        //                if UserHandler.sharedInstance.userData?.id == _story.userId{
//        //                    testdataArray.remove(at: key)
//        //                    newdataArray = testdataArray
//        //                }else{
//        //                    newdataArray = testdataArray
//        //            }
//        //        }
//        
//        
//        print(newdataArray.count)
//        print(testdataArray.count)
//        print(dataArray.count)
//        
//        viewCollection.reloadData()
//    }
//    
//    // MARK: - UICollection View Delegates
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArray.count+1
//        //        if(newdataArray.count==0){
//        //             return newdataArray.count+1
//        //            if(dataArray.count == 0){
//        //                return dataArray.count+1
//        //            }
//        //            else{
//        //                return dataArray.count+1
//        //            }
//        // }
//        
//        
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if indexPath.row == 0 {
//            
//            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStoriesCell", for: indexPath) as! FeedStoriesCell
//            collectionCell.backgroundColor = UIColor.clear
//            
//            
//            for _story in dataArray{
//                if UserHandler.sharedInstance.userData?.id == _story.userId{
//                    
//                    collectionCell.oltAddStory.addTarget(self, action: #selector(self.onAddStoryButtonClicked), for: .touchUpInside)
//                    
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(_:)))
//                    collectionCell.imguser.tag = indexPath.row
//                    collectionCell.imguser.isUserInteractionEnabled = true
//                    collectionCell.imguser.addGestureRecognizer(tap)
//                    
//                    userStoryFlag=true
//                }
//            }
//            
//            
//            if userStoryFlag==false{
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.storyButtonhandle(_:)))
//                collectionCell.imguser.tag = indexPath.row
//                collectionCell.imguser.isUserInteractionEnabled = true
//                collectionCell.imguser.addGestureRecognizer(tap)
//                
//                collectionCell.oltAddStory.addTarget(self, action: #selector(self.onAddStoryButtonClicked), for: .touchUpInside)
//            }
//            
//            
//            collectionCell.oltAddStory.isHidden = false
//            let objUser = UserHandler.sharedInstance.userData
//            
//            let fullNameArr = objUser?.fullName.components(separatedBy: " ")
//            let name = fullNameArr![0]
//            
//            //            collectionCell.lblUserName.text = name
//            collectionCell.lblUserName.text = "Add"
//            
//            if let coverUrl = objUser?.image {
//                collectionCell.imguser.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: "user"))
//                collectionCell.imguser.sd_setShowActivityIndicatorView(true)
//                collectionCell.imguser.sd_setIndicatorStyle(.gray)
//                collectionCell.imguser.contentMode = .scaleAspectFill
//                collectionCell.imguser.clipsToBounds = true
//            }
//            
//            return collectionCell
//        }
//            
//            //        if indexPath.row == 1 {
//            //
//            //
//            //
//            //            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStoriesCell", for: indexPath) as! FeedStoriesCell
//            //            collectionCell.backgroundColor = UIColor.clear
//            //
//            //            collectionCell.oltAddStory.isHidden = true
//            //            for _story in dataArray{
//            //                if UserHandler.sharedInstance.userData?.id == _story.userId{
//            //
//            //                    collectionCell.oltAddStory.addTarget(self, action: #selector(self.onAddStoryButtonClicked), for: .touchUpInside)
//            //
//            //                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
//            //                    collectionCell.imguser.tag = indexPath.row
//            //                    collectionCell.imguser.isUserInteractionEnabled = true
//            //                    collectionCell.imguser.addGestureRecognizer(tap)
//            //                     collectionCell.lblUserName.text = "You Story"
//            //                    userStoryFlag=true
//            //                }
//            //            }
//            //
//            //
//            //            if userStoryFlag==false{
//            //                let tap = UITapGestureRecognizer(target: self, action: #selector(self.storyButtonhandle(_:)))
//            //                collectionCell.imguser.tag = indexPath.row
//            //                collectionCell.imguser.isUserInteractionEnabled = true
//            //                collectionCell.imguser.addGestureRecognizer(tap)
//            //
//            //                collectionCell.oltAddStory.addTarget(self, action: #selector(self.onAddStoryButtonClicked), for: .touchUpInside)
//            //            }
//            //
//            //
//            //      //      collectionCell.oltAddStory.isHidden = false
//            //            let objUser = UserHandler.sharedInstance.userData
//            //
//            //            let fullNameArr = objUser?.fullName.components(separatedBy: " ")
//            //            let name = fullNameArr![0]
//            //
//            //            //            collectionCell.lblUserName.text = name
//            //          //  collectionCell.lblUserName.text = "You Story"
//            //
//            //            print(self.dataArray.count)
//            //           //   let objStory = self.dataArray[0]
//            //           // let coverURL = objStory.snaps[objStory.snaps.count-1].thumbnail
//            //
//            //           if let coverUrl = objUser?.image {
//            //            collectionCell.imguser.sd_setImage(with: URL(string: coverUrl), placeholderImage: UIImage(named: "user"))
//            //                collectionCell.imguser.sd_setShowActivityIndicatorView(true)
//            //                collectionCell.imguser.sd_setIndicatorStyle(.gray)
//            //                collectionCell.imguser.contentMode = .scaleAspectFill
//            //                collectionCell.imguser.clipsToBounds = true
//            //           }
//            //
//            //            return collectionCell
//            //        }
//        else{
//            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedStoriesCell", for: indexPath) as! FeedStoriesCell
//            
//            
//            
//            
//            collectionCell.backgroundColor = UIColor.clear
//            collectionCell.oltAddStory.isHidden = true
//            let objStory = self.dataArray[indexPath.row - 1 ]
//            
//            print(self.newdataArray.count)
//            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//            collectionCell.isUserInteractionEnabled = true
//            collectionCell.oltAddStory.isUserInteractionEnabled = true
//            collectionCell.oltAddStory.tag = indexPath.row
//            collectionCell.oltAddStory.addGestureRecognizer(tap)
//            collectionCell.imguser.tag = indexPath.row
//            collectionCell.imguser.isUserInteractionEnabled = true
//            collectionCell.imguser.addGestureRecognizer(tap)
//            
//            let fullNameArr = objStory.user.fullName.components(separatedBy: " ")
//            //    let name = fullNameArr[0]
//            
//            print(UserHandler.sharedInstance.userData!.id!)
//            print(objStory.userId!)
//            
//            if UserHandler.sharedInstance.userData!.id! == objStory.userId!{
//                collectionCell.lblUserName.text = "Your Story"
//            }
//            else{
//                
//                collectionCell.lblUserName.text = objStory.user.fullName
//            }
//            
//            
//            
//            // if let coverUrl = objStory.user.image{
//            let coverURL = objStory.snaps[objStory.snaps.count-1].thumbnail
//            
//            collectionCell.imguser.sd_setImage(with: URL(string: coverURL!), placeholderImage: UIImage(named: "user"))
//            collectionCell.imguser.sd_setShowActivityIndicatorView(true)
//            collectionCell.imguser.sd_setIndicatorStyle(.gray)
//            collectionCell.imguser.contentMode = .scaleAspectFill
//            collectionCell.imguser.clipsToBounds = true
//            //  }
//            
//            return collectionCell
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            self.delegate?.actionCreateStory()
//        } else {
//            let objStory = self.dataArray[indexPath.row - 1 ]
//            self.delegate?.actionViewStory(objStory: objStory)
//        }
//    }
//    
//    func onAddStoryButtonClicked() {
//        self.delegate?.actionCreateStory()
//    }
//    
//    func handleTap3(_ sender: UITapGestureRecognizer) {
//        self.delegate?.actionCreateStory()
//        
//    }
//    
//    func storyButtonhandle(_ sender: UITapGestureRecognizer) {
//        self.delegate?.actionCreateStory()
//    }
//    
//    func handleTap(_ sender: UITapGestureRecognizer) {
//        let index = sender.view?.tag
//        if let _index = index {
//            let objStory = self.dataArray[_index - 1 ]
//            self.delegate?.actionViewStory(objStory: objStory)
//        }
//        //        self.delegate?.actionCreateStory()
//    }
//    func handleTap2(_ sender: UITapGestureRecognizer) {
//        let index = sender.view?.tag
//        if let _index = index {
//            
//            for _data in dataArray{
//                if UserHandler.sharedInstance.userData?.id == _data.userId{
//                    self.delegate?.actionViewStory(objStory: _data)
//                    break
//                }
//            }
//            
//        }
//        //        self.delegate?.actionCreateStory()
//    }
//    
//}
//
//class FeedStoriesCell : UICollectionViewCell{
//    
//    @IBOutlet var imguser: UIImageView!
//    @IBOutlet var lblUserName: UILabel!
//    @IBOutlet var oltAddStory: UIButton!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        imguser.layer.cornerRadius = imguser.frame.size.height/2
//        //imguser.clipsToBounds = true
//        lblUserName.font = CommonMethods.getFontOfSize(size: 14)
//    }
//}
//class FeedStatusCell: UITableViewCell{
//    
//    @IBOutlet var imguserProfile: UIImageView!
//    
//    
//    @IBOutlet var lblStatus: UILabel!
//    @IBOutlet var oltUpdateStatus: UIButton!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        /*
//         imguserProfile.layer.cornerRadius = imguserProfile.frame.size.height/2
//         imguserProfile.clipsToBounds = true
//         */
//        lblStatus.font = UIFont (name: "Lato-Bold", size: 16)
//        self.oltUpdateStatus.setTitle("", for: .normal)
//        
//        let objUser = UserHandler.sharedInstance.userData
//        let imgUrl = objUser?.image
//        
//        if let url = URL(string: imgUrl!) {
//            imguserProfile.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "user"))
//            
//            imguserProfile.sd_setShowActivityIndicatorView(true)
//            imguserProfile.sd_setIndicatorStyle(.gray)
//            
//            
//            
//            //            imguserProfile.contentMode = .center
//            //            imguserProfile.clipsToBounds = true
//        }
//        
//    }
//    @IBAction func actionUpdateStatus(_ sender: Any) {
//        // Go to status View
//    }
//    
//}
