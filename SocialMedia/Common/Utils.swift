////
////  Utils.swift
////  SocialMedia
////
////  Created by Macbook on 04/08/2017.
////  Copyright © 2017 My Technology. All rights reserved.
////
//
import Foundation
import UIKit
import DeviceKit
import AVFoundation
import AVKit

class CommonMethods {
    
    
    let mytest = ""
    static func getAppColor () -> UIColor{
        return UIColor.init(hex: AppColor.primaryBlue)
    }
    static func textFieldColor () -> UIColor{
        return UIColor(red:221/255,green:221/255,blue:221/255, alpha: 1)
    }
    static func getFontOfSize (size: Int) -> UIFont{
        return UIFont (name: "Lato-Regular", size: CGFloat(size))!
    }
    static func showBasicAlert (message: String) -> UIAlertController{
        let alert = UIAlertController(title: "Alert".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: nil))
        // self.present(alert, animated: true, completion: nil)
        return alert
    }
    // MARK: - Create Cells NewsFeed
    
    static func createMultiFeedImageCell (tableView: UITableView, objFeed: NewsFeedData) -> FeedMultipleImagesCell{
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedMultipleImagesCell
        feedCell.selectionStyle = .none
        feedCell.viewContainer.clipsToBounds = true
        feedCell.viewContainer.layer.cornerRadius = 5
        
        // Set feed image
        var imgUrl = ""
        if objFeed.postType == "image"{
//            if let _ = objFeed.postAttachment, let _path = objFeed.postAttachment.path {
//                imgUrl = _path
//                imgUrl = objFeed.postAttachment.path
//            }
        }else{
//            imgUrl = objFeed.postAttachment.thumbnail   //need to uncomment this line
        }
        
        if let url = URL(string: imgUrl) {
            
            feedCell.imgFeedOne.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell.imgFeedOne.sd_setShowActivityIndicatorView(true)
            feedCell.imgFeedOne.sd_setIndicatorStyle(.gray)
            feedCell.imgFeedOne.contentMode = .scaleAspectFill
            feedCell.imgFeedOne.clipsToBounds = true
            
        }
        //set user image
        let imgUrl2 = objFeed.user.image
        if let url = URL(string: imgUrl2!) {
            feedCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell.imgUser.sd_setShowActivityIndicatorView(true)
            feedCell.imgUser.sd_setIndicatorStyle(.gray)
            feedCell.imgUser.contentMode = .scaleAspectFill
            feedCell.imgUser.clipsToBounds = true
            
        }
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != ""{
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        if objFeed.feeling.translation != nil {
            feelingText = " feeling ".localized + objFeed.feeling.translation.title
        }
        
        if objFeed.tagFriends.count > 0{
            var friendsString = ""
            for item in objFeed.tagFriends{
                friendsString = friendsString + " \(item.fullName!)" + ","
            }
//            if friendsString != ""{
//                feelingText = feelingText + " with " + friendsString
//            }
        }
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
        feedCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        feedCell.lblUserName.attributedText = attributedString1
        }else
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
            let both  = "\u{200E}\(attributedString2 ) \(attributedString1)"
            feedCell.lblfeelingLocation.isHidden = false
            feedCell.lblfeelingLocation.text = attributedString2.string
            attributedString2.append(attributedString1)
            feedCell.lblUserName.text = attributedString1.string //both
            
            
        }
        
        //feedCell.lblDescription.text = objFeed.descriptionField
        
        
        if objFeed.descriptionField != ""{
            feedCell.lblDescription.text = objFeed.descriptionField
        }else{
            feedCell.lblDescription.layer.height = 0.0
            
        }
        
        //        feedCell.lblLike.text = "\(objFeed.totalLikes!) Like"
        //        feedCell.lblComment.text = "\(objFeed.totalComments!) Comment"
        //        feedCell.lblShare.text = "\(objFeed.totalShares!) Share"
        
        //Imran Code Starts
        if objFeed.totalLikes! != 0 {
            feedCell.lblLike.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            feedCell.lblLike.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0 {
            
            let a = "Comment".localized
            feedCell.lblComment.text = "\(objFeed.totalComments!) " + a
        }else{
            feedCell.lblComment.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            feedCell.lblShare.text = "\(objFeed.totalShares!)" + "Share".localized
        }else{
            feedCell.lblShare.text = "Share".localized
        }
        //Imran Code Ends
        
        return feedCell
    }
    
    static func showImageInFeedCell (ImageView _imageView : UIImageView, URL _imageUrl : String?) {
        if let _string = _imageUrl {
            if let url = URL(string: _string) {
                _imageView.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
                print("videee url is/...",url)
                _imageView.sd_setShowActivityIndicatorView(true)
                _imageView.sd_setIndicatorStyle(.gray)
                _imageView.contentMode = .scaleAspectFill
                _imageView.clipsToBounds = true
            }
        }
    }
    
    static func createFeedImageCell (tableView: UITableView, objFeed: NewsFeedData) -> FeedImageCell{
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        feedCell.selectionStyle = .none
        feedCell.viewContainer.clipsToBounds = true
        feedCell.viewContainer.layer.cornerRadius = 5
        
        // Set feed image
        var imgUrl = ""
        if objFeed.postType == "image"{
            if let _data = objFeed.postAttachmentData {
                switch (_data.count) {
                case 0:
                    feedCell.viewMultipleFeedImages.isHidden = true
                    break;
                case 1:
                    feedCell.viewMultipleFeedImages.isHidden = true
                    showImageInFeedCell(ImageView: feedCell.imgFeed, URL: _data[0].path)
                    break;
                case 2:
                    feedCell.viewMultipleFeedImages.isHidden = false
                    feedCell.imgFeed.isHidden = true
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                    break;
                case 3:
                    feedCell.viewMultipleFeedImages.isHidden = false
                    feedCell.imgFeed.isHidden = true
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: _data[2].path)
                    break;
                default:
                    feedCell.viewMultipleFeedImages.isHidden = false
                    feedCell.imgFeed.isHidden = true
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                    showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: _data[2].path)
                    break
                }
                
            }
//            if let _ = objFeed.postAttachment, let _path = objFeed.postAttachment.path {
//                imgUrl = _path
//            }
        }else if objFeed.postType == "video"{
            
            let thubnail = objFeed.postAttachment?.thumbnail
               if thubnail != nil {
            imgUrl = objFeed.postAttachment.thumbnail   //need to uncomment this line
          //  showImageInFeedCell(ImageView: feedCell.imgFeed, URL: imgUrl)
            
            switch (1) {
            case 0:
                feedCell.viewMultipleFeedImages.isHidden = true
                break;
            case 1:
                feedCell.viewMultipleFeedImages.isHidden = true
                showImageInFeedCell(ImageView: feedCell.imgFeed, URL: imgUrl)
                break;
            case 2:
                feedCell.viewMultipleFeedImages.isHidden = false
                feedCell.imgFeed.isHidden = true
                showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: "")
                showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: "")
                break;
            case 3:
                feedCell.viewMultipleFeedImages.isHidden = false
                feedCell.imgFeed.isHidden = true
                showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: "")
                showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: "")
                showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: "")
                break;
            default:
                feedCell.viewMultipleFeedImages.isHidden = false
                feedCell.imgFeed.isHidden = true
                showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: "")
                showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: "")
                showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: "")
                break
            }
            }
            
        }
        else{
            if let _data = objFeed.postAttachmentData {
                switch (_data.count) {
                case 0:
                    feedCell.viewMultipleFeedImages.isHidden = true
                    break;
                case 1:
                    feedCell.viewMultipleFeedImages.isHidden = true
                    showImageInFeedCell(ImageView: feedCell.imgFeed, URL: _data[0].thumbnail!)
                    break;
                default:
                    break
                }
            }
            
        }
        
//        if let url = URL(string: imgUrl) {
//            feedCell.imgFeed.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//            feedCell.imgFeed.sd_setShowActivityIndicatorView(true)
//            feedCell.imgFeed.sd_setIndicatorStyle(.gray)
//            feedCell.imgFeed.contentMode = .scaleAspectFill
//            feedCell.imgFeed.clipsToBounds = true
//        }
        
        //set user image
        let imgUrl2 = objFeed.user.image
        if let url = URL(string: imgUrl2!) {
            feedCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell.imgUser.sd_setShowActivityIndicatorView(true)
            feedCell.imgUser.sd_setIndicatorStyle(.gray)
            feedCell.imgUser.contentMode = .scaleAspectFill
            feedCell.imgUser.clipsToBounds = true
        }
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != ""{
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        if objFeed.feeling.translation != nil {
            feelingText = "is feeling ".localized + objFeed.feeling.translation.title
            feedCell.labelFeeling.text = feelingText
            feedCell.labelFeeling.isHidden=false
        }else{
            feedCell.labelFeeling.isHidden=true
        }
        
       
        
        if let feelingImage = objFeed.feeling.emoji{
            feedCell.imgFeeling.sd_setImage(with: URL(string: feelingImage), placeholderImage: UIImage(named: ""))
            feedCell.imgFeeling.sd_setShowActivityIndicatorView(true)
            feedCell.imgFeeling.sd_setIndicatorStyle(.gray)
            feedCell.imgFeeling.contentMode = .scaleAspectFill
            feedCell.imgFeeling.clipsToBounds = true
            feedCell.imgFeeling.isHidden=false
        }else{
            feedCell.imgFeeling.isHidden=true
        }
        
        
        
        var friendsString = ""
        if objFeed.tagFriends.count > 0{
            friendsString = "  with "
            for item in objFeed.tagFriends{
                friendsString = friendsString + " \(item.fullName!)" + ","
            }
        }
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " \(date)" + friendsString + "  \(checkinPlace)", attributes:attrs2)
        feedCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        feedCell.lblUserName.attributedText = attributedString1
        }else
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string: " \(date)" + friendsString + "  \(checkinPlace)", attributes:attrs2)
            feedCell.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            feedCell.lblfeelingLocation.text = attributedString2.string
            feedCell.lblUserName.text = attributedString1.string //both
        }
        print(feedCell.lblUserName.text!)
       // feedCell.lblDescription.text = objFeed.descriptionField
        
        if objFeed.descriptionField != ""{
            feedCell.lblDescription.text = objFeed.descriptionField
        }else{
            feedCell.lblDescription.layer.height = 0.0
            
        }
        
//        feedCell.lblLike.text = "\(objFeed.totalLikes!) Like"
//        feedCell.lblComment.text = "\(objFeed.totalComments!) Comment"
//        feedCell.lblShare.text = "\(objFeed.totalShares!) Share"

        //Imran Code Starts
        if objFeed.totalLikes! != 0 {
            feedCell.lblLike.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            feedCell.lblLike.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0 {
            let a = "Comment".localized
            feedCell.lblComment.text = "\(objFeed.totalComments!) " + a
        }else{
            feedCell.lblComment.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            feedCell.lblShare.text = "\(objFeed.totalShares!) " + "Share".localized
        }else{
            feedCell.lblShare.text = "Share".localized
        }
        //Imran Code Ends
        
        return feedCell
    }
    static func createFeedTextCell (tableView: UITableView, objFeed: NewsFeedData) -> FeedTextCell{
        let textCell = tableView.dequeueReusableCell(withIdentifier: "FeedTextCell") as! FeedTextCell
        textCell.selectionStyle = .none
        textCell.viewContainer.clipsToBounds = true
        textCell.viewContainer.layer.cornerRadius = 5

        if let url = URL(string: objFeed.user.image) {
            textCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            textCell.imgUser.sd_setShowActivityIndicatorView(true)
            textCell.imgUser.sd_setIndicatorStyle(.gray)
            textCell.imgUser.contentMode = .scaleAspectFill
            textCell.imgUser.clipsToBounds = true
        }
        
      
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        
        var checkinPlace = ""
        
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        
        if let feelingImage = objFeed.feeling.emoji{
            textCell.imgFeeling.sd_setImage(with: URL(string: feelingImage), placeholderImage: UIImage(named: ""))
            textCell.imgFeeling.sd_setShowActivityIndicatorView(true)
            textCell.imgFeeling.sd_setIndicatorStyle(.gray)
            textCell.imgFeeling.contentMode = .scaleAspectFill
            textCell.imgFeeling.clipsToBounds = true
            textCell.imgFeeling.isHidden=false
        }else{
            textCell.imgFeeling.isHidden=true
        }
        
        
        
       // var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != ""{
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        if objFeed.feeling.translation != nil {
            feelingText = "is feeling ".localized + objFeed.feeling.translation.title
            textCell.lblFeeling.text = feelingText
            textCell.lblFeeling.isHidden=false
        }else{
            textCell.lblFeeling.isHidden=true
        }
        var friendsString = " with "
        
        if objFeed.tagFriends.count > 0{
           
            for item in objFeed.tagFriends{
                friendsString = friendsString + " \(item.fullName!)" + ","
            }
//            if friendsString != ""{
//                feelingText = feelingText + " with " + friendsString
//            }
        }else{
            friendsString = ""
        }
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:" \(date)" + friendsString + "  \(checkinPlace)", attributes:attrs2)
        textCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        textCell.lblUserName.attributedText = attributedString1
        }else
        {
           
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:" \(date)" + friendsString + "  \(checkinPlace)", attributes:attrs2)
             textCell.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            textCell.lblfeelingLocation.text = attributedString2.string
            textCell.lblUserName.textAlignment = .right
            
            textCell.lblUserName.text =  attributedString1.string //both
            
        }
        textCell.lblStatus.text = objFeed.descriptionField
        
//        textCell.lblLikes.text = "\(objFeed.totalLikes!) Like"
//        textCell.lblComments.text = "\(objFeed.totalComments!) Comment"
//        textCell.lblShares.text = "\(objFeed.totalShares!) Share"

        //Imran Code Starts
        if objFeed.totalLikes! != 0 {
            textCell.lblLikes.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            textCell.lblLikes.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0 {
            let a = "Comment".localized
            textCell.lblComments.text = "\(objFeed.totalComments!)" + a
        }else{
            textCell.lblComments.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            textCell.lblShares.text = "\(objFeed.totalShares!) " + "Share".localized
        }else{
            textCell.lblShares.text = "Share".localized
        }
        //Imran Code Ends
        
        
        return textCell
    }
    // MARK: - TimeLine Cells
    static func createFeedImageCellTimeline (tableView: UITableView, objFeed: TimelineData) -> FeedImageCell{
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        feedCell.selectionStyle = .none
        feedCell.viewContainer.clipsToBounds = true
        feedCell.viewContainer.layer.cornerRadius = 5
        
        // Set feed image
        var imgUrl = ""
        
        if let _postType = objFeed.postType {
            if _postType == "image"{
                if let _data = objFeed.postAttachmentData {
                    switch (_data.count) {
                    case 0:
                        feedCell.viewMultipleFeedImages.isHidden = true
                        break;
                    case 1:
                        feedCell.viewMultipleFeedImages.isHidden = true
                        showImageInFeedCell(ImageView: feedCell.imgFeed, URL: _data[0].path)
                        break;
                    case 2:
                        feedCell.viewMultipleFeedImages.isHidden = false
                        feedCell.imgFeed.isHidden = true
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                        break;
                    case 3:
                        feedCell.viewMultipleFeedImages.isHidden = false
                        feedCell.imgFeed.isHidden = true
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: _data[2].path)
                        break;
                    default:
                        feedCell.viewMultipleFeedImages.isHidden = false
                        feedCell.imgFeed.isHidden = true
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage1, URL: _data[0].path)
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage2, URL: _data[1].path)
                        showImageInFeedCell(ImageView: feedCell.imgFeedImage3, URL: _data[2].path)
                        break
                    }
                    
                }
                //            imgUrl = objFeed.postAttachment.path
            }else{
                if let _data = objFeed.postAttachmentData {
                    switch (_data.count) {
                    case 0:
                        feedCell.viewMultipleFeedImages.isHidden = true
                        break;
                    case 1:
                        feedCell.viewMultipleFeedImages.isHidden = true
                        showImageInFeedCell(ImageView: feedCell.imgFeed, URL: _data[0].thumbnail)
                        break;
                    default:
                        break
                    }
                }
//                imgUrl = objFeed.postAttachment.thumbnail
            }
        }
        
//        if let url = URL(string: imgUrl) {
//            feedCell.imgFeed.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//            feedCell.imgFeed.sd_setShowActivityIndicatorView(true)
//            feedCell.imgFeed.sd_setIndicatorStyle(.gray)
//            feedCell.imgFeed.contentMode = .scaleAspectFill
//            feedCell.imgFeed.clipsToBounds = true
//        }
        //set user image
        let imgUrl2 = objFeed.user.image
        if let url = URL(string: imgUrl2!) {
            feedCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell.imgUser.sd_setShowActivityIndicatorView(true)
            feedCell.imgUser.sd_setIndicatorStyle(.gray)
            feedCell.imgUser.contentMode = .scaleAspectFill
            feedCell.imgUser.clipsToBounds = true
        }
    
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        if objFeed.feeling.translation != nil {
            feelingText = " feeling ".localized + objFeed.feeling.translation.title
        }
        
//        if objFeed.tagFriends.count > 0{
//            var frndString = ""
//            for i in objFeed.tagFriends{
//                frndString = frndString + " \(i.fullName)" + ","
//            }
//            if frndString != ""{
//                feeli
//            }
//        }
//        var friendsString = " with "
//        if objFeed.tagFriends.count > 0{
//
//            for item in objFeed.tagFriends{
//                friendsString = friendsString + " \(String(describing: item.fullName!))"
//            }
//
//
//        }else{
//            friendsString = ""
//        }

        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
        feedCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        feedCell.lblUserName.attributedText = attributedString1
        }else{
            
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
             feedCell.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            feedCell.lblfeelingLocation.text = attributedString2.string
            feedCell.lblUserName.text = attributedString1.string //both
            
        }
        
        if objFeed.descriptionField != ""{
            feedCell.lblDescription.text = objFeed.descriptionField
        }else{
            feedCell.lblDescription.layer.height = 0.0
        }
        
//        feedCell.lblLike.text = "\(objFeed.totalLikes!) Like"
//        feedCell.lblComment.text = "\(objFeed.totalComments!) Comment"
//        feedCell.lblShare.text = "\(objFeed.totalShares!) Share"
//
        //Imran Code Starts
        if objFeed.totalLikes! != 0{
            feedCell.lblLike.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            feedCell.lblLike.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0{
            let a = "Comment".localized
            feedCell.lblComment.text = "\(objFeed.totalComments!)" + a
        }else{
            feedCell.lblComment.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            feedCell.lblShare.text = "\(objFeed.totalShares!) " + "Share".localized
        }else{
            feedCell.lblShare.text = " Share".localized
        }
        //Imran Code Ends
        
        
        
        return feedCell
    }
    static func createFeedTextCellTimeline (tableView: UITableView, objFeed: TimelineData) -> FeedTextCell{
        let textCell = tableView.dequeueReusableCell(withIdentifier: "FeedTextCell") as! FeedTextCell
        textCell.selectionStyle = .none
        textCell.viewContainer.clipsToBounds = true
        textCell.viewContainer.layer.cornerRadius = 5
        
        if let url = URL(string: objFeed.user.image) {
            textCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            textCell.imgUser.sd_setShowActivityIndicatorView(true)
            textCell.imgUser.sd_setIndicatorStyle(.gray)
            textCell.imgUser.contentMode = .scaleAspectFill
            textCell.imgUser.clipsToBounds = true
        }
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
        if objFeed.feeling.translation != nil {
            feelingText = " feeling ".localized + objFeed.feeling.translation.title
        }
        
//        if objFeed.tagFriends.count > 0{
//            var friendsString = ""
//            for item in objFeed.tagFriends{
//                friendsString.append("\(item.fullName)")
//                //friendsString.append(" \(val)")
//            }
//            print(friendsString)
//            if friendsString != ""{
//                feelingText = feelingText + " with " + friendsString
//            }
//        }

        
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
        textCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        textCell.lblUserName.attributedText = attributedString1
        }else
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
            textCell.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            textCell.lblfeelingLocation.text = attributedString2.string
            textCell.lblUserName.text = attributedString1.string
        }
        textCell.lblStatus.text = objFeed.descriptionField
        
//        textCell.lblLikes.text = "\(objFeed.totalLikes!) Like"
//        textCell.lblComments.text = "\(objFeed.totalComments!) Comment"
//        textCell.lblShares.text = "\(objFeed.totalShares!) Share"
//
        //Imran Code Starts
        if objFeed.totalLikes! != 0{
            textCell.lblLikes.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            textCell.lblLikes.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0{
            let a = "Comment".localized
            textCell.lblComments.text = "\(objFeed.totalComments!)" + a
        }else{
            textCell.lblComments.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            textCell.lblShares.text = "\(objFeed.totalShares!) " + "Share".localized
        }else{
            textCell.lblShares.text = "Share".localized
        }
        //Imran Code Ends
        
        
        return textCell
    }

    static func convertDate(dateString: Double) -> String{
        //let dateUnix = NSDate(timeIntervalSince1970: TimeInterval(dateString))
        //print(dateUnix)
        let date = Date(timeIntervalSince1970: TimeInterval(dateString))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        //print(strDate)
        return strDate
        
    }
    
    // MARK: - Show Cells NewsFeed
    static func showFeedImageCell (tableView: UITableView, objFeed: PostDetailsData) -> FeedImageCell{
        let feedCell2 = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        feedCell2.selectionStyle = .none
        feedCell2.viewContainer.clipsToBounds = true
        feedCell2.viewContainer.layer.cornerRadius = 5
        
        // Set feed image
        var imgUrl = ""
        if objFeed.postType == "image"{
            if let _postAttachmentData = objFeed.postAttachmentData {
                if (_postAttachmentData.count > 0) {
                    imgUrl = _postAttachmentData[0].path
                }
            }
        }else{
            if let _postAttachmentData = objFeed.postAttachmentData {
                if (_postAttachmentData.count > 0) {
                    imgUrl = _postAttachmentData[0].thumbnail
                }
            }
//            imgUrl = objFeed.postAttachment.thumbnail
        }
        
        if let url = URL(string: imgUrl) {
            feedCell2.imgFeed.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell2.imgFeed.sd_setShowActivityIndicatorView(true)
            feedCell2.imgFeed.sd_setIndicatorStyle(.gray)
            feedCell2.imgFeed.contentMode = .scaleAspectFill
            feedCell2.imgFeed.clipsToBounds = true
        }
        //set user image
        let imgUrl2 = objFeed.user.image
        if let url = URL(string: imgUrl2!) {
            feedCell2.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            feedCell2.imgUser.sd_setShowActivityIndicatorView(true)
            feedCell2.imgUser.sd_setIndicatorStyle(.gray)
            feedCell2.imgUser.contentMode = .scaleAspectFill
            feedCell2.imgUser.clipsToBounds = true
        }
        
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != ""{
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
//        if objFeed.feeling.feelingTranslation != nil {
//            feelingText = " feeling " + objFeed.feeling.feelingTranslation.title
//        }
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  " + date, attributes:attrs2)
        feedCell2.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        feedCell2.lblUserName.attributedText = attributedString1
        }else
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  " + date, attributes:attrs2)
            feedCell2.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            feedCell2.lblfeelingLocation.text = attributedString2.string
            feedCell2.lblUserName.text = attributedString1.string
            
        }
        
        if objFeed.descriptionField != ""{
            feedCell2.lblDescription.text = objFeed.descriptionField
        }else{
            feedCell2.lblDescription.layer.height = 0.0
            
        }
        
        //feedCell2.lblDescription.text = objFeed.descriptionField
//        feedCell2.lblLike.text = "\(objFeed.totalLikes!) Like"
//        feedCell2.lblComment.text = "\(objFeed.totalComments!) Comment"
//        feedCell2.lblShare.text = "\(objFeed.totalShares!) Share"
//
        //Imran Code Starts
        if objFeed.totalLikes! != 0{
            feedCell2.lblLike.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            feedCell2.lblLike.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0{
            let a = "Comment".localized
            feedCell2.lblComment.text = "\(objFeed.totalComments!)" + a
        }else{
            feedCell2.lblComment.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            feedCell2.lblShare.text = "\(objFeed.totalShares!)" + "Share".localized
        }else{
            feedCell2.lblShare.text = "Share".localized
        }
        //Imran Code Ends
        
        
        return feedCell2
    }
    
    static func showFeedTextCell (tableView: UITableView, objFeed: PostDetailsData) -> FeedTextCell{
        let textCell = tableView.dequeueReusableCell(withIdentifier: "FeedTextCell") as! FeedTextCell
        textCell.selectionStyle = .none
        textCell.viewContainer.clipsToBounds = true
        textCell.viewContainer.layer.cornerRadius = 5
        
        if let url = URL(string: objFeed.user.image) {
            textCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
            textCell.imgUser.sd_setShowActivityIndicatorView(true)
            textCell.imgUser.sd_setIndicatorStyle(.gray)
            textCell.imgUser.contentMode = .scaleAspectFill
            textCell.imgUser.clipsToBounds = true
        }
        
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
        let timeStream = CommonMethods.timeAgoSinceDate(date: date, numericDates:true)
        var checkinPlace = ""
        var feelingText = ""
        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
            checkinPlace = " is at ".localized + objFeed.checkinPlace
        }
//        if objFeed.feeling.feelingTranslation != nil {
//            feelingText = " feeling " + objFeed.feeling.feelingTranslation.title
//        }
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if(lang == "en")
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  " + timeStream, attributes:attrs2)
        textCell.lblfeelingLocation.isHidden = true
        attributedString1.append(attributedString2)
        textCell.lblUserName.attributedText = attributedString1
        }else
        {
            let attrs1 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : CommonMethods.getFontOfSize(size: 10), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
            let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  " + timeStream, attributes:attrs2)
            textCell.lblfeelingLocation.isHidden = false
            //let both  = "\u{200E}\(attributedString2.string ) \(attributedString1.string)"
            textCell.lblfeelingLocation.text = attributedString2.string
            textCell.lblUserName.text = attributedString1.string //both
        }
        textCell.lblStatus.text = objFeed.descriptionField
        
//        textCell.lblLikes.text = "\(objFeed.totalLikes!) Like"
//        textCell.lblComments.text = "\(objFeed.totalComments!) Comment"
//        textCell.lblShares.text = "\(objFeed.totalShares!) Share"
//
        //Imran Code Starts
        if objFeed.totalLikes! != 0{
            textCell.lblLikes.text = "\(objFeed.totalLikes!)" + " Like".localized
        }else{
            textCell.lblLikes.text = " Like".localized
        }
        
        if objFeed.totalComments! != 0{
            let a = "Comment".localized
            textCell.lblComments.text = "\(objFeed.totalComments!)" + a
        }else{
            textCell.lblComments.text = " Comment".localized
        }
        
        if objFeed.totalShares! != 0 {
            textCell.lblShares.text = "\(objFeed.totalShares!) " + "Share".localized
        }else{
            textCell.lblShares.text = "Share".localized
        }
        //Imran Code Ends
        
        
        return textCell
    }

    
    static func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }

    
   static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            let a = "years ago"
            return "\(components.year!) " + a.localized
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago".localized
            } else {
                return "Last year".localized
            }
        } else if (components.month! >= 2) {
            let a = "months ago"
            return "\(components.month!) " + a.localized
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago".localized
            } else {
                return "Last month".localized
            }
        } else if (components.weekOfYear! >= 2) {
            let a = "weeks ago".localized
            
            return "\(components.weekOfYear!) " + a.localized
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago".localized
            } else {
                return "Last week".localized
            }
        } else if (components.day! >= 2) {
            let a = "days ago"
            return "\(components.day!) " + a.localized
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago".localized
            } else {
                return "Yesterday".localized
            }
        } else if (components.hour! >= 2) {
            let a = "hours ago"
            return "\(components.hour!) " + a.localized
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago".localized
            } else {
                return "An hour ago".localized
            }
        } else if (components.minute! >= 2) {
            let a = "minutes ago"
            return "\(components.minute!) " + a.localized
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago".localized
            } else {
                return "A minute ago".localized
            }
        } else if (components.second! >= 3) {
            let a = "seconds ago"
            return "\(components.second!) " + a.localized
        } else {
            return "Just now".localized
        }
        
    }
    
    static func timeAfterSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "Scheduled \(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "Scheduled 1 year ago"
            } else {
                return "Scheduled Last year"
            }
        } else if (components.month! >= 2) {
            return "Scheduled \(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "Scheduled 1 month ago"
            } else {
                return "Scheduled Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "Scheduled \(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "Scheduled 1 week ago"
            } else {
                return "Scheduled Last week"
            }
        } else if (components.day! >= 2) {
            return "Scheduled \(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "Scheduled 1 day ago"
            } else {
                return "Scheduled Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "Scheduled \(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "Scheduled 1 hour ago"
            } else {
                return "Scheduled An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "Scheduled \(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "Scheduled 1 minute ago"
            } else {
                return "Scheduled A minute ago"
            }
        } else if (components.second! >= 3) {
            return "Scheduled \(components.second!) seconds ago"
        } else {
            return "Scheduled Just now"
        }
        
    }

    
}
extension String {
    var html2AttributedString: NSAttributedString? {
        do {
        //Cannot convert value of type 'NSAttributedString.DocumentAttributeKey' to expected dictionary key type 'NSAttributedString.DocumentReadingOptionKey'
            return try NSAttributedString(data: Data(utf8), options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


//extension String {
//span style="color: #ff0000">January 30, 2011</span>
//    var html2AttributedString: NSAttributedString? {
//        do {
//            let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 16\">%@</span>" as NSString, mytest) as String
//
//            let data = modifiedFont.data(using: String.Encoding.utf8, allowLossyConversion: true)
//            if let d = data {
//                let str = try NSAttributedString(data: d,
//                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//                return str
//            }
//        }  catch {
//            print("error: ", error)
//            return nil
//        }
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
//}
//
//    static func isValidEmailAddress (emailAddress: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: emailAddress)
//    }

//    
//    static func isValidPhone (text: String) -> Bool {
//        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let components = text.components(separatedBy: inverseSet)
//        let filtered = components.joined(separator: "")
//        
//        return text == filtered
//    }
//    
//
//    static func setFontSize (size : Int) -> UIFont {
//        
//        let device = Device()
//        
//        switch device {
//            
//        case .iPad2, .iPad3, .iPad4 , .iPad5 , .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro12Inch2:
//            
//            return UIFont(name: "Lato-Regular", size: CGFloat(size + 2))!
//            
//        case .iPhone4, .iPhone4s , .iPhone5, .iPhone5c, .iPhone5s:
//            
//            return UIFont (name: "Lato-Regular", size: CGFloat(size - 2))!
//            
//        default:
//            break
//            
//        }
//        
//        return UIFont (name: "Lato-Regular", size: CGFloat(size))!
//        
//    }
//    
//    static func headerFontSize (size : Int) -> UIFont {
//        
//        let device = Device()
//        
//        switch device {
//            
//        case .iPad2, .iPad3, .iPad4 , .iPad5 , .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro12Inch2:
//            
//            return UIFont(name: "Lato-Regular", size: CGFloat(size))!
//            
//        case .iPhone4, .iPhone4s , .iPhone5, .iPhone5c, .iPhone5s:
//            
//            return UIFont (name: "Lato-Regular", size: CGFloat(size))!
//            
//        default:
//            break
//            
//        }
//        
//        return UIFont (name: "Lato-Regular", size: CGFloat(size))!
//        
//    }
//    
//}

