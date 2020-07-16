//
//  File.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//
import Foundation
import NMAKit

public struct objectPoint {
    var polyGon : NMAMapPolygon?
    var polyBox : NMAGeoBoundingBox?
}
var object = objectPoint()
    public func drawRectwith(centrBox : NMAGeoCoordinates, _ height : Float) -> objectPoint {
        
        var geoBoxPolygon : NMAGeoBoundingBox?
        var boxPoly : NMAMapPolygon?
        geoBoxPolygon = NMAGeoBoundingBox(center: centrBox,
                                          width: height,
                                          height: height/2)
        //create a NMAMapPolygon with bounding box's vertices.
        boxPoly = geoBoxPolygon.map { NMAMapPolygon(vertices: [$0.topLeft,
                                                               $0.bottomLeft,
                                                               $0.bottomRight,
                                                               $0.topRight]) }
        object.polyBox = geoBoxPolygon
        object.polyGon = boxPoly
        boxPoly?.fillColor = UIColor.gray
        boxPoly?.lineWidth = 1
        boxPoly?.lineColor = UIColor.red
        boxPoly?.isVisible = true
        //_ = boxPoly.map{MapView.add(mapObject: $0)}
        return object
    }
public func drawPolygonWithPoints(centrBox : [NMAGeoCoordinates],fillClr : UIColor,fillLnr : UIColor) -> NMAMapPolygon? {
    var geoBoxPolygon : NMAGeoBoundingBox?
    var boxPoly : NMAMapPolygon?
    boxPoly = NMAMapPolygon.init(vertices: centrBox)
    object.polyGon = boxPoly
    boxPoly?.fillColor = fillClr//#colorLiteral(red: 0.0202548003, green: 0.8078431373, blue: 0, alpha: 0.6264029489)
    
    boxPoly?.lineWidth = 3
    boxPoly?.lineColor = fillLnr//#colorLiteral(red: 0.1882352941, green: 0.4078431373, blue: 0.4392156863, alpha: 0.5)
    boxPoly?.isVisible = true
    return object.polyGon
}
