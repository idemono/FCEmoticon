//
//  ViewController.m
//  Emoticon
//
//  Created by viziner on 16/5/13.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "ViewController.h"
#import "FCEmoticon.h"
#import "ZipArchive.h"

@interface ViewController ()<FCEmoticonKeyboardDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *fcImageVew;

@end

@implementation ViewController
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString; 
    
    
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *hexstr = @"";
    
    for (int i=0;i< [text length];i++)
    {
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[text characterAtIndex:i]]];
    }
    NSLog(@"UTF16 [%@]",hexstr);
    
    hexstr = @"";
    
    int slen = strlen([text UTF8String]);
    
    for (int i = 0; i < slen; i++)
    {
        //fffffff0 去除前面六个F & 0xFF
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[text UTF8String][i] & 0xFF ]];
    }
    NSLog(@"UTF8 [%@]",hexstr);
    
    hexstr = @"";
    
    if ([text length] >= 2) {
        
        for (int i = 0; i < [text length] / 2 && ([text length] % 2 == 0) ; i++)
        {
            // three bytes
//            if (([text characterAtIndex:i*2] & 0xFF00) == 0 ) {
//                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[text characterAtIndex:i*2],[text characterAtIndex:i*2+1]];
//            }
//            else
//            {// four bytes
//                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([text characterAtIndex:i*2],[text characterAtIndex:i*2+1])];
//            }
            
        }
        NSLog(@"(unicode) [%@]",hexstr);
    }
    else
    {
        NSLog(@"(unicode) U+%1X",[text characterAtIndex:0]);
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [SSZipArchive unzipFileAtPath:[[NSBundle mainBundle] pathForResource:@"Emoticon" ofType:@"zip"] toDestination:FC_PATH];
    
    FCEmoticonKeyboard *keyboard = [FCEmoticonKeyboard shareInstance];
    keyboard.delegate = self;
    [self.view addSubview:keyboard];
    
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:@"0x1f60d"];
    uint32_t result = 0;
    [scanner scanHexInt:&result];
    char *ttt = "\result";
    
    NSString *stirng = [self replaceUnicode:@"0x1f60d"];
    NSLog(@"%@",stirng);

    
//    let char = Character(UnicodeScalar(result))
//    
//    // 将code转成emoji表情
//    emoji = "\(char)"

    
//    NSString *basePath = [FC_PATH stringByAppendingPathComponent:@"Emojis"];
//    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
//    
//    NSMutableArray *emojisBaseInfoAry = [NSMutableArray arrayWithCapacity:0];
//    
//    NSMutableDictionary *packagesConfigDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    
//    
//    [folders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *packagePath = [basePath stringByAppendingPathComponent:obj];
//        NSArray *emojis = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:packagePath error:nil];
//        
//        
//        NSMutableArray *emojiss = [NSMutableArray arrayWithCapacity:0];
//        [emojis enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![obj hasSuffix:@"plist"]){
//                NSMutableDictionary *emojiDict = [NSMutableDictionary dictionaryWithCapacity:0];
//                [emojiDict setObject:obj forKey:@"chs"];
//                [emojiDict setObject:obj forKey:@"png"];
//                [emojiss addObject:emojiDict];
//            }
//            
//        }];
//        NSMutableDictionary *packageInfo = [NSMutableDictionary dictionaryWithCapacity:0];
//        [packageInfo setObject:obj forKey:@"group_name_cn"];
//        [packageInfo setObject:@1 forKey:@"version"];
//        [packageInfo setObject:[NSDate date] forKey:@"createTime"];
//        
//        NSMutableDictionary *packageconfigDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [packageconfigDict setDictionary:packageInfo];
//        [packageconfigDict setObject:[NSDate date] forKey:@"updataTime"];
//        
//        [packagesConfigDict setObject:packageconfigDict forKey:obj];
//        
//        [packageInfo setObject:emojiss forKey:@"emoticons"];
//
//        [packageInfo writeToFile:[packagePath stringByAppendingPathComponent:@"ainfo.plist"] atomically:YES];
//        
//        if (![obj hasSuffix:@"plist"]){
//            NSMutableDictionary *packageBaseInfoDict = [NSMutableDictionary dictionaryWithCapacity:0];
//            [packageBaseInfoDict setObject:obj forKey:@"id"];
//            [packageBaseInfoDict setObject:@"0" forKey:@"version"];
//            [emojisBaseInfoAry addObject:packageBaseInfoDict];
//        }
//    }];
//    NSMutableDictionary *emoticons = [NSMutableDictionary dictionaryWithCapacity:0];
//    [emoticons setObject:@1 forKey:@"version"];
//    [emoticons setObject:emojisBaseInfoAry forKey:@"packages"];
//    [emoticons setObject:packagesConfigDict forKey:@"packagesConfig"];
//    
//    [emoticons writeToFile:[basePath stringByAppendingPathComponent:@"emoticons.plist"] atomically:YES];
}

- (void)fc_emoticonInfo:(FCEmoticon *)emoticon{
    _fcImageVew.image = [UIImage imageWithContentsOfFile:emoticon.path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
