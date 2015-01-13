//
//  DLFPhotosLibrary.m
//  PhotosPicker
//
//  Created by  on 1/13/15.
//  Copyright (c) 2015 Delightful. All rights reserved.
//

#import "DLFPhotosLibrary.h"

NSString *const DLFPhotosLibraryDidChangeNotification = @"com.getdelightfulapp.DLFPhotosLibraryDidChangeNotification";
NSString *const DLFPhotosLibraryDidChangeNotificationChangeKey = @"com.getdelightfulapp.DLFPhotosLibraryDidChangeNotificationChangeKey";

@implementation DLFPhotosLibrary

+ (instancetype)sharedLibrary {
    static id _sharedLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLibrary = [[self alloc] init];
    });
    
    return _sharedLibrary;
}

- (void)startObserving {
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)stopObserving {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    self.changeInstance = changeInstance;
    [[NSNotificationCenter defaultCenter] postNotificationName:DLFPhotosLibraryDidChangeNotification object:nil userInfo:@{DLFPhotosLibraryDidChangeNotificationChangeKey: changeInstance}];
}

@end
