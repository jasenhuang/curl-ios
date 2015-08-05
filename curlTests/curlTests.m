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
static const char *urls[] = {
    "http://www.qq.com",
    "http://www.mail.qq.com",
};

static void init(CURLM *cm, int i)
{
    CURL *eh = curl_easy_init();
    curl_easy_setopt(eh, CURLOPT_HEADER, 0L);
    curl_easy_setopt(eh, CURLOPT_URL, urls[i]);
    curl_easy_setopt(eh, CURLOPT_PRIVATE, urls[i]);
    curl_easy_setopt(eh, CURLOPT_VERBOSE, 0L);
    
    curl_multi_add_handle(cm, eh);
}

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
    CURLM *cm;
    CURLMsg *msg;
    long L;
    unsigned int C=0;
    int M, Q, U = -1;
    fd_set R, W, E;
    struct timeval T;
    
    curl_global_init(CURL_GLOBAL_ALL);
    cm = curl_multi_init();
    
    for (C = 0; C < 1; ++C) {
        init(cm, C);
    }
    
    while (U) {
        curl_multi_perform(cm, &U);
        
        if (U) {
            FD_ZERO(&R);
            FD_ZERO(&W);
            FD_ZERO(&E);
            
            if (curl_multi_fdset(cm, &R, &W, &E, &M)) {
                fprintf(stderr, "E: curl_multi_fdset\n");
                return;
            }
            
            if (curl_multi_timeout(cm, &L)) {
                fprintf(stderr, "E: curl_multi_timeout\n");
                return;
            }
            if (L == -1)
                L = 100;
            
            if (M == -1) {
                sleep((int)L / 1000);
            } else {
                T.tv_sec = L/1000;
                T.tv_usec = (L%1000)*1000;
                
                if (0 > select(M+1, &R, &W, &E, &T)) {
                    fprintf(stderr, "E: select(%i,,,,%li): %i: %s\n",
                            M+1, L, errno, strerror(errno));
                    return;
                }
                while ((msg = curl_multi_info_read(cm, &Q))) {
                    if (msg->msg == CURLMSG_DONE) {
                        char *url;
                        CURL *e = msg->easy_handle;
                        curl_easy_getinfo(msg->easy_handle, CURLINFO_PRIVATE, &url);
                        fprintf(stderr, "R: %d - %s <%s>\n",msg->data.result, curl_easy_strerror(msg->data.result), url);
                        curl_multi_remove_handle(cm, e);
                        curl_easy_cleanup(e);
                    }
                    else {
                        fprintf(stderr, "E: CURLMsg (%d)\n", msg->msg);
                    }
                }
            }
        }
    }
    
    curl_multi_cleanup(cm);
    curl_global_cleanup();
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
