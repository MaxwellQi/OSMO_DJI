//
//  ViewController.m
//  IOSDemoDJi
//
//  Created by zhangqi on 30/11/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import <DJISDK/DJISDK.h>

@interface ViewController ()<DJISDKManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self registerApp];
}

- (void)registerApp
{
    NSString *appKey = @"4a1e6edb5fb359e5c734d616";
    [DJISDKManager registerApp:appKey withDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --DJISDKManagerDelegate
/**
 *  Callback delegate method after the application attempts to register.
 *
 *  @param error `nil` if registration is successful. Otherwise it contains an
 *              `NSError` object with error codes from `DJISDKRegistrationError`.
 *
 */
- (void)sdkManagerDidRegisterAppWithError:(NSError *_Nullable)error
{
    NSLog(@"%@",error.userInfo);
        NSString* message = @"Register App Successful!";
        if (error) {
            message = @"Register App Failed! Please enter your App Key and check the network.";
        }else
        {
            NSLog(@"registerAppSuccess");
            [DJISDKManager startConnectionToProduct];
        }
}


@end
