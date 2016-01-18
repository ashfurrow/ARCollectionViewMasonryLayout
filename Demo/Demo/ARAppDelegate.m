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

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
    ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
    viewController.colorCount = 100;
    viewController.headerSize = CGSizeMake(10, 20);
    viewController.footerSize = CGSizeMake(10, 2);
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
