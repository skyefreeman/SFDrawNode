//
//  SFDrawNode.m
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SFDrawNode.h"

@interface SFDrawNode()
@property (nonatomic) NSMutableArray *allPathColors;

@property (nonatomic) NSMutableArray *layers;
@property (nonatomic) CGMutablePathRef currentPath;

@property (nonatomic) SKShapeNode *currentDrawShape;

@end

@implementation SFDrawNode

#pragma mark - Designated init
+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.drawColor = [SKColor blackColor];
        self.layers = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - SKShapeNode Rendering
- (void)drawCircleAtPoint:(CGPoint)point {
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:5];
    [circle setFillColor:self.drawColor];
    [circle setStrokeColor:[SKColor clearColor]];
    [circle setPosition:point];
    [[self currentLayer] addChild:circle];
}

- (void)drawLineForPath:(CGPathRef)path {
    if (self.currentDrawShape) {
        [self.currentDrawShape removeFromParent];
    }
    
    self.currentDrawShape = [SKShapeNode shapeNodeWithPath:path];
    [self.currentDrawShape setLineWidth:10];
    [self.currentDrawShape setLineCap:kCGLineCapRound];
    [self.currentDrawShape setStrokeColor:self.drawColor];
    [[self currentLayer] addChild:self.currentDrawShape];
}

#pragma mark - Layering
- (void)newLayer {
    SKNode *layer = [SKNode new];
    [self addChild:layer];
    
    [self.layers addObject:layer];
}

- (SKNode*)currentLayer {
    return [self.layers lastObject];
}

- (void)eraseCurrentLayer {
    if (self.layers.count > 0) {
        SKNode *layer = [self.layers lastObject];
        [layer removeFromParent];
        [self.layers removeLastObject];
    }
}
#pragma mark - Touch Input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];

    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, point.x, point.y);
    self.currentPath = newPath;
    
    [self newLayer];
    [self drawCircleAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (!self.currentPath) return;
        
        CGPoint point = [touch locationInNode:self];
        CGPathAddLineToPoint(self.currentPath, nil, point.x, point.y);
    }
    
    [self drawLineForPath:self.currentPath];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.currentPath) {
        CGPathCloseSubpath(self.currentPath);
        self.currentPath = nil;
    }
    
    if (self.currentDrawShape) {
        SKShapeNode *endPathShape = self.currentDrawShape.copy;
        [[self currentLayer] addChild:endPathShape];
        
        [self.currentDrawShape removeFromParent];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
