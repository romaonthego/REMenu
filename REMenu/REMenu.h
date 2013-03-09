//
// REMenu.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "REMenuItem.h"
#import "REMenuContainerView.h"

@class REMenuItem;

@interface REMenu : NSObject {
    UIView *_menuView;
    UIView *_menuWrapperView;
    REMenuContainerView *_containerView;
    NSMutableArray *_itemViews;
    UIButton *_backgroundButton;
}

// Data
//
@property (strong, readwrite, nonatomic) NSArray *items;
@property (assign, readonly, nonatomic) BOOL isOpen;
@property (assign, readwrite, nonatomic) BOOL waitUntilAnimationIsComplete;
@property (copy, readwrite, nonatomic) void (^closeCompletionHandler)(void);

// Style
//
@property (assign, readwrite, nonatomic) CGFloat cornerRadius;
@property (strong, readwrite, nonatomic) UIColor *shadowColor;
@property (assign, readwrite, nonatomic) CGSize shadowOffset;
@property (assign, readwrite, nonatomic) CGFloat shadowOpacity;
@property (assign, readwrite, nonatomic) CGFloat shadowRadius;
@property (assign, readwrite, nonatomic) CGFloat itemHeight;
@property (strong, readwrite, nonatomic) UIColor *backgroundColor;
@property (strong, readwrite, nonatomic) UIColor *separatorColor;
@property (assign, readwrite, nonatomic) CGFloat separatorHeight;
@property (strong, readwrite, nonatomic) UIFont *font;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *textShadowColor;
@property (assign, readwrite, nonatomic) CGSize imageOffset;
@property (assign, readwrite, nonatomic) CGSize textOffset;
@property (assign, readwrite, nonatomic) CGSize textShadowOffset;
@property (strong, readwrite, nonatomic) UIColor *highlightedBackgroundColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedSeparatorColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedTextColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize highlightedTextShadowOffset;
@property (assign, readwrite, nonatomic) CGFloat borderWidth;
@property (strong, readwrite, nonatomic) UIColor *borderColor;
@property (assign, readwrite, nonatomic) NSTextAlignment textAlignment;
@property (strong, readwrite, nonatomic) UIFont *subtitleFont;
@property (strong, readwrite, nonatomic) UIColor *subtitleTextColor;
@property (strong, readwrite, nonatomic) UIColor *subtitleTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize subtitleTextOffset;
@property (assign, readwrite, nonatomic) CGSize subtitleTextShadowOffset;
@property (strong, readwrite, nonatomic) UIColor *subtitleHighlightedTextColor;
@property (strong, readwrite, nonatomic) UIColor *subtitleHighlightedTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize subtitleHighlightedTextShadowOffset;
@property (assign, readwrite, nonatomic) NSTextAlignment subtitleTextAlignment;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;

- (id)initWithItems:(NSArray *)items;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view;
- (void)showInView:(UIView *)view;
- (void)showFromNavigationController:(UINavigationController *)navigationController;
- (void)closeWithCompletion:(void (^)(void))completion;
- (void)close;

@end
