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

    [self createCannonInitShot];
    
    [self createBackground];
    
    [self createGround];
    
    self.physicsWorld.contactDelegate = self;
}


- (void) createCannonInitShot
{
    cannon = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    shot = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    cannon.xScale = 0.5;
    cannon.yScale = 0.5;
    
    cannon.physicsBody =  [SKPhysicsBody bodyWithCircleOfRadius:cannon.size.width/2];
    
    cannon.physicsBody.categoryBitMask = shotBitMask;
    
    cannon.position = CGPointMake(self.frame.size.width/6,
                                  self.frame.size.height/2 - 140);
    
    [self addChild:cannon];
}


- (void) createBackground
{
    background = [SKScrollingNode scrollingNodeWithImageNamed:@"Trail"
                                             inContainerWidth:self.frame.size.width
                                                   withHeight:self.frame.size.height];
    [background setScrollingSpeed:130.0];
    [background setAnchorPoint:CGPointZero];
    [background setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    background.physicsBody.categoryBitMask = backBitMask;
    background.physicsBody.contactTestBitMask = shotBitMask;
    [self addChild:background];
}

- (void) createGround
{
    floor = [SKScrollingNode scrollingNodeWithImageNamed:@"floor"
                                        inContainerWidth:self.frame.size.width];
    [floor setScrollingSpeed:25.0];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = shotBitMask;
    [self addChild:floor];
}

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        
        CGPoint location = [touch locationInNode:self];
        
        //Check if there is already a projectile in the scene
        if (!hasProjectile
            && CGRectContainsPoint(cannon.frame,location))
        {
        
            //If not, add it
            hasProjectile = YES;
            [self addProjectile];
            
            //Create a Vector to use as a 2D force value
            CGVector projectileForce = CGVectorMake(800.0f, 800.0f);
            
            
                    //Apply an impulse to the projectile, overtaking gravity and friction temporarily
                    [shot.physicsBody applyImpulse:projectileForce
                                           atPoint:CGPointMake(cannon.frame.origin.x+cannon.frame.size.width,self.view.frame.size.height)];
            
        }
        
        
    }
}

-(void) addProjectile
{
    //Create a sprite based on our image, give it a position and name
    shot = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    shot.xScale = 0.2;
    shot.yScale = 0.2;
    shot.position = CGPointMake(cannon.frame.origin.x+cannon.frame.size.width, cannon.position.y);
    shot.zPosition = 20;
    shot.name = @"Projectile";
    
    //Assign a physics body to the sprite
    shot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shot.size.width/2];
    
    //Assign properties to the physics body (these all exist and have default values upon the creation of the body)
    shot.physicsBody.restitution = 0.5;
    shot.physicsBody.density = 5;
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
    }
    
    
}


- (void) didBeginContact:(SKPhysicsContact *)contact
{
    hasProjectile = NO;
}

@end
