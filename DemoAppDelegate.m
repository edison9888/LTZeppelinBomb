#import "AppDelegate.h"
#import "LTZeppelinBomb.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  
  [[LTZeppelinBomb theHugest] dropABombOnMe:@"DemoApp"
                              zeppelinURI:@"http://tokens.example.com/new"
                                 isADrill:YES];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [[ZeppelinBomb theHugest] confirmMyPosition:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  [[ZeppelinBomb theHugest] outOfRange:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  [[ZeppelinBomb theHugest] disposeTheBomb:userInfo
                                   succeed:^(NSDictionary* bomb){
                                     NSString *alert = [bomb objectForKey:@"body"];
                                     if (alert != nil)
                                     {
                                       NSString *reg = @"New version";
                                       NSRange r = [alert rangeOfString:reg];
                                       if (r.location != NSNotFound)
                                       {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"A new version is available!"
                                                                                             message:alert
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"Not now"
                                                                                   otherButtonTitles:@"Update", nil];
                                         [alertView show];
                                       }
                                       NSNumber *badge = [bomb objectForKey:@"badge"];
                                       if (badge != nil && [badge intValue] > 0)
                                       {
                                         [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                                       }
                                     }
                                   }
                                    failed:^(NSDictionary* bomb){
                                      
                                    }];
}

#pragma mark - Alert delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    NSURL *appURL = [NSURL URLWithString:@"http://itunes.apple.com/cn/app//id488116020?mt=8"];
    [[UIApplication sharedApplication] openURL:appURL];
  }
}

@end
