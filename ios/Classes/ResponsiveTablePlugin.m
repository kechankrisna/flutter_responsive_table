#import "ResponsiveTablePlugin.h"
#if __has_include(<responsive_table/responsive_table-Swift.h>)
#import <responsive_table/responsive_table-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "responsive_table-Swift.h"
#endif

@implementation ResponsiveTablePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftResponsiveTablePlugin registerWithRegistrar:registrar];
}
@end
