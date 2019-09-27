
import Foundation
import ObjectMapper

class Translation :NSObject, Mappable {
	var language_id : Int?
	var term_id : Int?
	var title : String?
	var descriptionField : String?

    class func newInstance(map: Map) -> Mappable?{
        return Translation()
    }
    required init?(map: Map){}
    override init(){}
	
    func mapping(map: Map) {

		language_id <- map["language_id"]
		term_id <- map["term_id"]
		title <- map["title"]
		descriptionField <- map["description"]
	}

}
