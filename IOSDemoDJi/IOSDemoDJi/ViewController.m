//
//  ViewController.m
//  IOSDemoDJi
//
//  Created by zhangqi on 30/11/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "ViewController.h"
#import <DJISDK/DJISDK.h>
#import <VideoPreviewer/VideoPreviewer.h>

@interface ViewController ()<DJICameraDelegate, DJISDKManagerDelegate, DJIBaseProductDelegate>
@property (weak, nonatomic) IBOutlet UIView *fpvPreviewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[VideoPreviewer instance] setView:self.fpvPreviewView];
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

- (DJICamera*) fetchCamera {
    if (![DJISDKManager product]) {
        return nil;
    }
    
    if ([[DJISDKManager product] isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)[DJISDKManager product]).camera;
    }else if ([[DJISDKManager product] isKindOfClass:[DJIHandheld class]]){
        return ((DJIHandheld *)[DJISDKManager product]).camera;
    }
    return nil;
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
            [[VideoPreviewer instance] start];
        }
}

/**
 *  Called when the `product` property changed.
 *
 *  @param oldProduct Old product object. nil if starting up.
 *  @param newProduct New product object. nil if the USB link or WiFi link
 *                    between the product and phone is disconnected.
 */
- (void)sdkManagerProductDidChangeFrom:(DJIBaseProduct *_Nullable)oldProduct to:(DJIBaseProduct *_Nullable)newProduct
{
    if (newProduct) {
        [newProduct setDelegate:self];
        DJICamera* camera = [self fetchCamera];
        if (camera != nil) {
            camera.delegate = self;
        }
    }
}

#pragma mark - DJIBaseProductDelegate Method
/**
 *  Callback delegate method when a component object changes.
 *
 */
- (void)componentWithKey:(NSString *)key
             changedFrom:(DJIBaseComponent *_Nullable)oldComponent
                      to:(DJIBaseComponent *_Nullable)newComponent
{
    if ([key isEqualToString:DJICameraComponent] && newComponent != nil) {
        __weak DJICamera* camera = [self fetchCamera];
        if (camera) {
            [camera setDelegate:self];
        }
    }
}

#pragma mark - DJICameraDelegate Method
/**
 *  Video data update callback. H.264 (also called MPEG-4 Part 10 Advanced Video Coding or MPEG-4 AVC)
 *  is a video coding format that is currently one of the most commonly used formats for the recording,
 *  compression, and distribution of video content.
 *
 *  @param camera      Camera that sends out the video data.
 *  @param videoBuffer H.264 video data buffer. Don't free the buffer after it has been used. The
 *  units for the video buffer are bytes.
 *  @param length      Size of the address of the video data buffer in bytes.
 */
- (void)camera:(DJICamera *_Nonnull)camera didReceiveVideoData:(uint8_t *)videoBuffer length:(size_t)size
{
    [[VideoPreviewer instance] push:videoBuffer length:(int)size];
}

/**
 *  Updates the camera's current state.
 *
 *  @param camera      Camera that updates the current state.
 *  @param systemState The camera's system state.
 */
- (void)camera:(DJICamera *_Nonnull)camera didUpdateSystemState:(DJICameraSystemState *_Nonnull)systemState
{
    
}



@end
