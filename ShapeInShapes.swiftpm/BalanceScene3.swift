//
//  BalanceScene3.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 20/04/22.
//

import SpriteKit
import SwiftUI

class BalanceScene3: SKScene {
    
    // Animations
    var fadeIn = SKAction.fadeIn(withDuration: 0.8)
    var fadeOut = SKAction.fadeOut(withDuration: 0.5)
    var fadeInAlphaMask = SKAction.fadeAlpha(to: 0.2, duration: 0.8)
    var scale = SKAction.scale(by: 2, duration: 2)
    
    var balanceTxt: SKSpriteNode!
    
    var mrCircle: SKSpriteNode!
    
    var mask: SKShapeNode!
    var background: SKShapeNode!
    var shapes: [SKShapeTM] = []
    var limitShape: SKShapeNode!
    var slotShapes: [SKShapeSlot] = []
    var redFrame: SKShapeNode!
    var dialogue: SKSpriteNode!
    
    var showLimitAndSlot = false {
        didSet {
            self.limitShape?.fillColor = showLimitAndSlot ? UIColor.init(red: 240/255, green: 220/255, blue: 220/255, alpha: 1) : UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
            for shape in slotShapes {
                shape.fillColor = showLimitAndSlot ? UIColor.init(red: 20/255, green: 220/255, blue: 220/255, alpha: 1) : UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
            }
        }
    }
    
    var won:Bool {
        for slot in slotShapes {
            let shape = nodes(at: slot.position).first as? SKShapeTM
            guard let shape = shape,
                  shape.isRightSlot(node: slot) else {return false}
        }
        return true
    }
    
    
    var isFirstTouch = true
    var isOnIntroduction = false
    /// Pode mover o círculo ou não após a interação inicial
    var canMove: Bool = true
    
    var numberOfFilledSlots: Int = 0
    var dialogueIndex: Int = 1
    
    var heldNode: SKNode?
    
    override func didMove(to view: SKView) {
        
        // Cria o cenário
        createBalanceTxt(position: CGPoint(x: 0, y: (frame.maxY) * 0.83))
        createBackground()
        
        createLimit()
        
        // Cria os círculos arrastáveis
        createRedCircle(position: CGPoint(x: 000, y: (limitShape.frame.midY) - 150), size: 100.0, name: "largeCircle", rigthSlotName: "largeSlot")
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 150, y:(limitShape.frame.minY) + 390), size: 45.0, name: "smallCircle", rigthSlotName: "smallSlot")
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 150, y:(limitShape.frame.minY) + 550), size: 45.0, name: "smallCircle", rigthSlotName: "smallSlot")
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 300, y:(limitShape.frame.minY) + 680), size: 45.0, name: "smallCircle", rigthSlotName: "smallSlot")
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 450, y:(limitShape.frame.minY) + 680), size: 45.0, name: "smallCircle", rigthSlotName: "smallSlot")
        createRedCircle(position: CGPoint(x: 000, y:(limitShape.frame.minY) + 70), size: 45.0, name: "smallCircle", rigthSlotName: "smallSlot")
        
        // Cria os círculos encaixes
        createSlotCircle(position: CGPoint(x: 0, y: (limitShape.frame.midY) + 150), size: 30.0, name: "largeSlot")
        createSlotCircle(position: CGPoint(x: 0, y: (limitShape.frame.midY) - 150), size: 30.0, name: "smallSlot")
        createSlotCircle(position: CGPoint(x: 115, y: (limitShape.frame.midY) - 150), size: 30.0, name: "smallSlot")
        createSlotCircle(position: CGPoint(x: 230, y: (limitShape.frame.midY) - 150), size: 30.0, name: "smallSlot")
        createSlotCircle(position: CGPoint(x: -115, y: (limitShape.frame.midY) - 150), size: 30.0, name: "smallSlot")
        createSlotCircle(position: CGPoint(x: -230, y: (limitShape.frame.midY) - 150), size: 30.0, name: "smallSlot")
    }
    
    func createBalanceTxt(position: CGPoint) {
        let texture = SKTexture(imageNamed: "balanceTxt")
        
        let size = CGSize(width: 2048, height: 511)
        
        balanceTxt = SKSpriteNode(texture: texture, size: size)
        
        balanceTxt.setScale(0.5)
        
        balanceTxt.zPosition = -90
        balanceTxt.position = position
        
        
        balanceTxt.name = "text"
        
        self.addChild(balanceTxt)
    }
    
    func createMask() {
        mask = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        
        mask.fillColor = .white
        mask.strokeColor = .clear
        mask.alpha = 0
        
        mask.zPosition = -1
        mask.position = CGPoint(x: 0, y: 0)
        
        mask.name = "mask"
        
        mask.run(fadeInAlphaMask)
        
        self.addChild(mask)
        
    }
    
    func createBackground() {
        background = SKShapeNode(circleOfRadius: 1000.0)
        
        background.fillColor = UIColor.init(red: 173/255, green: 37/255, blue: 37/255, alpha: 1)
        background.strokeColor = .clear
        
        background.zPosition = -100
        background.position = CGPoint(x: 0, y: 0)
        
        background.name = "background"
        
        self.addChild(background)
    }
    
    func createMrCircle(position: CGPoint) {
        let texture = SKTexture(imageNamed: "mrShape")
        
        let size = CGSize(width: 1224/5, height: 1585/5)
        
        mrCircle = SKSpriteNode(texture: texture, size: size)
        
        mrCircle.zPosition = -5
        mrCircle.position = position
        
        mrCircle.name = "mrShape"
        
        self.addChild(mrCircle)
    }
    
    func createRedCircle(position: CGPoint, size: CGFloat, name: String, rigthSlotName:String) {
        let shape = SKShapeTM(circleOfRadius: size)
        //shape.name = "forma"
        shape.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        shape.strokeColor = .clear
        shape.alpha = 0.85
        
        shape.zPosition = -10
        shape.originalPosition = position
        shape.limitNode = limitShape
        shape.rightSlotName = rigthSlotName
        
        let body = SKPhysicsBody(rectangleOf: shape.frame.size)
        body.affectedByGravity = false
        shape.physicsBody = body
        
        shape.name = name
        
        self.addChild(shape)
        shapes.append(shape)
    }
    
    func createSlotCircle(position: CGPoint, size: CGFloat, name: String) {
        let slotShape = SKShapeSlot(circleOfRadius: size)
        slotShape.fillColor = UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
        slotShape.strokeColor = .clear //UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
        
        slotShape.zPosition = -15
        slotShape.position = position
        
        slotShape.name = name
        
        slotShape.alpha = 1
        self.addChild(slotShape)
        
        slotShapes.append(slotShape)
    }
    
    func createLimit() {
        
        let minSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let square = SKShapeNode(rectOf: CGSize(width: minSize, height: minSize))
        
        square.position.y = -40
        square.zPosition = -50
        square.name = "quadrado"
        square.fillColor = UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
        square.strokeColor = .clear
        square.alpha = 1
        self.limitShape = square
        self.addChild(square)
    }
    
    //    func createRedFrame(position: CGPoint) {
    //        let minSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    //        let rectangle = SKShapeNode(rectOf: CGSize(width: minSize, height: minSize))
    //        rectangle.fillColor = .magenta
    //        rectangle.strokeColor = .magenta
    //
    //        rectangle.zPosition = -60
    //        rectangle.position = position
    //
    //        self.redFrame = rectangle
    //        self.addChild(rectangle)
    //
    //    }
    
    func createDialogue() {
        let texture = SKTexture(imageNamed: "dialogue3balance\(dialogueIndex)")
        let size = CGSize(width: 1960, height: 850)
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.alpha = 0
        
        dialogue.setScale(0.35)
        
        dialogue.name = "dialogoFinal"
        dialogue.zPosition = 10
        dialogue.position = CGPoint(x: 0, y: (frame.minY) * 0.65)
        
        dialogue.run(fadeIn)
        
        self.addChild(dialogue)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // pega a posiçào
            let touchPosition = touch.location(in: self)
            
            // pega os nós que estão sendo tocados
            let touchedNodes = self.nodes(at: touchPosition)
            
            // para cada um dos nós...
            for node in touchedNodes {
                if node.name == "smallCircle" || node.name == "largeCircle" {
                    heldNode = node
                }
                if canMove {
                    return
                }
            }
            
            if dialogueIndex > 1 && dialogueIndex < 5 {
                print(dialogueIndex)
                let texture = SKTexture(imageNamed: "dialogue3balance\(dialogueIndex)")
                dialogue.texture = texture
                
                dialogueIndex += 1
            }
            else if dialogueIndex >= 5 {
                // criar a cena
                let sceneSize = CGSize(width: self.size.width, height: self.size.height)
                let scene = PatternScene1(size: sceneSize)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                // mostras próxima cena
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.25))
                //self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.5))
            }
            
        }
        
    }
    
    func cleanEmptySlots() {
        for slot in slotShapes {
            if let _ = nodes(at: slot.position).first as? SKShapeTM {
                slot.alreadyFilled = true
            } else {
                slot.alreadyFilled = false
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        showLimitAndSlot = false
        heldNode = nil
        if canMove == false { return }
        shapes.forEach { $0.returnToOriginIfOffLimits() }
        // for shape in shapes {
        //   shape.returnToOriginIfOffLimits()
        // }
        
        guard let location = touches.first?.location(in: self),
              let shape = nodes(at: location).first as? SKShapeTM else {
            cleanEmptySlots()
            return
            
        }
        
        let body = SKPhysicsBody(rectangleOf: shape.frame.size)
        body.affectedByGravity = false
        shape.physicsBody = body
        
        let intersectSlots = slotShapes.filter { $0.intersects(shape) } // filtra os nós embaixo do shape
            .filter {!$0.alreadyFilled} // retira os já preenchidos
        
        guard let intersectSlot = intersectSlots.first else {
            cleanEmptySlots()
            return
            
        }
        
        shape.position = intersectSlot.position
        shape.physicsBody = nil
        cleanEmptySlots()
        
        if shape.isRightSlot(node: intersectSlot) {
            //shape.name = "noName"
            
        } else {
        }
        
        print(won)
        if won {
            presentWon()
        }
    }
    
    
    func presentWon() {
        
        print(numberOfFilledSlots)
        
        canMove = false
        
        //createMrCircle(position: CGPoint(x: 0.0, y: -150.0))
        
        createMask()
        
        createDialogue()
        
        print(dialogueIndex)
        
        dialogueIndex += 1
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(#function)
        // para cada um dos toques...
        for touch in touches {
            // peguei a posição do toque
            let touchPosition = touch.location(in: self)
            
            guard let node = (heldNode as? SKShapeTM),
                  node.canMove else {return}
            
            if (heldNode?.name ?? "").hasSuffix("Circle") && canMove == true {
                if self.limitShape.contains(touchPosition) {
                    heldNode?.position = touchPosition
                    showLimitAndSlot = true
                }
                else {
                    showLimitAndSlot = false
                }
            }
        }
        
    }
    
}

