//
//  FCEmoticonToolbar.m
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "FCEmoticonToolbar.h"

@interface FCEmoticonToolbarCell : UICollectionViewCell
@property (nonatomic, strong)UIView *rightLineView;
@property (nonatomic, strong)UIImageView *emoticonImageView;
@end


@interface FCEmoticonToolbar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger selectedIndex;
}
@property (nonatomic, strong)UICollectionView *fcToolBarCollectionView;
@end

@implementation FCEmoticonToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    selectedIndex = 0;
    [self fc_setupUI];
    return self;
}

#pragma mark - delegate && dataSource

#pragma mark fcCollection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _packages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCEmoticonToolbarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCEmoticonToolbarCell class]) forIndexPath:indexPath];
    if (selectedIndex != indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    }
    
    cell.rightLineView.hidden = indexPath.row ==0?:NO;
    
    FCEmoticonPackage *package = [_packages objectAtIndex:indexPath.row];
    FCEmoticon *emotion = [package.fcEmoticons firstObject];
    cell.emoticonImageView.image = [UIImage imageWithContentsOfFile:emotion.path];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.frame)/5.0, CGRectGetHeight(collectionView.frame));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex == indexPath.row){
        return;
    }
    //改变选择状态,代理回调
    selectedIndex = indexPath.row;
    [_fcToolBarCollectionView reloadData];

    if ([_delegate respondsToSelector:@selector(fc_toolbarSelectedIndex:)]){
        [_delegate fc_toolbarSelectedIndex:selectedIndex];
    }
    
}

#pragma mark - Actions
- (void)fc_toolbarScrollToIndex:(NSInteger)index{
    if (index == selectedIndex) {
        return;
    }
    selectedIndex = index;
    [_fcToolBarCollectionView reloadData];
    [_fcToolBarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - Setup UI
- (void)fc_setupUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 9;
    flowLayout.minimumLineSpacing = 0;
    
    _fcToolBarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    //tool
    _fcToolBarCollectionView.backgroundColor = [UIColor clearColor];
    _fcToolBarCollectionView.clipsToBounds = YES;
    _fcToolBarCollectionView.showsHorizontalScrollIndicator = NO;
    [_fcToolBarCollectionView registerClass:[FCEmoticonToolbarCell class] forCellWithReuseIdentifier:NSStringFromClass([FCEmoticonToolbarCell class])];
    _fcToolBarCollectionView.delegate = self;
    _fcToolBarCollectionView.dataSource = self;
    [self addSubview:_fcToolBarCollectionView];
    
    
    
    //添加约束
    [self addConstrainForSubViews];
}

- (void)addConstrainForSubViews{
    _fcToolBarCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fcToolBarCollectionView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_fcToolBarCollectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fcToolBarCollectionView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_fcToolBarCollectionView)]];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectZero];
    topLineView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:topLineView];
    topLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topLineView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(topLineView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLineView]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(topLineView)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
}

@end

#pragma mark - FCEmoticonToolbarCell
@implementation FCEmoticonToolbarCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _emoticonImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _emoticonImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _emoticonImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_emoticonImageView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_emoticonImageView]-0-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_emoticonImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_emoticonImageView]-5-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_emoticonImageView)]];
    
    _rightLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_rightLineView];
    _rightLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_rightLineView]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_rightLineView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_rightLineView]-5-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_rightLineView)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightLineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];

    return self;
}


@end
