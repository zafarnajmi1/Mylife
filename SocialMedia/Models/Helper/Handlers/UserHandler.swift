//
//  UserHandler.swift
//  Freestyle
//
//  Created by Macbook on 05/07/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import Alamofire

class UserHandler{
    
    static let sharedInstance = UserHandler()
    var dataArray = [UserLoginData]()
    var userData:UserLoginData?
    var isLoginCall = false
    
    
    // MARK: - User Registration
    class func registerUser(params: NSDictionary, success: @escaping (UserModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UserRegister
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UserRegister
        }
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UserRegister
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            
            let model = UserModel(fromDictionary: dictionary)
            print(model)
            let obj = NSKeyedArchiver.archivedData(withRootObject: model)
            UserDefaults.standard.set(obj, forKey: "user")
            UserDefaults.standard.synchronize()
            success(model)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - User Login
    class func loginUser(params: NSDictionary, success: @escaping (UserLoginModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var url = String()
        if lang == "ar" {
             url = ApiCalls.baseUrlBuildAR + ApiCalls.UserLogin
        }
        else {
             url = ApiCalls.baseUrlBuild + ApiCalls.UserLogin
        }
        
        
        print(url)
        print(params)
        UserHandler.sharedInstance.isLoginCall = true
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            print("\(dictionary)")

            let model = UserLoginModel(fromDictionary: dictionary)
            print(model)
            
            let obj = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(obj, forKey: "user")
            UserDefaults.standard.synchronize()
            // retrieving a value for a key
            
            //            if let userInfo =  UserDefaults.standard.object(forKey: "user") {
            //                let userProfile = NSKeyedUnarchiver.unarchiveObject(with: userInfo as! Data) as! [String : Any]
            //                print(userProfile)
            //                let dictionary2 = userProfile
            //                let  model2 = UserLoginModel(fromDictionary: dictionary2)
            //                print(model2)
            //            }
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - User Logout
    class func logoutUser(success: @escaping (UserLogoutModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UserLogout
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UserLogout
        }
        
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UserLogout
//        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let model = UserLogoutModel(fromDictionary: dictionary)
            print(model)
            
            //            let obj = NSKeyedArchiver.archivedData(withRootObject: model)
            //            UserDefaults.standard.set(obj, forKey: "user")
            //            UserDefaults.standard.synchronize()
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - FORGOT PASSWORD
    class func forgotPassword(params: NSDictionary,success: @escaping (forgotPasswordModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.forgotPassword
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.forgotPassword
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.forgotPassword
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = forgotPasswordModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - CHANGE    PASSWORD
    class func changePassword(params: NSDictionary,success: @escaping (forgotPasswordModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.changePassword
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.changePassword
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.changePassword
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = forgotPasswordModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - SEARCH PEOPLE
    class func searchPeople(params: NSDictionary,success: @escaping (SearchPeopleModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.SearchPeople
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.SearchPeople
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.SearchPeople
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            print("\n\n")
            print(successResponse)
            print("\n\n")
            
            let dictionary = successResponse as! [String: AnyObject]
            
            let objData = SearchPeopleModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - GET COMMENTS
    class func getComments(pageNo:String,params: NSDictionary,success: @escaping (GetCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.GetComments + "?page=" + pageNo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.GetComments + "?page=" + pageNo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.GetComments + "?page=" + pageNo
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = GetCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    class func getSubComments(pageNo:String,params: NSDictionary,success: @escaping (GetCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.GetSubComments + "?page=" + pageNo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.GetSubComments + "?page=" + pageNo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.GetSubComments + "?page=" + pageNo
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = GetCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - POST COMMENTS with Attachement
    class func postCommentsWithAttachment(fileUrl:URL, params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.PostComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.PostComments
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.PostComments
//        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "attachment", params: params as? Parameters, uploadProgress: { (progess) in
            print(Progress())
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    
    // MARK: - POST COMMENTS with Attachement
    class func postsubCommentsWithAttachment(fileUrl:URL, params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.PostsubComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.PostsubComments
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.PostsubComments
//        print(url)
        
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "attachment", params: params as? Parameters, uploadProgress: { (progess) in
            print(Progress())
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    // MARK: - POST COMMENTS without Attachement
    class func postsubCommentwithoutAttachement(params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.PostsubComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.PostsubComments
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.PostsubComments
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - POST COMMENTS without Attachement
    class func postCommentwithoutAttachement(params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.PostComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.PostComments
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.PostComments
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - POST COMMENTS without Attachement
    class func deleteComment(params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.DeleteComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.DeleteComments
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.DeleteComments
//        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - POST COMMENTS  Attachement
    class func updateComment(fileUrl:URL, params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UpdateComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UpdateComments
        }
        
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UpdateComments
//        print(url)
        
        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: "attachment", params: params as? Parameters, uploadProgress: { (progess) in
            print(Progress())
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    // MARK: - POST COMMENTS without Attachement
    class func updateCommentwithoutAttachement(params: NSDictionary,success: @escaping (PostCommentsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UpdateComments
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UpdateComments
        }
        
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UpdateComments
//        print(url)
        
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let objData = PostCommentsModel(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - MY FOLLOWERS
    class func myFollowers(success: @escaping (FollowersModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.MyFollowers
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.MyFollowers
        }
        
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.MyFollowers
//        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let model = FollowersModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - MY FOLLOWINGS
    class func myFollowings(success: @escaping (FollowersModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.MyFollowings
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.MyFollowings
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.MyFollowings
//        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let model = FollowersModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
  
    
    // MARK: - ADD/EDIT WORK INFORMATION
    class func addEditWorkInfo(params: NSDictionary, success: @escaping (AddEditWorkInfoModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.AddEditWorkInfo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.AddEditWorkInfo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.AddEditWorkInfo
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            //            UserHandler.sharedInstance.userData?.workDetails.append(UserLoginWorkDetail(fromDictionary: dictionary))
            let model = AddEditWorkInfoModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    // MARK: - edit Profile Picture And Cover Photo
    class func editProfilePictureAndCoverPhoto(fileName:String,fileUrl:URL, params: NSDictionary,success: @escaping (UserLoginModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.EditUserInformation
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.EditUserInformation
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.EditUserInformation
//        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: fileName, params: params as? Parameters, uploadProgress: { (progress) in
            print(progress)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objData = UserLoginModel.init(fromDictionary: dictionary)
            success(objData)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - DELETE WORK INFORMATION
    class func deleteWorkInfo(params: NSDictionary, success: @escaping (AddEditWorkInfoModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.DeleteWorkInfo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.DeleteWorkInfo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.DeleteWorkInfo
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            //            UserHandler.sharedInstance.userData?.workDetails.append(UserLoginWorkDetail(fromDictionary: dictionary))
            let model = AddEditWorkInfoModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    
    // MARK: - ADD/EDIT Education INFORMATION
    class func addEditEducationInfo(params: NSDictionary, success: @escaping (addEditEducationInformationModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.AddEditEducationInfo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.AddEditEducationInfo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.AddEditEducationInfo
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            
            let model = addEditEducationInformationModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    // MARK: - DELETE EDUCATION INFORMATION
    class func deleteEducationInfo(params: NSDictionary, success: @escaping (addEditEducationInformationModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.DeleteEducationInfo
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.DeleteEducationInfo
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.DeleteEducationInfo
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            
            let model = addEditEducationInformationModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    // MARK: - EDIT USER INFORMATION
    class func editUserInfo(params: NSDictionary, success: @escaping (UserLoginModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.EditUserInformation
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.EditUserInformation
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.EditUserInformation
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
             print(dictionary)
            let model = UserLoginModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - GET USER PHOTOES
    class func getUserPhotoes(params: NSDictionary, success: @escaping (UserPhotoesModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UserPhotoes
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UserPhotoes
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UserPhotoes
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            
            let model = UserPhotoesModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - GET USER VIDEOS
    class func getUserVideos(params: NSDictionary, success: @escaping (UserVideosModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UserVideos
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UserVideos
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UserVideos
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let model = UserVideosModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    // MARK: - GET Unread Notification Count
    class func getUnreadNotificationCount(success: @escaping (UnreadNotificationCoutModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UnreadNotificationCount
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UnreadNotificationCount
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UnreadNotificationCount
//        //print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            //print(dictionary)
            let model = UnreadNotificationCoutModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    class func getUnreadMessageCount(success: @escaping (UnreadMessageCoutModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.UnreadMessageCount
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.UnreadMessageCount
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.UnreadMessageCount
        //print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            //print(dictionary)
            let model = UnreadMessageCoutModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - GET MY Notification
    class func getMyNotifications(success: @escaping (MyNotificationsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.Notifications
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.Notifications
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.Notifications
//        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let model = MyNotificationsModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    
    
    // MARK: - GET MY Notification
    class func readAllNotifications(success: @escaping (MyNotificationsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.readNotifications
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.readNotifications
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.readNotifications
//        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let model = MyNotificationsModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    
    
    
    
    class func getNextMyNotifications(url: String, success: @escaping (MyNotificationsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
//        var url = String()
//        if lang == "ar" {
//            url = ApiCalls.baseUrlBuildAR + ApiCalls.UserRegister
//        }
//        else {
//            url = ApiCalls.baseUrlBuild + ApiCalls.UserRegister
//        }
        
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: AnyObject]
            let model = MyNotificationsModel(fromDictionary: dictionary)
            print(model)
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            
        }
    }
    
    // MARK: - Mark Notification as Read
    class func markNotificationAsRead(params: NSDictionary, success: @escaping (NotificationReadModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.MarkNotificationAsRead
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.MarkNotificationAsRead
        }
//        let url = ApiCalls.baseUrlBuild + ApiCalls.MarkNotificationAsRead
//        print(url)
//        print(params)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            
            let model = NotificationReadModel(fromDictionary: dictionary)
            print(model)
            
            success(model)
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    // MARK: - Get Other User Profile
    class func getOtherUserProfile (params: NSDictionary, success: @escaping (UserProfileModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.getOtherUserProfile
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.getOtherUserProfile
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.getOtherUserProfile
//        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters , success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objOtherUser = UserProfileModel.init(fromDictionary: dictionary)
            success(objOtherUser)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    // MARK: - Get User About
    
    class func getUserAbout (params: NSDictionary, success: @escaping (AboutUserModel)-> Void, failure: @escaping (NetworkError?)->Void){
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.aboutUser
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.aboutUser
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.aboutUser
//        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            print(successResponse)
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objAboutUser = AboutUserModel.init(fromDictionary: dictionary)
            success(objAboutUser)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    // MARK: - Get Faqs
    class func getFaqs (success: @escaping (FaqsModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.GetFaqs
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.GetFaqs
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.GetFaqs
//        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: AnyObject]
            let objFaqs = FaqsModel.init(fromDictionary: dictionary)
            success(objFaqs)
            
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
    
    // MARK: - Post Faq
    class func postFAQ (params: NSDictionary, success: @escaping (FAQModel)-> Void, failure: @escaping (NetworkError?)->Void){
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var url = String()
        if lang == "ar" {
            url = ApiCalls.baseUrlBuildAR + ApiCalls.PsotFaqs
        }
        else {
            url = ApiCalls.baseUrlBuild + ApiCalls.PsotFaqs
        }
        
//        let url = ApiCalls.baseUrlBuild + ApiCalls.PsotFaqs
//        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            print(successResponse)
            let dictionary = successResponse as! [String: AnyObject]
            print(dictionary)
            let objAboutUser = FAQModel.init(fromDictionary: dictionary)
            success(objAboutUser)
        }) { (errorResponse) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: errorResponse.message))
        }
    }
}
