//
//  TSKStoreProductViewControllerViewController.h
//  openaid
//
//  Created by tangxianhai on 2017/8/21.
//  Copyright © 2017年 tangxianhai. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#endif
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "WJPhotoTool.h"
#import "UIImage+T.h"
#import "T.h"
#import "UIView+Toast.h"
#import "ZwImagesQueueDownloader.h"
#import <Photos/Photos.h>
#import <objc/runtime.h>

@interface TSKStoreProductViewController : SKStoreProductViewController

@property (nonatomic, copy) void(^finishBlock)(TSKStoreProductViewController *tskStreProductVc);

@end
