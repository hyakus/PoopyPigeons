//
//  GameScene.m
//  PoopyPigeons
//
//  Created by Bryan Carter on 17/03/2016.
//  Copyright (c) 2016 Bryan Carter. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

static const  uint32_t objectiveMask = 1 << 0;
static const  uint32_t otherMask = 1 << 1;
static const uint32_t backBitMask =  0x1 << 0;
static const uint32_t shotBitMask =  0x1 << 1;
static const uint32_t floorBitMask    =  0x1 << 2;




-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    [self createBackground];

    [self createGround];
    
    [self createCannonInitShot];
    
    camera = [[SKCameraNode alloc] init];
    
    self.camera = camera;
    
    camera.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.physicsWorld.contactDelegate = self;
    
    self.physicsWorld.gravity = CGVectorMake(self.physicsWorld.gravity.dx, self.physicsWorld.gravity.dy/4);
}


- (void) createCannonInitShot
{
    cannon = [SKSpriteNode spriteNodeWithImageNamed:@"cannon-body"];
    
    shot = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    cannon.xScale = 2;
    cannon.yScale = 2;
    
    cannon.physicsBody =  [SKPhysicsBody bodyWithCircleOfRadius:cannon.size.width/2];
    
    cannon.physicsBody.categoryBitMask = shotBitMask;
    
    cannon.physicsBody.density = 5;
    
    cannon.position = CGPointMake(self.frame.size.width/6,
                                  self.frame.size.height/2);
    
    cannon.zPosition = 1.0;
    
    cannonBase = [SKSpriteNode spriteNodeWithImageNamed:@"cannon-base"];
    
    cannonBase.xScale = 0.7;
    cannonBase.yScale = 0.7;
    
    cannonBase.position = CGPointMake(self.frame.size.width/6,
                                      self.frame.size.height/6);
    
    cannonBase.zPosition = 2.0;
    
    [self addChild:cannon];
    
    [self addChild:cannonBase];
}


- (void) createBackground
{
    background = [SKScrollingNode scrollingNodeWithImageNamed:@"Trail"
                                             inContainerWidth:self.frame.size.width
                                                   withHeight:self.frame.size.height];
    [background setScrollingSpeed:20.0];
    [background setAnchorPoint:CGPointZero];
    
    background.zPosition = -1.0;
//    [background setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    background.physicsBody.categoryBitMask = backBitMask;
    background.physicsBody.contactTestBitMask = shotBitMask;
    [self addChild:background];
}

- (void) createGround
{
    floor = [SKScrollingNode scrollingNodeWithImageNamed:@"floor"
                                        inContainerWidth:self.frame.size.width];
    [floor setScrollingSpeed:20.0];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = shotBitMask;
    floor.zPosition = -1.0;
    
    [self addChild:floor];
}

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    NSLog(@"HITHITHIT");
    for (UITouch *touch in touches)
    {
        
        CGPoint location = [touch locationInNode:self];
        
        //Check if there is already a projectile in the scene
        if (!hasProjectile
            && cannon.parent
            && CGRectContainsPoint(cannon.frame,location))
        {
            //If not, add it
            hasProjectile = YES;
            [self addProjectile];
         
            [cannonBase removeFromParent];
            
            //Create a Vector to use as a 2D force value
            CGVector projectileForce = CGVectorMake(20.0, 100.0f);
            CGVector cannonForce = CGVectorMake(-8000.0, 0.0f);
            
            //Apply an impulse to the projectile, overtaking gravity and friction temporarily
            [shot.physicsBody applyImpulse:projectileForce
                                   atPoint:CGPointMake(cannon.frame.origin.x,
                                                       self.view.frame.size.height)];
            
            cannon.physicsBody =  [SKPhysicsBody bodyWithRectangleOfSize:cannon.size];
            
            [cannon.physicsBody applyImpulse:cannonForce
                                     atPoint:CGPointMake(cannon.frame.origin.x+cannon.frame.size.width,
                                                         cannon.frame.origin.y+cannon.frame.size.height/2)];
            
        }
        else if(hasProjectile)
        {
            
            CGVector projectileForce = CGVectorMake(0.001, (300.0f - shot.physicsBody.velocity.dy));
            
            [shot.physicsBody applyImpulse:projectileForce
                                   atPoint:CGPointMake(cannon.position.x,
                                                       cannon.position.y)];
        }
        
    }
}

-(void) addProjectile
{
    //Create a sprite based on our image, give it a position and name
    shot = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    shot.xScale = 0.2;
    shot.yScale = 0.2;
    
    
    // complex math regarding position -r*sin(a), r*cos(a)
    // r is the radius of the physics body of the cannon
    // a is the angle of the cannon (defined by cannon.zRotation)
    
    CGFloat r = cannon.frame.size.width-(cannon.frame.size.width/2);
    
    CGFloat a = cannon.zRotation;
    
    CGPoint pos = CGPointMake(((-r)*sinf(a)), (r*cosf(a)));
//    CGPoint pos = CGPointMake((r*cosf(a)), (r*sinf(a)));
    
    shot.position = CGPointMake(cannon.frame.size.width+pos.x+5,cannon.frame.size.height+pos.y+5);
    
//    shot.position = CGPointMake(cannon.frame.origin.x+cannon.frame.size.width, cannon.position.y);
    shot.zPosition = 0.0;
    shot.name = @"Projectile";
    
    shot.zRotation = cannon.zRotation;
    
    
    //Assign a physics body to the sprite
    shot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shot.size.width/2];
    
    //Assign properties to the physics body (these all exist and have default values upon the creation of the body)
    shot.physicsBody.restitution = 0.5;
    shot.physicsBody.density = 4;
    shot.physicsBody.friction = 1;
    shot.physicsBody.dynamic = YES;
    shot.physicsBody.allowsRotation = YES;
    shot.physicsBody.categoryBitMask = otherMask;
    shot.physicsBody.contactTestBitMask = objectiveMask;
    shot.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Add the sprite to the scene, with the physics body attached
    [self addChild:shot];
    
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches
            withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];

        CGFloat newCannonAngle = [self spriteAngleFrom:cannon.position
                                                    to:location];

        if(-1.6005 < newCannonAngle
           && newCannonAngle < 0.052333)
        {
        
            cannon.zRotation = newCannonAngle;
        }
        
    }
}

- (CGFloat) spriteAngleFrom:(CGPoint) start to:(CGPoint)finish
{
    float deltaX = finish.x - start.x;
    float deltaY = finish.y - start.y;
    
    return atan2(deltaY,deltaX) - M_PI/2;
}

-(void)update:(CFTimeInterval)currentTime
{
    if(hasProjectile)
    {
        [background update:currentTime];
//        camera.position = CGPointMake(shot.position.x, self.frame.size.height/2);
    }
    
    
}


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    if((contact.bodyA == shot.physicsBody
        || contact.bodyB == shot.physicsBody)
       && (contact.bodyA == floor.physicsBody
            || contact.bodyB == floor.physicsBody)
       && !(contact.bodyA == cannon.physicsBody
           || contact.bodyB == cannon.physicsBody))
    {
        hasProjectile = NO;
    }
    if((contact.bodyA == cannon.physicsBody
       || contact.bodyB == cannon.physicsBody)
       && (contact.bodyA == background.physicsBody
           || contact.bodyB == background.physicsBody))
    {
        [cannon removeFromParent];
    }
}

@end
