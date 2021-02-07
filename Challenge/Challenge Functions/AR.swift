//
//  AR.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI
import ARKit
class faceVC: UIViewController {
    let sceneView = ARSCNView()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else { return }
           let configuration = ARFaceTrackingConfiguration()
           configuration.isLightEstimationEnabled = true
           sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.frame = view.frame
        sceneView.delegate = self
        sceneView.scene.background.contents = UIColor(named: "green1")
        view.addSubview(sceneView)
    }
}
extension faceVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        faceGeometry.update(from: faceAnchor.geometry)
        let rightSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
       
       // 3
       
        if rightSmileValue > 0.7 {
            smile = "yes"
        }
    }
   
}
struct facesView: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) -> faceVC {
        let controller = faceVC()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: faceVC, context: Context) {}
    
   
}
var smile = ""
