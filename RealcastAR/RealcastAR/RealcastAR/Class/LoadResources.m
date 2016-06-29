//
//  LoadResources.m
//  tianyanAR
//
//  Created by Steven2761 on 16/5/11.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import "LoadResources.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "Header.h"
#import "ZipArchive.h"
#import "DDXML.h"
@implementation LoadResources
{
    NSString *_channel;
    NSString *_XMLURL;
    NSString *_JSONURL;
    float     _progress;
    NSMutableDictionary *_modelURL;
}
//XML节点
static NSString *kXML =@"//TrackingData//dataset";
static NSString *kXML2 =@"//TrackingData//media";
static NSString *TRACKID = @"//TrackingData//trackableID";

- (void)DownloadResources:(NSString *)channel
{
    _progress = 0;
    _modelURL = [[NSMutableDictionary alloc] init];
    [_delegate theProgressBar:_progress describe:@"开始加载"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _channel = channel;
        NSString *stampSin = [self TheTimeStamp];
//        NSString *PJkey = [[UserManager shareUserManager].URLChoose[@"authorizationKey"] stringByAppendingString:stampSin];//拼接授权KEY
        NSString *PJkey = [@"ezRq7-1Wov6N9lVMpTRQtP-n_6UVBTdcgOQRT8_JlJhaKaZgKsPg39rfZ0PsO3VL" stringByAppendingString:stampSin];
        PJkey = [self md5:PJkey];
        
        NSError *error = nil;
//        NSString *urlsin = nil;
//        if ([UserManager shareUserManager].refurbish) {
//            NSString *accessToken = [NSString stringWithFormat:@"%@",[UserManager shareUserManager].totaldata[@"accessToken"]];
//            urlsin = [NSString stringWithFormat:@"%@ck=%@&sdk=realSDK&ak=%@&at=%@&ut=%@",[UserManager shareUserManager].URLChoose[@"XIAZAIzip_URL"],channel,PJkey,stampSin,accessToken];
//        }else{
//            urlsin = [NSString stringWithFormat:@"%@ck=%@&sdk=realSDK&ak=%@&at=%@",[UserManager shareUserManager].URLChoose[@"XIAZAIzip_URL"],channel,PJkey,stampSin];
//        }
        
        
        NSString *urlsin = [NSString stringWithFormat:@"http://res.e3.test/channel/info/resource?ck=%@&sdk=realSDK&ak=%@&at=%@",channel,PJkey,stampSin];
        NSURL *url = [NSURL URLWithString:urlsin];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:8];
        //查看沙盒是否有时间记录
        NSDictionary *dict = [self writesandboxtime:channel];
        NSString *channeltime = nil;
        if (dict) {
            channeltime = [dict objectForKey:@"Last-Modified"];
            [request setValue:channeltime forHTTPHeaderField:@"If-Modified-Since"];
        }
//        NSString *cookie = [appDelegateData objectForKey:@"Cookie"];
//        if (cookie) {
//            [request setValue:cookie forHTTPHeaderField:@"Cookie"];
//        }
        NSHTTPURLResponse *urlreponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlreponse error:&error];
        if (!error) {
            NSError *jsonerror;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonerror];
            if ([json [@"error"] integerValue] == 0) {
                if ([json[@"data"][@"status"] integerValue] == 200) {//正常返回数据
                    NSDictionary *dictionary = [urlreponse allHeaderFields];
                    NSDictionary *dictTime = [[NSDictionary alloc] initWithObjectsAndKeys:dictionary[@"Last-Modified"],@"Last-Modified", nil];
                    [self writesandboxtime:dictTime name:channel];
                    NSString *strurl = [NSString stringWithFormat:@"%@",json[@"data"][@"url"]];
                    _progress = 0.1;
                    [_delegate theProgressBar:_progress describe:@"获取到频道资源包地址"];
                    [self DownloadPackage:strurl];
                    
                }else if ([json[@"data"][@"status"] integerValue] == 304) {
                    //使用缓存 直接加载
                    }
            }else if ([json[@"error"] integerValue] == 1) {
                if ([[[json objectForKey:@"data"] objectForKey:@"message"] isEqual:@"channel_not_exists"]){
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5000)",CustomLocalizedString(@"Channelnotexist", nil)]];
                    [_delegate downloadResourcesFailure:@"该频道不存在"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"message"] isEqual:@"channel_barred"]){//频道被禁止
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5001)",CustomLocalizedString(@"Thechannelhavebee", nil)]];
                    [_delegate downloadResourcesFailure:@"频道禁止"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"message"] isEqual:@"access_restrictions"]){
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5002)",CustomLocalizedString(@"Accessrestrictions", nil)]];
                    [_delegate downloadResourcesFailure:@"访问限制"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"message"] isEqual:@"empty_channel"]){
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5003)",CustomLocalizedString(@"Channelisempty", nil)]];
                    [_delegate downloadResourcesFailure:@"该频道为空"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"message"] isEqual:@"no_expansion"]){
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5008)",CustomLocalizedString(@"Downloaderrorresources", nil)]];
                    [_delegate downloadResourcesFailure:@"频道未绑定扩展"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"status"] integerValue] == 401) { //授权异常
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5005)",CustomLocalizedString(@"Authorizationexception", nil)]];
                    [_delegate downloadResourcesFailure:@"授权异常"];
                }
                else if ([[[json objectForKey:@"data"] objectForKey:@"status"] integerValue] == 500) { //服务器内部错误
//                    [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5006)",CustomLocalizedString(@"Downloaderrorresources", nil)]];
                    [_delegate downloadResourcesFailure:@"服务器内部错误"];
                }
                else {
                    [_delegate downloadResourcesFailure:@"未知错误"];
                }
            }
        }else{
            //请求失败
            NSLog(@"%@",urlreponse);
//            [_delegate downloadResourcesFailure:[NSString stringWithFormat:@"%@(5007)",CustomLocalizedString(@"Networkrequestfailed", nil)]];
            [_delegate downloadResourcesFailure:@"网络请求失败"];
        }
    });
}

//时间戳
- (NSString *)TheTimeStamp
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%f", [datenow timeIntervalSince1970]];
    NSString *sting = [[NSString alloc] initWithFormat:@"%d", [timeSp intValue]];
    return sting;
}

//加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//下载数据
- (void)DownloadPackage:(NSString *)urlSing
{
    //网络请求(同步)
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:urlSing];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (data != nil) {
        //创建文件存储路径
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dz = [NSString stringWithFormat:@"channel/%@",_channel];
        NSString *filePath = [caches stringByAppendingPathComponent:dz];
        //创建文件夹到沙盒
        NSFileManager *mananger = [NSFileManager defaultManager];
        [mananger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        //创建zip包路径
        NSString *diry = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"channel/%@/%@.rcp",_channel,_channel]];
        //存储
        [data writeToFile:diry atomically:YES];
        _progress = 0.5;
        [_delegate theProgressBar:_progress describe:@"频道资源包下载完成"];
        //解压
        ZipArchive *zip = [[ZipArchive alloc] init];
        if ([zip UnzipOpenFile:diry]) {
            BOOL ret = [zip UnzipFileTo:filePath overWrite:YES];
            if (NO == ret) {
                [zip UnzipCloseFile];
            }
            //解析XML
            NSString *xmlstring = [filePath stringByAppendingPathComponent:@"channelConfig.xml"];
            NSData *data = [NSData dataWithContentsOfFile:xmlstring];
            //获取XML里面动态加载的地址.
            [self obtainLoadingURL:data];
            //配置XML文件
            BOOL XML = [self parsedDataFrom:data];//解析XML数据
            if (XML) {//检测是否需要下载
                _XMLURL = [filePath stringByAppendingPathComponent:@"xmlData.xml"];
                _JSONURL = [filePath stringByAppendingPathComponent:@"interaction.json"];
                [self detectionofDownload];
            }
            else{
                [_delegate downloadResourcesFailure:@"XML解析错误"];
            }
        }else{
            [_delegate downloadResourcesFailure:@"解压失败"];
            //加载错误，删除错误的安装包
            [self errordeleta:[NSString stringWithFormat:@"channel/%@",_channel]];
            [self errordeleta:[NSString stringWithFormat:@"channel/%@.plist",_channel]];
        }
    }
}
//获取XML里面动态加载的地址
- (void)obtainLoadingURL:(NSData *)data
{
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    if (document) {
        NSArray *itemss = [document nodesForXPath:kXML error:nil];
        for (int i = 0; i < itemss.count; i ++) {
            DDXMLElement *obj = itemss[i];
            NSString *namesing = [NSString stringWithFormat:@"%@",obj];
            NSData *itemssData = [namesing dataUsingEncoding:NSUTF8StringEncoding];
            DDXMLDocument *document2 = [[DDXMLDocument alloc] initWithData:itemssData options:0 error:nil];
            if (document2) {
//                NSArray *itemssData2 = [document2 nodesForXPath:@"//media" error:nil];
                NSArray *sArray22 = [document2 nodesForXPath:@"//mediaID" error:nil];
//                DDXMLElement *obj2 = itemssData2[0];
                NSMutableArray  *muarray=[[NSMutableArray alloc]init];
                for ( int i = 0; i < sArray22.count; i ++) {
//                    DDXMLNode *aUser = [obj2 attributeForName:@"name"];
                    NSString *string2 = [sArray22[i] stringValue];
                    [muarray addObject:string2];
                }
                NSArray *sArray = [document2 nodesForXPath:@"//trackableID" error:nil];
                NSString *string = [sArray[0] stringValue];
                [_modelURL setObject:muarray forKey:string];
            }
        }
    }
}
//解析XML文件数据
- (BOOL)parsedDataFrom:(NSData *)data
{
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    if (document) {
        NSArray *itemss = [document nodesForXPath:kXML error:nil];
        float number = 15/itemss.count;
        for (int i = 0; i < itemss.count; i ++) {
            DDXMLElement *obj = itemss[i];
            NSString *namesing = [NSString stringWithFormat:@"%@",obj];
            NSArray *array = [namesing componentsSeparatedByString:@"name="];
            array = [array[1] componentsSeparatedByString:@"/"];
            namesing = [NSString stringWithFormat:@"%@",array[0]];
            //判断是否需要网络请求更换地址
            if ([namesing rangeOfString:@"http"].location != NSNotFound) {
                DDXMLNode *aUser = [obj attributeForName:@"name"];
                NSString *url = [self data:[aUser stringValue]];
                _progress += number/100;
                [_delegate theProgressBar:_progress describe:@"加载xml文件中"];
                if (url) {
                    [aUser setStringValue:[NSString stringWithFormat:@"%@",url]];
                    //存储修改过后的xml到沙盒
                    NSString *Path = [NSString stringWithFormat:@"%@/channel/%@/xmlData.xml",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0],_channel];
                    NSString *result=[[NSString alloc]initWithFormat:@"%@",document];
                    [result writeToFile:Path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"XML配置错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    alert.tag = 11111115;
//                    [alert show];
//                    [_delegate downloadResourcesFailure:@"XML配置错误"];
                    return NO;
                }
            }
        }
        NSArray *items2 = [document nodesForXPath:kXML2 error:nil];
        float number2 = 15/items2.count;
        for (int i = 0; i < items2.count; i ++) {
            DDXMLElement *obj = items2[i];
            NSString *namesing = [NSString stringWithFormat:@"%@",obj];
            NSArray *array = [namesing componentsSeparatedByString:@"name="];
            array = [array[1] componentsSeparatedByString:@"/"];
            namesing = [NSString stringWithFormat:@"%@",array[0]];
            //判断是否需要网络请求更换地址
            if ([namesing rangeOfString:@"http"].location != NSNotFound) {
                DDXMLNode *aUser = [obj attributeForName:@"name"];
                NSString *url = [self data:[aUser stringValue]];
                _progress += number2/100;
                [_delegate theProgressBar:_progress describe:@"加载xml文件中"];
                if (url) {
                    [aUser setStringValue:[NSString stringWithFormat:@"%@",url]];
                    NSString *path =[[NSString alloc]initWithFormat:@"%@/channel/%@/xmlData.xml", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0],_channel];
                    NSString *result=[[NSString alloc]initWithFormat:@"%@",document];
                    [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"XML配置错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    alert.tag = 11111115;
//                    [alert show];
//                    [_delegate downloadResourcesFailure:@"XML配置错误"];
                    return NO;
                }
            }
        }
    }else{
        return NO;
    }
    return YES;
}
//下载xml里面的文件
- (NSString *)data:(NSString *)urlsing
{
    //网络请求(同步)
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:urlsing];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data != nil) {
        //存储下载的东西到沙盒
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *minzi = [NSString stringWithFormat:@"channel"];
        filePath=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"channel/%@",_channel]];
        //创建文件夹到沙盒
        NSFileManager *mananger = [NSFileManager defaultManager];
        NSError *error = nil;
        [mananger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSArray *arr = [urlsing componentsSeparatedByString:@"/"];
        
        NSString *ding = [NSString stringWithFormat:@"%@",arr[arr.count - 1]];
        NSString *sing = [filePath stringByAppendingPathComponent:ding];
        [data writeToFile:sing atomically:YES];
        
        if ([sing rangeOfString:@"zip"].location != NSNotFound) {
            ZipArchive *za = [[ZipArchive alloc] init];
            if ([za UnzipOpenFile:sing]) {
                BOOL ret = [za UnzipFileTo:filePath overWrite:YES];
                if (NO == ret) {
                    [za UnzipCloseFile];
                }
            }
            NSString *dz = [sing stringByReplacingOccurrencesOfString:@"zip" withString:@"rmx"];
            NSArray *ar = [dz componentsSeparatedByString:@"/"];
            NSString *sin = [NSString stringWithFormat:@"%@",ar[ar.count - 1]];
            return sin;
        }else if ([sing rangeOfString:@"rmx"].location != NSNotFound){
            NSArray *ar = [sing componentsSeparatedByString:@"/"];
            NSString *sin = [NSString stringWithFormat:@"%@",ar[ar.count - 1]];
            return sin;
        }
        else{
            NSString *si = [sing stringByReplacingOccurrencesOfString:@".rdx" withString:@""];
            NSArray *ar = [si componentsSeparatedByString:@"/"];
            NSString *sin = [NSString stringWithFormat:@"%@",ar[ar.count - 1]];
            return sin;
        }
    }
    return nil;
}


//检测是否需要下载
- (void)detectionofDownload
{
    //读取文件
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *ding = [NSString stringWithFormat:@"channel/%@/downloadList.json",_channel];
    NSString *sing = [documentsPath stringByAppendingPathComponent:ding];
    NSFileManager *manager = [NSFileManager defaultManager];
    //判断json文件是否存在
    if ([manager fileExistsAtPath:sing]) {
        //读出沙盒中的json文件
        NSError *error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:sing options:kNilOptions error:&error];
        //解析json文件
        NSError *error2 = nil;
        NSArray *dity = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        if (dity) {
            //用循环去下载json里面的文件
            for (int i = 0; i < dity.count; i ++) {
                BOOL complete = NO;
                if (i == dity.count - 1) {
                    complete = YES;
                }
                [self thedownloadfilee:complete url:[NSString stringWithFormat:@"%@",dity[i]] totalNumber:dity.count];
            }
        }else{
            [_delegate theProgressBar:0.95 describe:@"没有downloadList文件"];
            [_delegate downloadResourcesSuccessful:_XMLURL JSON:_JSONURL model:_modelURL];
        }
    }else{
        [_delegate theProgressBar:0.95 describe:@"没有downloadList文件"];
        [_delegate downloadResourcesSuccessful:_XMLURL JSON:_JSONURL model:_modelURL];
    }
}
//下载文件
- (void)thedownloadfilee:(BOOL)sender url:(NSString *)urlSing totalNumber:(NSInteger)Number
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:urlSing];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (data != nil) {
            NSArray *arr = [urlSing componentsSeparatedByString:@"/"];
            NSString *caches=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"channel/%@",_channel]];
            
            NSString *ding = [NSString stringWithFormat:@"%@",arr[arr.count - 1]];
            NSString *sing = [filePath stringByAppendingPathComponent:ding];
            [data writeToFile:sing atomically:YES];
            _progress += 15/Number/100;
            [_delegate theProgressBar:_progress describe:@"下载downloadList文件中"];
            
        }
        else{
            //            NSLog(@"错误信息 == %@",error);
            NSLog(@"%@ ... 下载错误。",urlSing);
            //            [ThepublicclassView myAlertShowForView:self.view caption:[NSString stringWithFormat:@"%@(这个下载失败)",_resourcesArray[sender]] direction:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sender) {
                [_delegate downloadResourcesSuccessful:_XMLURL JSON:_JSONURL model:_modelURL];
            }
        });
    });
}

//加载出错时的删除
- (void)errordeleta:(NSString *)name
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

//存储zip包的时间 //获取
- (NSDictionary *)writesandboxtime:(NSString *)name
{
    //读取文件
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *name2 = [NSString stringWithFormat:@"channel/%@.plist",name];
    NSString *readPath = [documentsPath stringByAppendingPathComponent:name2];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:readPath];
    return data;
}

//存储zip包的时间  创建
- (void)writesandboxtime:(NSDictionary *)time name:(NSString *)name
{
    //获取沙盒路径
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *name2 = [NSString stringWithFormat:@"channel/%@.plist",name];
    //写入文件并赋值
    NSString *filePaht = [documentsPath stringByAppendingPathComponent:name2];
    [time writeToFile:filePaht atomically:YES];
}
////下载成功
//- (void)downloadResourcesSuccessful:(NSString *)XMLaddress
//{
//    
//}
////下载失败
//- (void)downloadResourcesFailure:(NSString *)errorParameters
//{
//    
//}
@end
