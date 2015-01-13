//
//  DLFPhotosLibrary.h
//  PhotosPicker
//
//  Created by  on 1/13/15.
//  Copyright (c) 2015 Delightful. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

extern NSString *const DLFPhotosLibraryDidChangeNotification;
extern NSString *const DLFPhotosLibraryDidChangeNotificationChangeKey;

@interface DLFPhotosLibrary : NSObject <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHChange *changeInstance;

+ (instancetype)sharedLibrary;

- (void)startObserving;
- (void)stopObserving;

@end
