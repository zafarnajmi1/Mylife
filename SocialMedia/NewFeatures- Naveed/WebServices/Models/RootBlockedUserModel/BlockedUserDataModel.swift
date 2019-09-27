

import Foundation
import ObjectMapper

class BlockedUserDataModel :NSObject, Mappable {
	var id : Int?
	var full_name : String?
	var email : String?
	var image : String?

    class func newInstance(map: Map) -> Mappable?{
        return BlockedUserDataModel()
    }
    required init?(map: Map){}
    override init(){}

	 func mapping(map: Map) {

		id <- map["id"]
		full_name <- map["full_name"]
		email <- map["email"]
		image <- map["image"]
	}

}
