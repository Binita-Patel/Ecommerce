
import Foundation
import UIKit
//import Reachability

/** A simple HTTP client for fetching JSON data. */
//@available(iOS 13.0, *)
class JSONService : NSObject, NSURLConnectionDataDelegate
{
    
    var query = String()
    var data: NSMutableData = NSMutableData()
    
    var success: Bool = false
    var statusCode: Int!
    
    let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
 
    var webserviceTypeTag : Int! = 0
    var closure: (Bool, Data) -> () = {_,_ in }
    override init(){
        super.init()
    }
    
    
    
    
    //MARK: - Check Status Code
    
    func checkResponseCode(_ responseCode: Int) -> Bool{
        
        if (responseCode == 200 || responseCode == 201 || responseCode == 204)
        {
            return true
        }
        else if (responseCode == 400)
        {
            print("Error Code 400")
        }
        else if (responseCode == 401)
        {
            print("Error Code 401")
        }
        else if (responseCode == 403)
        {
            print("Error Code 403")
        }
        else if (responseCode == 404)
        {
            print("Error Code 404: File Not Found.")
        }
        return false
    }
    
    
    
    //MARK: - Show Alerts
    func showAlert(_ title: String, msg: String){
        
    }
    
    
    // MARK:- GET Async methods with completion handler
    public func getAsyncCall(strUrl: String, HeaderValueForOpenAPI: String, completion: @escaping (_ result: Bool, _ response: Data) -> ())
    {
        print("Asyc Get API Call.....\(strUrl)")
        
        if !appdelegate.isReachable
        {
            return completion(false, Data())
        }
        
        let url: URL = URL(string: strUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        
       
        request1.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        request1.httpMethod = "GET"
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20.0
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let task = session.dataTask(with: request1 as URLRequest) {data, response, error in
            
            guard let dataResp = data else { return }
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                print("GET Response......\(jsonResult)")
                DispatchQueue.main.async {
                    if(statusCode >= 400 && statusCode <= 500 && statusCode != 401){
                        if let dict = jsonResult as? NSDictionary{
                            let alert = UIAlertController(title: ConstantMsg.alert_Title,
                                                          message: dict.value(forKey: "title") as? String,
                                                          preferredStyle: .alert)
                            let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            Utils.sharedInstance.getCurrentVC().present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            catch{
                
            }
            
            if let error = error {
                print("DataTask error:\(error)")
                return completion(false, dataResp)
            }
            if(response == nil) {
                return completion(false, dataResp)
            }
            
            if statusCode == 401{
            }
            
            
            
            let success = self.checkResponseCode(statusCode)
            completion(success, dataResp)
        }
        task.resume()
    }
   
    
}
