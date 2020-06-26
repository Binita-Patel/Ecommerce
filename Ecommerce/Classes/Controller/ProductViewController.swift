//
//  ProductViewController.swift
//  Ecommerce
//
//  Created by Binita Patel on 24/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData
class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionVw: UICollectionView!
    @IBOutlet var pickerViewRanking: UIPickerView!
    @IBOutlet var toolbarPicker: UIToolbar!

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrProducts: [NSManagedObject] = []
    var arrRankings: [NSManagedObject] = []
    var selectedElement : String! = "Most Viewed Products"
    var indexValue : Int! = 0
    
    var cat_id : Int = 0
    var arrChildCategories :  Array = Array<Any>()
    var strProductName : String = "Products"
    override func viewDidLoad() {
        super.viewDidLoad()
        if(arrChildCategories.count > 0) {
            self.title = "SubCategories"

        }
        else {
            self.title = strProductName
            let btnSort = UIBarButtonItem(title: "Sort", style: .done, target: self, action: #selector(ProductViewController.actionSort(_:)))
                  self.navigationItem.rightBarButtonItem = btnSort
            fetchProducts()
            fetchRankings()
        }
        
      
        
        setupCollectionView()
       
    }

    func setupCollectionView() {
        collectionVw.delegate = self
        collectionVw.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionVw!.collectionViewLayout = layout
        collectionVw.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
    }
    
    func fetchProducts() {
        arrProducts.removeAll()
        let managedObjContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Products")
        fetchRequest.predicate = NSPredicate(format:"%K == %d", "cat_id", cat_id)

        do {
            arrProducts = try managedObjContext.fetch(fetchRequest).reversed()
        } catch let error as NSError {
            print("Error while fetching the data:: ",error.description)
        }
        collectionVw.reloadData()
    }
    
    func fetchRankings() {
        let managedObjContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rankings")

        do {
            arrRankings = try managedObjContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error while fetching the data:: ",error.description)
        }
        pickerViewRanking.reloadAllComponents()
    }
    
    //MARK:- UIButton Action
     
    @objc func actionSort(_ sender: Any){
        
       if indexValue != nil{
           self.pickerViewRanking.selectRow(indexValue, inComponent: 0, animated: true)
       }
        pickerViewRanking.isHidden = false
        toolbarPicker.isHidden = false
        self.view.endEditing(true)
            
    }
    
    @IBAction func actionDonePicker(_ sender: Any) {
        pickerViewRanking.isHidden = true
        toolbarPicker.isHidden = true
        arrProducts.removeAll()
        let managedObjContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Products")
        fetchRequest.predicate = NSPredicate(format:"%K == %d", "cat_id", cat_id)
        var strKey : String = "shares"
        if(selectedElement == "Most Viewed Products") {
            strKey = "view_count"
        }
        else if(selectedElement == "Most OrdeRed Products") {
            strKey = "order_count"

        }
        else {
            strKey = "shares"

        }
        
        let sort = NSSortDescriptor(key: strKey, ascending: true)
           fetchRequest.sortDescriptors = [sort]

        do {
            arrProducts = try managedObjContext.fetch(fetchRequest).reversed()
        } catch let error as NSError {
            print("Error while fetching the data:: ",error.description)
        }
        

        collectionVw.reloadData()
        
    }
    
    @IBAction func actionCancelPicker(_ sender: Any) {
        pickerViewRanking.isHidden = true
        toolbarPicker.isHidden = true
        fetchProducts()
         
    }


    // MARK: - Generate Random Colors
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return randomColor
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: - UICollectionViewDelegate ,UICollectionViewDataSource & UICollectionViewDelegateFlowLayout Methods
extension ProductViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(arrChildCategories.count > 0) {
            return arrChildCategories.count
        }
        return arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVw.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? ProductsCollectionViewCell
        if(arrChildCategories.count > 0) {
            if let strcatName = arrChildCategories[indexPath.row]  as? NSNumber{
                    cell!.lblProductName.text = "\(strcatName)"
               
            }
            cell?.btnInfo.isHidden = true

        }
        else {
            let product = arrProducts[indexPath.row]
            cell?.lblProductName.text = product.value(forKeyPath: "name") as? String
            cell?.btnInfo.isHidden = false

        }
      cell!.lblProductName.backgroundColor = generateRandomColor().withAlphaComponent(0.5)

        cell?.lblProductName.layer.cornerRadius = 5.0
        cell?.lblProductName.layer.borderColor = ColorFont.GrayBorder.cgColor
        cell?.lblProductName.layer.borderWidth = 1.0
        cell?.lblProductName.clipsToBounds = true
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(arrChildCategories.count > 0) {
            return
        }
        let product = arrProducts[indexPath.row]

        let data = product.value(forKeyPath: "variants") as! NSData
        let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)

        let arrayObject = unarchiveObject as AnyObject? as! [[String: Any]]
        let variantVC = VariantViewController.init(nibName: "VariantViewController", bundle: nil)
        variantVC.arrVariants = arrayObject as Array
        variantVC.strProductName =  (product.value(forKeyPath: "name") as? String)!
        let navCtrl: UINavigationController = UINavigationController(rootViewController: variantVC)
        self.present(navCtrl, animated: true, completion: nil)
    }
}

extension ProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component:  Int) -> Int {
        return arrRankings.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let ranking = arrRankings[row]
        return ranking.value(forKeyPath: "ranking") as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let ranking = arrRankings[row]
        indexValue = row
        selectedElement = ranking.value(forKeyPath: "ranking") as? String

    }
    
}

