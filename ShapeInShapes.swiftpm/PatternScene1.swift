//
//  PatternScene1.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 20/04/22.
//

import SpriteKit
import SwiftUI

class PatternScene1: SKScene {
    
    // Animations
    var fadeIn = SKAction.fadeIn(withDuration: 1)
    var fadeOut = SKAction.fadeOut(withDuration: 0.5)
    var scale = SKAction.scale(by: 2, duration: 2)
    
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
            self.limitShape?.alpha = showLimitAndSlot ? 1 : 0
            if dialogueIndex > 6 {
                self.box.alpha = showLimitAndSlot ? 0.5 : 1
            }
            
            for shape in slotShapes {
                shape.alpha = showLimitAndSlot ? 0.75 : 0
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
    var canMove: Bool = false
    
    var numberOfFilledSlots: Int = 0
    var dialogueIndex: Int = 1
    
    var heldNode: SKNode?
    
    override func didMove(to view: SKView) {
        createBackground()
        createSlotBox()
        
        // Cria a moldura
        //createRedFrame(position: CGPoint(x: 0, y: 300))
        //createRedFrame(position: CGPoint(x: -200, y: -300))
        
        // Cria as formas arrastáveis
        //createTriangle(position: CGPoint(x: 200, y: 200), size: 80.0, color: SKColor.init(red: 100, green: 100, blue: 0, alpha: 1))
        createShapesGrid()
        //createCircle(position: CGPoint(x: 200, y: 200), size: 80.0, name: "circle", color: SKColor.init(red: 100, green: 100, blue: 0, alpha: 1))
        //createSquare(position: CGPoint(x: -200, y: 200), size: CGSize(width: 80.0, height: 80.0), name: "square", color: SKColor.red)
        
        // Cria os encaixes iniciais
//        createSlotCircle(position: CGPoint(x: 200, y: 200), size: 30.0, name: "noName")
//        createSlotCircle(position: CGPoint(x: -200, y: 200), size: 30.0, name: "noName")
        
        // Cria as formas encaixes
        //createSlotCircle(position: CGPoint(x: 200, y: -200), size: 30.0, name: "slotCircle")
        //createSlotCircle(position: CGPoint(x: -200, y: -200), size: 30.0, name: "slotSquare")
        
    }
    
    func createMask() {
        mask = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        
        mask.fillColor = .white
        mask.strokeColor = .clear
        mask.alpha = 0.1
        
        mask.zPosition = -6
        mask.position = CGPoint(x: 0, y: 0)
        
        mask.name = "mask"
        
        self.addChild(mask)
        
    }
    
    func createBackground() {
        background = SKShapeNode(circleOfRadius: 1000.0)
        
        background.fillColor = UIColor.init(red: 240, green: 240, blue: 240, alpha: 1)
        background.strokeColor = UIColor.init(red: 240, green: 240, blue: 240, alpha: 1)
        
        background.zPosition = -100
        background.position = CGPoint(x: 0, y: 0)
        
        background.name = "background"
        
        self.addChild(background)
    }
    
    func createMrCircle(position: CGPoint) {
        let texture = SKTexture(imageNamed: "mrShape")
        
        let size = CGSize(width: 1224/5, height: 1585/5)
        
        mrCircle = SKSpriteNode(texture: texture, size: size)
        
        mrCircle.alpha = 0
        
        mrCircle.setScale(0.5)
        
        mrCircle.zPosition = -5
        mrCircle.position = position
        
        mrCircle.name = "mrShape"
        
        mrCircle.run(fadeIn)
        
        self.addChild(mrCircle)
    }
    
    func createCorrectCircle(position: CGPoint, zposition: CGFloat = -10, size: CGFloat, name: String = "correctCircle", rightSlotName: String = "slotCorrectCircle", color: SKColor, stroke: SKColor, canMove:Bool = false) {
        let shape = SKShapeTM(circleOfRadius: size)
        //shape.name = "forma"
        shape.fillColor = color
        shape.strokeColor = stroke
        
        shape.zPosition = zposition
        shape.position = position
        
        shape.name = name
        
        shape.rightSlotName = rightSlotName
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
    }
    
    func createCircle(position: CGPoint, zposition: CGFloat = -10, size: CGFloat, name: String = "circle", rigthSlotName:String, color: SKColor, canMove:Bool = true) {
        let shape = SKShapeTM(circleOfRadius: size)
        //shape.name = "forma"
        shape.fillColor = .clear
        shape.strokeColor = color
        shape.lineWidth = 5
        
        shape.zPosition = zposition
        shape.position = position
        
        shape.name = name
        
        shape.rightSlotName = "slotCircle"
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
    }
    
    func createSquare(position: CGPoint, size: CGSize, name: String = "square", rigthSlotName:String, color: SKColor, canMove:Bool = true) {
        let shape = SKShapeTM(rectOf: size)
        
        shape.fillColor = color
        shape.strokeColor = color
        
        shape.zPosition = -10
        shape.position = position
        
        shape.name = name
        
        shape.rightSlotName = "slotSquare"
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
        
    }
    
    func createTriangle(position: CGPoint, size: CGFloat, name: String = "triangle", rigthSlotName:String, color: SKColor, canMove: Bool = true) {
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
        
        shape.zPosition = -10
        shape.position = position
        
        shape.name = name
        
        shape.rightSlotName = "slotTriangle"
        
        shape.canMove = canMove
        
        self.addChild(shape)
        shapes.append(shape)
    }
        
    func createSlotCircle(position: CGPoint, size: CGFloat, name: String) {
        let slotShape = SKShapeSlot(circleOfRadius: size)
        
        slotShape.fillColor = UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
        slotShape.strokeColor = .clear
        
        slotShape.zPosition = -15
        slotShape.position = position
        
        slotShape.name = name
        
        slotShape.alpha = 0
        
        self.addChild(slotShape)
        slotShapes.append(slotShape)
    }
    
    
    func createLimit() {
        
        let minSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let square = SKShapeNode(rectOf: CGSize(width: minSize, height: minSize))
        
        square.position.y = -40
        square.zPosition = -50
        square.name = "quadrado"
        square.fillColor = UIColor.init(red: 230, green: 230, blue: 230, alpha: 1)
        square.strokeColor = .clear
        square.alpha = 0
        self.limitShape = square
        self.addChild(square)
    }
    

    func createInicialDialogue(position: CGPoint, size: CGSize, name: String) {
        let texture = SKTexture(imageNamed: "dialoguepattern\(dialogueIndex)")
        let size = size
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.alpha = 0
        
        dialogue.setScale(0.25)
        
        dialogue.name = name
        dialogue.zPosition = 10
        dialogue.position = position
        
        dialogue.run(fadeIn)
        
        self.addChild(dialogue)
    }
    
    func createFinalDialogue(position: CGPoint, size: CGSize, name: String, canAnim: Bool = true, alpha: CGFloat = 0) {
        let texture = SKTexture(imageNamed: "dialoguepattern\(dialogueIndex)")
        let size = size
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.alpha = alpha
        
        dialogue.setScale(0.3)
        
        dialogue.name = name
        dialogue.zPosition = 10
        dialogue.position = position
        
        if canAnim == true {
            dialogue.run(fadeIn)
        }
        
        self.addChild(dialogue)
    }
    
    func createSlotBox() {
        let texture = SKTexture(imageNamed: "slotBox")
        let size = CGSize(width: 1546, height: 526)
        box = SKSpriteNode(texture: texture, size: size)
        
        box.setScale(0.4)
        
        box.alpha = 0
        
        box.name = "box"
        box.zPosition = -15
        box.position = CGPoint(x: 0, y: (frame.minY) * 0.55)
        
        self.addChild(box)
    }
    
    func createShapesGrid() {
        let spacing = 120
        
        let inicialPosX = Int(self.frame.midX - CGFloat(spacing)*2.0)
        let inicialPosY = Int(self.frame.midY)
        
        
        
        for i in 0...4 {
            let posX = inicialPosX + i*spacing
            
            for j in 0...1 {
                let objIndex = i%2
                let posY = inicialPosY + j*spacing
                
                let size = CGFloat(spacing)*0.3
                
                switch(i, j) {
                case (2, 0):
                    createCorrectCircle(position: CGPoint(x: posX, y: posY), size: size, rightSlotName: "notTheOne", color: .red, stroke: .red)
                    print(position)
                    print(size)
                    /*createSlotCircle(position: CGPoint(x: posX, y: posY), size: size, name: objIndex == 0 ? "circleSlot": "squareSlot")*/
                default:
                    if objIndex == 0 {
                        createCircle(position: CGPoint(x: posX, y: posY), size: size, rigthSlotName: "cannotMove", color: .red, canMove: false)
                    }
                    else if objIndex == 1 {
                        createSquare(position: CGPoint(x: posX, y: posY), size: CGSize(width: size*2, height: size*2), rigthSlotName: "cannotMove", color: SKColor.red, canMove: false)
                    }
                }
                
                
            }
        }
    }
    
    func handleFirstTouch(touches: Set<UITouch>) {
        for touch in touches {
            // pega a posiçào
            let touchPosition = touch.location(in: self)
            
            // pega os nós que estão sendo tocados
            let touchedNodes = self.nodes(at: touchPosition)
            
            // para cada um dos nós...
            for node in touchedNodes {
                if node is SKShapeTM {
                    heldNode = node
                }
                
                if canMove == false {
                    if node.name == "correctCircle" {
                        //node.removeFromParent()
                        
                        createMrCircle(position: CGPoint(x: 0, y: 0))
                        createInicialDialogue(position: CGPoint(x: 0, y: (frame.minY) * 0.23), size: CGSize(width: 1960, height: 611), name: "dialogoInicial")
                        
                        isFirstTouch = false
                        isOnIntroduction = true
                        dialogueIndex += 1
                    }
                }
            }
        }
    }
    
    func handleTouchIntroduction() {
        if canMove == true {
            return
        }
        print(dialogueIndex)
        if dialogueIndex > 1 && dialogueIndex < 6 {
            let texture = SKTexture(imageNamed: "dialoguepattern\(dialogueIndex)")
            dialogue.texture = texture
            
            dialogueIndex += 1
        }
        else if dialogueIndex == 6 {
            let texture = SKTexture(imageNamed: "dialoguepattern\(dialogueIndex)")
            dialogue.texture = texture
            
            box.alpha = 1
            
            //black
            createCorrectCircle(position: CGPoint(x: 0, y: box.frame.midY), zposition: -9, size: 32.0, name: "correctCircle", color: SKColor.init(red: 240, green: 240, blue: 240, alpha: 1), stroke: .red, canMove: true)
            
            dialogueIndex += 1
        }
        else if dialogueIndex == 7 {
            dialogue.run(fadeOut) {
                self.dialogue.removeFromParent()
            }
            
            
            mrCircle.run(fadeOut)
            
            canMove = true
            
//            createSlotBox()
            createLimit()
            
            //red
            createCorrectCircle(position: CGPoint(x: 0.0, y: 0.0), size: 36.0, name: "notTheOne", rightSlotName: "notTheOne", color: .red, stroke: .red)
            
            createSlotCircle(position: CGPoint(x: 0.0, y: 0.0), size: 18.0, name: "slotCorrectCircle")
            createSlotCircle(position: CGPoint(x: 0, y: box.frame.midY), size: 18.0, name: "ignoredSlot")
//            createCorrectCircle(position: CGPoint(x: 0.0, y: -200.0), size: 30.0, name: "correctCircle", color: .yellow, canMove: true)
        }
        else if dialogueIndex == 8 {
            createFinalDialogue(position: CGPoint(x: 0, y: (frame.minY) * 0.43), size: CGSize(width: 1960, height: 850), name: "dialogoFinal", canAnim: false, alpha: 1)
            
            dialogueIndex += 1
        }
        else if dialogueIndex == 9 {
            // criar a cena
            let sceneSize = CGSize(width: self.size.width, height: self.size.height)
            let scene = PatternScene2(size: sceneSize)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            // mostras próxima cena
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.25))
            //self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.5))
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchedNodes = self.nodes(at: touchPosition)

            for node in touchedNodes {
                if let node = node as? SKShapeTM {
                    if node.canMove {
                        heldNode = node
                        print("HELD")
                    }
                }
            }
        }
        
        if isFirstTouch {
            handleFirstTouch(touches: touches)
            return
        }
        
        if isOnIntroduction {
            handleTouchIntroduction()
            return
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
            
        
        let intersectSlots = slotShapes.filter { $0.intersects(shape) } // filtra os nós embaixo do shape
            .filter {!$0.alreadyFilled} // retira os já preenchidos
        
        guard let intersectSlot = intersectSlots.first else {
            cleanEmptySlots()
            return
        }
        
        print(shape.name)
        print(shape.rightSlotName)
        
        shape.position = intersectSlot.position

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
        
        createFinalDialogue(position: CGPoint(x: 0, y: (frame.minY) * 0.43), size: CGSize(width: 1960, height: 850), name: "dialogoFinal")
        
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
                  node.canMove else {
                print("CANT MOVE")
                return
                
            }
            
            if (heldNode?.name == "correctCircle" || heldNode?.name == "circle" || heldNode?.name == "square" || heldNode?.name == "triangle" ) && canMove == true {
                if self.limitShape.contains(touchPosition) {
                    heldNode?.position = touchPosition
                    showLimitAndSlot = true
                }
                else {
                    showLimitAndSlot = false
                }
            }
        }
        
//        for shape in shapes {
//            if shape.position.x > limitShape.frame.width {
//                shape.position.x = limitShape.frame.width - shape.frame.width
//            }
//        }
    }
}
