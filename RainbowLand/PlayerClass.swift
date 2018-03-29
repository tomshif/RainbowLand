//
//  PlayerClass.swift
//  RainbowLand
//
//  Created by Tom Shiflet on 3/29/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerClass:EntityClass
{
    
    override init()
    {
        super.init()
        sprite = SKSpriteNode(imageNamed: "player")
        sprite.zPosition=5
        sprite.zRotation=heading
        speed=6
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = physCat.Player
        sprite.physicsBody?.contactTestBitMask = physCat.Gold
        sprite.physicsBody?.collisionBitMask = physCat.None
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        
        
        
    } // override init
    
} // class PlayerClass
