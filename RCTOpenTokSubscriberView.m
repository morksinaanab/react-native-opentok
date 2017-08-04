/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import UIKit;
#import "RCTOpenTokSubscriberView.h"
#import "RCTOpenTokSharedInfo.h"

@implementation RCTOpenTokSubscriberView

- (void)didMoveToWindow {
  [super didMoveToSuperview];
  
  if (self.window) {
    [self initSubscriberView];
  } else {
    [self deinitSubscriberView];
  }
}

- (void)initSubscriberView {
  NSLog(@"RCTOpenTokSubscriberView.initSubscriberView");
  if (!self.initialized) {
    RCTOpenTokSharedInfo *sharedInfo = [RCTOpenTokSharedInfo sharedInstance];
    if (sharedInfo.incomingVideoSubscriber) {
      [sharedInfo.incomingVideoSubscriber.view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
      [self addSubview:sharedInfo.incomingVideoSubscriber.view];
      self.initialized = true;
      NSLog(@"RCTOpenTokSubscriberView.initSubscriberView initialized");
    } else {
      NSLog(@"RCTOpenTokSubscriberView.initSubscriberView no subscriber");
    }
  } else {
    NSLog(@"RCTOpenTokSubscriberView.initSubscriberView already initialized");
  }
}

- (void)deinitSubscriberView {
  NSLog(@"RCTOpenTokSubscriberView.deinitSubscriberView");
  if (self.initialized) {
    RCTOpenTokSharedInfo *sharedInfo = [RCTOpenTokSharedInfo sharedInstance];
    if (sharedInfo.incomingVideoSubscriber) {
      [sharedInfo.incomingVideoSubscriber.view removeFromSuperview];
      self.initialized = false;
    } else {
      NSLog(@"RCTOpenTokSubscriberView.deinitSubscriberView no subscriber");
    }
  } else {
    NSLog(@"RCTOpenTokSubscriberView.deinitSubscriberView already deinitialized");
  }

}

- (void)dealloc {
    [self deinitSubscriberView];
}

@end
