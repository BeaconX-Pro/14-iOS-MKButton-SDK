//
//  MKBXDAdopter.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDAdopter : NSObject

+ (BOOL)validTriggerChannelAdvParamsProtocol:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol;

+ (NSString *)parseTriggerChannelAdvParamsProtocol:(id <MKBXDTriggerChannelAdvParamsProtocol>)protocol;

+ (BOOL)validChannelTriggerParamsProtocol:(id <MKBXDChannelTriggerParamsProtocol>)protocol;

+ (NSString *)parseChannelTriggerParamsProtocol:(id <MKBXDChannelTriggerParamsProtocol>)protocol;

+ (NSString *)fetchTxPower:(mk_bxd_txPower)txPower;

+ (NSString *)fetchTxPowerValueString:(NSString *)content;

+ (NSString *)fetchReminderTypeString:(mk_bxd_reminderType)type;

+ (NSString *)fetchThreeAxisDataRate:(mk_bxd_threeAxisDataRate)dataRate;

+ (NSString *)fetchThreeAxisDataAG:(mk_bxd_threeAxisDataAG)ag;

+ (NSDictionary *)parseChannelContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
