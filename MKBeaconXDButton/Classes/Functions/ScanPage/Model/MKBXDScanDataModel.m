//
//  MKBXDScanDataModel.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDScanDataModel.h"

@implementation MKBXDScanDataModel

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
