//
//  YQFullSizeContentView.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQFullSizeContentView.h"

@interface YQFullSizeContentView ()
@property (nonatomic, assign) BOOL forceFrameFlag;
@end

@implementation YQFullSizeContentView

- (void)setFrameSize:(NSSize)newSize {
    if ([self superview] && !_forceFrameFlag) {
        newSize = [[self superview] bounds].size;
    }
    [super setFrameSize:newSize];
}

- (void)forceFrame:(NSRect)frame {
    _forceFrameFlag = YES;
    [super setFrame:frame];
    _forceFrameFlag = NO;
}

@end
