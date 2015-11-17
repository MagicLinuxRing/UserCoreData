//
//  JZUserDetailTableViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/9/23.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZUserDetailTableViewController.h"
#import "JZUserDescriptionViewController.h"
#import "JZSexChooseTableViewController.h"
#import "ModifyUserInfoViewController.h"
#import "UserDetailTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+Resize.h"
#import "JZQRCodeViewController.h"
#import "PlayerStoreManager.h"
#import "AppDelegate.h"
#import "PlayerMoudle.h"
#import "JZFileManager.h"
//#import "JZAudioQueueViewController.h"
#import "JZAudioRecorderViewController.h"
#import "ScapViewController.h"

@interface JZUserDetailTableViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,UserDetailClickDelegate,ModifySexDelegate,ModifySignatureDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray  *_userInfoArray;
    UIImagePickerController *_imagePicker;
}

@property(nonatomic,retain)UIImagePickerController *imagePicker;

@end

@implementation JZUserDetailTableViewController
@synthesize imagePicker = _imagePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"个人中心";
    
    [self createDataArray];
}

- (void)createDataArray
{
    _userInfoArray = [[NSArray alloc] init];
    _userInfoArray = @[@"头像",@"昵称",@"账户",@"二维码名片",@"性别",@"地区",@"个性签名"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return 70.0;
    }
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userDetailIdentifier = @"userDetailCell";
    
    UserDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userDetailIdentifier];
    if (!cell)
    {
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            cell = [[AVatarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:userDetailIdentifier];
            
        }
        else
        {
            cell = [[UserDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:userDetailIdentifier];
        }
    }
    cell.clickDetailDelegate = self;
    
    cell.playerMoudle = self.playerMoudle;
    
    [cell setUserInfowithindexPath:indexPath];
    
    if (indexPath.row == 2 && indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self clickDetailWithIndex:indexPath.row + indexPath.section * 4];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENFRAME_SIZE_WIDTH, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        lineLabel.alpha = 0.5;
        return lineLabel;
    }
}

 - (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - showAvatar delegate

- (void)clickDetailWithIndex:(CELL_TAG)tag
{
    switch (tag) {
        case AVATAR:
            [self createPhotoChooseView];
            break;
        case NICKNAME:
                [self modifyUserName];
            break;
        case QRCODE:
                [self showQRCodeView];
            break;
        case SEX:
                [self chooseSexView];
            break;
        case POSITION:
                [self pushToAudioView];
            break;
        case SIGNITURE:
                [self userSignatureView];
            break;
            
        default:
            break;
    }
}

- (void)pushToAudioView
{
//    JZAudioQueueViewController *audioView = [[JZAudioQueueViewController alloc] init];
//    [self.navigationController pushViewController:audioView animated:YES];
//    JZAudioRecorderViewController *audioView = [[JZAudioRecorderViewController alloc] init];
//    [self.navigationController pushViewController:audioView animated:YES];
    
    ScapViewController *scaptureView = [[ScapViewController alloc] init];
    [self.navigationController pushViewController:scaptureView animated:YES];
}

- (void)createPhotoChooseView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self cameraButtonDidClicked];
            break;
        case 1:
            [self localPhoto];
            break;
            
        default:
            break;
    }
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker) {
        return _imagePicker;
    }

    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    return _imagePicker;
}

- (void)localPhoto
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:self.imagePicker animated:YES completion:^{
    }];
}

//相机
- (void)cameraButtonDidClicked
{
    NSString *cameraType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:cameraType];
    if (authStatus == ALAuthorizationStatusNotDetermined)
    {
        //没有相机
    }
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        //禁止访问相机
        [[[UIAlertView alloc] initWithTitle:@"需要访问相机" message:[NSString stringWithFormat:@"要直播视频，需要有权访问你的设备上的相机。点击你设备的设置按钮，然后会启用相机选项"] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"设置", nil] show];
        return;
    }
    else
    {
        [self openCamaro];
    }
}

- (void)openCamaro
{
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ||
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSData *imageData;
    //当选择的类型是图片
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *newImg = [image resizedImage:CGSizeMake(220, 220) interpolationQuality:kCGInterpolationDefault];
    imageData = UIImageJPEGRepresentation(newImg, 0.8);
    NSString *timeSubFix = [[[NSDate date] description] stringByAppendingFormat:@".png"];
    NSString *filePath = [[[JZFileManager shareInstance] currentUserFileFullPath] stringByAppendingPathComponent:timeSubFix];
    [imageData writeToFile:filePath atomically:YES];
    
    self.playerMoudle.playerAvatar = [filePath lastPathComponent];
    
    [[PlayerStoreManager shareInstance] modifyEntityWithPlayer:self.playerMoudle
                                                       context:[PlayerStoreManager shareInstance].privateObjectContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        //TODO::update avatar
        
    }];
}

- (void)updateUserAvatarWithData:(NSData *)imageData
{
    self.playerMoudle.playerAvatar = nil;
}

- (void)modifyUserName
{
    ModifyUserInfoViewController *modifyView = [[ModifyUserInfoViewController alloc] init];
    modifyView.playerMoudle = self.playerMoudle;
    [self.navigationController pushViewController:modifyView animated:YES];
}

- (void)showQRCodeView
{
    JZQRCodeViewController *qrCodeView = [[JZQRCodeViewController alloc] init];
    qrCodeView.playerMoudle = self.playerMoudle;
    [self.navigationController pushViewController:qrCodeView animated:YES];
}

- (void)userSignatureView
{
    JZUserDescriptionViewController *userDescriptionView = [[JZUserDescriptionViewController alloc] init];
    userDescriptionView.delegate = self;
    userDescriptionView.playerDescription = self.playerMoudle.playerDescription;
    [self.navigationController pushViewController:userDescriptionView animated:YES];
}

- (void)chooseSexView
{
    JZSexChooseTableViewController *sexChooseView = [[JZSexChooseTableViewController alloc] init];
    sexChooseView.delegate = self;
    sexChooseView.sex = self.playerMoudle.playerSex;
    [self.navigationController pushViewController:sexChooseView animated:YES];
}

- (void)modifySexWithIndex:(NSInteger)indexRow
{
    if (indexRow)
    {
        self.playerMoudle.playerSex = @"female";
    }
    else
    {
        self.playerMoudle.playerSex = @"male";
    }
    
    [[PlayerStoreManager shareInstance] modifyEntityWithPlayer:self.playerMoudle
                                                       context:[PlayerStoreManager shareInstance].privateObjectContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)modifySignatureWithText:(NSString *)signature
{
    if (signature.length == 0 || [self.playerMoudle.playerDescription isEqualToString:signature]) return;
    self.playerMoudle.playerDescription = signature;
    
    [[PlayerStoreManager shareInstance] modifyEntityWithPlayer:self.playerMoudle
                                                       context:[PlayerStoreManager shareInstance].privateObjectContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end











