//
//  ARSceneController.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22/03/2020.
//  Copyright © 2019 Артем Стратиенко. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import NMAKit
import Foundation

    // MARK variables
    var manualPosition = NMAGeoCoordinates(latitude: 55.790607665738925, longitude:  38.43919700016806)
    var bridge = ViewController()
    var movingNow = false
    var hereLogo = SCNNode()
    var statusMode : String!
    var timeTrackingArPosition = Timer()
    var currentPosMap : NMAGeoCoordinates?
    var arrayVector = [SCNVector3]()
    var printDiff = [String:[Double]]()
    var arrayoffset = [Double]()
    // propertys for check point
    var pointXColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    var testXPoint : NMAGeoCoordinates?
    var testYPoint : NMAGeoCoordinates?
    var arrayColisionPoint = [NMAGeoCoordinates]()


class ARSceneController: UIViewController, ARSCNViewDelegate {
    // log info scene
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var scenePosition: UILabel!
    @IBOutlet var worldPosition: UILabel!
    @IBOutlet var geoPosition: UILabel!
    @IBOutlet var offsetPosition: UILabel!
    @IBOutlet var nodePosition: UILabel!
    @IBOutlet var offsetInScene: UILabel!
    @IBOutlet var offsetInSceneNode: UILabel!
    @IBOutlet var nodePositionWorld: UILabel!
    @IBOutlet var worldCoordinate: UILabel!
    @IBOutlet var positionInMap: UILabel!
    @IBOutlet var segmentRoute: UILabel!
    @IBOutlet weak var heightFround: UILabel!
    // slider value update property
    @IBOutlet weak var SliderAltitude: UISlider!
    @IBOutlet weak var AltitiudeValue: UILabel!
    @IBOutlet weak var SliderDirection: UISlider!
    @IBOutlet weak var DirectionValue: UILabel!
    // slider update property
    @IBOutlet weak var SliderBearing: UISlider!
    @IBOutlet weak var BearingValue: UILabel!
    @IBOutlet weak var isBearing: UILabel!
    @IBOutlet weak var isDirection: UILabel!
    // uiSwitch
    @IBOutlet weak var startDrawAR: UISwitch!
    // drone object
    var parrotNode: SCNNode!
    var roterNode: SCNNode!
    var propellerNode : SCNNode!
    //
    var planePoint : CGPoint!
    var groundHeight : CGFloat! = 0.0
    //
    let configuration = ARWorldTrackingConfiguration()
        override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        planePoint = CGPoint(x: view.center.x, y: view.center.y)
        sceneView.debugOptions = [.showFeaturePoints]
        // Create a session configuration
        configuration.worldAlignment = .gravityAndHeading
        self.initDetection()
     // self.loadModels()
     // self.addPlane()
     // self.trackingTimerAR()
        // Set the view's delegate
     // sceneView.delegate = self
        print("running vieDidLoad ============================")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("running viewWillAppear ============================")
    }
    /// MARK 1 Section IBAction
    // Draw Object in Map's and Scene (ARKit)
    @IBAction func setDirection(_ sender: Any) {
        isBearing.text = "-1"
    }
    @IBAction func setBearing(_ sender: Any) {
        isDirection.text = "-1"
    }
    @IBAction func showAltitude(_ sender: Any) {
        self.AltitiudeValue.text = "\(SliderAltitude.value)"
    }
    @IBAction func showDirection(_ sender: Any) {
        self.DirectionValue.text = "\(SliderDirection.value)"
    }
    @IBAction func showBearing(_ sender: Any) {
        self.BearingValue.text = "\(SliderBearing.value)"
    }
    @IBAction func currPos(_ sender: Any) {
        self.changeCurrentPosition()
    }
    @IBAction func addButton(_ sender: UIButton) {
        // remove scene
       self.addObjectAR()
    }
    @IBAction func CloseARScene(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("Dismiss")
    }
   
      // start show object
    @IBAction func startShowARobject(_ sender: Any) {
        self.addObjectAR()
          //self.trackingTimerAR()
          //self.deinitDetection()
    }
    @IBAction func gravity(_ sender: Any) {
        statusMode = "state 1"
    }
    @IBAction func gravityandHeading(_ sender: Any) {
        statusMode = "state 2"
    }
    @IBAction func camera(_ sender: Any) {
        statusMode = "state 3"
    }
    @IBAction func startDrawARState (_ sender: Any) {
        if startDrawAR.isOn {
            self.deinitDetection()
            self.trackingTimerARStart()
        } else {
            self.trackingTimerARStop()
        }
    }
    /// MARK 3 @objc func
    @objc func addObjectAR() {
        /// mark update drone
        // self.updateDrone()
        // self.findhereLogo()
        // self.sofa(position: SCNVector3(0,0, 4))
        var index = 0
        // arrayVector.append(SCNVector3(0,-Float(groundHeight),0))
        if arrayARObject.count > 0 {
            self.reset()
        //  draw
        //    arrayVector.append(SCNVector3(0, 0, 0))
            for object in arrayARObject {
                painItemAR(object,index)
                index += 1
            }
            if arrayVector.count > 1 {
                let size = arrayVector.count
                self.segmentRoute.text = "route seg : \(String(describing: size - 1))"
                for i in 0...size - 1 {
                if i != size - 1{
                    draw3DLine(arrayVector[i], arrayVector[i+1])
                    }
                }
            }
        }
        print(printDiff)
        print(arrayoffset)
}
    @objc func dragObject(sender: UIPanGestureRecognizer) {
      if(movingNow){
              let translation = sender.translation(in: sender.view!)
              let result : SCNVector3 = CGPointToSCNVector3(view: sceneView,
                                                            depth: hereLogo.position.z,
                                                            point: translation)
              hereLogo.position = result
          } else {
              // view is the view containing the sceneView
              let hitResults = sceneView.hitTest(sender.location(in: view),
                                                 options: nil)
              if hitResults.count > 0 {
                  movingNow = true
              }
          }
      }
/// MARK 4 timer()
    func trackingTimerARStart() {
        timeTrackingArPosition.invalidate()
        timeTrackingArPosition = Timer.scheduledTimer(timeInterval: 0.9,
                                                      target: self,
                                                      selector: "addObjectAR",
                                                      userInfo: nil,
                                                      repeats: true)
    }
    func trackingTimerARStop() {
        timeTrackingArPosition.invalidate()
    }
//###
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trackingTimerARStop()
        // Pause the view's session
        currentPosMap = nil
        sceneView.session.pause()
        sceneView.removeFromSuperview()
        sceneView = nil
        pointXColor =  #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        DispatchQueue.global(qos: .background).async {
           
        }
        print("running viewWillDisappear ============================")
    }
}

extension ARSceneController {
    /// MARK 1 Init
    func initDetection() {
        configuration.planeDetection = .horizontal // vertical detection
        //sceneView.debugOptions = [.showPhysicsShapes]
        sceneView.session.run(configuration)
    }
    /// MARK 2 DeInit
    func deinitDetection() {
        //sceneView.session.pause()
        configuration.planeDetection = []//.horizontal // vertical detection
        sceneView.debugOptions = [.showPhysicsShapes]
        sceneView.session.run(configuration)
    }
    /// MARK 3 posInScene
    func getPositionInScene() -> SCNVector3! {
        let pos = sceneView.pointOfView!.position
        let posW = sceneView.pointOfView!.worldPosition
        self.scenePosition.text = "scene pos - \(pos)"
        self.worldPosition.text = "world pos - \(posW)"
        // scene.pointOfView.worldPosition
        return pos
    }
  /// MARK 4  posInMap
    func getPositionInMap() -> NMAGeoCoordinates! {
        let pos = NMAPositioningManager.sharedInstance().currentPosition
        let cord = pos?.coordinates
        let lat = cord?.latitude
        let lon = cord?.longitude
        self.geoPosition.text = "geo pos: - \(lat!) : \(lon!)"
        return pos?.coordinates
    }
 /// MARK 5 updatePositionManual
    func changeCurrentPosition() {
        currentPosMap = getPositionInMap()
    }
}

/// MARK 4 extension computed offset and draw
extension ARSceneController {
    
    func painItemAR(_ posDraw : NMAGeoCoordinates?,_ index : Int) {
            self.changeCurrentPosition()
            let currentPosScene = getPositionInScene()
            if  currentPosMap == nil {
                currentPosMap = manualPosition//getPositionInMap()
            }
            self.positionInMap.text = "position in map: \(currentPosMap?.latitude) : \(currentPosMap?.longitude)"
            let offsetMeters = bridge.distanceGeo(pointA: currentPosMap!, pointB: posDraw!)
            arrayoffset.append(offsetMeters)
            self.offsetPosition.text = "offset - \(offsetMeters) метров"
            let delta = offsetComplete(currentPosMap!, posDraw!)
            // test compute new coordinate
            // deltaX = offsetMeters*cos(45*Double.pi/180)/(6371000*Double.pi/180)
            // deltaZ=offsetMeters*sin(45*Double.pi/180)/cos(currentPosMap!.latitude*Double.pi/180)/(6371000*Double.pi/180)
            let sphere = SCNSphere(radius: 0.5)
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "way_3d.png")
            sphere.materials = [material]
            let node = SCNNode()
            node.geometry = sphere
            printDiff["\(index)"] = delta
            node.position = SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) + SliderBearing.value,SliderAltitude.value + 0 - Float(groundHeight) ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 + SliderDirection.value)
            arrayVector.append(node.position)
            self.nodePosition.text = "node ims - \(node.position)"
            self.nodePositionWorld.text = "node world - \(node.presentation.worldPosition)"
            self.offsetInScene.text = "offset scene - \(delta[0]) : \(delta[1])"
            let node1Pos = currentPosScene
            let node2Pos = node.position//node.presentation.worldPosition
            let distanceNode = SCNVector3(
                node2Pos.x - node1Pos!.x,
                node2Pos.y - node1Pos!.y,
                node2Pos.z - node1Pos!.z
            )
            let way = distanceNode.length()
            self.addLabel(SCNVector3(x : node.position.x,y : node.position.y + 5,z :node.position.z),"id : \(index)\n D :\(way) ")
            self.offsetInSceneNode.text = "offset node - \(way)"
            // self.lineAR(node1Pos!,node2Pos)
            node.name = "pointAR"
            sceneView.scene.rootNode.addChildNode(node)
        }
    
        // func computed offset for new coordinate
        func offsetComplete(_ pointStart : NMAGeoCoordinates, _ pointEnd : NMAGeoCoordinates) -> [Double] {
            let toRadian = Double.pi/180
            let toDegress = 180/Double.pi
            var deltaX = Double()
            var deltaZ = Double()
            var offset = [Double]()
            let defLat = (2*Double.pi * 6378.137)/360
            let defLot = (2*Double.pi*6378.137*cos(pointStart.latitude*toRadian))/360//*toDegress
                if pointStart != nil {
                    if pointEnd != nil {
                        deltaX = (pointEnd.longitude - pointStart.longitude)*defLot*1000//*toDegress
                        deltaZ = (pointEnd.latitude - pointStart.latitude)*defLat*1000//*toDegress
                        
                        var lon = (pointStart.longitude*defLot/*1000*/ + deltaX)/defLot/*1000*///*toDegress
                        var lat = (pointStart.latitude*defLat + deltaZ)/defLat//*toDegress
                        //
                         //   if deltaZ < 0 {
                          //     // deltaZ = -deltaZ}
                         //   else {
                               // deltaZ = -deltaZ
                         //   }
                        print("\(pointEnd.longitude - pointStart.longitude)")
                        print("\(pointEnd.latitude - pointStart.latitude)")
          
            let pointXColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            let defX = 360/(2*Double.pi*6378.137*cos(pointStart.latitude*toRadian))
            let defY = 360/(2*Double.pi * 6378.137)
            //
            testXPoint = pointStart//bridge.firstGeoTask(pointStart, deltaX, 0)
            //
            testYPoint = NMAGeoCoordinates(latitude: lat, longitude: lon)//bridge.firstGeoTask(pointEnd, deltaZ, deltaX)
            arrayColisionPoint.append(testYPoint!)
            //
            /*testXPoint = NMAGeoCoordinates(
                latitude: pointStart.latitude/*+ (pointEnd.latitude - pointStart.latitude)*/,
                longitude: pointStart.longitude/* + (pointEnd.longitude - pointStart.longitude)*/) */
            // test add compute point
            print("new coord : [\(testXPoint)]")
            print("end coord : [\(pointEnd)]")
                                    }
                                }
            offset.append(deltaX)
            offset.append(deltaZ)
        return offset
    }
     // reset
        func reset() {
            //sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "pointAR" /*|| node.name == "line" */|| node.name == "labelAR" || node.name == "routeAR" {
                node.removeFromParentNode()
            }}
            self.worldCoordinate.text = "world system : \(statusMode)"
            if arrayVector != nil {        arrayVector.removeAll()}
           /* if statusMode == "state 1" {
                configuration.worldAlignment = .camera
            } else if statusMode == "state 2" {
                configuration.worldAlignment = .gravityAndHeading
            } else if statusMode == "state 3"  {
                configuration.worldAlignment = .gravity
            }
            //configuration.worldAlignment = .gravityAndHeading
            sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showCameras,ARSCNDebugOptions.showBoundingBoxes]
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors]) */
            }

}

