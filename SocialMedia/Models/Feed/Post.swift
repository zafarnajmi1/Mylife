//
//  Post.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//


import Foundation
import IGListKit

protocol Post {
    var id: Int {get set}
    var postBy: String {get set}
    var creationDate: Double {get set}
    var likeCount: Int {get set}
    var commentCount: Int {get set}
    var shareCount: Int {get set}
}

extension Post {
    var isSimpleType: Bool { return self is SimplePost }
    var isVideoType: Bool { return self is VideoPost }
    var isPictureType: Bool { return self is PicturePost}
    var isFeelingType: Bool { return self is FeelingPost }
    var isCheckingType: Bool { return self is CheckinPost }
}

protocol SimpleFeed: SimplePost { }
protocol VideoFeed: VideoPost , FeelingPost { }
protocol PictureFeed: PicturePost, FeelingPost { }
protocol FeelingFeed: FeelingPost  { }
protocol CheckinFeed: CheckinPost { }
protocol ScheduledFeed { }

protocol SimplePost { var postText: String? {get set} }
protocol FeelingPost { var feelingId: Int? {get set} }
protocol VideoPost { var videoUrl: String {get set} }
protocol PicturePost { var pictureUrl: String {get set} }
protocol CheckinPost { var location: String {get set} }
protocol ScheduledPost { var scheduledTime: Double {get set} }

//extension Feed: Equatable {
//    static public func ==(rhs: Feed, lhs: Feed) -> Bool {
//        return lhs.time == rhs.time
//    }
//    
//    static public func >(rhs: Feed, lhs: Feed) -> Bool {
//        return lhs.time > rhs.time
//    }
//    
//    static public func <(rhs: Feed, lhs: Feed) -> Bool {
//        return lhs.time < rhs.time
//    }
//}

class Feed: NSObject, Post, SimplePost, Codable {
    var postText: String?
    var id: Int = 0
    var postBy: String = ""
    var creationDate: Double = 0.0
    var likeCount: Int = 0
    var commentCount: Int = 0
    var shareCount: Int = 0
    
    var time: Int64
    
    override init() {
        time = Int64(UInt64(NSDate().timeIntervalSince1970 * 1000.0))
       // time = Date().milliseconds
    }
    
    init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, postText: String?) {
        self.id = id
        self.postBy = postBy
        self.creationDate = creationDate
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.postText = postText
        
        time = Int64(UInt64(NSDate().timeIntervalSince1970 * 1000.0))
    }
    
//    func diffIdentifier() -> NSObjectProtocol {
//        return NSNumber(value: time)
//    }
//    
//    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
//        guard let object = object as? Feed else {
//            return false
//        }
//        
//        if time != object.time {
//            return false
//        }
//        
//        return self == object
//    }
}

class FeedTypeSimple: Feed, SimpleFeed {
//    convenience init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, postText: String?) {
//        self.init(id: id, postBy: postBy, creationDate: creationDate, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount, postText: postText)
//    }
}

class FeedTypePicture: Feed, PictureFeed {
    var pictureUrl: String = ""
    var feelingId: Int? = 0
    
    convenience init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, pictureUrl: String, postText: String?, feelingId: Int?) {
        self.init(id: id, postBy: postBy, creationDate: creationDate, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount, postText: postText)
        self.pictureUrl = pictureUrl
        self.feelingId = feelingId
    }
}

class FeedTypeVideo: Feed, VideoFeed {
    var videoUrl: String = ""
    var feelingId: Int? = 0
    
    convenience init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, videoUrl: String, postText: String?, feelingId: Int?) {
        self.init(id: id, postBy: postBy, creationDate: creationDate, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount, postText: postText)
        self.videoUrl = videoUrl
        self.feelingId = feelingId
    }
}

class FeedTypeCheckin: Feed, CheckinFeed  {
    var location: String = ""

    convenience init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, postText: String?, checkinLocation: String) {
        self.init(id: id, postBy: postBy, creationDate: creationDate, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount, postText: postText)
        self.location = checkinLocation
    }
}

class FeedTypeFeeling: Feed, FeelingFeed {
    var feelingId: Int? = 0
    
    convenience init(id: Int, postBy: String, creationDate: Double, likeCount: Int, commentCount: Int, shareCount: Int, postText: String?, feelingId: Int) {
        self.init(id: id, postBy: postBy, creationDate: creationDate, likeCount: likeCount, commentCount: commentCount, shareCount: shareCount, postText: postText)
        self.feelingId = feelingId
    }
}


