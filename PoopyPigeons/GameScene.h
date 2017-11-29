//
//  GameScene.h
//  PoopyPigeons
//

//  Copyright (c) 2016 Bryan Carter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKScrollingNode.h"


@interface GameScene : SKScene<SKPhysicsContactDelegate>
{
    
    SKSpriteNode* shot;
    SKSpriteNode *cannon;
    SKSpriteNode *cannonBase;
    SKScrollingNode *background;
    SKScrollingNode *floor;
    
    SKCameraNode* camera;
    
    BOOL hasProjectile;
    
}


@end
