//
//  HMACSignerTests.m
//  HMACSignerTests
//
//  Created by Martin Fernandez on 12/19/2014.
//  Copyright (c) 2014 Martin Fernandez. All rights reserved.
//

#import <HMACSigner/NSMutableURLRequest+HMACSigner.h>
#import <HMACSigner/NSDate+HTTP.h>
#import <HMACSigner/NSString+Crypto.h>

NSMutableURLRequest *buildRequest(NSString *url, NSString *contentType) {
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

  return request;
};


SPEC_BEGIN(HMACSignerSpec)


describe(@"HMACSigner", ^{

  __block NSMutableURLRequest *request;
  __block NSString *accessIdentifier;
  __block NSString *secret;


  beforeEach(^{
    request = buildRequest(@"http://example.com/", @"application/json");
    accessIdentifier = @"token";
    secret = @"secret";

    [request signWithAccessIdentifier:accessIdentifier andSecret:secret];
  });

  it(@"should contain the accessIdentifier", ^{
    [[request.allHTTPHeaderFields[@"Authorization"] should] containString:accessIdentifier];
  });

  it(@"should add an Authorization header", ^{
    [[request.allHTTPHeaderFields[@"Authorization"] shouldNot] beNil];
  });

  context(@"when date is not present", ^{

    it(@"should add a date header", ^{
      [[request.allHTTPHeaderFields[@"Date"] shouldNot] beNil];
    });
  });

  context(@"when date is present", ^{

    __block NSString *date;
    beforeEach(^{
      request = buildRequest(@"http://example.com/", @"application/json");
      date = [NSDate HTTPDateString];
      [request addValue:date forHTTPHeaderField:@"Date"];
      
    });

    it(@"should not change date header", ^{
      [[request.allHTTPHeaderFields[@"Date"] should] equal:date];
    });
  });

  context(@"when a valid request is provided", ^{

    context(@"when query paramters are not present", ^{

      beforeEach(^{
        request = buildRequest(@"http://example.com/", @"application/json");
        [request addValue:@"Tue, 24 Jun 2014 20:04:02 GMT" forHTTPHeaderField:@"Date"];
        [request signWithAccessIdentifier:accessIdentifier andSecret:secret];
      });

      it(@"generates correctly a valid HMAC Hash", ^{
        [[request.allHTTPHeaderFields[@"Authorization"] should] containString:@"0RrBpeUyRbW8Ot47flxJwdfKFK4="];
      });


    });

    context(@"when query paramters are present", ^{

      beforeEach(^{
        request = buildRequest(@"http://example.com/?per_page=10", @"application/json");
        [request addValue:@"Tue, 24 Jun 2014 20:04:02 GMT" forHTTPHeaderField:@"Date"];
        [request signWithAccessIdentifier:accessIdentifier andSecret:secret];
      });

      it(@"generates correctly a valid HMAC Hash", ^{
        [[request.allHTTPHeaderFields[@"Authorization"] should] containString:@"DAAR67Q4hzyxoR1ZyuthRaeb3RM="];
      });
    });
  });

  context(@"when calculating md5", ^{

    it(@"should calculate for empty body", ^{
      [[request.allHTTPHeaderFields[@"Content-MD5"] should] equal:[@"" base64MD5]];
    });

    it(@"should calculate for body with content", ^{
      request.HTTPMethod = @"POST";
      request.HTTPBody = [@"Test data" dataUsingEncoding:NSUTF8StringEncoding];

      [request signWithAccessIdentifier:accessIdentifier andSecret:secret];

      [[request.allHTTPHeaderFields[@"Content-MD5"] should] equal:[@"Test data" base64MD5]];
    });
  });
});

SPEC_END
