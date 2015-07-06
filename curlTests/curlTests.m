//
//  curlTests.m
//  curlTests
//
//  Created by jasenhuang on 15/5/5.
//  Copyright (c) 2015年 jasenhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "curl.h"

@interface curlTests : XCTestCase

@end



@implementation curlTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    //XCTAssert(YES, @"Pass");
    CURL *handler = curl_easy_init();
    curl_easy_setopt(handler, CURLOPT_URL, "http://www.baidu.com");
    curl_easy_setopt(handler, CURLOPT_VERBOSE, 1L);
    curl_easy_perform(handler);
    curl_easy_cleanup(handler);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
