//
//  ViewController.swift
//  Finding Surfaces
//
//  Created by Georgy Dyagilev on 18/09/2018.
//  Copyright © 2018 Dyagilev developer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, SCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        let geometry = SCNPlane(width: width, height: height)
        let node = SCNNode()
        node.geometry = geometry
        node.opacity = 0.25
        node.eulerAngles.x = -Float.pi / 2
        return node
    }
    
    func createTree(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let treeNode = SCNNode()
        treeNode.position = SCNVector3(0, 0.25, 0)
        
        let trunk = SCNCylinder(radius: 0.05, height: 0.5)
        trunk.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        treeNode.geometry = trunk
        
        let crownNode = SCNNode()
        crownNode.position = SCNVector3(0, 0.5, 0)
        
        let crown = SCNSphere(radius: 0.25)
        crown.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        crownNode.geometry = crown
        
        let node = SCNNode()
        node.addChildNode(treeNode)
        node.addChildNode(crownNode)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let floor = createFloor(planeAnchor: planeAnchor)
        let tree = createTree(planeAnchor: planeAnchor)
        node.addChildNode(floor)
        node.addChildNode(tree)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let floor = node.childNodes.first, let geometry = floor.geometry as? SCNPlane else { return }
        
        geometry.width = CGFloat(planeAnchor.extent.x)
        geometry.height = CGFloat(planeAnchor.extent.z)
        
        floor.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
