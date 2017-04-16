//
//  AppDelegate.m
//  CustomWindow
//
//  Created by yiqiwang(王一棋) on 2017/4/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "AppDelegate.h"
#import "YQWindowController.h"

@interface AppDelegate ()
@property (nonatomic, strong) YQWindowController *windowController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.windowController = [[YQWindowController alloc] init];
    [self.windowController showWindow:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
