//
//  MKBXDAlarmEventDBDataModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/10/10.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventDBDataModel : NSObject

@property (nonatomic, copy)NSString *singleMainCount;

@property (nonatomic, copy)NSString *singleSubCount;

@property (nonatomic, copy)NSString *doubleMainCount;

@property (nonatomic, copy)NSString *doubleSubCount;

@property (nonatomic, copy)NSString *longMainCount;

@property (nonatomic, copy)NSString *longSubCount;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
