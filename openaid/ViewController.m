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
#import "UIView+Color.h"
#import "UIImage+T.h"
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
    UIImage *imagttt = [UIImage imageNamed:@"testt"];
    UIImage *appIconImage = [UIImage imageWithContentsOfFile:filePathAppIcon];
    
    appIconImage = [self imageCompressWithSimple:appIconImage scale:2];
    
    
    self.iconImageView.image = appIconImage;
    self.iconImageView.contentMode = UIViewContentModeCenter;
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    size = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(size); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (void)startDownImage:(NSString *)appid
//{
//    // 根据APPID获取应用图标
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",@"414478124"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSession *session=[NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"网络响应：response：%@",response);
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if (json != nil) {
//            NSArray *tA = [json objectForKey:@"results"];
//            if ([tA count] != 0) {
//                NSDictionary *appInformation = [tA objectAtIndex:0];
//                if (appInformation != nil) {
//                    // 开始获取应用图标
//                    NSString *artworkUrl100 = [appInformation objectForKey:@"artworkUrl100"];
//                    NSString *artworkUrl512 = [appInformation objectForKey:@"artworkUrl512"];
//                    NSString *artworkUrl60 = [appInformation objectForKey:@"artworkUrl60"];
//
//                    NSString * url_appicon = artworkUrl100;
//                    NSString * url_app_get = @"http://qiniubigresource.nineton.cn/appStore/app_get.png";
//                    NSString * url_app_update = @"http://qiniubigresource.nineton.cn/appStore/app_update.png";
//                    NSString * url_app_open = @"http://qiniubigresource.nineton.cn/appStore/app_open.png";
//
//                    ZwImageFileModel *model1 = [[ZwImageFileModel alloc] initWithImageName:APP_ICON
//                                                                                  imageURL:url_appicon];
//                    ZwImageFileModel *model2 = [[ZwImageFileModel alloc] initWithImageName:APP_GET
//                                                                                  imageURL:url_app_get];
//                    ZwImageFileModel *model3 = [[ZwImageFileModel alloc] initWithImageName:APP_UPDATE
//                                                                                  imageURL:url_app_update];
//                    ZwImageFileModel *model4 = [[ZwImageFileModel alloc] initWithImageName:APP_OPEN
//                                                                                  imageURL:url_app_open];
//
//                    NSMutableArray *array = [[NSMutableArray alloc] init];
//                    [array addObject:model1];
//                    [array addObject:model2];
//                    [array addObject:model3];
//                    [array addObject:model4];
//
//                    [[ZwImagesQueueDownloader shareInstance] queueDownloadImagesByArray:array finishedBlock:^(BOOL isSuccess, NSString *tipsString) {
//                        if (isSuccess)
//                        {
//                            NSString *filePath = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:model1.imgName];
//                            NSLog(@"%@", filePath);
//                        }
//                        else
//                        {
//                            NSLog(@"%@", tipsString);
//                        }
//                    }];
//                }
//            } else {
//                NSLog(@"%@",@"数据为空");
//            }
//        }
//    }
//];
//    [dataTask resume];
//}

- (void)startDownImage:(NSString *)appid
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
                                                                    
- (IBAction)jump:(id)sender {
    
//    Class SKProductPageViewController = NSClassFromString(@"SKProductPageViewController");
//    id si = [SKProductPageViewController performSelector:@selector(_defaultClientInterface)];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//
//    [si performSelector:@selector(loadProductWithRequest:) withObject:request];
//
// 830084886 440948110 414478124
//    NSLog(@"-- %@", [si valueForKey:@"deviceColor"]);
    
    NSString *appid = self.textFiled_appId.text;
    if ([appid isEqualToString:@""]) {
        appid = @"440948110";
    }
    [self openAppWithIdentifier:appid];
    // 开始下载判断所需图片
    [self startDownImage:appid];
}


- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
   
    
    [viewController dismissViewControllerAnimated:YES completion:^{
  
        
    }];
}

// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        NSLog(@"%@%d: %@", blank, level, subview.class);
        
        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisappear>........");
    
}


@end
