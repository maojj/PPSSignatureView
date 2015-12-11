//
//  CGSize+TTUtils.m
//  Tutor
//
//  Created by maojj on 2/2/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import "CGSize+TTUtils.h"

CGSize fitSizeInSize(CGSize sourceSize, CGSize targetSize) {
    if (!targetSize.height || !targetSize.width || !sourceSize.width || !sourceSize.height) {
        return targetSize;
    }

    float widthRatio = targetSize.width / sourceSize.width;
    float heightRatio = targetSize.height / sourceSize.height;
    float scale = MIN(widthRatio, heightRatio);
    float newWidth = scale * sourceSize.width;
    float newHeight = scale * sourceSize.height;
    return CGSizeMake(newWidth, newHeight);
}

CGPoint TTMidPoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}