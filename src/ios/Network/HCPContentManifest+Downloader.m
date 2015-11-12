//
//  HCPContentManifest+Downloader.m
//
//  Created by Nikolay Demyankov on 10.08.15.
//

#import "HCPContentManifest+Downloader.h"
#import "HCPJsonDownloader.h"

@implementation HCPContentManifest (Downloader)

+ (void)downloadFromURL:(NSURL *)url withComplitionBlock:(HCPContentManifestDownloadComplitionBlock)block {
    if (block == nil) {
        return;
    }

    HCPJsonDownloader *jsonDownloader = [[HCPJsonDownloader alloc] initWithUrl:url accessToken:nil];
    [jsonDownloader downloadWithComplitionBlock:^(NSError *error, id json) {
        HCPContentManifest *manifest = nil;
        if (error == nil) {
            manifest = [HCPContentManifest instanceFromJsonObject:json];
        }

        block(error, manifest);
    }];
}

+ (HCPContentManifest *)downloadSyncFromURL:(NSURL *)url error:(NSError **)error {
    HCPJsonDownloader *jsonDownloader = [[HCPJsonDownloader alloc] initWithUrl:url accessToken:nil];
    id json = [jsonDownloader downloadSync:error];

    return [HCPContentManifest instanceFromJsonObject:json];
}

@end
