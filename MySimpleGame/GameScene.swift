//
//  GameScene.swift
//  MySimpleGame
//
//  Created by Timon Schmelzer on 21.01.15.
//  Copyright (c) 2015 Timon Schmelzer. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // some constants which will change difficulty of the game
  var minSpeedMonster = CGFloat(2.0)
  var maxSpeedMonster = CGFloat(4.0)
  let projectileSpeed = 2.0
  var monstersDestroyed = 0
  var highscore = 0
  
  var highscorelabel: SKLabelNode? = nil
    
  
  let player = SKSpriteNode(imageNamed: "player")
  
  func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  func random(#min: CGFloat, max: CGFloat) -> CGFloat{
    return random() * (max - min) + min
  }
  
  func addMonster(){
    let monster = SKSpriteNode(imageNamed: "monster")
    
    monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
    monster.physicsBody?.dynamic = true
    monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
    monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5


  
    let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    
    addChild(monster)
    
    let actualDuration = random(min: minSpeedMonster, max: maxSpeedMonster)
    
    let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    
    let loseAction = SKAction.runBlock() {
      let reveal = SKTransition.flipHorizontalWithDuration(0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
  }
    
  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode){
    println("hit")
    projectile.removeFromParent()
    monster.removeFromParent()
    
    minSpeedMonster *= CGFloat(0.95)
    maxSpeedMonster *= CGFloat(0.95)
    
    monstersDestroyed++
    if (monstersDestroyed > highscore){
      NSUserDefaults.standardUserDefaults().setInteger(highscore, forKey: "highscore")
      NSUserDefaults.standardUserDefaults().synchronize()
      highscore = monstersDestroyed
    }
    
    highscorelabel!.text = "Score / Highscore: \(monstersDestroyed) / \(highscore)"
    
    if (monstersDestroyed > 30) {
      let reveal = SKTransition.flipHorizontalWithDuration(0.5)
      let gameOverScene = GameOverScene(size: self.size, won: true)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
  }
  
  func makeLabel(#fontNamed: String, fontSize: CGFloat, fontColor: UIColor, position: CGPoint) -> SKLabelNode{
    let label = SKLabelNode(fontNamed: fontNamed)
    label.fontSize = fontSize
    label.fontColor = fontColor
    label.position = position
    return label
  }
  
  override func didMoveToView(view: SKView) {
    playBackgroundMusic("background-music-aac.caf")
    
    highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore") + 1 //
    
    physicsWorld.gravity = CGVectorMake(0, 0)
    physicsWorld.contactDelegate = self
    
    backgroundColor = SKColor.whiteColor()
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(player)
    
    runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addMonster),
            SKAction.waitForDuration(1.0)
            ])))
    
    
    highscorelabel = makeLabel(
      fontNamed: "Chalkduster",
      fontSize: 20,
      fontColor: SKColor.blackColor(),
      position: CGPoint(x: size.width*0.7, y: size.height*0.1)
    )
    highscorelabel!.text = "Score / Highscore: \(monstersDestroyed) / \(highscore)"
    addChild(highscorelabel!)
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
      (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
        projectileDidCollideWithMonster(firstBody.node as SKSpriteNode, monster: secondBody.node as SKSpriteNode)
    }
    
  }
  
  override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
      let touch = touches.anyObject() as UITouch
      let touchLocation = touch.locationInNode(self)
      
      let projectile = SKSpriteNode(imageNamed: "projectile")
      projectile.position = player.position
      
      projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
      projectile.physicsBody?.dynamic = true
      projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
      projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
      projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
      projectile.physicsBody?.usesPreciseCollisionDetection = true
      
      let offset = touchLocation - projectile.position
      
      if (offset.x < 0) {return}
    
      runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false)) // does this action end when the sound ends?
          
      addChild(projectile)
      
      let direction = offset.normalized()
      
      let shootAmount = direction * 1000
      
      let realDest = shootAmount + projectile.position
      
      let actionMove = SKAction.moveTo(realDest, duration: projectileSpeed)
      let actionMoveDone = SKAction.removeFromParent()
      projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
}

