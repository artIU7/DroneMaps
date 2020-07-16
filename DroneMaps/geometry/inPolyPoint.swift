//
//  inPolyPoint.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
extension ViewController {

struct dec_point {
    var status = Bool()
    var id_obj = Int()
}
public func ckeckPoint(checkPoint : NMAGeoCoordinates) -> dec_point! {
    var status_id = dec_point()
    //print("size arrayOBJ : = \(arrayObjSelect) + and count \(arrayObjSelect.count)")
   // arrayObjSelect.remove(at: 0)
    if arrayObjSelect.count > 0 {
       //var tempp = arrayObjSelect[0] as! objectSelectedUsers
       //print(tempp)
        //if tempp.id != 0
        //{
        for i in 1...arrayObjSelect.count - 1 {
            let arg = arrayObjSelect[i] as! objectSelectedUsers
            //print(arg)
            let obArray = self.NMAGeoToDoubleArray(arrayHere: arg.frame)
                var indoorpoly = self.pnpoly(arg.frame.count, obArray.pointX, obArray.pointY, checkPoint.latitude, checkPoint.longitude)
            if indoorpoly == true {
                print("point is poly - \(indoorpoly) id object : \(arg.id)")
                status_id.status = indoorpoly
                status_id.id_obj = arg.id
                print("=============000000000000==========\(status_id)")
                } else {
                //print("point is poly - \(indoorpoly) id object : _")
            }
        }
    //}// else {
    //arrayObjSelect.remove(at: 0)
//}
} else {
    
//var obS = self.NMAGeoToDoubleArray(arrayHere: areCheking)
//var indoorpoly = self.pnpoly(areCheking.count - 1, obS.pointX, obS.pointY, checkPoint.latitude, checkPoint.longitude)
 //      print(indoorpoly)
  //  Carrier.text = "Point is : \(indoorpoly) - touch ID :\(self.index_touch)"
    self.index_touch += 1
   // status_id.status = indoorpoly
  //  status_id.id_obj = self.index_touch
    }
    print("==========111111111111111111111==========\(status_id)")
    return status_id
}
}
