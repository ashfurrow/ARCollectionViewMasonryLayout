//
//  ARAppDelegate.m
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARAppDelegate.h"
#import "ARCollectionViewController.h"
#import "ARCollectionViewMasonryLayout.h"
#import "ARCollectionViewReusableView.h"

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
    layout.headerViewClass = [ARCollectionViewReusableView class];
    layout.headerHeight = 10;
    layout.footerViewClass = [ARCollectionViewReusableView class];
    layout.footerHeight = 44;
    
    ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
