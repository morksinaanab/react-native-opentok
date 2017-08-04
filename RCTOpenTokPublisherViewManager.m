/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTOpenTokPublisherViewManager.h"
#import "RCTOpenTokPublisherView.h"
#import "React/RCTComponent.h"

@implementation RCTOpenTokPublisherViewManager

- (UIView *)view {
    return [RCTOpenTokPublisherView new];
}

RCT_EXPORT_MODULE()


@end
