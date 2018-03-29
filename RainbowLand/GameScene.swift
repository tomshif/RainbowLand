//
//  GameScene.swift
//  RainbowLand
//
//  Created by Tom Shiflet on 3/29/18.
//  Copyright © 2018 Tom Shiflet. All rights reserved.
//

import SpriteKit
import GameplayKit


// global structures
struct physCat {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    
    static let Player       : UInt32 = 0b00010
    static let Enemy        : UInt32 = 0b00100
    static let Gold         : UInt32 = 0b01000
    static let Bullet       : UInt32 = 0b10000
} // struct physCat



class GameScene: SKScene,SKPhysicsContactDelegate {

    // global object arrays
    var PotList=[PotClass]()
    var enemyList=[EnemyClass]()
    
    
    // global objects
    var player=PlayerClass()
    
    // global SK nodes
    var cameraNode=SKCameraNode()
    
    // global game variables
    var level:Int=1
    var score=0
    
    
    // key variables
    var leftPressed=false
    var rightPressed=false
    var upPressed=false
    var downPressed=false
    
    // global constants
    let maxPots=10
    let edges:CGFloat=10
    let spawnTimer:CGFloat=2.0
    let maxEnemies:Int=250
    
    

    
    
    override func didMove(to view: SKView) {
    
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        
        addChild(player.sprite)
        
        
        cameraNode.name="Camera"
        addChild(cameraNode)
        self.camera=cameraNode
        
        
        
        backgroundColor=NSColor.brown
        drawDirt()
        
        //generate initial pots of gold
        for _ in 1...maxPots
        {
            generatePot()
            
        } // for each pot
        
    } // func didMove
    
    
    func generatePot()
    {
        let tempPot=PotClass()
        let x=random(min: -size.width*5, max: size.width*edges)
        let y=random(min: -size.height*5, max: size.height*edges)
        
        tempPot.sprite.position=CGPoint(x: x, y: y)
        tempPot.position=CGPoint(x: x, y: y)
        
        PotList.append(tempPot)
        addChild((PotList.last?.sprite)!)
        
    } // func generatePot
    
    func drawDirt()
    {
        for _ in 0...500
        {
            let x=random(min: -size.width*10, max: size.width*10)
            let y=random(min: -size.height*10, max: size.height*10)
            
            let tempSpot = SKShapeNode(circleOfRadius: random(min: 250, max: 1000))
            let r=random(min: 0, max: 1.0)
            let g=random(min: 0, max: 1.0)
            let b=random(min: 0, max: 1.0)
            let tempColor=NSColor.init(red: r, green: g, blue: b, alpha: random(min:0.5, max: 0.9))
            
            tempSpot.fillColor=tempColor
            tempSpot.position=CGPoint(x: x, y: y)
            addChild(tempSpot)
            
        } // for
    } // func drawDirt
    
    func touchDown(atPoint pos : CGPoint) {

    } // func touchDown
    
    func touchMoved(toPoint pos : CGPoint) {

    } // func touchMoved
    
    func touchUp(atPoint pos : CGPoint) {

    } // func touchUp
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    } // func mouseDown
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    } // func mouseDragged
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    } // func mouseUp
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {

        case 0:
            leftPressed=true
        case 1:
            downPressed=true
        case 2:
            rightPressed=true
        case 13:
            upPressed=true
        case 49:
            fireProjectile()
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        } // switch event
    } // func keyDown
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            leftPressed=false
        case 1:
            downPressed=false
        case 2:
            rightPressed=false
        case 13:
            upPressed=false
            
        default:
            break
        } // switch event
    } // func keyDown
    
    func checkKeys()
    {
        if leftPressed
        {
            if player.position.x > -size.width*edges
            {
                player.position.x -= player.speed
        
            }
        }
        
        if rightPressed
        {
            if player.position.x < size.width*edges
            {
            player.position.x += player.speed
            }
        }
        
        if upPressed
        {
            if player.position.y < size.height*edges
            {
                player.position.y += player.speed
            }
        }
        
        if downPressed
        {
            if player.position.y > -size.height*edges
            {
                player.position.y -= player.speed
            }
        }
        
        //rotate player sprite based on direction
        if rightPressed
        {
            if upPressed
            {
                player.heading = CGFloat.pi/4
                
            } // player facing up and right
            else
            {
                if downPressed
                {
                    player.heading = CGFloat.pi*(15/8)
                    
                } // player facing down and right
                else
                {
                    player.heading=0
                    
                } // player facing just right
            } // else not up right
        } // if right
        
        if leftPressed
        {
            if upPressed
            {
                player.heading = CGFloat.pi*(3/4)
            } // player facing up and left
            else
            {
                if downPressed
                {
                    player.heading = CGFloat.pi*(5/4)
                    
                } // player facing down and left
                else
                {
                    player.heading=CGFloat.pi
                    
                } // player facing just left
            } // else not up left
        } // if left
        
        if upPressed
        {
            if !leftPressed && !rightPressed
            {
                player.heading = CGFloat.pi*(1/2)
            }
        } // if up
        
        if downPressed
        {
            if !leftPressed && !rightPressed
            {
                player.heading = CGFloat.pi*(6/4)
            }
        } // if down
        
    } // func checkKeys
    
    func updatePlayer()
    {
        // update player rotation
        player.sprite.zRotation=player.heading
        
        // update player sprite position
        player.sprite.position = player.position
        
        
    } // func updatePlayer()
    
    func spawnEnemy(index: Int)
    {
        let tempEnemy=EnemyClass()
        tempEnemy.position=PotList[index].position
        tempEnemy.sprite.position=PotList[index].position
        tempEnemy.target=player
        enemyList.append(tempEnemy)
        addChild((enemyList.last?.sprite)!)
        
        
    } // func spawnEnemy
    
    func checkEnemySpawn()
    {
        let now = NSDate()
        if PotList.count > 0
        {
            for i in 0...PotList.count-1
            {
                let timeDelta=now.timeIntervalSince(PotList[i].lastSpawn as Date)
                if timeDelta > Double(spawnTimer)
                {
                    spawnEnemy(index: i)
                    PotList[i].lastSpawn=now
                    
                } // if it's time to spawn an enemy
                
                
            } // for each pot
            
        }
        
    } // func checkEnemySpawn
    
    func fireProjectile()
    {
        let proj = SKSpriteNode(imageNamed: "projectile01")
        proj.setScale(0.02)
        proj.position=player.sprite.position
        
        proj.physicsBody = SKPhysicsBody(circleOfRadius: proj.size.width/2)
        proj.physicsBody?.isDynamic = true
        proj.physicsBody?.categoryBitMask = physCat.Bullet
        proj.physicsBody?.contactTestBitMask = physCat.Enemy
        proj.physicsBody?.collisionBitMask = physCat.None
        proj.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(proj)
        proj.run(SKAction.repeatForever(SKAction.rotate(byAngle: 3, duration: 0.2)))
        let dx=cos(player.sprite.zRotation)*800 + player.sprite.position.x
        let dy=sin(player.sprite.zRotation)*800 + player.sprite.position.y
        let dv=CGPoint(x: dx, y: dy)
        
        let actionFinished=SKAction.sequence([SKAction.wait(forDuration: 0.0),SKAction.removeFromParent()])
        proj.run(SKAction.sequence([SKAction.move(to: dv, duration: 0.5), actionFinished]))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Check contact between player and enemy
        if ((firstBody.categoryBitMask & physCat.Player != 0) &&
            (secondBody.categoryBitMask & physCat.Enemy != 0))
        {
            if let tempPlayer = firstBody.node as? SKSpriteNode, let
                tempEnemy = secondBody.node as? SKSpriteNode
            {
                print("Player Died")
                
            } // if let
            
            
        } // if ((firstBody...)
        
        // check contact between enemy and bullet
        if ((firstBody.categoryBitMask & physCat.Enemy != 0) &&
            (secondBody.categoryBitMask & physCat.Bullet != 0))
        {
            if let tempEnemy = firstBody.node as? SKSpriteNode, let
                tempBullet = secondBody.node as? SKSpriteNode
            {
                tempBullet.removeFromParent()
                // find the enemy object
                var thisOne = -1
                if enemyList.count > 0
                {
                    for i in 0...enemyList.count-1
                    {
                        if tempEnemy.name == enemyList[i].ID
                        {
                            thisOne=i
                            break
                            
                        } // if match
                    } // for each enemy
                } // if we have enemies
                
                if thisOne > -1
                {
                    enemyList[thisOne].sprite.removeFromParent()
                    enemyList.remove(at: thisOne)
                    print("Enemy Killed")
                    
                } // if we found a match
                
            } // if let
        } // if contact is enemy and bullet
        
    } // func didBegin()
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        checkKeys()
        
        updatePlayer()
        
        // update camera position to the player's position
        cameraNode.position=player.position
        
        
        // check to see if a pot needs to spawn an enemy
        checkEnemySpawn()
        
        // Update enemies
        if enemyList.count > 0
        {
            for i in 0...enemyList.count-1
            {
                enemyList[i].update()
            } // for each enemy
        } // if we have enemies

        
        
    } // func update
}
