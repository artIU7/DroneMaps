//
//  ARHelper.swift
//  DroneMaps
//
//  Created by  brazilec22 on 15.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import ARKit

extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    static func + (_ a : SCNVector3,_ b : SCNVector3) -> SCNVector3 {
        let c = SCNVector3(a.x+b.x, a.y+b.y, a.z + b.z)
        return c
    }
}
extension SCNGeometry {
    class func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
   
}
extension SCNNode {
  public class func allNodes(from file: String) -> [SCNNode] {
    var nodesInFile = [SCNNode]()
    do {
      guard let sceneURL = Bundle.main.url(forResource: file, withExtension: nil) else {
        print("Could not find scene file \(file)")
        return nodesInFile
      }
      let objScene = try SCNScene(url: sceneURL as URL, options: [SCNSceneSource.LoadingOption.animationImportPolicy: SCNSceneSource.AnimationImportPolicy.doNotPlay])
      objScene.rootNode.enumerateChildNodes({ (node, _) in
        nodesInFile.append(node)
      })
    } catch {}
    return nodesInFile
  }
   public func nodeAnimation(_ nodeAnimation : SCNNode) {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 1.0
        animationGroup.repeatCount = .infinity
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(value: 1.0)
        opacityAnimation.toValue = NSNumber(value: 0.5)
        let scaleAnimation = CABasicAnimation(keyPath: "scale")
        scaleAnimation.fromValue = NSValue(scnVector3: SCNVector3(1.0, 1.0, 1.0))
        scaleAnimation.toValue = NSValue(scnVector3: SCNVector3(1, 1, 1))
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        nodeAnimation.addAnimation(animationGroup, forKey: "animations")
    }
}

extension ARSceneController {
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
           let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
           let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
           return view.unprojectPoint(locationWithz)
       }
    //
    func isNodeInFrontOfCamera(_ node: SCNNode, scnView: SCNView) -> Bool {
        guard let pov = scnView.pointOfView else { return false }
        guard let parent = node.parent else { return false }
        let positionInPOV = parent.convertPosition(node.position, to: pov)
        return positionInPOV.z < 0
       }
    
    /// not use
    ///
    // Draw Logo "Here" from scene // -
     func findhereLogo() {
         self.getPositionInScene()
         let nodes = sceneView.scene.rootNode.childNodes
         for node in nodes {
             if node.name != "here_logo_1" {
                 node.removeFromParentNode()
             } else {
                 var worldPosition = sceneView.pointOfView!.worldPosition
                 node.position = /*worldPosition+*/ SCNVector3(0, 0, 100)
                 node.scale = SCNVector3(-20,-20, -20)
                 node.nodeAnimation(node)
                 print("point in cord \(node.position)")
                 hereLogo = node
                 sceneView.scene.rootNode.addChildNode(node)
             }
         }
     }
    // draw obj
     func ojectShow() {
         var index = 0
         if arrayARObject.count > 0 {
             for object in arrayARObject {
                 painItemAR(object,index)
                 index += 1
             }
         }
     }

}
