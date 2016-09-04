//
//  ViewController.swift
//  Practices1
//
//  Created by Horacio Garza on 27/08/16.
//  Copyright © 2016 HGarz Studios. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    var totalChamps:Int = 0
    var champName = [String]()
    var champIDNames = [String: String]()
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getFromLOLAPI()
        tableView.delegate = self
        
        
        
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
    //MARK: JSON
    func getFromLOLAPI(){
        
        Alamofire.request(.GET, "http://ddragon.leagueoflegends.com/cdn/6.17.1/data/en_US/champion.json")
            .responseJSON { response in
               /* print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization*/
                
                
                
                if let json = response.result.value {
                    //print("JSON: \(json)")
                    let data = JSON(json)
                    let names = data["data"]
                    self.totalChamps = names.dictionaryValue.count
                    for (key, subJson) in names {
                        if let title = subJson["name"].string, id = subJson["id"].string{
                            print("\(title), \(id)")
                            self.champIDNames[id] = title
                            self.champName.append(title)
                        }
                    }
                    
                    self.do_table_refresh()
                    
                }
        }
        
        
        
        
        
        
    }
    
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if !champName.isEmpty {
            /*let champStringName = champName[indexPath.row]
            let champCompleteData = champData[champStringName]
            let nameID = champCompleteData!["name"] as! String*/
            cell.textLabel?.text = champName[indexPath.row]
        }else{
            cell.textLabel?.text = "1"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.totalChamps
    }
    
    
    


}

