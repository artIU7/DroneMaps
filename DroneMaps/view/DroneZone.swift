//
//  DroneZone.swift
//  TableCell
//
//  Created by brazilec22 on 02.04.2020.
//  Copyright © 2020 brazilec22. All rights reserved.
//

import UIKit
import NMAKit

class DroneZone: UITableViewController {
    var users = [User]()
    var ctr = [area]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://droneservice.herokuapp.com/users/"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
            //    parse(json: data)
                response(data: data)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.title = "Route Table"
       // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print(json)
        if let jsonPetitions = try? decoder.decode(Users.self, from: json) {
            users = jsonPetitions.results
            print(users)
            print(users)
            tableView.reloadData()
        }
    }
    func response(data : Data) {
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                // try to read out a string array
                print(json)
                for each in json {
                    let obj = each["locate"] as! NSArray
                    for p in obj  {
                        var a = p as! [String:Any]
                        ctr.append(area.init(lat: a["lat"] as! Double, lot: a["lot"] as! Double))
                    }
                   // print(obj[0] as! Dictionary)
                    let insertUser = User(altitude: each["altitude"] as! Double, id: each["id"] as! Int, positionID: each["positionID"] as! Int, username: each["username"] as! String, locate: ctr)
                    users.append(insertUser)
                    tableView.reloadData()
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }

    @IBAction func checkPost(_ sender: Any) {
        self.checkMethod()
    }
    // MARK
    func checkMethod() {
        print("")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        arrayARObject.removeAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username + ":" + "\(user.altitude)"
        
        // Configure the cell...
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        for k in user.locate {
            arrayARObject.append(NMAGeoCoordinates(latitude: k.lat, longitude: k.lot, altitude: 1))
                   }
        print(user.locate)
        self.dismiss(animated: true, completion: nil)
        print("index path: \(indexPath.row)")
        //self.dismiss(animated:true, completion: nil)
      
        //Ваши действия
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           print("running viewWillDisappear ============================")
       }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
        
