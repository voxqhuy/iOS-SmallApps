//
//  GameScene.swift
//  SpaceRace
//
//  Created by Vo Huy on 6/27/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer!
    var isGameOver = false
    var didUserStop = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        
        starfield = SKEmitterNode(fileNamed: "Starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
                starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if didUserStop { return }
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        didUserStop = true
        player.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let emitter = SKEmitterNode(fileNamed: "explosion")!
        emitter.position = player.position
        addChild(emitter)
        player.removeFromParent()
        
        isGameOver = true
    }
}


// MARK: Addditional helpers
extension GameScene {
    @objc func createEnemy() {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)
        
        let enemy = SKSpriteNode(imageNamed: possibleEnemies[0])
        enemy.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        addChild(enemy)
        
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemy.physicsBody?.angularVelocity = 5
        enemy.physicsBody?.angularDamping = 0
        
    }
}
