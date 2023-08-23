//
//  StrokeColorAnimation.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//

import UIKit

class StrokeColorAnimation: CAKeyframeAnimation {
    
    override init() {
        super.init()
    }
    
    init(colors: [CGColor], duration: Double) {
        
        super.init()
        
        self.keyPath = "strokeColor"
        self.values = colors
        self.duration = duration
        self.repeatCount = .greatestFiniteMagnitude
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
