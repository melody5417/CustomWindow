//
//  YQTitlebarView.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQTitlebarView.h"
#import "YQFramedWindow.h"

@implementation YQTitlebarView

- (void)drawRect:(NSRect)dirtyRect {
    float cornerRadius = 4.0;
    NSRect roundedRect = [self bounds];
    roundedRect.origin.y -= cornerRadius;
    roundedRect.size.height += cornerRadius;
    [[NSBezierPath bezierPathWithRoundedRect:roundedRect
                                     xRadius:cornerRadius
                                     yRadius:cornerRadius] addClip];
    [YQFramedWindow drawWindowThemeInDirtyRect:dirtyRect
                                       forView:self
                                        bounds:roundedRect
                          forceBlackBackground:NO];

    [[NSColor redColor] setFill];
    NSCompositingOperation operation = NSCompositingOperationSourceOver;
    NSRectFillUsingOperation(dirtyRect, operation);
}

@end
