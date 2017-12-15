//
//  XLPDF.h
//  Demo
//
//  Created by Lun.X on 2017/12/6.
//  Copyright © 2017年 Lun.X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XLPDF : NSObject

/**
 配置pdf文件

 @param webView 当前webView
 @param path pdf临时文件地址 （临时存放，根据需求删除）

 */
+ (void)configPDFWithWebView:(UIWebView *)webView path:(NSString *)path;

@end
