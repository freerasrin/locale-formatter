/*
 * LocaleFormatter Plugin for Phonegap
 *
 * Copyright (c) 2016 Rajit Srinivas
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */
#import "LocaleFormatter.h"

NSString*const LOGGER = @"LocaleFormatter[native]";

@implementation LocaleFormatter
@synthesize debugEnabled;
@synthesize cordova_command;

/**************
 * Plugin API
 **************/

- (void) formatCurrency:(CDVInvokedUrlCommand*)command;
{
    self.cordova_command = command;
    
    
    @try {
        // Get JS arguments
        NSString* locale = [command.arguments objectAtIndex:0];
        NSNumber* amount = [command.arguments objectAtIndex:1];
        BOOL enableDebug = [[command argumentAtIndex:2] boolValue];
        
        if(enableDebug == TRUE){
            self.debugEnabled = enableDebug;
        }else{
            self.debugEnabled = FALSE;
        }
        
		if(locale == nil || amount == nil){
			[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Locale and amount cannot be null"] callbackId:self.cordova_command.callbackId];
			return;
		}
		
        [self logDebug:[NSString stringWithFormat:@"Called formatCurrency() with args: locale=%@; amount=%@", locale, amount]];
        
        //NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:amount];
		NSLocale *priceLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale]; 

		NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter setLocale:priceLocale];
		NSString *formattedCurrency = [currencyFormatter stringFromNumber:amount];
		NSLog(@"%@", formattedCurrency);
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:formattedCurrency];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		
    }@catch (NSException *exception) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason] callbackId:self.cordova_command.callbackId];
    }
    

}

- (void)logDebug: (NSString*)msg
{
    if(self.debugEnabled){
        NSLog(@"%@: %@", LOGGER, msg);
        NSString* jsString = [NSString stringWithFormat:@"console.log(\"%@: %@\")", LOGGER, [self escapeDoubleQuotes:msg]];
        [self executeGlobalJavascript:jsString];
    }
}

- (void)executeGlobalJavascript: (NSString*)jsString
{
    [self.commandDelegate evalJs:jsString];
    
}

- (NSString*)escapeDoubleQuotes: (NSString*)str
{
    NSString *result =[str stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
    return result;
}

@end