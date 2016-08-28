//
//  ViewController.swift
//  Practices1
//
//  Created by Horacio Garza on 27/08/16.
//  Copyright © 2016 HGarz Studios. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    var totalChamps:Int = 2
    var champNameIdentifier = [String]()
    var champData:NSDictionary!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getFromLOLAPI()
        
        
        
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    

    //MARK: JSON
    func getFromLOLAPI(){
        
        
        let requestURL = NSURL(string: "http://ddragon.leagueoflegends.com/cdn/6.17.1/data/en_US/champion.json")!
        let urlRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            
            do{
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                
                
                let basics = json as! NSDictionary
                self.champData = basics["data"] as! NSDictionary
                self.totalChamps = Int(self.champData.count)
                
                
                for champName in self.champData.allKeys{
                    print(champName)
                    
                    
                    self.champNameIdentifier.append(champName as! String)
                }
                
                self.do_table_refresh()
                
            }catch {
                print("Error with Json: \(error) \(statusCode)")
            }
        }
        task.resume()
        
        
        
    }
    
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if !champNameIdentifier.isEmpty {
            let champStringName = champNameIdentifier[indexPath.row]
            let champCompleteData = champData[champStringName]
            let nameID = champCompleteData!["name"] as! String
            cell.textLabel?.text = nameID
        }else{
            cell.textLabel?.text = "1"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.totalChamps
    }
    
    
    


}

