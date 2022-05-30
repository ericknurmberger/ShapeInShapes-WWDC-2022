//
//  File.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 19/04/22.
//

import Foundation
import SpriteKit

class SKShapeTM:SKShapeNode {
    var canMove = true
    var rightSlotName:String = ""
    
    var originalPosition:CGPoint = .zero {
        didSet {
            self.position = originalPosition
        }
    }
    
    var limitNode:SKNode?
    
    func returnToOriginIfOffLimits() {
        guard let node = limitNode else {return}
        if !self.intersects(node) {
            self.returnToOrigin()
        }
    }
    
    func returnToOrigin(){
        let anime = SKAction.move(to: originalPosition, duration: 0.2)
        self.run(anime)
    }
    
    func isRightSlot(node:SKShapeSlot)->Bool {
        return self.rightSlotName == node.name
    }
    
}
