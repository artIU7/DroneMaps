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
            self.updateFocusNode()
        }
    }
/*    //
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
               guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
               print("plane Anchor: \(planeAnchor)")
               DispatchQueue.main.async {
                   print("add Plane")
               }
           }
    //
           func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
               guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
               DispatchQueue.main.async {
                    print("update anchor")
               }
           }
    //
       func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
           guard anchor is ARPlaneAnchor else { return }
           DispatchQueue.main.async {
               print("remove anchor")
           }
       } */
}
