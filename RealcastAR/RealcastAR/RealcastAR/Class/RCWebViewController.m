//
//  RCWebViewController.m
//  tianyanAR
//
//  Created by weily on 16/5/13.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import "RCWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface RCWebViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong) WKWebView *wkView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation RCWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSString *strUrl = [self.linkURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = nil;
    if (strUrl)
    {
        url = [NSURL URLWithString:strUrl];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    if (req)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [webView loadRequest:req];
        self.webView = webView;
        [self.view addSubview:webView];
    }
    
    /*
     if ([[UIDevice currentDevice].systemVersion integerValue] < 8.0)
     {
     UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
     webView.scalesPageToFit = YES;
     webView.delegate = self;
     self.webView = webView;
     [self.view addSubview:webView];
     
     if (req)
     {
     [webView loadRequest:req];
     }
     }
     else
     {
     WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
     //        webView.scalesPageToFit = YES;
     //        webView.delegate = self;
     self.wkView = webView;
     [self.view addSubview:webView];
     
     if (req)
     {
     [webView loadRequest:req];
     }
     }
     */
    
    self.navigationItem.leftBarButtonItem = [self backItem];
}

- (UIBarButtonItem *)backItem
{
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)goBack:(id)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self closeWeb:sender];
    }
}

- (void)closeWeb:(id)sender
{
    /**
     *	如果有navigationcontroller，那么返回
     */
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    ///	start
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    /**
     *  failed
     */
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    /**
     *  handle the javascript
     */
    /*
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    */
    
    /*
    context[@"checkUpdate"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //检查更新
        });
    };
    */
    
    /*
    context[@"callNative"] = ^{
        NSArray *args = [JSContext currentArguments];
        if (args.count > 0)
        {
            JSValue *param = [args objectAtIndex:0];
            NSString *jsonparam = [param toString];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    };
    */
    
    /*
    context[@"flaunt"] = ^
    {
        NSArray *args = [JSContext currentArguments];
        if (args.count == 4)
        {
            JSValue *flauntUrl = args[0];
            JSValue *flauntMsg = args[1];
            JSValue *flauntTitle = args[2];
            JSValue *flauntTitleUrl = args[3];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
    };
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
