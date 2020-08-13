//
//  ARSession.swift
//  DroneMaps
//
//  Created by  brazilec22 on 15.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import ARKit

// MARK section render(:)
extension ARSceneController {
    // MARK metdos hitTest distance to plane ground
    func updateFocusNode() {
           let results = self.sceneView.hitTest(self.planePoint, types: [.existingPlaneUsingExtent])
           if results.count == 1 {
               if let match = results.first {
                   let t = match.worldTransform
                  groundHeight = match.distance
                  heightFround.text = "GH : \(groundHeight!)"
                   print("t : \(t) \n p : \(groundHeight)")
                   /*roterNode.rotation.x = 0 //= SCNVector4Make(0, 0, 1, 20*Float(M_PI * 2))
                   roterNode.rotation.y = 0
                   roterNode.rotation.z = 1
                   roterNode.rotation.w += 20*2 */
                   //self.focusNode.position = SCNVector3((sceneView.pointOfView?.position.x)! + 0.5, (sceneView.pointOfView?.position.y)! + 0.5, (sceneView.pointOfView?.position.z)! + 0.5)//SCNVector3(x: t.columns.3.x,y: t.columns.3.y, z: t.columns.3.z)
                   print("Update : object - Drone's")
                   print("gamestate :: swipeToPlay")
                   }
               //
               }
               else {
                   print("gamestate :: pointToSurface")
               }
       }
    // MARK session ovveride
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    }
    // MARK render ovveride
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            
            //self.statusLabel.text = self.trackingStatus
            print("render(:updateAtTime)")
          //  self.updateStatus()
            let center = self.sceneView.center

            DispatchQueue.global(qos: .userInitiated).async {
                if #available(iOS 13.0, *) {
                    if let query = self.sceneView.raycastQuery(from: center, allowing: .estimatedPlane, alignment: .any) {
                        let results = self.sceneView.session.raycast(query)
                        print("object \(results)")
                    }
                    else {
                        // sometimes it gets here
                    }
                    self.makeUpdateCameraPos(towards: SCNVector3(0,0,0))
            }
            self.updateFocusNode()
        }
    }
}
    func makeUpdateCameraPos(towards: SCNVector3) {
          guard let scene = self.sceneView else { return }
      }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        /*DispatchQueue.main.async {
             print(planeAnchor.center)
            if node.renderingOrder < 2 {
                node.isHidden = true
            }
             print("update anchor")
        }*/
             node.enumerateChildNodes { child, _ in
                 child.removeFromParentNode()
             }
             let planeNode = SCNNode.createPlaneNode(planeAnchor: planeAnchor, id: self.planeId)
             self.planeId += 1
             node.addChildNode(planeNode)
    }

   //
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
               guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
               print("plane Anchor: \(planeAnchor)")
               /*DispatchQueue.main.async {
                   print("add Plane")
               }*/
                let planeNode = SCNNode.createPlaneNode(planeAnchor: planeAnchor, id: planeId)
                planeId += 1
                node.addChildNode(planeNode)
           }
    //
    //
       func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
           guard anchor is ARPlaneAnchor else { return }
           /*DispatchQueue.main.async {
                print("remove anchor")
           }*/
            node.enumerateChildNodes { child, _ in
                child.removeFromParentNode()
            }
        }
}
