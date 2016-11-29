# HMACSigner

[![CI Status](http://img.shields.io/travis/bilby91/HMACSigner.svg?style=flat)](https://travis-ci.org/Martin Fernandez/HMACSigner)
[![Version](https://img.shields.io/cocoapods/v/HMACSigner.svg?style=flat)](http://cocoadocs.org/docsets/HMACSigner)
[![License](https://img.shields.io/cocoapods/l/HMACSigner.svg?style=flat)](http://cocoadocs.org/docsets/HMACSigner)
[![Platform](https://img.shields.io/cocoapods/p/HMACSigner.svg?style=flat)](http://cocoadocs.org/docsets/HMACSignerer)

## Usage

HMACSigner signs your requests using HMAC + SHA1. It was adesigned to work with [ApiAuth](https://github.com/mgomes/api_auth) gem.

Basically it does this

1. Calculates a canonical string like this 'HTTPMethod,Content-Type,MD5(Body),URI,HTTPDate'
2. Hashes the canonical string using the secret
3. Adds the 'Authorization' header with "APIAuth identifier:hashedString" 

To use it:

**Objective-C**
``` objc
  NSURL *url = [NSURL URLWithString:@"https://api.domain.com/users/me"];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"POST";
  request.HTTPBody = [@"Message" dataUsingEncoding:NSUTF8StringEncoding];
  [request setValue:@"application/text" forHTTPHeaderField:@"Content-Type"]; 

  [request signWithAccessIdentifier:@"userId" andSecret:@"secret"];
```

**Swift**
```swift
let request = NSMutableURLRequest( url: URL(string: "https://api.domain.com/users/me"))
request.httpMethod = "POST"
request.httpBody = "Message".data(using: .utf8)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.sign(withAccessIdentifier: "userId", andSecret: "secret")
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HMACSigner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "HMACSigner"

## Author

Martin Fernandez <fmartin91@gmail.com>

## License

HMACSigner is available under the MIT license. See the LICENSE file for more info.

