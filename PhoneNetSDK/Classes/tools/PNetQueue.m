//
//  PNetQueue.m
//  UNetAnalysisSDK
//
//  Created by mediaios on 2019/1/22.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "PNetQueue.h"

@interface PNetQueue()
+ (instancetype)shareInstance;

@property (nonatomic) dispatch_queue_t pingQueue;
@property (nonatomic) dispatch_queue_t quickPingQueue;
@property (nonatomic) dispatch_queue_t traceQueue;
@property (nonatomic) dispatch_queue_t asyncQueue;

@end

@implementation PNetQueue

+ (instancetype)shareInstance
{
    static PNetQueue *unetQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unetQueue = [[self alloc] init];
    });
    return unetQueue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _pingQueue = dispatch_queue_create("pnet_ping_queue", DISPATCH_QUEUE_SERIAL);
        _quickPingQueue = dispatch_queue_create("pnet_qping_queue", DISPATCH_QUEUE_SERIAL);
        _traceQueue = dispatch_queue_create("pnet_trace_queue", DISPATCH_QUEUE_SERIAL);
        _asyncQueue = dispatch_queue_create("Pnet_async_queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (void)pnet_ping_async:(dispatch_block_t)block
{
    dispatch_async([PNetQueue shareInstance].pingQueue, ^{
        block();
    });
}

+ (void)pnet_quick_ping_async:(dispatch_block_t)block
{
    dispatch_async([PNetQueue shareInstance].quickPingQueue, ^{
        block();
    });
}

+ (void)pnet_trace_async:(dispatch_block_t)block
{
    dispatch_async([PNetQueue shareInstance].traceQueue , ^{
        block();
    });
}

+ (void)pnet_async:(dispatch_block_t)block
{
    dispatch_async([PNetQueue shareInstance].asyncQueue, ^{
        block();
    });
}
@end
