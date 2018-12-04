//
//  NNLegalTenderTradeOrderDetailModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderDetailModel.h"

@implementation NNLegalTenderTradeOrderDetailPayInfoModel 



@end

@implementation NNLegalTenderTradeOrderDetailModel


- (NSMutableArray *)paymentArray
{
    if (_paymentArray == nil) {
        _paymentArray = [NSMutableArray array];
        
        if (self.payinfo.alipay.name.length) {
            self.payinfo.alipay.paymentType = NNLegalTenderTradePaymentType_ali;
            self.payinfo.alipay.paymentName = @"支付宝";
            [_paymentArray addObject:self.payinfo.alipay];
        }
        
        if (self.payinfo.wechat.name.length) {
            self.payinfo.wechat.paymentType = NNLegalTenderTradePaymentType_wechat;
            self.payinfo.wechat.paymentName = @"微信";
            [_paymentArray addObject:self.payinfo.wechat];
        }
        
        if (self.payinfo.bank.name.length) {
            self.payinfo.bank.paymentType = NNLegalTenderTradePaymentType_bank;
            self.payinfo.bank.paymentName = @"银行转账";
            [_paymentArray addObject:self.payinfo.bank];
        }
    }
    return _paymentArray;
}

- (NSString *)rightItemTitle
{
    //    订单状态说明 0 待交易（刚发布）,1 已买入未付款,2 已付款未确认,3 已确认付款（完结）,5 已撤销 6 买家取消 7买家违规 8卖家违规 */
    
    if ([self.type isEqualToString:@"1"]) {
        if ([self.status isEqualToString:@"1"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_cancle;
            return @"取消订单";
        }else if ([self.status isEqualToString:@"2"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"3"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"6"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_normal;
            return @"";
        }else if ([self.status isEqualToString:@"7"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"8"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_normal;
            return @"";
        }
    }else {
        if ([self.status isEqualToString:@"1"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_normal;
            return @"";
        }else if ([self.status isEqualToString:@"2"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"3"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"6"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_normal;
            return @"";
        }else if ([self.status isEqualToString:@"7"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else if ([self.status isEqualToString:@"8"]) {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_appeal;
            return @"我要申诉";
        }else {
            self.rightItmeType =  NNLegalTenderTradeTightItemOperationType_normal;
            return @"";
        }
    }
}

-(NNLegalTenderTradeTightItemOperationType)rightItmeType
{
    if ([self.type isEqualToString:@"1"]) {
        if ([self.status isEqualToString:@"1"]) {
            return NNLegalTenderTradeTightItemOperationType_cancle;
        }else if ([self.status isEqualToString:@"2"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"3"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"6"]) {
            return NNLegalTenderTradeTightItemOperationType_normal;
        }else if ([self.status isEqualToString:@"7"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"8"]) {            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else {
            return NNLegalTenderTradeTightItemOperationType_normal;
        }
    }else {
        if ([self.status isEqualToString:@"1"]) {
            return NNLegalTenderTradeTightItemOperationType_normal;
        }else if ([self.status isEqualToString:@"2"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"3"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"6"]) {
            return NNLegalTenderTradeTightItemOperationType_normal;
        }else if ([self.status isEqualToString:@"7"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else if ([self.status isEqualToString:@"8"]) {
            return NNLegalTenderTradeTightItemOperationType_appeal;
        }else {
            return NNLegalTenderTradeTightItemOperationType_normal;
        }
    }
}


@end
