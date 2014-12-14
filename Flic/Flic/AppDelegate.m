//
//  AppDelegate.m
//  Flic
//
//  Created by Mr Trung on 10/27/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "AppDelegate.h"
#import "PHImagePicker.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [self initializeAlbum];
    
    return YES;
}

- (void) initializeAlbum {
    int totalAlbum = 0;
    
    PHImagePicker *phPicker = [[PHImagePicker alloc] init];
    NSString *albumTop = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeTop];
    
    if (albumTop) {
        _phAlbumTop = [phPicker getAlbum:albumTop];
        totalAlbum++;
    }
    NSString *albumRight = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeRight];
    
    if (albumRight) {
        _phAlbumRight = [phPicker getAlbum:albumRight];
        totalAlbum++;
    }
    NSString *albumBottom = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeBottom];
    
    if (albumBottom) {
        _phAlbumBottom = [phPicker getAlbum:albumBottom];
        totalAlbum++;
    }
    NSString *albumLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kTypeLeft];
    
    if (albumLeft) {
        _phAlbumLeft = [phPicker getAlbum:albumLeft];
        totalAlbum++;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:totalAlbum forKey:kTotalAlbum];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
