//
//  GameScene.swift
//  Pachinko
//
//  Created by Vo Huy on 6/19/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = CGPoint(x: 512, y: 0)
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.9
            ball.position = location
            addChild(ball)
//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//            box.position = location
//            addChild(box)
        }
    }
}
