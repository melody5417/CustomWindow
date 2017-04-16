//
//  YQFramedWindow.h
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQFullSizeContentWindow.h"

@protocol YQFrameWindowDelegate <NSObject>
    
// Returns YES if it is ok to constrain the window's frame to fit the screen.
- (BOOL)shouldConstrainFrameRect;

@end

@interface YQFramedWindow : YQFullSizeContentWindow

@property (nonatomic, weak) id<YQFrameWindowDelegate> controller;

- (id)initWithContentRect:(NSRect)contentRect
              hasTitleBar:(BOOL)hasTitleBar;

// When the lock is set to YES, the frame and style mask of the Window cannot be
// changed. This is used to prevent AppKit from making these unwanted changes
// to the window during exit fullscreen transition. It is very important to
// release this lock after the transition is completed.
- (void)setStyleMaskLock:(BOOL)lock;

// This method is overridden to prevent AppKit from  setting the style mask
// when frameAndStyleMaskLock_ is set to true.
- (void)setStyleMask:(NSUInteger)styleMask;

// Returns the desired spacing between window control views.
- (CGFloat)windowButtonsInterButtonSpacing;

+ (BOOL)drawWindowThemeInDirtyRect:(NSRect)dirtyRect
                           forView:(NSView*)view
                            bounds:(NSRect)bounds
              forceBlackBackground:(BOOL)forceBlackBackground;

@end
