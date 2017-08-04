/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import UIKit;
#import "RCTOpenTokPublisherView.h"
#import "RCTOpenTokSharedInfo.h"

@implementation RCTOpenTokPublisherView

- (void)didMoveToWindow {
  [super didMoveToSuperview];
  
  if (self.window) {
    [self initPublisherView];
  } else {
    [self deinitPublisherView];
  }
}

- (void)initPublisherView {
  NSLog(@"RCTOpenTokSubscriberView.initPublisherView");
  if (!self.initialized) {
    RCTOpenTokSharedInfo *sharedInfo = [RCTOpenTokSharedInfo sharedInstance];
    if (sharedInfo.outgoingVideoPublisher) {
      [sharedInfo.outgoingVideoPublisher.view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
      [self addSubview:sharedInfo.outgoingVideoPublisher.view];
      self.initialized = true;
      NSLog(@"RCTOpenTokSubscriberView.initPublisherView initialized");
    } else {
      NSLog(@"RCTOpenTokSubscriberView.initPublisherView no subscriber");
    }
  } else {
    NSLog(@"RCTOpenTokSubscriberView.initPublisherView already initialized");
  }
}

- (void)deinitPublisherView {
  NSLog(@"RCTOpenTokSubscriberView.deinitPublisherView");
  if (self.initialized) {
    RCTOpenTokSharedInfo *sharedInfo = [RCTOpenTokSharedInfo sharedInstance];
    if (sharedInfo.outgoingVideoPublisher) {
      [sharedInfo.outgoingVideoPublisher.view removeFromSuperview];
      self.initialized = false;
    } else {
      NSLog(@"RCTOpenTokSubscriberView.deinitPublisherView no subscriber");
    }
  } else {
    NSLog(@"RCTOpenTokSubscriberView.deinitPublisherView already deinitialized");
  }
  
}

- (void)dealloc {
  [self deinitPublisherView];
}

@end
