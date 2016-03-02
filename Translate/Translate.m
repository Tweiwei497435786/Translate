//
//  Translate.m
//  Translate
//
//  Created by little nie on 16/2/23.
//  Copyright © 2016年 NIEHAILI. All rights reserved.
//

#import "Translate.h"
#include "TranslateController.h"


#define kAPI    @"http://translate.google.cn/?hl=en#en/zh-CN/"

@interface Translate()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic,copy) NSString *selectedText;
@property (nonatomic, strong) TranslateController *translateController;
@end

@implementation Translate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [self p_addNotificatonListener];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [self p_addMenuItem];
}

#pragma mark ----private method

- (void)p_addNotificatonListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didApplicationFinishLaunchingNotification:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectContentChanged:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];
}


- (void)p_addMenuItem
{
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Translate" action:@selector(p_translate) keyEquivalent:@"T"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)selectContentChanged:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[NSTextView class]]) {
        NSTextView* textView = (NSTextView *)[notification object];
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count == 0) {
            return;
        }
        
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString* text = textView.textStorage.string;
        self.selectedText = [text substringWithRange:selectedRange];
    }
}

- (void)p_translate
{
    NSString *selectedText = [self.selectedText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPI,selectedText];
    [self.translateController showWindow:self.translateController];
    self.translateController.url = url;
}

#pragma mark ---getter and setter
- (TranslateController *)translateController
{
    if (!_translateController) {
        _translateController = [[TranslateController alloc] initWithWindowNibName:@"TranslateController"];
    }
    return _translateController;
}
@end
