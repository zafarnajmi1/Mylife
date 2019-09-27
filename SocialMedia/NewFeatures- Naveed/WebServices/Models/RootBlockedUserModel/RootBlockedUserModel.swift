
import Foundation
import ObjectMapper

class RootBlockedUserModel : NSObject, Mappable {
	var message : String?
	var data : [BlockedUserDataModel]?
	var status_code : Int?
	

    class func newInstance(map: Map) -> Mappable?{
        return RootTermsModel()
    }
    required init?(map: Map){}
    override init(){}

	 func mapping(map: Map) {

		message <- map["message"]
		data <- map["data"]
		status_code <- map["status_code"]
		
	}

}
