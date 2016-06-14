//
//  AppDelegate.m
//  RSlaunchAdViewController
//
//  Created by 王保霖 on 16/6/14.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "AppDelegate.h"
#import "RSLaunchAdView.h"

@interface AppDelegate ()<RSLaunchAdViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    RSLaunchAdView * view = [[RSLaunchAdView alloc]initWithWindow:self.window AdImageUrl:@"http://www.uisheji.com/wp-content/uploads/2013/04/19/app-design-uisheji-ui-icon20121_55.jpg"];
    
    view.delegate = self;
    
}

-(CGRect)RSLaunchAdViewRect{

    return self.window.bounds;
}

-(NSUInteger)RSLaunchAdViewShowDuration{

    return  6;
}

-(void)RSLaunchAdView:(RSLaunchAdView *)view didSelectItem:(RSAdSelectItem)item{

    NSLog(@"%d",item);
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
