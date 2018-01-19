//
//  PPHostIPModel.m
//  PPVideo
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPHostIPModel.h"
#import <AFNetworking.h>



@implementation PPHostIPModel

+ (instancetype)sharedModel {
    static PPHostIPModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[PPHostIPModel alloc] init];
    });
    return _sharedModel;
}

- (void)fetchHostList {
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * kDomainsURL = [NSString stringWithFormat:@"%@%@",PP_BASE_URL,PP_DOMAINS_URL];

    [sessionManager POST:kDomainsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[encryptedData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        NSMutableArray *paramsArr = [[NSMutableArray alloc] init];
        
        for (NSString *hostStr in dic[@"domains"]) {
            NSString *ipStrA = [[QBNetworkInfo sharedInfo] ipAddressOfHost:hostStr];
            NSString *ipStrB = [[QBNetworkInfo sharedInfo] ipAddressOfHost:hostStr];
            NSString *ipStrC = [[QBNetworkInfo sharedInfo] ipAddressOfHost:hostStr];
            
            NSMutableString *ipString =[[NSMutableString alloc] init];
            if (ipStrA) {
                [ipString appendFormat:@",%@",ipStrA];
            }
            if (ipStrB) {
                [ipString appendFormat:@",%@",ipStrB];
            }
            if (ipStrC) {
                [ipString appendFormat:@",%@",ipStrC];
            }
            
            if (ipString.length > 0) {
                NSDictionary *param = @{@"userId":[PPUtil userId],@"versionNo":PP_REST_APP_VERSION,@"domainName":hostStr,@"ip":[ipString substringFromIndex:1]};
                [paramsArr addObject:param];
            }
        }
        
        if (paramsArr.count > 0) {
            [self updatePingDomainsWithParams:paramsArr];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QBLog(@"%@",error);
    }];
    
}

- (void)updatePingDomainsWithParams:(NSArray *)paramsArr {
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * kPingDomainsURL = [NSString stringWithFormat:@"%@%@",PP_BASE_URL,PP_PINGDOMAINS_URL];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramsArr options:0 error:nil];
    NSString *newString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary *params = @{@"data":newString};
//    QBLog(@"%@",params);
    
    [sessionManager POST:kPingDomainsURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        QBLog(@"上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QBLog(@"%@",error);
    }];
}


@end
