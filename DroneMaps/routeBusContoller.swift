import UIKit
import NMAKit
import CoreTelephony
import CoreML
import AVFoundation

extension ViewController {
    
   public func distanceGeo(pointA : NMAGeoCoordinates,pointB : NMAGeoCoordinates) -> Double {
       let toRad = Double.pi/180
       let radial = acos(sin(pointA.latitude*toRad)*sin(pointB.latitude*toRad) + cos(pointA.latitude*toRad)*cos(pointB.latitude*toRad)*cos((pointA.longitude - pointB.longitude)*toRad))
       let R = 6378.137//6371.11
       let D = (radial*R)*1000
       return D
   }
    public func findDirection(_ startPoint : NMAGeoCoordinates, _ aizmutDirection : Double) -> NMAGeoCoordinates {
        let deltaLat = cos(aizmutDirection)
        let deltaLon = sin(aizmutDirection)
        let direction = [deltaLat,deltaLon]
        let fromLat = startPoint.latitude
        let fromLon = startPoint.longitude
        let endPoint = NMAGeoCoordinates(latitude: fromLat + deltaLat, longitude: fromLon + deltaLon,altitude : 20)
        return endPoint
    }
    public func firstGeoTask(_ firstPoint : NMAGeoCoordinates, _ deltaMetr : Double, _ directionRotate : Double) -> NMAGeoCoordinates {
        let toRad = Double.pi/180
        let Re = 6371000
        let deltaX = deltaMetr * cos(directionRotate*toRad)/(Double(Re)*toRad)
        let deltaY = deltaMetr * sin(directionRotate*toRad)/cos(firstPoint.latitude*toRad)/(Double(Re)*toRad)
        let newX = firstPoint.latitude + deltaX
        let newY = firstPoint.longitude + deltaY
        let secondPoint = NMAGeoCoordinates(latitude: newX, longitude: newY)
        return secondPoint
    }
}
