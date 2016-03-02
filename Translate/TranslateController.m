
//
//  TranslateController.m
//  Translate
//
//  Created by little nie on 16/2/25.
//  Copyright © 2016年 NIEHAILI. All rights reserved.
//

#import "TranslateController.h"
#import <WebKit/WebKit.h>

@interface TranslateController ()<WebFrameLoadDelegate,WebPolicyDelegate>
@property (weak) IBOutlet WebView *webView;

@end

@implementation TranslateController

- (void)windowDidLoad {
    [super windowDidLoad];
    

    self.webView.frameLoadDelegate = self;
    self.webView.policyDelegate = self;
    [self.webView preferences].plugInsEnabled = YES;
  
}

- (void)setUrl:(NSString *)url
{
    _url = url;

    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    NSLog(@"url = %@",url);
}

@end
