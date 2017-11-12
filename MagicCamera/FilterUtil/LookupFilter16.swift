//
//  LookupFilter16.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/19.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import GPUImage

public class LookupFilter16: BasicOperation {
    public var intensity:Float = 1.0 { didSet { uniformSettings["intensity"] = intensity } }
    public var lookupImage:PictureInput? { // TODO: Check for retain cycles in all cases here
        didSet {
            lookupImage?.addTarget(self, atTargetIndex:1)
            lookupImage?.processImage()
        }
    }
    
    public init() {
//        let str = NSString(cont)
        
        let fragStringP = Bundle.main.path(forResource: "lookup16Fragment", ofType: "glsl")
        var fragmentShader : String! = nil
        do {
            fragmentShader = try String(contentsOfFile: fragStringP!)

        }catch{
            print("read shader error")
        }

        super.init(fragmentShader:fragmentShader, numberOfInputs:2)
        
        ({intensity = 1.0})()
    }
    deinit {
        
        print("dealloc filter")
    }
}
