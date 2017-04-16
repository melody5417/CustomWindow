//
//  YQWindowController.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQWindowController.h"
#import "YQFramedWindow.h"
#import "YQTitlebarView.h"

@interface YQWindowController () <YQFrameWindowDelegate, NSWindowDelegate>
@property (nonatomic, strong) YQTitlebarView *titlebar;
@end

@implementation YQWindowController

- (instancetype)init {
    if (self = [super initWithWindowNibName:@"YQWindowController"]) {
        [self.window setDelegate:self];
        self.window.titleVisibility = NSWindowTitleHidden;
        self.window.titlebarAppearsTransparent = YES;
        self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;

        NSView *contentView = [self.window contentView];
        NSRect titlebarFrame = NSMakeRect(0, NSHeight([contentView bounds]) - 22, NSWidth([contentView bounds]), 22);
        self.titlebar = [[YQTitlebarView alloc] initWithFrame:titlebarFrame];
        [self.titlebar setAutoresizingMask:NSViewWidthSizable | NSViewMinYMargin];

        NSView *rootView = [contentView superview];
        [rootView addSubview:self.titlebar
                  positioned:NSWindowBelow
                  relativeTo:nil];
    }
    return self;
}

#pragma mark - YQFrameWindowDelegate

- (BOOL)shouldConstrainFrameRect {
    return NO;
}

@end
