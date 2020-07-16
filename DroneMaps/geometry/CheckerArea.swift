//
//  CheckerArea.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
// draw area for user's poi
extension ViewController {
       public func zoneObject(id : Int, geo : NMAGeoCoordinates, type : String) {
           //arrayObjSelect
           objSelect = objectSelectedUsers()
            /*1*/
            let polyFrame = drawRectwith(centrBox: geo, 0.005)
            polyFrame.polyGon.map{mapHere.add(mapObject: $0)}
            boxik = polyFrame.polyBox
            objSelect.id = id
              // ***
              let leftUp = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: (boxik?.topLeft.latitude)!, longitude:
                  (boxik?.topLeft.longitude)!,altitude: 1), image: LeftUp!)
              // print("Marker coordinates : \(leftUp.coordinates)")
               self.mapHere.add(mapObject: leftUp)
              //*
               let rightUp = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: (boxik?.topRight.latitude)!, longitude: (boxik?.topRight.longitude)!,altitude: 1), image: RightUp!)
              self.mapHere.add(mapObject: rightUp)
              //*
               let rightDown = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: (boxik?.bottomRight.latitude)!, longitude: (boxik?.bottomRight.longitude)!,altitude: 1), image: RightDown!)
               self.mapHere.add(mapObject: rightDown)
              //*
               let leftDown = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: (boxik?.bottomLeft.latitude)!, longitude: (boxik?.bottomLeft.longitude)!,altitude: 1), image: LeftDown!)
              self.mapHere.add(mapObject: leftDown)
               // sub cluster
               let frame_cluster = NMAClusterLayer()
               frame_cluster.addMarkers([leftUp,rightUp,rightDown,leftDown])
               self.mapHere.add(clusterLayer: frame_cluster)
                        //boxik!.topLeft.altitude = 10
        /*2*/   //
        var arrayAny = [NMAGeoCoordinates]()
        arrayAny.append(leftUp.coordinates)
        //
        arrayAny.append(rightUp.coordinates)
        //
        arrayAny.append(rightDown.coordinates)
        //
        arrayAny.append(leftDown.coordinates)
        objSelect.frame = arrayAny
        /*3*/  //
        objSelect.header = "\(id) - POI (\(type))"
        arrayObjSelect.append(objSelect)
        arrayObjSelect as! [objectSelectedUsers]
       // self.drawLabel(geo, objSelect.header)
//        let marker = NMAMapMarker(geoCoordinates: geo, image: UIImage(named: type)!)
               coordSystemHeli.append(geo)
        let cluster = NMAClusterLayer()
//        cluster.addMarker(marker)
        self.mapHere.add(clusterLayer: cluster)
        print("struct - \(arrayObjSelect)")
        //rechangeCount()
       }
}
