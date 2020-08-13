//
//  IntersectionCircle.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 26.05.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
import UIKit
//
// MARK extension ViewController - IntersectionCircle
//
enum stateCircle {
    case equalcircle
    case nonintersection
    case intersection
}
extension ViewController {
    //
    // MARK Method - findIntersection
    //
    public func findIntersectionOfCircle () {
        //
        // MARK variables
        //
        let colorPointC1 = #colorLiteral(red: 0, green: 0.7065169392, blue: 0.02451834161, alpha: 0.25)
        let colorPointC2 = #colorLiteral(red: 0.8426660441, green: 0.8738380208, blue: 0, alpha: 0.25)
        let interSecColor = #colorLiteral(red: 0.5, green: 0.08908936289, blue: 0.1093035199, alpha: 0.3674900968)
        let lineinterc = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        let tempP = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        //
        // MARK Call UserMethods - Draw Circle & Line Beetween two circle
        //
        // init 1 circle
        let circle1 = circle(id: 1, radius: 30.0, centr: NMAGeoCoordinates(latitude: 55.791065, longitude: 38.438890))
        // init 2 circle
        let circle2 = circle(id: 2, radius: 50.0, centr: NMAGeoCoordinates(latitude: 55.790375, longitude: 38.438957))
        
        print("circle - 1 \(circle1)")
        print("circle - 2 \(circle2)")
        //
        // MARK Draw Circle&Line
        //
        self.createCircle(geoCoord: circle1.centr,color: colorPointC1,rad: Int(circle1.radius))
        self.createCircle(geoCoord: circle2.centr,color: colorPointC2,rad: Int(circle2.radius))
        self.createPolyline(CTR: [circle1.centr,circle2.centr], lineinterc, 2, isShow: true)
        
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude: 55.790822521458686, longitude:  38.43900957613043), color: tempP, rad: 2)
        //
        //
        // MARK Calculate distance between centres of circle 1 & circle 2
        //
        var d =  distanceGeo(pointA: circle1.centr, pointB: circle2.centr)  // round(km*1000)/1000
        d = Double(round(1000*d)/1000)
        let c1r = circle1.radius
        let c2r = circle2.radius
        let m = c1r + c2r;
        var n = c1r - c2r;
        if (n < 0) { n = n * -1;}
        //No solns
        if (d > m) {return}
        //Circle are contained within each other
        if (d < n) {return}
        //Circles are the same
        if (d == 0 && c1r == c2r) {return}
        //Solve for a
        var b = ( c2r * c2r - c1r * c1r + d * d)/(2 * d)
        var a = d - b
        print("d1 = \(d)")
        print("d2 = \(a + b)")
        //Solve for h
        a = Double(round(1000*a)/1000)
        b = Double(round(1000*b)/1000)
        var h1 = sqrt(c1r*c1r - a*a)//pow((c1r*c1r-a*a),0.5)
        var h2 = sqrt(c2r*c2r - b*b)//pow((c1r*c1r-a*a),0.5)
        //Calculate point p, where the line through the circle intersection points crosses the line between the circle centers.
        h1 = Double(round(1000*h1)/1000)
        h2 = Double(round(1000*h2)/1000)
        let subV1 = 1.0//(2*Double.pi*6371000*cos(circle1.centr.latitude))/360
        let subV2 = 1.0//(2*Double.pi*6371000)/360
        let p = NMAGeoCoordinates()
        var deltaD = a/d
            deltaD = Double(round(1000*deltaD)/1000)
        p.latitude =
            circle1.centr.latitude+(deltaD)*((circle2.centr.latitude-circle1.centr.latitude))//*subV2)
        p.longitude =
            circle1.centr.longitude+(deltaD)*((circle2.centr.longitude-circle1.centr.longitude))//*subV1)
        self.createCircle(geoCoord: p,color: tempP,rad: Int(1))
        //1 soln , circles are touching
        if (d==c1r + c2r) {return}
        //2solns
       let p1 = NMAGeoCoordinates()
       let p2 = NMAGeoCoordinates()
       var deltaH = h1/d
            deltaH = Double(round(1000*deltaH)/1000)
        p1.latitude =
            p.latitude+(deltaH)*((circle2.centr.longitude-circle1.centr.longitude))//*subV1)
        p1.longitude =
            p.longitude+(deltaH)*((circle2.centr.latitude-circle1.centr.latitude))//*subV2)
        
        //
        p2.latitude =
            p.latitude-(deltaH)*((circle2.centr.longitude-circle1.centr.longitude)/**subV1*/)
        p2.longitude =
            p.longitude+(deltaH)*((circle2.centr.latitude-circle1.centr.latitude)/**subV2*/)
        self.createCircle(geoCoord: p1,color: interSecColor,rad: Int(1))
        //self.createCircle(geoCoord: p2,color: interSecColor,rad: Int(1))
    }
}
