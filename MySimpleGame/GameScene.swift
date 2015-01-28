//
//  GameScene.swift
//  MySimpleGame
//
//  Created by Timon Schmelzer on 21.01.15.
//  Copyright (c) 2015 Timon Schmelzer. All rights reserved.
//

import SpriteKit
// some usefull functions:
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
  
  // some constants which will change difficulty of the game
  let minSpeedMonster = CGFloat(2.0)
  let maxSpeedMonster = CGFloat(4.0)
  
  let player = SKSpriteNode(imageNamed: "player")
  
  func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  func random(#min: CGFloat, max: CGFloat) -> CGFloat{
    return random() * (max - min) + min
  }
  
  func addMonster(){
    let monster = SKSpriteNode(imageNamed: "monster")
  
    let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    
    addChild(monster)
    
    let actualDuration = random(min: minSpeedMonster, max: maxSpeedMonster)
    
    let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.whiteColor()
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(player)
    
    runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addMonster),
            SKAction.waitForDuration(1.0)
            ])))
    
    }
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        
        
    }
  
}
