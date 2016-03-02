//
//  NSObject_Extension.m
//  Translate
//
//  Created by little nie on 16/2/23.
//  Copyright © 2016年 NIEHAILI. All rights reserved.
//


#import "NSObject_Extension.h"
#import "Translate.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[Translate alloc] initWithBundle:plugin];
        });
    }
}
@end
