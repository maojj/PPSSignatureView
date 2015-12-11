//
//  TTHandDrawView.h
//  Tutor
//
//  Created by maojj on 1/28/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTHandDrawView;

@protocol TTHandDrawDelegate <NSObject>

/**
 *  完成一个stroke, 0-1相对坐标点
 */
- (void)handDrawView:(TTHandDrawView *)drawView strokeEndedWithPoints:(NSArray *)points;

@end

@interface TTHandDrawView : UIView

@property (nonatomic, weak) id<TTHandDrawDelegate> delegate;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  当前坐标点 绝对值
 */
- (NSArray *)currentStrokePoints;

/**
 *  0-1 的相对坐标点
 */
- (NSArray *)_currentStrokeRelativePoints;

- (void)clear;

@end
