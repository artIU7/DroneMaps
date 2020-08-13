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
    func addSphereTest(pos : SCNVector3) {
        var node1 = SCNNode()

        let nodeColor1 =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        node1 = sphere2d(color: nodeColor1)
 
        node1.position = pos
        sceneView.scene.rootNode.addChildNode(node1)

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
    // add arrow
    /// MARK 0 load drone model
       func arrowLoadMesh(_ endRoute : SCNVector3) {
               let arrowScene = SCNScene(named: "art.scnassets/Model/Down_Arrow_Animated.scn")! // "Focus_mocus"
               allowNode = arrowScene.rootNode.childNode(withName: "Meshes",
                                                          recursively: false)! // "main"
        
               allowNode.scale = SCNVector3(0.8, 0.8, 0.8)
               allowNode.position = endRoute
               allowNode.name = "allow"
               sceneView.scene.rootNode.addChildNode(allowNode)
               print("Init : add object - Allow") // Focusw
               // load roter drones
               /*roterNode = parrotNode.childNode(withName: "GeometryDrone",
                                                recursively: false)!.childNode(withName: "roter",
                                                                               recursively: false)! */
              
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
    
    /// MARK 0 load drone model
          func followGreen(_ endRoute : SCNVector3,name : String) {
                  let followScene = SCNScene(named: "art.scnassets/Model/followGreenAllow.scn")! // "Focus_mocus"
                  followRootGreen = followScene.rootNode.childNode(withName: "RootNode",
                                                             recursively: false)! // "main"
                
                  followRootGreen.scale = SCNVector3(0.1, 0.1, 0.1)
                  followRootGreen.position = endRoute
                  followRootGreen.name = name
                  followRootGreen.nodeAnimation(followRootGreen)
                  //followNode.nodeAnimation(followNode)
                  //infoNode.transform = SCNMatrix4Mult(infoNode.transform, SCNMatrix4MakeRotation(Float(Double.pi)/2.0, 0, 0, 1))
                  sceneView.scene.rootNode.addChildNode(followRootGreen)
                  print("Init : add object - followRoot") // Focusw
              }
    /// MARK 0 load drone model
    func ringCheck(_ endRoute : SCNVector3,name : String) {
            let arrowScene = SCNScene(named: "art.scnassets/Model/RingCheck.scn")! // "Focus_mocus"
            infoNode = arrowScene.rootNode.childNode(withName: "Meshes",
                                                       recursively: false)! // "main"
        
        
            circleNode = infoNode.childNode(withName: "RootNode",
                                               recursively: false)!.childNode(withName: "Circle",
                                                                              recursively: false)!
         
        
        
            circleNode.scale = SCNVector3(0.2, 0.2, 0.2)
            circleNode.position = endRoute
            circleNode.name = name
            circleNode.nodeAnimation(circleNode)
            //infoNode.transform = SCNMatrix4Mult(infoNode.transform, SCNMatrix4MakeRotation(Float(Double.pi)/2.0, 0, 0, 1))
            sceneView.scene.rootNode.addChildNode(circleNode)
            print("Init : add object - Allow") // Focusw
        }
    //FollowMe
    /// MARK 0 load drone model
       func followMeScene(_ endRoute : SCNVector3,name : String) {
               let followScene = SCNScene(named: "art.scnassets/Model/FollowMe.scn")! // "Focus_mocus"
               followRoot = followScene.rootNode.childNode(withName: "RootNode",
                                                          recursively: false)! // "main"
               followNode = followRoot.childNode(withName: "Follow",
                                                  recursively: false)!
               followNode.scale = SCNVector3(0.5, 0.5, 0.5)
               followNode.position = endRoute
               followNode.name = name
               //followNode.nodeAnimation(followNode)
               //infoNode.transform = SCNMatrix4Mult(infoNode.transform, SCNMatrix4MakeRotation(Float(Double.pi)/2.0, 0, 0, 1))
               sceneView.scene.rootNode.addChildNode(followNode)
               print("Init : add object - Allow") // Focusw
           }
    // func load models standart geometry
    func loadStandartGeometry(_ endRoute : SCNVector3,name : String) {
             let standartScene = SCNScene(named: "art.scnassets/Model/SceneKitScene.scn")! // "Focus_mocus"
             sceneGeometry = standartScene.rootNode.childNode(withName: "RootNode",
                                                        recursively: false)! // "main"
             sceneGeometry.name = name
             sceneGeometry.scale = SCNVector3(0.002, 0.002, 0.002)
             sceneView.scene.rootNode.addChildNode(sceneGeometry)
        }
}

