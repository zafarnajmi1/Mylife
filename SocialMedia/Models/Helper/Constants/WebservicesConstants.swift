//
//  WebservicesConstants.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 29/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

//http://mylife.local/en/api/friends/pending-requests
import Foundation
struct ApiCalls {
    static let baseUrlBuild = "http://myliife.com/en/api"
    
    
    static let baseUrlBuildAR = "http://myliife.com/ar/api"
    
    static let baseUrlSocket = "http://myliife.com"
   
  //  static let baseUrlBuild = "http://www.mytechnology.ae/test/my-life/build/en/api"
    static let baseUrlDev = "http://myliife.com/en/api"

    // Total Api's Implemented = 42
    static let AcceptFriendRequest = "/friends/accept-friend-request" // POST
    static let RejectFriendRequest  = "/friends/remove-friend" // POST
    
    
    static let LeaveChatGroupRequest = "/messages/leave-chat-group" //
    static let AcceptChatGroupRequest  = "/messages/accept-chat-group" // 
    
    
    
    static let SendFriendRequest  = "/friends/send-friend-request" //POST
    static let SearchPeople  = "/friends/search-friend" //POST
    static let RemoveFriendRequest  = "/friends/remove-friend" // POST
    static let RemoveNotification  = "/notification/delete" // POST
    static let allRemoveNotification  = "/notification/clear" // GET

    static let MyFriends = "/friends/friends"//"/friends/search-friend" // Post
    static let MyFriendRequest = "/friends/my-friend-requests" // GET
    static let MyEmojis = "/site-settings" // GET
    static let SearchFriendRequest = "/friends/my-friends?criteria=" // GET
    static let UserLogout =  "/user/logout" // GET
    static let UserRegister  = "/user/register" // POST
    static let UserLogin  = "/user/login" // POST
    static let UserConversation =  "/messages/conversations" // GET
    static let DeleteUserConversation  = "/messages/delete-conversation" // POST
    static let GetComments  = "/post/get-comments" // POST
    static let GetSubComments  = "/post/get-sub-comments" // POST

    static let PostComments  = "/post/comment" // POST
    static let PostsubComments  = "/post/comment/create" // POST

    static let DeleteComments  = "/post/comment/delete" // POST
    static let UpdateComments  = "/post/comment/update" // POST

    static let MyFollowers = "/followers/my-followers" //GET
    static let MyFollowings = "/followers/my-followings" //GET
    static let FollowTheUser  = "/followers/follow-user" // POST
    static let UnFollowThaUser  = "/followers/un-follow" // POST
    static let AddEditWorkInfo  = "/user/edit-work" // POST
    static let AddEditEducationInfo  = "/user/edit-education" // POST
    static let DeleteWorkInfo  = "/user/delete-user-work" // POST
    static let DeleteEducationInfo  = "/user/delete-user-education" // POST
    static let UserPhotoes  = "/post/photos" // POST
    static let UserVideos  = "/post/videos" // POST
    static let EditUserInformation = "/user/profile" //POST
    static let OnlineFriends =  "/friends/online-friends" // GET
    static let UnreadNotificationCount =  "/notification/unread-notification-count" // GET
    static let UnreadMessageCount =  "/messages/unread-conversations" // GET

    static let Notifications =  "/notification/notifications" // GET
    
    
    static let readNotifications =  "/notification/mark-all-notification-read" // GET

    
    
    static let MarkNotificationAsRead  = "/notification/mark-notification-read" // POST
    static let getConversationMessages = "/messages/get-conversation-messages"
    static let postConversationMessage = "/messages/send-message"
    static let deleteConversationMessage = "/messages/delete-message"
    static let CreateGroupChat =  "/messages/create-or-update-chat-group" // POST
    static let getStories = "/stories/get-stories"
    static let getNewsFeed = "/post/news-feeds"
    static let shareFeed = "/post/share"
    static let postLike = "/post/like"
    static let userTimeLine = "/post/timeline"
    static let getFeelings = "/get-feelings"
    static let createPost = "/post/create"
    static let forgotPassword = "/user/reset-password" //POST
    static let changePassword = "/user/change-password" //POST
    static let getOtherUserProfile = "/user/get-user-profile"
    static let searchPost = "/post/search-post" //POST
    static let postDetails = "/post/post-detail" //POST
    static let aboutUser = "/user/about-user"
    static let GetFaqs = "/faqs/get-all-faqs"
    static let PsotFaqs = "/faqs/ask-any-query"
    static let RemovePost = "/post/delete-post"
    static let UploadStory = "/stories/upload-snap"
    static let getAllDocuments = "/documents/all"
    static let saveDocument = "/documents/save"
    static let deleteDocument = "/documents/destroy"
    static let getMySchedule = "/post/scheduled"
    static let saveFavouriteStory = "/stories/save-favorite-story"
    static let getPermanentStories = "/stories/get-permanent-stories"
    static let getSentRequest = "/friends/your-friend-requests"
    static let removeRequest = "/stories/delete-permanent-story"

    static let deletePermanentStory = "/stories/delete-permanent-story"
    static let removeStoryFromTimeLine = "/stories/remove-from-timeline"
    
    
   
    //Newfeatures-
    static let getTermsEn =  baseUrlBuild + "/get-terms"
    static let getTermsAr =  baseUrlBuildAR + "/get-terms"
    
    static let blockedUsersEn =  baseUrlBuild + "/blocked/users"
    static let blockedUsersAr =  baseUrlBuildAR + "/blocked/users"
    
    static let blockUserByIdEn =  baseUrlBuild + "/blocked/block-user"
    static let blockUserByIdAr =  baseUrlBuildAR + "/blocked/block-user"
    
    static let unblockUserByIdEn =  baseUrlBuild + "/blocked/unblock-user"
    static let unblockUserByIdAr =  baseUrlBuildAR + "/blocked/unblock-user"
    
    static let reportPostByIdEn =  baseUrlBuild + "/post/report-post"
    static let reportPostByIdAr =  baseUrlBuildAR + "/post/report-post"
    
}
