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


@property (nonatomic) NSMutableArray *currentPathSegments;

@property (nonatomic) SKShapeNode *currentDrawShape;

@end

@implementation SFDrawNode {
    NSMutableArray *_pool;
    SKSpriteNode *_canvas;
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

        _pool = [NSMutableArray new];
        [self populateShapeNodePool];
        
        _canvas = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [self addChild:_canvas];
        
        self.drawColor = [SKColor blackColor];
    }
    
    return self;
}

#pragma mark - SKShapeNode Pool
- (void)populateShapeNodePool {
    for (int i = 0; i < 5; i++) {
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
    SKTexture *cachedTexture = [self.scene.view textureFromNode:self];
    [_canvas setTexture:cachedTexture];
    
    [_canvas enumerateChildNodesWithName:@"segment" usingBlock:^(SKNode *node, BOOL *stop) {
        [_pool addObject:node];
        [node removeFromParent];
    }];
}

#pragma mark - Segment Rendering
- (void)drawLineFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint {

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, nil, secondPoint.x, secondPoint.y);
    
    SKShapeNode *newSegment = [self getShapeFromPool];
    [newSegment setStrokeColor:self.drawColor];
    [newSegment setLineWidth:10.0];
    [newSegment setLineCap:kCGLineCapRound];
    [newSegment setName:@"segment"];
    [newSegment setPath:path];
    
    _lastPoint = secondPoint;
    [_canvas addChild:newSegment];
}

#pragma mark - DrawNode Controls
- (void)eraseCanvas {
    [_canvas setTexture:nil];
}

#pragma mark - Touch Input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self cacheSegments];
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInNode:self];
        _lastPoint = point;
        [self drawLineFromPoint:_lastPoint toPoint:point];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInNode:self];
        [self drawLineFromPoint:_lastPoint toPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self cacheSegments];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
