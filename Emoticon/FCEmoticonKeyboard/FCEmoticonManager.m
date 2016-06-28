//
//  FCEmoticonManager.m
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "FCEmoticonManager.h"

@implementation FCEmoticonManager
+ (FCEmoticonDataSource *)fc_getEmoticonDataSource{
    FCEmoticonDataSource *dataSource = [[FCEmoticonDataSource alloc] init];
    NSString *packageRootPath = [FC_PATH stringByAppendingPathComponent:@"Emoticon"];

    NSString *packageConfig = [packageRootPath stringByAppendingPathComponent:@"emoticons.plist"];
    NSDictionary *packagesInfo = [NSDictionary dictionaryWithContentsOfFile:packageConfig];
    dataSource.version = packagesInfo[@"version"];
    NSMutableArray *mutPackages = [NSMutableArray array];
    NSArray *packages = packagesInfo[@"packages"];
    for (NSDictionary *tmpDic in packages) {
        FCEmoticonPackage *emoticonPackage = [[FCEmoticonPackage alloc] init];
        emoticonPackage.version = tmpDic[@"version"];
        emoticonPackage.packageName = tmpDic[@"id"];
        NSString *emoticonRootPath = [packageRootPath stringByAppendingPathComponent:emoticonPackage.packageName];
        NSString *emoticonConfig = [emoticonRootPath stringByAppendingPathComponent:@"ainfo.plist"];
        NSDictionary *emoticonInfo = [NSDictionary dictionaryWithContentsOfFile:emoticonConfig];
        
        NSMutableArray *mutEmoticons = [NSMutableArray array];
        NSArray *emoticons = emoticonInfo[@"emoticons"];
        for (NSDictionary *emoticonInfoDict in emoticons) {
            FCEmoticon *emoticon = [[FCEmoticon alloc] init];
            emoticon.name = emoticonInfoDict[@"chs"];
            emoticon.path = [emoticonRootPath stringByAppendingPathComponent:emoticonInfoDict[@"png"]];
            
            [mutEmoticons addObject:emoticon];
        }
        emoticonPackage.fcEmoticons = mutEmoticons;
        
        //
        [mutPackages addObject:emoticonPackage];
    }
    dataSource.fcEmoticonPackages = mutPackages;
    
    NSMutableDictionary *packageConverConfigDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSDictionary *packagesConfig = packagesInfo[@"packagesConfig"];
    NSArray *packagesAllKeys = [packagesConfig allKeys];
    for (NSString *tmpKey in packagesAllKeys) {
        NSDictionary *tmpDict = packagesConfig[tmpKey];
        FCPackageConfig *packageConfigModel = [[FCPackageConfig alloc] init];
        packageConfigModel.name = tmpDict[@"group_name_cn"];
        packageConfigModel.version = tmpDict[@"version"];
        packageConfigModel.createTime = tmpDict[@"createTime"];
        packageConfigModel.updataTime = tmpDict[@"updataTime"];
        [packageConverConfigDict setObject:packageConfigModel forKey:tmpKey];
    }
    dataSource.fcEmoticonPackagesConfig = packageConverConfigDict;
    return dataSource;
}


@end

@implementation FCEmoticonDataSource
- (void)fc_loadEmoticonGroup:(FCMatrix)fcmatrix{
    for (FCEmoticonPackage *package in self.fcEmoticonPackages) {
        NSMutableArray *emoticongroup = [NSMutableArray array];
        NSMutableArray *pageEmoticons = [NSMutableArray array];
        for (int i = 0; i < package.fcEmoticons.count; i ++) {
            if (i != 0 &&i % (fcmatrix.rows * fcmatrix.columns) == 0) {
                [emoticongroup addObject:pageEmoticons];
                pageEmoticons = [NSMutableArray array];
            }
            [pageEmoticons addObject:package.fcEmoticons[i]];
            if (i == package.fcEmoticons.count - 1) {
                [emoticongroup addObject:pageEmoticons];
            }
        }
        package.fcEmoticonGroups = emoticongroup;
    }
}

@end

@implementation FCPackageConfig



@end

@implementation FCEmoticonPackage

@end

@implementation FCEmoticon

@end
@implementation FCEmoticonGroup

@end
