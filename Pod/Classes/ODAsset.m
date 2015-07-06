//
//  ODAsset.m
//  askq
//
//  Created by Kenji Pa on 19/1/15.
//  Copyright (c) 2015 Rocky Chan. All rights reserved.
//

#import "ODAsset.h"

@interface ODAsset ()

- (instancetype)initWithName:(NSString *)name url:(NSURL *)url NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(NSString *)name fileURL:(NSURL *)fileURL;
- (instancetype)initWithName:(NSString *)name data:(NSData *)data;
- (instancetype)initWithFileURL:(NSURL *)fileURL;
- (instancetype)initWithData:(NSData *)data;

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSNumber *fileSize;

@end

@implementation ODAsset

- (instancetype)initWithName:(NSString *)name url:(NSURL *)url
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _url = [url copy];

        // derive fileSize
        // mainly used in ODUploadAssetOperation
        if (_url.isFileURL) {
            NSNumber *fileSize;
            NSError *error;
            [_url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:&error];
            if (error) {
                NSLog(@"Failed obtain file size in %@: %@", _url, error);
            }
            _fileSize = fileSize;
        }
    }
    return self;

}

- (instancetype)initWithName:(NSString *)name fileURL:(NSURL *)fileURL
{
    return [self initWithName:name url:fileURL];
}

- (instancetype)initWithName:(NSString *)name data:(NSData *)data
{
    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    [data writeToURL:fileURL atomically:NO];

    return [self initWithName:name fileURL:fileURL];

}

- (instancetype)initWithFileURL:(NSURL *)fileURL
{
    return [self initWithName:fileURL.lastPathComponent fileURL:fileURL];
}

- (instancetype)initWithData:(NSData *)data
{
    return [self initWithName:[[NSProcessInfo processInfo] globallyUniqueString] data:data];
}

+ (instancetype)assetWithName:(NSString *)name url:(NSURL *)url
{
    return [[self alloc] initWithName:name url:url];
}

+ (instancetype)assetWithName:(NSString *)name fileURL:(NSURL *)fileURL
{
    return [[self alloc] initWithName:name fileURL:fileURL];
}

+ (instancetype)assetWithName:(NSString *)name data:(NSData *)data
{
    return [[self alloc] initWithName:name data:data];
}

+ (instancetype)assetWithFileURL:(NSURL *)fileURL
{
    return [[self alloc] initWithFileURL:fileURL];
}

+ (instancetype)assetWithData:(NSData *)data
{
    return [[self alloc] initWithData:data];
}

@end
