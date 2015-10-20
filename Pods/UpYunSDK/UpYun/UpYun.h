//
//  UpYun.h
//
//  Created by nickcheng on 14-6-20.
//  Copyright (c) 2014年 nickcheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPYUN_API_DOMAIN @"http://v0.api.upyun.com/"
#define UPYUN_ERROR_DOMAIN @"upyun.com"

typedef void (^UpYunCompletionBlock)(BOOL success, NSDictionary *result, NSError *error);
typedef void (^UpYunUploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface UpYun : NSObject 

@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, assign) NSTimeInterval expiresIn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *passcode;
@property (nonatomic, copy) UpYunUploadProgressBlock progressBlock;

- (id)initWithBucket:(NSString *)bucket andPassCode:(NSString *)passcode;

- (void)uploadFileWithPath:(NSString *)path
                completion:(UpYunCompletionBlock)completionBlock;
- (void)uploadFileWithPath:(NSString *)path
                useSaveKey:(NSString *)saveKey
                completion:(UpYunCompletionBlock)completionBlock;
- (void)uploadFileWithData:(NSData *)data
                useSaveKey:(NSString *)saveKey
                completion:(UpYunCompletionBlock)completionBlock;

@end

@interface NSString (Utilities)

- (NSString *)base64EncodedString;
- (NSString *)MD5Digest;
- (NSString *)stringByEscapingForURLQuery;

@end
