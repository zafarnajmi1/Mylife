////
////  TimeLineUtilities.swift
////  SocialMedia
////
////  Created by iOSDev on 11/16/17.
////  Copyright © 2017 My Technology. All rights reserved.
////
//
//import Foundation
//import UIKit
//import DeviceKit
//import AVFoundation
//import AVKit
//class CommonMethodsTimeLine {
//    static func getAppColor () -> UIColor{
//        return UIColor.init(hex: AppColor.primaryBlue)
//    }
//    static func textFieldColor () -> UIColor{
//        return UIColor(red:221/255,green:221/255,blue:221/255, alpha: 1)
//    }
//    static func getFontOfSize (size: Int) -> UIFont{
//        return UIFont (name: "Lato-Regular", size: CGFloat(size))!
//    }
//    static func showBasicAlert (message: String) -> UIAlertController{
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        // self.present(alert, animated: true, completion: nil)
//        return alert
//    }
//  
//    // MARK: - TimeLine Cells
//    static func createFeedImageCellTimeline (tableView: UITableView, objFeed: TimelineData) -> FeedImageCell{
//        let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
//        feedCell.selectionStyle = .none
//        feedCell.viewContainer.clipsToBounds = true
//        feedCell.viewContainer.cornerRadius = 5
//        
//        // Set feed image
//        var imgUrl = ""
//        if objFeed.postType == "image"{
//            imgUrl = objFeed.postAttachment.path
//        }else{
//            imgUrl = objFeed.postAttachment.thumbnail
//        }
//        
//        if let url = URL(string: imgUrl) {
//            feedCell.imgFeed.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//            feedCell.imgFeed.sd_setShowActivityIndicatorView(true)
//            feedCell.imgFeed.sd_setIndicatorStyle(.gray)
//            feedCell.imgFeed.contentMode = .scaleAspectFill
//            feedCell.imgFeed.clipsToBounds = true
//        }
//        //set user image
//        let imgUrl2 = objFeed.user.image
//        if let url = URL(string: imgUrl2!) {
//            feedCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//            feedCell.imgUser.sd_setShowActivityIndicatorView(true)
//            feedCell.imgUser.sd_setIndicatorStyle(.gray)
//            feedCell.imgUser.contentMode = .scaleAspectFill
//            feedCell.imgUser.clipsToBounds = true
//        }
//        
//        var checkinPlace = ""
//        var feelingText = ""
//        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
//            checkinPlace = " is at " + objFeed.checkinPlace
//        }
//        if objFeed.feeling.translation != nil {
//            feelingText = " feeling " + objFeed.feeling.translation.title
//        }
//        
//        //        if objFeed.tagFriends.count > 0{
//        //            var frndString = ""
//        //            for i in objFeed.tagFriends{
//        //                frndString = frndString + " \(i.fullName)" + ","
//        //            }
//        //            if frndString != ""{
//        //                feeli
//        //            }
//        //        }
//        
//        //        if objFeed.tagFriends.count > 0{
//        //            var friendsString = ""
//        //            for item in objFeed.tagFriends{
//        //                friendsString = friendsString + " \(String(describing: item.fullName!))"
//        //            }
//        //
//        //            if (friendsString) != ""{
//        //                feelingText = feelingText + " with " + friendsString
//        //            }
//        //        }
//        
//        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
//        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
//        
//        let attrs1 = [NSFontAttributeName : CommonMethods.getFontOfSize(size: 14), NSForegroundColorAttributeName : UIColor.black]
//        let attrs2 = [NSFontAttributeName : CommonMethods.getFontOfSize(size: 10), NSForegroundColorAttributeName : UIColor.lightGray]
//        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
//        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
//        
//        attributedString1.append(attributedString2)
//        feedCell.lblUserName.attributedText = attributedString1
//        
//        feedCell.lblDescription.text = objFeed.descriptionField
//        feedCell.lblLike.text = "\(objFeed.totalLikes!) Like"
//        feedCell.lblComment.text = "\(objFeed.totalComments!) Comment"
//        feedCell.lblShare.text = "\(objFeed.totalShares!) Share"
//        
//        return feedCell
//    }
//    static func createFeedTextCellTimeline (tableView: UITableView, objFeed: TimelineData) -> FeedTextCell{
//        let textCell = tableView.dequeueReusableCell(withIdentifier: "FeedTextCell") as! FeedTextCell
//        textCell.selectionStyle = .none
//        textCell.viewContainer.clipsToBounds = true
//        textCell.viewContainer.cornerRadius = 5
//        
//        if let url = URL(string: objFeed.user.image) {
//            textCell.imgUser.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//            textCell.imgUser.sd_setShowActivityIndicatorView(true)
//            textCell.imgUser.sd_setIndicatorStyle(.gray)
//            textCell.imgUser.contentMode = .scaleAspectFill
//            textCell.imgUser.clipsToBounds = true
//        }
//        var checkinPlace = ""
//        var feelingText = ""
//        if objFeed.checkinPlace != nil && objFeed.checkinPlace != "" {
//            checkinPlace = " is at " + objFeed.checkinPlace
//        }
//        if objFeed.feeling.translation != nil {
//            feelingText = " feeling " + objFeed.feeling.translation.title
//        }
//        
//                if objFeed.tagFriends!.count > 0{
//                    var friendsString = ""
//                    for item in objFeed.tagFriends!{
//                        friendsString = friendsString + " \(String(describing: item.fullName!))"
//                        //friendsString.append(" \(val)")
//                    }
//                    print(friendsString)
//                    if friendsString != ""{
//                        feelingText = feelingText + " with " + friendsString
//                    }
//                }
//    
//        let timeStream = NSDate(timeIntervalSince1970: TimeInterval(objFeed.updatedAt.toDouble))
//        let date = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
//        
//        
//        let attrs1 = [NSFontAttributeName : CommonMethods.getFontOfSize(size: 14), NSForegroundColorAttributeName : UIColor.black]
//        let attrs2 = [NSFontAttributeName : CommonMethods.getFontOfSize(size: 10), NSForegroundColorAttributeName : UIColor.lightGray]
//        let attributedString1 = NSMutableAttributedString(string:objFeed.user.fullName, attributes:attrs1)
//        let attributedString2 = NSMutableAttributedString(string:checkinPlace + feelingText + "  \(date)", attributes:attrs2)
//        
//        attributedString1.append(attributedString2)
//        textCell.lblUserName.attributedText = attributedString1
//        
//        textCell.lblStatus.text = objFeed.descriptionField
//        
//        textCell.lblLikes.text = "\(objFeed.totalLikes!) Like"
//        textCell.lblComments.text = "\(objFeed.totalComments!) Comment"
//        textCell.lblShares.text = "\(objFeed.totalShares!) Share"
//        
//        return textCell
//    }
//    
//    static func convertDate(dateString: Double) -> String{
//        //let dateUnix = NSDate(timeIntervalSince1970: TimeInterval(dateString))
//        //print(dateUnix)
//        let date = Date(timeIntervalSince1970: TimeInterval(dateString))
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
//        let strDate = dateFormatter.string(from: date)
//        //print(strDate)
//        return strDate
//        
//    }
//
//    static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
//        let calendar = NSCalendar.current
//        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
//        let now = NSDate()
//        let earliest = now.earlierDate(date as Date)
//        let latest = (earliest == now as Date) ? date : now
//        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
//        
//        if (components.year! >= 2) {
//            return "\(components.year!) years ago"
//        } else if (components.year! >= 1){
//            if (numericDates){
//                return "1 year ago"
//            } else {
//                return "Last year"
//            }
//        } else if (components.month! >= 2) {
//            return "\(components.month!) months ago"
//        } else if (components.month! >= 1){
//            if (numericDates){
//                return "1 month ago"
//            } else {
//                return "Last month"
//            }
//        } else if (components.weekOfYear! >= 2) {
//            return "\(components.weekOfYear!) weeks ago"
//        } else if (components.weekOfYear! >= 1){
//            if (numericDates){
//                return "1 week ago"
//            } else {
//                return "Last week"
//            }
//        } else if (components.day! >= 2) {
//            return "\(components.day!) days ago"
//        } else if (components.day! >= 1){
//            if (numericDates){
//                return "1 day ago"
//            } else {
//                return "Yesterday"
//            }
//        } else if (components.hour! >= 2) {
//            return "\(components.hour!) hours ago"
//        } else if (components.hour! >= 1){
//            if (numericDates){
//                return "1 hour ago"
//            } else {
//                return "An hour ago"
//            }
//        } else if (components.minute! >= 2) {
//            return "\(components.minute!) minutes ago"
//        } else if (components.minute! >= 1){
//            if (numericDates){
//                return "1 minute ago"
//            } else {
//                return "A minute ago"
//            }
//        } else if (components.second! >= 3) {
//            return "\(components.second!) seconds ago"
//        } else {
//            return "Just now"
//        }
//        
//    }
//}
//
//
