/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTOpenTokMessageHandler.h"
#import "React/RCTEventDispatcher.h"
#import "RCTOpenTokSessionProvider.h"
#import <OpenTok/OpenTok.h>

@implementation RCTOpenTokMessageHandler {
  OTSession *_session;
}

@synthesize bridge = _bridge;


- (void)initSessionWithApiKey:(NSString *)apiKey sessionId:(NSString *)sessionId token:(NSString *)token {
  RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
  [sessionManager initSessionWithApiKey:apiKey sessionId:sessionId token:token];
  sessionManager.messageHandler = self;
  _session = [sessionManager session];
  NSLog(@"RCTOpenTokMessageHandler session %@",_session);
  
}

- (void) sendSessionMessage:(NSString*)message {
  OTError* error = nil;
  RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
  _session = [sessionManager session];
  
  NSLog(@"sendSessionMessage %@ %@", message,_session);
  
  [_session signalWithType:@"message" string:message connection:nil error:&error];
  if (error) {
    NSLog(@"signal error %@", error);
  } else {
    NSLog(@"signal sent");
  }
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(connect:(NSString *)apiKey sessionId:(NSString *)sessionId token:(NSString *)token)
{
  [self initSessionWithApiKey:apiKey sessionId:sessionId token:token];
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)message)
{
  [self sendSessionMessage:message];
}

#pragma mark handle session messaging - direct delegates

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
    NSLog(@"Received signal %@ %@ %@", type,string, session);
    [self onMessageReceived:string data:connection.data];
}

- (void)onMessageReceived:(NSString *)message data:(NSString *)data
{
  NSLog(@"RCTOpenTokSessionManager.onMessageReceived: %@ %@",message,data);
  [self.bridge.eventDispatcher sendAppEventWithName:@"onMessageReceived"
    body:message];
}

@end
