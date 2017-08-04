//
//  RCTOpenTokSharedInfo.m
//  KijkBijMij
//
//  Created by Harrie van der Lubbe on 04-08-17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RCTOpenTokSharedInfo.h"

@implementation RCTOpenTokSharedInfo

@synthesize session;
@synthesize latestIncomingVideoStream;
@synthesize incomingVideoSubscriber;
@synthesize outgoingVideoPublisher;
@synthesize outgoingVideoStream;

#pragma mark Singleton Methods

+ (id)sharedInstance {
  static RCTOpenTokSharedInfo *singleSharedInstance = nil;
  
//  if (singleSharedInstance == nil) {
//    singleSharedInstance = [[self alloc] init];
//  }
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    singleSharedInstance = [[self alloc] init];
  });
  return singleSharedInstance;
}

- (id)init {
  if (self = [super init]) {
    session = nil;
    latestIncomingVideoStream = nil;
    incomingVideoSubscriber = nil;
    outgoingVideoPublisher = nil;
    outgoingVideoStream = nil;
    
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

@end
