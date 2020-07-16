//
//  extension+mapGesture.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 07.05.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import UIKit
import NMAKit
import CoreTelephony
import CoreML
import AVFoundation

extension ViewController : NMAMapGestureDelegate {
    // add touch in map and draw rote to point
    func mapView(_ mapView: NMAMapView, didReceiveLongPressAt location: CGPoint) {
   //     print("location :\(String(describing: mapView.geoCoordinates(from: location)))")
        if detected != "Delete" {
        let alert = UIAlertController(title: "location", message: "\(String(describing: mapView.geoCoordinates(from: location)))", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Построить маршрут", style: .default) { (_) -> Void in
            let latLocal = mapView.geoCoordinates(from: location)!.latitude
            let lonLocal = mapView.geoCoordinates(from: location)!.longitude
            self.route.append(NMAGeoCoordinates(latitude: latLocal, longitude: lonLocal))
            //self.zoneObject(id: self.index_placed, geo: NMAGeoCoordinates(latitude: latLocal, longitude: lonLocal,altitude: 1), type: "home-button-for-interface 1.png")
           // print(self.route)
            //mapView.onMapObjectSelected(latLocal, lonLocal)
            self.routeChild((Any).self)
            self.index_placed += 1
        }
            let deleteAction = UIAlertAction(title: "Удалить обьекты", style: .default) { (_) -> Void in
                let getObject = self.mapHere.objects(at: location)
                print("get object : \(getObject)")
                if getObject != [] {
                    print("delete \(getObject)")
                mapView.remove(mapObjects: getObject as! [NMAMapObject])
            }
        }
        let canceledAction = UIAlertAction(title: "Отменить", style: .cancel) {
            (_) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(canceledAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    } //
        else {
            let getObject = mapHere.objects(at: location)
                   print("get object : \(getObject)")
                   if getObject != [] {
                       print("delete \(getObject)")
                    //getObject.removeAll()
                    mapView.remove(mapObjects: getObject as! [NMAMapObject])
                   }
        }
    }
    //
    //
    func drone(_ positionBus : NMAGeoCoordinates, _ routes : routes) -> NMAMapMarker {
        let drone = NMAMapMarker(geoCoordinates:  positionBus/*NMAGeoCoordinates(latitude: 55.79061793745191, longitude: 38.4369134902954)*/, image: drone_ui!)
   //     drone.setSize(CGSize(width: 40, height: 40), forZoomLevel: UInt(15))
      //  drone.setSize(CGSize(width: 10, height: 10), forZoomRange: NSRange(location: 5,length: 20))
        drone.resetIconSize()
        drone.setSize(CGSize(width: 10, height: 10), forZoomRange: NSRange(location: 5,length: 20))
        let id = Int(drone.uniqueId())
        var obj = drone_(id: id, stop: testStops, route: routes, coordinate: positionBus)
        print(obj)
        arrayBus.append(obj)
        self.mapHere.add(mapObject: drone)
        return drone
    }
    func clear_drone(_ object :NMAMapMarker) {
        mapHere.remove(mapObject: object)
    }
    //
    // MARK Draw route drone
    func routeBusDraw() {
    var lineType = typeLine.dash
    for objStructArray in arrayBus {
        let bRoute = #colorLiteral(red: 0.8549019608, green: 0.6769049658, blue: 0.8281600022, alpha: 0.75)
        let polyArray = self.LineRoute(objStructArray.route.coordinates, bRoute, lineType.rawValue)
        let polys = poly_struct(id : objStructArray.id,poly : polyArray)
        arrayPolys.append(polys)
        polys.poly[0].isVisible = false
        polys.poly[1].isVisible = false
    }
}
    func mapView(_ mapView: NMAMapView, didReceiveTapAt location: CGPoint) {
        
        guard let pTemp = self.ckeckPoint(checkPoint: mapView.geoCoordinates(from: location)!) else {return}
        print("\(pTemp) - ptmp")
        polyDetec.text! = "\(pTemp.id_obj) - \(pTemp.status)"
        //
       
            let objStruct = mapHere.objects(at: location)
            print("get object : \(objStruct)")
            if objStruct != [] {
                print(objStruct)
                for get in objStruct {
                        guard let mark = get as? NMAMapMarker else {return}
                        for objStructArray in arrayBus {
                        print(objStructArray.id)
                        print(Int(mark.uniqueId()))
                        if Int(mark.uniqueId()) == objStructArray.id  {
                            for pol in arrayPolys {
                                print(pol.id)
                                print(objStructArray.id)
                                print("stop")
                                if pol.id == objStructArray.id {
                                    pol.poly[0].isVisible = true
                                    pol.poly[1].isVisible = true
                                    break
                                }// else {
                                 //   pol.poly[0].isVisible = false
                                   // pol.poly[1].isVisible = false
                               // }
                        }
                    }
                }
            }
            } else {
                for pol in arrayPolys {
                    pol.poly[0].isVisible = false
                    pol.poly[1].isVisible = false
                }
        }
    }
        
       
    // *LongPress* touch to detected point in poly
       
    func mapView(_ mapView: NMAMapView, didReceiveDoubleTapAt location: CGPoint) {
        
        var getCoordinate = mapView.geoCoordinates(from: location)
       
        if end_area == "start" && shape == "poly" {
        array_area.frame_area.append(getCoordinate!)
        
            tempArray.append(getCoordinate!)
        let pointColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        let plineColor = #colorLiteral(red: 0.8644338001, green: 0.3671671473, blue: 0.6680456927, alpha: 0.653884243)
        let middleColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        self.createCircle(geoCoord: getCoordinate!, color: pointColor, rad: 2)
       //line self.createPolyline(CTR: array_area.frame_area, plineColor, 10)
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
                }
                var lastElement = tempArray.last
                tempArray.removeAll()
                tempArray.append(lastElement!)
            }
           // let waypoint = NMAMapMarker(geoCoordinates: getCoordinate!, image: waypoint_ui!)
                                      // print("Marker coordinates : \(leftUp.coordinates)")
           // self.mapHere.add(mapObject: waypoint)
        } else if end_area == "end" && shape == "poly" {
        if array_area.frame_area != nil {
            }} else if end_area == "start" && shape == "circle" {
            let pointColorCenter = #colorLiteral(red: 0.1612316361, green: 0.3431667361, blue: 0.8644338001, alpha: 0.653884243) //colorObject
            let areaColor = #colorLiteral(red: 0.8024802703, green: 0.6241669053, blue: 0.05677067874, alpha: 0.653884243)
/*circle */
          self.createCircle(geoCoord: getCoordinate!, color: pointColorCenter, rad: 2)
          self.createCircle(geoCoord: getCoordinate!,
                  color: areaColor,rad: 500)
            let lat = getCoordinate!.latitude
            let lon = getCoordinate!.longitude
            post(url: /*"http://127.0.0.1:8080/location"*/"https://droneservice.herokuapp.com/location/", parametrs: ["lon":lon,"lat":lat])
        let colorPoint = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)
        let colorPoint_other = #colorLiteral(red: 0.7450980544, green: 0.3117482386, blue: 0.3231185398, alpha: 1)
        let Cx = getCoordinate?.latitude
        let Cy = getCoordinate?.longitude
        let radius = 100.0
        let toRad = Double.pi/180 //M_PI
        let newX = radius*cos(90.0*toRad) + Cx!
        let newY = radius*sin(90.0*toRad) + Cy!
      //  let AZIMUT = 90.0
        let Degress = [0,45,90,135,180,225,270,315,360]
        for AZIMUT in 0...360/*Degress*/ {
            if AZIMUT%5 == 0 {
                let LAT1 = Cx!+radius*cos(Double(AZIMUT) * M_PI / 180)/(6371000 * M_PI / 180)
                let LON1 = Cy!+radius*sin(Double(AZIMUT) * M_PI / 180)/cos(Cx! * M_PI / 180) / (6371000/*6371000*/ * M_PI / 180)
                let coord = NMAGeoCoordinates(latitude: LAT1, longitude: LON1)
                self.createCircle(geoCoord: coord,color: colorPoint,rad: Int(1))
                dropCircle.frame_area.append(coord)
            }
        }
        var compass = [0,90,180,270]
            for bearing in compass {
                let LAT1 = Cx!+radius*cos(Double(bearing) * M_PI / 180)/(6371000 * M_PI / 180)
                let LON1 = Cy!+radius*sin(Double(bearing) * M_PI / 180)/cos(Cx! * M_PI / 180) / (6371000/*6371000*/ * M_PI / 180)
            let pointStrip = NMAGeoCoordinates(latitude: LAT1, longitude: LON1)
            let stripBearing = [getCoordinate,pointStrip]
                 let color_N = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                 let color_E = #colorLiteral(red: 0.1529411765, green: 0, blue: 1, alpha: 1)
                 let color_S = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.2666666667, alpha: 1)
                 let color_W = #colorLiteral(red: 0.8901960784, green: 0.4784313725, blue: 0.09019607843, alpha: 1)
                 if bearing == 0 {
                    self.createPolyline(CTR: stripBearing as! [NMAGeoCoordinates], color_N, 3)} else if bearing == 90 {
                    self.createPolyline(CTR: stripBearing as! [NMAGeoCoordinates], color_E, 3)} else if bearing == 180 {
                    self.createPolyline(CTR: stripBearing as! [NMAGeoCoordinates], color_S, 3)} else if bearing == 270 {
                    self.createPolyline(CTR: stripBearing as! [NMAGeoCoordinates], color_W, 3)}
            }
            let pointSecond = self.firstGeoTask(getCoordinate!, radius + 10, 45)
            self.createCircle(geoCoord: pointSecond,color: colorPoint_other,rad: Int(1))
        objSelect.id = arrayObjSelect.count + 1
        objSelect.header = "\(objSelect.id) - zone draw"
        objSelect.frame = dropCircle.frame_area
        arrayObjSelect.append(objSelect)
        arrayObjSelect as! [objectSelectedUsers]
        self.drawLabel(getCoordinate!, objSelect.header)
        var tempDrop = [NMAGeoCoordinates]()
            for i in 0...dropCircle.frame_area.count - 1 {
           //     print(dropCircle.frame_area.count - 1)
                if i > 22 && i < 55 {
                dropCircle.frame_area[i] = NMAGeoCoordinates(latitude: 0, longitude: 0)
                }
                if dropCircle.frame_area[i].latitude == 0 && dropCircle.frame_area[i].longitude == 0 {/*dropCircle.frame_area.remove(at: i)*/
                } else {tempDrop.append(dropCircle.frame_area[i])}
            }
        print("= = = \n \(dropCircle.frame_area)")
        let color_F = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
        let color_L = #colorLiteral(red: 0.1529411765, green: 0, blue: 1, alpha: 1)
        self.drawPolygonInMap(tempDrop,color_F,color_L)
        dropCircle.frame_area.removeAll()
        } else {
        offsetPoint = getCoordinate!
            if offsetPoint != nil {
                let colorObject = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) //
                arrayObj["latitude"] = offsetPoint!.latitude as Double
                arrayObj["longitude"] = offsetPoint!.longitude as Double
                arrayObj["cellor"] = obj.cellor
                piplInePoint.append(arrayObj)
                self.createCircle(geoCoord: offsetPoint!,color: colorObject,rad: Int(1))
                arrayARObject.append(offsetPoint!)
                offsetPoint = NMAGeoCoordinates(latitude: offsetPoint!.latitude, longitude: offsetPoint!.longitude, altitude: 10)
                let movePoint = self.findDirection(offsetPoint!,45)
                let vectorDirection = [offsetPoint,movePoint]
                //self.createPolyline(CTR: vectorDirection as! [NMAGeoCoordinates])
                print(vectorDirection)
                print(arrayARObject)
            }
        }
     //   self.mapHere.set(geoCenter: NMAGeoCoordinates(latitude: newX, longitude: newY), zoomLevel: 10, orientation: 35, tilt: 0, animation: .none)
    
}
    func mapView(_ mapView: NMAMapView, didReceiveTwoFingerTapAt location: CGPoint) {
        let getObject = mapHere.objects(at: location)
        print("get object : \(getObject)")
        if getObject != [] {
            print("delete \(getObject)")
        }
    }
    // *LongPress* touch to detected point in poly
/*    func mapView(_ mapView: NMAMapView, didReceivePan translation: CGPoint, at location: CGPoint) {
        if panDrawLine == "Activate" {
        let getObjectNorm = mapView.geoCoordinates(from: location)
        //let getObjectPan = mapView.geoCoordinates(from: translation)
        nonSPL.append(getObjectNorm!)
            self.LineRoute(nonSPL, #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        }
    } */
}
