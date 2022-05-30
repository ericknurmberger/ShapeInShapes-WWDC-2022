//
//  BalanceScene1.swift
//  Design Principles - Playground
//
//  Created by Erick Nurmberger Carvalho de Oliveira Teixeira on 20/04/22.
//

import SpriteKit

class BalanceScene1: SKScene {
    
    // Animations
    var fadeIn = SKAction.fadeIn(withDuration: 1)
    var fadeOut = SKAction.fadeOut(withDuration: 0.5)
    var scale = SKAction.scale(by: 2, duration: 2)
    
    var mrCircle: SKSpriteNode!
    
    var mask: SKShapeNode!
    var background: SKShapeNode!
    var shape: SKShapeNode!
    var limitShape: SKShapeNode!
    var slotShape: SKShapeNode!
    var dialogue: SKSpriteNode!
    
    var showLimitAndSlot = false {
        didSet {
            self.limitShape?.alpha = showLimitAndSlot ? 1 : 0
            //self.slotShape?.alpha = showLimitAndSlot ? 1 : 0
        }
    }
    
    
    var isFirstTouch = true
    var isOnIntroduction = false
    /// Pode mover o círculo ou não após a interação inicial
    var canMove: Bool = false
    
    var indexDialogue: Int = 1
    
    override func didMove(to view: SKView) {
        createBackground()
        createRedCircle()
    }
    
    func createMask() {
        mask = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        
        mask.fillColor = .white
        mask.strokeColor = .clear
        mask.alpha = 0.2
        
        mask.zPosition = -1
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
        
        mrCircle.zPosition = -5
        mrCircle.position = position
        
        mrCircle.name = "mrShape"
        
        mrCircle.run(fadeIn)
        
        self.addChild(mrCircle)
    }
    
    func createRedCircle(position: CGPoint = CGPoint(x: -120.0, y: -180.0)) {
        shape = SKShapeNode(circleOfRadius: 80.0)
        shape.name = "forma"
        shape.fillColor = .red
        shape.strokeColor = .red
        
        shape.zPosition = -10
        shape.position = position
        
        self.addChild(shape)
    }
    
    func createLimitCircle() {
        limitShape = SKShapeNode(circleOfRadius: 350.0)
        limitShape.name = "limite"
        limitShape.fillColor = UIColor.init(red: 230, green: 230, blue: 230, alpha: 1)
        limitShape.strokeColor = UIColor.init(red: 171, green: 171, blue: 171, alpha: 1)
        
        limitShape.zPosition = -15
        limitShape.position = CGPoint(x: 0, y: 0)
        showLimitAndSlot = false
        
        self.addChild(limitShape)
    }
    
    func createSlotCircle() {
        slotShape = SKShapeNode(circleOfRadius: 30.0)
        slotShape.fillColor = UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
        slotShape.strokeColor = UIColor.init(red: 190, green: 190, blue: 190, alpha: 1)
        
        slotShape.zPosition = -15
        slotShape.position = CGPoint(x: 0, y: 0)
        slotShape.alpha = 0
        
        self.addChild(slotShape)
    }
    
    func createInicialDialogue() {
        let texture = SKTexture(imageNamed: "dialoguebalance\(indexDialogue)")
        let size = CGSize(width: 1960, height: 611)
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.alpha = 0
        
        dialogue.setScale(0.25)
        
        dialogue.name = "dialogoInicial"
        dialogue.zPosition = 10
        dialogue.position = CGPoint(x: 0, y: (frame.maxY) * 0.1)
        
        dialogue.run(fadeIn)
        
        self.addChild(dialogue)
        
    }
    
    func createFinalDialogue(canAnim: Bool = true, alpha: CGFloat = 0) {
        let texture = SKTexture(imageNamed: "dialoguebalance\(indexDialogue)")
        let size = CGSize(width: 1960, height: 611)
        dialogue = SKSpriteNode(texture: texture, size: size)
        
        dialogue.setScale(0.3)
        
        dialogue.alpha = alpha
        
        dialogue.name = "dialogoFinal"
        dialogue.zPosition = 10
        dialogue.position = CGPoint(x: 0, y: (frame.minY) * 0.43)
        
        if canAnim == true {
            dialogue.run(fadeIn)
        }
        
        self.addChild(dialogue)
    }
    
    
    func handleFirstTouch(touches: Set<UITouch>) {
        for touch in touches {
            // pega a posiçào
            let touchPosition = touch.location(in: self)
            
            // pega os nós que estão sendo tocados
            let touchedNodes = self.nodes(at: touchPosition)
            
            // para cada um dos nós...
            for node in touchedNodes {
                
                if canMove == false {
                    if node.name == "forma" {
                        //shape.removeFromParent()
                        
                        createMrCircle(position: CGPoint(x: -117, y: -170.0))
                        createInicialDialogue()
                        
                        isFirstTouch = false
                        isOnIntroduction = true
                        indexDialogue += 1
                    }
                }
            }
        }
    }
    
    func handleTouchIntroduction() {
        if canMove == true {
            return
        }
        print(indexDialogue)
        if indexDialogue > 1 && indexDialogue < 8 {
            let texture = SKTexture(imageNamed: "dialoguebalance\(indexDialogue)")
            dialogue.texture = texture
            
            indexDialogue += 1
        }
        else if indexDialogue == 8 {
            dialogue.run(fadeOut) {
                self.dialogue.removeFromParent()
            }
            
            
            mrCircle.run(fadeOut)
            //createRedCircle()
            createLimitCircle()
            createSlotCircle()
            
            canMove = true
            
//            mrCircle.run(fadeOut) {
//                self.createRedCircle()
//                self.createLimitCircle()
//                self.createSlotCircle()
//
//                self.canMove = true
//            }
            
        }
        else if indexDialogue == 9 {
            createFinalDialogue(canAnim: false, alpha: 1)
            
            indexDialogue += 1
        }
        else if indexDialogue == 10 {
            // criar a cena
            let sceneSize = CGSize(width: self.size.width, height: self.size.height)
            let scene = BalanceScene2(size: sceneSize)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            // mostras próxima cena
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.25))
//            self.view?.presentScene(scene, transition: SKTransition.doorway(withDuration: 1.25))
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isFirstTouch {
            handleFirstTouch(touches: touches)
            return
        }
        
        if isOnIntroduction {
            handleTouchIntroduction()
            return
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        showLimitAndSlot = false
        
        if canMove == true {
            if shape.intersects(slotShape) {
                print("completei")
                
                shape.position = slotShape.position
                //shape.removeFromParent()
                
                //showLimitAndSlot = true
                
                createMrCircle(position: CGPoint(x: 0, y: 0))

                canMove = false
                
                createFinalDialogue()
                
                indexDialogue += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // para cada um dos toques...
        for touch in touches {
            // peguei a posição do toque
            let touchPosition = touch.location(in: self)
            
            // peguei os nós que estão sendo tocados
            let touchedNodes = self.nodes(at: touchPosition)
            
            // para cada um dos nós tocados...
            for node in touchedNodes {
                // if (no.name ?? "").starts(with: "forma") {}
                if node.name == "forma" && canMove == true {
                    if self.limitShape.contains(touchPosition) {
                        node.position = touchPosition
                        showLimitAndSlot = true
                    } else {
                        showLimitAndSlot = false
                    }
                }
            }
        }
    }
}


