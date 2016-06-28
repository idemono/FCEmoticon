//
//  FCEmoticonView.h
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCEmoticon.h"

@protocol FCEmoticonViewDelegate <NSObject>

- (void)fc_clickEmoticonInfo:(FCEmoticon *)emoticon;

@end

@interface FCEmoticonView : UIView
@property (nonatomic, assign)FCMatrix fcmatrix;
@property (nonatomic, strong)NSArray*emoticons;
@property (nonatomic, weak)id<FCEmoticonViewDelegate>delegate;
@end
