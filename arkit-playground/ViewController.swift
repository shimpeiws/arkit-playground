//
//  ViewController.swift
//  arkit-playground
//
//  Created by Shimpei Takamatsu on 2018/09/19.
//  Copyright © 2018 Shimpei Takamatsu. All rights reserved.
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
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

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

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        print("anchor:\(anchor), node: \(node), node geometry: \(String(describing: node.geometry))")
        
        // 平面ジオメトリを作成
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                height: CGFloat(planeAnchor.extent.z))
        geometry.materials.first?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
        
        // 平面ジオメトリを持つノードを作成
        let planeNode = SCNNode(geometry: geometry)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        DispatchQueue.main.async(execute: {
            // 検出したアンカーに対応するノードに子ノードとして持たせる
            node.addChildNode(planeNode)
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        DispatchQueue.main.async(execute: {
            // 平面ジオメトリのサイズを更新
            for childNode in node.childNodes {
                guard let plane = childNode.geometry as? SCNPlane else {continue}
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
                break
            }
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
    }

    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
        // 平面検出時はARPlaneAnchor型のアンカーが得られる
        //        guard let planeAnchors = anchors as? [ARPlaneAnchor] else {return}
        //        print("平面を検出: \(planeAnchors)")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("\(self.classForCoder)/" + #function)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
