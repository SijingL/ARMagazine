import UIKit
import SpriteKit
import ARKit

struct ImageInformation {
    let name: String
    let description: String
    let image: UIImage
    let buttonAction: String
}

class ViewController: UIViewController, ARSKViewDelegate {
    @IBOutlet var sceneView: ARSKView!
    var selectedImage : ImageInformation?
    
    var images : [String? : ImageInformation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        let url = URL(string: "https://s3.amazonaws.com/netc-http/AR/NET.jpg")
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            
            if (error != nil){
                print("Error")
            }
            else{
                var documentsDirectory:String?
                
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                
                if paths.count > 0
                {
                    documentsDirectory = paths[0]
                    let savePath = documentsDirectory! + "/NET.jpg"
                    FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
                    
                    DispatchQueue.main.async{
                        guard let uiimage = UIImage(named: savePath),
                        let ciimage = CIImage(image: uiimage),
                            let cgimage = self.convertCIImageToCGImage(inputImage: ciimage)else { return }
                        
                        let arImage = ARReferenceImage(cgimage, orientation: .up, physicalWidth: 0.2)
                        
                        arImage.name = "CGImage Test"
                        let configuration = ARWorldTrackingConfiguration()
                        configuration.detectionImages = [arImage]
                        
                        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                        
                        self.images = [arImage.name : ImageInformation(name: "This is a title", description: "It was labeled a year to “reinvent,” but the 2017 Nebraska volleyball team had other plans. A 30-minute documentary captures an unexpected tile run and the drama of the 2017 Nebraska volleyball season.", image: uiimage, buttonAction: "http://d34oa379y8jhb4.cloudfront.net/NETVOD/50007115.mp4")]
                    }
                }
            }
        }
        
        task.resume()
        
        /*guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "ImageReference", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let referenceImages = arImage
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages

        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        */
    }
    
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        if let imageAnchor = anchor as? ARImageAnchor,
            let referenceImageName = imageAnchor.referenceImage.name,
            let scannedImage =  self.images[referenceImageName] {
            
            self.selectedImage = scannedImage
            
            self.performSegue(withIdentifier: "showImageInformation", sender: self)
            
            return imageSeenMarker()
        }
        
        return nil
    }
    
    private func imageSeenMarker() -> SKLabelNode {
        let labelNode = SKLabelNode(text: "✅")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        
        return labelNode
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInformation"{
            if let imageInformationVC = segue.destination as? ImageInformationViewController,
                let actualSelectedImage = selectedImage {
                imageInformationVC.imageInformation = actualSelectedImage
            }
        }
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}
