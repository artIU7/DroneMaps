//
//  MapKitYAView.swift
//  DroneMaps
//
//  Created by  brazilec22 on 01.08.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import UIKit
//import YandexRuntime
import YandexMapKit
import YandexMapKitDirections
import YandexMapKitTransport

/**
 * This example shows how to build routes between two points and display them on the map.
 * Note: Routing API calls count towards MapKit daily usage limits. Learn more at
 * https://tech.yandex.ru/mapkit/doc/3.x/concepts/conditions-docpage/#conditions__limits
 */
var ROUTE_START_POINT = YMKPoint()
var ROUTE_END_POINT = YMKPoint()
var arrayNewRoute = [YMKPoint]()
class MapKitYAView: UIViewController {

    @IBOutlet var mapVIew: YMKMapView!
    var drivingSession: YMKDrivingSession?
    var pedestrianSession : YMKMasstransitSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.computedRoute(start: ROUTE_START_POINT, end: ROUTE_END_POINT)
        
            let CAMERA_TARGET = YMKPoint(latitude: (ROUTE_START_POINT.latitude - ROUTE_END_POINT.latitude)/2 + ROUTE_START_POINT.latitude, longitude: (ROUTE_START_POINT.longitude - ROUTE_END_POINT.longitude)/2 + ROUTE_START_POINT.longitude)//YMKPoint(latitude: 55.79059240191234, longitude: 38.44084188862678)
          
             DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
          self.mapVIew.mapWindow.map.move(with: YMKCameraPosition(target: arrayNewRoute[(arrayNewRoute.count-1)/2],
                                                                            zoom:25,
                                                                            azimuth: 0,
                                                                            tilt: 0))
        }
    }
    
    func computedRoute(start : YMKPoint, end : YMKPoint) {
      let requestPoints : [YMKRequestPoint] = [
          YMKRequestPoint(point: start, type: .waypoint, pointContext: nil),
          YMKRequestPoint(point: end, type: .waypoint, pointContext: nil),
          ]
      let pedestrianRouter = YMKTransport.sharedInstance().createPedestrianRouter()
              pedestrianSession = pedestrianRouter.requestRoutes(with: requestPoints,
                                                                 timeOptions: YMKTimeOptions(),
              routeHandler: { (routesResponse : [YMKMasstransitRoute]?, error :Error?) in
               if let routes = routesResponse {
                  print("route pedestrian \(routes.count)")
                  self.onRoutesPedestrian(routes)
               } else {
                  print("errr")
              }
          })
      }
    
    
    func onRoutesPedestrian(_ routes: [YMKMasstransitRoute]) {
        let mapObjects = mapVIew.mapWindow.map.mapObjects
        for route in routes {
            arrayNewRoute = route.geometry.points
            mapObjects.addPolyline(with: route.geometry)
        }
    }
    
    func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
