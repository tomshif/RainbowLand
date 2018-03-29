//
//  EnemyClass.swift
//  RainbowLand
//
//  Created by Tom Shiflet on 3/29/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyClass:EntityClass
{
    var lastUpdate=NSDate()
    var target:EntityClass?
    
    
    
    func update()
    {
        
        if target != nil
        {
            let dx=target!.position.x-position.x
            let dy=target!.position.y-position.y
            var angle=atan2(dy, dx)
            
            
            sprite.run(SKAction.rotate(toAngle: angle, duration: 0.3, shortestUnitArc: true))

        }
        
        heading=sprite.zRotation
        let dx=cos(heading)*speed
        let dy=sin(heading)*speed
        position.x+=dx
        position.y+=dy
        
        sprite.position=position
        
        
        // set last update time
        lastUpdate=NSDate()
        
        
    } // func update
    
    override init()
    {
        super.init()
        sprite=SKSpriteNode(imageNamed: "lep01")
        sprite.zPosition=3
        sprite.name=ID
        
        sprite.zRotation=random(min:0, max:CGFloat.pi*2)
        speed=5
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = physCat.Enemy
        sprite.physicsBody?.contactTestBitMask = physCat.Player
        sprite.physicsBody?.collisionBitMask = physCat.None
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        
    } // override init
    
} // class EnemyClass

