//
//  Translate.h
//  Translate
//
//  Created by little nie on 16/2/23.
//  Copyright © 2016年 NIEHAILI. All rights reserved.
//

#import <AppKit/AppKit.h>

@class Translate;
static Translate *sharedPlugin;

@interface Translate : NSObject
@property (nonatomic, strong, readonly) NSBundle* bundle;

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@end