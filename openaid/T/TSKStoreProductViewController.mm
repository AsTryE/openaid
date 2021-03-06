//
//  TSKStoreProductViewControllerViewController.m
//  openaid
//
//  Created by tangxianhai on 2017/8/21.
//  Copyright © 2017年 tangxianhai. All rights reserved.
//

#import "TSKStoreProductViewController.h"

enum AppState : NSUInteger {
    AppStateUpdate,
    AppStateOpen,
    AppStateGet,
    AppStateIcon,
    AppStateError,
};

@interface TSKStoreProductViewController ()<PHPhotoLibraryChangeObserver>
@property (nonatomic) BOOL isTakeScreenshot;
@property (nonatomic) AppState appState;
@property (nonatomic) BOOL isAppIcon;
@property (nonatomic,strong) NSArray<UIImage*> * tmpMatImage;
@end

@implementation TSKStoreProductViewController {
    UIWindow *topWindow;
    cv::Point currentLoc;
    cv::Mat inputMat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSomething];
}

- (void)prepareSomething {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    //相册变化通知
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    topWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    topWindow.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
    topWindow.windowLevel = UIWindowLevelAlert;
    topWindow.hidden = NO;
}

- (void)startCCCCCCC {
    // 初始化应用状态
    self.appState = AppStateError;
    self.isAppIcon = YES;
    
    [self appstoreGetStateQ];
    [self appstoreOpenStateQ];
    [self appstoreUpdateStateQ];
    
    [MBProgressHUD hideHUDForView:topWindow animated:YES];
    if (self.isAppIcon) {
        // 应用是指定的下载应用
        if (self.appState == AppStateGet) {
            // 当前为获取状态
            [topWindow makeToast:@"当前为获取状态！" duration:2 position:CSToastPositionTop];
        } else if (self.appState == AppStateUpdate) {
            // 当前为更新状态
            [topWindow makeToast:@"当前为更新状态" duration:2 position:CSToastPositionTop];
        } else if (self.appState == AppStateOpen) {
            // 当前为打开状态，即下载完成
            [topWindow makeToast:@"当前为打开状态，即下载完成" duration:2 position:CSToastPositionTop];
        } else {
            // 异常状态
            [topWindow makeToast:@"请在指定的任务界面截图！" duration:2 position:CSToastPositionTop];
        }
    } else {
        [topWindow makeToast:@"您下载的应用不是指定应用！" duration:2 position:CSToastPositionTop];
    }
    if (self.finishBlock != nil) {
        self.finishBlock(self);
    }
    [self deletePhotoLastPicture];
}

/// 检测AppStore 应用是否有打开按钮
- (void)appstoreOpenStateQ {
    // Appstore应用状态打开
    @synchronized(self) {
        NSString *filePathAppOpen = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:APP_OPEN];
        UIImage *appopenImage = [UIImage imageWithContentsOfFile:filePathAppOpen];
        NSArray *appopenImageArry = [self compareByLevel:1 CameraInput:inputMat templateMat:[self initTemplateImage:appopenImage]];
        NSLog(@"appopenImageArry: %@",appopenImageArry);
        if ([appopenImageArry count] > 0) {
            self.appState = AppStateOpen;
        } else {
        }
    }
    
}


/// 检测AppStore 应用是否有更新按钮
- (void)appstoreUpdateStateQ {
    // Appstore应用状态更新
    
    @synchronized(self) {
        NSString *filePathAppUpdate = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:APP_UPDATE];
        UIImage *appupdateImage = [UIImage imageWithContentsOfFile:filePathAppUpdate];
        NSArray *appupdateImageArray = [self compareByLevel:1 CameraInput:inputMat templateMat:[self initTemplateImage:appupdateImage]];
        NSLog(@"appupdateImageArray: %@",appupdateImageArray);
        if ([appupdateImageArray count] > 0) {
            self.appState = AppStateUpdate;
        } else {
        }
    }
    
}


/// 检测AppStore 应用是否有获取按钮
- (void)appstoreGetStateQ {
    // Appstore应用状态获取
    
    @synchronized(self)
    {
        NSString *filePathAppGet = [[ZwImagesQueueDownloader shareInstance] imageFileFullPathWithFileName:APP_GET];
        UIImage *appgetImage = [UIImage imageWithContentsOfFile:filePathAppGet];
        NSArray *appgetImageArry = [self compareByLevel:1 CameraInput:inputMat templateMat:[self initTemplateImage:appgetImage]];
        NSLog(@"appgetImageArry: %@",appgetImageArry);
        if ([appgetImageArry count] > 0) {
            self.appState = AppStateGet;
        } else {
        }
    }
    
}

- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    
    if (self.isTakeScreenshot) {
        NSLog(@"change change......");
        __weak TSKStoreProductViewController *weakSelf =  self;
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
            [hud.backgroundView setStyle:MBProgressHUDBackgroundStyleSolidColor];
        });
        self.isTakeScreenshot = NO;
        // 表示当前保存的图片是截屏那面过来的最新图片
        [WJPhotoTool latestAsset:^(WJAsset * _Nullable asset) {
            // 开始识别图片是否有完成按钮和应用图标
            inputMat = [self initTemplateImage:asset.image];
            [self startCCCCCCC];
        }];
    }
}

// 获取当前时间戳
- (NSString *)currentTimeStr {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    NSLog(@"检测到截屏，时间：%@",[self currentTimeStr]);
    self.isTakeScreenshot = YES;
}

- (void)deletePhotoLastPicture {
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx == [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    //                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
}

#pragma mark - Opencv2 Method
//将图片转换为灰度的矩阵
-(cv::Mat)initTemplateImageName:(NSString *)imgName{
    UIImage *templateImage = [UIImage imageNamed:imgName];
    cv::Mat tempMat;
    UIImageToMat(templateImage, tempMat);
    //cv::cvtColor(tempMat, tempMat, CV_BGR2GRAY);
    return tempMat;
}

-(cv::Mat)initTemplateImage:(UIImage *)img{
    UIImage *templateImage = img;
    cv::Mat tempMat;
    UIImageToMat(templateImage, tempMat);
    //cv::cvtColor(tempMat, tempMat, CV_BGR2GRAY);
    return tempMat;
}

/**
 对比两个图像是否有相同区域
 
 @return 有为Yes
 */
-(BOOL)compareInput:(cv::Mat)inputMat templateMat:(cv::Mat)tmpMat{
    int result_rows = inputMat.rows - tmpMat.rows + 1;
    int result_cols = inputMat.cols - tmpMat.cols + 1;
    
    cv::Mat resultMat = cv::Mat(result_cols,result_rows,CV_32FC1);
    cv::matchTemplate(inputMat, tmpMat, resultMat, cv::TM_CCOEFF_NORMED);
    
    
    double minVal, maxVal;
    cv::Point minLoc, maxLoc, matchLoc;
    cv::minMaxLoc( resultMat, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat());
    //    matchLoc = maxLoc;
    //    NSLog(@"min==%f,max==%f",minVal,maxVal);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"相似度：%.2f",maxVal] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //        [alert show];
    //    });
    NSLog(@"%@",[NSString stringWithFormat:@"相似度：%.2f",maxVal]);
    if (maxVal > 0.85) {
        //有相似位置，返回相似位置的第一个点
        currentLoc = maxLoc;
        return YES;
    }else{
        return NO;
    }
}

//图像金字塔分级放大缩小匹配，最大0.8*相机图像，最小0.3*tep图像 level = 8
-(NSArray *)compareByLevel:(int)level CameraInput:(cv::Mat) inputMat templateMat:(cv::Mat) templateMat{
    //相机输入尺寸
    int inputRows = inputMat.rows;
    int inputCols = inputMat.cols;
    
    //模板的原始尺寸
    int tRows = templateMat.rows;
    int tCols = templateMat.cols;
    
    NSMutableArray *marr = [NSMutableArray array];
    
    for (int i = 0; i < level; i++) {
        //取循环次数中间值
        int mid = level*0.5;
        //目标尺寸
        cv::Size dstSize;
        if (i<mid) {
            //如果是前半个循环，先缩小处理
            dstSize = cv::Size(tCols*(1-i*0.2),tRows*(1-i*0.2));
        }else{
            //然后再放大处理比较
            int upCols = tCols*(1+i*0.2);
            int upRows = tRows*(1+i*0.2);
            //如果超限会崩，则做判断处理
            if (upCols>=inputCols || upRows>=inputRows) {
                upCols = tCols;
                upRows = tRows;
            }
            dstSize = cv::Size(upCols,upRows);
        }
        //重置尺寸后的tmp图像
        cv::Mat resizeMat;
        cv::resize(templateMat, resizeMat, dstSize);
        //然后比较是否相同
        BOOL cmpBool = [self compareInput:inputMat templateMat:resizeMat];
        
        if (cmpBool) {
            NSLog(@"匹配缩放级别level==%d",i);
            CGRect rectF = CGRectMake(currentLoc.x, currentLoc.y, dstSize.width, dstSize.height);
            NSValue *rValue = [NSValue valueWithCGRect:rectF];
            [marr addObject:rValue];
            break;
        }
    }
    return marr;
}

- (void)dealloc {
    NSLog(@"dealloc......");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    topWindow.hidden = YES;
    topWindow = nil;
}

@end
