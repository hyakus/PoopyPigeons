//
//  SKScrollingNode.m
//  PoopyPigeons
//
//  Created by Bryan Carter on 31/03/2016.
//  Copyright © 2016 Bryan Carter. All rights reserved.
//

#import "SKScrollingNode.h"

@implementation SKScrollingNode

+ (id) scrollingNodeWithImageNamed:(NSString *)name
                  inContainerWidth:(float) width
{
    UIImage * image = [UIImage imageNamed:name];
    
    SKScrollingNode * realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor]
                                                                 size:CGSizeMake(width, image.size.height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(width + image.size.width))
    {
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}

+ (id) scrollingNodeWithImageNamed:(NSString *)name
                  inContainerWidth:(float) width
                        withHeight:(float) height
{
    UIImage * image = [UIImage imageNamed:name];
    
    SKScrollingNode * realNode = [SKScrollingNode spriteNodeWithColor:[UIColor clearColor]
                                                                 size:CGSizeMake(width, height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(width + image.size.width))
    {
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}

- (void) update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop)
     {
         SKSpriteNode *child = (SKSpriteNode *)object;
         child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
         if (child.position.x <= -child.size.width)
         {
             float delta = child.position.x+child.size.width;
             child.position = CGPointMake(child.size.width*(self.children.count-1)+delta, child.position.y);
         }
     }];

}



@end
