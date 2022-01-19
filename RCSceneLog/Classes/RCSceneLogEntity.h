//
//  RCSceneLogEntity.h
//  RCVoiceRoomLib
//
//  Created by xuefeng on 2022/1/10.
//

#import <Foundation/Foundation.h>
#import "RCSceneLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSceneLogEntity : NSObject
//消息主题
@property (nonatomic, copy, nullable, readonly) NSString *msg;
//行数
@property (nonatomic, copy, nullable, readonly) NSString *line;
//文件位置
@property (nonatomic, copy, nullable, readonly) NSString *file;
//调用的函数位置
@property (nonatomic, copy, nullable, readonly) NSString *func;
//时间
@property (nonatomic, copy, nullable, readonly) NSString *time;
//日志登记
@property (nonatomic, assign, readonly) RCSceneLogLevel logLevel;
//线程id
@property (nonatomic, copy, nullable, readonly) NSString *threadId;
//线程名称
@property (nonatomic, copy, nullable, readonly) NSString *threadName;
//队列名称
@property (nonatomic, copy, nullable, readonly) NSString *queueName;
//队列优先级
@property (nonatomic, assign, readonly) NSInteger qos;
//SDK版本
@property (nonatomic, copy, nullable, readonly) NSString *version;
//机型
@property (nonatomic, copy, nullable, readonly) NSString *model;
//操作系统版本
@property (nonatomic, copy, nullable, readonly) NSString *os;
//业务扩展字段
@property (nonatomic, copy, nullable) NSDictionary *extend;

/*-------------------------------------------------------------*/

@property (nonatomic, copy, nullable, class) NSString *version;

- (instancetype)initWithMsg:(nullable NSString *)msg
                       line:(nullable NSString *)line
                       file:(nullable NSString *)file
                       func:(nullable NSString *)func
                   logLevel:(RCSceneLogLevel)logLevel
                     extend:(nullable NSDictionary *)extend;
@end

NS_ASSUME_NONNULL_END
