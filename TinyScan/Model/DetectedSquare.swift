//
//  DetectedSquare.swift
//  TinyScan
//
//  Created by Dan Huynh on 12/20/21.
//  Copyright © 2021 Dan Huynh. All rights reserved.
//

import Foundation
import Metal
import CoreGraphics

public class DetectedSquare {
        
    let type : String
    
    let coords : CGPoint
    
    public init(name: String, xy : CGPoint){
        type = name
        coords = xy
    }
}
