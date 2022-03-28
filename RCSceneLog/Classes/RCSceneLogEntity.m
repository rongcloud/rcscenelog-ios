//
//  RCSceneLogEntity.m
//  RCVoiceRoomLib
//
//  Created by xuefeng on 2022/1/10.
//

#import "RCSceneLogEntity.h"
#import <pthread.h>
#import <sys/qos.h>

@interface RCSceneLogEntity ()
@property (nonatomic, copy, nullable, class) NSString *version;
@property (nonatomic, copy, nullable, class) NSString *model;
@property (nonatomic, copy, nullable, class) NSString *os;
@end

@implementation RCSceneLogEntity

- (instancetype)initWithMsg:(NSString *)msg
                       line:(NSString *)line
                       file:(NSString *)file
                       func:(NSString *)func
                   logLevel:(RCSceneLogLevel)logLevel
                     extend:(NSDictionary *)extend {
    if (self = [super init]) {
        _msg = msg;
        _line = line;
        _file = file;
        _func = func;
        _logLevel = logLevel;
        _extend = extend;
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        NSInteger time = interval;
        _time = [NSString stringWithFormat:@"%ld",time];
        _version = RCSceneLogEntity.version ?: @"";
        _model = RCSceneLogEntity.model;
        _os = RCSceneLogEntity.os;
        
        __uint64_t tId;
        if (pthread_threadid_np(NULL, &tId) == 0) {
            _threadId = [[NSString alloc] initWithFormat:@"%llu", tId];
        } else {
            _threadId = @"missing threadId";
        }
        _threadName   = NSThread.currentThread.name;
        _qos = (NSUInteger) qos_class_self();
    }
    return self;
}

+ (NSString *)model {
    static NSString *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UIDevice currentDevice] model];
    });
    return model;
}

+ (void)setModel:(NSString *)model {}

+ (NSString *)os {
    static NSString *os;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        os = [[UIDevice currentDevice] systemVersion];
    });
    return os;
}

+ (void)setOs:(NSString *)os {}

static NSString *kVersion;

+ (void)setVersion:(NSString *)version {
    kVersion = version;
}

+ (NSString *)version {
    return kVersion;
}
@end
