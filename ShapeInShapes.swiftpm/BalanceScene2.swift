//
//  BalanceScene2.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 20/04/22.
//

import SpriteKit
import SwiftUI

class BalanceScene2: SKScene {
    
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
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 150, y:(limitShape.frame.minY) + 130), size: 100.0, name: "largeCircle", rigthSlotName: "largeSlot")
        createRedCircle(position: CGPoint(x: (limitShape.frame.maxX) - 150, y:(limitShape.frame.minY) + 390), size: 100.0, name: "largeCircle", rigthSlotName: "largeSlot")
        
        
        
        // Cria os círculos encaixes
        createSlotCircle(position: CGPoint(x: (limitShape.frame.midX) + 120, y: (limitShape.frame.midY) + 150), size: 30.0, name: "largeSlot")
        createSlotCircle(position: CGPoint(x: (limitShape.frame.midX) - 120, y: (limitShape.frame.midY) - 150), size: 30.0, name: "largeSlot")
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
    
    func createMask(alpha: CGFloat = 0) {
        mask = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        
        mask.fillColor = .white
        mask.strokeColor = .clear
        mask.alpha = alpha
        
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
        let texture = SKTexture(imageNamed: "dialogue2balance\(dialogueIndex)")
        let size = CGSize(width: 1960, height: 850)
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.setScale(0.35)
        
        dialogue.alpha = 0
        
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
            if dialogueIndex > 1 && dialogueIndex < 3 {
                print(dialogueIndex)
                let texture = SKTexture(imageNamed: "dialogue2balance\(dialogueIndex)")
                dialogue.texture = texture
                
                dialogueIndex += 1
            }
            else if dialogueIndex >= 3 {
                // criar a cena
                let sceneSize = CGSize(width: self.size.width, height: self.size.height)
                let scene = BalanceScene3(size: sceneSize)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                // mostras próxima cena
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.25))
                //self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.25))
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
            .filter {!$0.alreadyFilled} // retura os já preenchidos
        
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




//class BalanceScene2: SKScene {
//
//    var mrCircle: SKSpriteNode!
//
//    var background: SKShapeNode!
//    var shapes: [SKShapeNode] = []
//    var limitShape: SKShapeNode!
//    var slotShapes: [SKShapeNode] = []
//    var redFrame: SKShapeNode!
//    var dialogue: SKSpriteNode!
//
//    var showLimitAndSlot = false {
//        didSet {
//            self.limitShape?.alpha = showLimitAndSlot ? 1 : 0
//            for shape in slotShapes {
//                shape.alpha = showLimitAndSlot ? 1 : 0
//            }
//        }
//    }
//
//
//    var isFirstTouch = true
//    var isOnIntroduction = false
//    /// Pode mover o círculo ou não após a interação inicial
//    var canMove: Bool = true
//
//    var indexDialogue: Int = 1
//
//    var heldNode: SKNode?
//
//    override func didMove(to view: SKView) {
//        createBackground()
//
//        createLimit()
//        //createRedFrame(position: CGPoint(x: 0.0, y: -300.0))
//        createRedCircle(position: CGPoint(x: -134.5, y: 230.0))
//        createRedCircle(position: CGPoint(x: 207.0, y: -269.0))
//
//        createSlotCircle(position: CGPoint(x: 80, y: 80))
//        createSlotCircle(position: CGPoint(x: -80, y: -80))
//    }
//
//    func createBackground() {
//        background = SKShapeNode(circleOfRadius: 1000.0)
//
//        background.fillColor = UIColor.init(red: 250, green: 250, blue: 250, alpha: 1)
//        background.strokeColor = UIColor.init(red: 250, green: 250, blue: 250, alpha: 1)
//
//        background.zPosition = -100
//        background.position = CGPoint(x: 0, y: 0)
//
//        background.name = "background"
//
//        self.addChild(background)
//    }
//
//    func createMrCircle(position: CGPoint) {
//        let texture = SKTexture(imageNamed: "mrShape")
//
//        let size = CGSize(width: 195.825, height: 282.975)
//
//        mrCircle = SKSpriteNode(texture: texture, size: size)
//
//        mrCircle.zPosition = -5
//        mrCircle.position = position
//
//        mrCircle.name = "mrShape"
//
//        self.addChild(mrCircle)
//    }
//
//    func createRedCircle(position: CGPoint) {
//        let shape = SKShapeTM(circleOfRadius: 80.0)
//        shape.name = "forma"
//        shape.fillColor = .red
//        shape.strokeColor = .red
//
//        shape.zPosition = -10
//        shape.position = position
//
//        self.addChild(shape)
//        shapes.append(shape)
//    }
//
//    func createSlotCircle(position: CGPoint) {
//        let slotShape = SKShapeNode(circleOfRadius: 30.0)
//        slotShape.fillColor = UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
//        slotShape.strokeColor = UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
//
//        slotShape.zPosition = -15
//        slotShape.position = position
//
//        slotShape.alpha = 0
//        self.addChild(slotShape)
//
//        slotShapes.append(slotShape)
//    }
//
//    func createLimit() {
//
//        let minSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
//        let square = SKShapeNode(rectOf: CGSize(width: minSize, height: minSize))
//        square.zPosition = -50
//        square.name = "quadrado"
//        square.fillColor = UIColor.init(red: 240, green: 240, blue: 240, alpha: 1)
//        square.strokeColor = UIColor.init(red: 171, green: 171, blue: 171, alpha: 1)
//        square.alpha = 0
//        self.limitShape = square
//        self.addChild(square)
//    }
//
//    func createRedFrame(position: CGPoint) {
//        let minSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
//        var rectangle = SKShapeNode(rectOf: CGSize(width: minSize, height: minSize))
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
//
//    func createDialogue() {
//        let texture = SKTexture(imageNamed: "dialoguebalance\(indexDialogue)")
//        let size = CGSize(width: 456, height: 99.25)
//        dialogue = SKSpriteNode(texture: texture, size: size)
//
//        dialogue.name = "dialogoFinal"
//        dialogue.zPosition = 10
//        dialogue.position = CGPoint(x: 0, y: -275.0)
//
//        self.addChild(dialogue)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            // pega a posiçào
//            let touchPosition = touch.location(in: self)
//
//            // pega os nós que estão sendo tocados
//            let touchedNodes = self.nodes(at: touchPosition)
//
//            // para cada um dos nós...
//            for node in touchedNodes {
//                if node.name == "forma" {
//                    heldNode = node
//                }
//                if canMove == true {
//                    return
//                }
//
//                if indexDialogue > 1 && indexDialogue < 3 {
//                    createDialogue()
//
//                    indexDialogue += 1
//                }
//                if indexDialogue == 3 {
//                    // criar a cena
//                    let sceneSize = CGSize(width: self.size.width, height: self.size.height)
//                    let scene = BalanceScene3(size: sceneSize)
//                    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//
//                    // mostras próxima cena
//                    self.view?.presentScene(scene)
//                }
//
//            }
//        }
//    }
//
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(#function)
//        showLimitAndSlot = false
//        heldNode = nil
//        if canMove == false {
//            return
//        }
//
//        for shape in shapes {
//            for slotShape in slotShapes {
//                if shape.intersects(slotShape) {
//
//                    shape.position = slotShape.position
//                    (shape as? SKShapeTM)?.canMove = false
//
//                    // tira o forma encaixe do formasEncaixe
//                    slotShapes = slotShapes.filter({$0 != slotShape})
//
//                }
//            }
//        }
//
//
//        if slotShapes.count == 0 {
//            canMove = false
//
//            createMrCircle(position: CGPoint(x: 0.0, y: -150.0))
//
//            createDialogue()
//
//            indexDialogue += 1
//        }
//
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(#function)
//        // para cada um dos toques...
//        for touch in touches {
//            // peguei a posição do toque
//            let touchPosition = touch.location(in: self)
//
//            guard let node = (heldNode as? SKShapeTM),
//                  node.canMove else {return}
//
//            if (heldNode?.name ?? "").starts(with: "forma") && canMove == true {
//                if self.limitShape.contains(touchPosition) {
//                    heldNode?.position = touchPosition
//                    showLimitAndSlot = true
//
//                    print(heldNode?.position)
//                }
//                else {
//                    showLimitAndSlot = false
//                }
//            }
//        }
//    }
//
//}
//
