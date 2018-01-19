//
//  PPDetailPhotoCell.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailPhotoCell.h"

static NSString *const kPPDetailPhotoCellReusableIdentifier = @"PPDetailPhotoCellReusableIdentifier";


@interface PPDetailPhotoCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_photoCollectionView;
}
@end

@implementation PPDetailPhotoCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kWidth(20);
        layout.minimumInteritemSpacing = kWidth(0);
        [layout setSectionInset:UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20))];
        layout.itemSize = CGSizeMake((kScreenWidth - kWidth(80))/3.5, (kScreenWidth - kWidth(80))/3.5/0.79);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [UIColor clearColor];
        [_photoCollectionView registerClass:[PPPhotoCell class] forCellWithReuseIdentifier:kPPDetailPhotoCellReusableIdentifier];
        [self addSubview:_photoCollectionView];
        
        {
            [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
    }
    return self;
}

-(void)setImgUrls:(NSArray *)imgUrls {
    _imgUrls = imgUrls;
    [_photoCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imgUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPPDetailPhotoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < _imgUrls.count) {
        PPDetailUrlModel *model = _imgUrls[indexPath.item];
        cell.imgUrlStr = model.url;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < _imgUrls.count) {
        PPDetailUrlModel *model = _imgUrls[indexPath.item];
        if ((model.type == 4 || model.type == 5) && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.spreadUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.spreadUrl]];
        } else if (model.type == 6) {
            if (self.popUrlAction) {
                self.popUrlAction(model.spreadUrl);
            }
        }
    }
    
    
}


@end


@interface PPPhotoCell ()
{
    UIImageView *_imgV;
}
@end


@implementation PPPhotoCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

@end


