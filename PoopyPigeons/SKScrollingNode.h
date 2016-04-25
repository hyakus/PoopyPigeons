//
//  SKScrollingNode.h
//  PoopyPigeons
//
//  Created by Bryan Carter on 31/03/2016.
//  Copyright © 2016 Bryan Carter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

+ (id) scrollingNodeWithImageNamed:(NSString *)name
                  inContainerWidth:(float) width;
+ (id) scrollingNodeWithImageNamed:(NSString *)name
                  inContainerWidth:(float) width
                        withHeight:(float) height;
- (void) update:(NSTimeInterval)currentTime;


@end
