import Foundation

struct UserLoginData{
    
    var aboutMe : String!
    var birthday : Int!
    var contacts : [AnyObject]!
    var contactsArray = [Contactdata]()
    var cover : String!
    var createdAt : Int!
    var educationDetails : [UserLoginEducationDetail]!
    var email : String!
    var fullName : String!
    var gender : String!
    var id : Int!
    var image : String!
    
    var dob_privacy : String!
    var about_me_privacy : String!
    var living_place_privacy : String!
    var education_privacy : String!
    var mobile_privacy : String!
      var email_privacy : String!
    var relationship_privacy : String!
    var work_privacy : String!
    
    var isOnline : Bool!
    var livingPlace : String!
    var mobile : String!
    var notifiyFriendRequest : Bool!
    var notifiyPostComment : Bool!
    var notifiyPostLike : Bool!
    var notifiyPostShare : Bool!
    var notifiyRequestAccepted : Bool!
    var relationship : String!
    var totalFollowers : Int!
    var total_friends : Int!
    var total_followings : Int!
    var updatedAt : Int!
    var workDetails : [UserLoginWorkDetail]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aboutMe = dictionary["about_me"] as? String
        about_me_privacy = dictionary["about_me_privacy"] as? String
        dob_privacy = dictionary["dob_privacy"] as? String
        education_privacy = dictionary["education_privacy"] as? String
        living_place_privacy = dictionary["living_place_privacy"] as? String
        mobile_privacy = dictionary["mobile_privacy"] as? String
        email_privacy = dictionary["email_privacy"] as? String
        relationship_privacy = dictionary["relationship_privacy"] as? String
        work_privacy =  dictionary["work_privacy"] as? String
        birthday = dictionary["birthday"] as? Int
        contacts = dictionary["contacts"] as? [AnyObject]
        cover = dictionary["cover"] as? String
        createdAt = dictionary["created_at"] as? Int
        educationDetails = [UserLoginEducationDetail]()
        if let educationDetailsArray = dictionary["educationDetails"] as? [[String:Any]]{
            for dic in educationDetailsArray{
                let value = UserLoginEducationDetail(fromDictionary: dic)
                educationDetails.append(value)
            }
        }
        email = dictionary["email"] as? String
        fullName = dictionary["full_name"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? String
        isOnline = dictionary["is_online"] as? Bool
        livingPlace = dictionary["living_place"] as? String
        mobile = dictionary["mobile"] as? String
        notifiyFriendRequest = dictionary["notifiy_friend_request"] as? Bool
        notifiyPostComment = dictionary["notifiy_post_comment"] as? Bool
        notifiyPostLike = dictionary["notifiy_post_like"] as? Bool
        notifiyPostShare = dictionary["notifiy_post_share"] as? Bool
        notifiyRequestAccepted = dictionary["notifiy_request_accepted"] as? Bool
        relationship = dictionary["relationship"] as? String
        totalFollowers = dictionary["total_followers"] as? Int
        total_friends = dictionary["total_friends"] as? Int

        total_followings = dictionary["total_followings"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
        workDetails = [UserLoginWorkDetail]()
        if let workDetailsArray = dictionary["workDetails"] as? [[String:Any]]{
            for dic in workDetailsArray{
                let value = UserLoginWorkDetail(fromDictionary: dic)
                workDetails.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aboutMe != nil{
            dictionary["about_me"] = aboutMe
        }
        if work_privacy != nil{
            dictionary["work_privacy"] = work_privacy
        }
        if relationship_privacy != nil{
            dictionary["relationship_privacy"] = relationship_privacy
        }
        
        if mobile_privacy != nil{
            dictionary["mobile_privacy"] = mobile_privacy
        }
        if email_privacy != nil{
            dictionary["email_privacy"] = email_privacy
        }
        if dob_privacy != nil{
            dictionary["dob_privacy"] = dob_privacy
        }
        if living_place_privacy != nil{
            dictionary["living_place_privacy"] = living_place_privacy
        }
        if education_privacy != nil{
            dictionary["education_privacy"] = education_privacy
        }
        
        if about_me_privacy != nil{
            dictionary["about_me_privacy"] = about_me_privacy
        }
        if birthday != nil{
            dictionary["birthday"] = birthday
        }
        if contacts != nil{
            dictionary["contacts"] = contacts
        }
        if cover != nil{
            dictionary["cover"] = cover
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if educationDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for educationDetailsElement in educationDetails {
                dictionaryElements.append(educationDetailsElement.toDictionary())
            }
            dictionary["educationDetails"] = dictionaryElements
        }
        if email != nil{
            dictionary["email"] = email
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if isOnline != nil{
            dictionary["is_online"] = isOnline
        }
        if livingPlace != nil{
            dictionary["living_place"] = livingPlace
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if notifiyFriendRequest != nil{
            dictionary["notifiy_friend_request"] = notifiyFriendRequest
        }
        if notifiyPostComment != nil{
            dictionary["notifiy_post_comment"] = notifiyPostComment
        }
        if notifiyPostLike != nil{
            dictionary["notifiy_post_like"] = notifiyPostLike
        }
        if notifiyPostShare != nil{
            dictionary["notifiy_post_share"] = notifiyPostShare
        }
        if notifiyRequestAccepted != nil{
            dictionary["notifiy_request_accepted"] = notifiyRequestAccepted
        }
        if relationship != nil{
            dictionary["relationship"] = relationship
        }
        if totalFollowers != nil{
            dictionary["total_followers"] = totalFollowers
        }
        
        
        
        if total_friends != nil{
            dictionary["total_friends"] = total_friends
        }
        
        
        if total_followings != nil{
            dictionary["total_followings"] = total_followings
        }
        
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if workDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for workDetailsElement in workDetails {
                dictionaryElements.append(workDetailsElement.toDictionary())
            }
            dictionary["workDetails"] = dictionaryElements
        }
        return dictionary
    }
    
}
