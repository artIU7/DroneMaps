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
import Vision

    var arrayNavigate = Navigate()
    var arrayGPS = [Coordinate]()
    var arrayAR = [Coordinate]()

    var manualPosition = NMAGeoCoordinates(latitude: 55.79059240191234, longitude:  38.44084188862678)
    var bridge = ViewController()
    var movingNow = false
    var hereLogo = SCNNode()
    var statusMode : String!
    var timeTrackingArPosition = Timer()
    var timeTrackingEstimate = Timer()
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
    
    var planeId: Int = 0
    
    private var timer = Timer()

    let currentMLModel = Inceptionv3().model
    let serialQueue = DispatchQueue(label: "com.aboveground.dispatchqueueml")
    var visionRequests = [VNRequest]()
        // MARK variables
    // log info scene
    @IBOutlet var infoML: UILabel!
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
    @IBOutlet weak var startEstimate : UISwitch!
    // drone object
    var parrotNode: SCNNode!
    var roterNode: SCNNode!
    var propellerNode : SCNNode!
    /// MARK arrow set propertys
    var allowNode : SCNNode!
    var infoNode : SCNNode!
    var circleNode : SCNNode!
    var followRoot : SCNNode!
    var followNode : SCNNode!
    var followRootGreen : SCNNode!
    var sceneGeometry : SCNNode!
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
        configuration.isLightEstimationEnabled = true

        // Create a session configuration
        configuration.worldAlignment = .gravityAndHeading
        self.initDetection()
      //  self.loadStandartGeometry(SCNVector3(x: 0, y: 0, z: 0), name: "Geometry")
            
        //self.loadModels()
   //     self.addPlane(content: arImage, place: SCNVector3(10, -5, 0))
   //     self.addPlane(content: googleImage, place: SCNVector3(10, 5, 0))
        // self.trackingTimerAR()
        // Set the view's delegate
        // sceneView.delegate = self
        self.initTap()
            DispatchQueue.main.async {
                /*self.ringCheck(SCNVector3(0,2,0), name: "test ring 1")
                self.ringCheck(SCNVector3(0,0,0), name: "test ring 3")
                self.ringCheck(SCNVector3(0,-2,0), name: "test ring 2")*/
            }
        //self.addInfo()
        print("running vieDidLoad ============================")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCoreML()
        //startML()
        print("running viewWillAppear ============================")
    }
    /// ML
    func startML() {
         timer.invalidate()
         timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loopCoreMLUpdate), userInfo: nil, repeats: true)
    }
    func stopML() {
        timer.invalidate()
    }
    ///
    ///
   
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
        manualPosition = arrayARObject.first!
       // manualPosition = //arrayARObject.first!
        currentPosMap = manualPosition
        self.geoPosition.text = "geo pos: - \(manualPosition.latitude) : \(manualPosition.longitude)"

        //self.changeCurrentPosition()
    }
    @IBAction func addButton(_ sender: UIButton) {
        // remove scene
       self.addObjectAR()
       self.startNavigate()
    }
    @IBAction func CloseARScene(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("Dismiss")
    }
   
      // start show object
    @IBAction func startShowARobject(_ sender: Any) {
        showHide()
        //self.addObjectAR()
        //self.startML()
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
            
            let pos = getPositionInScene()
         
            self.trackingTimerARStart()
            DispatchQueue.main.async {
               // self.startML()
            }
            } else {
            self.trackingTimerARStop()
            self.initDetection()
        }
    }
    @IBAction func startEstimateState (_ sender: Any) {
        if startEstimate.isOn {
            self.trackingTimerEstimateStart()
            } else {
            self.trackingTimerEstimateStop()
           // self.stopML()
            }
    }
    @objc func startNavigate() {
        arrayGPS.append(Coordinate(lat: getPositionInMap()!.latitude, lon: getPositionInMap()!.longitude))
        let coordinateCompute = findPointOffset(currentPosMap!,0 - Double(getPositionInScene().z) , 0 + Double(getPositionInScene().x))
        arrayAR.append(Coordinate(lat: coordinateCompute.latitude, lon: coordinateCompute.longitude))
    }
    func addAllow() {
        if arrayARObject.count > 0 {
            let delta = offsetComplete(currentPosMap!, arrayARObject.last!)
                   self.arrowLoadMesh(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) , 0 - Float(groundHeight) ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1))
        }
    }
    func addFollow(midObject : NMAGeoCoordinates) {
           let delta = offsetComplete(currentPosMap!, midObject)
           self.followMeScene(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) , 0 - Float(groundHeight) ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 - 0.5), name: "Follow")
       }
    func addInfo(object : NMAGeoCoordinates, name : String) {
        if currentPosMap != nil {
            let delta = offsetComplete(currentPosMap!, object)
            self.ringCheck(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) , 0 + 1 ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 + 2),name: name + "" + String(1))
            self.ringCheck(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) , 0  ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 + 0),name: name + "" + String(2))
            self.ringCheck(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) , 0 - 1 ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 - 2),name: name + "" + String(3))

        } else {
            
            self.changeCurrentPosition()
        }
    }
    /// MARK 3 @objc func
    @objc func addObjectAR() {
        /// mark update drone
        // self.updateDrone()
        // self.findhereLogo()
        // self.sofa(position: SCNVector3(0,0, 4))

        self.changeCurrentPosition()

        var index = 0
        var index2 = 0
        // arrayVector.append(SCNVector3(0,-Float(groundHeight),0))
           var green = #colorLiteral(red: 0.0912076999, green: 0.2924068921, blue: 0.1181608858, alpha: 1)
        if arrayARObject.count > 0 {
            self.reset()
        //  draw
            //arrayVector.append(SCNVector3(0, 0 - Float(groundHeight), 0))
            for object in arrayARObject {
                painItemAR(object,index)
                //self.addFollow(midObject: object)
                index += 1
            }
            if arrayVector.count > 1 {
                let size = arrayVector.count
                self.segmentRoute.text = "route seg : \(String(describing: size - 1))"
                for i in 0...size - 1 {
                if i != size - 1{
                    draw3DLine(arrayVector[i], arrayVector[i+1],orderIndex: index, color : green )
                    }
                }
            }
            //self.addInfo(object : arrayARObject.last!, name: "test ring")
        }
        var red = #colorLiteral(red: 0.6872526506, green: 0.1140015829, blue: 0.1115887886, alpha: 1)

        if arrayARObjectYAM.count > 0 {
                  //self.reset()
              //  draw
                  //arrayVector.append(SCNVector3(0, 0 - Float(groundHeight), 0))
                  for object in arrayARObjectYAM {
                      painItemAR(object,index2)
                      //self.addFollow(midObject: object)
                      index2 += 1
                  }
                  if arrayVector.count > 1 {
                      let size = arrayVector.count
                      self.segmentRoute.text = "route seg : \(String(describing: size - 1))"
                      for i in 0...size - 1 {
                      if i != size - 1{
                        //draw3DLine(arrayVector[i], arrayVector[i+1],orderIndex: index, color: red)
                          }
                      }
                  }
                  //self.addInfo(object : arrayARObject.last!, name: "test ring")
              }
        
        print(printDiff)
        print(arrayoffset)
        self.addAllow()
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
    /// MARK 5 estimate()
    func trackingTimerEstimateStart() {
        timeTrackingEstimate.invalidate()
        timeTrackingEstimate = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(self.startNavigate),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    func trackingTimerEstimateStop() {
        timeTrackingEstimate.invalidate()
        arrayNavigate.id = 1
        arrayNavigate.pointGPS = arrayGPS
        arrayNavigate.pointAR = arrayAR
        print(arrayNavigate)
    }
//###
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  //      stopML()
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

     func initTap() {
         let tapRec = UITapGestureRecognizer(target: self,
                                             action: #selector(ARSceneController.handleTap(rec:)))
         tapRec.numberOfTouchesRequired = 1
         self.sceneView.addGestureRecognizer(tapRec)
    }
     @objc func handleTap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if let tappednode = hits.first?.node {
                if tappednode.name == "test ring1" {
                    let p1 = SCNVector3(tappednode.position.x - 2,tappednode.position.y,tappednode.position.z - 1 )
                    self.addPlane(content: arImage, place: p1)
                } else
                if tappednode.name == "test ring2" {
                    let p2 = SCNVector3(tappednode.position.x,tappednode.position.y,tappednode.position.z - 2 )
                    self.addPlane(content: octoberImage!, place: p2)
                } else
                if tappednode.name == "test ring3" {
                    let p3 = SCNVector3(tappednode.position.x + 6  ,tappednode.position.y ,tappednode.position.z - 6 )
                    self.addPlane(content: googleImage, place: p3)

                                    }
                
                print("Tap name +++\(tappednode.name)+++")
                //do something with tapped object
            }
            //self.addSphereTest(pos: getPositionInScene())
        }
    }
    private func setupCoreML() {
        guard let selectedModel = try? VNCoreMLModel(for: currentMLModel) else {
            fatalError("Could not load model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: selectedModel,
                                                    completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
    }
    @objc private func loopCoreMLUpdate() {
         serialQueue.async {
             self.updateCoreML()
         }
     }
}

extension ARSceneController {
    /// MARK 1 Init
    func initDetection() {
        configuration.planeDetection = [.horizontal,.vertical] // vertical detection
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
        var pos = NMAPositioningManager.sharedInstance().currentPosition
        if pos != nil {
        let cord = pos?.coordinates
        let lat = cord?.latitude
        let lon = cord?.longitude
        let alt = 0.0//cord?.altitude
        let geoPos = NMAGeoCoordinates(latitude: lat!, longitude: lon!, altitude: Float(alt))
        self.geoPosition.text = "geo pos: - \(lat!) : \(lon!)"
        return geoPos
        }
       
        return nil//
    }
 /// MARK 5 updatePositionManual
    func changeCurrentPosition() {
        currentPosMap = getPositionInMap()
        bridge.updateMapAR()
    }
}

/// MARK 4 extension computed offset and draw
extension ARSceneController {
    
    func painItemAR(_ posDraw : NMAGeoCoordinates?,_ index : Int) {
            let currentPosScene = getPositionInScene()
            if  currentPosMap == nil {
                manualPosition = arrayARObject.first!
                currentPosMap = manualPosition//getPositionInMap()
                self.geoPosition.text = "geo pos: - \(manualPosition.latitude) : \(manualPosition.longitude)"

            }
            self.positionInMap.text = "position in map: \(currentPosMap?.latitude) : \(currentPosMap?.longitude)"
            let offsetMeters = bridge.distanceGeo(pointA: currentPosMap!, pointB: posDraw!)
            arrayoffset.append(offsetMeters)
            self.offsetPosition.text = "offset - \(offsetMeters) метров"
            let delta = offsetComplete(currentPosMap!, posDraw!)
            // test compute new coordinate
            // deltaX = offsetMeters*cos(45*Double.pi/180)/(6371000*Double.pi/180)
            // deltaZ=offsetMeters*sin(45*Double.pi/180)/cos(currentPosMap!.latitude*Double.pi/180)/(6371000*Double.pi/180)
            var node = SCNNode()
            var scalarLeft = SCNNode()
            var scalarRight = SCNNode()
            printDiff["\(index)"] = delta
            let positionN = SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) + SliderBearing.value,SliderAltitude.value + 0 - Float(groundHeight) ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 + SliderDirection.value)
            var bearing = 5
            //node.transform = SCNMatrix4Mult(node.transform, SCNMatrix4MakeRotation(Float(bearing), 0.0, 1.0, 0.0))
            //self.ringCheck(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) + SliderBearing.value,SliderAltitude.value + 0 - Float(groundHeight) ,0/*currentPosScene!.z*/ + Float(delta[1]) * -1 + SliderDirection.value), name: "test ring1")
            let centrColor =  #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            node = sphere2d(color: centrColor)
            //node.nodeAnimation(node)
            
            node.position = positionN
            let leftColor =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            scalarLeft = sphere2d(color: leftColor)
            //scalarLeft.nodeAnimation(scalarLeft)
            scalarLeft.position = SCNVector3(node.position.x , node.position.y, node.position.z + 3)
            //scalarLeft.transform = SCNMatrix4Mult(scalarLeft.transform, SCNMatrix4MakeRotation(Float(bearing), 0.0, 1.0, 0.0))
            if index == arrayARObject.count - 1 {
            //self.followGreen(SCNVector3(node.position.x , node.position.y, node.position.z + 5), name: "followGreen")
            }
            if index % 10 == 0 {
            self.ringCheck(SCNVector3(0/*currentPosScene!.x*/ + Float(delta[0] ) + SliderBearing.value,SliderAltitude.value + 0 ,1/*currentPosScene!.z*/ + Float(delta[1]) * -1 + SliderDirection.value), name: "test ring1")
            }
        
            let rightColor =  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            scalarRight = sphere2d(color: rightColor)
            //scalarRight.nodeAnimation(scalarRight)
            scalarRight.position = SCNVector3(node.position.x + 0, node.position.y, node.position.z)
            var greenpl = #colorLiteral(red: 0.1653840926, green: 0.534415934, blue: 0.2186465091, alpha: 0)
            self.addPlaneColor(content: greenpl, place: scalarRight.position,isPlot : true)
        
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
        if index == 0 {
             self.addLabel(SCNVector3(x : node.position.x,y : node.position.y + 5,z :node.position.z)," Начало маршрута \(way) ", isCamera: true)
        }  else if index == arrayARObject.count - 1 {
                self.addLabel(SCNVector3(x : node.position.x,y : node.position.y + 5,z :node.position.z),"  Финиш \(way) ", isCamera: true)
        } else if  index % 6 == 0 {
             self.addLabel(SCNVector3(x : node.position.x,y : node.position.y + 5,z :node.position.z),"  Расстояние \(way) ", isCamera: true)
        }
           
        
            self.offsetInSceneNode.text = "offset node - \(way)"
            //self.lineAR(node1Pos!,node2Pos)
            node.name = "pointAR"
         scalarLeft.name = "pointAR"
         scalarRight.name = "pointAR"
        
          sceneView.scene.rootNode.addChildNode(scalarLeft)
          sceneView.scene.rootNode.addChildNode(scalarRight)
          sceneView.scene.rootNode.addChildNode(node)
        }
    
        // dfndsfnsdfs
    func sphere2d(color : UIColor) -> SCNNode {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.1))
          sphereNode.simdPivot.columns.3.x = 5
          sphereNode.geometry?.firstMaterial?.diffuse.contents = color
          //sphereNode.rotation = SCNVector4(0, 1, 0, (-CGFloat.pi * (CGFloat(5))/6)/7.5)
          return sphereNode
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
            testXPoint =  pointStart//bridge.firstGeoTask(pointStart, deltaX, 0)
            //
            testYPoint = self.findPointOffset(pointStart, deltaZ, deltaX)//NMAGeoCoordinates(latitude: lat, longitude: lon)//bridge.firstGeoTask(pointEnd, deltaZ, deltaX)
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
        func findPointOffset(_ startPoint : NMAGeoCoordinates, _ deltaX : Double , _ deltaY : Double) -> NMAGeoCoordinates {
            let R = 6378.137
            var dLat = deltaX/1000/R
            var dLon = deltaY/1000/(R * cos(Double.pi * startPoint.latitude/180))
            return NMAGeoCoordinates(latitude: startPoint.latitude + dLat * 180/Double.pi,
                                     longitude: startPoint.longitude + dLon * 180/Double.pi)
    }
    /*
    func calculateBearing(to coordinate: NMAGeoCoordinates,from start : NMAGeoCoordinates) -> Double {
      let toRadian = Double.pi/180
      let a = sin(coordinate.latitude.toRadian - start.longitude.toRadian) * cos(coordinate.latitude.toRadian)
      let b = cos(start.lat.toRadian)*sin(coordinate.lat.toRadian)
      let c = sin(start.lat.toRadian)*cos(coordinate.lat.toRadian)*cos(coordinate.lon.toRadian - start.lon.toRadian)
     let d = b - c
      return atan2(a, d)
    }*/
     // reset
        func reset() {
            //sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "pointAR" /*|| node.name == "line" */|| node.name == "labelAR" || node.name == "routeAR" || node.name == "allow" || node.name == "test ring1" || node.name == "followGreen" || node.name == "occlusion" {
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
    func showHide() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name ==  "test ring1" {
                let nodes = node.childNodes.count
                let node1Pos = getPositionInScene()
                let node2Pos = node.position
                 let distanceNode = SCNVector3(
                        node2Pos.x - node1Pos!.x,
                        node2Pos.y - node1Pos!.y,
                        node2Pos.z - node1Pos!.z)
                if distanceNode.length() < 0.1 {
                    node.isHidden = true
                }
        }}
    }

    class ARSCNArrowGeometry: SCNGeometry {
        convenience init(material: SCNMaterial) {
            let vertices: [SCNVector3] = [
                SCNVector3Make(-0.02,  0.00,  0.00), // 0
                SCNVector3Make(-0.02,  0.50, -0.33), // 1
                SCNVector3Make(-0.10,  0.44, -0.50), // 2
                SCNVector3Make(-0.22,  0.00, -0.39), // 3
                SCNVector3Make(-0.10, -0.44, -0.50), // 4
                SCNVector3Make(-0.02, -0.50, -0.33), // 5
                SCNVector3Make( 0.02,  0.00,  0.00), // 6
                SCNVector3Make( 0.02,  0.50, -0.33), // 7
                SCNVector3Make( 0.10,  0.44, -0.50), // 8
                SCNVector3Make( 0.22,  0.00, -0.39), // 9
                SCNVector3Make( 0.10, -0.44, -0.50), // 10
                SCNVector3Make( 0.02, -0.50, -0.33), // 11
            ]
            let sources: [SCNGeometrySource] = [SCNGeometrySource(vertices: vertices)]
            let indices: [Int32] = [0,3,5, 3,4,5, 1,2,3, 0,1,3, 10,9,11, 6,11,9, 6,9,7, 9,8,7,
                                    6,5,11, 6,0,5, 6,1,0, 6,7,1, 11,5,4, 11,4,10, 9,4,3, 9,10,4, 9,3,2, 9,2,8, 8,2,1, 8,1,7]
            let geometryElements = [SCNGeometryElement(indices: indices, primitiveType: .triangles)]
            self.init(sources: sources, elements: geometryElements)
            self.materials = [material]
        }
    }
}

extension ARSceneController {
    private func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        
        let deviceOrientation = UIDevice.current.orientation.getImagePropertyOrientation()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixbuff!, orientation: deviceOrientation,options: [:])
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
}
extension UIDeviceOrientation {
    func getImagePropertyOrientation() -> CGImagePropertyOrientation {
        switch self {
        case UIDeviceOrientation.portrait, .faceUp: return CGImagePropertyOrientation.right
        case UIDeviceOrientation.portraitUpsideDown, .faceDown: return CGImagePropertyOrientation.left
        case UIDeviceOrientation.landscapeLeft: return CGImagePropertyOrientation.up
        case UIDeviceOrientation.landscapeRight: return CGImagePropertyOrientation.down
        case UIDeviceOrientation.unknown: return CGImagePropertyOrientation.right
        }
    }
}
extension ARSceneController {
    private func classificationCompleteHandler(request: VNRequest, error: Error?) {
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            return
        }
        if observations.isEmpty != true {
            print("type array : \(type(of: observations))")
                       for observation in observations /* where observation is VNRecognizedObjectObservation */{
                           guard let objectObservation = observation as? VNClassificationObservation else {
                  //         print("is Observation None")
                           continue }
          //  for observation in observations where observation is VNRecognizedObjectObservation {
          //  guard let objectObservation = observation as? VNRecognizedObjectObservation else {
           //     continue
          //  }
            // Select only the label with the highest confidence.
            //let topLabelObservation = objectObservation.labels[0]
                        let topLabelObservation = objectObservation
                print("score: \(topLabelObservation.confidence) :: name: \(topLabelObservation.identifier)")
            self.infoML.text = "\(topLabelObservation.identifier)"
            if topLabelObservation.confidence > 0.10 && topLabelObservation.identifier == "passenger car" || topLabelObservation.confidence > 0.10 && topLabelObservation.identifier == "car wheel" {
                //self.stopML()
                DispatchQueue.main.async {
                    self.infoML.text = "Внимание автомобиль"
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    self.infoML.text = ""
                    }                    //self.reset()
                    //self.configuration.worldAlignment = .gravity
                    //self.initDetection()
                    //self.ringCheck(SCNVector3(-1.5,0.25,-1), name: "test ring1")
                    //self.ringCheck(SCNVector3(0,0.25,-1), name: "test ring2")
                    //self.ringCheck(SCNVector3(1.5,0.25,-1), name: "test ring3")
                 }
                }
                /*
            DispatchQueue.main.async {
                let topPrediction = classifications.components(separatedBy: "\n")[0]
                let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
                guard let topPredictionScore: Float = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces)) else { return }
                
                if (topPredictionScore > 0.95) {
                    print("Top prediction: \(topPredictionName) - score: \(String(describing: topPredictionScore))")
                    
                }
            } */
        }
    }
}
}
extension SCNNode {
    
    static func createPlaneNode(planeAnchor: ARPlaneAnchor, id: Int) -> SCNNode {
        let scenePlaneGeometry = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!)
        scenePlaneGeometry?.update(from: planeAnchor.geometry)
        let planeNode = SCNNode(geometry: scenePlaneGeometry)
        planeNode.name = "\(id)"
        switch planeAnchor.alignment {
        case .horizontal:
            planeNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        case .vertical:
            planeNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
            
        }
        return planeNode
    }
    
}
