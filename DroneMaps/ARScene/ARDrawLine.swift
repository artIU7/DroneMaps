//
//  ARDrawLine.swift
//  DroneMaps
//
//  Created by  brazilec22 on 15.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import ARKit




class Plane: SCNNode{
    
    /// Creates An SCNPlane With A Single Colour Or Image For It's Material
    /// (Either A Colour Or UIImage Must Be Input)
    /// - Parameters:
    ///   - width: Optional CGFloat (Defaults To 60cm)
    ///   - height: Optional CGFloat (Defaults To 30cm)
    ///   - content: Any (UIColor Or UIImage)
    ///   - doubleSided: Bool
    ///   - horizontal: The Alignment Of The Plane
    init(width: CGFloat = 3, height: CGFloat = 2, content: Any, doubleSided: Bool, horizontal: Bool, plot : Bool) {
        
        super.init()
        
        //1. Create The Plane Geometry With Our Width & Height Parameters
        if plot == true {
            self.geometry = SCNPlane(width: width + 2, height: height + 1)

        } else {
            self.geometry = SCNPlane(width: width - 2, height: height - 1)
        }
        
        //2. Create A New Material
        let material = SCNMaterial()
        
        if let colour = content as? UIColor{
            
   

            
        material.diffuse.contents = colour
            
             //The Material Will Be A UIColor
            
        }else if let image = content as? UIImage{
            
            //The Material Will Be A UIImage
            material.diffuse.contents = image
            
        }else{
            
            //Set Our Material Colour To Cyan
            material.diffuse.contents = UIColor.cyan
            
        }
        if plot == true {
            self.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        } else {
            self.geometry?.firstMaterial = material
        }
        //3. Set The 1st Material Of The Plane
        
        //4. If We Want Our Material To Be Applied On Both Sides The Set The Property To True
        if doubleSided{
            material.isDoubleSided = true
        }
      
        //5. By Default An SCNPlane Is Rendered Vertically So If We Need It Horizontal We Need To Rotate It
        if horizontal{
            self.transform = SCNMatrix4Mult(self.transform, SCNMatrix4MakeRotation(Float(Double.pi), 1, 0, 1))
            self.transform = SCNMatrix4Mult(self.transform, SCNMatrix4MakeRotation(-Float(Double.pi)/1.0, 1, 0, 1))
   
            //SCNMatrix4MakeRotation(0, 1, 3, 0)
        }
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError("Plane Node Coder Not Implemented") }
}
// MARK additional helper draw 3d line class
class MeasuringLineNode: SCNNode{

    init(startingVector vectorA: GLKVector3, endingVector vectorB: GLKVector3, color : UIColor) {
    super.init()

    //1. Create The Height Our Box Which Is The Distance Between Our 2 Vectors
    let height = CGFloat(GLKVector3Distance(vectorA, vectorB))

    //2. Set The Nodes Position At The Same Position As The Starting Vector
    self.position = SCNVector3(vectorA.x, vectorA.y, vectorA.z)

    //3. Create A Second Node Which Is Placed At The Ending Vectors Posirions
    let nodeVectorTwo = SCNNode()
    nodeVectorTwo.position = SCNVector3(vectorB.x, vectorB.y, vectorB.z)

    //4. Create An SCNNode For Alignment Purposes At 90 Degrees
    let nodeZAlign = SCNNode()
    nodeZAlign.eulerAngles.x = Float.pi/2

    //5. Create An SCNCyclinder Geometry To Act As Our Line
    let cylinder = SCNCylinder(radius: 0.5, height: height)
    let material = SCNMaterial()
    let color_route = color
    material.diffuse.contents = color_route//UIColor.white
    /*cylinder.materials = [material]
    cylinder.firstMaterial?.diffuse.contents = UIColor.white
    cylinder.firstMaterial?.lightingModel = .physicallyBased
    cylinder.firstMaterial?.metalness.intensity = 1.0
    cylinder.firstMaterial?.roughness.intensity = 0.0
    */

   
    // If you want to use an SCNBox then use the following:

    let box = SCNBox(width: 0.5, height: height, length: 0.05, chamferRadius: 0)
     //let material = SCNMaterial()
    // material.diffuse.contents = UIColor.white
     box.materials = [material]

    

    //6. Create The LineNode Centering On The Alignment Node
    let nodeLine = SCNNode(geometry: box)
    nodeLine.position.y = Float(-height/2)
    nodeZAlign.addChildNode(nodeLine)
        nodeZAlign.name = "route AR"
    nodeZAlign.renderingOrder = 10
    self.addChildNode(nodeZAlign)

    //7. Force The Node To Look At Our End Vector
    self.constraints = [SCNLookAtConstraint(target: nodeVectorTwo)]
}

required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ARSceneController {
    // MARK: - ARSCNViewDelegate
       /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        return node
        }
        */
       /*
       func session(_ session: ARSession, didFailWithError error: Error) {
           // Present an error message to the user
       }
       func sessionWasInterrupted(_ session: ARSession) {
           // Inform the user that the session has been interrupted, for example, by presenting an overlay
       }
       func sessionInterruptionEnded(_ session: ARSession) {
           // Reset tracking and/or remove existing anchors if consistent tracking is required
       } */
          func addPlane(content : UIImage, place : SCNVector3){
           //1. Create Our Plane Node
           //let color = #colorLiteral(red: 0.6549019608, green: 0.6638626321, blue: 0.9686274529, alpha: 0.65)
            let plane = Plane(content : content, doubleSided: true, horizontal: true, plot: false)
           
           //2. Set It's Position 1.5m Away From The Camera
                plane.position = place//SCNVector3(10, 0, 0)
                plane.name = "plane \(UIImage.description())"
           //3. Add Our Plane To Our ARSCNView
                self.sceneView.scene.rootNode.addChildNode(plane)
           
       }
    func addPlaneColor(content : UIColor, place : SCNVector3, isPlot : Bool){
             //1. Create Our Plane Node
             //let color = #colorLiteral(red: 0.6549019608, green: 0.6638626321, blue: 0.9686274529, alpha: 0.65)
        let plane = Plane(content : content, doubleSided: true, horizontal: true, plot : true)
             //2. Set It's Position 1.5m Away From The Camera
                  plane.position = place//SCNVector3(10, 0, 0)
                  plane.name = "occlusion"
             //3. Add Our Plane To Our ARSCNView
                  self.sceneView.scene.rootNode.addChildNode(plane)
             
         }
    func draw3DLine(_ nodeA : SCNVector3, _ nodeB : SCNVector3, orderIndex : Int, color : UIColor) {
          //1. Convert The Nodes SCNVector3 to GLVector3
          //SCNTransaction.animationDuration = 1.0

          let nodeAVector3 = GLKVector3Make(nodeA.x, nodeA.y, nodeA.z)
          let nodeBVector3 = GLKVector3Make(nodeB.x, nodeB.y, nodeB.z)

          //2. Draw A Line Between The Nodes
        let line = MeasuringLineNode(startingVector: nodeAVector3 , endingVector: nodeBVector3, color: color)
          line.name = "routeAR"
          line.renderingOrder = 10 //+ orderIndex//orderIndex
        //  line.opacity = 0
          //line.nodeAnimation(line)
          self.sceneView.scene.rootNode.addChildNode(line)
    }
    // add line beetween two position point
    func lineAR(_ startPosition : SCNVector3,_ endPosition : SCNVector3) {
        let areaColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let line = SCNGeometry.line(from: startPosition, to: endPosition)
        line.firstMaterial?.diffuse.contents  = areaColor
        
        let lineNode = SCNNode(geometry: line)
       // lineNode.frame.height = 10
        lineNode.name = "3D Line"
        lineNode.position = SCNVector3Zero
        sceneView.scene.rootNode.addChildNode(lineNode)
    }
    // add from .DAE
    func sofa(position: SCNVector3) {
      guard let scene = self.sceneView else { return }
      let containerNode = SCNNode()
      let nodesInFile = SCNNode.allNodes(from: "Sofa.obj")
      
      nodesInFile.forEach { (node) in
        containerNode.addChildNode(node)
      }
      
      containerNode.position = position
      sceneView.scene.rootNode.addChildNode(containerNode)
    }
    //
    func addMapCard() {
        if arImage != nil {}
    }
    //
}
