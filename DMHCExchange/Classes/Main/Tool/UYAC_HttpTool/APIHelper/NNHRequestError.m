//
//  NNHRequestError.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/3.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNHRequestError.h"

@implementation NNHRequestError

- (NSString *)printErrorInfo
{
    
    NSString *errorDes = [NSString stringWithFormat:@"AKRequestErrorInfo : \n  \
                          APIName: %@ \n \
                          ErrorCode %ld,   \n  \
                          Reason: %@ \n  \
                          OriginError: %@ ", self.errorApiName, (long)self.errorCode,self.errorReason,self.errrorOringin];
    
    NNHLog(@"*************************************************************\n \
            **********%@ \n ***********************************",errorDes);
    return errorDes;
}

@end
