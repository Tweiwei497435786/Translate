//
//  Translate.m
//  Translate
//
//  Created by little nie on 16/2/23.
//  Copyright © 2016年 NIEHAILI. All rights reserved.
//

#import "Translate.h"
#include "TranslateController.h"
#import <WebKit/WebKit.h>

// 翻译网址
static NSString * const kAPI = @"http://translate.google.cn/?hl=en#en/zh-CN/";

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [self p_addMenuItem];
    
    [self p_addNotificatonListener];
}

#pragma mark ----private method

- (void)p_addNotificatonListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_textViewDidChangeSelectionNotification:)
                                                 name:NSTextViewDidChangeSelectionNotification                                                object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_webViewDidChangeSelectionNotification:)
                                                 name:WebViewDidChangeSelectionNotification                                                object:nil];
}
- (void)p_addMenuItem
{
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenuItem *pluginsMenuItem = [[NSApp mainMenu] itemWithTitle:@"Plugins"];
    if (!pluginsMenuItem)
    {
        pluginsMenuItem = [[NSMenuItem alloc] init];
        pluginsMenuItem.title = @"Plugins";
        pluginsMenuItem.submenu = [[NSMenu alloc] initWithTitle:pluginsMenuItem.title];
        NSInteger windowIndex = [mainMenu indexOfItemWithTitle:@"Window"];
        [mainMenu insertItem:pluginsMenuItem atIndex:windowIndex];
    }

    [[pluginsMenuItem submenu] addItem:[NSMenuItem separatorItem]];
    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"HLTranslate" action:@selector(p_translate) keyEquivalent:@"T"];
    [actionMenuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [actionMenuItem setTarget:self];
    [[pluginsMenuItem submenu] addItem:actionMenuItem];
}

- (void)p_textViewDidChangeSelectionNotification:(NSNotification *)notification
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

- (void)p_webViewDidChangeSelectionNotification:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[WebView class]]) {
        WebView *webView = (WebView *)notification.object;
        DOMRange *range = webView.selectedDOMRange;
        if (range.text) {
            self.selectedText = range.text;
        }
    }
}

- (void)p_translate
{
    NSString *selectedText = [self.selectedText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];;
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
