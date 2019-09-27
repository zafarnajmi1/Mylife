

import Foundation
import ObjectMapper

class TermsDataModel : NSObject ,Mappable {
	var terms : [Terms]?
	var permissions : [Permissions]?
	var privacy : [Privacy]?

    class func newInstance(map: Map) -> Mappable?{
        return TermsDataModel()
    }
    required init?(map: Map){}
    override init(){}
    
    
	 func mapping(map: Map) {

		terms <- map["terms"]
		permissions <- map["permissions"]
		privacy <- map["privacy"]
	}

}
