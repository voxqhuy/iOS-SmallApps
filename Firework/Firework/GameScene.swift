//
//  GameScene.swift
//  Firework
//
//  Created by Vo Huy on 6/26/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    var roundCount = 0
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 2
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        
            gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)


        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
                
            }
        }
    }
}

// MARK: - User interaction
extension GameScene {
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node is SKSpriteNode {
                let sprite = node as! SKSpriteNode
                
                if sprite.name == "firework" {
                    for parent in fireworks {
                        let firework = parent.children[0] as! SKSpriteNode
                        
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name = "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    sprite.name = "selected"
                    sprite.colorBlendFactor = 0
                }
            }
        }
    }
}

// MARK: - Layout
extension GameScene {
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        firework.colorBlendFactor = 1
        node.addChild(firework)
        
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .red
        case 2:
            firework.color = .green
        default:
            break
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        fireworks.append(node)
        addChild(node)
    }
}

// MARK: - Additional helpers
extension GameScene {
    @objc func launchFireworks() {
        
        if roundCount < 10 {
            let movementAmount: CGFloat = 1800
            
            switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
            case 0:
                // straight up
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            case 1:
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            case 2:
                // from left to right
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            case 3:
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            default:
                break
            }
            
            roundCount += 1
        } else {
            gameTimer.invalidate()
            return
        }
        
    }
    
    func explode(firework: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "explode")!
        emitter.position = firework.position
        addChild(emitter)
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            let firework = fireworkContainer.children[0] as! SKSpriteNode
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
            
            switch numExploded {
            case 0:
                break
            case 1:
                score += 200
            case 2:
                score += 500
            case 3:
                score += 1000
            case 4:
                score += 2000
            default:
                score += 4000
            }
        }
        
        
    }
}
