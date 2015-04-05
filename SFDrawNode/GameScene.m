//
//  GameScene.m
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "GameScene.h"
#import "SFDrawNode.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self setBackgroundColor:[SKColor whiteColor]];
    
    SFDrawNode *drawNode = [SFDrawNode nodeWithSize:self.size];
    [drawNode setAnchorPoint:CGPointMake(0, 0)];
    [self addChild:drawNode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
