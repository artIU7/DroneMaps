//
//  ARDroneMesh.swift
//  DroneMaps
//
//  Created by  brazilec22 on 15.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import ARKit

extension ARSceneController {
    /// MARK 0 load drone model
    func loadModels() {
            let droneScene = SCNScene(named: "art.scnassets/ParrotARDrone.scn")! // "Focus_mocus"
            parrotNode = droneScene.rootNode.childNode(withName: "MeshDrone",
                                                       recursively: false)! // "main"
            //focusNode.scale = SCNVector3(0.2, 0.2, 0.2)
            sceneView.scene.rootNode.addChildNode(parrotNode)
            print("Init : add object - Drone's") // Focusw
            // load roter drones
            roterNode = parrotNode.childNode(withName: "GeometryDrone",
                                             recursively: false)!.childNode(withName: "roter",
                                                                            recursively: false)!
            propellerNode = parrotNode.childNode(withName: "GeometryDrone",
                                                 recursively: false)!.childNode(withName: "Propeller",
                                                                                recursively: false)!
            //focusNode.childNode(withName: "GeometryDrone", recursively: false)!.childNode(withName: "Propeller", recursively: false)!
          /*
        // add animation roter
            let rotationAnimation = CABasicAnimation(keyPath: "move")
            // Animate one complete revolution around the node's Y axis.
            rotationAnimation.toValue = SCNVector4Make(0, 0, 1, Float(3.14*2) * 30.0)
            rotationAnimation.duration = 10.0 // One revolution in ten seconds.
            rotationAnimation.repeatCount = 100 // Repeat the animation forever.
            //parrotNode.addAnimation(rotationAnimation, forKey: "move")
        // root 2
             let rotate = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.5)
             let moveSequence = SCNAction.sequence([rotate])
             let moveLoop = SCNAction.repeatForever(moveSequence)
             parrotNode.runAction(moveLoop) */
      //self.focusNode.position = SCNVector3((sceneView.pointOfView?.position.x)! + 0.5, (sceneView.pointOfView?.position.y)! + 0.5, (sceneView.pointOfView?.position.z)! + 0.5)//SCNVector3(x: t.columns.3.x,y: t.columns.3.y, z: t.columns.3.z)
    }
    /// MARK 1 drone arObject
    /// reset drone position
       func resetDrone() {
           sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
           if node.name == "MeshDrone" {
               node.removeFromParentNode()
           }}
       }
       /// update positin drone
       func updateDrone() {
          //resetDrone()
           parrotNode.position = SCNVector3(parrotNode.position.x + 0.05,parrotNode.position.y + 0.005,parrotNode.position.z + 0)
           print("Drone position ::\(parrotNode.position)")
       }
}

