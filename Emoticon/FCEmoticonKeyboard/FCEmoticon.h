//
//  FCEmoticon.h
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

/*
    引入Emoticon用到的头文件
    常用变量
 */

#ifndef FCEmoticon_h
#define FCEmoticon_h


struct FCMatrix {
    NSUInteger rows;
    NSUInteger columns;
};
typedef struct FCMatrix FCMatrix;

static inline FCMatrix FCMatrixMake(NSUInteger rows, NSUInteger columns){
    FCMatrix p; p.rows = rows; p.columns = columns; return p;
}

#import "FCEmoticonManager.h"//mamager
#import "FCEmoticonKeyboard.h"//main
#import "FCEmoticonToolbar.h"//底部
#import "FCEmoticonView.h"//每页表情
@class FCEmoticon;

//#define FC_ROWS 2       //行数
//#define FC_COLUMNS 4    //列数
#define FC_HDDEL  YES      //隐藏删除键
#define FC_HIDNAME YES      //隐藏名字

#define FC_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]       //EMOTICON根路径

#define FC_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

#endif /* FCEmoticon_h */
