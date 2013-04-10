#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface TumblrSDKAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (TumblrSDKAPIClient *)sharedClient;

@end
