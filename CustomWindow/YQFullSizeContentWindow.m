//
//  YQFullSizeContentWindow.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQFullSizeContentWindow.h"
#import "YQFullSizeContentView.h"

@interface YQFullSizeContentWindow ()
@property (nonatomic, strong) NSView *windowView;
@end

@implementation YQFullSizeContentWindow

- (instancetype)init {
    return nil;
}

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSUInteger)windowStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)deferCreation
             wantsViewsOverTitlebar:(BOOL)wantsViewsOverTitlebar {
    self = [super initWithContentRect:contentRect
                            styleMask:windowStyle
                              backing:bufferingType
                                defer:deferCreation];
    if (self) {
        if (wantsViewsOverTitlebar
            && [[self class] shouldUseFullSizeContentViewForStyle:windowStyle]) {

            self.windowView = [[YQFullSizeContentView alloc] init];
            self.windowView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            self.contentView = self.windowView;
            [self.windowView setFrame:[[self.windowView superview] bounds]];


            // Our content view overlaps the window control buttons, so we must ensure
            // it is positioned below the buttons.
            NSView* superview = [self.windowView superview];
            [self.windowView removeFromSuperview];
            [superview addSubview:self.windowView
                       positioned:NSWindowBelow
                       relativeTo:nil];
            }

    }
    return self;
}

- (void)forceContentViewFrame:(NSRect)frame {
    if ([self.windowView isKindOfClass:[YQFullSizeContentView class]]) {
        YQFullSizeContentView* contentView = (YQFullSizeContentView*)self.windowView;
        [contentView forceFrame:frame];
    } else if (self.windowView) {
        [self.windowView setFrame:frame];
    } else {
        [self.contentView setFrame:frame];
    }
}

#pragma mark - Private Methods

+ (BOOL)shouldUseFullSizeContentViewForStyle:(NSUInteger)windowStyle {
    return windowStyle & NSWindowStyleMaskTitled;
}

@end
