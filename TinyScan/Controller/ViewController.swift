//
//  ViewController.swift
//  TinyScan
//
//  Created by Dan Huynh on 12/22/20.
//  Copyright © 2020 Dan Huynh. All rights reserved.
//

import UIKit
import CoreML
import Vision
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    var detectedBoard : [DetectedSquare] = []
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
    }
    
    //what happens when the image is picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
            guard let ciImage = CIImage(image:userPickedImage,
                                        options: [.applyOrientationProperty:true ] ) else {
                fatalError("cannot convert to CI Image")
            }

            detect(image: ciImage)
            
        imageView.image = userPickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: TinyTownsDetector().model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model:model) { (request,error) in
            let classification = request.results as! [VNRecognizedObjectObservation]
        
            print("size is:", request.results?.count ?? 0)
            print("Image has been taken")
            
            for number in 0...(request.results!.count - 1){
                let madesquare = DetectedSquare(name: classification[number].labels[0].identifier, xy: CGPoint(x:classification[number].boundingBox.minX, y:classification[number].boundingBox.minY) )
                self.detectedBoard.append(madesquare)
            }

            for element in self.detectedBoard {
                print("Type: ", element.type, "Coord: ", element.coords)
            }
            //sort by y and influencing a bit of x to deal for small variances in height
            self.detectedBoard.sort{
                ($0.coords.y + ($0.coords.x * 0.2)) < ($1.coords.y + ($1.coords.x * 0.2))
            }
            for element in self.detectedBoard {
                print("Type: ", element.type, "Coord: ", element.coords)
            }
//            print("Square 1 is: ", classification.ide ?? "narks")
            
            
//            for squares in request.results ?? [] {
//                let printMe = squares as? VNClassificationObservation
//                print(printMe?.identifier ?? "couldn't figure out")
//            }
            
//            print("This is the square:", classification?.identifier ?? "null")
        }
            let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func overlay<T, U>(_ array: [[T]], values: [U]) -> [[U]] {
        var iter = values.makeIterator()
        return array.map { $0.compactMap { _ in iter.next() }}
    }
    
    @IBAction func calculate(_ sender: Any) {
        //create tinyTown in here atm, move into creating town when image is loaded eventually
        let tinyTown = TinyTown()
        print("sorted board: ", overlay(tinyTown.board, values: self.detectedBoard))
        print("calculating...")
        tinyTown.calculate(town: tinyTown.board)
        
        
        
    }
}

