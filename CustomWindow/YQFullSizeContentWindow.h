//
//  YQFullSizeContentWindow.h
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface YQFullSizeContentWindow : NSWindow

// Designated initializer.
- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSUInteger)windowStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)deferCreation
             wantsViewsOverTitlebar:(BOOL)wantsViewsOverTitlebar;

- (void)forceContentViewFrame:(NSRect)frame;

@end
