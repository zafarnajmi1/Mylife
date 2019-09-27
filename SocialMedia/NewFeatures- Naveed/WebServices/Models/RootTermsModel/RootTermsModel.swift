
import Foundation
import ObjectMapper

class RootTermsModel :NSObject, Mappable {
    
    
	var message : String?
	var data : TermsDataModel?

    class func newInstance(map: Map) -> Mappable?{
        return RootTermsModel()
    }
    required init?(map: Map){}
    override init(){}

	 func mapping(map: Map) {

		message <- map["message"]
		data <- map["data"]
	}

}
