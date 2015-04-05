//
//  SFDrawNode.h
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SFDrawNode : SKSpriteNode

@property (nonatomic) SKColor *drawColor;

+ (instancetype)nodeWithSize:(CGSize)size;
@end
