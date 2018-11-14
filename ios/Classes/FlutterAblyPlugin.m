#import "FlutterAblyPlugin.h"
#import <flutter_ably/flutter_ably-Swift.h>

@implementation FlutterAblyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAblyPlugin registerWithRegistrar:registrar];
}
@end
