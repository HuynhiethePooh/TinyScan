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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    
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
        
            guard let ciImage = CIImage(image:userPickedImage) else {
                fatalError("cannot convert to CI Image")
            }
            
            detect(image: ciImage)
            
        imageView.image = userPickedImage
        
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: TinyTownsClassifier().model) else{
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request,error) in
            let classification = request.results?.first as? VNClassificationObservation
            
            print(classification?.identifier ?? "null")
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
    
    
    @IBAction func calculate(_ sender: Any) {
        //create tinyTown in here atm, move into creating town when image is loaded eventually
        let tinyTown = TinyTown()
        print("calculating...")
        tinyTown.calculate(town: tinyTown.board)
        
        
        
    }
}

