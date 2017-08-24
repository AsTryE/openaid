## openaid

> iOS Opencv图片识别，图片必须是指定的图片。可以在指定的大图中查找并返回结果。

* 建立  
> 下载opencv2.framework导入项目中，即可运行。  
* 使用  
``` 
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

