//
//  MKBXDAlarmEventDataModel.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAlarmEventDataModel : NSObject

@property (nonatomic, copy)NSString *timestamp;

@property (nonatomic, copy)NSString *singleCount;

@property (nonatomic, copy)NSString *doubleCount;

@property (nonatomic, copy)NSString *longCount;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
