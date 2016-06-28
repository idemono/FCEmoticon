//
//  FCEmoticonToolbar.h
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCEmoticon.h"

@protocol FCEmoticonToolbarProtocol <NSObject>

- (void)fc_toolbarSelectedIndex:(NSInteger)index;

@end

@interface FCEmoticonToolbar : UIView
@property (nonatomic,strong)NSArray *packages;
@property (nonatomic,weak)id<FCEmoticonToolbarProtocol>delegate;
- (void)fc_toolbarScrollToIndex:(NSInteger)index;
@end
