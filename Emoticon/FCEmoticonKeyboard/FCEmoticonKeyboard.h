//
//  FCEmoticonKeyboard.h
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCEmoticon.h"
@class FCEmoticon;

@protocol FCEmoticonKeyboardDelegate <NSObject>
- (void)fc_emoticonInfo:(FCEmoticon *)emoticon;
@end

@interface FCEmoticonKeyboard : UIView
@property (nonatomic,weak)id<FCEmoticonKeyboardDelegate>delegate;
+ (FCEmoticonKeyboard *)shareInstance;
@end
