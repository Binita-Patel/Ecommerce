//
//  Utils.swift


import UIKit

class Utils {
    
    static let sharedInstance = Utils()
    
    init(){}
    
    // MARK: - Alert Controller
    func SubmitAlertView(viewController : UIViewController,title : String, message : String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    
   func getCurrentVC()-> UIViewController{
          let rootVC = UIApplication.shared.keyWindow?.rootViewController
          
          if rootVC?.presentedViewController == nil {
              return rootVC!
          }
          
          if let presented = rootVC?.presentedViewController {
              if presented.isKind(of: UINavigationController.self) {
                  let navigationController = presented as! UINavigationController
                  return navigationController.viewControllers.last!
              }
              return presented
          }
          return UIViewController()
      }
}
