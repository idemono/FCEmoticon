//
//  FCEmoticonKeyboard.m
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "FCEmoticonKeyboard.h"



@interface FCEmoticonCell : UICollectionViewCell
@property (nonatomic,strong)FCEmoticonView *fcEmoticonView;
@end

@interface FCEmoticonKeyboard ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FCEmoticonViewDelegate,FCEmoticonToolbarProtocol>
@property (nonatomic, strong)UICollectionView *fcCollectionView;
@property (nonatomic, strong)UIPageControl *fcPageControl;
@property (nonatomic, strong)FCEmoticonToolbar *fcToolBar;

@property (nonatomic,strong)FCEmoticonDataSource *fcDataSource;

@property (nonatomic,assign)NSUInteger rows;//default 2
@property (nonatomic,assign)NSUInteger columns;//default 4
@property (nonatomic,assign)BOOL hiddenDelete;//default YES
@property (nonatomic,assign)BOOL hiddenName;//default YES

@property (nonatomic,assign)FCMatrix matrix;

@end

@implementation FCEmoticonKeyboard

static FCEmoticonKeyboard *keyboard = nil;

+ (FCEmoticonKeyboard *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboard = [[FCEmoticonKeyboard alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds) - 200, FC_WIDTH, 200)];
    });
    return keyboard;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self){
        return nil;
        
    }
    _matrix = FCMatrixMake(2,4);
    //初始化UI
    [self fc_setupUI];
    //加载数据
    _fcDataSource = [FCEmoticonManager fc_getEmoticonDataSource];
    _fcToolBar.packages = _fcDataSource.fcEmoticonPackages;
    [_fcDataSource fc_loadEmoticonGroup:_matrix];
    [_fcCollectionView reloadData];
    [self checkPageControlWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return self;
}

#pragma mark - delegate && dataSource

#pragma mark fcCollection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _fcDataSource.fcEmoticonPackages.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    FCEmoticonPackage *emoticonPackage = [_fcDataSource.fcEmoticonPackages objectAtIndex:section];
    
    return emoticonPackage.fcEmoticonGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCEmoticonCell class]) forIndexPath:indexPath];
//    cell.fcEmoticonView.backgroundColor =[UIColor whiteColor];// [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1.0];
    cell.fcEmoticonView.fcmatrix = _matrix;
    FCEmoticonPackage *emoticonPackage = [_fcDataSource.fcEmoticonPackages objectAtIndex:indexPath.section];
    cell.fcEmoticonView.emoticons = emoticonPackage.fcEmoticonGroups[indexPath.row];
    cell.fcEmoticonView.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSIndexPath *indexpath = [_fcCollectionView indexPathForItemAtPoint:CGPointMake(offsetX + CGRectGetWidth(_fcCollectionView.frame) / 2.0, 0)];
    [_fcToolBar fc_toolbarScrollToIndex:indexpath.section];
    [self checkPageControlWithIndexPath:indexpath];
}

- (void)checkPageControlWithIndexPath:(NSIndexPath *)indexpath{
    FCEmoticonPackage *emoticonPackage = [_fcDataSource.fcEmoticonPackages objectAtIndex:indexpath.section];
    _fcPageControl.numberOfPages = emoticonPackage.fcEmoticonGroups.count;
    _fcPageControl.currentPage = indexpath.row;
}

#pragma mark FCEmoticonViewDelegate
- (void)fc_clickEmoticonInfo:(FCEmoticon *)emoticon{
    if ([_delegate respondsToSelector:@selector(fc_emoticonInfo:)]){
        [_delegate fc_emoticonInfo:emoticon];
    }
}

#pragma mark FCEmoticonToolbarProtocol
- (void)fc_toolbarSelectedIndex:(NSInteger)index{
    [_fcCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - Actions
- (void)fcPageControlAction:(UIPageControl *)pageControl{
    NSInteger pagea = pageControl.currentPage;
    CGFloat offsetX = _fcCollectionView.contentOffset.x;
    NSIndexPath *indexpath = [_fcCollectionView indexPathForItemAtPoint:CGPointMake(offsetX + CGRectGetWidth(_fcCollectionView.frame) / 2.0, 0)];

    [_fcCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pagea inSection:indexpath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

#pragma mark - Setup UI
- (void)fc_setupUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 9;
    flowLayout.minimumLineSpacing = 0;
    
    _fcCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _fcPageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _fcToolBar = [[FCEmoticonToolbar alloc] initWithFrame:CGRectZero];
    
    //表情键盘
    _fcCollectionView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    _fcCollectionView.clipsToBounds = YES;
    _fcCollectionView.pagingEnabled = YES;
    _fcCollectionView.showsHorizontalScrollIndicator = NO;
    [_fcCollectionView registerClass:[FCEmoticonCell class] forCellWithReuseIdentifier:NSStringFromClass([FCEmoticonCell class])];
    _fcCollectionView.delegate = self;
    _fcCollectionView.dataSource = self;
    [self addSubview:_fcCollectionView];
    
    //表情分组条
    _fcToolBar.delegate = self;
    [self addSubview:_fcToolBar];
    
    //页面控制器
    _fcPageControl.hidden = YES;
    _fcPageControl.numberOfPages = 5;
    _fcPageControl.currentPage = 2;
    _fcPageControl.hidesForSinglePage = YES;
    _fcPageControl.pageIndicatorTintColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    _fcPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0 green:129/255.0 blue:36/255.0 alpha:1.0];
    [self addSubview:_fcPageControl];
    [_fcPageControl addTarget:self action:@selector(fcPageControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加约束
    [self addConstrainForSubViews];
}

- (void)addConstrainForSubViews{
    _fcCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _fcPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _fcToolBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fcCollectionView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_fcCollectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fcToolBar]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_fcToolBar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fcPageControl]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_fcPageControl)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fcCollectionView]-0-[_fcToolBar(40)]-0-|" options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_fcCollectionView,_fcToolBar)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_fcPageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_fcToolBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_fcPageControl addConstraint:[NSLayoutConstraint constraintWithItem:_fcPageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
}

@end

#pragma mark - FCEmoticonCell

@implementation FCEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _fcEmoticonView = [[FCEmoticonView alloc] initWithFrame:CGRectZero];
    _fcEmoticonView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_fcEmoticonView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fcEmoticonView]-0-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_fcEmoticonView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fcEmoticonView]-0-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_fcEmoticonView)]];
    
    return self;
}

@end







