//
//  GameOverScene.swift
//  MySimpleGame
//
//  Created by Timon Schmelzer on 31.01.15.
//  Copyright (c) 2015 Timon Schmelzer. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

// awesome background music
var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String){
  let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
  if (url == nil){
    println("Could not find file: \(filename)")
    return
  }
  
  var error: NSError? = nil
  backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
  if (backgroundMusicPlayer == nil){
    println("Could not create audio player: \(error)")
    return
  }
  
  backgroundMusicPlayer.numberOfLoops = -1
  backgroundMusicPlayer.prepareToPlay()
  backgroundMusicPlayer.play()
}

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


//create struct of physics behavior ???
struct PhysicsCategory {
  static let None      : UInt32 = 0
  static let All       : UInt32 = UInt32.max
  static let Monster   : UInt32 = 0b1       // 1
  static let Projectile: UInt32 = 0b10      // 2
}


class GameOverScene: SKScene {
  init(size: CGSize, won: Bool){
    super.init(size: size)
    
    backgroundColor = SKColor.whiteColor()
    
    var message = won ? "You won :)" : "You lose :("
    
    let label = SKLabelNode(fontNamed: "Chalkduster")
    
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.blackColor()
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    runAction(SKAction.sequence([
        SKAction.waitForDuration(3.0),
        SKAction.runBlock(){
          let reveal = SKTransition.flipHorizontalWithDuration(0.5)
          let scene = GameScene(size: size)
          self.view?.presentScene(scene, transition: reveal)
        }
      ]))
  }
  
  required init(coder aDecoder: NSCoder){
    fatalError("init (coder:) has not been implemented")
  }
}