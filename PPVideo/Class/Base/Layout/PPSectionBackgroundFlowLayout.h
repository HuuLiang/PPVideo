//
//  PPSectionBackgroundFlowLayout.h
//  PPVideo
//
//  Created by Liang on 2016/10/17.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PPElementKindSectionBackground;

@interface PPSectionBackgroundFlowLayout : UICollectionViewFlowLayout

@end


@protocol PPSectionBackgroundFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
shouldDisplaySectionBackgroundInSection:(NSUInteger)section;

@end
