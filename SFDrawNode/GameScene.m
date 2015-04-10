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

    SKSpriteNode *redButton = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(100, 100)];
    [redButton setPosition:CGPointMake(redButton.size.width/2, redButton.size.height/2)];
    [redButton setName:@"red"];
    [redButton setZPosition:10];
    [self addChild:redButton];
    
    SKSpriteNode *greenButton = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(100, 100)];
    [greenButton setPosition:CGPointMake(greenButton.size.width/2 + redButton.size.width, greenButton.size.height/2)];
    [greenButton setName:@"green"];
    [greenButton setZPosition:10];
    [self addChild:greenButton];
    
    SKLabelNode *erase = [SKLabelNode labelNodeWithText:@"Erase"];
    [erase setFontColor:[SKColor blackColor]];
    erase.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    erase.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [erase setName:@"erase"];
    [erase setPosition:CGPointMake(self.size.width/2, 50)];
    [erase setZPosition:10];
    [self addChild:erase];
    
    SKLabelNode *fadeOut = [SKLabelNode labelNodeWithText:@"Fadeout"];
    [fadeOut setFontColor:[SKColor blackColor]];
    fadeOut.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    fadeOut.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [fadeOut setName:@"fadeOut"];
    [fadeOut setPosition:CGPointMake(self.size.width/4, 50)];
    [fadeOut setZPosition:10];
    [self addChild:fadeOut];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    
    if ([node.name isEqualToString:@"red"]) {
        [self.drawNode setDrawColor:[SKColor redColor]];
    }
    
    if ([node.name isEqualToString:@"green"]) {
        [self.drawNode setDrawColor:[SKColor greenColor]];
    }
    
    if ([node.name isEqualToString:@"erase"]) {
        [self.drawNode eraseCanvas];
    }
    
    if ([node.name isEqualToString:@"fadeOut"]) {
        [self.drawNode fadeOutCanvasWithDuration:1];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
