//
//  EntityClass.swift
//  RainbowLand
//
//  Created by Tom Shiflet on 3/29/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import Foundation
import SpriteKit

class EntityClass
{
    var name:String=""
    var ID:String
    var position=CGPoint()
    var sprite=SKSpriteNode()
    var health=10
    var heading:CGFloat=0
    var speed:CGFloat=0
    
    init()
    {
        ID=UUID().uuidString
        position=CGPoint(x: 0, y: 0)
    } // init
    
    
    
} // class EntityClass
