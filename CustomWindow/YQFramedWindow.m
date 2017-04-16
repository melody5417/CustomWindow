//
//  YQFramedWindow.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "YQFramedWindow.h"

// Size of the gradient. Empirically determined so that the gradient looks
// like what the heuristic does when there are just a few tabs.
static const CGFloat kWindowGradientHeight = 24.0;

// Offsets from the top/left of the window frame to the top of the window
// controls (zoom, close, miniaturize) for a window with a tabstrip.
static const NSInteger kFramedWindowButtonsWithTabStripOffsetFromTop = 4;
static const NSInteger kFramedWindowButtonsWithTabStripOffsetFromLeft = 8;

// Offsets from the top/left of the window frame to the top of the window
// controls (zoom, close, miniaturize) for a window without a tabstrip.
static const NSInteger kFramedWindowButtonsWithoutTabStripOffsetFromTop = 4;
static const NSInteger kFramedWindowButtonsWithoutTabStripOffsetFromLeft = 8;

@interface YQFramedWindow ()
@property (nonatomic, assign) BOOL hasTitleBar;
@property (nonatomic, strong) NSButton *closeButton;
@property (nonatomic, strong) NSButton *miniaturizeButton;
@property (nonatomic, strong) NSButton *zoomButton;
// Locks the window's frame and style mask. If it's set to YES, then the
// frame and the style mask cannot be changed.
@property (nonatomic, assign) BOOL styleMaskLock;
@property (nonatomic, assign) CGFloat windowButtonsInterButtonSpacing;
@end

@implementation YQFramedWindow

- (void)setStyleMask:(NSUInteger)styleMask {
    if (_styleMaskLock)
        return;
    [super setStyleMask:styleMask];
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    if (self = [self initWithContentRect:contentRect hasTitleBar:YES]) {

    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect
              hasTitleBar:(BOOL)hasTitleBar{
    NSUInteger styleMask = NSWindowStyleMaskTitled |
    NSWindowStyleMaskClosable |
    NSWindowStyleMaskMiniaturizable |
    NSWindowStyleMaskResizable |
    NSWindowStyleMaskTexturedBackground;
    
    if ((self = [super initWithContentRect:contentRect
                                 styleMask:styleMask
                                   backing:NSBackingStoreBuffered
                                     defer:YES
                    wantsViewsOverTitlebar:hasTitleBar])) {
        // The 10.6 fullscreen code copies the title to a different window, which
        // will assert if it's nil.
        [self setTitle:@""];

        // The following two calls fix http://crbug.com/25684 by preventing the
        // window from recalculating the border thickness as the window is
        // resized.
        // This was causing the window tint to change for the default system theme
        // when the window was being resized.
        [self setAutorecalculatesContentBorderThickness:NO forEdge:NSMaxYEdge];
        [self setContentBorderThickness:kWindowGradientHeight forEdge:NSMaxYEdge];

        _hasTitleBar = hasTitleBar;
        _closeButton = [self standardWindowButton:NSWindowCloseButton];
        [_closeButton setPostsFrameChangedNotifications:YES];
        _miniaturizeButton = [self standardWindowButton:NSWindowMiniaturizeButton];
        [_miniaturizeButton setPostsFrameChangedNotifications:YES];
        _zoomButton = [self standardWindowButton:NSWindowZoomButton];
        [_zoomButton setPostsFrameChangedNotifications:YES];

        _windowButtonsInterButtonSpacing =
        NSMinX([_miniaturizeButton frame]) - NSMaxX([_closeButton frame]);

        [self adjustButton:_closeButton ofKind:NSWindowCloseButton];
        [self adjustButton:_miniaturizeButton ofKind:NSWindowMiniaturizeButton];
        [self adjustButton:_zoomButton ofKind:NSWindowZoomButton];

        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(adjustCloseButton:)
                       name:NSViewFrameDidChangeNotification
                     object:_closeButton];
        [center addObserver:self
                   selector:@selector(adjustMiniaturizeButton:)
                       name:NSViewFrameDidChangeNotification
                     object:_miniaturizeButton];
        [center addObserver:self
                   selector:@selector(adjustZoomButton:)
                       name:NSViewFrameDidChangeNotification
                     object:_zoomButton];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)adjustCloseButton:(NSNotification*)notification {
    [self adjustButton:[notification object]
                ofKind:NSWindowCloseButton];
}

- (void)adjustMiniaturizeButton:(NSNotification*)notification {
    [self adjustButton:[notification object]
                ofKind:NSWindowMiniaturizeButton];
}

- (void)adjustZoomButton:(NSNotification*)notification {
    [self adjustButton:[notification object]
                ofKind:NSWindowZoomButton];
}

- (void)adjustButton:(NSButton*)button
              ofKind:(NSWindowButton)kind {
    NSRect buttonFrame = [button frame];

    CGFloat xOffset = _hasTitleBar
    ? kFramedWindowButtonsWithTabStripOffsetFromLeft
    : kFramedWindowButtonsWithoutTabStripOffsetFromLeft;
    CGFloat yOffset = _hasTitleBar
    ? kFramedWindowButtonsWithTabStripOffsetFromTop
    : kFramedWindowButtonsWithoutTabStripOffsetFromTop;
    buttonFrame.origin =
    NSMakePoint(xOffset, (NSHeight([self frame]) -
                          NSHeight(buttonFrame) - yOffset));

    switch (kind) {
        case NSWindowZoomButton:
            buttonFrame.origin.x += NSWidth([_miniaturizeButton frame]);
            buttonFrame.origin.x += _windowButtonsInterButtonSpacing;
            // fallthrough
        case NSWindowMiniaturizeButton:
            buttonFrame.origin.x += NSWidth([_closeButton frame]);
            buttonFrame.origin.x += _windowButtonsInterButtonSpacing;
            // fallthrough
        default:
            break;
    }

    BOOL didPost = [button postsBoundsChangedNotifications];
    [button setPostsFrameChangedNotifications:NO];
    [button setFrame:buttonFrame];
    [button setPostsFrameChangedNotifications:didPost];
}

// The tab strip view covers our window buttons. So we add hit testing here
// to find them properly and return them to the accessibility system.
- (id)accessibilityHitTest:(NSPoint)point {
    //  NSPoint windowPoint = [self convertScreenToBase:point];
    NSRect pointFrame = NSMakeRect(point.x, point.y, 0, 0);
    NSPoint windowPoint = [self convertRectFromScreen:pointFrame].origin;
    NSControl* controls[] = { _closeButton, _zoomButton, _miniaturizeButton };
    id value = nil;
    for (size_t i = 0; i < sizeof(controls) / sizeof(controls[0]); ++i) {
        if (NSPointInRect(windowPoint, [controls[i] frame])) {
            value = [controls[i] accessibilityHitTest:point];
            break;
        }
    }
    if (!value) {
        value = [super accessibilityHitTest:point];
    }
    return value;
}

- (void)setStyleMaskLock:(BOOL)lock {
    _styleMaskLock = lock;
}

- (CGFloat)windowButtonsInterButtonSpacing {
    return _windowButtonsInterButtonSpacing;
}

// This method is called whenever a window is moved in order to ensure it fits
// on the screen.  We cannot always handle resizes without breaking, so we
// prevent frame constraining in those cases.
- (NSRect)constrainFrameRect:(NSRect)frame toScreen:(NSScreen*)screen {
    // Do not constrain the frame rect if our delegate says no.  In this case,
    // return the original (unconstrained) frame.
    id delegate = [self controller];
    if ([delegate respondsToSelector:@selector(shouldConstrainFrameRect)]
        && ![delegate shouldConstrainFrameRect])
        return frame;

    return [super constrainFrameRect:frame toScreen:screen];
}

+ (BOOL)drawWindowThemeInDirtyRect:(NSRect)dirtyRect
                           forView:(NSView*)view
                            bounds:(NSRect)bounds
              forceBlackBackground:(BOOL)forceBlackBackground {
    NSColor* themeColor = [NSColor whiteColor];
    NSCompositingOperation operation = NSCompositingOperationCopy;
    if (forceBlackBackground) {
        [[NSColor blackColor] set];
        NSRectFill(dirtyRect);
        operation = NSCompositingOperationSourceOver;
    }
    [themeColor set];
    NSRectFillUsingOperation(dirtyRect, operation);
    return YES;
}

@end
