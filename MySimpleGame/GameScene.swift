//
//  GameScene.swift
//  MySimpleGame
//
//  Created by Timon Schmelzer on 21.01.15.
//  Copyright (c) 2015 Timon Schmelzer. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  let player = SKSpriteNode(imageNamed: "player")
  
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.whiteColor()
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    
    addChild(player)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
