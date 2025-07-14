//
//  MKBXDPeripheral.h
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBXDBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXDPeripheral : NSObject<MKBXDPeripheralProtocol>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
