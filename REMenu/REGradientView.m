//
//  REGradientView.m
//  CitationsDAmour
//
//  Created by Sovanna Hing on 09/03/13.
//  Copyright (c) 2013 Swelen. All rights reserved.
//

#import "REGradientView.h"

@implementation REGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 1};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    
    CGColorSpaceRelease(colorSpace), colorSpace = NULL;
    
    CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), 0);
    CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
}

@end
