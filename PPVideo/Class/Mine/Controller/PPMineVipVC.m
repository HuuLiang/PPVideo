//
//  PPMineVipVC.m
//  PPVideo
//
//  Created by Liang on 2016/10/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "PPMineVipVC.h"
#import "PPMineVipHeaderCell.h"
#import "PPTableViewCell.h"
#import "PPVipIntroduceCell.h"
#import "PPNickNameCell.h"

#import <AssetsLibrary/AssetsLibrary.h>

//#define secondCellHeight tableViewCellheight+kWidth(442)

@interface PPMineVipVC () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PPMineVipHeaderCell *_headerCell;
    PPTableViewCell *_detailCell;
    PPVipIntroduceCell *_introduceCell;
    PPNickNameCell *_nickCell;
}
@end

@implementation PPMineVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasRowSeparator = NO;
//    [self.layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(20), 0, kWidth(20))];
//    [self.layoutTableView setSeparatorColor:[UIColor colorWithHexString:@"#efefef"]];
    
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_detailCell) {
            if ([self.layoutTableView numberOfRowsInSection:[self.layoutTableView indexPathForCell:self->_detailCell].section] == 2) {
                [self removeNickCell];
            } else {
                [self addNickCell];
            }
        }
    };
    
    [self initCells];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getImage {
    if ([PPUtil isIpad]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;

        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];

        [popover presentPopoverFromRect:CGRectMake(0, 0, kScreenWidth, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    [self initDetailCellInSection:section++];
    [self initRightIntroduceCellInSection:section++];
    
    [self.layoutTableView reloadData];
}

- (void)initHeaderCellInSection:(NSInteger)section {
    _headerCell = [[PPMineVipHeaderCell alloc] init];
    
    @weakify(self);
    _headerCell.uploadImg = ^(id obj) {
        @strongify(self);
        [self getImage];
    };
    
    [self setLayoutCell:_headerCell cellHeight:kWidth(402) inRow:0 andSection:section];
}

- (void)initDetailCellInSection:(NSUInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    NSString *str = [PPUtil getUserNickName];
    _detailCell = [[PPTableViewCell alloc] initWithImage:[UIImage imageNamed:@"mine_detail"] title:@"个人资料" subtitle:str.length > 0 ? str : @""];
    _detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_detailCell cellHeight:tableViewCellheight inRow:0 andSection:section];
}



- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    [self.layoutTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"%f",secondCellHeight);
    CGFloat offsetY = endFrame.origin.y - (tableViewCellheight+kWidth(442)) - 64;
    [self.layoutTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

- (void)addNickCell {
    NSIndexPath *indexPath = [self.layoutTableView indexPathForCell:self->_detailCell];
    
    if (!self->_nickCell) {
        _nickCell = [[PPNickNameCell alloc] init];
        _nickCell.nameField.delegate = self;
        _nickCell.nickName = [PPUtil getUserNickName].length > 0 ? [PPUtil getUserNickName] : @"";
        @weakify(self);
        _nickCell.nickAction = ^(NSString *nickStr) {
            @strongify(self);
            if (nickStr.length < 2) {
                [[PPHudManager manager] showHudWithText:@"昵称长度过短"];
            } else {
                [PPUtil setUserNickName:nickStr];
                [[PPHudManager manager] showHudWithText:@"修改完成"];
                self->_detailCell.subtitleLabel.text = nickStr;
                [self removeNickCell];
            }
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    [self insertNickCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
}

- (void)insertNickCellAtIndexPath:(NSIndexPath *)indexPath {
    [self setLayoutCell:_nickCell cellHeight:tableViewCellheight inRow:indexPath.row andSection:indexPath.section];
    [self.layoutTableView beginUpdates];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    [self.layoutTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    [self.layoutTableView endUpdates];
}

- (void)removeNickCell {
    NSIndexPath *indexPath = [self.layoutTableView indexPathForCell:self->_nickCell];
    [self removeCell:self->_nickCell inRow:indexPath.row andSection:indexPath.section];
    
    [self.layoutTableView beginUpdates];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    [self.layoutTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
    [self.layoutTableView endUpdates];
    
}

- (void)initRightIntroduceCellInSection:(NSInteger)section {
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    _introduceCell = [[PPVipIntroduceCell alloc] init];
    [self setLayoutCell:_introduceCell cellHeight:kWidth(276) inRow:0 andSection:section];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nickCell.nameField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.layoutTableView.scrollEnabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.layoutTableView.scrollEnabled = YES;
}

- (void)textFieldWillEndEditing:(UITextField *)textField {
    [_nickCell.nameField resignFirstResponder];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    @weakify(self);
    UIImage *pickedImage;
    if (picker.allowsEditing) {
        pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (pickedImage) {
        @strongify(self);
        if (self->_headerCell) {
            self->_headerCell.userImg = pickedImage;
            [PPUtil setUserImage:pickedImage];
        }
    } else {
        [[PPHudManager manager] showHudWithText:@"照片获取失败"];

    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
