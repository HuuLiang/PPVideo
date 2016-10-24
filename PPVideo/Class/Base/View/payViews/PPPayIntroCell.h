//
//  PPPayIntroCell.h
//  PPVideo
//
//  Created by Liang on 2016/10/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define vipNoneIntroStr @"充值成功后，将获得相应等级的永久会员资格，享受资源定期更新服务。"
#define vipAIntroStr    @"升级成功后，将获升级等级的永久会员资格，享受高端会员更多优质资源服务。"
#define vipBIntroStr    @"升级成功后，将获升级等级的永久会员资格，享受高端会员更多优质资源服务。"

@interface PPPayIntroCell : UITableViewCell

@property (nonatomic) NSAttributedString *attStr;

@end
