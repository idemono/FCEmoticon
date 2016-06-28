//
//  FCEmoticonManager.h
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCEmoticon.h"
@class FCEmoticonDataSource;


@interface FCEmoticonManager : NSObject

+ (FCEmoticonDataSource *)fc_getEmoticonDataSource;

@end

#pragma mark - FCEmoticonDataSource

@interface FCEmoticonDataSource : NSObject
@property (nonatomic,strong)NSString *version;//版本
@property (nonatomic,strong)NSString *packegRootpath;//包根目录
@property (nonatomic,strong)NSDictionary *fcEmoticonPackagesConfig;//每个表情包的详细信息;用字典存储,可以快速找到表情包的详细信息(下载界面,判断是否已下载或者需要更新)
@property (nonatomic,strong)NSArray *fcEmoticonPackages;//种类 //主要用来排序,不需要每次都计算了,把最新下载的放到前面
- (void)fc_loadEmoticonGroup:(FCMatrix)fcmatrix;
@end

#pragma mark - packageConfig
@interface FCPackageConfig : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *version;
@property (nonatomic,strong)NSDate *createTime;
@property (nonatomic,strong)NSDate *updataTime;
@end

#pragma mark - FCEmoticonPackage
@interface FCEmoticonPackage : NSObject
@property (nonatomic,strong)NSString *version;//版本
@property (nonatomic,strong)NSString *packageName;//表情包Name
@property (nonatomic,strong)NSArray *fcEmoticons;//表情
@property (nonatomic,strong)NSArray *fcEmoticonGroups;//表情组
@end

#pragma mark - FCEmoticon
@interface FCEmoticon : NSObject
@property (nonatomic,strong)NSString *name;//表情名
@property (nonatomic,strong)NSString *path;//表情完整路径
@end

#pragma mark - FCEmoticonGroup
@interface FCEmoticonGroup : NSObject
@property (nonatomic,strong)NSArray *fcEmoticons;//表情s
@end



