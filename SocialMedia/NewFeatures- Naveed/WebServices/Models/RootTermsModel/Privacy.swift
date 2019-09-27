
import Foundation
import ObjectMapper

class Privacy :NSObject, Mappable {
	var id : Int?
	var terms_type : String?
	var created_at : Int?
	var updated_at : Int?
	var translation : Translation?

    class func newInstance(map: Map) -> Mappable?{
        return RootTermsModel()
    }
    
    required init?(map: Map){}
    override init(){}

	 func mapping(map: Map) {

		id <- map["id"]
		terms_type <- map["terms_type"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		translation <- map["translation"]
	}

}
