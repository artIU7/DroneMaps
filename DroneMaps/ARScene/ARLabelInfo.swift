//
//  ARLabelInfo.swift
//  DroneMaps
//
//  Created by  brazilec22 on 15.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import ARKit

extension ARSceneController {
    func addLabel(_ position : SCNVector3, _ value : String, isCamera : Bool) {
           let text = SCNText(string: value, extrusionDepth: 1)
           let material = SCNMaterial()
           let pointXColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
           material.diffuse.contents = pointXColor
           text.materials = [material]
           let node = SCNNode()
           node.position = position//SCNVector3(0,2, 2)
           node.scale = SCNVector3(0.1, 0.1, 0.1)
           let billboardConstraint = SCNBillboardConstraint()
           billboardConstraint.freeAxes = SCNBillboardAxis.Y
           node.constraints = [billboardConstraint]
           node.geometry = text
           node.name = "labelAR"
           //node.nodeAnimation(node)
           if isCamera == true {
                self.isNodeInFrontOfCamera(node, scnView: sceneView)
           }
           sceneView.scene.rootNode.addChildNode(node)
       }
}
