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
@property (assign, nonatomic) REMenuItemView *itemView;
@end

@implementation REMenu

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (!self)
        return nil;
    
    _containerView = [[REMenuContainerView alloc] init];
    _menuView = [[UIView alloc] init];
    _menuWrapperView = [[UIView alloc] init];
    _menuView.layer.masksToBounds = YES;
    _menuView.layer.shouldRasterize = YES;
    _menuView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _menuWrapperView.layer.shouldRasterize = YES;
    _menuWrapperView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.items = items;
    self.itemHeight = 48;
    self.separatorHeight = 2;
    
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
    
    return self;
}

- (void)showFromNavigationController:(UINavigationController *)navigationController
{
    if ([_containerView.subviews count] == 0) {
        for (REMenuItem *item in _items) {
            NSInteger index = [_items indexOfObject:item];

            CGFloat itemHeight = _itemHeight;
            if (index == _items.count - 1) {
                itemHeight += _cornerRadius;
            }

            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, index * _itemHeight + (index) * _separatorHeight + 40, navigationController.view.frame.size.width, _separatorHeight)];
            separatorView.backgroundColor = _separatorColor;
            separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [_menuView addSubview:separatorView];

            REMenuItemView *itemView = [[REMenuItemView alloc] initWithFrame:CGRectMake(0, index * _itemHeight + (index+1) * _separatorHeight + 40, navigationController.view.frame.size.width, itemHeight) menu:self hassubtitle:item.subtitle.length > 0];
            itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            itemView.item = item;
            item.itemView = itemView;
            itemView.separatorView = separatorView;
            itemView.autoresizesSubviews = YES;
            [_menuView addSubview:itemView];

        }

        _menuWrapperView.frame = CGRectMake(0, - self.combinedHeight, navigationController.navigationBar.frame.size.width, self.combinedHeight);
        _menuView.frame = _menuWrapperView.bounds;
        [_menuWrapperView addSubview:_menuView];

        _menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _menuWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth;


        _containerView = [[REMenuContainerView alloc] initWithFrame:CGRectMake(0, navigationController.navigationBar.frame.origin.y + navigationController.navigationBar.frame.size.height, navigationController.navigationBar.frame.size.width, navigationController.view.frame.size.height - navigationController.navigationBar.frame.origin.y - navigationController.navigationBar.frame.size.height)];
        _containerView.bar = navigationController.navigationBar;
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _containerView.clipsToBounds = YES;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _containerView.bounds;
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:button];
        [_containerView addSubview:_menuWrapperView];
    }
    
    [navigationController.view addSubview:_containerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _menuView.frame;
        frame.origin.y = -40 - _separatorHeight;
        _menuWrapperView.frame = frame;
    } completion:nil];
    
    _isOpen = YES;

}

- (void)close
{
    _isOpen = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _menuView.frame;
        frame.origin.y = -20;
        _menuWrapperView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _menuView.frame;
            frame.origin.y = - self.combinedHeight;
            _menuWrapperView.frame = frame;
        } completion:^(BOOL finished) {
            [_containerView removeFromSuperview];
        }];
    }];
}

- (CGFloat)combinedHeight
{
    return _items.count * _itemHeight + _items.count  * _separatorHeight + 40 + _cornerRadius;
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

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    _menuView.layer.cornerRadius = cornerRadius;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    _menuWrapperView.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    _menuWrapperView.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    _menuWrapperView.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    _menuWrapperView.layer.shadowRadius = shadowRadius;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    _menuView.backgroundColor = backgroundColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _menuView.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _menuView.layer.borderWidth = borderWidth;
}

@end
