

#import <Foundation/Foundation.h>
#import "GRHTTPClient.h"

typedef void (^GRNetworkResultsControllerFailureBlock)(NSError *error);
typedef void (^GRNetworkResultsControllerSuccessBlock)(void);

@interface GRNetworkResultsController : NSObject

@property (nonatomic, strong) GRHTTPClient *httpClient;


@end
