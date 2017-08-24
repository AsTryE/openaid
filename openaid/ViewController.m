//
//  ViewController.m
//  openaid
//
//  Created by tangxianhai on 2017/8/15.
//  Copyright © 2017年 tangxianhai. All rights reserved.
//

#import "ViewController.h"
#import "T.h"
#import <StoreKit/StoreKit.h>
#import <objc/runtime.h>
#import "UIImage+T.h"
#import "TSKStoreProductViewController.h"
#import "TSKStoreProductViewController+DownloadPicture.h"
#import "ZwImagesQueueDownloader.h"

@interface ViewController () <SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled_appId;
@property (weak, nonatomic) IBOutlet UIImageView *scimage;
@end

@implementation ViewController {
    BOOL success;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePathAppIcon = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:APP_ICON];
    UIImage *appIconImage = [UIImage imageWithContentsOfFile:filePathAppIcon];
    self.iconImageView.image = appIconImage;
    self.iconImageView.contentMode = UIViewContentModeCenter;
}
                                                                    
- (IBAction)jump:(id)sender {
    NSString *appid = self.textFiled_appId.text;
    if ([appid isEqualToString:@""]) {
        appid = @"440948110";
    }
    [self openAppWithIdentifier:appid];
}

/// 根据appId应用内打开app
- (void)openAppWithIdentifier:(NSString *)appId {
    // 初始化控制器
    TSKStoreProductViewController *storeProductVC = [[TSKStoreProductViewController alloc] init];
    // 开始下载模板图片
    [storeProductVC startDownloadImageByIphoneType:@"6p"];
    // 设置opencv校验完成后的回调block
    storeProductVC.finishBlock = ^(TSKStoreProductViewController *tskStreProduc) {
        [tskStreProduc dismissViewControllerAnimated:YES completion:nil];
    };
    // 应用内打开APP详情界面
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisappear>........");
}

@end
