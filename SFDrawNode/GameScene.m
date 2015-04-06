//
//  GameScene.m
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "GameScene.h"
#import "SFDrawNode.h"

@interface GameScene()
@property (nonatomic) SFDrawNode *drawNode;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self setBackgroundColor:[SKColor whiteColor]];
    
    self.drawNode = [SFDrawNode nodeWithSize:CGSizeMake(self.size.width, self.size.height)];
    [self.drawNode setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [self addChild:self.drawNode];

    SKSpriteNode *button = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(100, 100)];
    [button setPosition:CGPointMake(button.size.width/2, button.size.height/2)];
    [button setName:@"button"];
    [button setZPosition:10];
    [self addChild:button];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    
    if ([node.name isEqualToString:@"button"]) {
        [self.drawNode eraseCanvas];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
