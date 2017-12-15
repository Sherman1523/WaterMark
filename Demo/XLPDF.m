//
//  XLPDF.m
//  Demo
//
//  Created by Lun.X on 2017/12/6.
//  Copyright © 2017年 Lun.X. All rights reserved.
//

#import "XLPDF.h"

@implementation XLPDF

static BOOL isA4 = YES;

+ (void)configPDFWithWebView:(UIWebView *)webView path:(NSString *)path{
    UIViewPrintFormatter *format = [webView viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];
    
    CGSize size = [self getPDFPageRectSizeWebView:webView];
    
    CGRect pageRect =  CGRectMake(0, 0, size.width, size.height);
    CGRect printableRect = CGRectInset(pageRect, 0, 0);
    
    [render setValue:[NSValue valueWithCGRect:pageRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    UIGraphicsBeginPDFContextToFile(path, pageRect, NULL);
    
    for (NSInteger i = 0; i < [render numberOfPages]; i++) {
        
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
        
        BOOL isiPad = [[UIDevice currentDevice].model isEqualToString:@"iPad"]?YES:NO;
        CGFloat height = isA4?180.0f:(isiPad?260.f:120.0f);
        CGFloat width = size.width/2-20;
        int count = (int)floor((size.height-8)/height) *2;
        
        
        for (int i = 0; i<count; i++) {
            UIImage *image = [self getBrowseLevelWatermarkImageWithRect:size];
            
            [image drawInRect:CGRectMake(20 + (width +20) *(i%2), 20+height*(i/2), width, height) blendMode:kCGBlendModeMultiply alpha:1];
        }
    }
    UIGraphicsEndPDFContext();
}

+ (CGSize)getPDFPageRectSizeWebView:(UIWebView *)webView {
   //默认A4纸大小
    
    CGFloat width = 595.0;
    CGFloat height = 842.0;

    [self isA4:YES];
    
    CGSize size = CGSizeMake(width, height);
    NSArray *arr = [webView.scrollView subviews];
    for (UIView *view in arr) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
            NSArray *array  = view.subviews;
            for (int i = 0; i<array.count ; i++) {
                UIView *subView = array[i];
                if ([subView isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
                    size = CGSizeMake(subView.frame.size.width, subView.frame.size.height+2);
                    [self isA4:NO];
                }
            }
        }
    }
    return size;
}
+ (UIImage *)getBrowseLevelWatermarkImageWithRect:(CGSize)size   {
    BOOL isiPad = [[UIDevice currentDevice].model isEqualToString:@"iPad"]?YES:NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (size.width -30)/2, isA4?180.0f:(isiPad?260.0f:120.0f))];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, isiPad?([self isA4]?120:178):([self isA4]?88:58), (size.width)/2-15, 30)];
    
    label.text = @"Lun.X JS-3";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    label.font = isA4?(isiPad?[UIFont systemFontOfSize:18]:[self getBigFont]):(isiPad?[UIFont systemFontOfSize:24]:[self getMidFont]);
    label.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
    label.transform = CGAffineTransformMakeRotation(M_PI_4);
    [view addSubview:label];
    
    UIImage *image = [UIImage imageWithData:UIImagePNGRepresentation([self getImageFromView:view])];
    
    return image;
}

+ (UIImage *)getImageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, 0.0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)isA4:(BOOL)A4 {
    isA4 = A4;
}

+ (BOOL)isA4 {
    return isA4;
}

+ (UIFont *)getMidFont {
    UIFont *customFont = nil;
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    if (kScreenWidth < 375) {
        customFont = [UIFont systemFontOfSize:12];
    }
    
    if (kScreenWidth > 320 && kScreenWidth < 414) {
        customFont = [UIFont systemFontOfSize:14];
    }
    
    if (kScreenWidth > 400) {
        customFont = [UIFont systemFontOfSize:15];
    }
    
    return customFont;
}

+ (UIFont *)getBigFont {
    UIFont *customFont = nil;
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    if (kScreenWidth < 375) {
        customFont = [UIFont systemFontOfSize:25];
    }
    
    if (kScreenWidth > 320 && kScreenWidth < 414) {
        customFont = [UIFont systemFontOfSize:26];
    }
    
    if (kScreenWidth > 400) {
        customFont = [UIFont systemFontOfSize:27];
    }
    
    return customFont;
}
@end
