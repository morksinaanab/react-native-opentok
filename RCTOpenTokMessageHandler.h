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

@interface RCTOpenTokMessageHandler : NSObject <RCTBridgeModule>

@property OTSession *session;

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string;

@end
