//
//  NNLegalTenderTradeOrderDetailPHelper.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderDetailHelper.h"
#import "NNLegalTenderTradeOrderDetailModel.h"
#import "NNAPILegalTenderTool.h"
#import "NNLegalTenderTradeOrderAppealViewController.h"

#import "NNUploadImageTool.h"
#import "NNHAlertTool.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NNImagePickerViewController.h"
#import "TZImagePickerController.h"

@implementation NNLegalTenderTradeOrderDetailHelper

- (void)contactTheCuonsumer
{
    [[NNHAlertTool shareAlertTool] showAlertView:self.currentViewController title:@"拨打电话联系对方" message:self.orderModel.mobile cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
        [[NNHApplicationHelper sharedInstance] openPhoneNum:self.orderModel.mobile InView:self.currentViewController.view];
    } cancle:^{
        
    }];
}

/** 上传凭证 */
- (void)uploadOrderCertificateWithImageView:(UIImageView *)scanImageView
{
    //选取图片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.naviBgColor = [UIColor blackColor];
    imagePickerVc.naviTitleColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.barItemTextColor = [UIConfigManager colorNaviBarTitle];
    imagePickerVc.naviTitleFont = [UIConfigManager fontNaviTitle];
    imagePickerVc.barItemTextFont = [UIConfigManager fontNaviBarButtonTitle];
    NNHWeakSelf(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [NNUploadImageTool uploadWithImage:[photos lastObject] successBlock:^(NSString *upUrl, NSString *wholeUrl) {
            [weakself uploadTradeImageWithImageURl:upUrl orderID:self.orderModel.tradeid];
        } failedBlock:^(NNHRequestError *error) {
            
        }];
    }];
    
    [self.currentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 查看凭证 */
- (void)scanOrderCertificateWithImageView:(UIImageView *)scanImageView
{
    if (self.orderModel.payimg.length) {
        [self scanPictureWithUrl:self.orderModel.payimg fromImageView:scanImageView];
    }
}

- (void)scanPictureWithUrl:(NSString *)url fromImageView:(UIImageView *)imageView
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    
    // 设置图片的路径
    photo.url = [NSURL URLWithString:url];
    
    // 设置来源于哪一个UIImageView
    photo.srcImageView = imageView;
    [photos addObject:photo];
    
    browser.photos = photos;
    // 4.设置默认显示的图片索引
    browser.currentPhotoIndex = 0;
    // 5.显示浏览器
    [browser show];
}

/** 上传凭证 请求网络操作 */
- (void)uploadTradeImageWithImageURl:(NSString *)imageUrl orderID:(NSString *)orderID
{
    NNHWeakSelf(self)
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initOrderDetailUploadCertificateWithImgpath:imageUrl orderID:orderID];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD showMessage:@"上传成功"];
        if (weakself.reloadDataBlock) {
            weakself.reloadDataBlock();
        }
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)operationViewAction
{
    // 订单状态说明 0 待交易（刚发布）,1 已买入未付款,2 已付款未确认,3 已确认付款（完结）,5 已撤销 6 买家取消 7买家违规 8卖家违规
    
    if ([self.orderModel.type isEqualToString:@"1"] && [self.orderModel.status isEqualToString:@"1"]) {
        
        [self buyerShouldPayOrder];
        
    }else if ([self.orderModel.type isEqualToString:@"2"] && [self.orderModel.status isEqualToString:@"2"]) {
        [self sellerConfirmReceiveMoney];
    }
}

/** 买家 确认付款  */
- (void)buyerShouldPayOrder
{
    NNHWeakSelf(self)
    
    if (!self.orderModel.payimg.length) {
        [SVProgressHUD showMessage:@"请上传付款凭证"];
        return;
    }
    
    NSString *payType = [NSString stringWithFormat:@"%ld",self.orderModel.selectedPayment.paymentType + 1];
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initOrderDetailBuyerConfirmPayOrderWithOrderID:self.orderModel.tradeid paytype:payType];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        if (weakself.reloadDataBlock) {
            weakself.reloadDataBlock();
        }
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

/** 卖家 确认收款  */
- (void)sellerConfirmReceiveMoney
{
    if (self.orderModel.password.length == 0) {
        [SVProgressHUD showMessage:@"请输入支付密码"];
        return;
    }
    
    NNHWeakSelf(self)
    [SVProgressHUD show];
    NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initOrderDetailSellerConfirmReceiveMoneyWithOrderID:self.orderModel.tradeid password:self.orderModel.password];
    [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        if (weakself.reloadDataBlock) {
            weakself.reloadDataBlock();
        }
    } failBlock:^(NNHRequestError *error) {
        
    } isCached:NO];
}

- (void)rightItemAction
{
    NNHWeakSelf(self)
    if (self.orderModel.rightItmeType == NNLegalTenderTradeTightItemOperationType_cancle) {
        NNAPILegalTenderTool *tradeTool = [[NNAPILegalTenderTool alloc] initOrderDetailBuyerCancleOrderWithOrderID:self.orderModel.tradeid];
        [tradeTool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
            if (weakself.reloadDataBlock) {
                weakself.reloadDataBlock();
            }
        } failBlock:^(NNHRequestError *error) {
            
        } isCached:NO];
    }else if (self.orderModel.rightItmeType == NNLegalTenderTradeTightItemOperationType_appeal) {
        NNLegalTenderTradeOrderAppealViewController *appleVC = [[NNLegalTenderTradeOrderAppealViewController alloc] initWithOrderID:self.orderModel.tradeid];
        [self.currentViewController.navigationController pushViewController:appleVC animated:YES];
    }
}

@end
