//
//  WorkoutView.swift
//  
//
//  Created by Andreas on 12/26/20.
//


import SwiftUI

import AVFoundation
import UIKit
import Vision
import CoreML
import CoreGraphics
import CoreImage
import VideoToolbox
@available(iOS 14.0, *)
class WorkoutViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {


    /// - Tag: MLModelSetup
    
    
    var type = ""
   
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.devices().filter({ $0.position == .front })
            .first as? AVCaptureDevice else {
                fatalError("No front facing camera found")
        }
       
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
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        let view1 = UIView()
        view1.frame = view.frame
        view1.backgroundColor = .blue
       // self.view.addSubview(view1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view1.addGestureRecognizer(tap)
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        self.updateClassifications(in: frame)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
        
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.createCSV()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func updateClassifications(in image: CVPixelBuffer) {

        let requestHandler = VNImageRequestHandler(cgImage: create(pixelBuffer: image)!)

        // Create a new request to recognize a human body pose.
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)

        do {
            // Perform the body pose-detection request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
        
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedPointsObservation] else { return }
        
        // Process each observation to find the recognized body pose points.
        observations.forEach { processObservation($0) }
    }
    func processObservation(_ observation: VNRecognizedPointsObservation) {
        
        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(forGroupKey: .all) else {
            return
        }
        
        // Torso point keys in a clockwise ordering.
        if type == "Situps" {
        let torsoKeys: [VNRecognizedPointKey] = [
            
           // .bodyLandmarkKeyLeftKnee //squats
            .bodyLandmarkKeyNose //situps
           //.bodyLandmarkKeyLeftEar //pushups
          // .bodyLandmarkKeyLeftEye //plank
        ]
        let screenSize = UIScreen.main.bounds
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = torsoKeys.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0.8 else { return nil }
           // print(point.x)
           // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
            //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
           //     calculateAnkle(x: point2.x, y: point2.y)
           //     return VNImagePointForNormalizedPoint(point2.location,
                //                                      Int(screenSize.width),
               //                                       Int(screenSize.height))
            //}
           // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
           //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
              //  calculateShoulder(x: point3.x, y: point3.y)
               // print(point3.x)
             ///   return VNImagePointForNormalizedPoint(point3.location,
                //                                      Int(screenSize.width),
                //                                      Int(screenSize.height))
            
    
           // print(point.x)
           // print( point.x)
          
          //  gestureProcessor.reset()
            calculateSitups(x: point.x, y: point.y)
            detectedJoints = true
            // Translate the point from normalized-coordinates to image coordinates.
            return VNImagePointForNormalizedPoint(point.location,
                                                  Int(screenSize.width),
                                                  Int(screenSize.height))
        }
        } else if type == "Pushups" {
            let torsoKeys: [VNRecognizedPointKey] = [
                
               // .bodyLandmarkKeyLeftKnee //squats
               // .bodyLandmarkKeyNose //situps
               .bodyLandmarkKeyLeftEar //pushups
              // .bodyLandmarkKeyLeftEye //plank
            ]
            let screenSize = UIScreen.main.bounds
            
            // Retrieve the CGPoints containing the normalized X and Y coordinates.
            let imagePoints: [CGPoint] = torsoKeys.compactMap {
                guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
               // print(point.x)
               // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
                //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
               //     calculateAnkle(x: point2.x, y: point2.y)
               //     return VNImagePointForNormalizedPoint(point2.location,
                    //                                      Int(screenSize.width),
                   //                                       Int(screenSize.height))
                //}
               // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
               //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
                  //  calculateShoulder(x: point3.x, y: point3.y)
                   // print(point3.x)
                 ///   return VNImagePointForNormalizedPoint(point3.location,
                    //                                      Int(screenSize.width),
                    //                                      Int(screenSize.height))
                
        
               // print(point.x)
               // print( point.x)
              
              //  gestureProcessor.reset()
                calculatePushups(x: point.x, y: point.y)
                detectedJoints = true
                // Translate the point from normalized-coordinates to image coordinates.
                return VNImagePointForNormalizedPoint(point.location,
                                                      Int(screenSize.width),
                                                      Int(screenSize.height))
            }
        } else if type == "Squats" {
            let torsoKeys: [VNRecognizedPointKey] = [
                
                .bodyLandmarkKeyLeftKnee //squats
               // .bodyLandmarkKeyNose //situps
              // .bodyLandmarkKeyLeftEar //pushups
              // .bodyLandmarkKeyLeftEye //plank
            ]
            let screenSize = UIScreen.main.bounds
            
            // Retrieve the CGPoints containing the normalized X and Y coordinates.
            let imagePoints: [CGPoint] = torsoKeys.compactMap {
                guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
               // print(point.x)
               // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
                //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
               //     calculateAnkle(x: point2.x, y: point2.y)
               //     return VNImagePointForNormalizedPoint(point2.location,
                    //                                      Int(screenSize.width),
                   //                                       Int(screenSize.height))
                //}
               // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
               //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
                  //  calculateShoulder(x: point3.x, y: point3.y)
                   // print(point3.x)
                 ///   return VNImagePointForNormalizedPoint(point3.location,
                    //                                      Int(screenSize.width),
                    //                                      Int(screenSize.height))
                
        
               // print(point.x)
               // print( point.x)
              
              //  gestureProcessor.reset()
                calculateSquats(x: point.x, y: point.y)
                detectedJoints = true
                // Translate the point from normalized-coordinates to image coordinates.
                return VNImagePointForNormalizedPoint(point.location,
                                                      Int(screenSize.width),
                                                      Int(screenSize.height))
            }
    
        
        // Draw the points onscreen.
        // draw(points: imagePoints)
    } else if type == "Planks" {
        let torsoKeys: [VNRecognizedPointKey] = [
            
           // .bodyLandmarkKeyLeftKnee //squats
           // .bodyLandmarkKeyNose //situps
          // .bodyLandmarkKeyLeftEar //pushups
          .bodyLandmarkKeyLeftEye //plank
        ]
        let screenSize = UIScreen.main.bounds
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = torsoKeys.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
           // print(point.x)
           // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
            //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
           //     calculateAnkle(x: point2.x, y: point2.y)
           //     return VNImagePointForNormalizedPoint(point2.location,
                //                                      Int(screenSize.width),
               //                                       Int(screenSize.height))
            //}
           // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
           //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
              //  calculateShoulder(x: point3.x, y: point3.y)
               // print(point3.x)
             ///   return VNImagePointForNormalizedPoint(point3.location,
                //                                      Int(screenSize.width),
                //                                      Int(screenSize.height))
            
    
           // print(point.x)
           // print( point.x)
          
          //  gestureProcessor.reset()
            calculatePlanks(x: point.x, y: point.y)
            detectedJoints = true
            // Translate the point from normalized-coordinates to image coordinates.
            return VNImagePointForNormalizedPoint(point.location,
                                                  Int(screenSize.width),
                                                  Int(screenSize.height))
        }
    } else if type == "Band" {
        let torsoKeys: [VNRecognizedPointKey] = [
            
           // .bodyLandmarkKeyLeftKnee //squats
           // .bodyLandmarkKeyNose //situps
           .bodyLandmarkKeyRightWrist //band
          // .bodyLandmarkKeyLeftEye //plank
        ]
        let screenSize = UIScreen.main.bounds
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = torsoKeys.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
           // print(point.x)
           // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
            //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
           //     calculateAnkle(x: point2.x, y: point2.y)
           //     return VNImagePointForNormalizedPoint(point2.location,
                //                                      Int(screenSize.width),
               //                                       Int(screenSize.height))
            //}
           // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
           //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
              //  calculateShoulder(x: point3.x, y: point3.y)
               // print(point3.x)
             ///   return VNImagePointForNormalizedPoint(point3.location,
                //                                      Int(screenSize.width),
                //                                      Int(screenSize.height))
            
    
           // print(point.x)
           // print( point.x)
          
          //  gestureProcessor.reset()
            calculateBand(x: point.x, y: point.y)
            detectedJoints = true
            // Translate the point from normalized-coordinates to image coordinates.
            return VNImagePointForNormalizedPoint(point.location,
                                                  Int(screenSize.width),
                                                  Int(screenSize.height))
        }
        } else if type == "Curls" {
            let torsoKeys: [VNRecognizedPointKey] = [
                
               // .bodyLandmarkKeyLeftKnee //squats
               // .bodyLandmarkKeyNose //situps
               .bodyLandmarkKeyRightWrist //band
              // .bodyLandmarkKeyLeftEye //plank
            ]
            let screenSize = UIScreen.main.bounds
            
            // Retrieve the CGPoints containing the normalized X and Y coordinates.
            let imagePoints: [CGPoint] = torsoKeys.compactMap {
                guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
               // print(point.x)
               // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
                //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
               //     calculateAnkle(x: point2.x, y: point2.y)
               //     return VNImagePointForNormalizedPoint(point2.location,
                    //                                      Int(screenSize.width),
                   //                                       Int(screenSize.height))
                //}
               // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
               //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
                  //  calculateShoulder(x: point3.x, y: point3.y)
                   // print(point3.x)
                 ///   return VNImagePointForNormalizedPoint(point3.location,
                    //                                      Int(screenSize.width),
                    //                                      Int(screenSize.height))
                
        
               // print(point.x)
               // print( point.x)
              
              //  gestureProcessor.reset()
                calculatePushups(x: point.x, y: point.y)
                detectedJoints = true
                // Translate the point from normalized-coordinates to image coordinates.
                return VNImagePointForNormalizedPoint(point.location,
                                                      Int(screenSize.width),
                                                      Int(screenSize.height))
            }
        
        } else if type == "Lunges" {
            let torsoKeys: [VNRecognizedPointKey] = [
                
               // .bodyLandmarkKeyLeftKnee //squats
               // .bodyLandmarkKeyNose //situps
               .bodyLandmarkKeyLeftKnee //band
              // .bodyLandmarkKeyLeftEye //plank
            ]
            let screenSize = UIScreen.main.bounds
            
            // Retrieve the CGPoints containing the normalized X and Y coordinates.
            let imagePoints: [CGPoint] = torsoKeys.compactMap {
                guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
               // print(point.x)
               // let imagePoints2: [CGPoint] = torsoKeys2.compactMap {
                //    guard let point2 = recognizedPoints[$0], point2.confidence > 0 else { return nil }
               //     calculateAnkle(x: point2.x, y: point2.y)
               //     return VNImagePointForNormalizedPoint(point2.location,
                    //                                      Int(screenSize.width),
                   //                                       Int(screenSize.height))
                //}
               // let imagePoints3: [CGPoint] = torsoKeys3.compactMap {
               //     guard let point3 = recognizedPoints[$0], point3.confidence > 0 else { return nil }
                  //  calculateShoulder(x: point3.x, y: point3.y)
                   // print(point3.x)
                 ///   return VNImagePointForNormalizedPoint(point3.location,
                    //                                      Int(screenSize.width),
                    //                                      Int(screenSize.height))
                
        
               // print(point.x)
               // print( point.x)
              
              //  gestureProcessor.reset()
                calculateLunges(x: point.x, y: point.y)
                detectedJoints = true
                // Translate the point from normalized-coordinates to image coordinates.
                return VNImagePointForNormalizedPoint(point.location,
                                                      Int(screenSize.width),
                                                      Int(screenSize.height))
            }
        
        }
}
    var pitch = 0.0
    var stop = false
    var backStroke = false
    var intialY = 0.0
    var yArray = [Double]()
    var xArray = [Double]()
    var forwardY = [Double]()
    var x = 0.0
    var y = 0.0
    var i = 0.0
    var backtime = 0.0
    var backSpeed = 0.0
    var alreadyContact = false
    var count = 0
    var start = false
    var speed = 0.0
    var forwardPadding = 0
    
    func calculate2(x: Double, y: Double) {
        if y > 0.7 {
            
        }
    }
    var pause = false
    var seventy = false
    var seventyCount = 0
    
    func calculatePlanks(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
           // synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(1000*(y))/1000)
            let roundedX = Double(round(1000*(x))/1000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(1000*(self.intialY-0.05))/1000) && roundedY <= Double(round(1000*(self.intialY+0.05))/1000) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                    if !coolDown {
                    i += 0.1
                   
                    reps += 1
                    self.coolDown = true
               
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.coolDown = false
                        }
                    }
                    
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                if  Double(round(100*(self.yArray.last ?? y))/100) < Double(round(100*(y))/100) {
               // if !self.coolDown{
                   
                  
            //    }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
              // synthesizer.speak(utterance)
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }
    
    func calculateLunges(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
            //synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(10000*(y))/10000)
            let roundedX = Double(round(1000*(x))/1000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(1000*(self.intialY-0.01))/1000) && roundedY <= Double(round(1000*(self.intialY+0.01))/1000) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                    if  Double(round(10*(self.yArray.last ?? y))/10) < Double(round(10*(y))/10) {
                if !self.coolDown{
                i += 1.0
                    reps += 1
                    self.coolDown = true
                print(self.i)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.coolDown = false
                    }
                }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
              // synthesizer.speak(utterance)
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }
    
    func calculateSquats(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
            //synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(10000*(y))/10000)
            let roundedX = Double(round(10000*(x))/10000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(10000*(self.intialY-0.01))/10000) && roundedY <= Double(round(10000*(self.intialY+0.01))/10000) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                    if  Double(round(10*(self.yArray.last ?? y))/10) < Double(round(10*(y))/10) {
                if !self.coolDown{
                i += 1.0
                    reps += 1
                    self.coolDown = true
                print(self.i)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.coolDown = false
                    }
                }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
              // synthesizer.speak(utterance)
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }
    func calculateBand(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
            //synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(10000*(y))/10000)
            let roundedX = Double(round(10000*(x))/10000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(100*(self.intialY-0.05))/100) && roundedY <= Double(round(100*(self.intialY+0.05))/100) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                    if  Double(round(10*(self.yArray.last ?? y))/10) < Double(round(10*(y))/10) {
                if !self.coolDown{
                    i += 0.5
                    let isInteger = floor(i) == i
                    if isInteger {
                    reps += 1
                    }
                    self.coolDown = true
                print(self.i)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.coolDown = false
                    }
                }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
               //synthesizer.speak(utterance)
                   
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }
    func calculatePushups(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
            //synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(10000*(y))/10000)
            let roundedX = Double(round(10000*(x))/10000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(1000*(self.intialY-0.05))/1000) && roundedY <= Double(round(1000*(self.intialY+0.05))/1000) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                    
                    if  Double(round(10*(self.yArray.last ?? y))/10) < Double(round(10*(y))/10) {
                if !self.coolDown{
                    i += 0.5
                    let isInteger = floor(i) == i
                   // if isInteger {
                    reps += 1
                  //  }
                    self.coolDown = true
                print(self.i)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.coolDown = false
                    }
                }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
               //synthesizer.speak(utterance)
                   
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }

    func calculateSitups(x: Double, y: Double) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.start = true
           
        }
        if start {
       count += 1
        if count == 1 {
            let utterance = AVSpeechUtterance(string: "start")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5
            

            let synthesizer = AVSpeechSynthesizer()
           // synthesizer.speak(utterance)
        self.intialY = (y)
        }
            
        let roundedY = Double(round(10000*(y))/10000)
            let roundedX = Double(round(10000*(x))/10000)
        //    print("y")
       // print(roundedY)
            
           // if y > 0.5 {
                
            if roundedY >= Double(round(1000*(self.intialY-0.03))/1000) && roundedY <= Double(round(1000*(self.intialY+0.03))/1000) {
                
                //seventy = true
                
               print("contact")
                if !yArray.isEmpty {
                let speed = self.yArray.max()! - self.yArray.min()!
                
                y2 = speed*5000
                x2 = roundedX*10
                //let bowl = Bowling(id: UUID().uuidString, name: "", pins: 0, x: x2, y: y2, date: NSDate().timeIntervalSince1970)
                    if  Double(round(10*(self.yArray.last ?? y))/10) < Double(round(10*(y))/10) {
                if !self.coolDown {
                    i += 0.5
                    let isInteger = floor(i) == i
                    if isInteger {
                    reps += 1
                        if reps > 5 {
                            complete = true
                        }
                    }
                    self.coolDown = true
                print(self.i)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.coolDown = false
                    }
                }
                let utterance = AVSpeechUtterance(string: "\(Int(self.i))")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.5
                

                let synthesizer = AVSpeechSynthesizer()
              // synthesizer.speak(utterance)
            }
            }
            }
           // if seventy {
      
           
            yArray.append(roundedY)
            xArray.append(roundedX)
          
            
    }
    }
    var coolDown = false
    var counting = 0
     func createCSV() {
        let fileName = getDocumentsDirectory().appendingPathComponent("OutputD.csv")
        var csvOutputText = "Y, X\n"
        yArray.forEach { result in
            let newLine = "\(String(describing: result)), \(String(describing: xArray[counting]))\n"
            csvOutputText.append(newLine)
            counting += 1
        }
        do {
            try csvOutputText.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        let activity = UIActivityViewController(activityItems: [fileName], applicationActivities: nil)
        present(activity, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


    
    var ankleI = 0.0
    func calculateAnkle(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
           // self.start = true
        }
        //print(x)
        if y > 0.5 {
       x2 = y*750
        } else  {
            x2 = -y*750
        }
        //print("x2")
            //print(y)
      
    }
    

     func create(pixelBuffer: CVPixelBuffer) -> CGImage? {
      var cgImage: CGImage?
      VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
      return cgImage
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
extension CGImage {
  /**
    Creates a new CGImage from a CVPixelBuffer.
    - Note: Not all CVPixelBuffer pixel formats support conversion into a
            CGImage-compatible pixel format.
  */
 

  /*
  // Alternative implementation:
  public static func create(pixelBuffer: CVPixelBuffer) -> CGImage? {
    // This method creates a bitmap CGContext using the pixel buffer's memory.
    // It currently only handles kCVPixelFormatType_32ARGB images. To support
    // other pixel formats too, you'll have to change the bitmapInfo and maybe
    // the color space for the CGContext.
    guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) else {
      return nil
    }
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
    if let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                               width: CVPixelBufferGetWidth(pixelBuffer),
                               height: CVPixelBufferGetHeight(pixelBuffer),
                               bitsPerComponent: 8,
                               bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                               space: CGColorSpaceCreateDeviceRGB(),
                               bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue),
       let cgImage = context.makeImage() {
      return cgImage
    } else {
      return nil
    }
  }
  */

  /**
   Creates a new CGImage from a CVPixelBuffer, using Core Image.
  */

}
struct WorkoutView: UIViewControllerRepresentable {
    
  
   @State var type = "Situps"
    
    func makeUIViewController(context: Context)-> WorkoutViewController {
        let controller = WorkoutViewController()
        //controller.delegate = context.coordinator
        controller.type = type
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: WorkoutViewController, context: Context) {}
    
   
}


var reps = 0
var x2 = 0.0
var y2 = 0.0
var detectedJoints = false
var complete = false
var counting1 = 0
