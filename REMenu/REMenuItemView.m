//
// REMenuItemView.m
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

#import "REMenuItemView.h"

@implementation REMenuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _titleLabel.contentMode = UIViewContentModeCenter;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageOffset = (self.frame.size.height - _item.image.size.height) / 2.0;
    _imageView.image = _item.image;
    _imageView.frame = CGRectMake(imageOffset, imageOffset, _item.image.size.height, _item.image.size.height);
    
    _titleLabel.font = _menu.font;
    _titleLabel.text = _item.title;
    _titleLabel.textColor = _menu.textColor;
    _titleLabel.shadowColor = _menu.textShadowColor;
    _titleLabel.shadowOffset = _menu.textShadowOffset;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _menu.highligtedBackgroundColor;
    _separatorView.backgroundColor = _menu.highlightedSeparatorColor;
    _imageView.image = _item.higlightedImage ? _item.higlightedImage : _item.image;
    _titleLabel.textColor = _menu.highlighedTextColor;
    _titleLabel.shadowColor = _menu.highlighedTextShadowColor;
    _titleLabel.shadowOffset = _menu.highlighedTextShadowOffset;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    _separatorView.backgroundColor = _menu.separatorColor;
    _imageView.image = _item.image;
    _titleLabel.textColor = _menu.textColor;
    _titleLabel.shadowColor = _menu.textShadowColor;
    _titleLabel.shadowOffset = _menu.textShadowOffset;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    _separatorView.backgroundColor = _menu.separatorColor;
    _imageView.image = _item.image;
    _titleLabel.textColor = _menu.textColor;
    _titleLabel.shadowColor = _menu.textShadowColor;
    _titleLabel.shadowOffset = _menu.textShadowOffset;
    [_menu close];
    if (_item.action) {
        _item.action(_item);
    }
}

@end
