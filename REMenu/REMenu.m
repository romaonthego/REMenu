//
// REMenu.m
// REMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REMenu.h"
#import "REMenuItem.h"
#import "REMenuItemView.h"


@interface REMenuItem ()

@property (assign, readwrite, nonatomic) REMenuItemView *itemView;

@end

@interface REMenu ()

@property (strong, readwrite, nonatomic) UIView *menuView;
@property (strong, readwrite, nonatomic) UIView *menuWrapperView;
@property (strong, readwrite, nonatomic) REMenuContainerView *containerView;
@property (strong, readwrite, nonatomic) UIButton *backgroundButton;
@property (assign, readwrite, nonatomic) BOOL isOpen;
@property (strong, readwrite, nonatomic) NSMutableArray *itemViews;

@end

@implementation REMenu

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.imageAlignment = REMenuImageAlignmentLeft;
    self.closeOnSelection = YES;
    self.itemHeight = 48;
    self.separatorHeight = 2;
    self.waitUntilAnimationIsComplete = YES;
    
    self.textOffset = CGSizeMake(0, 0);
    self.subtitleTextOffset = CGSizeMake(0, 0);
    self.font = [UIFont boldSystemFontOfSize:21];
    self.subtitleFont = [UIFont systemFontOfSize:14];
    
    self.backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    self.separatorColor = [UIColor colorWithPatternImage:self.separatorImage];
    self.textColor = [UIColor colorWithRed:128/255.0 green:126/255.0 blue:124/255.0 alpha:1];
    self.textShadowColor = [UIColor blackColor];
    self.textShadowOffset = CGSizeMake(0, -1);
    self.textAlignment = NSTextAlignmentCenter;
    
    self.highlightedBackgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
    self.highlightedSeparatorColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
    self.highlightedTextColor = [UIColor colorWithRed:128/255.0 green:126/255.0 blue:124/255.0 alpha:1];
    self.highlightedTextShadowColor = [UIColor blackColor];
    self.highlightedTextShadowOffset = CGSizeMake(0, -1);
    
    self.subtitleTextColor = [UIColor colorWithWhite:0.425 alpha:1.000];
    self.subtitleTextShadowColor = [UIColor blackColor];
    self.subtitleTextShadowOffset = CGSizeMake(0, -1);
    self.subtitleHighlightedTextColor = [UIColor colorWithRed:0.389 green:0.384 blue:0.379 alpha:1.000];
    self.subtitleHighlightedTextShadowColor = [UIColor blackColor];
    self.subtitleHighlightedTextShadowOffset = CGSizeMake(0, -1);
    self.subtitleTextAlignment = NSTextAlignmentCenter;
    
    self.borderWidth = 1;
    self.borderColor =  [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1];
    self.animationDuration = 0.3;
    self.bounce = YES;
    self.bounceAnimationDuration = 0.2;
    
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (!self)
        return nil;
    
    self.items = items;

    return self;
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view
{
    self.isOpen = YES;
    
    // Create views
    //
    self.containerView = [[REMenuContainerView alloc] init];
    
    if (self.backgroundView) {
        self.backgroundView.alpha = 0;
        [self.containerView addSubview:self.backgroundView];
    }
    
    self.menuView = [[UIView alloc] init];
    self.menuWrapperView = [[UIView alloc] init];
    
    self.containerView.clipsToBounds = YES;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.menuView.backgroundColor = self.backgroundColor;
    self.menuView.layer.cornerRadius = self.cornerRadius;
    self.menuView.layer.borderColor = self.borderColor.CGColor;
    self.menuView.layer.borderWidth = self.borderWidth;
    self.menuView.layer.masksToBounds = YES;
    self.menuView.layer.shouldRasterize = YES;
    self.menuView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.menuWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.menuWrapperView.layer.shadowColor = self.shadowColor.CGColor;
    self.menuWrapperView.layer.shadowOffset = self.shadowOffset;
    self.menuWrapperView.layer.shadowOpacity = self.shadowOpacity;
    self.menuWrapperView.layer.shadowRadius = self.shadowRadius;
    self.menuWrapperView.layer.shouldRasterize = YES;
    self.menuWrapperView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backgroundButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundButton.accessibilityLabel = NSLocalizedString(@"Menu background", @"Menu background");
    self.backgroundButton.accessibilityHint = NSLocalizedString(@"Double tap to close", @"Double tap to close");
    [self.backgroundButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    // Append new item views to REMenuView
    //
    for (REMenuItem *item in self.items) {
        NSInteger index = [self.items indexOfObject:item];
        
        CGFloat itemHeight = self.itemHeight;
        if (index == self.items.count - 1)
            itemHeight += self.cornerRadius;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         index * self.itemHeight + (index) * self.separatorHeight + 40,
                                                                         rect.size.width,
                                                                         self.separatorHeight)];
        separatorView.backgroundColor = self.separatorColor;
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.menuView addSubview:separatorView];
        
        REMenuItemView *itemView = [[REMenuItemView alloc] initWithFrame:CGRectMake(0,
                                                                                    index * self.itemHeight + (index+1) * self.separatorHeight + 40,
                                                                                    rect.size.width,
                                                                                    itemHeight)
                                                                    menu:self
                                                             hasSubtitle:item.subtitle.length > 0];
        itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        itemView.item = item;
        item.itemView = itemView;
        itemView.separatorView = separatorView;
        itemView.autoresizesSubviews = YES;
        if (item.customView) {
            item.customView.frame = itemView.bounds;
            [itemView addSubview:item.customView];
        }
        [self.menuView addSubview:itemView];
    }
    
    // Set up frames
    //
    self.menuWrapperView.frame = CGRectMake(0,
                                        - self.combinedHeight,
                                        rect.size.width,
                                        self.combinedHeight);
    self.menuView.frame = self.menuWrapperView.bounds;
    
    self.containerView.frame = CGRectMake(rect.origin.x,
                                      rect.origin.y,
                                      rect.size.width,
                                      rect.size.height);
    
    self.backgroundButton.frame = self.containerView.bounds;
    
    // Add subviews
    //
    [self.menuWrapperView addSubview:self.menuView];
    [self.containerView addSubview:self.backgroundButton];
    [self.containerView addSubview:self.menuWrapperView];
    [view addSubview:self.containerView];
    
    // Animate appearance
    //
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundView.alpha = 1.0;
        CGRect frame = self.menuView.frame;
        frame.origin.y = -40 - self.separatorHeight;
        self.menuWrapperView.frame = frame;
    } completion:nil];
}

- (void)showInView:(UIView *)view
{
    [self showFromRect:view.bounds inView:view];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController
{
    [self showFromRect:CGRectMake(0, 0, navigationController.navigationBar.frame.size.width, navigationController.view.frame.size.height)
                inView:navigationController.view];
    self.containerView.navigationBar = navigationController.navigationBar;
}

- (void)closeWithCompletion:(void (^)(void))completion
{
    void (^closeMenu)(void) = ^{
        [UIView animateWithDuration:self.animationDuration animations:^{
            CGRect frame = self.menuView.frame;
            frame.origin.y = - self.combinedHeight;
            self.menuWrapperView.frame = frame;
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.menuView removeFromSuperview];
            [self.menuWrapperView removeFromSuperview];
            [self.backgroundButton removeFromSuperview];
            [self.containerView removeFromSuperview];
            self.isOpen = NO;
            if (completion)
                completion();
            
            if (self.closeCompletionHandler)
                self.closeCompletionHandler();
        }];
    };
    
    if (self.bounce) {
        [UIView animateWithDuration:self.bounceAnimationDuration animations:^{
            CGRect frame = self.menuView.frame;
            frame.origin.y = -20;
            self.menuWrapperView.frame = frame;
        } completion:^(BOOL finished) {
            closeMenu();
        }];
    } else {
        closeMenu();
    }
}

- (void)close
{
    [self closeWithCompletion:nil];
}

- (CGFloat)combinedHeight
{
    return self.items.count * self.itemHeight + self.items.count  * self.separatorHeight + 40 + self.cornerRadius;
}

- (void)setNeedsLayout
{
    [UIView animateWithDuration:0.35 animations:^{
        [self.containerView layoutSubviews];
    }];
}

#pragma mark -
#pragma mark Setting style

- (UIImage *)separatorImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 4));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 2));
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:79/255.0 green:79/255.0 blue:77/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, 3, 1, 2));
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:outputImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
}

@end
