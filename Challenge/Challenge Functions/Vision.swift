//
//  Vision.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI
import VideoToolbox
import ARKit
class Vision: ObservableObject {
    @Published var ciColor = CIColor(color: .black)
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    func processClassifications(for request: VNRequest, error: Error?) -> String {
        
            guard let results = request.results else {
              return ""
            }
            let classifications = results as! [VNClassificationObservation]
        
            if !classifications.isEmpty {
                if classifications.first!.confidence > 0.5 {
                    let identifier = classifications.first?.identifier ?? ""
                    //print("Classification: Identifier \(identifier) Confidence \(classifications.first!.confidence)")
                    predictions = identifier.trimmingCharacters(in: .whitespaces)
                   
                    
                }
            
        }
        return predictions
    }
    func updateClassifications(in image: CVPixelBuffer) {

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    func areaAverage(cgImage: CGImage) -> UIColor {

        var bitmap = [UInt8](repeating: 0, count: 4)

        let context = CIContext(options: nil)
        let cgImg = context.createCGImage(CoreImage.CIImage(cgImage: cgImage), from: CoreImage.CIImage(cgImage: cgImage).extent)

        let inputImage = CIImage(cgImage: cgImg!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)

        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        
       
        return result
    }
}


import SwiftUI

import AVFoundation
import UIKit
import Vision
import CoreML

class CameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    var vision = Vision()
    private var gestureProcessor = HandGestureProcessor()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
       // view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        vision.updateClassifications(in: frame)
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        let uiImage = UIImage(cgImage: cgImage!)
    
      ciColor =  vision.areaAverage(cgImage: uiImage.cgImage!).coreImageColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

  
    
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) -> CameraVC {
        let controller = CameraVC()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CameraVC, context: Context) {}
    
   
}
class CameraVC2: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    var vision = Vision()
    private var gestureProcessor = HandGestureProcessor()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
       // view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        vision.updateClassifications(in: frame)
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        let uiImage = UIImage(cgImage: cgImage!)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }

            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    do {
                        
                       
                      
                    } catch {
                        
                    }
                    continue
                }
                texting.append(bestCandidate.string)
//print(texting)
               // print("Found this candidate: \(bestCandidate.string)")
            }
        }
        let requests = [request]

        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = uiImage.cgImage else {
                fatalError("Missing image to scan")
            }

            let handler = VNImageRequestHandler(cgImage: img, options: [:])
            try? handler.perform(requests)
        }
   
        
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

  
    
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

struct CustomCameraRepresentable2: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) -> CameraVC2 {
        let controller = CameraVC2()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CameraVC2, context: Context) {}
    
   
}
var predictions = ""

var ciColor = CIColor(color: .white)
extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

class CameraVC3: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    var vision = Vision()
    private var gestureProcessor = HandGestureProcessor()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
       // view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        //vision.updateClassifications(in: frame)
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        let uiImage = UIImage(cgImage: cgImage!)
        detectVisionContours(uiImage: uiImage)
        
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

  
    func detectVisionContours(uiImage: UIImage) {
            
            let context = CIContext()
             let sourceImage = uiImage
            
                var inputImage = CIImage.init(cgImage: sourceImage.cgImage!)
                
                let contourRequest = VNDetectContoursRequest.init()
                contourRequest.revision = VNDetectContourRequestRevision1
                contourRequest.contrastAdjustment = 1.0
                contourRequest.detectDarkOnLight = true
                contourRequest.maximumImageDimension = 512


                let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])

                try! requestHandler.perform([contourRequest])
                let contoursObservation = contourRequest.results?.first as! VNContoursObservation
        if contoursObservation.topLevelContours.last!.childContours.count == 1 {
                countC = (contoursObservation.topLevelContourCount)
        print(countC)
        }
                //self.contouredImage = drawContours(contoursObservation: contoursObservation, sourceImage: sourceImage.cgImage!)

            }
    }
    

 var countC = 0

struct CustomCameraRepresentable3: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) -> CameraVC3 {
        let controller = CameraVC3()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CameraVC3, context: Context) {}
    
   
}


struct ContourView: View {
    
    @State var points : String = ""
    @State var preProcessImage: UIImage?
    @State var contouredImage: UIImage?
    
    var body: some View {
        
        VStack{
            
            Text("Contours: \(points)")

            Image("coins")
            .resizable()
            .scaledToFit()
                
            if let image = preProcessImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            if let image = contouredImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Detect Contours", action: {
              //  detectVisionContours()
            })
        }
    }
    
   
    
}

var texting = ""

import SwiftUI
import VideoToolbox




extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
import SwiftUI

import AVFoundation
import UIKit
import Vision
import CoreML

class GreenCameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {


    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    
    
    func areaAverage(cgImage: CGImage) -> UIColor {

        var bitmap = [UInt8](repeating: 0, count: 4)

        let context = CIContext(options: nil)
        let cgImg = context.createCGImage(CoreImage.CIImage(cgImage: cgImage), from: CoreImage.CIImage(cgImage: cgImage).extent)

        let inputImage = CIImage(cgImage: cgImg!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)

        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
       // view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        let uiImage = UIImage(cgImage: cgImage!)
        print(areaAverage(cgImage: uiImage.cgImage!).coreImageColor.green)
        if areaAverage(cgImage: uiImage.cgImage!).coreImageColor.green > 0.75 {
            avgColor = "green"
            
        }
    }
    func colorToRGB(uiColor: UIColor) -> CIColor
    {
        return CIColor(color: uiColor)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func updateClassifications(in image: CVPixelBuffer) {

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            let classifications = results as! [VNClassificationObservation]
        
            if !classifications.isEmpty {
                if classifications.first!.confidence > 0.5 {
                    let identifier = classifications.first?.identifier ?? ""
                    //print("Classification: Identifier \(identifier) Confidence \(classifications.first!.confidence)")
                    predictions = identifier
                    
                }
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

struct GreenCustomCameraRepresentable: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) ->GreenCameraVC {
        let controller = GreenCameraVC()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: GreenCameraVC, context: Context) {}
    
   
}
var avgColor = ""



import UIKit
import Vision
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    var vision = Vision()
    private var gestureProcessor = HandGestureProcessor()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    var animalRecognitionRequest = VNRecognizeAnimalsRequest(completionHandler: nil)
    
    private let animalRecognitionWorkQueue = DispatchQueue(label: "PetClassifierRequest", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
       // view.layer.addSublayer(previewLayer)
setupVision()
        captureSession.startRunning()
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
       
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        let uiImage = UIImage(cgImage: cgImage!)
        processImage(uiImage)
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    
    
    private func setupVision() {
        animalRecognitionRequest = VNRecognizeAnimalsRequest { (request, error) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    var detectionString = ""
                    var animalCount = 0
                    for result in results
                    {
                        let animals = result.labels

                        for animal in animals {
                            
                            animalCount = animalCount + 1
                            var animalLabel = ""
                            print(animal.identifier)
                            if animal.identifier == "Dog" {
                                isDog = true
                            }
                            else{
                               
                               
                            }
                            
                            let string = "#\(animalCount) \(animal.identifier) \(animalLabel) confidence is \(animal.confidence)\n"
                            detectionString = detectionString + string
                        }
                    }
                    
                    if detectionString.isEmpty{
                        detectionString = "Neither cat nor dog"
                    }
                 
                }
            }
        }
    }
    
    private func processImage(_ image: UIImage) {
       // imageView.image = image
        animalClassifier(image)
    }
    
    private func animalClassifier(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        //textView.text = ""
        animalRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.animalRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

var isDog = false

struct DogView: UIViewControllerRepresentable {
    
  
   
    
    func makeUIViewController(context: Context) -> ViewController {
        let controller = ViewController()
        //controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: ViewController, context: Context) {}
    
   
}
