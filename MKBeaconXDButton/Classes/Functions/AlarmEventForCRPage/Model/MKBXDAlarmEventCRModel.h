//
//  MKBXDAlarmEventCRModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/3/19.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventCRModel : NSObject

@property (nonatomic, copy)NSString *timestamp;

@property (nonatomic, copy)NSString *singleCount;

@property (nonatomic, copy)NSString *doubleCount;

@property (nonatomic, copy)NSString *longCount;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
