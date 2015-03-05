//
//  Explosion.swift
//  PixelTank
//

import SpriteKit

class Explosion : SKNode
{
    // player tank requires two sprites
    var body : SKSpriteNode? = nil;
    var cannon : SKSpriteNode? = nil;
    
    let maxSpeed : CGFloat = 120.0;
    let minSpeed : CGFloat = 60.0;
    var tankSpeed : CGFloat = 60.0;
    
    var currentDirection : GameScene.Direction = GameScene.Direction.DOWN;
    var currentVector : CGVector = CGVector.zeroVector;
    
    // actions for movement and rotation
    var moveAction : SKAction? = nil;
    var rotateAction : SKAction? = nil;
    
    override init()
    {
        super.init();
        
        // scale the tank by half
        self.xScale = 0.5;
        self.yScale = 0.5;
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    /****************************************************************
    * setup
    ****************************************************************/
    func setup() ->Bool
    {
        // create the sprites for the tank parts
        body = SKSpriteNode(imageNamed: "Tank1Body_118");
        cannon = SKSpriteNode(imageNamed: "Tank1Cannon_118");

        // add the cannon to the body
        body!.addChild(cannon!);
    
        // add the body to the player node
        self.addChild(body!);

        // create the physics body
        // rectangle is halfsize since the xScale/yScale is 0.5
        var bodyRect : CGRect = CGRectMake(0.0, 0.0, body!.frame.size.width/2.0, body!.frame.size.height/2.0);
        self.physicsBody = SKPhysicsBody(rectangleOfSize: bodyRect.size);
        
        // setup the player collision category
        self.physicsBody!.categoryBitMask = GameScene.CollisionInfo.PLAYER_MASK;
        // setup the player to collide with the edge and enemies
        self.physicsBody!.contactTestBitMask = GameScene.CollisionInfo.AREA_MASK | GameScene.CollisionInfo.ENEMY_MASK;
        self.physicsBody!.collisionBitMask = 0x0;
        
        // set the initial direction
        currentDirection = GameScene.Direction.DOWN;
        currentVector = CGVectorMake(0.0, -tankSpeed);
        
        return true;
    }
    
    func startTank()
    {
        moveAction = SKAction.moveBy(currentVector, duration: 1.0);
        self.runAction(SKAction.repeatActionForever(moveAction!), withKey:"moveAction");
    }
    
    /// MARK: Speed modifiers ///////////////////////////////////////////////////////////
    func increaseSpeed()
    {
        tankSpeed += 1.0;
        if (tankSpeed > maxSpeed)
        {
            tankSpeed = maxSpeed;
        }
    }
    
    func decreaseSpeed()
    {
        tankSpeed -= 1.0;
        if (tankSpeed < minSpeed)
        {
            tankSpeed = minSpeed;
        }
    }
    
    /****************************************************************
    * turnTank
    ****************************************************************/
    func turnTank(direction:GameScene.Direction)
    {
        var vec : CGVector = CGVector.zeroVector;
        var rotateDirection : Double = 0.0;
        
        // only handle if direction has changed
        if (direction != currentDirection)
        {
            self.removeActionForKey("moveAction");
            
            // should the tank turn?
            if (direction == GameScene.Direction.RIGHT)
            {
                rotateDirection = 90.0;
                vec = CGVectorMake(tankSpeed, 0.0);
            }
            else if (direction == GameScene.Direction.LEFT)
            {
                rotateDirection = 270.0;
                vec = CGVectorMake(-tankSpeed, 0.0);
            }
            else if (direction == GameScene.Direction.DOWN)
            {
                rotateDirection = 0.0;
                vec = CGVectorMake(0.0, -tankSpeed);
            }
            else if (direction == GameScene.Direction.UP)
            {
                rotateDirection = 180.0;
                vec = CGVectorMake(0.0, tankSpeed);
            }
            
            // run the rotation
            rotateAction = SKAction.rotateToAngle(CGFloat(degreesToRadians(rotateDirection)), duration: 0.1);
            self.runAction(rotateAction);
            
            // trigger the move in new direction
            moveAction = SKAction.moveBy(vec, duration: 1.0);
            self.runAction(SKAction.repeatActionForever(moveAction!), withKey:"moveAction");
            
            // save off the new direction
            currentDirection = direction;
            
            // cache off the new current vector
            currentVector = vec;
        }
    }
    
    /****************************************************************
    * degreesToRadians
    ****************************************************************/
    func degreesToRadians (value:Double) -> Double
    {
        return value * M_PI / 180.0
    }
}
