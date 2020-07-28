//
//  NetworkLayer.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 24.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
//
var users = [User]()
var ctr = [area]()
var arImage = UIImage()
var googleImage = UIImage()
//https://image.maps.ls.hereapi.com/mia/1.6/mapview?apiKey=JdbJa6yZk5MljMzUe9bUO8X8FpHsF02J7UdmHY6hoKs&i&c=55.79109113663435,38.43966736458242&h=400&w=500&r=50
extension ViewController {
    // post
    func post(url : String,parametrs : [String:Any]) {
        guard let url = URL(string: url) else {return}
        let parametrs = parametrs//["id":"3","carrier":"LTE"] ["lon":48.3,"lat":38.5]
        var request = URLRequest(url : url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        guard let httBody = try? JSONSerialization.data(withJSONObject: parametrs, options: [.fragmentsAllowed]) else { return }
        //data(withJSONObject: parametrs, options: []) else {return}
        request.httpBody = httBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data,response,error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                 print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    //
    func getImage(url : String) {
        var image = UIImage()
        guard let url = URL(string: url) else {return}
               let session = URLSession.shared
               session.dataTask(with: url) { (data,response,error) in
                   if let response = response {
                       print(response)
                   }
                   guard let data = data else {return}
                   do {
                    image = UIImage(data: data)!
                    arImage = image
                    print(image.description)
                   } catch {
                       print(error)
                   }
               }.resume()
    }
    //https://api.живуспортом.рф/imagecache/size1024_jpeg/place_image/45/44707/5cd2cd3af276b.jpeg
    func getImageGoogle(url : String) {
          var image = UIImage()
          guard let url = URL(string: url) else {return}
                 let session = URLSession.shared
                 session.dataTask(with: url) { (data,response,error) in
                     if let response = response {
                         print(response)
                     }
                     guard let data = data else {return}
                     do {
                      image = UIImage(data: data)!
                      googleImage = image
                      print(image.description)
                     } catch {
                         print(error)
                     }
                 }.resume()
      }
    // get location
    func get(url : String/*,parametrs : [String:Any]*/) {
        guard let url = URL(string: url) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data,response,error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let p = json as! [[String:Any]]
                print("json response")
                print(json)
                print("json response decoder")
                print(p)
                print("stop")
            
                for response in p {
                print("select id")
                    guard let id = response["id"] /*as! Double*/ else {
                        return
                    }
                print("select lat")
                    guard let lat = response["lat"] /*as! Double*/ else {
                                       return
                    }
                print("select lon")
                    guard let lon = response["lon"] /*as! Double*/ else {
                                   return
                    }
                let colorPoly = #colorLiteral(red: 0.7268418864, green: 0.5883266902, blue: 0.7264475103, alpha: 0.5)
                self.createCircle(geoCoord: NMAGeoCoordinates(latitude: lat as! Double, longitude: lon as! Double), color: colorPoly, rad: Int(20000))
                }
               /* guard let lat = p["latitude"] /*as! Double*/ else {
                    return
                }
                guard let lon = p["longitude"] /*as! Double*/ else {
                    return
                }
                guard let id = p["id"] else {
                    return
                } */
           //     self.createCircle(geoCoord: NMAGeoCoordinates(latitude: lat as! Double, longitude: lon as! Double), color: UIColor.purple, rad: Int(2.5))
                /*if id_user == 1 {
                    self.createCircle(geoCoord: NMAGeoCoordinates(latitude: lat as! Double, longitude: lon as! Double), color: UIColor.purple, rad: Int(2.5))
                } else if id_user == 2 {
                    self.createCircle(geoCoord: NMAGeoCoordinates(latitude: lat as! Double, longitude: lon as! Double), color: UIColor.orange, rad: Int(2.5))
                } else {
                    self.createCircle(geoCoord: NMAGeoCoordinates(latitude: lat as! Double, longitude: lon as! Double), color: UIColor.green, rad: Int(2.5))
                } */
            } catch {
                print(error)
            }
        }.resume()
    }
    // update location
    // post
    func patch(url : String,parametrs : [String:Any]) {
        guard let url = URL(string: url) else {return}
        let parametrs = parametrs//["id":"3","carrier":"LTE"] ["lon":48.3,"lat":38.5]
        var request = URLRequest(url : url)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "PATCH"
        guard let httBody = try? JSONSerialization.data(withJSONObject: parametrs, options: [.fragmentsAllowed]) else { return }
        //data(withJSONObject: parametrs, options: []) else {return}
        request.httpBody = httBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data,response,error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                 print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    func loadArea() {
        let urlString = "https://droneservice.herokuapp.com/users/"
        areas.removeAll()
        ctr.removeAll()
               if let url = URL(string: urlString) {
                   if let data = try? Data(contentsOf: url) {
                   //    parse(json: data)
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
                                           areas.append(insertUser)
                                        ctr.removeAll()
                                       }
                                   }
                               } catch let error as NSError {
                                   print("Failed to load: \(error.localizedDescription)")
                               }
                       }
        }
    }
}
//
