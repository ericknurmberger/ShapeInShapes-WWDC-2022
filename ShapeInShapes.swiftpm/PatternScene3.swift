//
//  BalanceScene3.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 20/04/22.
//

import SpriteKit
import SwiftUI

class PatternScene3: SKScene {
    
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
    var box: SKSpriteNode!
    
    var showLimitAndSlot = false {
        didSet {
            self.limitShape?.fillColor = showLimitAndSlot ? UIColor.init(red: 240/255, green: 220/255, blue: 220/255, alpha: 1) : UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
            self.box.alpha = showLimitAndSlot ? 0.5 : 1
            for shape in slotShapes {
                shape.fillColor = showLimitAndSlot ? UIColor.init(red: 20/255, green: 220/255, blue: 220/255, alpha: 1) : UIColor.init(red: 252/255, green: 219/255, blue: 219/255, alpha: 1)
            }
        }
    }
    
    var won:Bool {
        for slot in slotShapes {
            if slot.name == "ignoredSlot" {
                continue
            }
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
        createPatternTxt(position: CGPoint(x: 0, y: (frame.maxY) * 0.83))
        createBackground()
        
        createLimit()
        
        // Cria a caixa
        createSlotBox()
        
        // Cria o grid
        createShapesGrid()
        
        // Cria as formas arrastáveis
        createTriangle(position: CGPoint(x: (box.frame.midX) - 200, y: box.frame.midY), size: 72.0, rigthSlotName: "slotRedTriangle", color: .red, canMove: true)
        createTriangle(position: CGPoint(x: (box.frame.midX) + 100, y: box.frame.midY), size: 72.0, rigthSlotName: "slotGreenTriangle", color: .green, canMove: true)
        createUpsideDownTriangle(position: CGPoint(x: (box.frame.midX) + 200, y: box.frame.midY), size: 72.0, rigthSlotName: "slotBlueTriangle", color: .blue, canMove: true)
        // Formas extras
        createTriangle(position: CGPoint(x: 0, y: box.frame.midY), size: 72.0, rigthSlotName: "doesntMatter", color: .blue, canMove: true)
        createUpsideDownTriangle(position: CGPoint(x: (box.frame.midX) - 100, y: box.frame.midY), size: 72.0, rigthSlotName: "doesntMatter", color: .red, canMove: true)
        
        // Cria os círculos encaixes
        createSlotCircle(position: CGPoint(x: (box.frame.midX) - 200, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
        createSlotCircle(position: CGPoint(x: (box.frame.midX) - 100, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
        createSlotCircle(position: CGPoint(x: 0, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
        createSlotCircle(position: CGPoint(x: (box.frame.midX) + 100, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
        createSlotCircle(position: CGPoint(x: (box.frame.midX) + 200, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
    }
    
    func createPatternTxt(position: CGPoint) {
        let texture = SKTexture(imageNamed: "patternTxt")
        
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
    
    func createCircle(position: CGPoint, size: CGFloat, name: String = "circle", rigthSlotName:String = "slotCircle", color: SKColor, canMove: Bool = false, hasPhysics: Bool = true) {
        let shape = SKShapeTM(circleOfRadius: size)
        //shape.name = "forma"
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.85
        
        shape.zPosition = -10
        shape.originalPosition = position
        shape.limitNode = limitShape
        shape.rightSlotName = rigthSlotName
        
        if hasPhysics {
            let body = SKPhysicsBody(rectangleOf: shape.frame.size)
            body.affectedByGravity = false
            shape.physicsBody = body
            shape.physicsBody?.allowsRotation = false
            shape.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0.0, upperLimit: 0.0))]
        }
        
        shape.name = name
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
    }
    
    func createSquare(position: CGPoint, size: CGSize, name: String = "square", rigthSlotName:String = "slotSquare", color: SKColor, canMove:Bool = false, hasPhysics: Bool = true) {
        let shape = SKShapeTM(rectOf: size)
        
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.85
        
        shape.zPosition = -10
        shape.originalPosition = position
        shape.limitNode = limitShape
        shape.rightSlotName = rigthSlotName
        
        if hasPhysics {
            let body = SKPhysicsBody(rectangleOf: shape.frame.size)
            body.affectedByGravity = false
            shape.physicsBody = body
            shape.physicsBody?.allowsRotation = false
            shape.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0.0, upperLimit: 0.0))]
        }
        
        shape.name = name
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
        
    }
    
    func createUpsideDownTriangle(position: CGPoint, size: CGFloat, name: String = "upsideDownTriangle", rigthSlotName:String = "slotUpsideDownTriangle", color: SKColor, canMove: Bool = false, hasPhysics: Bool = true) {
     let path = UIBezierPath()
//     firstpoint: CGPoint, secondpoint: CGPoint, thirdpoint: CGPoint
//      cria os pontos e conecta eles como linha
     path.move(to: CGPoint(x: size/2, y: size/2))
     path.addLine(to: CGPoint(x: 0, y: -size/2))
     path.addLine(to: CGPoint(x: -size/2, y: size/2))
     path.addLine(to: CGPoint(x: size/2, y: size/2))
     let shape = SKShapeTM(path: path.cgPath)
     
     shape.fillColor = color
     shape.strokeColor = color
     shape.alpha = 0.85
     
     shape.zPosition = -10
     shape.position = position
     
     shape.originalPosition = position
     shape.limitNode = limitShape
     shape.rightSlotName = rigthSlotName
     
        if hasPhysics {
            let body = SKPhysicsBody(rectangleOf: shape.frame.size)
            body.affectedByGravity = false
            shape.physicsBody = body
            shape.physicsBody?.allowsRotation = false
            shape.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0.0, upperLimit: 0.0))]
        }
     
     shape.name = name
     
     shape.canMove = canMove
     
     self.addChild(shape)
     shapes.append(shape)
     }
    
    func createTriangle(position: CGPoint, size: CGFloat, name: String = "triangle", rigthSlotName:String = "slotTriangle", color: SKColor, canMove: Bool = false, hasPhysics: Bool = true) {
        let path = UIBezierPath()
        //firstpoint: CGPoint, secondpoint: CGPoint, thirdpoint: CGPoint
        // cria os pontos e conecta eles como linha
        path.move(to: CGPoint(x: -size/2, y: -size/2))
        path.addLine(to: CGPoint(x: 0, y: size/2))
        path.addLine(to: CGPoint(x: size/2, y: -size/2))
        path.addLine(to: CGPoint(x: -size/2, y: -size/2))
        let shape = SKShapeTM(path: path.cgPath)
        
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.85
        
        shape.zPosition = -10
        shape.position = position
        
        shape.originalPosition = position
        shape.limitNode = limitShape
        shape.rightSlotName = rigthSlotName
        
        if hasPhysics {
            let body = SKPhysicsBody(rectangleOf: shape.frame.size)
            body.affectedByGravity = false
            shape.physicsBody = body
            shape.physicsBody?.allowsRotation = false
            shape.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0.0, upperLimit: 0.0))]
        }
        
        shape.name = name
        
        shape.canMove = canMove
        
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
        let texture = SKTexture(imageNamed: "dialogue3pattern\(dialogueIndex)")
        let size = CGSize(width: 1960, height: 850)
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.alpha  = 0
        
        dialogue.setScale(0.35)
        
        dialogue.name = "dialogoFinal"
        dialogue.zPosition = 10
        dialogue.position = CGPoint(x: 0, y: (frame.minY) * 0.65)
        
        dialogue.run(fadeIn)
        
        self.addChild(dialogue)
    }
    
    func createSlotBox() {
        let texture = SKTexture(imageNamed: "slotBox")
        let size = CGSize(width: 1546, height: 526)
        box = SKSpriteNode(texture: texture, size: size)
        
        box.setScale(0.4)
        
        box.alpha = 1
        
        box.name = "box"
        box.zPosition = -15
        box.position = CGPoint(x: 0, y: (frame.minY) * 0.55)
        
        self.addChild(box)
    }
    
    func createShapesGrid() {
        let spacing = 120
        
        let inicialPosX = Int(self.frame.midX - CGFloat(spacing)*2.5)
        let inicialPosY = Int(self.frame.midY - CGFloat(spacing))
        
        
        
        for i in 0...5 {
            let posX = inicialPosX + i*spacing
            
            for j in 0...3 {
                let objIndex = i%3
                let posY = inicialPosY + j*spacing
                
                let size = CGFloat(spacing)*0.3
                
                switch(i, j) {
                case (3, 1), (2, 3), (1, 0):
                    if objIndex == 0 {
                        createSlotCircle(position: CGPoint(x: posX, y: posY), size: size/2, name: "slotRedTriangle")
                    }
                    else if objIndex == 1 {
                        createSlotCircle(position: CGPoint(x: posX, y: posY), size: size/2, name: "slotGreenTriangle")
                    }
                    else if objIndex == 2 {
                        createSlotCircle(position: CGPoint(x: posX, y: posY), size: size/2, name: "slotBlueTriangle")
                    }
                    
                    print(position)
                    print(size)
                    
                    //createCircle(position: CGPoint(x: posX, y: posY), size: size, color: .yellow, canMove: true)
                    //createCorrectCircle(position: CGPoint(x: posX, y: posY), size: size, rightSlotName: "notTheOne", color: .red)
                    /*createSlotCircle(position: CGPoint(x: posX, y: posY), size: size, name: objIndex == 0 ? "circleSlot": "squareSlot")*/
                default:
                    if objIndex == 0 {
                        createTriangle(position: CGPoint(x: posX, y: posY), size: CGFloat(size*2), rigthSlotName: "cannotMove", color: .red, canMove: false, hasPhysics: false)
                    }
                    else if objIndex == 1 {
                        createTriangle(position: CGPoint(x: posX, y: posY), size: CGFloat(size*2), rigthSlotName: "cannotMove", color: .green, canMove: false, hasPhysics: false)
                    }
                    else if objIndex == 2 {
                        createUpsideDownTriangle(position: CGPoint(x: posX, y: posY), size: CGFloat(size*2), rigthSlotName: "cannotMove", color: .blue, canMove: false, hasPhysics: false)
                    }
                }
                
                
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // pega a posiçào
            let touchPosition = touch.location(in: self)
            
            // pega os nós que estão sendo tocados
            let touchedNodes = self.nodes(at: touchPosition)
            
            // para cada um dos nós...
            for node in touchedNodes {
                if node.name == "circle" || node.name == "triangle" || node.name == "square" || node.name == "upsideDownTriangle" {
                    heldNode = node
                }
                if canMove {
                    return
                }
            }
            
            if dialogueIndex > 1 && dialogueIndex < 2 {
                print(dialogueIndex)
                let texture = SKTexture(imageNamed: "dialogue3pattern\(dialogueIndex)")
                dialogue.texture = texture
                
                dialogueIndex += 1
            }
            else if dialogueIndex >= 2 {
                // criar a cena
                let sceneSize = CGSize(width: self.size.width, height: self.size.height)
                let scene = FinalScene(size: sceneSize)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                // mostras próxima cena
                self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.25))
                //self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.5))
            }
            
            
        }
    }
    
    func cleanEmptySlots() {
        for slot in slotShapes {
            if let intersectedNode = nodes(at: slot.position).first as? SKShapeTM {
                if intersectedNode.name == "notTheOne" {
                    slot.alreadyFilled = false
                    continue
                }
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
        
        //box.run(fadeOut)
        box.removeFromParent()
        
        createMask()
        
        //createMrCircle(position: CGPoint(x: 0.0, y: -150.0))
        
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
            
            //if (heldNode?.name ?? "").hasSuffix("Circle") && canMove == true {
            if (heldNode?.name == "circle" || heldNode?.name == "triangle" || heldNode?.name == "square" || heldNode?.name == "upsideDownTriangle") && canMove == true {
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


