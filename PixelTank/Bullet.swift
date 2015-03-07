//
//  Bullet.swift
//  PixelTank
//
//  Created by Wendy Jones on 3/2/15.
//  Copyright (c) 2015 kittycode. All rights reserved.
//

import Foundation;
import SpriteKit;

class Bullet : SKNode, Collidable
{
    var bullet : SKSpriteNode? = nil;
    var bulletFrames : [SKTexture] = [SKTexture]();
    
    var isActive : Bool = false;
    
    override init()
    {
        super.init();
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    func setup()
    {
        let bulletAtlas : SKTextureAtlas = SKTextureAtlas(named: "bullets");
        
        // loop through the images in the atlas
        for (var i:Int=1; i<=bulletAtlas.textureNames.count; i++)
        {
            var tex : SKTexture = bulletAtlas.textureNamed("bullet\(i)");
            // add each texture in the atlas to the array of SKTexture objects
            bulletFrames.append(tex);
        }

        // put the first texture into the sprite on creation
        bullet = SKSpriteNode(texture: bulletFrames[0]);
        // set the radius for collision
        bullet!.physicsBody = SKPhysicsBody(circleOfRadius: bullet!.frame.size.width/2);
        // set the category
        bullet!.physicsBody!.categoryBitMask = GameScene.CollisionInfo.BULLET_MASK;
        // set who we can contact with
        bullet!.physicsBody!.contactTestBitMask = GameScene.CollisionInfo.ENEMY_MASK | GameScene.CollisionInfo.PLAYER_MASK | GameScene.CollisionInfo.AREA_MASK;
        bullet!.physicsBody!.collisionBitMask = 0;
        // bullet is not active at start
        isActive = false;
        
        // hide the bullet
        self.hidden = true;
        
        // add the bullet sprite as a child of the parent node
        self.addChild(bullet!);
    }
    
    func update()
    {
        
    }
    
    func fireBullet(let startPos : CGPoint, var angle: CGFloat)
    {
        self.hidden = false;
        self.position = startPos;
        
        var dx : CGFloat = cos(CGFloat(angle));
        var dy : CGFloat = sin(CGFloat(angle));
        var dirVector : CGVector = CGVector(dx: dx*500, dy: dy*500);
        var fireAction : SKAction = SKAction.moveBy(dirVector, duration: 1.0);
        self.runAction(fireAction);
        isActive = true;
   }
    
    func killBullet()
    {
        isActive = false;
        self.hidden = true;
    }
    
    /****************************************************************
    * handleCollisionWithObject
    ****************************************************************/
    func handleCollisionWithObject(otherBody:SKPhysicsBody)
    {
        /*// if the player has hit the edge or an enemy
        if (((otherBody.categoryBitMask | GameScene.CollisionInfo.AREA_MASK) != 0) ||
            ((otherBody.categoryBitMask | GameScene.CollisionInfo.ENEMY_MASK) != 0))
        {
            
        }*/
    }
}