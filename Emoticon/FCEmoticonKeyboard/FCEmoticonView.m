//
//  FCEmoticonView.m
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "FCEmoticonView.h"

@interface FCEmoticonView ()
@property (nonatomic,assign)UIEdgeInsets fcMargin;//边距
@property (nonatomic,assign)CGFloat emoticonWidth;//表情宽
@property (nonatomic,assign)CGFloat itemWidth;//点击范围宽
@property (nonatomic,assign)CGFloat itemHeight;//点击范围高


@end

@implementation FCEmoticonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    return self;
}

- (void)setEmoticons:(NSArray *)emoticons{
    _emoticons = emoticons;
    [self setNeedsDisplay];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    NSInteger index = [self fc_indexWithLocation:[tapGesture locationInView:self]];
    if (index < 0 || index >= _emoticons.count) {
        return;
    }
    FCEmoticon *emoticon = _emoticons[index];
    NSLog(@"%@",emoticon.name);
    if ([_delegate respondsToSelector:@selector(fc_clickEmoticonInfo:)]) {
        [_delegate fc_clickEmoticonInfo:emoticon];
    }
}

- (void)loadDefaultData{
    _fcMargin = UIEdgeInsetsMake(0, 10, 20, 10);
    _itemWidth = (CGRectGetWidth(self.frame) - _fcMargin.left - _fcMargin.right) / _fcmatrix.columns;
    _itemHeight = (CGRectGetHeight(self.frame) - _fcMargin.top - _fcMargin.bottom) / _fcmatrix.rows;

}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self loadDefaultData];
    NSInteger index = 0;
    for (FCEmoticon *emoticon in _emoticons) {
        UIImage *image = [UIImage imageWithContentsOfFile:emoticon.path];
        [self drawImage:image index:index];
        index ++;
    }
    
}

- (void)drawImage:(UIImage *)image index:(NSUInteger)index{
    CGFloat leftMargin = 5;//(_itemWidth - 30) / 2.0;
    CGFloat topMargin = 5;//(_itemHeight - 30) / 2.0;
    CGFloat x = _fcMargin.left + _itemWidth * ((CGFloat)(index % _fcmatrix.columns)) + leftMargin;
    CGFloat y = _fcMargin.top + _itemHeight * ((CGFloat)(index / _fcmatrix.columns)) + topMargin;
    [image drawInRect:CGRectMake(x, y, _itemWidth - 2 * 5, _itemHeight - 2 * 5)];
}


- (NSInteger)fc_indexWithLocation:(CGPoint)point{
    
    if (point.x < _fcMargin.left || point.x > CGRectGetWidth(self.frame) - _fcMargin.right || point.y < _fcMargin.top || point.y > CGRectGetHeight(self.frame) - _fcMargin.bottom){
        return -1;
    }
    NSInteger column = (NSInteger)((point.x - _fcMargin.left) / _itemWidth);
    NSInteger row    = (NSInteger)((point.y - _fcMargin.top ) / _itemHeight);
    return row * _fcmatrix.columns + column;
}
@end
