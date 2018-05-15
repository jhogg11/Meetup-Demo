//
//  GameScene.swift
//  Meetup Demo
//
//  Created by Jonathan Hogg on 5/10/18.
//  Copyright © 2018 Jonathan Hogg. All rights reserved.
//

import SpriteKit
import GameplayKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


//Explanation of SpriteKit framework (e.g., physics bodies and interactions, SKActions)
//GameScene.sks can be used if nodes are being placed manually
//GameScene.swift controls activity in SKView in View Controller; scene code dictates what is seen in the SKView
//Setting up nodes and physics bodies; node is visual representation; physics bodies govern how nodes move on the screen, contact each other, etc.  Once established, the relationship between nodes and their physics bodies are fixed until changed (e.g., if one spins, they both spin)
//Nodes can be moved by changing the velocity physics bodies or with SKAction.move
//SKActions can be chained, repeated forever, etc.  There are wide variety of SKActions.  SpriteKit handles
//categoryBitMask = identifier for a node/physicsBody
//collisionBitMask = determines which objects bounce off of each other
//contactTestMask = determines which collisions result in didBegin being called; SKPhysicsContactDelegate must be set for didBegin to be called
//collisionBitMask and contactTestMask are independent!



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory : UInt32 = 0x1 << 0 //Unique identifier for ball node
    let BoxCategory : UInt32 = 0x1 << 1 //Unique identifier box node
    
    let initialPoint = CGPoint(x: screenWidth / 2, y: screenHeight * 3 / 4)
    let boxPoint = CGPoint(x: screenWidth / 2, y: screenHeight / 4)
    
    let shouldSpin = false
    let includeWait = false
    
    override func sceneDidLoad() {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self //Have to set this for didBegin to be called
        
        setNodes()
        setMasks()
        spinBox()
    }
    
    func setNodes() {
        let ballNode = SKShapeNode(circleOfRadius: 10)
        ballNode.position = initialPoint
        ballNode.fillColor = .white
        ballNode.name = "ball"
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ballNode.physicsBody?.isDynamic = true
        ballNode.physicsBody?.friction = 0
        scene?.addChild(ballNode)
        
        let boxNode = SKShapeNode(rectOf: CGSize(width: 100, height: 40))
        boxNode.position = CGPoint(x: screenWidth / 2, y: screenHeight / 4)
        boxNode.fillColor = .green
        boxNode.name = "box"
        boxNode.lineWidth = 0
        boxNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 40))
        boxNode.physicsBody?.isDynamic = false
        boxNode.physicsBody?.friction = 0
        scene?.addChild(boxNode)
    }
    
    func launchBall() {
        print("launch")
        if let ball = childNode(withName: "ball") {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        }
    }
    
    func reset() {
        if let ball = childNode(withName: "ball") {
            ball.removeAllActions()
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            let moveBall = SKAction.move(to: initialPoint, duration: 0)
            ball.run(moveBall)
        }
        
        if let box = childNode(withName: "box") {
            box.removeAllActions()
            box.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            let moveBox = SKAction.move(to: boxPoint, duration: 0)
            let resetRotate = SKAction.rotate(toAngle: 0, duration: 0)
            box.run(moveBox)
            box.run(resetRotate)
            spinBox()
        }
    }
    
    func pause() {
        scene?.isPaused = !isPaused
    }
    
    func spinBox() {
        if shouldSpin, let box = childNode(withName: "box") {
            let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
            let spinForever = SKAction.repeatForever(spin)
            
            let wait = SKAction.wait(forDuration: 1)
            let spinThenWait = SKAction.sequence([spin, wait])
            let spinThenWaitForever = SKAction.repeatForever(spinThenWait)
            
            box.run(includeWait ? spinThenWaitForever: spinForever)
        }
    }
    
    func setMasks() {
        
        if let ball = childNode(withName: "ball") {
            ball.physicsBody?.categoryBitMask = BallCategory
            ball.physicsBody?.collisionBitMask = BoxCategory//Make zero to pass through
            ball.physicsBody?.contactTestBitMask = 0//BoxCategory //| BallCategory
        }
        
        if let box = childNode(withName: "box") {
            box.physicsBody?.categoryBitMask = BoxCategory
            box.physicsBody?.collisionBitMask = BallCategory
            box.physicsBody?.contactTestBitMask = 0//BallCategory
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Function gets called if one contacting body has the other's categoryBitMask as its contactTestBitMask
        
        print("did begin")
        
        let firstBody = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ?
            contact.bodyA:
            contact.bodyB
        
        if firstBody.categoryBitMask == BallCategory, let box = childNode(withName: "box") {
            let move = SKAction.move(to: CGPoint(x: screenWidth / 4, y: screenHeight / 4), duration: 2)
            box.run(move)
        }
    }
    
}
