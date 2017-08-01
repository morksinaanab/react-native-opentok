/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "React/RCTBridgeModule.h"
#import "React/RCTEventDispatcher.h"
#import <OpenTok/OpenTok.h>
#import "RCTOpenTokPublisherView.h"
#import "RCTOpenTokSubscriberView.h"
#import "RCTOpenTokMessageHandler.h"

@interface RCTOpenTokSessionProvider : NSObject <OTSessionDelegate>

+ (id)sharedSession;

- (void)initSessionWithApiKey:(NSString *)apiKey sessionId:(NSString *)sessionId token:(NSString *)token;

@property OTSession *session;

@property RCTOpenTokPublisherView *publisherView;
@property RCTOpenTokSubscriberView *subscriberView;
@property RCTOpenTokMessageHandler *messageHandler;

@end
