//
//  routeChild.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
import YandexMapKit
import YandexMapKitTransport

extension ViewController {
    
@IBAction func routeChild(_ sender: Any) {
    
    ///     var bridge = ViewController()
  //  var bridge = MapKitYAView()
  //  bridge.computedRoute(start: <#YMKPoint#>, end: <#YMKPoint#>)
    
    

    let  myPosition = NMAPositioningManager.sharedInstance().currentPosition
    var routingMode = NMARoutingMode()
    routingMode = NMARoutingMode.init(
        
        routingType: NMARoutingType.fastest,//shortest,//.fastest,
        transportMode: NMATransportMode.pedestrian,//pedestrian,
        routingOptions: []//NMARoutingOption.avoidTollRoad
    )
    
    // check if calculation completed otherwise cancel.
    if !(progress?.isFinished ?? false) {
        progress?.cancel()
    }
    route.insert(NMAGeoCoordinates(latitude: (myPosition?.coordinates!.latitude)!, longitude: (myPosition?.coordinates!.longitude)!), at: 0)
    ROUTE_START_POINT = YMKPoint(latitude: (myPosition?.coordinates!.latitude)!, longitude: (myPosition?.coordinates!.longitude)!)

    print("computed route:\(route)")
    progress = coreRouter.calculateRoute(withStops: route, routingMode: routingMode, { (routeResult, error) in
            print("new route : \(self.route)")
              
        if (error != NMARoutingError.none) {
            NSLog("Error in callback: \(error)")
            return
        }
        guard let route = routeResult?.routes?.first else {
            print("Empty Route result")
            return
        }
        self.routeNav = route
        print(routeResult?.routes?.first)
        guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
            print("Can't init Map Route")
            return
        }
        //mapRouteNav.init(route)
        if (self.mapRouts.count != 0) {
            for route in self.mapRouts {
                self.mapHere.remove(mapObject: route)
            }
            self.mapRouts.removeAll()
            self.route.removeAll()
        }
        if (layerRoute1.count != 0) {
            for r in layerRoute1 {
                self.mapHere.remove(mapObject: r)
            }
            layerRoute1.removeAll()
        }
        if (layerRoute2.count != 0) {
                   for r in layerRoute2 {
                       self.mapHere.remove(mapObject: r)
                   }
                   layerRoute2.removeAll()
               }
        if (layerRoute3.count != 0) {
                   for r in layerRoute3 {
                       self.mapHere.remove(mapObject: r)
                   }
                   layerRoute3.removeAll()
               }
               if (layerRoute4.count != 0) {
                          for r in layerRoute4 {
                              self.mapHere.remove(mapObject: r)
                          }
                          layerRoute4.removeAll()
                      }
        print("count route segment : \(String(describing: mapRoute.route.geometry?.count))")
        let inbound = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let outbound = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        let trackPoint = mapRoute.route.geometry
        
        arrayARObject.removeAll()
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude: (trackPoint?.first!.latitude)!,
                                                      longitude: (trackPoint?.first!.longitude)!,
                                                     altitude: 0.0),
                          color: inbound,rad: Int(1.5))
        for wayPoint in trackPoint! {
            //self.createCircle(geoCoord: NMAGeoCoordinates(latitude: wayPoint.latitude,
            //                                                             longitude: wayPoint.longitude,
             //                                                            altitude: 0),
             //                                color: outbound,rad: Int(1))
            
            //self.createCircle(geoCoord: NMAGeoCoordinates(latitude: wayPoint.latitude,
            //                                              longitude: wayPoint.longitude,
            //                                              altitude: 0.0),
             //                 color: inbound,rad: Int(0.5))
      
            arrayARObject.append(NMAGeoCoordinates(latitude: wayPoint.latitude, longitude: wayPoint.longitude, altitude: 0))
        }
        for i in 0...arrayARObject.count - 2 {
            newArrayAR += self.seperateRoute(startPoint: arrayARObject[i], endPoint: arrayARObject[i + 1])
        }
        arrayARObject = newArrayAR
        
        let colorRHere = #colorLiteral(red: 0.07352335196, green: 0.7233391637, blue: 0.1283224309, alpha: 1)
        let objectRoute = self.addDash(route: trackPoint, color: colorRHere)
        let distanceRoute = self.distanceInRoute(trackPoint)
        
        layerRoute1 = objectRoute.0
        layerRoute2 = objectRoute.1
        self.mapHere.add(mapObjects: layerRoute1)
        self.mapHere.add(mapObjects: layerRoute2)
        self.mapRouts.append(mapRoute)
        self.mapHere.set(boundingBox: box, animation: NMAMapAnimation.linear)
        self.showDialog(title: "Distance", message: "\(distanceRoute)")
        //NMAMapRoute(route)
        print("computed mapRoute:\(String(describing: mapRoute.route.waypoints?.count))")
        //self.mapHere.add(mapObject: mapRoute)
    })
    self.updateMapRoute(with: routeNav)
    self.startNavigation()

}
    func seperateRoute(startPoint : NMAGeoCoordinates,endPoint : NMAGeoCoordinates) -> [NMAGeoCoordinates]{
        var newAR = [NMAGeoCoordinates]()
        var distance = bridge.distanceGeo(pointA: startPoint, pointB: endPoint)
           distance = Double(round(1000*distance)/1000)
        var countSegment = distance/5
        print(Int(countSegment))
        newAR.append(startPoint)
        let deltaLat = (endPoint.latitude - startPoint.latitude)/countSegment
        let deltaLot = (endPoint.longitude - startPoint.longitude)/countSegment
        if Int(countSegment) > 1 {
            for i in 0...Int(countSegment) - 1 {
                     var j = 1
                     var newPoint = NMAGeoCoordinates(latitude: deltaLat*Double(i + 1)+startPoint.latitude, longitude: deltaLot*Double(i + 1)+startPoint.longitude)
                         //coordinate(lat: deltaLat*Double(i)+startPoint.lat, lon: deltaLot*Double(i)+startPoint.lon)
                     newAR.append(newPoint)
                 }
        } else {
            newAR.append(startPoint)
         //   newAR.append(endPoint)
        }
        return newAR
    }
    func addDash(route : [NMAGeoCoordinates]?, color : UIColor) -> ([NMAMapPolyline],[NMAMapPolyline]) {
        var arrayLayer1 = [NMAMapPolyline]()
        var arrayLayer2 = [NMAMapPolyline]()
        let middleColor = color
        let newSize = route!.count
                   for j in 0...newSize - 1 {
                       var array = [NMAGeoCoordinates]()
                  
                    if j < newSize - 1 {
                        array.append(route![j])
                        array.append(route![j+1])
                        let indexArray = self.LineRoute(array, middleColor, "Normal")
                                                             arrayLayer1.append(indexArray[0])
                                                             arrayLayer2.append(indexArray[1])
                    }
               
                       /*if j % 2 == 0 && j < newSize - 1  {
                           array.append(route![j])
                           array.append(route![j+1])
                           let indexArray = self.LineRoute(array, middleColor, "Normal")
                        arrayLayer1.append(indexArray[0])
                        arrayLayer2.append(indexArray[1])
                        } */
        }
        return (arrayLayer1,arrayLayer2)
    }
    /*
    let size = tempArray.count
               if size > 1 {
                   let fCoordLat = tempArray[size - 2].latitude
                   let eCoordLat = tempArray[size - 1].latitude
                   let fCoordLot = tempArray[size - 2].longitude
                   let eCoordLot = tempArray[size - 1].longitude
                   let deltaLat = (eCoordLat - fCoordLat)/10
                   let deltaLot = (eCoordLot - fCoordLot)/10
                   for i in 1...9 {
                       var cgeo = NMAGeoCoordinates(latitude: deltaLat*Double(i)+fCoordLat, longitude: deltaLot*Double(i)+fCoordLot, altitude: 10)
                       self.createCircle(geoCoord: cgeo, color: middleColor, rad: Int(1.5))
                       tempArray.insert(cgeo, at: tempArray.index(before: size - 1))
                       }
                   var newSize = tempArray.count
                   for j in 0...newSize - 1 {
                       var array = [NMAGeoCoordinates]()
                       if j % 2 == 0 && j != 10 {
                           array.append(tempArray[j])
                           array.append(tempArray[j+1])
                           LineRoute(array, pointColor, "Normal")
                       }
                   }*/
   
    
    open func distanceInRoute(_ routeIn : [NMAGeoCoordinates]?) -> Double {
        var allDistance = 0.0
        let segment = routeIn!.count
        for i in 0...segment - 2 {
            allDistance += distanceGeo(pointA: routeIn![i], pointB: routeIn![i + 1])
        }
        return allDistance
    }
    private func showDialog(title: String, message: String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alertController, animated: true, completion: nil)
       }
    @IBAction func clearMap(_ sender: UIButton) {
        // remove all routes from mapView.
        for route in mapRouts {
            self.mapHere.remove(mapObject: route)
        }
        route.removeAll()
        //self.mapHere.zoomLevel = 10
    }
}
