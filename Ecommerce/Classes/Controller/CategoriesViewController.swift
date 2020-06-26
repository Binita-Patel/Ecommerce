//
//  CategoriesViewController.swift
//  Ecommerce
//
//  Created by Binita Patel on 23/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    @IBOutlet weak var tblCategories: UITableView!
    var appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrCategories: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)

        fetchCategories()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
              NotificationCenter.default.removeObserver(self, name: .didReceiveData, object: nil)
      }
    
    @objc func onDidReceiveData(_ notification:Notification) {
           // Do something now
        self.appdelegate.stopLoader(self.view)

           fetchCategories()
       }
       
    
    func fetchCategories() {
        arrCategories.removeAll()
           let managedObjContext = appdelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")

           do {
               arrCategories = try managedObjContext.fetch(fetchRequest)
           } catch let error as NSError {
               print("Error while fetching the data:: ",error.description)
           }
        if(arrCategories.count == 0) {
            apiGetCategoriesListings()

        }
        
           tblCategories.reloadData()
       }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - API Methods
    func apiGetCategoriesListings() {
        let urlStr = ConstantAPI.Url.GetCategories
        appdelegate.startLoader(self.view)
        self.arrCategories.removeAll()
        JSONService().getAsyncCall(strUrl: urlStr, HeaderValueForOpenAPI: "") { (success, data) in
            if success{
                print(data)
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        DispatchQueue.main.async {

                            let arrResults : NSMutableDictionary = jsonResult as! NSMutableDictionary
                            let arrCat = arrResults.value(forKey: "categories")
                            // 1
                            let managedContext =
                            self.appdelegate.persistentContainer.viewContext
                                                       
                            // 2
                            let entity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
                            let entityProducts = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)!

                            for json in arrCat as! [NSDictionary]{
                                // 3
                                let category = NSManagedObject(entity: entity, insertInto: managedContext)

                                category.setValue(json["id"], forKeyPath: "id")
                                category.setValue(json["name"], forKeyPath: "name")
                           
                                
                                let arrProducts = json["products"]
                                for product in arrProducts as! [NSDictionary]{
                                    let productObj = NSManagedObject(entity: entityProducts, insertInto: managedContext)

                                    productObj.setValue(product["id"], forKeyPath: "id")
                                    productObj.setValue(product["name"], forKeyPath: "name")
                                    productObj.setValue(json["id"], forKeyPath: "cat_id")
                                    productObj.setValue(product["date_added"], forKeyPath: "date_added")
                                    if let variantsdata = try? NSKeyedArchiver.archivedData(withRootObject: product["variants"]!, requiringSecureCoding: true) {
                                        productObj.setValue(variantsdata, forKey: "variants")

                                    }
                                    if let taxdata = try? NSKeyedArchiver.archivedData(withRootObject: product["tax"]!, requiringSecureCoding: true) {
                                        productObj.setValue(taxdata, forKey: "tax")

                                    }
                                }

                                if let childdata = try? NSKeyedArchiver.archivedData(withRootObject: json["child_categories"]!, requiringSecureCoding: true) {
                                    category.setValue(childdata, forKey: "child_categories")

                                }
                                
                               
                                // 4
                                do {
                                  try managedContext.save()
                                   self.arrCategories.append(category)
                                } catch let error as NSError {
                                  print("Could not save. \(error), \(error.userInfo)")
                                }
                            }
                          
                            self.setupRankings(arrRankings: arrResults.value(forKey: "rankings") as! NSMutableArray)
                             
                          
                            self.tblCategories.reloadData()
                            self.appdelegate.stopLoader(self.view)
                        }

                    }catch {
                        self.appdelegate.stopLoader(self.view)

                }
            }else{
                DispatchQueue.main.async {
                    self.appdelegate.stopLoader(self.view)
                }
            }
        }
    }
    
    func setupRankings(arrRankings : NSMutableArray) {
        let managedContext =
                                 self.appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Rankings", in: managedContext)!

         for json in arrRankings as! [NSDictionary]{
             // 3
            let ranking = NSManagedObject(entity: entity, insertInto: managedContext)

            ranking.setValue(json["ranking"], forKeyPath: "ranking")
        
             
            let arrProducts = json["products"]
            for product in arrProducts as! [NSDictionary]{
            let pid : Int = product["id"] as! Int
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
            fetchRequest.predicate = NSPredicate(format: "id = %d", pid)
            do {
                    let fetchResults = try managedContext.fetch(fetchRequest)
                    if fetchResults.count != 0{
                        let managedObject = fetchResults[0]
                        if(product["order_count"] != nil) {
                            (managedObject as AnyObject).setValue(product["order_count"], forKey: "order_count")

                        }
                        else if(product["shares"] != nil) {
                            (managedObject as AnyObject).setValue(product["shares"], forKey: "shares")

                        }
                        else {
                            (managedObject as AnyObject).setValue(product["view_count"], forKey: "view_count")

                        }

                        try managedContext.save()
                    }
                       } catch let error as NSError {
                           print("Error while fetching the data:: ",error.description)
                       }
              
                
             }         
           
             // 4
             do {
               try managedContext.save()
             } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
             }
         }


    }
    
    // MARK: - Generate Random Colors
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }


}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return arrCategories.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = NSString(format: "cell%d",indexPath.section)
        
            var cell: CategoriesTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier as String) as? CategoriesTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: identifier as String)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier as String) as? CategoriesTableViewCell
            }
        cell.backgroundColor = generateRandomColor().withAlphaComponent(0.5)
        let category = arrCategories[indexPath.section]

        cell.lblCategoryName.text = category.value(forKeyPath: "name") as? String
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell!
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let category = arrCategories[indexPath.section]

        let data = category.value(forKeyPath: "child_categories") as! NSData
        let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)

        let arrayObject = unarchiveObject as AnyObject?
        let objProductVC  = ProductViewController(nibName:"ProductViewController",bundle:nil)

        if((arrayObject?.count)! > 0) {
            objProductVC.arrChildCategories = arrayObject as! [Any]
        }
        else {
            objProductVC.strProductName = (category.value(forKeyPath: "name") as? String)!
        }
        objProductVC.cat_id = category.value(forKeyPath: "id") as! Int

        self.navigationController?.pushViewController(objProductVC, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, heightForSectionAt indexPath: IndexPath) -> CGFloat{
        return 72.0
    }
    
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame:CGRect(x: 0, y: 0, width:  tableView.frame.size.width, height: 10))
        footerView.backgroundColor = UIColor.clear
        return footerView
        
    }
    
}

