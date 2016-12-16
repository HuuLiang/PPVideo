//
//  PPDetailViewController.m
//  PPVideo
//
//  Created by Liang on 2016/10/18.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPDetailViewController.h"
#import "PPDetailModel.h"

#import "PPDetailHeaderCell.h"
#import "PPDetailFuncCell.h"
#import "PPCommentModel.h"
#import "PPDetailPhotoCell.h"
#import "PPDetailCommentCell.h"
#import "PPDetailMoreCell.h"
#import "PPDetailReportView.h"

#import "PPAdPopView.h"

@interface PPDetailViewController ()
{
    QBBaseModel *_baseModel;
    PPProgramModel *_programModel;
    NSInteger _columnId;
    
    PPDetailHeaderCell *_headerCell;
    PPDetailFuncCell   *_funcCell;
    PPDetailPhotoCell  *_photoCell;
    NSInteger currentSection;
    PPDetailMoreCell   *_moreCell;
    PPDetailReportView *_reportView;
}
@property (nonatomic) PPDetailModel *detailModel;
@property (nonatomic) PPDetailResponse *response;
@property (nonatomic) PPAdPopView *adPopView;
@end

@implementation PPDetailViewController
QBDefineLazyPropertyInitialization(PPDetailModel ,detailModel)
QBDefineLazyPropertyInitialization(PPDetailResponse, response)

- (instancetype)initWithBaseModelInfo:(QBBaseModel *)baseModel
                             ColumnId:(NSInteger)columnId
                          programInfo:(PPProgramModel *)programModel
{
    if (self = [super init]) {
        _baseModel = baseModel;
        _columnId = columnId;
        _programModel = programModel;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    _reportView = [[PPDetailReportView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kWidth(88) - 64, kScreenWidth, kWidth(88))];
    [self.view addSubview:_reportView];
    
    self.layoutTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - ([PPUtil isIpad] ? kWidth(130) : kWidth(200)));
    
    @weakify(self);
    _reportView.endEditing = ^(NSString *text) {
        @strongify(self);
        if (text.length < 2) {
            [[PPHudManager manager] showHudWithText:@"输入的评论过短"];
        } else {
            if ([PPUtil currentVipLevel] == PPVipLevelNone) {
                [self presentPayViewControllerWithBaseModel:self->_baseModel];
            } else {
                [[PPHudManager manager] showHudWithText:@"审核中..."];
                self->_reportView.textField.text = @"";
                [self->_reportView.textField resignFirstResponder];
            }
        }
    };
    
//    {
//        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.bottom.equalTo(self.view);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(68));
//        }];
//    }
    
    [self.layoutTableView PP_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    
    
    if ([PPCacheModel getDetailCacheWithProgramId:[_baseModel.programId integerValue]]) {
        self.response = [PPCacheModel getDetailCacheWithProgramId:[_baseModel.programId integerValue]];
        [self initCells];
    }
    
    [self.layoutTableView PP_triggerPullToRefresh];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if ([self->_reportView.textField isFirstResponder]) {
            [self->_reportView.textField resignFirstResponder];
        }
        if (cell == self->_headerCell) {
            [self playVideoWithUrl:self.response.program baseModel:self->_baseModel vipLevel:NSNotFound hasTomeControl:self->_programModel.hasTimeControl];
        }
    };
    
    _adPopView = [[PPAdPopView alloc] initWithSuperView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotificationInDetailVC:) name:kPaidNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

- (void)onPaidNotificationInDetailVC:(NSNotification *)notification {
    [self.layoutTableView PP_triggerPullToRefresh];
}

- (void)loadData {
    @weakify(self);
    [self.detailModel fetchDetailInfoWithColumnId:[NSNumber numberWithInteger:_columnId] ProgramId:_baseModel.programId CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self.layoutTableView PP_endPullToRefresh];
        if (success) {
            self.response = obj;
            [self initCells];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    [self initFunctionCellInSection:section++];
    if (self.response.programUrlList.count > 0) {
        [self initPhotosInSection:section++];
    }
    if (self.response.commentJson.count > 0) {
        [self initCommentsInSection:section++];
    }
    if ([PPUtil currentVipLevel] == PPVipLevelNone) {
        [self initMoreCommentInSection:currentSection];
    }
    
    
    [self.layoutTableView reloadData];
}

- (void)initHeaderCellInSection:(NSInteger)section {
    _headerCell = [[PPDetailHeaderCell alloc] init];
    _headerCell.imgUrlStr = self.response.program.detailsCoverImg;
    NSArray *array = [self.response.program.spare componentsSeparatedByString:@"|"];
    if (array.count > 0) {
        _headerCell.playCount = [array firstObject];
    }
    [self setLayoutCell:_headerCell cellHeight:kScreenWidth * 0.6 inRow:0 andSection:section];
}

- (void)initFunctionCellInSection:(NSInteger)section {
    _funcCell = [[PPDetailFuncCell alloc] init];
    PPCommentModel *comment = [PPCommentModel getCommentInfoWithProgramId:self.response.program.programId];
    _funcCell.likeCount = comment.likeCount;
    _funcCell.hateCount = comment.hateCount;
    _funcCell.isChanged = comment.isChanged;
    @weakify(self);
    _funcCell.likeAction = ^(NSNumber * isChanged) {
        @strongify(self);
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            [[PPHudManager manager] showHudWithText:@"成为会员可👍/👎"];
            return ;
        }
        if ([isChanged boolValue]) {
            [[PPHudManager manager] showHudWithText:@"您已经👍/👎过了"];
        } else {
            self->_funcCell.isChanged = YES;
            comment.isChanged = YES;
            self->_funcCell.likeCount = ++comment.likeCount;
            [comment saveOrUpdate];
        }
    };
    
    _funcCell.hateAction = ^(NSNumber * isChanged) {
        @strongify(self);
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            [[PPHudManager manager] showHudWithText:@"成为会员可👎/👍"];
            return ;
        }
        if ([isChanged boolValue]) {
            [[PPHudManager manager] showHudWithText:@"您已经👎/👍过了"];
        } else {
            self->_funcCell.isChanged = YES;
            comment.isChanged = YES;
            self->_funcCell.hateCount = ++comment.hateCount;
            [comment saveOrUpdate];
        }
    };
    
    _funcCell.upAction = ^(id sender) {
        @strongify(self);
        [self presentPayViewControllerWithBaseModel:self->_baseModel];
    };
    
    [self setLayoutCell:_funcCell cellHeight:kWidth(94) inRow:0 andSection:section];
}

- (void)initPhotosInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(1) inSection:section];
    
    _photoCell = [[PPDetailPhotoCell alloc] init];
    _photoCell.imgUrls = self.response.programUrlList;
    @weakify(self);
    _photoCell.popUrlAction = ^(NSString *popUrl) {
        @strongify(self);
//        self.adPopView.codeImgUrlStr = popUrl;
        if (self.adPopView.isHidden) {
            self.adPopView.codeImgUrlStr = popUrl;
            self.adPopView.hidden = NO;
        }
    };
    [self setLayoutCell:_photoCell cellHeight:PPDetalCellHeight inRow:0 andSection:section];
}

- (void)initCommentsInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    UITableViewCell *shadowCell = [[UITableViewCell alloc] init];
    shadowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    shadowCell.accessoryType = UITableViewCellAccessoryNone;
    shadowCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  热门评论";
    label.font = [UIFont systemFontOfSize:[PPUtil isIpad] ? 34 : kWidth(34)];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [shadowCell addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shadowCell);
        }];
    }
    
    [self setLayoutCell:shadowCell cellHeight:kWidth(88) inRow:0 andSection:section++];
    
    
    [self.response.commentJson enumerateObjectsUsingBlock:^(PPDetailCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setHeaderHeight:kWidth(1) inSection:section];
        PPDetailCommentCell *commentCell = [[PPDetailCommentCell alloc] init];
        commentCell.userImgUrlStr = obj.icon;
        commentCell.timeStr = obj.createAt;
        commentCell.userNameStr = obj.userName;
        commentCell.commandAttriStr = [obj.content getAttriStringWithFont:[UIFont systemFontOfSize:[PPUtil isIpad] ? 30: kWidth(32)] lineSpace:kWidth(10) maxSize:CGSizeMake(kWidth(640), MAXFLOAT)];
        CGFloat cellheith = [obj.content getStringHeightWithFont:[UIFont systemFontOfSize:[PPUtil isIpad] ? 30: kWidth(32)] lineSpace:kWidth(10) maxSize:CGSizeMake(kWidth(640), MAXFLOAT)] + kWidth(150);
        currentSection = section + idx;
        [self setLayoutCell:commentCell cellHeight:cellheith inRow:0 andSection:section+idx];
    }];
}

- (void)initMoreCommentInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(1) inSection:section];
    
    _moreCell = [[PPDetailMoreCell alloc] init];
    @weakify(self);
    _moreCell.moreAction = ^ (id sender) {
        @strongify(self);
        if ([PPUtil currentVipLevel] == PPVipLevelNone) {
            [self presentPayViewControllerWithBaseModel:self->_baseModel];
        } else {
            [[PPHudManager manager] showHudWithText:@"已全部加载完成"];
        }
    };
    
    
    [self setLayoutCell:_moreCell cellHeight:kWidth(80) inRow:0 andSection:section];
}



@end
