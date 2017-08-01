/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTOpenTokSessionProvider.h"
#import "React/RCTEventDispatcher.h"
#import <OpenTok/OpenTok.h>

@implementation RCTOpenTokSessionProvider


+ (id)sharedSession {
  static RCTOpenTokSessionProvider *sharedSessionInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedSessionInstance = [[self alloc] init];
  });
  return sharedSessionInstance;
}

- (void)initSessionWithApiKey:(NSString *)apiKey sessionId:(NSString *)sessionId token:(NSString *)token {
  if (!_session ) {
    _session = [[OTSession alloc] initWithApiKey:apiKey sessionId:sessionId delegate:self];
    
    OTError *error = nil;
    [_session connectWithToken:token error:&error];
    
    if (error) {
      NSLog(@"connect failed with error: (%@)", error);
    } else {
      NSLog(@"session created");
    }
  } else {
    NSLog(@"session was already created");
  }
}

# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session {
  NSLog(@"RCTOpenTokSessionProvider.sessionDidConnect");
  if (_publisherView) [_publisherView sessionDidConnect:session];
  if (_subscriberView) [_subscriberView sessionDidConnect:session];
}

- (void)sessionDidDisconnect:(OTSession*)session {
  NSLog(@"RCTOpenTokSessionProvider.sessionDidDisconnect");
  if (_publisherView) [_publisherView sessionDidDisconnect:session];
  if (_subscriberView) [_subscriberView sessionDidDisconnect:session];
}

- (void)session:(OTSession*)session streamCreated:(OTStream *)stream {
  NSLog(@"RCTOpenTokSessionProvider.streamCreated");
  if (_publisherView) [_publisherView session:session streamCreated:stream];
  if (_subscriberView) [_subscriberView session:session streamCreated:stream];
}

- (void)session:(OTSession*)session streamDestroyed:(OTStream *)stream {
  NSLog(@"RCTOpenTokSessionProvider.streamDestroyed");
  if (_publisherView) [_publisherView session:session streamDestroyed:stream];
  if (_subscriberView) [_subscriberView session:session streamDestroyed:stream];
}

- (void)session:(OTSession*)session connectionCreated:(OTConnection *)connection {
  NSLog(@"RCTOpenTokSessionProvider.connectionCreated");
  if (_publisherView) [_publisherView session:session connectionCreated:connection];
  if (_subscriberView) [_subscriberView session:session connectionCreated:connection];
}

- (void)session:(OTSession*)session connectionDestroyed:(OTConnection *)connection{
  NSLog(@"RCTOpenTokSessionProvider.connectionDestroyed");
  if (_publisherView) [_publisherView session:session connectionDestroyed:connection];
  if (_subscriberView) [_subscriberView session:session connectionDestroyed:connection];

}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
  NSLog(@"RCTOpenTokSessionHandler.didFailWithError");
  if (_publisherView) [_publisherView session:session didFailWithError:error];
  if (_subscriberView) [_subscriberView session:session didFailWithError:error];
}

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
  NSLog(@"RCTOpenTokSessionHandler.receivedSignalType");
  if (_messageHandler) [_messageHandler session:session receivedSignalType:type fromConnection:connection withString:string];
}

@end
