//
//  SFDrawNode.m
//  SFDrawNode
//
//  Created by Skye on 4/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SFDrawNode.h"

#define kDefaultColor [SKColor blackColor];
CGFloat const kDefaultLineWidth = 10.0;
CGFloat const kDefaultLineCap = kCGLineCapRound;

NSUInteger const kCacheSize = 10;

@interface SFDrawNode()
@end

@implementation SFDrawNode {
    NSMutableDictionary * _currentPaths;
    NSMutableArray * _pool;
    SKSpriteNode * _canvas;
    CGPoint _lastPoint;
}

#pragma mark - Designated init
+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.drawColor = kDefaultColor;
        self.lineWidth = kDefaultLineWidth;
        self.lineCap = kDefaultLineCap;
        
        _pool = [NSMutableArray new];
        [self populateShapeNodePool];
        
        _canvas = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [self addChild:_canvas];

        _currentPaths = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - SKShapeNode Pool
- (void)populateShapeNodePool {
    if (_pool.count > 0) {
        [_pool removeAllObjects];
    }
    
    for (int i = 0; i < kCacheSize; i++) {
        SKShapeNode *segment = [SKShapeNode new];
        [_pool addObject:segment];
    }
}

- (SKShapeNode*)getShapeFromPool {
    if (_pool.count == 0) {
        [self cacheSegments];
    }
    
    SKShapeNode *segment = [_pool objectAtIndex:0];
    [_pool removeObjectAtIndex:0];
    return segment;
}

- (void)cacheSegments {
    SKTexture *cachedTexture = [self.scene.view textureFromNode:self crop:self.frame];
    [_canvas setTexture:cachedTexture];
    
    [_canvas enumerateChildNodesWithName:@"segment" usingBlock:^(SKNode *node, BOOL *stop) {
        [_pool addObject:node];
        [node removeFromParent];
    }];
}

#pragma mark - Segment Rendering
- (CGPathRef)newPathFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, nil, secondPoint.x, secondPoint.y);
    return path;
}

- (SKShapeNode*)newShapeWithPath:(CGPathRef)path {
    SKShapeNode *segment = [self getShapeFromPool];
    [segment setStrokeColor:self.drawColor];
    [segment setLineWidth:self.lineWidth];
    [segment setLineCap:self.lineCap];
    [segment setName:@"segment"];
    [segment setPath:path];
    [segment setZPosition:1];
    return segment;
}

- (void)drawLineFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint key:(NSString*)key {
    CGPathRef path = [self newPathFromPoint:firstPoint toPoint:secondPoint];
    SKShapeNode *drawPath = [self newShapeWithPath:path];
    [_canvas addChild:drawPath];

    CGPathRelease(path);
    
    _lastPoint = secondPoint;
}

#pragma mark - DrawNode Controls
- (void)eraseCanvas {
    [_canvas setTexture:nil];
}

- (void)fadeOutCanvasWithDuration:(CGFloat)duration {
    if ([_canvas hasActions]) return;
    
    self.userInteractionEnabled = NO;
    [_canvas runAction:[SKAction fadeOutWithDuration:duration] completion:^{
        [self eraseCanvas];
        self.userInteractionEnabled = YES;
        [_canvas setAlpha:1];
    }];
}

#pragma mark - Touch Input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self cacheSegments];
    for (UITouch *touch in touches) {
        NSString *key = [NSString stringWithFormat:@"%d",(int)touch];
        CGPoint point = [touch locationInNode:self];
        _lastPoint = point;
        
        [self drawLineFromPoint:_lastPoint toPoint:point key:key];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        NSString *key = [NSString stringWithFormat:@"%d",(int)touch];
        CGPoint point = [touch locationInNode:self];
        
        if (CGRectContainsPoint(_canvas.frame, point)) {
            [self drawLineFromPoint:_lastPoint toPoint:point key:key];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self cacheSegments];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
