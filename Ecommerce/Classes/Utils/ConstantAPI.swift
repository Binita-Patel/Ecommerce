import Foundation

struct ConstantAPI {
    
    //MARK:- Development or  Production Mode
    struct ReleaseMode{
        //        #if DEBUG
        //        static let IPHost = ""
        //        #else
        static let IPHost = "https://stark-spire-93433.herokuapp.com/"
        //        #endif
    }
    
    //MARK:- API URLs
    struct Url {
        
        static let GetCategories = ReleaseMode.IPHost + "json"
       
    }
    
    
   
}
