//
//  HCPJsonDownloader.m
//
//  Created by Nikolay Demyankov on 11.08.15.
//

#import "HCPJsonDownloader.h"
#import "NSError+HCPExtension.h"

@implementation HCPJsonDownloader

- (instancetype)initWithUrl:(NSURL *)url accessToken:(NSString *)token {
    self = [super init];
    if (self) {
        _url = url;
        _token = token;
    }

    return self;
}

- (void)downloadWithComplitionBlock:(HCPJsonDownloadComplitionBlock)block {
    if (block == nil) {
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            block(connectionError, nil);
            return;
        }

        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        block(jsonError, jsonObject);
    }];
}

- (id)downloadSync:(NSError **)error {
    NSLog(@"Enable accessToken: %@", self.token);
    *error = nil;

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:self.token forHTTPHeaderField:@"Authorization"];
    request = [mutableRequest copy];
    NSHTTPURLResponse *response = nil;

    // NSData *data = [NSData dataWithContentsOfURL:self.url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (data == nil) {
        NSString *message = [NSString stringWithFormat:@"Failed to download config file from: %@", self.url];
        *error = [NSError errorWithCode:0 description:message];
        return nil;
    }

    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

@end
