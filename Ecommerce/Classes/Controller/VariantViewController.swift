//
//  VariantViewController.swift
//  Ecommerce
//
//  Created by Binita Patel on 25/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
//import CoreData

class VariantViewController: UIViewController {
    @IBOutlet weak var tblVariants: UITableView!
    var appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrVariants: Array = Array<Any>()
    var strProductName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strProductName
        // Do any additional setup after loading the view.
        let btnSort = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(VariantViewController.actionBack(_:)))
              self.navigationItem.rightBarButtonItem = btnSort
    }

    //MARK:- UIButton Action
     
    @objc func actionBack(_ sender: Any){
        
        self.dismiss(animated: true, completion: nil)
            
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
extension VariantViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return arrVariants.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = NSString(format: "cell%d",indexPath.section)
        
            var cell: VariantTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier as String) as? VariantTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "VariantTableViewCell", bundle: nil), forCellReuseIdentifier: identifier as String)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier as String) as? VariantTableViewCell
            }
        if let dict = arrVariants[indexPath.section]  as? NSDictionary{
            if let color = dict.value(forKey: "color") {
                cell.lblColor.text = "Color : \(color)"
            }
            if let price = dict.value(forKey: "price") {
                cell.lblPrice.text = "Price : \(price)"
            }
            if let size = dict.value(forKey: "size") {
                cell.lblSize.text = "Size : \(size)"
            }
        }
        
        return cell!
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       

    }
    
    
    func tableView(_ tableView: UITableView, heightForSectionAt indexPath: IndexPath) -> CGFloat{
        return 120.0
    }
    
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame:CGRect(x: 0, y: 0, width:  tableView.frame.size.width, height: 10))
        footerView.backgroundColor = UIColor.clear
        return footerView
        
    }
    
}

