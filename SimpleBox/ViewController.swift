 //
//  ViewController.swift
//  SimpleBox
//
//  Created by Leonardo Medeiros on 10/07/21.
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
        
        /* 3D Elements of the scene */

        // width and height are in meters
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let text = SCNText(string: "Hello ARKIT!", extrusionDepth: 1.0)
        let sphere = SCNSphere(radius: 0.1)

        /* Defining Materials */

        // all the sides of the box will have the same material
        let boxMaterial = SCNMaterial()
        boxMaterial.name = "Color"
        boxMaterial.diffuse.contents = UIImage(named: "wood.jpeg")
        
        box.firstMaterial = boxMaterial
        text.firstMaterial?.diffuse.contents = UIColor.blue
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth.jpg")

        /* Defining Nodes (scale, position) */
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, -1)

        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(-0.25, 0, 0.25)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0, 0.35, -1)

        /*  */

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        /* Adding into the scene */

        self.sceneView.scene.rootNode.addChildNode(boxNode)
        boxNode.addChildNode(textNode)

        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        
        
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material = node.geometry?.material(named: "Color")
            
            material?.diffuse.contents = UIColor.random()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
