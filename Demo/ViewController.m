//
//  ViewController.m
//  Demo
//
//  Created by Lun.X on 2017/11/30.
//  Copyright © 2017年 Lun.X. All rights reserved.
//

#import "ViewController.h"
#import "XLPDF.h"
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSString *tempFilepath;
@property (assign, nonatomic) BOOL isiPad;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createReadView];
    [self setWebViewInfo];
}


- (BOOL)isiPad
{
    BOOL yesOrNo = NO;
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([device.model isEqualToString:@"iPad"])
    {
        yesOrNo = YES;
    }
    
    return yesOrNo;
}
- (void)createReadView {
    if (self.webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
        self.webView.delegate = self;
        self.webView.scrollView.delegate = self;
        self.webView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
        [self.webView setScalesPageToFit:YES];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
        
        
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.4;
        
        [self. webView addGestureRecognizer:longPress];
        
        
        [self.view addSubview:self.webView];
    }
}


- (void)setWebViewInfo {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"jpg"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"pdf"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
    
    self.tempFilepath = [[self appDocumentPath] stringByAppendingString:@"temp.pdf"];
}

- (NSString *)appDocumentPath {
    NSString *documentRootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentRootPath = [documentRootPath stringByAppendingString:@"/"];
    return documentRootPath;
}

- (void)longTapAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        [self configActivityViewController];
        
    }else {
        
    }
}
- (void)configActivityViewController {
    [XLPDF configPDFWithWebView:self.webView path:self.tempFilepath];
    
    NSURL *url=[NSURL fileURLWithPath:self.tempFilepath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
