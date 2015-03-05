//
//  GameScene.swift
//  PixelTank
//
//  Created by Wendy Jones on 2/26/15.
//  Copyright (c) 2015 kittycode. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // enum used to determine direction of game objects
    enum Direction : Int32
    {
        case UP = 0
        case DOWN
        case LEFT
        case RIGHT
    }
    
    // Collision information
    // These are in a struct because Swift doesn't allow class static variables
    struct CollisionInfo
    {
        // collision masks from most likely to collide with player to least
        static let PLAYER_MASK  : UInt32 = 0x1 << 0;
        static let ENEMY_MASK   : UInt32 = 0x1 << 1;
        static let AREA_MASK    : UInt32 = 0x1 << 2;
        static let BULLET_MASK  : UInt32 = 0x1 << 3;
        static let POWERUP_MASK : UInt32 = 0x1 << 4;
    }
    
    // the player object
    var player : Player? = nil;
    
    // the background graphic
    var background : SKSpriteNode? = nil;
    var lavaNodes : [SKNode] = [];
    
    var world : SKNode? = nil;
    /****************************************************************
    * didMoveToView - called when the scene is first displayed
    ****************************************************************/
    override func didMoveToView(view: SKView)
    {
        // create the swipe gestures and add to the view
        var rightSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("onSwipe:"));
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right;
        self.view!.addGestureRecognizer(rightSwipeGesture);
        
        var leftSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("onSwipe:"));
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left;
        self.view!.addGestureRecognizer(leftSwipeGesture);
        
        var upSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("onSwipe:"));
        upSwipeGesture.direction = UISwipeGestureRecognizerDirection.Up;
        self.view!.addGestureRecognizer(upSwipeGesture);
        
        var downSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("onSwipe:"));
        downSwipeGesture.direction = UISwipeGestureRecognizerDirection.Down;
        self.view!.addGestureRecognizer(downSwipeGesture);
        
        // setup the scene
        setupScene();
        
        // run the scene
        runScene();
    }
    
    // MARK: Input handler code
    /****************************************************************
    * onSwipe - swipe gesture callback
    ****************************************************************/
    func onSwipe(swipeGesture : UISwipeGestureRecognizer)
    {
        if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Right)
        {
            player!.turnTank(GameScene.Direction.RIGHT);
        }
        else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Left)
        {
            player!.turnTank(GameScene.Direction.LEFT);
        }
        else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Up)
        {
            player!.turnTank(GameScene.Direction.UP);
        }
        else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Down)
        {
            player!.turnTank(GameScene.Direction.DOWN);
        }
    }
    
    
    /****************************************************************
    * touchesBegan
    ****************************************************************/
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // fire the cannon
            player!.fireCannon();
        }
    }
   
    // MARK: Collision Handler Code
    /****************************************************************
    * didBeginContact
    ****************************************************************/
    func didBeginContact(contact: SKPhysicsContact)
    {
        // grab the contacted bodies into variables assume sorted
        var firstBody : SKPhysicsBody = contact.bodyA;
        var secondBody : SKPhysicsBody = contact.bodyB;
        
        // reverse the sort of the masks if necessary
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // if this is a player collision with an object
        // let the player handle it
        /*if ((firstBody.categoryBitMask | CollisionInfo.PLAYER_MASK) != 0)
        {
            (firstBody.node! as Player).handleCollisionWithObject(secondBody);
        }
        // handle enemy getting hit with something
        else if ((firstBody.categoryBitMask | CollisionInfo.ENEMY_MASK) != 0)
        {
            (firstBody.node! as Enemy).handleCollisionWithObject(secondBody);
        }*/
        
    }
    
    /****************************************************************
    * didSimulatePhysics - called after physics have been updated
    ****************************************************************/
    override func didSimulatePhysics()
    {
        // update the world camera position and constraint to background
        var newPosX : CGFloat = -(player!.position.x-(self.size.width/2));
        if (newPosX > 0.0) { newPosX = 0.0; }
        if (newPosX < -(background!.frame.size.width - self.size.width)) { newPosX = -(background!.frame.size.width - self.size.width); }
        
        var newPosY : CGFloat = -(player!.position.y-(self.size.height/2));
        if (newPosY > 0.0) { newPosY = 0.0; }
        if (newPosY < -(background!.frame.size.height - self.size.height)) { newPosY = -(background!.frame.size.height - self.size.height); }
        world!.position = CGPointMake(newPosX, newPosY);
    }
    
    // MARK: Scene Setup
    /****************************************************************
    * setupScene - inits the needed objects in the scene
    ****************************************************************/
    func setupScene()
    {
        // set up the world node for camera follow
        world = SKNode();
        self.addChild(world!);
        
        // create and set the background graphic
        background = SKSpriteNode(imageNamed: "ground");
        if (background != nil)
        {
            background!.position = CGPoint(x:background!.frame.size.width/2.0, y:background!.frame.size.height/2.0);
            println("backgroundframe=\(background!.frame.origin.x), \(background!.frame.origin.y), \(background!.frame.size.width), \(background!.frame.size.height)");
            // add the background to the scene
            world!.addChild(background!);
        }

        // Create the player object
        player = Player();
        if ((player != nil) && (player!.setup()))
        {
            player!.position = CGPointMake(background!.frame.size.width/2.0, background!.frame.size.height/2.0);
            world!.addChild(player!);
        }
        
        var star : SKSpriteNode = SKSpriteNode(imageNamed: "greenStar");
        star.anchorPoint = CGPointZero;
        world!.addChild(star);
        
        // setup and create the border collision
        setupBorderCollision();
        
        // set up the physicsWorld
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0);
        self.physicsWorld.contactDelegate = self;
    }
    
    /****************************************************************
    * setupBorderCollision - sets up the collision rects around the screen
    ****************************************************************/
    func setupBorderCollision()
    {
        // create the lava physics objects to handle collision
        var lavaNode0 : SKNode = SKNode();
        lavaNode0.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0.0, 0.0, background!.frame.size.width, 50.0));
        lavaNode0.physicsBody?.categoryBitMask = CollisionInfo.AREA_MASK;
        lavaNode0.physicsBody?.contactTestBitMask = CollisionInfo.PLAYER_MASK;
        world!.addChild(lavaNode0);
        
        var lavaNode1 : SKNode = SKNode();
        lavaNode1.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0.0, 0.0, 50.0, background!.frame.size.height));
        lavaNode1.physicsBody?.categoryBitMask = CollisionInfo.AREA_MASK;
        world!.addChild(lavaNode1);
        
        var lavaNode2 : SKNode = SKNode();
        lavaNode2.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(background!.frame.size.width-50.0, 0.0, 50.0, background!.frame.size.height));
        lavaNode2.physicsBody?.categoryBitMask = CollisionInfo.AREA_MASK;
        world!.addChild(lavaNode2);
        
        var lavaNode3 : SKNode = SKNode();
        lavaNode3.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0.0, background!.frame.size.height-50.0, background!.frame.size.width, 50.0));
        lavaNode3.physicsBody?.categoryBitMask = CollisionInfo.AREA_MASK;
        world!.addChild(lavaNode3);
    }
    
    // MARK: Scene Update
    /****************************************************************
    * setupScene - inits the needed objects in the scene
    ****************************************************************/
    func runScene()
    {
        //player!.startTank();
    }
    
    /****************************************************************
    * update - called every frame
    ****************************************************************/
    override func update(currentTime: CFTimeInterval)
    {
        // if the player is dead
        if (!player!.isAlive)
        {
            
        }
    }
}
