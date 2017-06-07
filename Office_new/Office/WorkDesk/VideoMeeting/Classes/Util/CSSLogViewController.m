//
//  CSSLogViewController.m
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CSSLogViewController.h"
#import "CSSLogManager.h"

@interface CSSLogViewController ()<NSLayoutManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *logTextView;
@property (copy,nonatomic) NSString *path;
@end

@implementation CSSLogViewController


- (instancetype)initWithFilepath:(NSString *)path
{
    if (self = [self initWithNibName:@"CSSLogViewController" bundle:nil])
    {
        self.path = path;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(onDismiss:)];
    NSData *data = [NSData dataWithContentsOfFile:_path];
    NSString *content = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    if (content == nil)
    {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSASCIIStringEncoding];
    }
    _logTextView.text = content;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_logTextView scrollRangeToVisible:NSMakeRange([_logTextView.text length], 0)];
}


- (void)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
