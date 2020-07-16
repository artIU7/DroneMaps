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
    func addLabel(_ position : SCNVector3, _ value : String) {
           let text = SCNText(string: value, extrusionDepth: 1)
           let material = SCNMaterial()
           material.diffuse.contents = UIColor.orange
           text.materials = [material]
           let node = SCNNode()
           node.position = position//SCNVector3(0,2, 2)
           node.scale = SCNVector3(0.5, 0.5, 0.5)
           let billboardConstraint = SCNBillboardConstraint()
           billboardConstraint.freeAxes = SCNBillboardAxis.Y
           node.constraints = [billboardConstraint]
           node.geometry = text
           node.name = "labelAR"
           //node.nodeAnimation(node)
           self.isNodeInFrontOfCamera(node, scnView: sceneView)
           sceneView.scene.rootNode.addChildNode(node)
       }
}
