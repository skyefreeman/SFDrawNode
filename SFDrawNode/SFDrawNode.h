//
//  SFDrawNode.h
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SFDrawNode : SKSpriteNode

@property (nonatomic) CGLineCap lineCap;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) SKColor *drawColor;

// Creates a drawing canvas with a given size.
+ (instancetype)nodeWithSize:(CGSize)size;

// Erases the canvas.
- (void)eraseCanvas;

// Fade out then erase the canvas.
- (void)fadeOutCanvasWithDuration:(CGFloat)duration;

@end

