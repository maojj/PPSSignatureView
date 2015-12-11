//
//  TTHandDrawView.m
//  Tutor
//
//  Created by maojj on 1/28/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import "TTHandDrawView.h"
#import "CGSize+TTUtils.h"

static CGFloat defaultLineWitdh = 1.5f;

@implementation TTHandDrawView {
    UIBezierPath *_path;
    NSMutableArray *_currentStrokePoints;
    CGPoint _previousPoint;
    CGFloat _lineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    _path = [UIBezierPath bezierPath];
    _path.lineWidth = 2.f;
    _currentStrokePoints = [NSMutableArray array];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
//    [self addGestureRecognizer:pan];
}

- (UIColor *)strokeColor {
    if (_strokeColor == nil) {
        _strokeColor = [UIColor greenColor];
    }
    return _strokeColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (CGFloat)lineWidth {
    if (_lineWidth < 0.001) {
        _lineWidth = defaultLineWitdh;
    }
    return _lineWidth;
}

//- (void)pan:(UIPanGestureRecognizer *)pan {
//    CGPoint currPoint = [pan locationInView:self];
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        [self addPoint:currPoint];
//    } else if (pan.state == UIGestureRecognizerStateChanged) {
//        [self addPoint:currPoint];
//    } else if (pan.state == UIGestureRecognizerStateEnded) {
//        [self addPoint:currPoint];
//        [self strokeEnded];
//    }
//    [self setNeedsDisplay];b
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin touches:%@", touches);
    NSLog(@"begin event:%@", event);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self addPoint:point forStart:YES];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"move touches:%@", touches);
    NSLog(@"move event:%@", event);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self addPoint:point];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"end touches:%@", touches);
    NSLog(@"end event:%@", event);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self addPoint:point];
    [self strokeEnded];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancel touches:%@", touches);
    NSLog(@"cancel event:%@", event);
    [self strokeEnded];
    [self setNeedsDisplay];
}

- (void)addPoint:(CGPoint)currpoint {
    [self addPoint:currpoint forStart:NO];
}

- (void)addPoint:(CGPoint)currPoint forStart:(BOOL)start {

    if (_currentStrokePoints.count > 0) {
        CGPoint midPoint = TTMidPoint(_previousPoint, currPoint);
        [_path addQuadCurveToPoint:midPoint controlPoint:_previousPoint];
    } else {
        [_path moveToPoint:currPoint];
    }
    _previousPoint = currPoint;
    [_currentStrokePoints addObject:[NSValue valueWithCGPoint:currPoint]];
}

- (BOOL)shouldAddPoint:(CGPoint)point {
    if (!(_currentStrokePoints.count > 0)) {
        return YES;
    }

    CGPoint previousPoint = [(NSValue *)_currentStrokePoints.lastObject CGPointValue];
    CGFloat difX = previousPoint.x - point.x;
    CGFloat difY = previousPoint.y - point.y;
    CGFloat dist2 = difX * difX + difY * difY;
    CGFloat threshold = [self lineWidth] * 3;
    BOOL shouldAdd = (dist2 > threshold * threshold);
    return shouldAdd;
}

- (void)erase {
    [_path removeAllPoints];
    [_currentStrokePoints removeAllObjects];
    [self setNeedsDisplay];
}

- (void)strokeEnded {
    NSMutableArray *relativePoints = [NSMutableArray arrayWithCapacity:_currentStrokePoints.count];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;

    if (!(_currentStrokePoints.count > 0)) {
        return;
    } else if (_currentStrokePoints.count == 1) {
        CGPoint center = [_currentStrokePoints.firstObject CGPointValue];
        CGFloat radius = [self lineWidth] / 2.f;
        CGRect dotRect = CGRectMake(center.x - radius / 2.f, center.y - radius / 2.f, radius, radius);
        _path = [UIBezierPath bezierPathWithOvalInRect:dotRect];
    }

    [_currentStrokePoints enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
        CGPoint point = [pointValue CGPointValue];
        CGPoint relativePoint = CGPointMake(point.x / width, point.y / height);
        [relativePoints addObject:[NSValue valueWithCGPoint:relativePoint]];
    }];

    [_currentStrokePoints removeAllObjects];
    [_delegate handDrawView:self strokeEndedWithPoints:relativePoints];
}

- (void)clear {
    [self erase];
}

/**
 *  坐标点 绝对值
 */
- (NSArray *)currentStrokePoints {
    return _currentStrokePoints;
}

/**
 *  0-1 的相对坐标点
 */
- (NSArray *)_currentStrokeRelativePoints {
    return _currentStrokePoints;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    _path.lineWidth = [self lineWidth];
    [[self strokeColor] setStroke];
    [_path stroke];
    CGContextRestoreGState(context);
}

@end
