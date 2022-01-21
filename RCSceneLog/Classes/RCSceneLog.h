//
//  RCSceneLog.h
//  RCVoiceRoomLib
//
//  Created by xuefeng on 2022/1/10.
//

#import <Foundation/Foundation.h>

@class RCSceneLogEntity;

typedef NS_OPTIONS(NSUInteger, RCSceneLogFlag){
    RCSceneLogFlagError      = (1 << 0),
    RCSceneLogFlagWarning    = (1 << 1),
    RCSceneLogFlagInfo       = (1 << 2),
    RCSceneLogFlagDebug      = (1 << 3),
    RCSceneLogFlagVerbose    = (1 << 4)
};

typedef NS_ENUM(NSUInteger, RCSceneLogLevel){
    RCSceneLogLevelOff       = 0,
    RCSceneLogLevelError     = (RCSceneLogFlagError),
    RCSceneLogLevelWarning   = (RCSceneLogLevelError   | RCSceneLogFlagWarning),
    RCSceneLogLevelInfo      = (RCSceneLogLevelWarning | RCSceneLogFlagInfo),
    RCSceneLogLevelDebug     = (RCSceneLogLevelInfo    | RCSceneLogFlagDebug),
    RCSceneLogLevelVerbose   = (RCSceneLogLevelDebug   | RCSceneLogFlagVerbose),
    RCSceneLogLevelAll       = NSUIntegerMax
};

NS_ASSUME_NONNULL_BEGIN

@protocol RCSceneLogFormatter <NSObject>
- (nonnull NSString *)format:(RCSceneLogEntity *)entity;
@end

@protocol RCSceneLogger <NSObject>
@property (nonatomic, strong, nullable) id <RCSceneLogFormatter> logFormatter;
@property (nonatomic, assign) RCSceneLogFlag flag;
- (void)log:(RCSceneLogEntity *)entity;
@end

@interface RCSceneLog : NSObject

+ (void)addLogger:(id<RCSceneLogger>)logger;

+ (void)error:(NSString *)msg
         file:(const char *)file
         func:(const char *)func
         line:(NSInteger)line
       extend:(NSDictionary *)extend;
@end

NS_ASSUME_NONNULL_END
