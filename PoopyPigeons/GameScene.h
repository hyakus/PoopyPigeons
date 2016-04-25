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
    SKScrollingNode *background;
    SKScrollingNode *floor;
    
    BOOL hasProjectile;
    
}


@end
