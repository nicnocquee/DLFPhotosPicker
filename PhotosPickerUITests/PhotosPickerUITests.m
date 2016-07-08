//
//  PhotosPickerUITests.m
//  PhotosPickerUITests
//
//  Created by Nico Prananta on 7/8/16.
//  Copyright © 2016 Delightful. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PhotosPickerUITests : XCTestCase

@end

@implementation PhotosPickerUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUI {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self addUIInterruptionMonitorWithDescription:@"“PhotosPicker” Would Like to Access Your Photos" handler:^BOOL(XCUIElement * _Nonnull interruptingElement) {
        [interruptingElement.buttons[@"OK"] tap];
        return YES;
    }];
    XCUIElement *pickPhotosButton = app.buttons[@"Pick Photos"];
    [pickPhotosButton tap];
    [app.collectionViews.cells[@"Image 1"] tap];
    [pickPhotosButton tap];
    [app.navigationBars[@"All Photos"].buttons[@"Albums"] tap];
    [app.tables.staticTexts[@"Camera Roll"] tap];
    [app.navigationBars[@"Camera Roll"].buttons[@"Albums"] tap];
    [app.navigationBars[@"Albums"].buttons[@"Cancel"] tap];
    
}

@end
