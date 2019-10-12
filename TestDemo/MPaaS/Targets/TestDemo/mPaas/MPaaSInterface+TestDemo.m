//
//  MPaaSInterface+TestDemo.m
//  TestDemo
//
//  Created by gaochongyang on 2019/10/12.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "MPaaSInterface+TestDemo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation MPaaSInterface (TestDemo)

- (BOOL)enableSettingService
{
    return NO;
}

- (NSString *)userId
{
    return nil;
}

@end

#pragma clang diagnostic pop
