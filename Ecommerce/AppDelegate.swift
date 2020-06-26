//
//  AppDelegate.swift
//  Ecommerce
//
//  Created by Binita Patel on 23/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD
import Reachability
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
       var reachability = try? Reachability()
       var lblInternetError = UILabel()

       var isReachable: Bool = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startReachablity()
        setMainScreen()
        return true
    }

   func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
            startReachablity()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Ecommerce")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK:- Start & Stop Loader

       func startLoader(_ view:UIView) {
           DispatchQueue.main.async {
               let hud =  MBProgressHUD.showAdded(to:view, animated: true)
               hud.label.text = "Loading..."
               hud.label.textColor = UIColor.white
               hud.bezelView.color = ColorFont.GrayDark.withAlphaComponent(0.8)
               hud.bezelView.style = .solidColor
               hud.contentColor = UIColor.white
           }
       }
       
       func stopLoader(_ view:UIView) {
           DispatchQueue.main.async {
               MBProgressHUD.hide(for: view, animated: true)
               MBProgressHUD().removeFromSuperViewOnHide = true
           }
       }

       //MARK:- Set Main screen
       func setMainScreen() {
         
             let categoriesVC = CategoriesViewController.init(nibName: "CategoriesViewController", bundle: nil)
               let frame = UIScreen.main.bounds
               self.window = UIWindow(frame: frame)
               let navCtrl: UINavigationController = UINavigationController(rootViewController: categoriesVC)
               navCtrl.isNavigationBarHidden = false
               self.window?.rootViewController = navCtrl
               self.window?.makeKeyAndVisible()
           
       }

       //MARK:- Reachablity
       func startReachablity(){
           
           NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
           do{
               try reachability?.startNotifier()
           }catch{
               print("could not start reachability notifier")
           }
       }
       
       @objc func reachabilityChanged(note: Notification) {
           
           let reachability = note.object as! Reachability
           if  reachability.connection == .unavailable{
               isReachable = false
               showInternetError()

           }
           else {
            if(isReachable == false) {
                NotificationCenter.default.post(name: .didReceiveData, object: nil)

            }
               isReachable = true

               removeInternetError()

           }
      
       }
       
       func stopReachablity(){
           reachability?.stopNotifier()
           NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
       }
       
       func showInternetError(){
           
           if(lblInternetError.isHidden == false) {
               lblInternetError.removeFromSuperview()
               
           }
                 
           lblInternetError.frame = CGRect(x: 0, y: 90, width: UIScreen.main.bounds.width, height: 50)
           
           lblInternetError.text = "Please check your internet connection"
           lblInternetError.font = UIFont.systemFont(ofSize: 15, weight: .medium)
           lblInternetError.textColor = UIColor.white
           lblInternetError.numberOfLines = 0
           lblInternetError.textAlignment = .center
           lblInternetError.backgroundColor = UIColor.gray
           lblInternetError.alpha = 1
           lblInternetError.isHidden = false
           window?.addSubview(lblInternetError)
           
       }
       
       func removeInternetError(){
           if lblInternetError.alpha == 1{
               UIView.animate(withDuration: 2, delay: 1, options: [], animations: {
                   self.lblInternetError.alpha = 0
               }, completion: {_ in
                   self.lblInternetError.isHidden = true
                   self.lblInternetError.removeFromSuperview()
               })
           }else{
               
           }
       }

}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
