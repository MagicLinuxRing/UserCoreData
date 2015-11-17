//
//  FriendListTableViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/9/16.
//  Copyright (c) 2015年 kingJ. All rights reserved.
//

#import "JZUserDetailTableViewController.h"
#import "FriendListTableViewController.h"
#import "FriendListTableViewCell.h"
#import "PlayerStoreManager.h"
#import <CoreData/CoreData.h>

@interface FriendListTableViewController ()<FriendRelationShipDelegate,NSFetchedResultsControllerDelegate>
{
    NSMutableArray *_friendListArray;
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@end

@implementation FriendListTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"好友列表";
    [self createNavBar];
    
    _friendListArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _friendListArray = [NSMutableArray arrayWithArray:[self.fetchedResultsController fetchedObjects]];
    [self.tableView reloadData];
}

- (void)createNavBar
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"ADD" style:UIBarButtonItemStyleDone target:self action:@selector(navBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)navBarButtonClick:(UIBarButtonItem *)barButtonItem
{
    PlayerStoreManager *playerManager = [PlayerStoreManager shareInstance];
    NSManagedObjectContext *privateContext = playerManager.privateObjectContext;
    NSMutableDictionary *playerInfo = [NSMutableDictionary dictionaryWithCapacity:7];
    playerInfo[@"playerID"] = [[NSDate date] description];
    playerInfo[@"playerAge"] = @"20";
    playerInfo[@"playerDescription"] = @"handsome boy,kingjack";
    playerInfo[@"playerName"] = @"kingjack";
    playerInfo[@"playerNickName"] = @"lovely boy";
    playerInfo[@"playerSex"] = @"male";
    playerInfo[@"playerAvatar"] = @"user";
    [playerManager insertObjectWithPlayerMoudle:playerInfo objectContext:privateContext];
    [playerManager saveWithObjectContext:privateContext];
}

#pragma mark -
#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[PlayerStoreManager shareInstance] fetchAllNode];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[PlayerStoreManager shareInstance].mainObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"friendListCell";
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[FriendListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    [cell setFriendDetail:_friendListArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //好友详情页面
    
    [self pushToDetailView:_friendListArray[indexPath.row]];
}

- (void)pushToDetailView:(PlayerMoudle *)playerMoudle
{
    JZUserDetailTableViewController *userDetailView = [[JZUserDetailTableViewController  alloc] initWithStyle:UITableViewStylePlain];
    userDetailView.playerMoudle = playerMoudle;
    [self.navigationController pushViewController:userDetailView animated:YES];
}

#pragma mark - cell delegate

- (void)removeRelationShipWithInfo:(NSString *)friendID
{
    [[PlayerStoreManager shareInstance] deleteEntityWithPlayerID:friendID objectContext:[PlayerStoreManager shareInstance].mainObjectContext];
    [[PlayerStoreManager shareInstance] save];
}

#pragma mark - NSFetchResultControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [_friendListArray addObject:anObject];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [_friendListArray removeObject:anObject];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationBottom];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
