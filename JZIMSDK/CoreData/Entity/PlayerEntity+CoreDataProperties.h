//
//  PlayerEntity+CoreDataProperties.h
//  JZIMSDK
//
//  Created by king jack on 15/9/28.
//  Copyright © 2015年 kingJ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlayerEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) NSNumber *playerAge;
@property (nullable, nonatomic, retain) NSString *playerAvatar;
@property (nullable, nonatomic, retain) NSString *playerDescription;
@property (nullable, nonatomic, retain) NSString *playerID;
@property (nullable, nonatomic, retain) NSString *playerName;
@property (nullable, nonatomic, retain) NSString *playerNickName;
@property (nullable, nonatomic, retain) NSString *playerSex;

@end

NS_ASSUME_NONNULL_END
