import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene: SKScene {
        let sceneSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let scene = BalanceScene1(size: sceneSize)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return scene
        
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
