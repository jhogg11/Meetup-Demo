//
//  GameViewController.swift
//  Meetup Demo
//
//  Created by Jonathan Hogg on 5/10/18.
//  Copyright © 2018 Jonathan Hogg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupScene() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let scene = GameScene(size: size)
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .aspectFill
        
        gameView.presentScene(scene)
        gameView.ignoresSiblingOrder = true
    }
    
    @IBAction func pause(_ sender: Any) {
        if let gameScene = gameView.scene as? GameScene {
            gameScene.pause()
        }
    }
    
    
    @IBAction func launchBall(_ sender: Any) {
        if let gameScene = gameView.scene as? GameScene {
            gameScene.launchBall()
        }
    }
    
    
    @IBAction func resetBall(_ sender: Any) {
        if let gameScene = gameView.scene as? GameScene {
            gameScene.reset()
        }
    }
    
}


