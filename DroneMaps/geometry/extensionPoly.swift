//
//  extensionPoly.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit

extension ViewController {
    // main function
     public func pnpoly(_ nPoly : Int, _ polyX : [Double], _ polyY : [Double], _ x : Double, _ y : Double) -> Bool
        {
            var c : Bool = false
            for i in 0...nPoly - 1 {
                var j = nPoly - 1
                    if ((((polyY[i]<=y) && (y<polyY[j])) || ((polyY[j]<=y) && (y<polyY[i]))) &&
                        (polyY[j]-polyY[i] != 0 && x > (polyX[j] - polyX[i]) * (y - polyY[i]) / (polyY[j] - polyY[i]) + polyX[i])) {
                          c = !c;
                    }
                j += i
            }
            return c;
        }
    // sub function
    struct arrayXY {
        var pointX : [Double]
        var pointY : [Double]
        init() {
            pointX = []
            pointY = []
        }
    }
    public func NMAGeoToDoubleArray(arrayHere geo : [NMAGeoCoordinates]) -> arrayXY {
        // add temp var/let
        var obj = arrayXY()
        var tempGeo = geo
        var sizeGeo = tempGeo.count // size input array geo
        // add array temp
        var post = [Double]()
        for get in geo {
            obj.pointX.append(get.latitude)// =  get.latitude
            obj.pointY.append(get.longitude)// =  get.latitude        }
        }
        return obj
    }
    //
    struct objectSelectedUsers {
        var id = Int()
        var frame = [NMAGeoCoordinates]()
        var header = String()
    }
}
