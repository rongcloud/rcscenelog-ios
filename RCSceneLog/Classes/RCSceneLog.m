//
//  RCSceneLog.m
//  RCVoiceRoomLib
//
//  Created by xuefeng on 2022/1/10.
//

#import "RCSceneLog.h"
#import "RCSceneLogEntity.h"

@interface RCSceneLog ()
@property (nonatomic, strong) NSMutableArray<id<RCSceneLogger>> *loggers;
@property (nonatomic, strong, class) dispatch_queue_t queue;
@property (nonatomic, strong, class) dispatch_group_t group;
//临时派发队列 TODO
@property (nonatomic, strong, class) dispatch_queue_t disQueue;
@end

@implementation RCSceneLog

+ (instancetype)shareInstance {
    static RCSceneLog *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCSceneLog alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.loggers = [NSMutableArray new];
    }
    return self;
}

+ (void)addLogger:(id<RCSceneLogger>)logger {
    if (logger == nil) {
        NSLog(@"add logger must be nonnull");
        return;
    }
    @synchronized (self) {
        [[[self shareInstance] loggers] addObject:logger];
    }
}

+ (void)error:(nullable NSString *)msg
         file:(const char *)file
         func:(const char *)func
         line:(NSInteger)line
       extend:(nullable NSDictionary *)extend {
    [[self shareInstance] log:msg file:file func:func line:line level:RCSceneLogLevelError extend:extend];
}

- (void)log:(nullable NSString *)msg
       file:(const char *)file
       func:(const char *)func
       line:(NSInteger)line
      level:(RCSceneLogLevel)level
     extend:(nullable NSDictionary *)extend  {
    if (msg == nil || msg.length == 0) {
        NSLog(@"log msg is nil");
    }
    if (self.loggers.count == 0) {
        NSLog(@"no logger");
        return;
    }
    @autoreleasepool {
        RCSceneLogEntity *entity = [[RCSceneLogEntity alloc] initWithMsg:msg
                                                         line:[@(line) stringValue]
                                                         file:[NSString stringWithFormat:@"%s",file]
                                                         func:[NSString stringWithFormat:@"%s",func]
                                                        logLevel:level
                                                       extend:extend];
        dispatch_async(RCSceneLog.disQueue, ^{
            [self logWithEntity:entity];
        });
    }
}

- (void)logWithEntity:(RCSceneLogEntity *)entity {
    for (id <RCSceneLogger> logger in self.loggers) {
        if (!(logger.flag & entity.logLevel)) {
            continue;
        }
        dispatch_group_async(RCSceneLog.group, RCSceneLog.queue, ^{
            [logger log:entity];
        });
    }
    dispatch_group_wait(RCSceneLog.group, DISPATCH_TIME_FOREVER);
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t kQueue;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        kQueue = dispatch_queue_create("RCSceneLog.Queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return kQueue;
}
+ (void)setQueue:(dispatch_queue_t)queue {}

+ (dispatch_group_t)group {
    static dispatch_group_t kGroup;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        kGroup = dispatch_group_create();
    });
    return kGroup;
}
+ (void)setGroup:(dispatch_group_t)group {}

+ (dispatch_queue_t)disQueue {
    static dispatch_queue_t kDisQueue;
    static dispatch_once_t onceToken3;
    dispatch_once(&onceToken3, ^{
        kDisQueue = dispatch_queue_create("RCSceneLog.DisQueue", DISPATCH_QUEUE_SERIAL);
    });
    return kDisQueue;
}
+ (void)setDisQueue:(dispatch_queue_t)disQueue {}
@end
