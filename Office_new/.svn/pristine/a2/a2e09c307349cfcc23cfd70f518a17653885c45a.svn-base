//
//  NTESEmoticonManager.h
//  CS
//
//  Created by amao on 7/2/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "CSInputEmoticonManager.h"
#import "CSInputEmoticonDefine.h"
#import "NSString+CS.h"
#import "CSKit.h"

@implementation CSInputEmoticon
@end

@implementation CSInputEmoticonCatalog
@end

@implementation CSInputEmoticonLayout

- (id)initEmojiLayout:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        _rows            = CSKit_EmojRows;
        _columes         = ((width - CSKit_EmojiLeftMargin - CSKit_EmojiRightMargin) / CSKit_EmojImageWidth);
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (width - CSKit_EmojiLeftMargin - CSKit_EmojiRightMargin) / _columes;
        _cellHeight      = CSKit_EmojCellHeight;
        _imageWidth      = CSKit_EmojImageWidth;
        _imageHeight     = CSKit_EmojImageHeight;
        _emoji           = YES;
    }
    return self;
}

- (id)initCharletLayout:(CGFloat)width{
    self = [super init];
    if (self)
    {
        _rows            = CSKit_PicRows;
        _columes         = ((width - CSKit_EmojiLeftMargin - CSKit_EmojiRightMargin) / CSKit_PicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - CSKit_EmojiLeftMargin - CSKit_EmojiRightMargin) / _columes;
        _cellHeight      = CSKit_PicCellHeight;
        _imageWidth      = CSKit_PicImageWidth;
        _imageHeight     = CSKit_PicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end

@interface CSInputEmoticonManager ()
@property (nonatomic,strong)    NSArray *catalogs;
@end

@implementation CSInputEmoticonManager
+ (instancetype)sharedManager
{
    static CSInputEmoticonManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSInputEmoticonManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self parsePlist];
    }
    return self;
}

- (CSInputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID
{
    for (CSInputEmoticonCatalog *catalog in _catalogs)
    {
        if ([catalog.catalogID isEqualToString:catalogID])
        {
            return catalog;
        }
    }
    return nil;
}


- (CSInputEmoticon *)emoticonByTag:(NSString *)tag
{
    CSInputEmoticon *emoticon = nil;
    if ([tag length])
    {
        for (CSInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.tag2Emoticons objectForKey:tag];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}


- (CSInputEmoticon *)emoticonByID:(NSString *)emoticonID
{
    CSInputEmoticon *emoticon = nil;
    if ([emoticonID length])
    {
        for (CSInputEmoticonCatalog *catalog in _catalogs)
        {
            emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
            if (emoticon)
            {
                break;
            }
        }
    }
    return emoticon;
}

- (CSInputEmoticon *)emoticonByCatalogID:(NSString *)catalogID
                           emoticonID:(NSString *)emoticonID
{
    CSInputEmoticon *emoticon = nil;
    if ([emoticonID length] && [catalogID length])
    {
        for (CSInputEmoticonCatalog *catalog in _catalogs)
        {
            if ([catalog.catalogID isEqualToString:catalogID])
            {
                emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
                break;
            }
        }
    }
    return emoticon;
}



- (NSArray *)loadChartletEmoticonCatalog{
    NSString *directory = [CSKit_EmoticonPath stringByAppendingPathComponent:CSKit_ChartletChartletCatalogPath];
    NSURL *url = [[NSBundle mainBundle] URLForResource:[[CSKit sharedKit] bundleName]
                                         withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];    
    NSArray  *paths   = [bundle pathsForResourcesOfType:nil inDirectory:directory];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSString *path in paths) {
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            CSInputEmoticonCatalog *catalog = [[CSInputEmoticonCatalog alloc]init];
            catalog.catalogID = path.lastPathComponent;
            NSArray *resources = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:CSKit_ChartletChartletCatalogContentPath]];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *path in resources) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension;
                CSInputEmoticon *icon  = [[CSInputEmoticon alloc] init];
                icon.emoticonID = name.cs_stringByDeletingPictureResolution;
                icon.filename   = path;
                [array addObject:icon];
            }
            catalog.emoticons = array;
            
            NSArray *icons     = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:CSKit_ChartletChartletCatalogIconPath]];
            for (NSString *path in icons) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension.cs_stringByDeletingPictureResolution;
                if ([name hasSuffix:CSKit_ChartletChartletCatalogIconsSuffixNormal]) {
                    catalog.icon = path;
                }else if([name hasSuffix:CSKit_ChartletChartletCatalogIconsSuffixHighLight]){
                    catalog.iconPressed = path;
                }
            }
            [res addObject:catalog];
        }
    }
    return res;
}

- (void)parsePlist
{
    NSMutableArray *catalogs = [NSMutableArray array];
    NSString *directory = [CSKit_EmoticonPath stringByAppendingPathComponent:CSKit_EmojiPath];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:[[CSKit sharedKit] bundleName]
                                         withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    NSString *filepath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:directory];
    if (filepath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        for (NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSArray *emoticons = dict[@"data"];
            
            CSInputEmoticonCatalog *catalog = [self catalogByInfo:info
                                                     emoticons:emoticons];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

- (CSInputEmoticonCatalog *)catalogByInfo:(NSDictionary *)info
                             emoticons:(NSArray *)emoticonsArray
{
    CSInputEmoticonCatalog *catalog = [[CSInputEmoticonCatalog alloc]init];
    catalog.catalogID   = info[@"id"];
    catalog.title       = info[@"title"];
    NSString *iconNamePrefix = [[[[CSKit sharedKit] bundleName] stringByAppendingPathComponent:CSKit_EmoticonPath] stringByAppendingPathComponent:CSKit_EmojiPath];
    NSString *icon      = info[@"normal"];
    catalog.icon = [iconNamePrefix stringByAppendingPathComponent:icon];
    NSString *iconPressed = info[@"pressed"];
    catalog.iconPressed = [iconNamePrefix stringByAppendingPathComponent:iconPressed];

    
    NSMutableDictionary *tag2Emoticons = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2Emoticons = [NSMutableDictionary dictionary];
    NSMutableArray *emoticons = [NSMutableArray array];
    
    for (NSDictionary *emoticonDict in emoticonsArray) {
        CSInputEmoticon *emoticon  = [[CSInputEmoticon alloc] init];
        emoticon.emoticonID     = emoticonDict[@"id"];
        emoticon.tag            = emoticonDict[@"tag"];
        NSString *fileName      = emoticonDict[@"file"];
        NSString *imageNamePrefix = [[[[CSKit sharedKit] bundleName] stringByAppendingPathComponent:CSKit_EmoticonPath] stringByAppendingPathComponent:CSKit_EmojiPath];
        emoticon.filename = [imageNamePrefix stringByAppendingPathComponent:fileName];
        if (emoticon.emoticonID) {
            [emoticons addObject:emoticon];
            id2Emoticons[emoticon.emoticonID] = emoticon;
        }
        if (emoticon.tag) {
            tag2Emoticons[emoticon.tag] = emoticon;
        }
    }
    
    catalog.emoticons       = emoticons;
    catalog.id2Emoticons    = id2Emoticons;
    catalog.tag2Emoticons   = tag2Emoticons;
    return catalog;
}


@end
