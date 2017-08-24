//
//  TSKStoreProductViewController+DownloadPicture.m
//  openaid
//
//  Created by tangxianhai on 2017/8/23.
//  Copyright © 2017年 tangxianhai. All rights reserved.
//

#import "TSKStoreProductViewController+DownloadPicture.h"

@implementation TSKStoreProductViewController (DownloadPicture)
- (void)startDownloadImageByIphoneType:(NSString *)iphoneType
{
    // 开始获取应用图标
    NSString * url_app_get = @"http://qiniubigresource.nineton.cn/appStore/app_get.png";
    //    NSString * url_app_get = @"http://qiniubigresource.nineton.cn/app_get_small.png";
    NSString * url_app_update = @"http://qiniubigresource.nineton.cn/appStore/app_update.png";
    NSString * url_app_open = @"http://qiniubigresource.nineton.cn/appStore/app_open.png";
    
    ZwImageFileModel *model1 = [[ZwImageFileModel alloc] initWithImageName:APP_GET
                                                                  imageURL:url_app_get];
    ZwImageFileModel *model2 = [[ZwImageFileModel alloc] initWithImageName:APP_UPDATE
                                                                  imageURL:url_app_update];
    ZwImageFileModel *model3 = [[ZwImageFileModel alloc] initWithImageName:APP_OPEN
                                                                  imageURL:url_app_open];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:model1];
    [array addObject:model2];
    [array addObject:model3];
    
    [[ZwImagesQueueDownloader shareInstance] queueDownloadImagesByArray:array finishedBlock:^(BOOL isSuccess, NSString *tipsString) {
        if (isSuccess)
        {
            NSString *filePath = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:model1.imgName];
            NSLog(@"%@", filePath);
        }
        else
        {
            NSLog(@"%@", tipsString);
        }
    }];
}
@end
